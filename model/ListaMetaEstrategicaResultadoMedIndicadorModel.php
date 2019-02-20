<?php
use Luracast\Restler\RestException;
require_once('./helper/Connection.php');

class ListaMetaEstrategicaResultadoMedIndicadorModel
{
    private $db;
    function __construct ()
    {
        $this->pdo = Connection::get()->connect();
    }
    function get ($id)
    {
        //prepare SELECT statement
        $stmt = $this->pdo->prepare('select *  from med.lista_meta_estrategica_resultado_med_indicador (:id);');
         //bind value to the :id parameter
        $stmt->bindValue(':id', $id);
        
       // execute the statement
       $stmt->execute();
 
       // return the result set as an object
        
        return $stmt->fetchObject();
       
    }

    function getAll ()
    {
        //$stmt = $this->pdo->query('select * from med.lista_meta_estrategica_resultado_med_indicador (".id_resultado.");');
        $items = [];
        //while ($row = $stmt->fetch(\PDO::FETCH_ASSOC)) {
           // echo $stmt->fetch(\PDO::FETCH_ASSOC)
          // if($row !== NULL) {
            //$items[] = 
            //$row;
           //}
        //}
        return $items;
    }

}