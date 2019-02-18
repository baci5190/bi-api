<?php
/**
 * SQLite DB. All data is stored in data_pdo_sqlite.sq3 file
 * This file will be automatically created when missing
 * Make sure this folder has sufficient write permission
 * for this page to create the file.
 */
use Luracast\Restler\RestException;
class DB_PDO_Postgres
{
    private $db;
    function __construct ()
    {
        $this->db = new PDO( 'pgsql:host=localhost;dbname=banco_indicadores', 'postgres', 'rootio' );
         //= new LessQL\Database( $pdo );

    }
    function get ($id)
    {
        return $this->db->table('tbl_indicador', $id);
    }
    function getAll ()
    {
        $stmt = $this->db->query('SELECT * from tbl_indicador');
        $stocks = [];
        while ($row = $stmt->fetch(\PDO::FETCH_ASSOC)) {
            $stocks[] = [
                'id' => $row['id'],
                'symbol' => $row['symbol'],
                'company' => $row['company']
            ];
        }
        return $stocks;
    }

    function insert ($rec)
    {
        try {
            $date = new Date();
            $toInsert = [
                'codigo' => $rec['codigo'],
                'denominacion' => $rec['denominacion'], 
                'complemento' => $rec['complemento'], 
                'id_resultado_originador' => $rec['id_resultado_originador'],
                'tipo_indicador' => $rec['tipo_indicador'],
                'criterio_indicador' => $rec['criterio_indicador'],
                'definicion','estado' => $rec['definicion'],
                'creado' => $date->format(DATE_ATOM),
                'creado_por' => 'dev',
                'observaciones' => '{}'
            ];
            return $this->db->tbl_indicador()->createRow($toInsert);
        } catch(Exception $e){
            return false;
        }
    }

    function update ($id, $rec)
    {
        $sql = $this->db->prepare("UPDATE authors SET name = :name, email = :email WHERE id = :id");
        if (!$sql->execute(array(':id' => $id, ':name' => $rec['name'], ':email' => $rec['email'])))
            return FALSE;
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
}