

<?php
use Luracast\Restler\RestException;
require_once './model/PoliticasGeneralesModel.php';
class PoliticasGenerales
{
    public $dp;
    static $FIELDS = array('id_indicador', 'tipo');
    function __construct()
    {
        $this->dp = new PoliticasGeneralesModel();
    }
    function index()
    {
        return $this->dp->getAll();
    }
    //example: http://localhost:8080/bi-api/PoliticasGenerales/1
    function get($id)
    {
        return $this->dp->get($id);
    }
}