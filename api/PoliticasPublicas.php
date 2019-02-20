<?php
use Luracast\Restler\RestException;
require_once './model/PoliticasPublicasModel.php';
class PoliticasPublicas
{
    public $dp;
    static $FIELDS = array('id_resultado', 'id_politica', 'descripcion_politica', 'codigo_interno_resultado');
    function __construct()
    {
        $this->dp = new PoliticasPublicasModel();
    }
    function index()
    {
        return $this->dp->getAll();
    }
    //example: http://localhost:8080/bi-api/politicasPublicas/1
    function get($id)
    {
        return $this->dp->get($id);
    }
}