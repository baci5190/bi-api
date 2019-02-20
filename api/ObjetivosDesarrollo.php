<?php
use Luracast\Restler\RestException;
require_once './model/ObjetivosDesarrolloModel.php';
class ObjetivosDesarrollo
{
    public $dp;
    static $FIELDS = array('descripcion', );
    function __construct()
    {
        $this->dp = new ObjetivosDesarrolloModel();
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