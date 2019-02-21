<?php
use Luracast\Restler\RestException;
require_once './model/IndicadoresModel.php';
require_once './model/InstrumentosPlanificacionModel.php';

class Indicadores
{
    public $dp;
    static $FIELDS = array('id', 'codigo', 'denominacion', 'complemento', 'id_resultado_originador','tipo_indicador','criterio_indicador','estado', "tipo_resultado");
    function __construct()
    {
        $this->dp = new IndicadoresModel();
        $this->dpa = new InstrumentosPlanificacionModel();
    }
    function index()
    {
        return $this->dp->getAll();
    }
    function get($id)
    {
        return $this->dp->get($id);
    }
    function post($request_data = NULL)
    {
        return $this->dp->insert($request_data);
    }
    function put($id, $request_data = NULL)
    {
        return $this->dp->update($id, $this->_validate($request_data));
    }

    /**
     * GET indicadores/{id}/variables
     *
     * @param int       $param1 map to url
     *
     * @return Array
     */
    function getLineaBase($id){
        return $this->dp->getLineaBase($id);
    }

    //
    function getInstrumentosPlanificacion($id) {
        return $this->dpa->get($id);
    }

    function deleteInstrumentosPlanificacion($id)
    {
        return $this->dpa->delete($id);
    }
    function postInstrumentosPlanificacion($request_data = NULL)
    {   
        return $this->dpa->insert($request_data);
    }

    //
    function postLineaBase($request_data = NULL)
    {
        return $this->dp->insertLineaBase($request_data);
    }

    function getDatosComplementarios($id){
        return $this->dp->getDatosComplementarios($id);
    }

    function postDatosComplementarios($request_data = NULL)
    {
        return $this->dp->insertDatosComplementarios($request_data);
    }

    function getReferenciaBibliografica($id){
        return $this->dp->getReferenciaBibliografica($id);
    }

    function postReferenciaBibliografica($request_data = NULL)
    {
        return $this->dp->insertReferenciaBibliografica($request_data);
    }

    function getDatosEstadisticos($id){
        return $this->dp->getDatosEstadisticos($id);
    }

    function postDatosEstadisticos($request_data = NULL)
    {
        return $this->dp->insertDatosEstadisticos($request_data);
    }

    function delete($id)
    {
        return $this->dp->delete($id);
    }

    function getFichaTecnica($id){
        return $this->dp->getFichaTecnica($id);
    }
    /*
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