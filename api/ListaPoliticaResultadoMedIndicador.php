
<?php
use Luracast\Restler\RestException;
require_once './model/ListaPoliticaResultadoMedIndicadorModel.php';
class ListaPoliticaResultadoMedIndicador
{
    public $dp;
    static $FIELDS = array( 'id_resultado', 'nombre', 'tipo', 'codigo_interno');
    function __construct()
    {
        $this->dp = new ListaPoliticaResultadoMedIndicadorModel();
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