<?php
use Luracast\Restler\RestException;
require_once('./helper/Connection.php');

class ListaResultadoMedIndicadorModel
{
    private $db;
    function __construct ()
    {
        $this->pdo = Connection::get()->connect();
    }
    function get ($id)
    {
        // prepare SELECT statement
        //$stmt = $this->pdo->prepare('select * from med.lista_resultado_med_indicador (:id);');
        // bind value to the :id parameter
        //$stmt->bindValue(':id', $id);
        
        // execute the statement
        //$stmt->execute();
        $items = [];
        // return the result set as an object
        return $items;
    }

    function getAll ()
    {
        $stmt = $this->pdo->query('select * from med.lista_resultado_med_indicador ();');
        $items = [];
        while ($row = $stmt->fetch(\PDO::FETCH_ASSOC)) {
           // echo $stmt->fetch(\PDO::FETCH_ASSOC)
           if($row !== NULL) {
            $items[] = 
            $row;
           }
        }
        return $items;
    }

}