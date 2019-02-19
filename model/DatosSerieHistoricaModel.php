<?php
use Luracast\Restler\RestException;
use League\Csv\Reader;
require_once('./helper/Connection.php');
require_once('IndicadoresModel.php');

class DatosSerieHistoricaModel
{
    private $db;
    private $lastError;

    function __construct ()
    {
        $this->pdo = Connection::get()->connect();
    }
    function get ($id, $nivel)
    {
        $stmt = $this->pdo->prepare('SELECT *
                                       FROM banco_indicadores.tbl_serie_historica
                                      WHERE id_indicador = ?
                                      AND id_nivel_territorial = ?
                                        ORDER BY año');
        // bind value to the :id parameter
        $stmt->execute([$id, $nivel]);
        // execute the statement
        $items = [];
        while ($row = $stmt->fetch(\PDO::FETCH_ASSOC)) {
            $resultItem = [
                "id_indicador" => $row["id_indicador"],
                "ano" => $row['año'],
                "id_departamento" => $row['id_departamento'],
                "id_municipio" => $row['id_municipio'],
                "id_poblado" => $row['id_poblado'],
                "id_departamento" => $row['id_departamento'],
                "valor_relativo" =>$row["valor_relativo"],
                "valor_absoluto" =>$row["valor_absoluto"]
            ];
            $items[] = $resultItem;
        }
        return $items;
 
        // return the result set as an object
        //return $stmt->fetchObject();
    }

    function getAll ()
    {
        $stmt = $this->pdo->query('SELECT * from banco_indicadores.tbl_serie_historica');
        $items = [];
        while ($row = $stmt->fetch(\PDO::FETCH_ASSOC)) {
            $resultItem = [
                "id_indicador" => $row["id_indicador"],
                "ano" => $row['año'],
                "id_departamento" => $row['id_departamento'],
                "id_municipio" => $row['id_municipio'],
                "id_poblado" => $row['id_poblado'],
                "id_departamento" => $row['id_departamento'],
                "valor_relativo" =>$row["valor_relativo"],
                "valor_absoluto" =>$row["valor_absoluto"]
            ];
            $items[] = $resultItem;
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
            $rowCount = $this->validateRows($records, $rec['nivelId']);
            return ['success' => $rowCount['success'] > 0, 'successCount' => $rowCount['success'], 'errorCount' => $rowCount['error']];
        } else {

            $records = $this->cleanupRows($records, $rec["nivelId"]);
            $this->pdo->beginTransaction(); // also helps speed up your inserts.
            $insert_values = array();
            if(!empty($rec['reemplazar']) && $rec['reemplazar'] == 1){
                $delStmt = $this->pdo->prepare("DELETE FROM banco_indicadores.tbl_serie_historica WHERE id_indicador = ? AND id_nivel_territorial = ?");
                $delStmt->execute([$idIndicador, $rec['nivelId']]); 
            }
            foreach($records as $d){
                $question_marks[] = '('  . $this->placeholders('?', 8) . ')';
                $dataToInsert = [
                    "id_indicador" => $idIndicador,
                    "id_nivel_territorial" => $rec['nivelId'],
                    "año" => intval(trim($d[0])),
                    "id_departamento" => $rec["nivelId"] == 1 && intval(trim($d[1])) > 0 ? intval(trim($d[1])) : PDO::PARAM_NULL,
                    "id_municipio" => $rec["nivelId"] == 2 && intval($d[2]) > 0 ? intval(trim($d[2])) : PDO::PARAM_NULL,
                    "id_poblado" => $rec["nivelId"] == 3 && intval($d[3]) > 0 ? intval($d[3]) : PDO::PARAM_NULL,
                    "valor_relativo" => floatval($d[4]) > 0 ? floatval($d[4]) : PDO::PARAM_NULL,
                    "valor_absoluto" => floatval($d[5]) > 0 ? floatval($d[5]) : PDO::PARAM_NULL
                ];
                $insert_values = array_merge($insert_values, array_values($dataToInsert));
            }
            $datafields = array_merge(["id_indicador", "id_nivel_territorial","año","id_departamento","id_municipio","id_poblado","valor_relativo","valor_absoluto"]);
            $sql = "INSERT INTO banco_indicadores.tbl_serie_historica(" . implode(",", $datafields ) . ") VALUES " . implode(',', $question_marks);
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

    private function validateRows($rows, $nivel){
        $successCount = 0;
        $errorCount = 0;
        foreach($rows as $r){
            if(!$this->validateRow($r, $nivel)){
                $errorCount+= 1;
            } else {
                $successCount+=1;
            }
        }
        return ["success" => $successCount, "error" => $errorCount];
    }

    private function cleanupRows($rows, $nivel){
        $result = [];
        foreach($rows as $r){
            if($this->validateRow($r, $nivel)){
                $result[] = $r;
            }
        }
        return $result;
    }

    private function validateRow($r, $nivel){
        $colToCheck = $nivel;
        //Si esta llena la casilla correcta de lugar dependiendo del nivel
        if(!empty($r[$colToCheck]) && intval($r[$colToCheck]) > 0){
            //Si esta vacio val_abs y val_rel
            if(floatval($r[4]) == 0 || floatval($r[5]) == 0){
                return false;
            }
            //Verificamos el año
        } else if(intval($r[0]) == 0) {
            return false;
        }
        return true;
    }

    private function validateHeaders($header, $idIndicador){
        if(count($header) < 6){
            $this->lastError = "Las columnas son incorrectas. Revise e intente de nuevo";
            return false;
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