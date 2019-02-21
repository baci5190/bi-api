<?php
define('ROOT', __DIR__);
$models = ['Indicadores', 'Productos', 'PlanesSectorial', 'MetasEstrategicas', 'ListaResultadoMedIndicador', 'ObjetivosDesarrollo', 'PoliticasGenerales', 'PlanesNacionales',  'PoliticasPublicas', 'ResultadosOriginadores', 'NivelesTerritoriales','UnidadesMedida', 'TiposFuente','InstrumentosPlanificacion','DatosEstadisticos','IndicadorEstadistica', 'DatosLineaBase', 'DatosSerieHistorica', 'Departamentos', 'Municipios'];
require_once './helper/functions.php';
require_once './vendor/restler.php';

//require_once './api/Authors.php';
//require_once './api/Indicadores.php';
//require_once './api/ResultadosOriginadores.php';
use Luracast\Restler\Restler;
use \Luracast\Restler\Defaults;
Defaults::$crossOriginResourceSharing = true;
Defaults::$accessControlAllowOrigin = '*';
Defaults::$accessControlAllowMethods = 'GET, POST, PUT, PATCH, DELETE, OPTIONS, HEAD';

$r = new Restler();
$r->setSupportedFormats('JsonFormat', 'UploadFormat');
foreach($models as $m){
    require_once './api/' . $m . ".php";
    $r->addAPIClass($m);        
}
$r->addAPIClass('Resources');
$r->handle();