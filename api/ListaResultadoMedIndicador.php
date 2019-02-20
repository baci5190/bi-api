<?php
use Luracast\Restler\RestException;
require_once './model/ListaResultadoMedIndicadorModel.php';
class ListaResultadoMedIndicador
{
    public $dp;
    static $FIELDS = array( 'id_resultado', 'nombre', 'tipo', 'codigo_interno');
    function __construct()
    {
        $this->dp = new ListaResultadoMedIndicadorModel();
    }
    function index()
    {
        return $this->dp->getAll();
    }
    function get($id)
    {
        return $this->dp->get($id);
    }
}