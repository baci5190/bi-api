<?php
use Luracast\Restler\RestException;
require_once('./helper/Connection.php');

class InstrumentosPlanificacionModel
{
    private $db;
    function __construct ()
    {
        $this->pdo = Connection::get()->connect();
    }

    function get ($id)
    {
        // prepare SELECT statement
        $stmt = $this->pdo->prepare('SELECT *
                                       FROM banco_indicadores.tbl_instrumentos_planificacion
                                      WHERE id = :id');
        // bind value to the :id parameter
        $stmt->bindValue(':id', $id);
        
        // execute the statement
        $stmt->execute();
 
        // return the result set as an object
        return $stmt->fetchObject();
    }

    function getAll ()
    {
        $stmt = $this->pdo->query('SELECT * from banco_indicadores.tbl_instrumentos_planificacion');
        $items = [];
        while ($row = $stmt->fetch(\PDO::FETCH_ASSOC)) {
            $items[] = [
                'id' => $row['id'],
                'descripcion' => $row['descripcion']
            ];
        }
        return $items;
    }

    function delete ($id)
    {
        $r = $this->get($id);
        if (!$r || !$this->db->prepare("DELETE FROM banco_indicadores.tbl_instrumentos_planificacion WHERE id = ?")->execute(array($id)))
            return FALSE;
        return $r;
    }
    

 
    function insert ($rec)
    {
        $id = !isset($rec['id']) ? 0 : intval($rec['id']);
        if(!is_not_set_or_empty($id) && $id != 0){
            /*$sql = sprintf('
                UPDATE banco_indicadores.tbl_referencia_bibliografica SET
                    autor_institucional_nombre = :autor_institucional_nombre, 
                    autor_nombre = :autor_nombre, 
                    autor_iniciales = :autor_iniciales, 
                    titulo = :titulo, 
                    nombre_editorial = :nombre_editorial, 
                    año_publicacion = :ano_publicacion,
                    ciudad_publicacion = :ciudad_publicacion, 
                    pais_publicacion = :pais_publicacion
                WHERE id=%s', $id);*/
        } else {
            $sql = 'INSERT INTO banco_indicadores.tbl_instrumentos_planificacion (descripcion) VALUES (:descripcion)';
        }
        try {   
            $stmt = $this->pdo->prepare($sql);
            //if($id == 0){
            //    $stmt->bindValue(':id',$rec['id']);
           // } 
            $stmt->bindValue(':descripcion',$rec['descripcion']);
            



            $stmt->execute();
            
            if($id == 0){
                $id = 1; //$this->pdo->lastInsertId('banco_indicadores.tbl_referencia_bibliografica_id_seq');
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

    //FUNCIONES ANTERIORES SE CAMBIAN POR INSTRUMENTOS PLANIFICACION DETALLE 
    /*function get ($id)
    {
        // prepare SELECT statement
        $stmt = $this->pdo->prepare('SELECT *
                                       FROM banco_indicadores.tbl_instrumentos_planificacion
                                      WHERE id = :id');
        // bind value to the :id parameter
        $stmt->bindValue(':id', $id);
        
        // execute the statement
        $stmt->execute();
 
        // return the result set as an object
        return $stmt->fetchObject();
    }*/

    /*function getAll ()
    {
        $stmt = $this->pdo->query('SELECT * from banco_indicadores.tbl_instrumentos_planificacion');
        $items = [];
        while ($row = $stmt->fetch(\PDO::FETCH_ASSOC)) {
            $items[] = [
                'id' => $row['id'],
                'descripcion' => $row['descripcion']
            ];
        }
        return $items;
    }*/
    
/*
    function insert ($rec)
    {
        try {
            $sql = 'INSERT INTO banco_indicadores.tbl_indicador(codigo, denominacion, complemento, id_resultado_originador, tipo_indicador, criterio_indicador, definicion, creado, creado_por, observaciones,estado) VALUES (:codigo, :denominacion, :complemento, :id_resultado_originador, :tipo_indicador, :criterio_indicador, :definicion, :creado, :creado_por, :observaciones,:estado)';
            $stmt = $this->pdo->prepare($sql);
            $date = new DateTime();
            $stmt->bindValue(':codigo',$rec['codigo']);
            $stmt->bindValue(':denominacion',$rec['denominacion']);
            $stmt->bindValue(':complemento',$rec['complemento']);
            $stmt->bindValue(':id_resultado_originador',$rec['id_resultado_originador']);
            $stmt->bindValue(':tipo_indicador',$rec['tipo_indicador']);
            $stmt->bindValue(':criterio_indicador',$rec['criterio_indicador']);
            $stmt->bindValue(':definicion',$rec['definicion']);
            $stmt->bindValue(':creado',$date->format(DATE_ATOM));
            $stmt->bindValue(':creado_por',$rec['creado_por']);
            $stmt->bindValue(':observaciones',"{}");
            $stmt->bindValue(':estado',$rec['estado']);
            $stmt->execute();

            return $this->pdo->lastInsertId('banco_indicadores.tbl_indicador_id_seq');
        } catch (Exception $e){
            $err = "";
            foreach($stmt->errorInfo() as $d){
                $err.=$d;
            }
            throw new RestException(400, $err);
        }
    }

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