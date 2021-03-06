<?php
use Luracast\Restler\RestException;
require_once './model/MunicipiosModel.php';
class Municipios
{
    public $dp;
    static $FIELDS = array('descripcion');
    function __construct()
    {
        $this->dp = new MunicipiosModel();
    }
    function index()
    {
        return $this->dp->getAll();
    }
    function get($id)
    {
        return $this->dp->get($id);
    }
    /*
    function post($request_data = NULL)
    {
        return $this->dp->insert($this->_validate($request_data));
    }
    function put($id, $request_data = NULL)
    {
        return $this->dp->update($id, $this->_validate($request_data));
    }
    function delete($id)
    {
        return $this->dp->delete($id);
    }
    private function _validate($data)
    {
        $indicador = array();
        foreach (Indicadores::$FIELDS as $field) {
            if (!isset($data[$field]))
                throw new RestException(400, "$field field missing");
            $indicador[$field] = $data[$field];
        }
        return $indicador;
    }
    */
}