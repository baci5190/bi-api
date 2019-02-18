--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.11
-- Dumped by pg_dump version 9.6.11

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: criteriosindicador; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE banco_indicadores.criteriosindicador AS ENUM (
    'Es específico',
    'Es medible',
    'Existe un responsable asignado',
    'Es relevante o realista',
    'Es Pertinente'
);


ALTER TYPE banco_indicadores.criteriosindicador OWNER TO postgres;

--
-- Name: estadosindicador; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE banco_indicadores.estadosindicador AS ENUM (
    'En formulación',
    'En revisión',
    'Aprobado'
);


ALTER TYPE banco_indicadores.estadosindicador OWNER TO postgres;

--
-- Name: formatossistematizacionindicador; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE banco_indicadores.formatossistematizacionindicador AS ENUM (
    'Base de datos de acceso interno',
    'Datos tabulados en texto generados de una base de datos',
    'Datos tabulados en texto generados manualmente',
    'Base de datos del INE',
    'SICOIN',
    'SICOIN GL',
    'SIGEASI',
    'SIGES',
    'SIGSA',
    'SIINSAN',
    'SIMON',
    'SINIT',
    'SIPLAN',
    'SNIP',
    'Tablas Access generadas manualmente',
    'Tablas Excel generadas manualmente'
);


ALTER TYPE banco_indicadores.formatossistematizacionindicador OWNER TO postgres;

--
-- Name: frecuenciasindicador; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE banco_indicadores.frecuenciasindicador AS ENUM (
    'Decenal',
    'Sexenal',
    'Quinquenal',
    'Cuatrienal',
    'Trienal',
    'Bienal',
    'Anual',
    'Semestral',
    'Cuatrimestral',
    'Mensual'
);


ALTER TYPE banco_indicadores.frecuenciasindicador OWNER TO postgres;

--
-- Name: sentidosindicador; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE banco_indicadores.sentidosindicador AS ENUM (
    'Ascendente',
    'Descendente'
);


ALTER TYPE banco_indicadores.sentidosindicador OWNER TO postgres;

--
-- Name: tiposindicador; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE banco_indicadores.tiposindicador AS ENUM (
    'Impacto',
    'Resultado'
);


ALTER TYPE banco_indicadores.tiposindicador OWNER TO postgres;

--
-- Name: tiposresultadoindicador; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE banco_indicadores.tiposresultadoindicador AS ENUM (
    'Resultado Final',
    'Resultado Intermedio',
    'Producto'
);


ALTER TYPE banco_indicadores.tiposresultadoindicador OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: tbl_bitacora; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE banco_indicadores.tbl_bitacora (
    id bigint NOT NULL,
    vista_originador text,
    servicio_destino text,
    sql text,
    resultado text,
    trx_prefijo text,
    creado_el timestamp with time zone DEFAULT now() NOT NULL,
    id_usuario text NOT NULL
);


ALTER TABLE banco_indicadores.tbl_bitacora OWNER TO postgres;

--
-- Name: tbl_bitacora_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE banco_indicadores.tbl_bitacora_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE banco_indicadores.tbl_bitacora_id_seq OWNER TO postgres;

--
-- Name: tbl_bitacora_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE banco_indicadores.tbl_bitacora_id_seq OWNED BY banco_indicadores.tbl_bitacora.id;


--
-- Name: tbl_dato_comp_inst_planificacion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE banco_indicadores.tbl_dato_comp_inst_planificacion (
    id integer NOT NULL,
    id_dato_complementario bigint NOT NULL,
    id_instrumento bigint NOT NULL
);


ALTER TABLE banco_indicadores.tbl_dato_comp_inst_planificacion OWNER TO postgres;

--
-- Name: tbl_dato_comp_inst_planificacion_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE banco_indicadores.tbl_dato_comp_inst_planificacion_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE banco_indicadores.tbl_dato_comp_inst_planificacion_id_seq OWNER TO postgres;

--
-- Name: tbl_dato_comp_inst_planificacion_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE banco_indicadores.tbl_dato_comp_inst_planificacion_id_seq OWNED BY banco_indicadores.tbl_dato_comp_inst_planificacion.id;


--
-- Name: tbl_datos_estadisticos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE banco_indicadores.tbl_datos_estadisticos (
    id bigint NOT NULL,
    descripcion text,
    id_nivel_territorial bigint
);


ALTER TABLE banco_indicadores.tbl_datos_estadisticos OWNER TO postgres;

--
-- Name: tbl_datos_estadisticos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE banco_indicadores.tbl_datos_estadisticos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE banco_indicadores.tbl_datos_estadisticos_id_seq OWNER TO postgres;

--
-- Name: tbl_datos_estadisticos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE banco_indicadores.tbl_datos_estadisticos_id_seq OWNED BY banco_indicadores.tbl_datos_estadisticos.id;


--
-- Name: tbl_indicador; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE banco_indicadores.tbl_indicador (
    id integer NOT NULL,
    codigo text NOT NULL,
    denominacion text NOT NULL,
    complemento text NOT NULL,
    id_resultado_originador bigint,
    estado banco_indicadores.estadosindicador NOT NULL,
    creado timestamp with time zone DEFAULT now() NOT NULL,
    actualizado timestamp with time zone,
    creado_por text NOT NULL,
    actualizado_por text,
    habilitado boolean DEFAULT true,
    observaciones jsonb,
    tipo_resultado banco_indicadores.tiposresultadoindicador DEFAULT 'Resultado Final'::banco_indicadores.tiposresultadoindicador NOT NULL,
    criterio_indicador jsonb DEFAULT '{"criterios": {}}'::jsonb NOT NULL,
    tipo_indicador text
);


ALTER TABLE banco_indicadores.tbl_indicador OWNER TO postgres;

--
-- Name: tbl_indicador_datos_complementarios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE banco_indicadores.tbl_indicador_datos_complementarios (
    id bigint NOT NULL,
    id_indicador bigint NOT NULL,
    autor character varying NOT NULL,
    id_tipo_fuente integer NOT NULL,
    frecuencia banco_indicadores.frecuenciasindicador NOT NULL,
    formato_sistematizacion banco_indicadores.formatossistematizacionindicador NOT NULL,
    limitaciones_tecnicas text,
    institucion_estimacion text,
    instrumentos_planificacion integer[] DEFAULT '{}'::integer[] NOT NULL,
    institucion_seguimiento text NOT NULL,
    fecha_elaboracion timestamp without time zone NOT NULL,
    fecha_actualizacion timestamp without time zone,
    fecha_esperada_actualizacion timestamp without time zone,
    id_instrumento_planificacion integer
);


ALTER TABLE banco_indicadores.tbl_indicador_datos_complementarios OWNER TO postgres;

--
-- Name: tbl_indicador_datos_complementarios_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE banco_indicadores.tbl_indicador_datos_complementarios_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE banco_indicadores.tbl_indicador_datos_complementarios_id_seq OWNER TO postgres;

--
-- Name: tbl_indicador_datos_complementarios_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE banco_indicadores.tbl_indicador_datos_complementarios_id_seq OWNED BY banco_indicadores.tbl_indicador_datos_complementarios.id;


--
-- Name: tbl_indicador_estadistica; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE banco_indicadores.tbl_indicador_estadistica (
    id integer NOT NULL,
    id_indicador bigint NOT NULL,
    id_dato_estadistico bigint NOT NULL
);


ALTER TABLE banco_indicadores.tbl_indicador_estadistica OWNER TO postgres;

--
-- Name: tbl_indicador_estadistica_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE banco_indicadores.tbl_indicador_estadistica_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE banco_indicadores.tbl_indicador_estadistica_id_seq OWNER TO postgres;

--
-- Name: tbl_indicador_estadistica_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE banco_indicadores.tbl_indicador_estadistica_id_seq OWNED BY banco_indicadores.tbl_indicador_estadistica.id;


--
-- Name: tbl_indicador_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE banco_indicadores.tbl_indicador_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE banco_indicadores.tbl_indicador_id_seq OWNER TO postgres;

--
-- Name: tbl_indicador_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE banco_indicadores.tbl_indicador_id_seq OWNED BY banco_indicadores.tbl_indicador.id;


--
-- Name: tbl_instrumentos_planificacion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE banco_indicadores.tbl_instrumentos_planificacion (
    id bigint NOT NULL,
    descripcion text
);


ALTER TABLE banco_indicadores.tbl_instrumentos_planificacion OWNER TO postgres;

--
-- Name: tbl_instrumentos_planificacion_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE banco_indicadores.tbl_instrumentos_planificacion_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE banco_indicadores.tbl_instrumentos_planificacion_id_seq OWNER TO postgres;

--
-- Name: tbl_instrumentos_planificacion_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE banco_indicadores.tbl_instrumentos_planificacion_id_seq OWNED BY banco_indicadores.tbl_instrumentos_planificacion.id;


--
-- Name: tbl_linea_base; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE banco_indicadores.tbl_linea_base (
    id bigint NOT NULL,
    id_indicador integer NOT NULL,
    "año" integer NOT NULL,
    valor_relativo numeric(10,2),
    valor_absoluto numeric(10,2),
    id_unid_med_valor_absoluto bigint NOT NULL,
    id_unid_med_valor_relativo integer NOT NULL,
    niveles_territoriales integer[],
    variables jsonb DEFAULT '{"variables": []}'::jsonb NOT NULL,
    formula text,
    resultado text,
    sentido_esperado banco_indicadores.sentidosindicador DEFAULT 'Ascendente'::banco_indicadores.sentidosindicador NOT NULL
);


ALTER TABLE banco_indicadores.tbl_linea_base OWNER TO postgres;

--
-- Name: tbl_linea_base_datos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE banco_indicadores.tbl_linea_base_datos (
    id bigint NOT NULL,
    id_linea_base bigint NOT NULL,
    id_indicador integer NOT NULL,
    "año" integer NOT NULL,
    valor_relativo numeric(10,2),
    valor_absoluto numeric(10,2),
    id_departamento bigint,
    id_municipio bigint,
    id_poblado bigint,
    columnas jsonb,
    id_nivel_territorial integer
);


ALTER TABLE banco_indicadores.tbl_linea_base_datos OWNER TO postgres;

--
-- Name: tbl_linea_base_datos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE banco_indicadores.tbl_linea_base_datos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE banco_indicadores.tbl_linea_base_datos_id_seq OWNER TO postgres;

--
-- Name: tbl_linea_base_datos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE banco_indicadores.tbl_linea_base_datos_id_seq OWNED BY banco_indicadores.tbl_linea_base_datos.id;


--
-- Name: tbl_linea_base_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE banco_indicadores.tbl_linea_base_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE banco_indicadores.tbl_linea_base_id_seq OWNER TO postgres;

--
-- Name: tbl_linea_base_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE banco_indicadores.tbl_linea_base_id_seq OWNED BY banco_indicadores.tbl_linea_base.id;


--
-- Name: tbl_linea_base_nivel_territorial; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE banco_indicadores.tbl_linea_base_nivel_territorial (
    id bigint NOT NULL,
    id_linea_base bigint,
    id_nivel_territorial bigint
);


ALTER TABLE banco_indicadores.tbl_linea_base_nivel_territorial OWNER TO postgres;

--
-- Name: tbl_linea_base_nivel_territorial_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE banco_indicadores.tbl_linea_base_nivel_territorial_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE banco_indicadores.tbl_linea_base_nivel_territorial_id_seq OWNER TO postgres;

--
-- Name: tbl_linea_base_nivel_territorial_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE banco_indicadores.tbl_linea_base_nivel_territorial_id_seq OWNED BY banco_indicadores.tbl_linea_base_nivel_territorial.id;


--
-- Name: tbl_nivel_territorial; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE banco_indicadores.tbl_nivel_territorial (
    id integer NOT NULL,
    descripcion text
);


ALTER TABLE banco_indicadores.tbl_nivel_territorial OWNER TO postgres;

--
-- Name: tbl_nivel_territorial_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE banco_indicadores.tbl_nivel_territorial_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE banco_indicadores.tbl_nivel_territorial_id_seq OWNER TO postgres;

--
-- Name: tbl_nivel_territorial_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE banco_indicadores.tbl_nivel_territorial_id_seq OWNED BY banco_indicadores.tbl_nivel_territorial.id;


--
-- Name: tbl_referencia_bibliografica; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE banco_indicadores.tbl_referencia_bibliografica (
    id bigint NOT NULL,
    id_indicador bigint NOT NULL,
    autor_institucional_nombre text,
    autor_nombre text,
    autor_iniciales text,
    autores jsonb,
    titulo text NOT NULL,
    nombre_editorial text,
    "año_publicacion" integer,
    ciudad_publicacion text,
    pais_publicacion text,
    url_referencia text
);


ALTER TABLE banco_indicadores.tbl_referencia_bibliografica OWNER TO postgres;

--
-- Name: tbl_referencia_bibliografica_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE banco_indicadores.tbl_referencia_bibliografica_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE banco_indicadores.tbl_referencia_bibliografica_id_seq OWNER TO postgres;

--
-- Name: tbl_referencia_bibliografica_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE banco_indicadores.tbl_referencia_bibliografica_id_seq OWNED BY banco_indicadores.tbl_referencia_bibliografica.id;


--
-- Name: tbl_resultados_originadores; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE banco_indicadores.tbl_resultados_originadores (
    id bigint NOT NULL,
    descripcion text
);


ALTER TABLE banco_indicadores.tbl_resultados_originadores OWNER TO postgres;

--
-- Name: tbl_resultados_originadores_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE banco_indicadores.tbl_resultados_originadores_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE banco_indicadores.tbl_resultados_originadores_id_seq OWNER TO postgres;

--
-- Name: tbl_resultados_originadores_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE banco_indicadores.tbl_resultados_originadores_id_seq OWNED BY banco_indicadores.tbl_resultados_originadores.id;


--
-- Name: tbl_serie_historica; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE banco_indicadores.tbl_serie_historica (
    id bigint NOT NULL,
    id_indicador integer NOT NULL,
    "año" integer NOT NULL,
    valor_relativo numeric(10,2),
    valor_absoluto numeric(10,2),
    id_departamento bigint,
    id_municipio bigint,
    id_poblado bigint,
    id_nivel_territorial integer
);


ALTER TABLE banco_indicadores.tbl_serie_historica OWNER TO postgres;

--
-- Name: tbl_serie_historica_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE banco_indicadores.tbl_serie_historica_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE banco_indicadores.tbl_serie_historica_id_seq OWNER TO postgres;

--
-- Name: tbl_serie_historica_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE banco_indicadores.tbl_serie_historica_id_seq OWNED BY banco_indicadores.tbl_serie_historica.id;


--
-- Name: tbl_tipos_fuente; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE banco_indicadores.tbl_tipos_fuente (
    id integer NOT NULL,
    descripcion text
);


ALTER TABLE banco_indicadores.tbl_tipos_fuente OWNER TO postgres;

--
-- Name: tbl_tipos_fuente_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE banco_indicadores.tbl_tipos_fuente_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE banco_indicadores.tbl_tipos_fuente_id_seq OWNER TO postgres;

--
-- Name: tbl_tipos_fuente_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE banco_indicadores.tbl_tipos_fuente_id_seq OWNED BY banco_indicadores.tbl_tipos_fuente.id;


--
-- Name: tbl_unidad_medida; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE banco_indicadores.tbl_unidad_medida (
    id integer NOT NULL,
    descripcion text,
    es_relativo boolean DEFAULT true NOT NULL
);


ALTER TABLE banco_indicadores.tbl_unidad_medida OWNER TO postgres;

--
-- Name: tbl_unidad_medida_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE banco_indicadores.tbl_unidad_medida_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE banco_indicadores.tbl_unidad_medida_id_seq OWNER TO postgres;

--
-- Name: tbl_unidad_medida_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE banco_indicadores.tbl_unidad_medida_id_seq OWNED BY banco_indicadores.tbl_unidad_medida.id;


--
-- Name: tbl_bitacora id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY banco_indicadores.tbl_bitacora ALTER COLUMN id SET DEFAULT nextval('banco_indicadores.tbl_bitacora_id_seq'::regclass);


--
-- Name: tbl_dato_comp_inst_planificacion id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY banco_indicadores.tbl_dato_comp_inst_planificacion ALTER COLUMN id SET DEFAULT nextval('banco_indicadores.tbl_dato_comp_inst_planificacion_id_seq'::regclass);


--
-- Name: tbl_datos_estadisticos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY banco_indicadores.tbl_datos_estadisticos ALTER COLUMN id SET DEFAULT nextval('banco_indicadores.tbl_datos_estadisticos_id_seq'::regclass);


--
-- Name: tbl_indicador id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY banco_indicadores.tbl_indicador ALTER COLUMN id SET DEFAULT nextval('banco_indicadores.tbl_indicador_id_seq'::regclass);


--
-- Name: tbl_indicador_datos_complementarios id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY banco_indicadores.tbl_indicador_datos_complementarios ALTER COLUMN id SET DEFAULT nextval('banco_indicadores.tbl_indicador_datos_complementarios_id_seq'::regclass);


--
-- Name: tbl_indicador_estadistica id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY banco_indicadores.tbl_indicador_estadistica ALTER COLUMN id SET DEFAULT nextval('banco_indicadores.tbl_indicador_estadistica_id_seq'::regclass);


--
-- Name: tbl_instrumentos_planificacion id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY banco_indicadores.tbl_instrumentos_planificacion ALTER COLUMN id SET DEFAULT nextval('banco_indicadores.tbl_instrumentos_planificacion_id_seq'::regclass);


--
-- Name: tbl_linea_base id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY banco_indicadores.tbl_linea_base ALTER COLUMN id SET DEFAULT nextval('banco_indicadores.tbl_linea_base_id_seq'::regclass);


--
-- Name: tbl_linea_base_datos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY banco_indicadores.tbl_linea_base_datos ALTER COLUMN id SET DEFAULT nextval('banco_indicadores.tbl_linea_base_datos_id_seq'::regclass);


--
-- Name: tbl_linea_base_nivel_territorial id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY banco_indicadores.tbl_linea_base_nivel_territorial ALTER COLUMN id SET DEFAULT nextval('banco_indicadores.tbl_linea_base_nivel_territorial_id_seq'::regclass);


--
-- Name: tbl_nivel_territorial id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY banco_indicadores.tbl_nivel_territorial ALTER COLUMN id SET DEFAULT nextval('banco_indicadores.tbl_nivel_territorial_id_seq'::regclass);


--
-- Name: tbl_referencia_bibliografica id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY banco_indicadores.tbl_referencia_bibliografica ALTER COLUMN id SET DEFAULT nextval('banco_indicadores.tbl_referencia_bibliografica_id_seq'::regclass);


--
-- Name: tbl_resultados_originadores id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY banco_indicadores.tbl_resultados_originadores ALTER COLUMN id SET DEFAULT nextval('banco_indicadores.tbl_resultados_originadores_id_seq'::regclass);


--
-- Name: tbl_serie_historica id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY banco_indicadores.tbl_serie_historica ALTER COLUMN id SET DEFAULT nextval('banco_indicadores.tbl_serie_historica_id_seq'::regclass);


--
-- Name: tbl_tipos_fuente id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY banco_indicadores.tbl_tipos_fuente ALTER COLUMN id SET DEFAULT nextval('banco_indicadores.tbl_tipos_fuente_id_seq'::regclass);


--
-- Name: tbl_unidad_medida id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY banco_indicadores.tbl_unidad_medida ALTER COLUMN id SET DEFAULT nextval('banco_indicadores.tbl_unidad_medida_id_seq'::regclass);


--
-- Data for Name: tbl_bitacora; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY banco_indicadores.tbl_bitacora (id, vista_originador, servicio_destino, sql, resultado, trx_prefijo, creado_el, id_usuario) FROM stdin;
\.


--
-- Name: tbl_bitacora_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('banco_indicadores.tbl_bitacora_id_seq', 1, false);


--
-- Data for Name: tbl_dato_comp_inst_planificacion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY banco_indicadores.tbl_dato_comp_inst_planificacion (id, id_dato_complementario, id_instrumento) FROM stdin;
\.


--
-- Name: tbl_dato_comp_inst_planificacion_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('banco_indicadores.tbl_dato_comp_inst_planificacion_id_seq', 1, false);


--
-- Data for Name: tbl_datos_estadisticos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY banco_indicadores.tbl_datos_estadisticos (id, descripcion, id_nivel_territorial) FROM stdin;
1	Poblacion menor de 18 años	1
2	Población de menores de 5 años	2
\.


--
-- Name: tbl_datos_estadisticos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('banco_indicadores.tbl_datos_estadisticos_id_seq', 2, true);


--
-- Data for Name: tbl_indicador; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY banco_indicadores.tbl_indicador (id, codigo, denominacion, complemento, id_resultado_originador, estado, creado, actualizado, creado_por, actualizado_por, habilitado, observaciones, tipo_resultado, criterio_indicador, tipo_indicador) FROM stdin;
2	0	prueba	prueba	1	En formulación	2018-12-13 22:47:37-06	\N	prueba	\N	f	{}	Resultado Final	{"criterios": {}}	Impacto
3	0	asldmas	asdkmasodkams	1	En formulación	2018-12-14 19:49:07-06	\N	dev	\N	f	{}	Resultado Final	{"criterios": {}}	Impacto
4	0	Poblacions	Pruebas	1	En formulación	2018-12-14 19:52:40-06	\N	dev	\N	f	{}	Resultado Final	{"criterios": {}}	Impacto
5	0	Poblacion	mayores	1	En formulación	2018-12-14 20:04:36-06	\N	dev	\N	f	{}	Resultado Final	{"criterios": {}}	Impacto
6	0	asdasd	asdasd	1	En formulación	2018-12-14 20:09:05-06	\N	dev	\N	f	{}	Resultado Final	{"criterios": {}}	Impacto
7	0	l,mlm	lkmlm	1	En formulación	2018-12-14 20:11:53-06	\N	dev	\N	f	{}	Resultado Final	{"criterios": {}}	Impacto
8	0	asdas	sadasd	1	En formulación	2018-12-14 20:16:11-06	\N	dev	\N	f	{}	Resultado Final	{"criterios": {}}	Impacto
36	0	Poblacion 	mayores a 90 años	2	En formulación	2018-12-16 04:18:47-06	\N	dev	\N	f	{}	Resultado Intermedio	{"criterios": {}}	Impacto
53	IM0004	alksmdlkams	lksldmkasldm	1	En formulación	2019-01-08 12:39:29-06	\N	dev	\N	t	{}	Resultado Final	{"criterios": {"es_medible": "dakn", "es_especifico": "adas", "es_pertinente": "kmo", "relevante_o_realista": "ni", "responsable_asignado": "ni"}}	De impacto
54	PR0001	asodmasokm	saodkmaosmd	2	En formulación	2019-01-08 12:40:20-06	\N	dev	\N	t	{}	Producto	{}	De eficiencia
41	0	Poblacion	poblacion	2	En formulación	2019-01-07 21:57:03-06	\N	dev	\N	f	{}	Resultado Intermedio	{"criterios": {}}	Resultado
42	0	pruebas	pruebas	1	En formulación	2019-01-07 21:59:06-06	\N	dev	\N	f	{}	Resultado Intermedio	{"criterios": {}}	Impacto
44	0	Poblacion	aslkdmalskdmas	1	En formulación	2019-01-08 11:01:36-06	\N	dev	\N	f	{}	Resultado Intermedio	{}	De resultado
46	0	pobacion	aslkdmalsk	2	En formulación	2019-01-08 12:06:16-06	\N	dev	\N	f	{}	Resultado Intermedio	{"criterios": {"es_medible": "alkmalkm", "es_especifico": "klmlkm", "es_pertinente": "slkmslks", "relevante_o_realista": "alkmalakm", "responsable_asignado": "lkmalkaml"}}	De resultado
55	IM0005	demo	demo	1	En formulación	2019-01-08 16:14:04-06	\N	dev	\N	t	{}	Resultado Final	{"criterios": {"es_medible": "test", "es_especifico": "test", "es_pertinente": "test", "relevante_o_realista": "test", "responsable_asignado": "test"}}	\N
38	0	Poblacion	mayor a 30 años	1	En formulación	2018-12-17 08:27:22-06	\N	dev	\N	f	{}	Producto	{"criterios": []}	Resultado
51	IM0002	l,lkmlkm	lkmlmlk	1	En formulación	2019-01-08 12:25:38-06	\N	dev	\N	t	{}	Resultado Final	{"criterios": {"es_medible": "m", "es_especifico": "mk", "es_pertinente": "m", "relevante_o_realista": "okmokm", "responsable_asignado": "m"}}	De impacto
56	IM0006	demo	demo	1	En formulación	2019-01-08 16:14:13-06	\N	dev	\N	t	{}	Resultado Final	{"criterios": {"es_medible": "test", "es_especifico": "test", "es_pertinente": "test", "relevante_o_realista": "test", "responsable_asignado": "test"}}	De impacto
45	0	poblacio	mayores	1	En formulación	2019-01-08 11:26:54-06	\N	dev	\N	f	{}	Producto	{"criterios": {"es_medible": "sdlkfmsdlfksm", "es_especifico": "sdlfkmsdlfkm", "es_pertinente": "skmdkmlkm", "relevante_o_realista": "dlfkmsdlfksdmlfkm", "responsable_asignado": "ldkfsldfmkl"}}	De eficiencia
9	0	321322132	321321321	1	En formulación	2018-12-14 20:20:51-06	\N	dev	\N	f	{}	Resultado Final	{"criterios": {}}	Impacto
10	0	assdasdas	asdasdasd	1	En formulación	2018-12-14 20:31:44-06	\N	dev	\N	f	{}	Resultado Final	{"criterios": {}}	Impacto
20	0	asdasda	asdasd	1	En formulación	2018-12-14 20:35:19-06	\N	dev	\N	f	{}	Resultado Final	{"criterios": {}}	Impacto
21	0	lkmlm	lkmlkm	1	En formulación	2018-12-14 21:54:36-06	\N	dev	\N	f	{}	Resultado Final	{"criterios": {}}	Impacto
22	0	lkmlkml	lkmlkml	1	En formulación	2018-12-14 21:56:21-06	\N	dev	\N	f	{}	Resultado Final	{"criterios": {}}	Impacto
23	0	lkmlkm	lkmlkm	1	En formulación	2018-12-14 21:57:33-06	\N	dev	\N	f	{}	Resultado Final	{"criterios": {}}	Impacto
24	0	sdfsd	sdfsd	1	En formulación	2018-12-14 22:00:45-06	\N	dev	\N	f	{}	Resultado Final	{"criterios": {}}	Impacto
30	0	sfas	sasdasda	2	En formulación	2018-12-14 22:24:00-06	\N	dev	\N	f	{}	Resultado Intermedio	{"criterios": {}}	Resultado
31	0	admaslkdm	lksasmdlaskmdlaks	1	En formulación	2018-12-14 22:25:49-06	\N	dev	\N	f	{}	Resultado Final	{"criterios": {}}	Impacto
32	0	asdlkmaslkdm	lsakmdlaksmdlaksm	1	En formulación	2018-12-14 22:26:25-06	\N	dev	\N	f	{}	Producto	{"criterios": {}}	Impacto
33	0	Producto	mayores a 30 años	2	En formulación	2018-12-14 22:28:13-06	\N	dev	\N	f	{}	Producto	{"criterios": {}}	Resultado
34	0	Pueblo	alskmdalsdas	1	En formulación	2018-12-16 04:14:29-06	\N	dev	\N	f	{}	Resultado Final	{"criterios": {}}	Impacto
35	0	321321	321321	1	En formulación	2018-12-16 04:15:20-06	\N	dev	\N	f	{}	Producto	{"criterios": {}}	Impacto
50	IM0001	asllmk	lkmlkmlk	1	En formulación	2019-01-08 12:23:10-06	\N	dev	\N	t	{}	Resultado Final	{"criterios": {"es_medible": "mlkm", "es_especifico": "kmlkm", "es_pertinente": "kmlk", "relevante_o_realista": "mlmk", "responsable_asignado": "kmlm"}}	De impacto
47	0	poblacion	pruebas	2	En formulación	2019-01-08 12:16:05-06	\N	dev	\N	f	{}	Resultado Final	{"criterios": {"es_medible": "lkm", "es_especifico": "lkm", "es_pertinente": "lkm", "relevante_o_realista": "lkm", "responsable_asignado": "lkm"}}	De impacto
48	0	lkm	lkm	1	En formulación	2019-01-08 12:19:48-06	\N	dev	\N	f	{}	Resultado Final	{"criterios": {"es_medible": "n", "es_especifico": "kjn", "es_pertinente": "n", "relevante_o_realista": "n", "responsable_asignado": "n"}}	De impacto
49	0	asd	lkm	1	En formulación	2019-01-08 12:21:21-06	\N	dev	\N	f	{}	Resultado Final	{"criterios": {"es_medible": "im", "es_especifico": "om", "es_pertinente": "km", "relevante_o_realista": "m", "responsable_asignado": "oim"}}	De impacto
39	0	pruebas de	pruebas	2	En formulación	2018-12-17 15:58:26-06	\N	dev	\N	f	{}	Resultado Intermedio	{"criterios": {}}	Impacto
57	IM0007	denominacion 	y complemento	1	En formulación	2019-01-08 16:18:37-06	\N	dev	\N	t	{}	Resultado Final	{"criterios": []}	De impacto
37	0	Poblacion	mayor de 30 	2	En formulación	2018-12-17 08:11:50-06	\N	dev	\N	f	{}	Resultado Final	{"criterios": {"es_medible": "slkmslmslk", "es_especifico": "lkmalkma", "es_pertinente": "slkmslslksm", "relevante_o_realista": "slkmslkmsl", "responsable_asignado": "lksmlsmkslk"}}	Impacto
40	0	poblacion	poblacion	1	En formulación	2019-01-07 21:48:30-06	\N	dev	\N	f	{}	Resultado Intermedio	{"criterios": {}}	Resultado
59	PR0002	poblacion de ejemplo	kmadomasodkasdas	2	En formulación	2019-01-28 16:42:36-06	\N	dev	\N	t	{}	Producto	{"criterios": {"es_medible": "asdasd", "es_especifico": "asdasd", "es_pertinente": "asdasdasdas", "relevante_o_realista": "asdasdasd", "responsable_asignado": "asdasda"}}	De eficiencia
60	IM0008	okmokm	okmokmokkmk	1	En formulación	2019-01-28 16:47:35-06	\N	dev	\N	t	{}	Resultado Final	{"criterios": {"es_medible": "ñl,ñl,", "es_especifico": "ñl,ñl", "es_pertinente": "ñl,", "relevante_o_realista": "ñl,", "responsable_asignado": "ñl,"}}	De impacto
61	RE0001	zszczx	zcxzczxczx	2	En formulación	2019-01-28 18:42:51-06	\N	dev	\N	t	{}	Resultado Intermedio	{"criterios": {"es_medible": "zxczx", "es_especifico": "zxcxz", "es_pertinente": "zxczxc", "relevante_o_realista": "zxczxcz", "responsable_asignado": "xzczx"}}	De impacto
62	RE0002	Poblacion adulta	39 a 52 años	2	En formulación	2019-01-28 19:45:38-06	\N	dev	\N	t	{}	Resultado Intermedio	{"criterios": {"es_medible": "Porque es cuantitativo", "es_especifico": "porque es especifico", "es_pertinente": "Porque lo necesitamos", "relevante_o_realista": "Porque sirve para ", "responsable_asignado": "Si"}}	De resultado
63	PR0003	Población adulta	50 a 70 años	2	En formulación	2019-01-28 19:53:03-06	\N	dev	\N	t	{}	Producto	{"criterios": {"es_medible": "medible", "es_especifico": "especifico", "es_pertinente": "pertinente", "relevante_o_realista": "relevante", "responsable_asignado": "responsable "}}	De eficiencia
52	IM0003	lamlkml	slkdmsldkmfsl	1	En formulación	2019-01-08 12:29:19-06	\N	dev	\N	f	{}	Resultado Final	{"criterios": {"es_medible": "kmlkmm", "es_especifico": "kmlkm", "es_pertinente": "mlkm", "relevante_o_realista": "kmlkm", "responsable_asignado": "mlkm"}}	De impacto
64	PR0004	Población adulta	mayores de 35 años	2	En formulación	2019-01-29 07:30:57-06	\N	dev	\N	t	{}	Producto	{"criterios": {"es_medible": "medible", "es_especifico": "especifico", "es_pertinente": "pertinente", "relevante_o_realista": "relevante", "responsable_asignado": "asignado"}}	De calidad
\.


--
-- Data for Name: tbl_indicador_datos_complementarios; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY banco_indicadores.tbl_indicador_datos_complementarios (id, id_indicador, autor, id_tipo_fuente, frecuencia, formato_sistematizacion, limitaciones_tecnicas, institucion_estimacion, instrumentos_planificacion, institucion_seguimiento, fecha_elaboracion, fecha_actualizacion, fecha_esperada_actualizacion, id_instrumento_planificacion) FROM stdin;
5	37	Pruebas	12	Trienal	Tablas Access generadas manualmente	No tenemos dinero	ptuebas	{4,5,3,6}	pruebas	2018-12-20 00:00:00	2018-12-14 00:00:00	2018-12-14 00:00:00	\N
7	62		6	Bienal	SICOIN GL	No tenemos agua	Ejemplos	{5}	Ejemplos	2019-01-31 00:00:00	2019-01-31 00:00:00	2019-01-31 00:00:00	\N
6	54		2	Decenal	Base de datos de acceso interno	pruebas	ñls,fdñlsd	{3}	asñdla,	2019-01-01 00:00:00	2019-01-10 00:00:00	2019-01-13 00:00:00	\N
2	2	asdasdasd	2	Quinquenal	SICOIN	asdasdasdasdasd	asdasdas	{3,4,5,6}	asdasd	2018-12-19 00:00:00	2018-12-21 00:00:00	2018-12-28 00:00:00	\N
3	35	asdsad	5	Cuatrienal	Base de datos del INE	sadasdasdasdasd	adasds	{2,3,4}	asds	2018-12-27 00:00:00	2018-12-14 00:00:00	2018-12-26 00:00:00	\N
4	36	Bryan Cruz	7	Anual	Base de datos del INE	NO HAY INTERNET	MINDES	{1,2,3}	MINDES	2018-12-24 00:00:00	2018-12-24 00:00:00	2018-12-24 00:00:00	\N
\.


--
-- Name: tbl_indicador_datos_complementarios_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('banco_indicadores.tbl_indicador_datos_complementarios_id_seq', 7, true);


--
-- Data for Name: tbl_indicador_estadistica; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY banco_indicadores.tbl_indicador_estadistica (id, id_indicador, id_dato_estadistico) FROM stdin;
1	2	1
2	2	2
3	35	2
4	35	1
5	36	2
6	37	1
7	37	2
8	53	1
9	62	1
10	54	2
11	54	1
12	54	1
13	54	1
14	54	1
\.


--
-- Name: tbl_indicador_estadistica_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('banco_indicadores.tbl_indicador_estadistica_id_seq', 14, true);


--
-- Name: tbl_indicador_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('banco_indicadores.tbl_indicador_id_seq', 64, true);


--
-- Data for Name: tbl_instrumentos_planificacion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY banco_indicadores.tbl_instrumentos_planificacion (id, descripcion) FROM stdin;
1	Plan Nacional de Desarrollo
2	Una Meta Estratégica de Desarrollo (especificar cuál)
3	Un Objetivo de Desarrollo Sostenible (especificar cuál)
4	Una Política Pública (especificar cuál)
5	Un Plan Sectorial  (especificar cuál)
6	Plan de Desarrollo Municipal y Ordenamiento Territorial (especificar qué municipio)
7	Política General de Gobierno
\.


--
-- Name: tbl_instrumentos_planificacion_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('banco_indicadores.tbl_instrumentos_planificacion_id_seq', 7, true);


--
-- Data for Name: tbl_linea_base; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY banco_indicadores.tbl_linea_base (id, id_indicador, "año", valor_relativo, valor_absoluto, id_unid_med_valor_absoluto, id_unid_med_valor_relativo, niveles_territoriales, variables, formula, resultado, sentido_esperado) FROM stdin;
9	42	2019	10.20	10.20	1	1	{1}	{"variables": [{"id": "extModel563-1", "valor": "10.2", "nombre": "weqwe", "inicial": "A", "id_unidad_medida": 8}]}			Ascendente
8	41	2019	0.00	0.00	0	0	{1,3}	{"variables": [{"id": "extModel563-1", "valor": "10.2", "nombre": "asdasd", "inicial": "A", "id_unidad_medida": 1}]}			Descendente
10	45	2019	10.20	10.20	1	1	{1,2}	{"variables": [{"id": "extModel582-1", "valor": "100", "nombre": "aslkmdlaskmd", "inicial": "B", "id_unidad_medida": 1}]}			Descendente
1	2	2018	10.20	10.30	1	2	{1,2}	{"variables": [{"id": "extModel568-1", "valor": null, "nombre": "sdfmsdlfmsdl", "inicial": "A", "id_unidad_medida": 8}, {"id": "extModel573-1", "valor": null, "nombre": "sdñlf,sñdl,f", "inicial": "B", "id_unidad_medida": 7}]}			Ascendente
2	34	2018	0.00	0.00	0	0	{2,3}	{"variables": []}			Ascendente
3	35	2018	10.20	10.30	6	5	{1,2}	{"variables": [{"id": "extModel599-1", "valor": "10.2", "nombre": "asdsadas", "inicial": "A", "id_unidad_medida": 6}, {"id": "extModel657-1", "valor": null, "nombre": "asdsad", "inicial": "B", "id_unidad_medida": 6}]}			Descendente
4	36	2014	5.10	5.20	3	3	{3,4}	{"variables": [{"id": "extModel683-1", "valor": null, "nombre": "asdasd", "inicial": "A", "id_unidad_medida": 4}, {"id": "extModel683-2", "valor": null, "nombre": "asdasdas", "inicial": "B", "id_unidad_medida": 12}]}			Descendente
17	54	2019	10.00	120.00	2	2	{2}	{"variables": [{"id": "extModel614-1", "valor": null, "nombre": "slkdmsdlf", "inicial": "A", "id_unidad_medida": 1}]}			Descendente
18	56	2016	10.00	10.00	8	8	{1,2}	{"variables": [{"id": "extModel589-1", "valor": "0", "nombre": "variable", "inicial": "A", "id_unidad_medida": 8}, {"id": "extModel589-2", "valor": "0", "nombre": "variable B", "inicial": "B", "id_unidad_medida": 8}]}			Ascendente
11	46	2019	10.00	10.00	3	6	{1,2,3}	{"variables": [{"id": "extModel603-1", "valor": "10", "nombre": "pruebas", "inicial": "A", "id_unidad_medida": 1}, {"id": "extModel603-2", "valor": "10", "nombre": "pruebas", "inicial": "B", "id_unidad_medida": 1}]}	A/B		Ascendente
5	37	2019	10.30	10.50	3	6	{2,3,1}	{"variables": [{"id": "extModel582-1", "valor": null, "nombre": "Descripcion", "inicial": "A", "id_unidad_medida": 7}, {"id": "extModel582-2", "valor": null, "nombre": "Descripcion", "inicial": "C", "id_unidad_medida": 3}, {"id": "extModel557-1", "valor": null, "nombre": "Descripcion", "inicial": "B", "id_unidad_medida": 8}]}	A/C		Descendente
7	40	2019	10.00	10.00	2	2	{1,2}	{"variables": [{"id": "extModel563-1", "valor": "10.2", "nombre": "Pruebas", "inicial": "A", "id_unidad_medida": 2}, {"id": "extModel563-2", "valor": "10.2", "nombre": "Prubas", "inicial": "B", "id_unidad_medida": 7}]}	A/B		Descendente
6	38	2020	10.20	10.30	4	7	{2,3}	{"variables": [{"id": "extModel604-1", "valor": null, "nombre": "Pruebas", "inicial": "D", "id_unidad_medida": 4}]}	D		Descendente
12	47	2019	0.00	0.00	0	0	{2}	{"variables": [{"id": "extModel634-1", "valor": null, "nombre": "alsmlkm", "inicial": "A", "id_unidad_medida": 1}]}	A		Ascendente
13	50	2019	10.00	10.00	1	1	{2}	{"variables": [{"id": "extModel580-1", "valor": null, "nombre": "kmokmo", "inicial": "A", "id_unidad_medida": 1}]}			Ascendente
19	57	2016	10.00	10.00	8	1	{2}	{"variables": [{"id": "extModel666-1", "valor": null, "nombre": "variable A", "inicial": "A", "id_unidad_medida": 8}, {"id": "extModel666-2", "valor": null, "nombre": "variable B", "inicial": "B", "id_unidad_medida": 8}]}	A/B		Ascendente
15	52	2019	10.00	10.00	1	1	{2}	{"variables": [{"id": "extModel580-1", "valor": null, "nombre": "sdlfkmsdlkf", "inicial": "A", "id_unidad_medida": 1}]}			Ascendente
14	51	2019	10.00	10.00	1	1	{2}	{"variables": [{"id": "extModel581-1", "valor": null, "nombre": "klmaslkmsl", "inicial": "A", "id_unidad_medida": 1}, {"id": "extModel235-1", "valor": null, "nombre": "variable B", "inicial": "B", "id_unidad_medida": 8}]}	A/B		Ascendente
20	59	2019	0.00	0.00	0	0	{3}	{"variables": []}			Descendente
21	59	2019	0.00	0.00	0	0	{3}	{"variables": []}			Descendente
23	62	2018	10.00	20.00	8	4	{2,3}	{"variables": [{"id": "extModel494-1", "valor": null, "nombre": "Ejemplo", "inicial": "A", "id_unidad_medida": 5}, {"id": "extModel494-2", "valor": null, "nombre": "ejemplo", "inicial": "B", "id_unidad_medida": 5}]}	A/B		Descendente
22	60	2018	10.00	10.00	7	6	{2,4}	{"variables": [{"id": "extModel362-1", "valor": null, "nombre": "asdasdasdsad", "inicial": "A", "id_unidad_medida": 6}, {"id": "extModel362-2", "valor": null, "nombre": "asdasdasd", "inicial": "B", "id_unidad_medida": 8}]}			Ascendente
24	64	2019	10.00	10.00	6	4	{2,3,1}	{"variables": [{"id": "extModel512-1", "valor": null, "nombre": "pruebas", "inicial": "A", "id_unidad_medida": 3}, {"id": "extModel512-2", "valor": "10", "nombre": "Pruebas", "inicial": "B", "id_unidad_medida": 8}]}	A/B		Ascendente
16	53	2019	10.00	10.00	19	1	{2}	{"variables": [{"id": "extModel580-1", "valor": null, "nombre": "asdspad", "inicial": "A", "id_unidad_medida": 1}, {"id": "extModel264-1", "valor": null, "nombre": "Variable de pruebas", "inicial": "B", "id_unidad_medida": 4}]}			Ascendente
\.


--
-- Data for Name: tbl_linea_base_datos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY banco_indicadores.tbl_linea_base_datos (id, id_linea_base, id_indicador, "año", valor_relativo, valor_absoluto, id_departamento, id_municipio, id_poblado, columnas, id_nivel_territorial) FROM stdin;
2	5	37	2019	10.00	10.00	1	0	0	{"columnas": ["", ""]}	2
3	5	37	2019	0.00	0.00	1	0	0	{"columnas": ["10", "10"]}	2
4	5	37	2019	10.00	10.00	1	0	0	{"columnas": ["", ""]}	2
5	5	37	2019	10.00	10.00	1	0	0	{"columnas": ["", ""]}	2
6	5	37	2019	10.00	10.00	1	0	0	{"columnas": ["", ""]}	2
7	5	37	2019	10.00	10.00	1	0	0	{"columnas": ["", ""]}	2
8	5	37	2019	10.00	10.00	1	0	0	{"columnas": ["", ""]}	2
35	5	37	2019	10.00	10.00	0	1	0	{"columnas": ["", "", ""]}	3
36	5	37	2019	0.00	0.00	0	1	0	{"columnas": ["10", "10", "10"]}	3
37	7	40	2019	10.00	10.00	1	0	0	{"columnas": ["", "", ""]}	2
38	7	40	2019	0.00	0.00	1	0	0	{"columnas": ["10", "10", "10"]}	2
39	8	41	2019	10.00	10.00	0	1	0	{"columnas": ["", "", ""]}	3
40	8	41	2019	0.00	0.00	0	1	0	{"columnas": ["10", "10", "10"]}	3
41	11	46	2019	10.00	10.00	1	0	0	{"columnas": ["", ""]}	2
42	11	46	2019	0.00	0.00	1	0	0	{"columnas": ["10", "10"]}	2
43	12	47	2019	10.00	10.00	1	0	0	{"columnas": [""]}	2
44	12	47	2019	0.00	0.00	1	0	0	{"columnas": ["10"]}	2
45	13	50	2019	10.00	10.00	1	0	0	{"columnas": [""]}	2
46	13	50	2019	0.00	0.00	1	0	0	{"columnas": ["10"]}	2
47	14	51	2019	10.00	10.00	1	0	0	{"columnas": [""]}	2
48	14	51	2019	0.00	0.00	1	0	0	{"columnas": ["10"]}	2
49	15	52	2019	10.00	10.00	1	0	0	{"columnas": [""]}	2
50	15	52	2019	0.00	0.00	1	0	0	{"columnas": ["10"]}	2
51	17	54	2019	10.00	10.00	1	0	0	{"columnas": [""]}	2
52	17	54	2019	0.00	0.00	1	0	0	{"columnas": ["10"]}	2
53	19	57	2016	0.00	0.00	1	0	0	{"columnas": ["1", "1"]}	2
54	19	57	2016	0.00	0.00	2	0	0	{"columnas": ["5", "2"]}	2
59	16	53	2019	10.00	10.00	1	0	0	{"columnas": ["", ""]}	2
60	16	53	2019	0.00	0.00	2	0	0	{"columnas": ["5", "2"]}	2
61	22	60	2018	10.00	10.00	1	0	0	{"columnas": ["", ""]}	2
62	22	60	2018	0.00	0.00	2	0	0	{"columnas": ["5", "2"]}	2
63	23	62	2018	10.00	10.00	1	0	0	{"columnas": ["", ""]}	2
64	23	62	2018	0.00	0.00	2	0	0	{"columnas": ["5", "2"]}	2
69	24	64	2019	10.00	10.00	1	0	0	{"columnas": ["", ""]}	2
70	24	64	2019	0.00	0.00	2	0	0	{"columnas": ["5", "2"]}	2
\.


--
-- Name: tbl_linea_base_datos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('banco_indicadores.tbl_linea_base_datos_id_seq', 70, true);


--
-- Name: tbl_linea_base_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('banco_indicadores.tbl_linea_base_id_seq', 24, true);


--
-- Data for Name: tbl_linea_base_nivel_territorial; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY banco_indicadores.tbl_linea_base_nivel_territorial (id, id_linea_base, id_nivel_territorial) FROM stdin;
\.


--
-- Name: tbl_linea_base_nivel_territorial_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('banco_indicadores.tbl_linea_base_nivel_territorial_id_seq', 1, false);


--
-- Data for Name: tbl_nivel_territorial; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY banco_indicadores.tbl_nivel_territorial (id, descripcion) FROM stdin;
1	NACIONAL
2	DEPARTAMENTAL
3	MUNICIPAL
4	LUGAR POBLADO
\.


--
-- Name: tbl_nivel_territorial_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('banco_indicadores.tbl_nivel_territorial_id_seq', 4, true);


--
-- Data for Name: tbl_referencia_bibliografica; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY banco_indicadores.tbl_referencia_bibliografica (id, id_indicador, autor_institucional_nombre, autor_nombre, autor_iniciales, autores, titulo, nombre_editorial, "año_publicacion", ciudad_publicacion, pais_publicacion, url_referencia) FROM stdin;
1	2	asdas	asd	asd	\N	as	asd	2018	asd	asd	\N
2	35	dasdas	asdas	asdasdas	\N	asdas	asdasds	2018	asdas	asdasd	\N
3	36	MINDES	Cruz	BA	\N	Libro de muchas cosas	Santillana	2013	Guatemala	Guatemala	\N
4	37		Datos	BC	\N	Juanito de los palotres	trozos	2018	Guatemala	Guatemala	\N
5	54	Mindes			\N	Ejemplo	Ejemplo	2019	Guatemala	Guatemala	\N
6	61	zxczxczx			\N	titulo	editorial	2019	ciudad	pais	\N
7	62	Juanito			\N	El titulo	Piedrasanta	2019	guatemala	guatemala	\N
8	63	MINDES			\N	El pais de los santos	Piedrasanta	1998	Guatemala	Guatemal	\N
\.


--
-- Name: tbl_referencia_bibliografica_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('banco_indicadores.tbl_referencia_bibliografica_id_seq', 8, true);


--
-- Data for Name: tbl_resultados_originadores; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY banco_indicadores.tbl_resultados_originadores (id, descripcion) FROM stdin;
1	RF-001- Resultado Final elaborado en otro módulo
2	RF-002- Resultado Final elaborado en otro módulo
\.


--
-- Name: tbl_resultados_originadores_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('banco_indicadores.tbl_resultados_originadores_id_seq', 2, true);


--
-- Data for Name: tbl_serie_historica; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY banco_indicadores.tbl_serie_historica (id, id_indicador, "año", valor_relativo, valor_absoluto, id_departamento, id_municipio, id_poblado, id_nivel_territorial) FROM stdin;
11	37	2017	10.00	5.00	1	0	0	2
12	37	2016	13.00	12.00	1	0	0	2
13	37	2017	10.00	10.00	2	0	0	2
14	37	2016	12.00	15.00	2	0	0	2
15	37	2017	10.00	5.00	0	1	0	3
16	37	2016	13.00	12.00	0	1	0	3
17	37	2017	10.00	10.00	0	1	0	3
18	37	2016	12.00	15.00	0	1	0	3
19	40	2017	10.00	5.00	0	1	0	3
20	40	2016	13.00	12.00	0	1	0	3
21	40	2017	10.00	10.00	0	1	0	3
22	40	2016	12.00	15.00	0	1	0	3
23	41	2017	10.00	5.00	0	1	0	3
24	41	2016	13.00	12.00	0	1	0	3
25	41	2017	10.00	10.00	0	1	0	3
26	41	2016	12.00	15.00	0	1	0	3
27	54	2017	10.00	5.00	1	0	0	2
28	54	2016	13.00	12.00	1	0	0	2
29	54	2017	10.00	10.00	2	0	0	2
30	54	2016	12.00	15.00	2	0	0	2
31	57	2017	10.00	5.00	1	0	0	2
32	57	2016	13.00	12.00	1	0	0	2
33	57	2017	10.00	10.00	2	0	0	2
34	57	2016	12.00	15.00	2	0	0	2
35	53	2017	10.00	5.00	1	0	0	2
36	53	2016	13.00	12.00	1	0	0	2
37	53	2017	10.00	10.00	2	0	0	2
38	53	2016	12.00	15.00	2	0	0	2
39	53	2017	10.00	5.00	0	0	1	4
40	53	2016	13.00	12.00	0	0	1	4
41	53	2017	10.00	10.00	0	0	1	4
42	53	2016	12.00	15.00	0	0	1	4
43	53	2017	10.00	5.00	0	2	0	3
44	53	2016	13.00	12.00	0	2	0	3
45	53	2017	10.00	10.00	0	1	0	3
46	53	2016	12.00	15.00	0	3	0	3
47	60	2017	10.00	5.00	1	0	0	2
48	60	2016	13.00	12.00	1	0	0	2
49	60	2017	10.00	10.00	2	0	0	2
50	60	2016	12.00	15.00	2	0	0	2
51	62	2017	10.00	5.00	1	0	0	2
52	62	2016	13.00	12.00	1	0	0	2
53	62	2017	10.00	10.00	2	0	0	2
54	62	2016	12.00	15.00	2	0	0	2
55	62	2017	10.00	5.00	0	2	0	3
56	62	2016	13.00	12.00	0	2	0	3
57	62	2017	10.00	10.00	0	1	0	3
58	62	2016	12.00	15.00	0	3	0	3
59	64	2017	10.00	5.00	1	0	0	2
60	64	2016	13.00	12.00	1	0	0	2
61	64	2017	10.00	10.00	2	0	0	2
62	64	2016	12.00	15.00	2	0	0	2
63	64	2017	10.00	5.00	0	2	0	3
64	64	2016	13.00	12.00	0	2	0	3
65	64	2017	10.00	10.00	0	1	0	3
66	64	2016	12.00	15.00	0	3	0	3
\.


--
-- Name: tbl_serie_historica_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('banco_indicadores.tbl_serie_historica_id_seq', 66, true);


--
-- Data for Name: tbl_tipos_fuente; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY banco_indicadores.tbl_tipos_fuente (id, descripcion) FROM stdin;
1	Encuesta
2	Estudio
3	Investigación
4	Mapa
5	Informe
6	Compendio
7	Registro administrativo
8	SICOIN 
9	SICOIN GL 
10	SIGEASI 
11	SIGES 
12	SIGSA 
13	SIINSAN 
14	SIMON 
15	SINIT 
16	SIPLAN 
17	SNIP 
\.


--
-- Name: tbl_tipos_fuente_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('banco_indicadores.tbl_tipos_fuente_id_seq', 17, true);


--
-- Data for Name: tbl_unidad_medida; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY banco_indicadores.tbl_unidad_medida (id, descripcion, es_relativo) FROM stdin;
1	Coeficiente	t
2	Incidencia	t
3	Índice	t
4	Porcentaje	t
5	Prevalencia	t
6	Proporción	t
7	Ratio	t
8	Razón	t
9	Relación	t
10	Tasa bruta	t
11	Tasa específica	t
12	Tasa específica estandarizada	t
13	Persona \n	f
14	Hectárea (10,000 metros cuadrados)\n	f
15	Kilómetro cuadrado \n	f
16	Kilómetro lineal \n	f
17	Metro cuadrado \n	f
18	Metro cúbico \n	f
19	Metro lineal \n	f
20	Familia\n	f
21	Manzana\n	f
22	 Tonelada métrica \n	f
23	Quintal \n	f
24	Kilogramo \n	f
25	Metro cúbico/habitante \n	f
26	 Tonelada/kilómetro cuadrado \n	f
27	Kilogramo/hectárea \n	f
28	CO2 equivalente \n	f
29	GWh \n	f
30	Litro \n	f
31	Jornal \n	f
\.


--
-- Name: tbl_unidad_medida_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('banco_indicadores.tbl_unidad_medida_id_seq', 31, true);


--
-- Name: tbl_bitacora tbl_bitacora_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY banco_indicadores.tbl_bitacora
    ADD CONSTRAINT tbl_bitacora_pkey PRIMARY KEY (id);


--
-- Name: tbl_dato_comp_inst_planificacion tbl_dato_comp_inst_planificacion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY banco_indicadores.tbl_dato_comp_inst_planificacion
    ADD CONSTRAINT tbl_dato_comp_inst_planificacion_pkey PRIMARY KEY (id);


--
-- Name: tbl_datos_estadisticos tbl_datos_estadisticos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY banco_indicadores.tbl_datos_estadisticos
    ADD CONSTRAINT tbl_datos_estadisticos_pkey PRIMARY KEY (id);


--
-- Name: tbl_indicador_datos_complementarios tbl_indicador_datos_complementarios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY banco_indicadores.tbl_indicador_datos_complementarios
    ADD CONSTRAINT tbl_indicador_datos_complementarios_pkey PRIMARY KEY (id);


--
-- Name: tbl_indicador_estadistica tbl_indicador_estadistica_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY banco_indicadores.tbl_indicador_estadistica
    ADD CONSTRAINT tbl_indicador_estadistica_pkey PRIMARY KEY (id);


--
-- Name: tbl_indicador tbl_indicador_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY banco_indicadores.tbl_indicador
    ADD CONSTRAINT tbl_indicador_pkey PRIMARY KEY (id);


--
-- Name: tbl_instrumentos_planificacion tbl_instrumentos_planificacion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY banco_indicadores.tbl_instrumentos_planificacion
    ADD CONSTRAINT tbl_instrumentos_planificacion_pkey PRIMARY KEY (id);


--
-- Name: tbl_linea_base_datos tbl_linea_base_datos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY banco_indicadores.tbl_linea_base_datos
    ADD CONSTRAINT tbl_linea_base_datos_pkey PRIMARY KEY (id);


--
-- Name: tbl_linea_base_nivel_territorial tbl_linea_base_nivel_territorial_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY banco_indicadores.tbl_linea_base_nivel_territorial
    ADD CONSTRAINT tbl_linea_base_nivel_territorial_pkey PRIMARY KEY (id);


--
-- Name: tbl_linea_base tbl_linea_base_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY banco_indicadores.tbl_linea_base
    ADD CONSTRAINT tbl_linea_base_pkey PRIMARY KEY (id);


--
-- Name: tbl_nivel_territorial tbl_nivel_territorial_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY banco_indicadores.tbl_nivel_territorial
    ADD CONSTRAINT tbl_nivel_territorial_pkey PRIMARY KEY (id);


--
-- Name: tbl_referencia_bibliografica tbl_referencia_bibliografica_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY banco_indicadores.tbl_referencia_bibliografica
    ADD CONSTRAINT tbl_referencia_bibliografica_pkey PRIMARY KEY (id);


--
-- Name: tbl_resultados_originadores tbl_resultados_originadores_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY banco_indicadores.tbl_resultados_originadores
    ADD CONSTRAINT tbl_resultados_originadores_pkey PRIMARY KEY (id);


--
-- Name: tbl_serie_historica tbl_serie_historica_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY banco_indicadores.tbl_serie_historica
    ADD CONSTRAINT tbl_serie_historica_pkey PRIMARY KEY (id);


--
-- Name: tbl_tipos_fuente tbl_tipos_fuente_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY banco_indicadores.tbl_tipos_fuente
    ADD CONSTRAINT tbl_tipos_fuente_pkey PRIMARY KEY (id);


--
-- Name: tbl_unidad_medida tbl_unidad_medida_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY banco_indicadores.tbl_unidad_medida
    ADD CONSTRAINT tbl_unidad_medida_pkey PRIMARY KEY (id);


--
-- Name: tbl_dato_comp_inst_planificacion tbl_dato_comp_inst_planificacion_id_instrumento_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY banco_indicadores.tbl_dato_comp_inst_planificacion
    ADD CONSTRAINT tbl_dato_comp_inst_planificacion_id_instrumento_fkey FOREIGN KEY (id_instrumento) REFERENCES banco_indicadores.tbl_indicador_datos_complementarios(id);


--
-- Name: tbl_indicador_datos_complementarios tbl_indicador_datos_complemen_id_instrumento_planificacion_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY banco_indicadores.tbl_indicador_datos_complementarios
    ADD CONSTRAINT tbl_indicador_datos_complemen_id_instrumento_planificacion_fkey FOREIGN KEY (id_instrumento_planificacion) REFERENCES banco_indicadores.tbl_instrumentos_planificacion(id);


--
-- Name: tbl_indicador_datos_complementarios tbl_indicador_datos_complementarios_id_indicador_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY banco_indicadores.tbl_indicador_datos_complementarios
    ADD CONSTRAINT tbl_indicador_datos_complementarios_id_indicador_fkey FOREIGN KEY (id_indicador) REFERENCES banco_indicadores.tbl_indicador(id);


--
-- Name: tbl_indicador_estadistica tbl_indicador_estadistica_id_indicador_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY banco_indicadores.tbl_indicador_estadistica
    ADD CONSTRAINT tbl_indicador_estadistica_id_indicador_fkey FOREIGN KEY (id_indicador) REFERENCES banco_indicadores.tbl_indicador(id);


--
-- Name: tbl_linea_base_datos tbl_linea_base_datos_id_indicador_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY banco_indicadores.tbl_linea_base_datos
    ADD CONSTRAINT tbl_linea_base_datos_id_indicador_fkey FOREIGN KEY (id_indicador) REFERENCES banco_indicadores.tbl_indicador(id);


--
-- Name: tbl_linea_base_datos tbl_linea_base_datos_id_linea_base_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY banco_indicadores.tbl_linea_base_datos
    ADD CONSTRAINT tbl_linea_base_datos_id_linea_base_fkey FOREIGN KEY (id_linea_base) REFERENCES banco_indicadores.tbl_linea_base(id);


--
-- Name: tbl_linea_base_datos tbl_linea_base_datos_id_nivel_territorial_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY banco_indicadores.tbl_linea_base_datos
    ADD CONSTRAINT tbl_linea_base_datos_id_nivel_territorial_fkey FOREIGN KEY (id_nivel_territorial) REFERENCES banco_indicadores.tbl_nivel_territorial(id);


--
-- Name: tbl_linea_base tbl_linea_base_id_indicador_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY banco_indicadores.tbl_linea_base
    ADD CONSTRAINT tbl_linea_base_id_indicador_fkey FOREIGN KEY (id_indicador) REFERENCES banco_indicadores.tbl_indicador(id);


--
-- Name: tbl_linea_base_nivel_territorial tbl_linea_base_nivel_territorial_id_linea_base_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY banco_indicadores.tbl_linea_base_nivel_territorial
    ADD CONSTRAINT tbl_linea_base_nivel_territorial_id_linea_base_fkey FOREIGN KEY (id_linea_base) REFERENCES banco_indicadores.tbl_linea_base(id);


--
-- Name: tbl_referencia_bibliografica tbl_referencia_bibliografica_id_indicador_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY banco_indicadores.tbl_referencia_bibliografica
    ADD CONSTRAINT tbl_referencia_bibliografica_id_indicador_fkey FOREIGN KEY (id_indicador) REFERENCES banco_indicadores.tbl_indicador(id);


--
-- Name: tbl_serie_historica tbl_serie_historica_id_indicador_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY banco_indicadores.tbl_serie_historica
    ADD CONSTRAINT tbl_serie_historica_id_indicador_fkey FOREIGN KEY (id_indicador) REFERENCES banco_indicadores.tbl_indicador(id);


--
-- Name: tbl_serie_historica tbl_serie_historica_id_nivel_territorial_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY banco_indicadores.tbl_serie_historica
    ADD CONSTRAINT tbl_serie_historica_id_nivel_territorial_fkey FOREIGN KEY (id_nivel_territorial) REFERENCES banco_indicadores.tbl_nivel_territorial(id);


--
-- PostgreSQL database dump complete
--

