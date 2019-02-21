<?php
use Luracast\Restler\RestException;
require_once('./helper/Connection.php');

class ProductosModel
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
          FROM public.producto
         WHERE id_producto = :id');
            // bind value to the :id parameter
$stmt->bindValue(':id', $id);

// execute the statement
$stmt->execute();

// return the result set as an object
return $stmt->fetchObject();
        // prepare SELECT statement
        //$stmt = $this->pdo->prepare('SELECT * FROM med.lista_producto_indicador
          //                            WHERE id_producto = :id');
        // bind value to the :id parameter
        //$stmt->bindValue(':id', $id);
        
        // execute the statement
        //$stmt->execute();
 
        // return the result set as an object
        //return $stmt->fetchObject();
        
    }

    function getAll ()
    {
        $stmt = $this->pdo->query('SELECT * from public.producto');
        $items = [];
        while ($row = $stmt->fetch(\PDO::FETCH_ASSOC)) {
            $items[] = [
                'id' => $row['id_producto'],
                'nombre' => $row['nombre_producto']
            ];
        }
        return $items;
        //$stmt = $this->pdo->query('select * from med.lista_producto_indicador ();');
        //$items = [];
        //while ($row = $stmt->fetch(\PDO::FETCH_ASSOC)) {
           // echo $stmt->fetch(\PDO::FETCH_ASSOC)
           //if($row !== NULL) {
          //  $items[] = 
           /// $row;
           //}
      //  }
    //    return $items;
    }

}