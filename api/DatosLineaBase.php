<?php
use Luracast\Restler\RestException;
require_once './model/DatosLineaBaseModel.php';
class DatosLineaBase
{
    public $dp;
    function __construct()
    {
        $this->dp = new DatosLineaBaseModel();
    }
    /*
    function index()
    {
        return $this->dp->getAll();
    }
    */
    function get($id, $nivelId)
    {
        return $this->dp->get($id, $nivelId);
    }
    function post($request_data = NULL)
    {
        return $this->dp->insert($request_data);
    }
    /*
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