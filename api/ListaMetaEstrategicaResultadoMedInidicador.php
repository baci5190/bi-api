
<?php
use Luracast\Restler\RestException;
require_once './model/ListaMetaEstrategicaResultadoMedIndicadorModel.php';
class ListaMetaEstrategicaResultadoMedInidicador
{
    public $dp;
    static $FIELDS = array( 'id_resultado', 'nombre', 'tipo', 'codigo_interno');
    function __construct()
    {
        $this->dp = new ListaMetaEstrategicaResultadoMedIndicadorModel();
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