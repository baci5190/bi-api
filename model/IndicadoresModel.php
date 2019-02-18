<?php
use Luracast\Restler\RestException;
require_once('./helper/Connection.php');
require_once('./model/NivelesTerritorialesModel.php');
require_once('./model/UnidadesMedidaModel.php');

class IndicadoresModel
{
    private $db;
    function __construct ()
    {
        $this->pdo = Connection::get()->connect();
        $this->niveles = new NivelesTerritorialesModel();
        $this->unidades = new UnidadesMedidaModel();
    }
    function get ($id)
    {
        // prepare SELECT statement
        $stmt = $this->pdo->prepare("SELECT *
                                       FROM banco_indicadores.tbl_indicador
                                      WHERE id = :id
                                      AND habilitado = 't'");
        // bind value to the :id parameter
        $stmt->bindValue(':id', $id);
        
        // execute the statement
        $stmt->execute();
 
        // return the result set as an object
        return $stmt->fetchObject();
    }

    function getFichaTecnica($id){
        $indicador = $this->get($id);
        $lineaBase = $this->getLineaBase($id);
        $result = [];
        if(!empty($indicador)){
            $result['codigo'] = $indicador->codigo;
            $result['nombre'] = sprintf("%s de %s", $indicador->denominacion, $indicador->complemento);
            $result['tipo_indicador'] = $indicador->tipo_indicador;
            $result['definicion'] = "";
            $criterios = json_decode($indicador->criterio_indicador);
            foreach($criterios->criterios as $k => $v){
                $result['definicion'].= sprintf("%s. ", $v);
            }
            $result['definicion'] = trim($result['definicion']);
            $result["anio_linea_base"] = $lineaBase ? $lineaBase->año : "";
            $result["niveles_territoriales"] = "";
            if($lineaBase){
                foreach($lineaBase->niveles_territoriales as $n){
                    $nivel = $this->niveles->get($n);
                    $result["niveles_territoriales"].= sprintf("%s\n", $nivel->tipo_nivel);
                }
                $result["niveles_territoriales"] = trim($result["niveles_territoriales"]);
                $unidadMedidaValorAbs = $this->unidades->get($lineaBase->id_unid_med_valor_absoluto);
                $unidadMedidaValorRel = $this->unidades->get($lineaBase->id_unid_med_valor_relativo);
                $result["unidad_medida_valor_relativo"] = $unidadMedidaValorRel->descripcion;
                $result["unidad_medida_valor_absoluto"] = $unidadMedidaValorAbs->descripcion;
                $result["valor_relativo_linea_base"] = number_format($lineaBase->valor_relativo,2);
                $result["valor_absoluto_linea_base"] = number_format($lineaBase->valor_absoluto,2);
                $result["metodo_calculo_abreviado"] = $lineaBase->formula;
                $metodoCalculo = $lineaBase->formula;
                foreach($lineaBase->variables as $v){
                    //str_replace($metodoCalculo, new RegExp(sprintf("%s\g")$v->inicial))
                }
            }
        }
        return $result;
    }

    function getAll ()
    {
        $tipo = isset($_GET['tipo_resultado']) ? $_GET['tipo_resultado'] : "";
        $query = "SELECT * from banco_indicadores.tbl_indicador WHERE habilitado = 't'";
        if(!is_not_set_or_empty($tipo)){
            $query.= sprintf(" AND tipo_resultado='%s'", $tipo);
        }
        $stmt = $this->pdo->query($query);
        $indicadores = [];
        while ($row = $stmt->fetch(\PDO::FETCH_ASSOC)) {
            $newItem = [
                'id' => $row['id'],
                'codigo' => $row['codigo'],
                'denominacion' => $row['denominacion'],
                'complemento' => $row['complemento'],
                'tipo_resultado' => $row['tipo_resultado'],
                'id_resultado_originador' => $row['id_resultado_originador'],
                'tipo_indicador' => $row['tipo_indicador'],
                'criterio_indicador' => $row['criterio_indicador'],
                'estado' => $row['estado'],
                'observaciones' => json_decode($row['observaciones'])
            ];
            $criterios = json_decode($row['criterio_indicador'], true);
            if(count($criterios) > 0){
                $newItem['criterios'] = $criterios['criterios'];
            } else {
                $newItem['criterios'] = [];
            }
            $indicadores[] = $newItem;
        }
        return $indicadores;
    }

    function insert ($rec)
    {
        //print_r($rec);
        try {
            $id = intval($rec['id']);
            if(!empty($id)){
                //echo "IS UPDATE";
                $sql = 'UPDATE banco_indicadores.tbl_indicador SET
                    denominacion = :denominacion, 
                    complemento = :complemento, 
                    id_resultado_originador = :id_resultado_originador, 
                    tipo_indicador = :tipo_indicador, 
                    criterio_indicador = :criterio_indicador, 
                    estado = :estado
                    WHERE id=:id';
            } else {
                //echo "IS INSERT";
                $sql = 'INSERT INTO banco_indicadores.tbl_indicador(
                    codigo, 
                    denominacion, 
                    complemento, 
                    id_resultado_originador, 
                    tipo_indicador, 
                    criterio_indicador, 
                    creado,
                    creado_por, 
                    observaciones,
                    estado, 
                    tipo_resultado
                    ) VALUES (
                        :codigo, 
                        :denominacion, 
                        :complemento, 
                        :id_resultado_originador, 
                        :tipo_indicador, 
                        :criterio_indicador, 
                        :creado, 
                        :creado_por, 
                        :observaciones,
                        :estado, 
                        :tipo_resultado
                    )';
            }
            
            $stmt = $this->pdo->prepare($sql);
            $date = new DateTime();
            if(empty($id)){
                $stmt->bindValue(':codigo',$this->getCodigo($rec['tipo_resultado']));
                $stmt->bindValue(':tipo_resultado',$rec['tipo_resultado']);
                $stmt->bindValue(':creado',$date->format(DATE_ATOM));
                $stmt->bindValue(':creado_por',$rec['creado_por']);
                $stmt->bindValue(':observaciones',"{}");
            }
            $stmt->bindValue(':denominacion',$rec['denominacion']);
            $stmt->bindValue(':complemento',$rec['complemento']);
            $stmt->bindValue(':id_resultado_originador',$rec['id_resultado_originador']);
            $stmt->bindValue(':tipo_indicador',$rec['tipo_indicador']);
            $stmt->bindValue(':criterio_indicador',$rec['criterio_indicador']);
            $stmt->bindValue(':estado',$rec['estado']);
            if(!empty($id)){
                $stmt->bindValue(':id', $rec['id']);
            }
            $stmt->execute();

            if(empty($id)){
                $id =  $this->pdo->lastInsertId('banco_indicadores.tbl_indicador_id_seq');
            } else {
                $id = $rec['id'];
            }
            return ['id' => $id];
        } catch (Exception $e){
            $err = "";
            foreach($stmt->errorInfo() as $d){
                $err.=$d;
            }
            throw new RestException(400, $err);
        }
    }

    private function getCodigo($tipo_resultado){
        // prepare SELECT statement
        $stmt = $this->pdo->prepare("SELECT max(codigo) codigo
                                       FROM banco_indicadores.tbl_indicador
                                      WHERE tipo_resultado = :tipo_resultado");
        // bind value to the :id parameter
        $stmt->bindValue(':tipo_resultado', $tipo_resultado);
        
        // execute the statement
        $stmt->execute();
 
        // return the result set as an object
        $lastIndicador = $stmt->fetchObject();
        //print_r($lastIndicador);
        $seed = 0;
        if(empty($lastIndicador)){
            $seed = 1;
        } else {
            $seed = intval(preg_replace("/[^0-9,.]/", "", $lastIndicador->codigo));
        }
        switch($tipo_resultado){
            case "Resultado Final":
                return "IM" . str_pad("", 4 - strlen(strval($seed + 1)), "0") . strval($seed + 1);
            case "Resultado Intermedio":
                return "RE" . str_pad("", 4 - strlen(strval($seed + 1)), "0") . strval($seed + 1);
            default:
                return "PR" . str_pad("", 4 - strlen(strval($seed + 1)), "0") . strval($seed + 1);
        }
    }

    function update ($id, $rec)
    {
        return $this->get($id);
    }

    function delete ($id)
    {
        $r = $this->get($id);
        if (!$r || !$this->pdo->prepare("UPDATE banco_indicadores.tbl_indicador SET habilitado =  'f' WHERE id = ?")->execute(array($id)))
            return FALSE;
        return $r;
    }

    /**
     * GET indicadores/lineabase/{id}
     *
     * @param int       $id map to url
     * @return string
     */
    function getLineaBase($id){
        $query = "SELECT * FROM banco_indicadores.tbl_linea_base WHERE id_indicador=:id";
        $stmt = $this->pdo->prepare($query);
        $stmt->bindValue(':id', $id);
        $stmt->execute();
        $obj = $stmt->fetchObject();
        if(!$obj) return false;

        if(!is_not_set_or_empty($obj->niveles_territoriales)){
            
            $obj->niveles_territoriales = explode(",",preg_replace('/[{}]/', "", $obj->niveles_territoriales));
        }
        $obj->variables = json_decode($obj->variables);
        return $obj;
    }

    /**
     * POST indicadores/lineabase/{id}
     *
     * @param int       $id map to url
     * @return string
     */
    function insertLineaBase ($rec)
    {
        $id = !isset($rec['id']) ? 0 : intval($rec['id']);
        if(!is_not_set_or_empty($id) && $id != 0){
            $sql = sprintf('
                UPDATE banco_indicadores.tbl_linea_base SET
                    id_indicador = :id_indicador, 
                    año = :ano, 
                    valor_relativo = :valor_relativo, 
                    valor_absoluto = :valor_absoluto, 
                    niveles_territoriales = :niveles_territoriales, 
                    id_unid_med_valor_absoluto = :id_unid_med_valor_absoluto, 
                    id_unid_med_valor_relativo = :id_unid_med_valor_relativo,
                    variables = :variables, 
                    formula = :formula,
                    resultado = :resultado,
                    sentido_esperado = :sentido_esperado
                WHERE id=%s', $id);
        } else {
            $sql = 'INSERT INTO banco_indicadores.tbl_linea_base (
                id_indicador, 
                año, 
                valor_relativo, 
                valor_absoluto, 
                niveles_territoriales, 
                id_unid_med_valor_absoluto, 
                id_unid_med_valor_relativo,
                variables, 
                formula,
                resultado,
                sentido_esperado
                ) VALUES (
                    :id_indicador, 
                    :ano, 
                    :valor_relativo, 
                    :valor_absoluto, 
                    :niveles_territoriales, 
                    :id_unid_med_valor_absoluto, 
                    :id_unid_med_valor_relativo,
                    :variables, 
                    :formula,
                    :resultado,
                    :sentido_esperado
                )';
        }
        try {     
                
            $stmt = $this->pdo->prepare($sql);
            $stmt->bindValue(':id_indicador',intval($rec['id_indicador']));
            $stmt->bindValue(':ano',intval($rec['ano']));
            $stmt->bindValue(':valor_relativo',floatval($rec['valor_relativo']));
            $stmt->bindValue(':valor_absoluto',floatval($rec['valor_absoluto']));
            $stmt->bindValue(':id_unid_med_valor_absoluto',intval($rec['id_unid_med_valor_absoluto']));
            $stmt->bindValue(':id_unid_med_valor_relativo',intval($rec['id_unid_med_valor_relativo']));
            $stmt->bindValue(':formula',$rec['formula']);
            $stmt->bindValue(':resultado',$rec['resultado']);
            $stmt->bindValue(':sentido_esperado',$rec['sentido_esperado']);

            $stmt->bindValue(':variables',$rec['variables']);
            $stmt->bindValue(':niveles_territoriales',$rec['niveles_territoriales']);

            $stmt->execute();

            if($id == 0){
                $id =  $this->pdo->lastInsertId('banco_indicadores.tbl_linea_base_id_seq');
            }
            return ['id' => $id, 'success' => true];
            
        } catch (Exception $e){
            $err = "";
            foreach($stmt->errorInfo() as $d){
                $err.=$d;
            }
            throw new RestException(400, $e->getTraceAsString());
        }
        
    }

    /**
     * GET indicadores/referenciabibliografica/{id}
     *
     * @param int       $id map to url
     * @return string
     */
    function getReferenciaBibliografica($id){
        $query = "SELECT * FROM banco_indicadores.tbl_referencia_bibliografica WHERE id_indicador=:id";
        $stmt = $this->pdo->prepare($query);
        $stmt->bindValue(':id', $id);
        $stmt->execute();
        $obj = $stmt->fetchObject();
        if(!$obj) return false;
        return $obj;
    }

    /**
     * POST indicadores/referenciabibliografica/{id}
     *
     * @param int       $id map to url
     * @return string
     */
    function insertReferenciaBibliografica ($rec)
    {
        $id = !isset($rec['id']) ? 0 : intval($rec['id']);
        if(!is_not_set_or_empty($id) && $id != 0){
            $sql = sprintf('
                UPDATE banco_indicadores.tbl_referencia_bibliografica SET
                    autor_institucional_nombre = :autor_institucional_nombre, 
                    autor_nombre = :autor_nombre, 
                    autor_iniciales = :autor_iniciales, 
                    titulo = :titulo, 
                    nombre_editorial = :nombre_editorial, 
                    año_publicacion = :ano_publicacion,
                    ciudad_publicacion = :ciudad_publicacion, 
                    pais_publicacion = :pais_publicacion
                WHERE id=%s', $id);
        } else {
            $sql = 'INSERT INTO banco_indicadores.tbl_referencia_bibliografica (
                id_indicador, 
                autor_institucional_nombre, 
                autor_nombre, 
                autor_iniciales, 
                titulo, 
                nombre_editorial, 
                año_publicacion,
                ciudad_publicacion, 
                pais_publicacion
                ) VALUES (
                    :id_indicador, 
                    :autor_institucional_nombre, 
                    :autor_nombre, 
                    :autor_iniciales, 
                    :titulo, 
                    :nombre_editorial, 
                    :ano_publicacion,
                    :ciudad_publicacion, 
                    :pais_publicacion
                )';
        }
        try {   
            $stmt = $this->pdo->prepare($sql);
            if($id == 0){
                $stmt->bindValue(':id_indicador',$rec['id_indicador']);
            } 
            $stmt->bindValue(':autor_institucional_nombre',$rec['autor_institucional_nombre']);
            $stmt->bindValue(':autor_nombre',$rec['autor_nombre']);
            $stmt->bindValue(':autor_iniciales',$rec['autor_iniciales']);
            $stmt->bindValue(':titulo',$rec['titulo']);
            $stmt->bindValue(':nombre_editorial',$rec['nombre_editorial']);
            $stmt->bindValue(':ano_publicacion',intval($rec['ano_publicacion']));
            $stmt->bindValue(':ciudad_publicacion',$rec['ciudad_publicacion']);
            $stmt->bindValue(':pais_publicacion',$rec['pais_publicacion']);



            $stmt->execute();
            
            if($id == 0){
                $id =  $this->pdo->lastInsertId('banco_indicadores.tbl_referencia_bibliografica_id_seq');
            }
            return ['id' => $id, 'success' => true];
            
        } catch (Exception $e){
            $err = "";
            foreach($stmt->errorInfo() as $d){
                $err.=$d;
            }
            throw new RestException(400, $e->getTraceAsString().":".$err);
        }
    }

    /**
     * GET indicadores/datoscomplementarios/{id}
     *
     * @param int       $id map to url
     * @return string
     */
    function getDatosComplementarios($id){
        $query = "SELECT * FROM banco_indicadores.tbl_indicador_datos_complementarios WHERE id_indicador=:id";
        $stmt = $this->pdo->prepare($query);
        $stmt->bindValue(':id', $id);
        $stmt->execute();
        $obj = $stmt->fetchObject();
        if(!$obj) return false;

        if(!is_not_set_or_empty($obj->instrumentos_planificacion)){
            /*
            $obj->fecha_elaboracion = DateTime::createFromFormat('Y-m-d H:i:s', $obj->fecha_elaboracion)->format("d/m/Y");
            $obj->fecha_actualizacion = DateTime::createFromFormat('Y-m-d H:i:s', $obj->fecha_actualizacion)->format("d/m/Y");
            $obj->fecha_esperada_actualizacion = DateTime::createFromFormat('Y-m-d H:i:s', $obj->fecha_esperada_actualizacion)->format("d/m/Y");
            */
            $obj->instrumentos_planificacion = explode(",",preg_replace('/[{}]/', "", $obj->instrumentos_planificacion));
                
        }
        return $obj;
    }

    /**
     * POST indicadores/datoscomplementarios/{id}
     *
     * @param int       $id map to url
     * @return string
     */
    function insertDatosComplementarios ($rec)
    {
        $id = !isset($rec['id']) ? 0 : intval($rec['id']);
        if(!is_not_set_or_empty($id) && $id != 0){
            $sql = sprintf('
                UPDATE banco_indicadores.tbl_indicador_datos_complementarios SET
                    autor = :autor, 
                    id_tipo_fuente = :id_tipo_fuente, 
                    frecuencia = :frecuencia, 
                    formato_sistematizacion = :formato_sistematizacion, 
                    instrumentos_planificacion = :instrumentos_planificacion,
                    fecha_elaboracion = :fecha_elaboracion,
                    fecha_actualizacion = :fecha_actualizacion, 
                    fecha_esperada_actualizacion = :fecha_esperada_actualizacion,
                    institucion_estimacion = :institucion_estimacion,
                    institucion_seguimiento = :institucion_seguimiento,
                    limitaciones_tecnicas = :limitaciones_tecnicas
                WHERE id=%s', $id);
        } else {
            $sql = 'INSERT INTO banco_indicadores.tbl_indicador_datos_complementarios (
                id_indicador, 
                autor, 
                id_tipo_fuente, 
                frecuencia, 
                formato_sistematizacion, 
                instrumentos_planificacion, 
                fecha_elaboracion,
                fecha_actualizacion, 
                fecha_esperada_actualizacion,
                institucion_estimacion,
                institucion_seguimiento,
                limitaciones_tecnicas
                ) VALUES (
                    :id_indicador, 
                    :autor, 
                    :id_tipo_fuente, 
                    :frecuencia, 
                    :formato_sistematizacion, 
                    :instrumentos_planificacion,
                    :fecha_elaboracion,
                    :fecha_actualizacion, 
                    :fecha_esperada_actualizacion,
                    :institucion_estimacion,
                    :institucion_seguimiento,
                    :limitaciones_tecnicas
                )';
        }
        try {   
            $stmt = $this->pdo->prepare($sql);
            if($id == 0){
                $stmt->bindValue(':id_indicador',$rec['id_indicador']);
            } 
            $stmt->bindValue(':autor',$rec['autor']);
            $stmt->bindValue(':id_tipo_fuente',$rec['id_tipo_fuente']);
            $stmt->bindValue(':frecuencia',$rec['frecuencia']);
            $stmt->bindValue(':formato_sistematizacion',$rec['formato_sistematizacion']);
            $stmt->bindValue(':instrumentos_planificacion',$rec['instrumentos_planificacion']);
            //$stmt->bindValue(':id_instrumento_planificacion',$rec['id_instrumento_planificacion']);
            $stmt->bindValue(':fecha_elaboracion',$rec['fecha_elaboracion']);
            $stmt->bindValue(':fecha_actualizacion',$rec['fecha_actualizacion']);
            $stmt->bindValue(':fecha_esperada_actualizacion',$rec['fecha_esperada_actualizacion']);
            $stmt->bindValue(':institucion_estimacion',$rec['institucion_estimacion']);
            $stmt->bindValue(':institucion_seguimiento',$rec['institucion_seguimiento']);
            $stmt->bindValue(':limitaciones_tecnicas',$rec['limitaciones_tecnicas']);


            $stmt->execute();
            
            if($id == 0){
                $id =  $this->pdo->lastInsertId('banco_indicadores.tbl_indicador_datos_complementarios_id_seq');
            }
            return ['id' => $id, 'success' => true];
          
        } catch (Exception $e){
            $err = "";
            foreach($stmt->errorInfo() as $d){
                $err.=$d;
            }
            throw new RestException(400, $e->getTraceAsString().":".$err);
        }
      
      
    }

    /**
     * GET indicadores/datosestadisticos/{id}
     *
     * @param int       $id map to url
     * @return string
     */
    function getDatosEstadisticos($id){
        
        $query = sprintf("SELECT * FROM banco_indicadores.tbl_indicador_estadistica WHERE id_indicador=%s", $id);
        $stmt = $this->pdo->query($query);
        $indicadores = [];
        while ($row = $stmt->fetch(\PDO::FETCH_ASSOC)) {
            $indicadores[] = [
                'id' => $row['id'],
                'id_indicador' => $row['id_indicador'],
                'id_dato_estadistico' => $row['id_dato_estadistico']
            ];
        }
        return $indicadores;
    }

    /**
     * POST indicadores/datosestadisticos/{id}
     *
     * @param int       $id map to url
     * @return string
     */
    function insertDatosEstadisticos ($rec)
    {
        try {print_r($rec);
          
        } catch (Exception $e){
            $err = "";
            foreach($stmt->errorInfo() as $d){
                $err.=$d;
            }
            throw new RestException(400, $e->getTraceAsString().":".$err);
        }
      
      
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
}