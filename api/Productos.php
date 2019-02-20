<?php
use Luracast\Restler\RestException;
require_once './model/ProductosModel.php';
class Productos
{
    public $dp;
    static $FIELDS = array('nombre');
    function __construct()
    {
        $this->dp = new ProductosModel();
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