<?php
use Luracast\Restler\RestException;
require_once('./helper/Connection.php');

class IndicadorEstadisticaModel
{
    private $db;
    function __construct ()
    {
        $this->pdo = Connection::get()->connect();
    }

    function get ($id)
    {
        // prepare SELECT statement
        $stmt = $this->pdo->prepare("SELECT *
                                       FROM banco_indicadores.tbl_indicador_estadistica
                                      WHERE id = :id");
        // bind value to the :id parameter
        $stmt->bindValue(':id', $id);
        
        // execute the statement
        $stmt->execute();
 
        // return the result set as an object
        return $stmt->fetchObject();
    }

    function insert ($rec)
    {
        try {
            $sql = 'INSERT INTO banco_indicadores.tbl_indicador_estadistica(
                id_indicador, 
                id_dato_estadistico) VALUES (
                    :id_indicador, 
                    :id_dato_estadistico
                )';
            $stmt = $this->pdo->prepare($sql);
            $stmt->bindValue(':id_indicador',$rec['id_indicador']);
            $stmt->bindValue(':id_dato_estadistico',$rec['id_dato_estadistico']);
            $stmt->execute();

            $id =  $this->pdo->lastInsertId('banco_indicadores.tbl_indicador_estadistica_id_seq');
            return ['id' => $id];
        } catch (Exception $e){
            $err = "";
            foreach($stmt->errorInfo() as $d){
                $err.=$d;
            }
            throw new RestException(400, $err);
        }
    }

   
    function delete ($id)
    {
        $r = $this->get($id);
        if (!$r || !$this->db->prepare("DELETE FROM banco_indicadores.tbl_indicador_estadistica WHERE id = ?")->execute(array($id)))
            return FALSE;
        return $r;
    }

   
}