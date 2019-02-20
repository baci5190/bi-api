<?php
use Luracast\Restler\RestException;
require_once('./helper/Connection.php');

class PoliticasPublicasModel
{
    private $db;
    function __construct ()
    {
        $this->pdo = Connection::get()->connect();
    }
    function get ($id)
    {
        // prepare SELECT statement
        //$stmt = $this->pdo->prepare('SELECT *
 //                                      FROM banco_indicadores.tbl_tipos_fuente
   //                                   WHERE id = :id');
        // bind value to the :id parameter
     //   $stmt->bindValue(':id', $id);
        
        // execute the statement
       // $stmt->execute();
       $item[] = [
        'id_resultado' =>  1,
        'id_politica' => 1,
        'descripcion_politica' => 'nombre',
        'codigo_interno_resultado' => 'sadfa'
        ];
        // return the result set as an object
        //return $stmt->fetchObject();
        return $item;
    }

    function getAll ()
    {
       // $stmt = $this->pdo->query('SELECT * from banco_indicadores.tbl_tipos_fuente');
        $items = [];
       // while ($row = $stmt->fetch(\PDO::FETCH_ASSOC)) {
        for ($x = 0; $x <= 10; $x++) {
            $items[] = [
                'id_resultado' =>  $x,
                'id_politica' => $x,
                'descripcion_politica' => 'nombre',
                'codigo_interno_resultado' => 'sadfa'
            ];
        } 
            
        //}
        return $items;
    }
}