

<?php
use Luracast\Restler\RestException;
require_once './model/PlanesSectorialModel.php';
class PlanesSectorial
{
    public $dp;
    static $FIELDS = array('id_plan_sectorial', 'descripcion');
    function __construct()
    {
        $this->dp = new PlanesSectorialModel();
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