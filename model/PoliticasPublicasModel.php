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
        //prepare SELECT statement
        $stmt = $this->pdo->prepare('select * from med.lista_politica_publica_resultado_med_indicador (:id);');
           //bind value to the :id parameter
        $stmt->bindValue(':id', $id);
          
         // execute the statement
        $stmt->execute();
   
        while ($row = $stmt->fetch(\PDO::FETCH_ASSOC)) {
            $items = json_decode($row['lista_politica_publica_resultado_med_indicador']); 
        }  
          return $items;
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
                'codigo_interno_resultado' => 'ABB' . $x
            ];
        } 
            
        //}
        return $items;
    }
}