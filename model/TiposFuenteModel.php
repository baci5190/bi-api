<?php
use Luracast\Restler\RestException;
require_once('./helper/Connection.php');

class TiposFuenteModel
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
                                       FROM banco_indicadores.tbl_tipos_fuente
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
        $stmt = $this->pdo->query('SELECT * from banco_indicadores.tbl_tipos_fuente');
        $items = [];
        while ($row = $stmt->fetch(\PDO::FETCH_ASSOC)) {
            $items[] = [
                'id' => $row['id'],
                'descripcion' => $row['descripcion']
            ];
        }
        return $items;
    }
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