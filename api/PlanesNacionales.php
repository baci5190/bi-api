
<?php
use Luracast\Restler\RestException;
require_once './model/PlanesNacionalesModel.php';
class PlanesNacionales
{
    public $dp;
    static $FIELDS = array('id_plan', 'descripcion');
    function __construct()
    {
        $this->dp = new PlanesNacionalesModel();
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