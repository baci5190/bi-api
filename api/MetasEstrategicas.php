<?php
use Luracast\Restler\RestException;
require_once './model/MetasEstrategicasModel.php';
class MetasEstrategicas
{
    public $dp;
    static $FIELDS = array('id_resultado', 'id_meta_estrategica', 'nombre_meta_estrategica', 'codigo_interno_med', 'codigo_interno_resultado' );
    function __construct()
    {
        $this->dp = new MetasEstrategicasModel();
    }
    function index()
    {
        return $this->dp->getAll();
    }
    //example: http://localhost:8080/bi-api/metasEstrategicas/1
    function get($id)
    {
        return $this->dp->get($id);
    }
}