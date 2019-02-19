<?php
use Luracast\Restler\RestException;
use League\Csv\Reader;
require_once('./helper/Connection.php');
require_once('IndicadoresModel.php');

class DatosLineaBaseModel
{
    private $db;
    private $lastError;

    function __construct ()
    {
        $this->pdo = Connection::get()->connect();
        $this->lbm = new IndicadoresModel();
    }
    function get ($id, $nivel)
    {
        $stmt = $this->pdo->prepare('SELECT *
                                       FROM banco_indicadores.tbl_linea_base_datos
                                      WHERE id_indicador = ?
                                      AND id_nivel_territorial = ?');
        $lb = $this->lbm->getLineaBase($id);
        // bind value to the :id parameter
        $stmt->execute([$id, $nivel]);
        // execute the statement
        $items = [];
        while ($row = $stmt->fetch(\PDO::FETCH_ASSOC)) {
            $resultItem = [
                "id_indicador" => $row["id_indicador"],
                "id_linea_base" => $row["id_linea_base"],
                "ano" => $row['año'],
                "id_departamento" => $row['id_departamento'],
                "id_municipio" => $row['id_municipio'],
                "id_poblado" => $row['id_poblado'],
                "id_departamento" => $row['id_departamento'],
                "valor_relativo" =>$row["valor_relativo"],
                "valor_absoluto" =>$row["valor_absoluto"]
            ];
            $columnas = json_decode($row["columnas"], true);
            $columnas = $columnas["columnas"];
            $variables = json_decode(json_encode($lb->variables), true);
            foreach($variables["variables"] as $k => $v){
                $resultItem[$v['inicial']] = !empty($columnas[$k]) ? $columnas[$k] : null;
            }
            $items[] = $resultItem;
        }
        return $items;
 
        // return the result set as an object
        //return $stmt->fetchObject();
    }

    function getAll ()
    {
        $stmt = $this->pdo->query('SELECT * from banco_indicadores.tbl_linea_base_datos');
        $items = [];
        while ($row = $stmt->fetch(\PDO::FETCH_ASSOC)) {
            $items[] = [
                "id_indicador" => $row["id_indicador"],
                "id_linea_base" => $row["id_linea_base"],
                "año" => $row['año'],
                "valor_relativo" =>$row[""]
            ];
        }
        return $items;
    }

    function insert ($rec)
    {
        $csv = Reader::createFromPath($rec['excel']['tmp_name'], 'r');
        $header = $csv->fetchOne();
        $records = $csv->setOffset(1)->fetchAll();
        $idIndicador = $rec['indicadorId'];
        if(!$this->validateHeaders($header, $idIndicador)){
            return ["success" => false, "errors" => [
                "encabezadosError" => $this->lastError
            ]];    
        } else if($rec["dirty"] == 1){
            $rowCount = $this->validateRows($records, $rec['nivelId'], $header);
            return ['success' => $rowCount['success'] > 0, 'successCount' => $rowCount['success'], 'errorCount' => $rowCount['error']];
        } else {
            /*
            AQUI ES QUE TENEMOS QUE HACER EL CAMBIO DE GUARDAR EL ARCHIVO EN UNA CARPETA Y 
            CREAR UN REGISTRO EN LA TABLA tbl_linea_base_datos_carga
                id_linea_base
                nombre_archivo
                operacion ('carga'|'reemplazo')
                filas_validas
                filas_no_validas
                usuario_creacion
                fecha_creacion
            */
            $records = $this->cleanupRows($records, $rec["nivelId"], $header);
            $this->pdo->beginTransaction(); // also helps speed up your inserts.
            $insert_values = array();
            if(!empty($rec['reemplazar']) && $rec['reemplazar'] == 1){
                $delStmt = $this->pdo->prepare("DELETE FROM banco_indicadores.tbl_linea_base_datos WHERE id_indicador = ? AND id_nivel_territorial = ?");
                $delStmt->execute([$idIndicador, $rec['nivelId']]); 
            }
            foreach($records as $d){
                $question_marks[] = '('  . $this->placeholders('?', 10) . ')';
                $countOptHeaders = count(array_slice($header, 5));
                $lb = $this->lbm->getLineaBase($idIndicador);
                $dataToInsert = [
                    "id_linea_base" => $lb->id,
                    "id_indicador" => $idIndicador,
                    "id_nivel_territorial" => $rec['nivelId'],
                    "año" => $lb->año,
                    "id_departamento" => $rec["nivelId"] == 1 && intval($d[0]) > 0 ? intval($d[0]) : PDO::PARAM_NULL,
                    "id_municipio" => $rec["nivelId"] == 2 && intval($d[1]) > 0 ? intval($d[1]) : PDO::PARAM_NULL,
                    "id_poblado" => $rec["nivelId"] == 3 && intval($d[2]) > 0 ? intval($d[2]) : PDO::PARAM_NULL,
                    "valor_relativo" => floatval($d[3]) > 0 ? floatval($d[3]) : PDO::PARAM_NULL,
                    "valor_absoluto" => floatval($d[4]) > 0 ? floatval($d[4]) : PDO::PARAM_NULL,
                    "columnas" => json_encode(["columnas" => array_slice($d, 5)])
                ];
                $insert_values = array_merge($insert_values, array_values($dataToInsert));
            }
            $datafields = array_merge(["id_linea_base", "id_indicador", "id_nivel_territorial", "año"], array_slice($header,0, 5),["columnas"]);
            $sql = "INSERT INTO banco_indicadores.tbl_linea_base_datos(" . implode(",", $datafields ) . ") VALUES " . implode(',', $question_marks);
                //echo $sql;
                //print_r($insert_values);
            $stmt = $this->pdo->prepare($sql);
            try {
                $stmt->execute($insert_values);
            } catch (PDOException $e){
                $this->pdo->rollBack();
                throw new RestException(500, $e->getMessage());
            }
            $this->pdo->commit();
            return ["success" => true, "inserted" => count($records)];
        }
    }

    private function placeholders($text, $count=0, $separator=","){
        $result = array();
        if($count > 0){
            for($x=0; $x<$count; $x++){
                $result[] = $text;
            }
        }
    
        return implode($separator, $result);
    }

    private function validateRows($rows, $nivel, $headers){
        $successCount = 0;
        $errorCount = 0;
        $optHeaders = array_slice($headers, 5);
        foreach($rows as $r){
            if(!$this->validateRow($r, $nivel, $optHeaders)){
                $errorCount+= 1;
            } else {
                $successCount+=1;
            }
        }
        return ["success" => $successCount, "error" => $errorCount];
    }

    private function cleanupRows($rows, $nivel, $headers){
        $result = [];
        $optHeaders = array_slice($headers, 5);
        foreach($rows as $r){
            if($this->validateRow($r, $nivel, $optHeaders)){
                $result[] = $r;
            }
        }
        return $result;
    }

    private function validateRow($r, $nivel, $optHeaders){
        $colToCheck = $nivel - 1;
        //Si esta llena la casilla correcta de lugar dependiendo del nivel
        if(!empty($r[$colToCheck]) && intval($r[$colToCheck]) > 0){
            //Si esta vacio val_abs y val_rel
            if(empty($r[3]) && empty($r[4])){
                for($i = 0; count($optHeaders) > $i; $i++){
                    $toCheck = $r[5 + $i];
                    //Validamos que sean valores float no vacios
                    if(empty($toCheck) || floatval($toCheck) == 0){
                        return false;
                    }
                }
            } else {
                //Validamos que sean valores float
                if(floatval($r[3]) == 0 || floatval($r[4]) == 0){
                    return false;
                }
            }
        } else {
            return false;
        }
        return true;
    }

    private function validateHeaders($header, $idIndicador){
        $reqHeaders =  array_slice($header, 0, 5);
        $optHeaders = array_slice($header, 5);
        if(count($header) < 5){
            $this->lastError = "Las columnas son incorrectas. Revise e intente de nuevo";
            return false;
        } else {
            $lineaBase = $this->lbm->getLineaBase($idIndicador);
            if(empty($lineaBase)){
                $this->lastError = "No existe linea base";
                return false;
            } else {
                $variables = json_decode(json_encode($lineaBase->variables),true);
                $variables = $variables["variables"]; 
                $columnas = array_map(function($item){
                    return $item["inicial"];
                }, $variables);
                foreach($columnas as $c){
                    if(!in_array($c, $optHeaders)){
                        $this->lastError = "La columna $c no encontrada";
                        return false;
                    }
                }
            }  
        }
        return true;
    }
/*
    function update ($id, $rec)
    {
        return $this->get($id);
    }
    function delete ($id)
    {
        $r = $this->get($id);
        if (!$r || !$this->db->prepare('DELETE FROM authors WHERE id = ?')->execute(array($id)))
            return FALSE;
        return $r;
    }
    private function id2int ($r)
    {
        if (is_array($r)) {
            if (isset($r['id'])) {
                $r['id'] = intval($r['id']);
            } else {
                foreach ($r as &$r0) {
                    $r0['id'] = intval($r0['id']);
                }
            }
        }
        return $r;
    }
    private function install ()
    {
        $this->db->exec(
        "CREATE TABLE authors(
            'id' INTEGER PRIMARY KEY AUTOINCREMENT,
            'name' TEXT,
            'email' TEXT
        )");
        $this->db->exec(
        "INSERT INTO authors (name, email) VALUES ('Jac Wright', 'jacwright@gmail.com');
         INSERT INTO authors (name, email) VALUES ('Arul Kumaran', 'arul@luracast.com');
        ");
    }
    */
}