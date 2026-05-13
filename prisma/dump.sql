--
-- PostgreSQL database dump
--

-- Dumped from database version 14.7 (Debian 14.7-1.pgdg110+1)
-- Dumped by pg_dump version 17.0

-- Started on 2026-05-11 17:07:49

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 5 (class 2615 OID 66591)
-- Name: core; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA core;


--
-- TOC entry 6 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

-- *not* creating schema, since initdb creates it


--
-- TOC entry 972 (class 1247 OID 66593)
-- Name: enum_user_types_user_type_form; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.enum_user_types_user_type_form AS ENUM (
    'consignee',
    'shipper',
    'operator',
    'regulator',
    'visitor',
    'disperindag',
    'kemendag',
    'kementan',
    'disnak',
    'ksop'
);


--
-- TOC entry 975 (class 1247 OID 66614)
-- Name: enum_users_user_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.enum_users_user_status AS ENUM (
    'waiting',
    'approved',
    'rejected'
);


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 210 (class 1259 OID 66621)
-- Name: t_mtr_icon; Type: TABLE; Schema: core; Owner: -
--

CREATE TABLE core.t_mtr_icon (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    status smallint DEFAULT 1 NOT NULL,
    server_id character varying(2) DEFAULT '00'::character varying,
    id_trx bigint
);


--
-- TOC entry 211 (class 1259 OID 66626)
-- Name: t_mtr_icon_id_seq; Type: SEQUENCE; Schema: core; Owner: -
--

CREATE SEQUENCE core.t_mtr_icon_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4105 (class 0 OID 0)
-- Dependencies: 211
-- Name: t_mtr_icon_id_seq; Type: SEQUENCE OWNED BY; Schema: core; Owner: -
--

ALTER SEQUENCE core.t_mtr_icon_id_seq OWNED BY core.t_mtr_icon.id;


--
-- TOC entry 212 (class 1259 OID 66627)
-- Name: t_mtr_menu_id_seq; Type: SEQUENCE; Schema: core; Owner: -
--

CREATE SEQUENCE core.t_mtr_menu_id_seq
    START WITH 154
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 213 (class 1259 OID 66628)
-- Name: t_mtr_menu; Type: TABLE; Schema: core; Owner: -
--

CREATE TABLE core.t_mtr_menu (
    id integer DEFAULT nextval('core.t_mtr_menu_id_seq'::regclass) NOT NULL,
    parent integer,
    name character varying(100) NOT NULL,
    icon character varying(100) DEFAULT NULL::character varying,
    slug character varying(100) DEFAULT NULL::character varying,
    number smallint NOT NULL,
    status smallint DEFAULT 1 NOT NULL,
    created_by character varying(100) DEFAULT NULL::character varying,
    created_on timestamp(6) without time zone,
    updated_by character varying(100) DEFAULT NULL::character varying,
    updated_on timestamp(6) without time zone,
    server_id character varying(2) DEFAULT '00'::character varying,
    id_trx bigint
);


--
-- TOC entry 214 (class 1259 OID 66640)
-- Name: t_mtr_menu_action; Type: TABLE; Schema: core; Owner: -
--

CREATE TABLE core.t_mtr_menu_action (
    id integer NOT NULL,
    action_name character varying(20) NOT NULL,
    status smallint DEFAULT 1 NOT NULL,
    created_by character varying(100) NOT NULL,
    created_on timestamp(6) without time zone DEFAULT now(),
    updated_by character varying(100),
    updated_on timestamp(6) without time zone,
    server_id character varying(2) DEFAULT '00'::character varying,
    id_trx bigint
);


--
-- TOC entry 215 (class 1259 OID 66646)
-- Name: t_mtr_menu_action_id_seq; Type: SEQUENCE; Schema: core; Owner: -
--

CREATE SEQUENCE core.t_mtr_menu_action_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4106 (class 0 OID 0)
-- Dependencies: 215
-- Name: t_mtr_menu_action_id_seq; Type: SEQUENCE OWNED BY; Schema: core; Owner: -
--

ALTER SEQUENCE core.t_mtr_menu_action_id_seq OWNED BY core.t_mtr_menu_action.id;


--
-- TOC entry 216 (class 1259 OID 66647)
-- Name: t_mtr_menu_detail_web; Type: TABLE; Schema: core; Owner: -
--

CREATE TABLE core.t_mtr_menu_detail_web (
    id integer NOT NULL,
    menu_id integer NOT NULL,
    action_id integer NOT NULL,
    status smallint DEFAULT 1 NOT NULL,
    created_by character varying(100) NOT NULL,
    created_on timestamp(6) without time zone DEFAULT now(),
    updated_by character varying(100),
    updated_on timestamp(6) without time zone,
    server_id character varying(2) DEFAULT '00'::character varying,
    id_trx bigint
);


--
-- TOC entry 217 (class 1259 OID 66653)
-- Name: t_mtr_menu_detail_web_id_seq; Type: SEQUENCE; Schema: core; Owner: -
--

CREATE SEQUENCE core.t_mtr_menu_detail_web_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4107 (class 0 OID 0)
-- Dependencies: 217
-- Name: t_mtr_menu_detail_web_id_seq; Type: SEQUENCE OWNED BY; Schema: core; Owner: -
--

ALTER SEQUENCE core.t_mtr_menu_detail_web_id_seq OWNED BY core.t_mtr_menu_detail_web.id;


--
-- TOC entry 218 (class 1259 OID 66654)
-- Name: t_mtr_menu_web; Type: TABLE; Schema: core; Owner: -
--

CREATE TABLE core.t_mtr_menu_web (
    id integer NOT NULL,
    parent_id integer,
    name character varying(50) NOT NULL,
    icon character varying(50),
    slug character varying(50),
    "order" smallint NOT NULL,
    status smallint DEFAULT 1 NOT NULL,
    created_by character varying(100) NOT NULL,
    created_on timestamp(6) without time zone DEFAULT now(),
    updated_by character varying(100),
    updated_on timestamp(6) without time zone,
    server_id character varying(2) DEFAULT '00'::character varying,
    id_trx bigint
);


--
-- TOC entry 219 (class 1259 OID 66660)
-- Name: t_mtr_menu_web_id_seq; Type: SEQUENCE; Schema: core; Owner: -
--

CREATE SEQUENCE core.t_mtr_menu_web_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4108 (class 0 OID 0)
-- Dependencies: 219
-- Name: t_mtr_menu_web_id_seq; Type: SEQUENCE OWNED BY; Schema: core; Owner: -
--

ALTER SEQUENCE core.t_mtr_menu_web_id_seq OWNED BY core.t_mtr_menu_web.id;


--
-- TOC entry 220 (class 1259 OID 66661)
-- Name: t_mtr_privilege_id_seq; Type: SEQUENCE; Schema: core; Owner: -
--

CREATE SEQUENCE core.t_mtr_privilege_id_seq
    START WITH 30
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 221 (class 1259 OID 66662)
-- Name: t_mtr_privilege; Type: TABLE; Schema: core; Owner: -
--

CREATE TABLE core.t_mtr_privilege (
    id integer DEFAULT nextval('core.t_mtr_privilege_id_seq'::regclass) NOT NULL,
    group_id integer NOT NULL,
    privilege_name character varying(100) NOT NULL,
    privilege_desc text,
    status smallint DEFAULT 1 NOT NULL,
    created_by character varying(100) DEFAULT NULL::character varying,
    created_on timestamp(6) without time zone,
    updated_by character varying(100) DEFAULT NULL::character varying,
    updated_on timestamp(6) without time zone,
    server_id character varying(2) DEFAULT '00'::character varying,
    id_trx bigint
);


--
-- TOC entry 222 (class 1259 OID 66672)
-- Name: t_mtr_privilege_detail_id_seq; Type: SEQUENCE; Schema: core; Owner: -
--

CREATE SEQUENCE core.t_mtr_privilege_detail_id_seq
    START WITH 71
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 223 (class 1259 OID 66673)
-- Name: t_mtr_privilege_detail; Type: TABLE; Schema: core; Owner: -
--

CREATE TABLE core.t_mtr_privilege_detail (
    id integer DEFAULT nextval('core.t_mtr_privilege_detail_id_seq'::regclass) NOT NULL,
    privilege_id integer NOT NULL,
    menu_id integer NOT NULL,
    view boolean DEFAULT false NOT NULL,
    add boolean DEFAULT false NOT NULL,
    edit boolean DEFAULT false NOT NULL,
    delete boolean DEFAULT false NOT NULL,
    detail boolean DEFAULT false NOT NULL,
    approval boolean DEFAULT false NOT NULL,
    status smallint DEFAULT 1 NOT NULL,
    created_by character varying(100) DEFAULT NULL::character varying,
    created_on timestamp(6) without time zone,
    updated_by character varying(100) DEFAULT NULL::character varying,
    updated_on timestamp(6) without time zone,
    server_id character varying(2) DEFAULT '00'::character varying,
    id_trx bigint
);


--
-- TOC entry 224 (class 1259 OID 66687)
-- Name: t_mtr_privilege_web; Type: TABLE; Schema: core; Owner: -
--

CREATE TABLE core.t_mtr_privilege_web (
    id integer NOT NULL,
    user_group_id smallint NOT NULL,
    menu_id integer NOT NULL,
    menu_detail_id integer NOT NULL,
    status smallint DEFAULT 1 NOT NULL,
    created_by character varying(100) NOT NULL,
    created_on timestamp(6) without time zone DEFAULT now(),
    updated_by character varying(100),
    updated_on timestamp(6) without time zone,
    server_id character varying(2) DEFAULT '00'::character varying,
    id_trx bigint
);


--
-- TOC entry 225 (class 1259 OID 66693)
-- Name: t_mtr_privilege_web_id_seq; Type: SEQUENCE; Schema: core; Owner: -
--

CREATE SEQUENCE core.t_mtr_privilege_web_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4109 (class 0 OID 0)
-- Dependencies: 225
-- Name: t_mtr_privilege_web_id_seq; Type: SEQUENCE OWNED BY; Schema: core; Owner: -
--

ALTER SEQUENCE core.t_mtr_privilege_web_id_seq OWNED BY core.t_mtr_privilege_web.id;


--
-- TOC entry 226 (class 1259 OID 66694)
-- Name: t_mtr_team_code_seq; Type: SEQUENCE; Schema: core; Owner: -
--

CREATE SEQUENCE core.t_mtr_team_code_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 227 (class 1259 OID 66695)
-- Name: t_mtr_user_id_seq; Type: SEQUENCE; Schema: core; Owner: -
--

CREATE SEQUENCE core.t_mtr_user_id_seq
    START WITH 154
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 228 (class 1259 OID 66696)
-- Name: t_mtr_user; Type: TABLE; Schema: core; Owner: -
--

CREATE TABLE core.t_mtr_user (
    id integer DEFAULT nextval('core.t_mtr_user_id_seq'::regclass) NOT NULL,
    username character varying(100),
    password character varying(255) NOT NULL,
    first_name character varying(50),
    last_name character varying(50),
    phone character varying(20),
    email character varying(254),
    last_login timestamp(6) without time zone,
    status smallint DEFAULT 1,
    created_by character varying(100) NOT NULL,
    created_on timestamp(6) without time zone DEFAULT now(),
    updated_by character varying(100),
    updated_on timestamp(6) without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone,
    user_group_id integer,
    port_id smallint,
    admin_pannel_login boolean,
    pos_login boolean,
    validator_login boolean,
    e_ktp_reader_login boolean,
    cs_login boolean,
    server_id character varying(2) DEFAULT '00'::character varying,
    id_trx bigint,
    ship_class_id smallint
);


--
-- TOC entry 229 (class 1259 OID 66706)
-- Name: t_mtr_user_group_id_seq; Type: SEQUENCE; Schema: core; Owner: -
--

CREATE SEQUENCE core.t_mtr_user_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 230 (class 1259 OID 66707)
-- Name: t_mtr_user_group; Type: TABLE; Schema: core; Owner: -
--

CREATE TABLE core.t_mtr_user_group (
    id integer DEFAULT nextval('core.t_mtr_user_group_id_seq'::regclass) NOT NULL,
    name character varying(100) NOT NULL,
    status smallint DEFAULT 1,
    created_by character varying(100) NOT NULL,
    created_on timestamp(6) without time zone,
    updated_by character varying(100),
    updated_on timestamp(6) without time zone,
    server_id character varying(2) DEFAULT '00'::character varying,
    id_trx bigint
);


--
-- TOC entry 231 (class 1259 OID 66713)
-- Name: t_trx_email_attachment_id_seq; Type: SEQUENCE; Schema: core; Owner: -
--

CREATE SEQUENCE core.t_trx_email_attachment_id_seq
    START WITH 71
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 232 (class 1259 OID 66714)
-- Name: t_trx_email_bcc_id_seq; Type: SEQUENCE; Schema: core; Owner: -
--

CREATE SEQUENCE core.t_trx_email_bcc_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 233 (class 1259 OID 66715)
-- Name: t_trx_email_cc_id_seq; Type: SEQUENCE; Schema: core; Owner: -
--

CREATE SEQUENCE core.t_trx_email_cc_id_seq
    START WITH 3
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 234 (class 1259 OID 66716)
-- Name: t_trx_email_id_seq; Type: SEQUENCE; Schema: core; Owner: -
--

CREATE SEQUENCE core.t_trx_email_id_seq
    START WITH 82
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 235 (class 1259 OID 66717)
-- Name: SequelizeMeta; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."SequelizeMeta" (
    name character varying(255) NOT NULL
);


--
-- TOC entry 236 (class 1259 OID 66720)
-- Name: acls; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acls (
    id integer NOT NULL,
    user_type_id integer,
    actions_action_id integer,
    acl_allowed boolean,
    "createdAt" timestamp with time zone DEFAULT '2020-09-04 13:46:13.39+07'::timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone DEFAULT '2020-09-04 13:46:13.39+07'::timestamp with time zone NOT NULL
);


--
-- TOC entry 237 (class 1259 OID 66725)
-- Name: acls_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.acls_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4110 (class 0 OID 0)
-- Dependencies: 237
-- Name: acls_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.acls_id_seq OWNED BY public.acls.id;


--
-- TOC entry 238 (class 1259 OID 66726)
-- Name: actions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.actions (
    id integer NOT NULL,
    action_name character varying(255),
    action_key character varying(255),
    modules_module_id integer,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


--
-- TOC entry 239 (class 1259 OID 66731)
-- Name: actions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.actions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4111 (class 0 OID 0)
-- Dependencies: 239
-- Name: actions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.actions_id_seq OWNED BY public.actions.id;


--
-- TOC entry 240 (class 1259 OID 66732)
-- Name: activity_logs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.activity_logs (
    id integer NOT NULL,
    users_id integer,
    activity_log_action character varying(255),
    activity_log_data character varying(255),
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "deletedAt" timestamp with time zone
);


--
-- TOC entry 241 (class 1259 OID 66737)
-- Name: activity_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.activity_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4112 (class 0 OID 0)
-- Dependencies: 241
-- Name: activity_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.activity_logs_id_seq OWNED BY public.activity_logs.id;


--
-- TOC entry 242 (class 1259 OID 66738)
-- Name: animal_type_rates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.animal_type_rates (
    id integer NOT NULL,
    animal_type_id integer,
    trayek_id integer,
    animal_type_rates numeric(60,0),
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "deletedAt" timestamp with time zone
);


--
-- TOC entry 243 (class 1259 OID 66741)
-- Name: animal_type_rates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.animal_type_rates_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4113 (class 0 OID 0)
-- Dependencies: 243
-- Name: animal_type_rates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.animal_type_rates_id_seq OWNED BY public.animal_type_rates.id;


--
-- TOC entry 244 (class 1259 OID 66742)
-- Name: animal_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.animal_types (
    id integer NOT NULL,
    animal_type_name character varying(255),
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "deletedAt" timestamp with time zone
);


--
-- TOC entry 245 (class 1259 OID 66745)
-- Name: animal_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.animal_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4114 (class 0 OID 0)
-- Dependencies: 245
-- Name: animal_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.animal_types_id_seq OWNED BY public.animal_types.id;


--
-- TOC entry 246 (class 1259 OID 66746)
-- Name: animals; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.animals (
    id integer NOT NULL,
    animal_name character varying(255),
    animal_type_id integer,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "deletedAt" timestamp with time zone
);


--
-- TOC entry 247 (class 1259 OID 66749)
-- Name: animals_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.animals_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4115 (class 0 OID 0)
-- Dependencies: 247
-- Name: animals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.animals_id_seq OWNED BY public.animals.id;


--
-- TOC entry 248 (class 1259 OID 66750)
-- Name: bank_accounts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.bank_accounts (
    id integer NOT NULL,
    users_user_id integer,
    bank_account_bank character varying(255),
    bank_account_number character varying(255),
    bank_account_name character varying(255),
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


--
-- TOC entry 249 (class 1259 OID 66755)
-- Name: bank_accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.bank_accounts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4116 (class 0 OID 0)
-- Dependencies: 249
-- Name: bank_accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.bank_accounts_id_seq OWNED BY public.bank_accounts.id;


--
-- TOC entry 250 (class 1259 OID 66756)
-- Name: berita_acaras; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.berita_acaras (
    id smallint NOT NULL,
    tipe_berita_acara smallint,
    id_jadwal_kapal smallint,
    id_dokter smallint,
    tanggal_upload timestamp with time zone,
    filename character varying,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    status smallint DEFAULT 1,
    tanggal_selesai_pemeriksaan timestamp with time zone,
    "deletedAt" timestamp with time zone
);


--
-- TOC entry 251 (class 1259 OID 66762)
-- Name: berita_acaras_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.berita_acaras_id_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4117 (class 0 OID 0)
-- Dependencies: 251
-- Name: berita_acaras_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.berita_acaras_id_seq OWNED BY public.berita_acaras.id;


--
-- TOC entry 252 (class 1259 OID 66763)
-- Name: booking_news; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.booking_news (
    id integer NOT NULL,
    booking_code character varying(255),
    booking_plan_id integer,
    booking_quarantine_doc character varying(255),
    quarantine_upload_time timestamp with time zone DEFAULT '2024-02-23 14:24:22.404+07'::timestamp with time zone,
    health_certificate_doc character varying(255),
    health_certificate_upload_time timestamp with time zone DEFAULT '2024-02-23 14:24:22.405+07'::timestamp with time zone,
    payment_channel_id integer,
    payment_doc character varying(255),
    payment_time timestamp with time zone,
    total_payment integer,
    status_code integer,
    status_name character varying(255),
    created_by integer,
    updated_by integer,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "deletedAt" timestamp with time zone
);


--
-- TOC entry 253 (class 1259 OID 66770)
-- Name: booking_news_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.booking_news_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4118 (class 0 OID 0)
-- Dependencies: 253
-- Name: booking_news_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.booking_news_id_seq OWNED BY public.booking_news.id;


--
-- TOC entry 254 (class 1259 OID 66771)
-- Name: booking_plan_details; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.booking_plan_details (
    id integer NOT NULL,
    booking_plan_id integer,
    animal_id integer,
    animal_name character varying(255),
    quota_request integer,
    quota_approved integer,
    vessel_room_id integer,
    vessel_cattle_room_id integer,
    vessel_cattle_room_code character varying(255),
    schedule_rates integer,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "deletedAt" timestamp with time zone,
    schedule_quota_id integer,
    schedule_rates_id integer,
    status_code integer,
    status_name character varying
);


--
-- TOC entry 255 (class 1259 OID 66776)
-- Name: booking_plan_details_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.booking_plan_details_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4119 (class 0 OID 0)
-- Dependencies: 255
-- Name: booking_plan_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.booking_plan_details_id_seq OWNED BY public.booking_plan_details.id;


--
-- TOC entry 256 (class 1259 OID 66777)
-- Name: booking_plan_documents; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.booking_plan_documents (
    id integer NOT NULL,
    booking_plan_id integer,
    document character varying(255),
    document_name character varying(255),
    document_nomor character varying(255),
    document_date timestamp with time zone,
    status_code integer,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "deletedAt" timestamp with time zone,
    status_name character varying(255)
);


--
-- TOC entry 257 (class 1259 OID 66782)
-- Name: booking_plan_documents_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.booking_plan_documents_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4120 (class 0 OID 0)
-- Dependencies: 257
-- Name: booking_plan_documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.booking_plan_documents_id_seq OWNED BY public.booking_plan_documents.id;


--
-- TOC entry 258 (class 1259 OID 66784)
-- Name: booking_plan_kleders; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.booking_plan_kleders (
    id integer NOT NULL,
    booking_plan_id integer,
    kleder_name character varying,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "deletedAt" timestamp with time zone
);


--
-- TOC entry 259 (class 1259 OID 66789)
-- Name: booking_plan_kleders_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.booking_plan_kleders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4121 (class 0 OID 0)
-- Dependencies: 259
-- Name: booking_plan_kleders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.booking_plan_kleders_id_seq OWNED BY public.booking_plan_kleders.id;


--
-- TOC entry 260 (class 1259 OID 66790)
-- Name: booking_plan_statuses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.booking_plan_statuses (
    id integer NOT NULL,
    booking_plan_status_name character varying(255),
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


--
-- TOC entry 261 (class 1259 OID 66793)
-- Name: booking_plan_statuses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.booking_plan_statuses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4122 (class 0 OID 0)
-- Dependencies: 261
-- Name: booking_plan_statuses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.booking_plan_statuses_id_seq OWNED BY public.booking_plan_statuses.id;


--
-- TOC entry 262 (class 1259 OID 66794)
-- Name: booking_plans; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.booking_plans (
    id integer NOT NULL,
    booking_plan_code character varying(255),
    shipper_id integer,
    shipper_name character varying(255),
    consignee_id integer,
    consignee_name character varying(255),
    operator_id integer,
    operator_name character varying(255),
    origin character varying(255),
    destination character varying(255),
    trayek_id integer,
    trayek character varying(255),
    schedule_id integer,
    schedule_eta character varying(255),
    schedule_etd character varying(255),
    schedule_ata character varying(255),
    schedule_atd character varying(255),
    doctor_name character varying(255),
    vessel_id integer,
    vessel_name character varying(255),
    animal_category_id integer,
    animal_category_name character varying(255),
    animal_type_id integer,
    animal_type_name character varying(255),
    status_name character varying(255),
    status_code integer,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "deletedAt" timestamp with time zone,
    voyage integer,
    updated_by integer,
    is_booked boolean DEFAULT false
);


--
-- TOC entry 263 (class 1259 OID 66800)
-- Name: booking_plans_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.booking_plans_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4123 (class 0 OID 0)
-- Dependencies: 263
-- Name: booking_plans_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.booking_plans_id_seq OWNED BY public.booking_plans.id;


--
-- TOC entry 264 (class 1259 OID 66801)
-- Name: booking_statuses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.booking_statuses (
    id integer NOT NULL,
    booking_status_name character varying(255),
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


--
-- TOC entry 265 (class 1259 OID 66804)
-- Name: booking_statuses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.booking_statuses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4124 (class 0 OID 0)
-- Dependencies: 265
-- Name: booking_statuses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.booking_statuses_id_seq OWNED BY public.booking_statuses.id;


--
-- TOC entry 266 (class 1259 OID 66805)
-- Name: bookings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.bookings (
    id integer NOT NULL,
    booking_code character varying(255),
    booking_status_id integer,
    schedule_id integer,
    shipper_id integer,
    booking_request_quota integer,
    booking_approved_quota integer,
    schedule_quota_id integer,
    user_consignee_id integer,
    animal_type_id integer,
    animal_id integer,
    booking_description character varying(255),
    booking_quarantine_number character varying(255),
    booking_quarantine_date timestamp with time zone,
    booking_quarantine_file character varying(255),
    booking_livestock_number character varying(255),
    booking_livestock_date timestamp with time zone,
    booking_livestock_file character varying(255),
    booking_payment_due_date timestamp with time zone,
    booking_payment_file character varying(255),
    booking_payment_date date,
    booking_bl_number character varying(255),
    booking_si_number character varying(255),
    booking_ro_number character varying(255),
    booking_shipper_taker_name character varying(255),
    booking_shipper_taker_date date,
    booking_shipper_taker_identity character varying(255),
    booking_consignee_taker_name character varying(255),
    booking_consignee_taker_date date,
    booking_consignee_taker_identity character varying(255),
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "deletedAt" timestamp with time zone,
    operator_id_validasi integer,
    validasi_date timestamp(6) with time zone,
    disnak_id_validasi integer,
    validasi_disnak_date timestamp(6) with time zone,
    alasan character varying,
    status_harga integer DEFAULT 2 NOT NULL,
    id_payment_channel integer,
    status_bayar character(1) DEFAULT 'N'::bpchar,
    expired_date timestamp with time zone,
    bukti_bayar timestamp with time zone,
    booking_plan_id integer,
    total_payment integer,
    created_by integer,
    health_certificate_number character varying,
    health_certificate_date timestamp with time zone,
    health_certificate_file character varying,
    validate_qr_by integer,
    validate_qr_date timestamp with time zone,
    is_valid_health_certificate boolean,
    total_payment_fix integer,
    is_new_bispro boolean,
    weight_total integer DEFAULT 0
);


--
-- TOC entry 267 (class 1259 OID 66813)
-- Name: bookings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.bookings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4125 (class 0 OID 0)
-- Dependencies: 267
-- Name: bookings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.bookings_id_seq OWNED BY public.bookings.id;


--
-- TOC entry 268 (class 1259 OID 66814)
-- Name: cities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cities (
    id integer NOT NULL,
    city_name character varying(255),
    provinces_province_id integer,
    "createdAt" timestamp with time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp with time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 269 (class 1259 OID 66819)
-- Name: cities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.cities_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4126 (class 0 OID 0)
-- Dependencies: 269
-- Name: cities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.cities_id_seq OWNED BY public.cities.id;


--
-- TOC entry 270 (class 1259 OID 66820)
-- Name: custom_params; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.custom_params (
    id integer NOT NULL,
    param_value_string character varying,
    param_value_date timestamp without time zone,
    master_custom_params_id integer,
    status integer DEFAULT 1 NOT NULL,
    payment_channel_id integer,
    description text,
    format character varying,
    "createdAt" timestamp with time zone,
    "deletedAt" timestamp with time zone,
    "updatedAt" timestamp with time zone
);


--
-- TOC entry 271 (class 1259 OID 66826)
-- Name: custom_params_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.custom_params_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4127 (class 0 OID 0)
-- Dependencies: 271
-- Name: custom_params_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.custom_params_id_seq OWNED BY public.custom_params.id;


--
-- TOC entry 272 (class 1259 OID 66827)
-- Name: depots; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.depots (
    id integer NOT NULL,
    depot_name character varying(255),
    depot_address character varying(255),
    ports_port_id integer,
    users_operator_id integer,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "deletedAt" timestamp with time zone
);


--
-- TOC entry 273 (class 1259 OID 66832)
-- Name: depots_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.depots_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4128 (class 0 OID 0)
-- Dependencies: 273
-- Name: depots_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.depots_id_seq OWNED BY public.depots.id;


--
-- TOC entry 274 (class 1259 OID 66833)
-- Name: harga_rates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.harga_rates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 275 (class 1259 OID 66834)
-- Name: hc_details; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.hc_details (
    id integer NOT NULL,
    hcc_id integer,
    room_id integer,
    cattle_room_id integer,
    total integer,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "deletedAt" timestamp with time zone
);


--
-- TOC entry 276 (class 1259 OID 66837)
-- Name: hc_details_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.hc_details_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4129 (class 0 OID 0)
-- Dependencies: 276
-- Name: hc_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.hc_details_id_seq OWNED BY public.hc_details.id;


--
-- TOC entry 277 (class 1259 OID 66838)
-- Name: health_certificate_complain_files; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.health_certificate_complain_files (
    id integer NOT NULL,
    booking_id integer,
    berita_acara_file character varying(255),
    refund_payment_file character varying,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "deletedAt" timestamp with time zone
);


--
-- TOC entry 278 (class 1259 OID 66843)
-- Name: health_certificate_complain_files_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.health_certificate_complain_files_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4130 (class 0 OID 0)
-- Dependencies: 278
-- Name: health_certificate_complain_files_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.health_certificate_complain_files_id_seq OWNED BY public.health_certificate_complain_files.id;


--
-- TOC entry 279 (class 1259 OID 66844)
-- Name: health_certificate_complains; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.health_certificate_complains (
    id integer NOT NULL,
    booking_id integer,
    animal_id integer,
    animal_name character varying(255),
    total_harga integer DEFAULT 0,
    description character varying(255),
    created_by integer,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "deletedAt" timestamp with time zone,
    total_animal integer DEFAULT 0
);


--
-- TOC entry 280 (class 1259 OID 66851)
-- Name: health_certificate_complains_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.health_certificate_complains_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4131 (class 0 OID 0)
-- Dependencies: 280
-- Name: health_certificate_complains_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.health_certificate_complains_id_seq OWNED BY public.health_certificate_complains.id;


--
-- TOC entry 281 (class 1259 OID 66852)
-- Name: import_hewans; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.import_hewans (
    id smallint NOT NULL,
    id_dokter integer,
    id_jadwal_kapal integer,
    tgl_waktu_pengecekan timestamp without time zone,
    berat_hewan character varying,
    nomor_hewan character varying,
    kondisi_hewan character varying,
    "createdAt" timestamp with time zone,
    "deletedAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    status smallint DEFAULT 1,
    berat_akhir character varying
);


--
-- TOC entry 282 (class 1259 OID 66858)
-- Name: master_berita_acaras; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.master_berita_acaras (
    id smallint NOT NULL,
    nama character varying,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    status smallint DEFAULT 1,
    "deletedAt" timestamp with time zone
);


--
-- TOC entry 283 (class 1259 OID 66864)
-- Name: master_category_animals; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.master_category_animals (
    id integer NOT NULL,
    id_animal_type integer NOT NULL,
    category_name character varying(100),
    "createdAt" timestamp(0) with time zone,
    "updatedAt" timestamp(0) with time zone,
    "deletedAt" timestamp(0) with time zone
);


--
-- TOC entry 284 (class 1259 OID 66867)
-- Name: master_category_animal_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.master_category_animal_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4132 (class 0 OID 0)
-- Dependencies: 284
-- Name: master_category_animal_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.master_category_animal_id_seq OWNED BY public.master_category_animals.id;


--
-- TOC entry 285 (class 1259 OID 66868)
-- Name: master_categorys; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.master_categorys (
    id integer NOT NULL,
    category_name character varying(100),
    "createdAt" timestamp(0) with time zone,
    "updatedAt" timestamp(0) with time zone,
    "deletedAt" timestamp(0) with time zone
);


--
-- TOC entry 286 (class 1259 OID 66871)
-- Name: master_category_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.master_category_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4133 (class 0 OID 0)
-- Dependencies: 286
-- Name: master_category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.master_category_id_seq OWNED BY public.master_categorys.id;


--
-- TOC entry 287 (class 1259 OID 66872)
-- Name: master_cresidensial_bris; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.master_cresidensial_bris (
    id integer NOT NULL,
    client_id character varying NOT NULL,
    secret_key character varying NOT NULL,
    operator_id integer NOT NULL,
    status integer DEFAULT 1 NOT NULL,
    keterangan character varying,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "deletedAt" timestamp with time zone
);


--
-- TOC entry 288 (class 1259 OID 66878)
-- Name: master_cresidensial_bri_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.master_cresidensial_bri_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4134 (class 0 OID 0)
-- Dependencies: 288
-- Name: master_cresidensial_bri_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.master_cresidensial_bri_id_seq OWNED BY public.master_cresidensial_bris.id;


--
-- TOC entry 289 (class 1259 OID 66879)
-- Name: master_custom_params; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.master_custom_params (
    id integer NOT NULL,
    param_name character varying,
    type character varying,
    status integer DEFAULT 1 NOT NULL,
    "createdaAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "deletedAt" timestamp with time zone
);


--
-- TOC entry 290 (class 1259 OID 66885)
-- Name: master_custom_params_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.master_custom_params_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4135 (class 0 OID 0)
-- Dependencies: 290
-- Name: master_custom_params_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.master_custom_params_id_seq OWNED BY public.master_custom_params.id;


--
-- TOC entry 291 (class 1259 OID 66886)
-- Name: master_dokters; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.master_dokters (
    id bigint NOT NULL,
    nama_dokter character varying,
    surat_ijin_praktek character varying,
    no_hp character varying,
    alamat character varying,
    id_provinsi integer,
    id_kota integer,
    tanggal_lahir date,
    tempat_lahir character varying,
    keterangan character varying,
    created_on timestamp without time zone,
    created_by character varying,
    status smallint,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "deletedAt" timestamp with time zone,
    email character varying,
    operator_id integer
);


--
-- TOC entry 292 (class 1259 OID 66891)
-- Name: master_dokter_id_dokter_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.master_dokter_id_dokter_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4136 (class 0 OID 0)
-- Dependencies: 292
-- Name: master_dokter_id_dokter_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.master_dokter_id_dokter_seq OWNED BY public.master_dokters.id;


--
-- TOC entry 293 (class 1259 OID 66892)
-- Name: master_harga_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.master_harga_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 294 (class 1259 OID 66893)
-- Name: master_kode_trayeks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.master_kode_trayeks (
    id integer NOT NULL,
    trayek_code character varying NOT NULL,
    users_operator_id integer NOT NULL,
    port_origin_id integer NOT NULL,
    port_destination_id integer NOT NULL,
    tahun integer NOT NULL,
    status integer NOT NULL,
    "createdAt" timestamp with time zone DEFAULT now(),
    "updatedAt" timestamp with time zone,
    "deletedAt" timestamp with time zone
);


--
-- TOC entry 295 (class 1259 OID 66899)
-- Name: master_kode_trayeks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.master_kode_trayeks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4137 (class 0 OID 0)
-- Dependencies: 295
-- Name: master_kode_trayeks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.master_kode_trayeks_id_seq OWNED BY public.master_kode_trayeks.id;


--
-- TOC entry 296 (class 1259 OID 66900)
-- Name: master_kontraks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.master_kontraks (
    id integer NOT NULL,
    tgl_awal_kontrak date NOT NULL,
    tgl_expired_kontrak date NOT NULL,
    tahun_kontrak character varying NOT NULL,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    status_kontrak integer NOT NULL,
    status integer DEFAULT 1 NOT NULL,
    nomor_kontrak character varying NOT NULL,
    "deletedAt" timestamp with time zone,
    id_operator integer,
    filename character varying
);


--
-- TOC entry 297 (class 1259 OID 66906)
-- Name: master_kontraks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.master_kontraks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4138 (class 0 OID 0)
-- Dependencies: 297
-- Name: master_kontraks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.master_kontraks_id_seq OWNED BY public.master_kontraks.id;


--
-- TOC entry 298 (class 1259 OID 66907)
-- Name: master_rates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.master_rates (
    id integer NOT NULL,
    master_rates numeric(60,0),
    users_operator_id integer,
    trayek_id integer,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "deletedAt" timestamp with time zone
);


--
-- TOC entry 299 (class 1259 OID 66910)
-- Name: master_rates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.master_rates_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4139 (class 0 OID 0)
-- Dependencies: 299
-- Name: master_rates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.master_rates_id_seq OWNED BY public.master_rates.id;


--
-- TOC entry 300 (class 1259 OID 66911)
-- Name: master_schedules; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.master_schedules (
    id integer NOT NULL,
    master_trayek_id integer,
    vessel_id integer,
    master_voyage_id integer,
    master_schedule_voyage integer,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


--
-- TOC entry 301 (class 1259 OID 66914)
-- Name: master_schedules_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.master_schedules_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4140 (class 0 OID 0)
-- Dependencies: 301
-- Name: master_schedules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.master_schedules_id_seq OWNED BY public.master_schedules.id;


--
-- TOC entry 302 (class 1259 OID 66915)
-- Name: master_surats; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.master_surats (
    id smallint NOT NULL,
    nama_surat character varying,
    nomor_surat character varying,
    tanggal_surat timestamp(6) without time zone,
    filepath character varying,
    id_booking integer,
    "createdAt" timestamp(6) with time zone,
    "updatedAt" timestamp(6) with time zone,
    "deletedAt" timestamp(6) with time zone,
    status character varying
);


--
-- TOC entry 303 (class 1259 OID 66920)
-- Name: master_surat_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.master_surat_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 32767
    CACHE 1;


--
-- TOC entry 4141 (class 0 OID 0)
-- Dependencies: 303
-- Name: master_surat_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.master_surat_id_seq OWNED BY public.master_surats.id;


--
-- TOC entry 304 (class 1259 OID 66921)
-- Name: master_tarif; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.master_tarif (
    id integer DEFAULT nextval('public.master_harga_id_seq'::regclass) NOT NULL,
    port_origin_id integer,
    port_destination_id integer,
    hewan_besar numeric(60,0),
    hewan_kecil numeric(60,0),
    non_ternak numeric(60,0),
    active boolean,
    description character varying,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "deletedAt" timestamp with time zone,
    tahun numeric(4,0)
);


--
-- TOC entry 305 (class 1259 OID 66927)
-- Name: master_trayeks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.master_trayeks (
    id integer NOT NULL,
    master_trayek_code character varying(255),
    users_operator_id integer,
    master_trayek_target integer,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "deletedAt" timestamp with time zone,
    tahun integer,
    status integer,
    id_mst_kode_trayek integer
);


--
-- TOC entry 306 (class 1259 OID 66930)
-- Name: master_trayeks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.master_trayeks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4142 (class 0 OID 0)
-- Dependencies: 306
-- Name: master_trayeks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.master_trayeks_id_seq OWNED BY public.master_trayeks.id;


--
-- TOC entry 307 (class 1259 OID 66931)
-- Name: master_voyages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.master_voyages (
    id integer NOT NULL,
    master_trayek_id integer,
    master_voyage integer,
    master_voyage_year integer,
    master_voyage_target integer,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


--
-- TOC entry 308 (class 1259 OID 66934)
-- Name: master_voyages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.master_voyages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4143 (class 0 OID 0)
-- Dependencies: 308
-- Name: master_voyages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.master_voyages_id_seq OWNED BY public.master_voyages.id;


--
-- TOC entry 309 (class 1259 OID 66935)
-- Name: modules; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.modules (
    id integer NOT NULL,
    module_name character varying(255),
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


--
-- TOC entry 310 (class 1259 OID 66938)
-- Name: modules_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.modules_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4144 (class 0 OID 0)
-- Dependencies: 310
-- Name: modules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.modules_id_seq OWNED BY public.modules.id;


--
-- TOC entry 311 (class 1259 OID 66939)
-- Name: newtable_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.newtable_id_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4145 (class 0 OID 0)
-- Dependencies: 311
-- Name: newtable_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.newtable_id_seq OWNED BY public.import_hewans.id;


--
-- TOC entry 312 (class 1259 OID 66940)
-- Name: newtable_id_seq1; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.newtable_id_seq1
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4146 (class 0 OID 0)
-- Dependencies: 312
-- Name: newtable_id_seq1; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.newtable_id_seq1 OWNED BY public.master_berita_acaras.id;


--
-- TOC entry 313 (class 1259 OID 66941)
-- Name: payment_channels; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.payment_channels (
    id integer NOT NULL,
    payment_channel_name character varying NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    status integer DEFAULT 1,
    "deletedAt" timestamp with time zone,
    "updatedAt" timestamp with time zone
);


--
-- TOC entry 314 (class 1259 OID 66947)
-- Name: payment_channel_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.payment_channel_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4147 (class 0 OID 0)
-- Dependencies: 314
-- Name: payment_channel_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.payment_channel_id_seq OWNED BY public.payment_channels.id;


--
-- TOC entry 315 (class 1259 OID 66948)
-- Name: pengaduan_replies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pengaduan_replies (
    id integer NOT NULL,
    description text,
    user_id integer,
    pengaduan_id integer,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "deletedAt" timestamp with time zone
);


--
-- TOC entry 316 (class 1259 OID 66953)
-- Name: pengaduan_replies_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pengaduan_replies_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4148 (class 0 OID 0)
-- Dependencies: 316
-- Name: pengaduan_replies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pengaduan_replies_id_seq OWNED BY public.pengaduan_replies.id;


--
-- TOC entry 317 (class 1259 OID 66954)
-- Name: pengaduans; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pengaduans (
    id integer NOT NULL,
    user_id integer,
    subject character varying(255),
    description character varying(255),
    "timestamp" timestamp with time zone,
    status_is_open boolean,
    users_operator_id integer,
    users_regulator_id integer,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "deletedAt" timestamp with time zone
);


--
-- TOC entry 318 (class 1259 OID 66959)
-- Name: pengaduans_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pengaduans_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4149 (class 0 OID 0)
-- Dependencies: 318
-- Name: pengaduans_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pengaduans_id_seq OWNED BY public.pengaduans.id;


--
-- TOC entry 319 (class 1259 OID 66960)
-- Name: ports_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 320 (class 1259 OID 66961)
-- Name: ports; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ports (
    id integer DEFAULT nextval('public.ports_id_seq'::regclass) NOT NULL,
    port_name character varying(255),
    port_code character varying(255),
    provinces_province_id integer,
    cities_city_id integer,
    port_long character varying(255),
    port_lat character varying(255),
    "createdAt" timestamp(6) with time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp(6) with time zone DEFAULT now() NOT NULL,
    "deletedAt" timestamp(6) with time zone DEFAULT NULL::timestamp with time zone
);


--
-- TOC entry 321 (class 1259 OID 66970)
-- Name: provinces; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.provinces (
    id integer NOT NULL,
    province_name character varying(255),
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


--
-- TOC entry 322 (class 1259 OID 66973)
-- Name: provinces_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.provinces_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4150 (class 0 OID 0)
-- Dependencies: 322
-- Name: provinces_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.provinces_id_seq OWNED BY public.provinces.id;


--
-- TOC entry 323 (class 1259 OID 66974)
-- Name: revokeds; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.revokeds (
    id integer NOT NULL,
    userid integer,
    issued integer,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


--
-- TOC entry 324 (class 1259 OID 66977)
-- Name: revokeds_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.revokeds_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4151 (class 0 OID 0)
-- Dependencies: 324
-- Name: revokeds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.revokeds_id_seq OWNED BY public.revokeds.id;


--
-- TOC entry 325 (class 1259 OID 66978)
-- Name: ruas_trayeks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ruas_trayeks (
    id integer NOT NULL,
    kode_trayek character varying(255),
    jaringan_trayek character varying(255),
    tahun bigint,
    jarak bigint,
    "createdAt" timestamp(6) without time zone,
    "updatedAt" timestamp(6) without time zone,
    "deletedAt" timestamp(6) without time zone
);


--
-- TOC entry 326 (class 1259 OID 66983)
-- Name: ruas_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ruas_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4152 (class 0 OID 0)
-- Dependencies: 326
-- Name: ruas_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ruas_seq OWNED BY public.ruas_trayeks.id;


--
-- TOC entry 327 (class 1259 OID 66984)
-- Name: schedule_quota; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schedule_quota (
    id integer NOT NULL,
    schedule_id integer,
    animal_type_id integer,
    schedule_quota integer,
    schedule_quota_rest integer,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "deletedAt" timestamp with time zone
);


--
-- TOC entry 328 (class 1259 OID 66987)
-- Name: schedule_quota_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.schedule_quota_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4153 (class 0 OID 0)
-- Dependencies: 328
-- Name: schedule_quota_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.schedule_quota_id_seq OWNED BY public.schedule_quota.id;


--
-- TOC entry 329 (class 1259 OID 66988)
-- Name: schedule_rates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schedule_rates (
    id integer NOT NULL,
    schedule_id integer,
    animal_type_id integer,
    schedule_rates numeric(60,0),
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "deletedAt" timestamp with time zone
);


--
-- TOC entry 330 (class 1259 OID 66991)
-- Name: schedule_rates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.schedule_rates_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4154 (class 0 OID 0)
-- Dependencies: 330
-- Name: schedule_rates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.schedule_rates_id_seq OWNED BY public.schedule_rates.id;


--
-- TOC entry 331 (class 1259 OID 66992)
-- Name: schedules; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schedules (
    id integer NOT NULL,
    trayek_id integer,
    schedule_etd timestamp with time zone,
    schedule_eta timestamp with time zone,
    schedule_atd timestamp with time zone,
    schedule_ata timestamp with time zone,
    schedule_bumn_closing_time timestamp with time zone,
    schedule_swasta_closing_time timestamp with time zone,
    users_operator_id integer,
    depot_id integer,
    master_schedule_id integer,
    schedule_manifest_date timestamp with time zone,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "deletedAt" timestamp with time zone,
    dokter_id integer,
    is_approved integer DEFAULT 3,
    operator_approval_id integer,
    alasan_penolakan character varying,
    filename character varying
);


--
-- TOC entry 4155 (class 0 OID 0)
-- Dependencies: 331
-- Name: COLUMN schedules.is_approved; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.schedules.is_approved IS '3 belum diapaapain,
2 itu di tolak
1 itu di accept
';


--
-- TOC entry 332 (class 1259 OID 66998)
-- Name: schedules_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.schedules_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4156 (class 0 OID 0)
-- Dependencies: 332
-- Name: schedules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.schedules_id_seq OWNED BY public.schedules.id;


--
-- TOC entry 333 (class 1259 OID 66999)
-- Name: set_hargas; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.set_hargas (
    id integer NOT NULL,
    id_booking integer NOT NULL,
    harga integer,
    "createdAt" timestamp(0) with time zone,
    "updatedAt" timestamp(0) with time zone,
    "deletedAt" timestamp(0) with time zone
);


--
-- TOC entry 334 (class 1259 OID 67002)
-- Name: set_harga_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.set_harga_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4157 (class 0 OID 0)
-- Dependencies: 334
-- Name: set_harga_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.set_harga_id_seq OWNED BY public.set_hargas.id;


--
-- TOC entry 335 (class 1259 OID 67003)
-- Name: tarif_rates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tarif_rates (
    id integer DEFAULT nextval('public.harga_rates_id_seq'::regclass) NOT NULL,
    tarif_id integer,
    animal_type_id integer,
    harga numeric(60,0),
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "deletedAt" timestamp with time zone
);


--
-- TOC entry 336 (class 1259 OID 67007)
-- Name: track_logs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.track_logs (
    id integer NOT NULL,
    bookings_id integer,
    track_log_shipper_booking_date timestamp with time zone,
    track_log_operator_date timestamp with time zone,
    track_log_shipper_taker_date timestamp with time zone,
    track_log_consignee_taker_date timestamp with time zone,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


--
-- TOC entry 337 (class 1259 OID 67010)
-- Name: track_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.track_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4158 (class 0 OID 0)
-- Dependencies: 337
-- Name: track_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.track_logs_id_seq OWNED BY public.track_logs.id;


--
-- TOC entry 338 (class 1259 OID 67011)
-- Name: trayeks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.trayeks (
    id integer NOT NULL,
    users_operator_id integer,
    master_trayek_id integer,
    port_origin_id integer,
    port_destination_id integer,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "deletedAt" timestamp with time zone
);


--
-- TOC entry 339 (class 1259 OID 67014)
-- Name: trayeks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.trayeks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4159 (class 0 OID 0)
-- Dependencies: 339
-- Name: trayeks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.trayeks_id_seq OWNED BY public.trayeks.id;


--
-- TOC entry 340 (class 1259 OID 67015)
-- Name: user_profiles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_profiles (
    id integer NOT NULL,
    users_user_id integer,
    user_profile_name character varying(255),
    user_profile_address character varying(255),
    user_profile_phone character varying(255),
    user_profile_fax character varying(255),
    user_profile_email character varying(255),
    user_profile_siup character varying(255),
    user_profile_siup_doc character varying(255),
    user_profile_npwp character varying(255),
    user_profile_npwp_doc character varying(255),
    user_profile_pic_name character varying(255),
    user_profile_pic_email character varying(255),
    user_profile_pic_hp character varying(255),
    user_profile_pic_phone character varying(255),
    user_profile_pic_fax character varying(255),
    user_profile_surat_rekomendasi_pemda character varying(255),
    provinces_province_id integer,
    cities_city_id integer,
    user_profile_person_in_charge character varying(255),
    user_profile_company_type character varying(255),
    user_profile_company_status character varying(255),
    user_profile_signature character varying(255),
    user_profile_company_logo character varying(255),
    user_profile_officer_1_name character varying(255),
    user_profile_officer_1_identity character varying(255),
    user_profile_officer_1_phone character varying(255),
    user_profile_officer_1_identity_pict character varying(255),
    user_profile_officer_2_name character varying(255),
    user_profile_officer_2_identity character varying(255),
    user_profile_officer_2_phone character varying(255),
    user_profile_officer_2_identity_pict character varying(255),
    user_profile_officer_3_name character varying(255),
    user_profile_officer_3_identity character varying(255),
    user_profile_officer_3_phone character varying(255),
    user_profile_officer_3_identity_pict character varying(255),
    user_profile_pmku_number character varying(255),
    user_profile_pmku_date timestamp with time zone,
    user_profile_pob character varying(255),
    user_profile_dob timestamp with time zone,
    user_profile_company_name character varying(255),
    user_profile_position character varying(255),
    user_profile_contract_number character varying(255),
    user_profile_contract_start date,
    user_profile_contract_end date,
    user_profile_contract_adendum character varying(255),
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    virtual_account integer,
    institution_code character varying(15)
);


--
-- TOC entry 341 (class 1259 OID 67020)
-- Name: user_profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_profiles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4160 (class 0 OID 0)
-- Dependencies: 341
-- Name: user_profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_profiles_id_seq OWNED BY public.user_profiles.id;


--
-- TOC entry 342 (class 1259 OID 67021)
-- Name: user_type_ex; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_type_ex (
    id integer NOT NULL,
    usertype character varying(50) NOT NULL
);


--
-- TOC entry 343 (class 1259 OID 67024)
-- Name: user_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_types (
    id integer NOT NULL,
    user_type_name character varying(255),
    user_type_form public.enum_user_types_user_type_form,
    user_type_show_on_register boolean,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


--
-- TOC entry 344 (class 1259 OID 67027)
-- Name: user_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4161 (class 0 OID 0)
-- Dependencies: 344
-- Name: user_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_types_id_seq OWNED BY public.user_types.id;


--
-- TOC entry 345 (class 1259 OID 67028)
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id integer NOT NULL,
    user_email character varying(255),
    user_password character varying(255),
    user_status public.enum_users_user_status,
    user_rejected_reason character varying(255),
    user_type_user_type_id integer,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    status smallint DEFAULT 1
);


--
-- TOC entry 346 (class 1259 OID 67034)
-- Name: users_ex; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users_ex (
    id integer NOT NULL,
    username character varying(255) NOT NULL,
    password character varying(255) NOT NULL,
    status integer NOT NULL,
    user_group_id integer NOT NULL
);


--
-- TOC entry 347 (class 1259 OID 67039)
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4162 (class 0 OID 0)
-- Dependencies: 347
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- TOC entry 348 (class 1259 OID 67040)
-- Name: vessel_cattle_room_schedules; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.vessel_cattle_room_schedules (
    id integer NOT NULL,
    vessel_room_id integer,
    cattle_room_code character varying(255),
    cattle_room_capacity integer,
    available_capacity integer,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "deletedAt" timestamp with time zone
);


--
-- TOC entry 349 (class 1259 OID 67043)
-- Name: vessel_cattle_room_schedules_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.vessel_cattle_room_schedules_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4163 (class 0 OID 0)
-- Dependencies: 349
-- Name: vessel_cattle_room_schedules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.vessel_cattle_room_schedules_id_seq OWNED BY public.vessel_cattle_room_schedules.id;


--
-- TOC entry 350 (class 1259 OID 67044)
-- Name: vessel_cattle_rooms; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.vessel_cattle_rooms (
    id integer NOT NULL,
    vessel_room_id integer,
    cattle_room_code character varying(255),
    cattle_room_capacity integer,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "deletedAt" timestamp with time zone,
    available_capacity integer DEFAULT 0
);


--
-- TOC entry 351 (class 1259 OID 67048)
-- Name: vessel_cattle_rooms_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.vessel_cattle_rooms_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4164 (class 0 OID 0)
-- Dependencies: 351
-- Name: vessel_cattle_rooms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.vessel_cattle_rooms_id_seq OWNED BY public.vessel_cattle_rooms.id;


--
-- TOC entry 352 (class 1259 OID 67049)
-- Name: vessel_room_schedules; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.vessel_room_schedules (
    id integer NOT NULL,
    schedule_id integer,
    master_vessel_room_id integer,
    vessel_id integer,
    room_code character varying(255),
    room_name character varying(255),
    max_room_capacity integer,
    available_max_room_capacity integer,
    url_image character varying(255),
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "deletedAt" timestamp with time zone
);


--
-- TOC entry 353 (class 1259 OID 67054)
-- Name: vessel_room_schedules_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.vessel_room_schedules_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4165 (class 0 OID 0)
-- Dependencies: 353
-- Name: vessel_room_schedules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.vessel_room_schedules_id_seq OWNED BY public.vessel_room_schedules.id;


--
-- TOC entry 354 (class 1259 OID 67055)
-- Name: vessel_rooms; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.vessel_rooms (
    id integer NOT NULL,
    vessel_id integer,
    room_code character varying(255),
    room_name character varying(255),
    max_room_capacity integer,
    url_image character varying(255),
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "deletedAt" timestamp with time zone,
    available_max_room_capacity integer DEFAULT 0
);


--
-- TOC entry 355 (class 1259 OID 67061)
-- Name: vessel_rooms_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.vessel_rooms_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4166 (class 0 OID 0)
-- Dependencies: 355
-- Name: vessel_rooms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.vessel_rooms_id_seq OWNED BY public.vessel_rooms.id;


--
-- TOC entry 356 (class 1259 OID 67062)
-- Name: vessel_trackings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.vessel_trackings (
    id integer NOT NULL,
    date timestamp with time zone,
    name character varying(255),
    lat character varying(255),
    lon character varying(255),
    speed character varying(255),
    heading character varying(255),
    distance character varying(255),
    port character varying(255),
    ior character varying(255),
    ips character varying(255),
    imo character varying(255),
    mmsi character varying(255),
    txid character varying(255),
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "deletedAt" timestamp with time zone
);


--
-- TOC entry 357 (class 1259 OID 67067)
-- Name: vessel_trackings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.vessel_trackings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4167 (class 0 OID 0)
-- Dependencies: 357
-- Name: vessel_trackings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.vessel_trackings_id_seq OWNED BY public.vessel_trackings.id;


--
-- TOC entry 358 (class 1259 OID 67068)
-- Name: vessels; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.vessels (
    id integer NOT NULL,
    vessel_name character varying(255),
    vessel_device_id character varying(255),
    vessel_photo character varying(255),
    users_operator_id integer,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "deletedAt" timestamp with time zone
);


--
-- TOC entry 359 (class 1259 OID 67073)
-- Name: vessels_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.vessels_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4168 (class 0 OID 0)
-- Dependencies: 359
-- Name: vessels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.vessels_id_seq OWNED BY public.vessels.id;


--
-- TOC entry 3541 (class 2604 OID 67074)
-- Name: t_mtr_icon id; Type: DEFAULT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.t_mtr_icon ALTER COLUMN id SET DEFAULT nextval('core.t_mtr_icon_id_seq'::regclass);


--
-- TOC entry 3551 (class 2604 OID 67075)
-- Name: t_mtr_menu_action id; Type: DEFAULT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.t_mtr_menu_action ALTER COLUMN id SET DEFAULT nextval('core.t_mtr_menu_action_id_seq'::regclass);


--
-- TOC entry 3555 (class 2604 OID 67076)
-- Name: t_mtr_menu_detail_web id; Type: DEFAULT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.t_mtr_menu_detail_web ALTER COLUMN id SET DEFAULT nextval('core.t_mtr_menu_detail_web_id_seq'::regclass);


--
-- TOC entry 3559 (class 2604 OID 67077)
-- Name: t_mtr_menu_web id; Type: DEFAULT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.t_mtr_menu_web ALTER COLUMN id SET DEFAULT nextval('core.t_mtr_menu_web_id_seq'::regclass);


--
-- TOC entry 3579 (class 2604 OID 67078)
-- Name: t_mtr_privilege_web id; Type: DEFAULT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.t_mtr_privilege_web ALTER COLUMN id SET DEFAULT nextval('core.t_mtr_privilege_web_id_seq'::regclass);


--
-- TOC entry 3591 (class 2604 OID 67079)
-- Name: acls id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acls ALTER COLUMN id SET DEFAULT nextval('public.acls_id_seq'::regclass);


--
-- TOC entry 3594 (class 2604 OID 67080)
-- Name: actions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.actions ALTER COLUMN id SET DEFAULT nextval('public.actions_id_seq'::regclass);


--
-- TOC entry 3595 (class 2604 OID 67081)
-- Name: activity_logs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activity_logs ALTER COLUMN id SET DEFAULT nextval('public.activity_logs_id_seq'::regclass);


--
-- TOC entry 3596 (class 2604 OID 67082)
-- Name: animal_type_rates id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.animal_type_rates ALTER COLUMN id SET DEFAULT nextval('public.animal_type_rates_id_seq'::regclass);


--
-- TOC entry 3597 (class 2604 OID 67083)
-- Name: animal_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.animal_types ALTER COLUMN id SET DEFAULT nextval('public.animal_types_id_seq'::regclass);


--
-- TOC entry 3598 (class 2604 OID 67084)
-- Name: animals id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.animals ALTER COLUMN id SET DEFAULT nextval('public.animals_id_seq'::regclass);


--
-- TOC entry 3599 (class 2604 OID 67085)
-- Name: bank_accounts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bank_accounts ALTER COLUMN id SET DEFAULT nextval('public.bank_accounts_id_seq'::regclass);


--
-- TOC entry 3600 (class 2604 OID 67086)
-- Name: berita_acaras id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.berita_acaras ALTER COLUMN id SET DEFAULT nextval('public.berita_acaras_id_seq'::regclass);


--
-- TOC entry 3602 (class 2604 OID 67087)
-- Name: booking_news id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.booking_news ALTER COLUMN id SET DEFAULT nextval('public.booking_news_id_seq'::regclass);


--
-- TOC entry 3605 (class 2604 OID 67088)
-- Name: booking_plan_details id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.booking_plan_details ALTER COLUMN id SET DEFAULT nextval('public.booking_plan_details_id_seq'::regclass);


--
-- TOC entry 3606 (class 2604 OID 67089)
-- Name: booking_plan_documents id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.booking_plan_documents ALTER COLUMN id SET DEFAULT nextval('public.booking_plan_documents_id_seq'::regclass);


--
-- TOC entry 3607 (class 2604 OID 67090)
-- Name: booking_plan_kleders id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.booking_plan_kleders ALTER COLUMN id SET DEFAULT nextval('public.booking_plan_kleders_id_seq'::regclass);


--
-- TOC entry 3608 (class 2604 OID 67091)
-- Name: booking_plan_statuses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.booking_plan_statuses ALTER COLUMN id SET DEFAULT nextval('public.booking_plan_statuses_id_seq'::regclass);


--
-- TOC entry 3609 (class 2604 OID 67092)
-- Name: booking_plans id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.booking_plans ALTER COLUMN id SET DEFAULT nextval('public.booking_plans_id_seq'::regclass);


--
-- TOC entry 3611 (class 2604 OID 67093)
-- Name: booking_statuses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.booking_statuses ALTER COLUMN id SET DEFAULT nextval('public.booking_statuses_id_seq'::regclass);


--
-- TOC entry 3612 (class 2604 OID 67094)
-- Name: bookings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bookings ALTER COLUMN id SET DEFAULT nextval('public.bookings_id_seq'::regclass);


--
-- TOC entry 3616 (class 2604 OID 67095)
-- Name: cities id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cities ALTER COLUMN id SET DEFAULT nextval('public.cities_id_seq'::regclass);


--
-- TOC entry 3619 (class 2604 OID 67096)
-- Name: custom_params id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.custom_params ALTER COLUMN id SET DEFAULT nextval('public.custom_params_id_seq'::regclass);


--
-- TOC entry 3621 (class 2604 OID 67097)
-- Name: depots id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.depots ALTER COLUMN id SET DEFAULT nextval('public.depots_id_seq'::regclass);


--
-- TOC entry 3622 (class 2604 OID 67098)
-- Name: hc_details id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hc_details ALTER COLUMN id SET DEFAULT nextval('public.hc_details_id_seq'::regclass);


--
-- TOC entry 3623 (class 2604 OID 67099)
-- Name: health_certificate_complain_files id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.health_certificate_complain_files ALTER COLUMN id SET DEFAULT nextval('public.health_certificate_complain_files_id_seq'::regclass);


--
-- TOC entry 3624 (class 2604 OID 67100)
-- Name: health_certificate_complains id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.health_certificate_complains ALTER COLUMN id SET DEFAULT nextval('public.health_certificate_complains_id_seq'::regclass);


--
-- TOC entry 3627 (class 2604 OID 67101)
-- Name: import_hewans id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.import_hewans ALTER COLUMN id SET DEFAULT nextval('public.newtable_id_seq'::regclass);


--
-- TOC entry 3629 (class 2604 OID 67102)
-- Name: master_berita_acaras id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.master_berita_acaras ALTER COLUMN id SET DEFAULT nextval('public.newtable_id_seq1'::regclass);


--
-- TOC entry 3631 (class 2604 OID 67103)
-- Name: master_category_animals id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.master_category_animals ALTER COLUMN id SET DEFAULT nextval('public.master_category_animal_id_seq'::regclass);


--
-- TOC entry 3632 (class 2604 OID 67104)
-- Name: master_categorys id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.master_categorys ALTER COLUMN id SET DEFAULT nextval('public.master_category_id_seq'::regclass);


--
-- TOC entry 3633 (class 2604 OID 67105)
-- Name: master_cresidensial_bris id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.master_cresidensial_bris ALTER COLUMN id SET DEFAULT nextval('public.master_cresidensial_bri_id_seq'::regclass);


--
-- TOC entry 3635 (class 2604 OID 67106)
-- Name: master_custom_params id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.master_custom_params ALTER COLUMN id SET DEFAULT nextval('public.master_custom_params_id_seq'::regclass);


--
-- TOC entry 3637 (class 2604 OID 67107)
-- Name: master_dokters id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.master_dokters ALTER COLUMN id SET DEFAULT nextval('public.master_dokter_id_dokter_seq'::regclass);


--
-- TOC entry 3638 (class 2604 OID 67108)
-- Name: master_kode_trayeks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.master_kode_trayeks ALTER COLUMN id SET DEFAULT nextval('public.master_kode_trayeks_id_seq'::regclass);


--
-- TOC entry 3640 (class 2604 OID 67109)
-- Name: master_kontraks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.master_kontraks ALTER COLUMN id SET DEFAULT nextval('public.master_kontraks_id_seq'::regclass);


--
-- TOC entry 3642 (class 2604 OID 67110)
-- Name: master_rates id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.master_rates ALTER COLUMN id SET DEFAULT nextval('public.master_rates_id_seq'::regclass);


--
-- TOC entry 3643 (class 2604 OID 67111)
-- Name: master_schedules id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.master_schedules ALTER COLUMN id SET DEFAULT nextval('public.master_schedules_id_seq'::regclass);


--
-- TOC entry 3644 (class 2604 OID 67112)
-- Name: master_surats id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.master_surats ALTER COLUMN id SET DEFAULT nextval('public.master_surat_id_seq'::regclass);


--
-- TOC entry 3646 (class 2604 OID 67113)
-- Name: master_trayeks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.master_trayeks ALTER COLUMN id SET DEFAULT nextval('public.master_trayeks_id_seq'::regclass);


--
-- TOC entry 3647 (class 2604 OID 67114)
-- Name: master_voyages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.master_voyages ALTER COLUMN id SET DEFAULT nextval('public.master_voyages_id_seq'::regclass);


--
-- TOC entry 3648 (class 2604 OID 67115)
-- Name: modules id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.modules ALTER COLUMN id SET DEFAULT nextval('public.modules_id_seq'::regclass);


--
-- TOC entry 3649 (class 2604 OID 67116)
-- Name: payment_channels id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payment_channels ALTER COLUMN id SET DEFAULT nextval('public.payment_channel_id_seq'::regclass);


--
-- TOC entry 3651 (class 2604 OID 67117)
-- Name: pengaduan_replies id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pengaduan_replies ALTER COLUMN id SET DEFAULT nextval('public.pengaduan_replies_id_seq'::regclass);


--
-- TOC entry 3652 (class 2604 OID 67118)
-- Name: pengaduans id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pengaduans ALTER COLUMN id SET DEFAULT nextval('public.pengaduans_id_seq'::regclass);


--
-- TOC entry 3657 (class 2604 OID 67119)
-- Name: provinces id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.provinces ALTER COLUMN id SET DEFAULT nextval('public.provinces_id_seq'::regclass);


--
-- TOC entry 3658 (class 2604 OID 67120)
-- Name: revokeds id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.revokeds ALTER COLUMN id SET DEFAULT nextval('public.revokeds_id_seq'::regclass);


--
-- TOC entry 3659 (class 2604 OID 67121)
-- Name: ruas_trayeks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ruas_trayeks ALTER COLUMN id SET DEFAULT nextval('public.ruas_seq'::regclass);


--
-- TOC entry 3660 (class 2604 OID 67122)
-- Name: schedule_quota id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schedule_quota ALTER COLUMN id SET DEFAULT nextval('public.schedule_quota_id_seq'::regclass);


--
-- TOC entry 3661 (class 2604 OID 67123)
-- Name: schedule_rates id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schedule_rates ALTER COLUMN id SET DEFAULT nextval('public.schedule_rates_id_seq'::regclass);


--
-- TOC entry 3662 (class 2604 OID 67124)
-- Name: schedules id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schedules ALTER COLUMN id SET DEFAULT nextval('public.schedules_id_seq'::regclass);


--
-- TOC entry 3664 (class 2604 OID 67125)
-- Name: set_hargas id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.set_hargas ALTER COLUMN id SET DEFAULT nextval('public.set_harga_id_seq'::regclass);


--
-- TOC entry 3666 (class 2604 OID 67126)
-- Name: track_logs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.track_logs ALTER COLUMN id SET DEFAULT nextval('public.track_logs_id_seq'::regclass);


--
-- TOC entry 3667 (class 2604 OID 67127)
-- Name: trayeks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trayeks ALTER COLUMN id SET DEFAULT nextval('public.trayeks_id_seq'::regclass);


--
-- TOC entry 3668 (class 2604 OID 67128)
-- Name: user_profiles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_profiles ALTER COLUMN id SET DEFAULT nextval('public.user_profiles_id_seq'::regclass);


--
-- TOC entry 3669 (class 2604 OID 67129)
-- Name: user_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_types ALTER COLUMN id SET DEFAULT nextval('public.user_types_id_seq'::regclass);


--
-- TOC entry 3670 (class 2604 OID 67130)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- TOC entry 3672 (class 2604 OID 67131)
-- Name: vessel_cattle_room_schedules id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vessel_cattle_room_schedules ALTER COLUMN id SET DEFAULT nextval('public.vessel_cattle_room_schedules_id_seq'::regclass);


--
-- TOC entry 3673 (class 2604 OID 67132)
-- Name: vessel_cattle_rooms id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vessel_cattle_rooms ALTER COLUMN id SET DEFAULT nextval('public.vessel_cattle_rooms_id_seq'::regclass);


--
-- TOC entry 3675 (class 2604 OID 67133)
-- Name: vessel_room_schedules id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vessel_room_schedules ALTER COLUMN id SET DEFAULT nextval('public.vessel_room_schedules_id_seq'::regclass);


--
-- TOC entry 3676 (class 2604 OID 67134)
-- Name: vessel_rooms id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vessel_rooms ALTER COLUMN id SET DEFAULT nextval('public.vessel_rooms_id_seq'::regclass);


--
-- TOC entry 3678 (class 2604 OID 67135)
-- Name: vessel_trackings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vessel_trackings ALTER COLUMN id SET DEFAULT nextval('public.vessel_trackings_id_seq'::regclass);


--
-- TOC entry 3679 (class 2604 OID 67136)
-- Name: vessels id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vessels ALTER COLUMN id SET DEFAULT nextval('public.vessels_id_seq'::regclass);

--
-- TOC entry 3681 (class 2606 OID 67138)
-- Name: t_mtr_icon t_mtr_icon_pkey; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.t_mtr_icon
    ADD CONSTRAINT t_mtr_icon_pkey PRIMARY KEY (id);


--
-- TOC entry 3691 (class 2606 OID 67140)
-- Name: t_mtr_menu_action t_mtr_menu_action_pkey; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.t_mtr_menu_action
    ADD CONSTRAINT t_mtr_menu_action_pkey PRIMARY KEY (id);


--
-- TOC entry 3696 (class 2606 OID 67142)
-- Name: t_mtr_menu_detail_web t_mtr_menu_detail_web_pkey; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.t_mtr_menu_detail_web
    ADD CONSTRAINT t_mtr_menu_detail_web_pkey PRIMARY KEY (id);


--
-- TOC entry 3684 (class 2606 OID 67144)
-- Name: t_mtr_menu t_mtr_menu_pkey; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.t_mtr_menu
    ADD CONSTRAINT t_mtr_menu_pkey PRIMARY KEY (id);


--
-- TOC entry 3700 (class 2606 OID 67146)
-- Name: t_mtr_menu_web t_mtr_menu_web_pkey; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.t_mtr_menu_web
    ADD CONSTRAINT t_mtr_menu_web_pkey PRIMARY KEY (id);


--
-- TOC entry 3705 (class 2606 OID 67148)
-- Name: t_mtr_privilege_detail t_mtr_privilege_detail_pkey; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.t_mtr_privilege_detail
    ADD CONSTRAINT t_mtr_privilege_detail_pkey PRIMARY KEY (id);


--
-- TOC entry 3703 (class 2606 OID 67150)
-- Name: t_mtr_privilege t_mtr_privilege_pkey; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.t_mtr_privilege
    ADD CONSTRAINT t_mtr_privilege_pkey PRIMARY KEY (id);


--
-- TOC entry 3709 (class 2606 OID 67152)
-- Name: t_mtr_privilege_web t_mtr_privilege_web_pkey; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.t_mtr_privilege_web
    ADD CONSTRAINT t_mtr_privilege_web_pkey PRIMARY KEY (id);


--
-- TOC entry 3712 (class 2606 OID 67154)
-- Name: t_mtr_user t_mtr_user_pkey; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.t_mtr_user
    ADD CONSTRAINT t_mtr_user_pkey PRIMARY KEY (id);


--
-- TOC entry 3718 (class 2606 OID 67156)
-- Name: SequelizeMeta SequelizeMeta_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."SequelizeMeta"
    ADD CONSTRAINT "SequelizeMeta_pkey" PRIMARY KEY (name);


--
-- TOC entry 3720 (class 2606 OID 67158)
-- Name: acls acls_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acls
    ADD CONSTRAINT acls_pkey PRIMARY KEY (id);


--
-- TOC entry 3722 (class 2606 OID 67160)
-- Name: actions actions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.actions
    ADD CONSTRAINT actions_pkey PRIMARY KEY (id);


--
-- TOC entry 3724 (class 2606 OID 67162)
-- Name: activity_logs activity_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activity_logs
    ADD CONSTRAINT activity_logs_pkey PRIMARY KEY (id);


--
-- TOC entry 3726 (class 2606 OID 67164)
-- Name: animal_type_rates animal_type_rates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.animal_type_rates
    ADD CONSTRAINT animal_type_rates_pkey PRIMARY KEY (id);


--
-- TOC entry 3728 (class 2606 OID 67166)
-- Name: animal_types animal_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.animal_types
    ADD CONSTRAINT animal_types_pkey PRIMARY KEY (id);


--
-- TOC entry 3730 (class 2606 OID 67168)
-- Name: animals animals_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.animals
    ADD CONSTRAINT animals_pkey PRIMARY KEY (id);


--
-- TOC entry 3732 (class 2606 OID 67170)
-- Name: bank_accounts bank_accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bank_accounts
    ADD CONSTRAINT bank_accounts_pkey PRIMARY KEY (id);


--
-- TOC entry 3734 (class 2606 OID 67172)
-- Name: booking_news booking_news_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.booking_news
    ADD CONSTRAINT booking_news_pkey PRIMARY KEY (id);


--
-- TOC entry 3736 (class 2606 OID 67174)
-- Name: booking_plan_details booking_plan_details_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.booking_plan_details
    ADD CONSTRAINT booking_plan_details_pkey PRIMARY KEY (id);


--
-- TOC entry 3738 (class 2606 OID 67176)
-- Name: booking_plan_documents booking_plan_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.booking_plan_documents
    ADD CONSTRAINT booking_plan_documents_pkey PRIMARY KEY (id);


--
-- TOC entry 3740 (class 2606 OID 67178)
-- Name: booking_plan_kleders booking_plan_kleders_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.booking_plan_kleders
    ADD CONSTRAINT booking_plan_kleders_pkey PRIMARY KEY (id);


--
-- TOC entry 3742 (class 2606 OID 67180)
-- Name: booking_plan_statuses booking_plan_statuses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.booking_plan_statuses
    ADD CONSTRAINT booking_plan_statuses_pkey PRIMARY KEY (id);


--
-- TOC entry 3744 (class 2606 OID 67182)
-- Name: booking_plans booking_plans_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.booking_plans
    ADD CONSTRAINT booking_plans_pkey PRIMARY KEY (id);


--
-- TOC entry 3746 (class 2606 OID 67184)
-- Name: booking_statuses booking_statuses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.booking_statuses
    ADD CONSTRAINT booking_statuses_pkey PRIMARY KEY (id);


--
-- TOC entry 3748 (class 2606 OID 67186)
-- Name: bookings bookings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_pkey PRIMARY KEY (id);


--
-- TOC entry 3750 (class 2606 OID 67188)
-- Name: cities cities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cities
    ADD CONSTRAINT cities_pkey PRIMARY KEY (id);


--
-- TOC entry 3752 (class 2606 OID 67190)
-- Name: depots depots_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.depots
    ADD CONSTRAINT depots_pkey PRIMARY KEY (id);


--
-- TOC entry 3754 (class 2606 OID 67192)
-- Name: hc_details hc_details_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hc_details
    ADD CONSTRAINT hc_details_pkey PRIMARY KEY (id);


--
-- TOC entry 3756 (class 2606 OID 67194)
-- Name: health_certificate_complain_files health_certificate_complain_files_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.health_certificate_complain_files
    ADD CONSTRAINT health_certificate_complain_files_pkey PRIMARY KEY (id);


--
-- TOC entry 3758 (class 2606 OID 67196)
-- Name: health_certificate_complains health_certificate_complains_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.health_certificate_complains
    ADD CONSTRAINT health_certificate_complains_pkey PRIMARY KEY (id);


--
-- TOC entry 3760 (class 2606 OID 67198)
-- Name: master_rates master_rates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.master_rates
    ADD CONSTRAINT master_rates_pkey PRIMARY KEY (id);


--
-- TOC entry 3762 (class 2606 OID 67200)
-- Name: master_schedules master_schedules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.master_schedules
    ADD CONSTRAINT master_schedules_pkey PRIMARY KEY (id);


--
-- TOC entry 3764 (class 2606 OID 67202)
-- Name: master_trayeks master_trayeks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.master_trayeks
    ADD CONSTRAINT master_trayeks_pkey PRIMARY KEY (id);


--
-- TOC entry 3766 (class 2606 OID 67204)
-- Name: master_voyages master_voyages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.master_voyages
    ADD CONSTRAINT master_voyages_pkey PRIMARY KEY (id);


--
-- TOC entry 3768 (class 2606 OID 67206)
-- Name: modules modules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.modules
    ADD CONSTRAINT modules_pkey PRIMARY KEY (id);


--
-- TOC entry 3770 (class 2606 OID 67208)
-- Name: pengaduan_replies pengaduan_replies_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pengaduan_replies
    ADD CONSTRAINT pengaduan_replies_pkey PRIMARY KEY (id);


--
-- TOC entry 3772 (class 2606 OID 67210)
-- Name: pengaduans pengaduans_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pengaduans
    ADD CONSTRAINT pengaduans_pkey PRIMARY KEY (id);


--
-- TOC entry 3774 (class 2606 OID 67212)
-- Name: provinces provinces_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.provinces
    ADD CONSTRAINT provinces_pkey PRIMARY KEY (id);


--
-- TOC entry 3776 (class 2606 OID 67214)
-- Name: revokeds revokeds_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.revokeds
    ADD CONSTRAINT revokeds_pkey PRIMARY KEY (id);


--
-- TOC entry 3778 (class 2606 OID 67216)
-- Name: ruas_trayeks ruas_trayeks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ruas_trayeks
    ADD CONSTRAINT ruas_trayeks_pkey PRIMARY KEY (id);


--
-- TOC entry 3780 (class 2606 OID 67218)
-- Name: schedule_quota schedule_quota_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schedule_quota
    ADD CONSTRAINT schedule_quota_pkey PRIMARY KEY (id);


--
-- TOC entry 3782 (class 2606 OID 67220)
-- Name: schedule_rates schedule_rates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schedule_rates
    ADD CONSTRAINT schedule_rates_pkey PRIMARY KEY (id);


--
-- TOC entry 3784 (class 2606 OID 67222)
-- Name: schedules schedules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schedules
    ADD CONSTRAINT schedules_pkey PRIMARY KEY (id);


--
-- TOC entry 3786 (class 2606 OID 67224)
-- Name: track_logs track_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.track_logs
    ADD CONSTRAINT track_logs_pkey PRIMARY KEY (id);


--
-- TOC entry 3788 (class 2606 OID 67226)
-- Name: trayeks trayeks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trayeks
    ADD CONSTRAINT trayeks_pkey PRIMARY KEY (id);


--
-- TOC entry 3790 (class 2606 OID 67228)
-- Name: user_profiles user_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_profiles
    ADD CONSTRAINT user_profiles_pkey PRIMARY KEY (id);


--
-- TOC entry 3792 (class 2606 OID 67230)
-- Name: user_type_ex user_type_ex_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_type_ex
    ADD CONSTRAINT user_type_ex_pkey PRIMARY KEY (id);


--
-- TOC entry 3794 (class 2606 OID 67232)
-- Name: user_types user_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_types
    ADD CONSTRAINT user_types_pkey PRIMARY KEY (id);


--
-- TOC entry 3798 (class 2606 OID 67234)
-- Name: users_ex users_ex_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users_ex
    ADD CONSTRAINT users_ex_pkey PRIMARY KEY (id);


--
-- TOC entry 3796 (class 2606 OID 67236)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 3800 (class 2606 OID 67238)
-- Name: vessel_cattle_room_schedules vessel_cattle_room_schedules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vessel_cattle_room_schedules
    ADD CONSTRAINT vessel_cattle_room_schedules_pkey PRIMARY KEY (id);


--
-- TOC entry 3802 (class 2606 OID 67240)
-- Name: vessel_cattle_rooms vessel_cattle_rooms_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vessel_cattle_rooms
    ADD CONSTRAINT vessel_cattle_rooms_pkey PRIMARY KEY (id);


--
-- TOC entry 3804 (class 2606 OID 67242)
-- Name: vessel_room_schedules vessel_room_schedules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vessel_room_schedules
    ADD CONSTRAINT vessel_room_schedules_pkey PRIMARY KEY (id);


--
-- TOC entry 3806 (class 2606 OID 67244)
-- Name: vessel_rooms vessel_rooms_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vessel_rooms
    ADD CONSTRAINT vessel_rooms_pkey PRIMARY KEY (id);


--
-- TOC entry 3808 (class 2606 OID 67246)
-- Name: vessel_trackings vessel_trackings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vessel_trackings
    ADD CONSTRAINT vessel_trackings_pkey PRIMARY KEY (id);


--
-- TOC entry 3810 (class 2606 OID 67248)
-- Name: vessels vessels_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vessels
    ADD CONSTRAINT vessels_pkey PRIMARY KEY (id);


--
-- TOC entry 3686 (class 1259 OID 67249)
-- Name: idx_mtr_menu_action; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX idx_mtr_menu_action ON core.t_mtr_menu_action USING btree (id, status, action_name);


--
-- TOC entry 3693 (class 1259 OID 67250)
-- Name: idx_mtr_menu_detail_web; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX idx_mtr_menu_detail_web ON core.t_mtr_menu_detail_web USING btree (menu_id, id, action_id, status);


--
-- TOC entry 3697 (class 1259 OID 67251)
-- Name: idx_mtr_menu_web; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX idx_mtr_menu_web ON core.t_mtr_menu_web USING btree (parent_id, status, id);


--
-- TOC entry 3707 (class 1259 OID 67252)
-- Name: idx_mtr_privilege_web; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX idx_mtr_privilege_web ON core.t_mtr_privilege_web USING btree (id, status, user_group_id, menu_detail_id, menu_id);


--
-- TOC entry 3715 (class 1259 OID 67253)
-- Name: idx_mtr_user_group; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX idx_mtr_user_group ON core.t_mtr_user_group USING btree (id, status);


--
-- TOC entry 3687 (class 1259 OID 67254)
-- Name: t_mtr_menu_action_action_idx; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX t_mtr_menu_action_action_idx ON core.t_mtr_menu_action USING btree (action_name);


--
-- TOC entry 3688 (class 1259 OID 67255)
-- Name: t_mtr_menu_action_id_status_action_name_idx; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX t_mtr_menu_action_id_status_action_name_idx ON core.t_mtr_menu_action USING btree (id, status, action_name);


--
-- TOC entry 3689 (class 1259 OID 67256)
-- Name: t_mtr_menu_action_id_status_idx; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX t_mtr_menu_action_id_status_idx ON core.t_mtr_menu_action USING btree (id, status);


--
-- TOC entry 3692 (class 1259 OID 67257)
-- Name: t_mtr_menu_action_status_idx; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX t_mtr_menu_action_status_idx ON core.t_mtr_menu_action USING btree (status);


--
-- TOC entry 3694 (class 1259 OID 67258)
-- Name: t_mtr_menu_detail_web_id_status_action_id_idx; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX t_mtr_menu_detail_web_id_status_action_id_idx ON core.t_mtr_menu_detail_web USING btree (id, status, action_id);


--
-- TOC entry 3682 (class 1259 OID 67259)
-- Name: t_mtr_menu_id_status_idx; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX t_mtr_menu_id_status_idx ON core.t_mtr_menu USING btree (id, status);


--
-- TOC entry 3685 (class 1259 OID 67260)
-- Name: t_mtr_menu_slug_idx; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX t_mtr_menu_slug_idx ON core.t_mtr_menu USING btree (slug);


--
-- TOC entry 3698 (class 1259 OID 67261)
-- Name: t_mtr_menu_web_id_status_idx; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX t_mtr_menu_web_id_status_idx ON core.t_mtr_menu_web USING btree (id, status);


--
-- TOC entry 3706 (class 1259 OID 67262)
-- Name: t_mtr_privilege_detail_privilege_id_view_idx; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX t_mtr_privilege_detail_privilege_id_view_idx ON core.t_mtr_privilege_detail USING btree (privilege_id, view);


--
-- TOC entry 3701 (class 1259 OID 67263)
-- Name: t_mtr_privilege_id_group_id_status_idx; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX t_mtr_privilege_id_group_id_status_idx ON core.t_mtr_privilege USING btree (id, group_id, status);


--
-- TOC entry 3710 (class 1259 OID 67264)
-- Name: t_mtr_privilege_web_user_group_id_menu_id_menu_detail_id_st_idx; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX t_mtr_privilege_web_user_group_id_menu_id_menu_detail_id_st_idx ON core.t_mtr_privilege_web USING btree (user_group_id, menu_id, menu_detail_id, status);


--
-- TOC entry 3716 (class 1259 OID 67265)
-- Name: t_mtr_user_group_id_status_idx; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX t_mtr_user_group_id_status_idx ON core.t_mtr_user_group USING btree (id, status);


--
-- TOC entry 3713 (class 1259 OID 67266)
-- Name: t_mtr_user_username_status_idx; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX t_mtr_user_username_status_idx ON core.t_mtr_user USING btree (username, status);


--
-- TOC entry 3714 (class 1259 OID 67267)
-- Name: t_mtr_user_username_status_idx1; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX t_mtr_user_username_status_idx1 ON core.t_mtr_user USING btree (username, status);


-- Completed on 2026-05-11 17:08:54

--
-- PostgreSQL database dump complete
--

