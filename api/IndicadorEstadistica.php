<?php
use Luracast\Restler\RestException;
require_once './model/IndicadorEstadisticaModel.php';
class IndicadorEstadistica
{
    public $dp;
    static $FIELDS = array("id_indicador","id_dato_estadistico");
    function __construct()
    {
        $this->dp = new IndicadorEstadisticaModel();
    }
    function post($request_data = NULL)
    {
        return $this->dp->insert($this->_validate($request_data));
    }

    function delete($id)
    {
        return $this->dp->delete($id);
    }
    private function _validate($data)
    {
        $indicador = array();
        foreach (IndicadorEstadistica::$FIELDS as $field) {
            if (!isset($data[$field]))
                throw new RestException(400, "$field field missing");
            $indicador[$field] = $data[$field];
        }
        return $indicador;
    }
}