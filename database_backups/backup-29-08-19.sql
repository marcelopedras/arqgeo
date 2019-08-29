--
-- PostgreSQL database dump
--

-- Dumped from database version 11.5 (Debian 11.5-1.pgdg90+1)
-- Dumped by pg_dump version 11.5 (Debian 11.5-1.pgdg90+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: getnextid(character varying); Type: FUNCTION; Schema: public; Owner: dspace
--

CREATE FUNCTION public.getnextid(character varying) RETURNS integer
    LANGUAGE sql
    AS $_$SELECT CAST (nextval($1 || '_seq') AS INTEGER) AS RESULT;$_$;


ALTER FUNCTION public.getnextid(character varying) OWNER TO dspace;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: bitstream; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.bitstream (
    bitstream_id integer,
    bitstream_format_id integer,
    checksum character varying(64),
    checksum_algorithm character varying(32),
    internal_id character varying(256),
    deleted boolean,
    store_number integer,
    sequence_id integer,
    size_bytes bigint,
    uuid uuid DEFAULT public.gen_random_uuid() NOT NULL
);


ALTER TABLE public.bitstream OWNER TO dspace;

--
-- Name: bitstreamformatregistry; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.bitstreamformatregistry (
    bitstream_format_id integer NOT NULL,
    mimetype character varying(256),
    short_description character varying(128),
    description text,
    support_level integer,
    internal boolean
);


ALTER TABLE public.bitstreamformatregistry OWNER TO dspace;

--
-- Name: bitstreamformatregistry_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.bitstreamformatregistry_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.bitstreamformatregistry_seq OWNER TO dspace;

--
-- Name: bundle; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.bundle (
    bundle_id integer,
    uuid uuid DEFAULT public.gen_random_uuid() NOT NULL,
    primary_bitstream_id uuid
);


ALTER TABLE public.bundle OWNER TO dspace;

--
-- Name: bundle2bitstream; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.bundle2bitstream (
    bitstream_order_legacy integer,
    bundle_id uuid NOT NULL,
    bitstream_id uuid NOT NULL,
    bitstream_order integer NOT NULL
);


ALTER TABLE public.bundle2bitstream OWNER TO dspace;

--
-- Name: checksum_history; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.checksum_history (
    check_id bigint NOT NULL,
    process_start_date timestamp without time zone,
    process_end_date timestamp without time zone,
    checksum_expected character varying,
    checksum_calculated character varying,
    result character varying,
    bitstream_id uuid
);


ALTER TABLE public.checksum_history OWNER TO dspace;

--
-- Name: checksum_history_check_id_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.checksum_history_check_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.checksum_history_check_id_seq OWNER TO dspace;

--
-- Name: checksum_history_check_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dspace
--

ALTER SEQUENCE public.checksum_history_check_id_seq OWNED BY public.checksum_history.check_id;


--
-- Name: checksum_results; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.checksum_results (
    result_code character varying NOT NULL,
    result_description character varying
);


ALTER TABLE public.checksum_results OWNER TO dspace;

--
-- Name: collection; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.collection (
    collection_id integer,
    uuid uuid DEFAULT public.gen_random_uuid() NOT NULL,
    workflow_step_1 uuid,
    workflow_step_2 uuid,
    workflow_step_3 uuid,
    submitter uuid,
    template_item_id uuid,
    logo_bitstream_id uuid,
    admin uuid
);


ALTER TABLE public.collection OWNER TO dspace;

--
-- Name: collection2item; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.collection2item (
    collection_id uuid NOT NULL,
    item_id uuid NOT NULL
);


ALTER TABLE public.collection2item OWNER TO dspace;

--
-- Name: community; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.community (
    community_id integer,
    uuid uuid DEFAULT public.gen_random_uuid() NOT NULL,
    admin uuid,
    logo_bitstream_id uuid
);


ALTER TABLE public.community OWNER TO dspace;

--
-- Name: community2collection; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.community2collection (
    collection_id uuid NOT NULL,
    community_id uuid NOT NULL
);


ALTER TABLE public.community2collection OWNER TO dspace;

--
-- Name: community2community; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.community2community (
    parent_comm_id uuid NOT NULL,
    child_comm_id uuid NOT NULL
);


ALTER TABLE public.community2community OWNER TO dspace;

--
-- Name: doi; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.doi (
    doi_id integer NOT NULL,
    doi character varying(256),
    resource_type_id integer,
    resource_id integer,
    status integer,
    dspace_object uuid
);


ALTER TABLE public.doi OWNER TO dspace;

--
-- Name: doi_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.doi_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.doi_seq OWNER TO dspace;

--
-- Name: dspaceobject; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.dspaceobject (
    uuid uuid NOT NULL
);


ALTER TABLE public.dspaceobject OWNER TO dspace;

--
-- Name: eperson; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.eperson (
    eperson_id integer,
    email character varying(64),
    password character varying(128),
    can_log_in boolean,
    require_certificate boolean,
    self_registered boolean,
    last_active timestamp without time zone,
    sub_frequency integer,
    netid character varying(64),
    salt character varying(32),
    digest_algorithm character varying(16),
    uuid uuid DEFAULT public.gen_random_uuid() NOT NULL
);


ALTER TABLE public.eperson OWNER TO dspace;

--
-- Name: epersongroup; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.epersongroup (
    eperson_group_id integer,
    uuid uuid DEFAULT public.gen_random_uuid() NOT NULL,
    permanent boolean DEFAULT false,
    name character varying(250)
);


ALTER TABLE public.epersongroup OWNER TO dspace;

--
-- Name: epersongroup2eperson; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.epersongroup2eperson (
    eperson_group_id uuid NOT NULL,
    eperson_id uuid NOT NULL
);


ALTER TABLE public.epersongroup2eperson OWNER TO dspace;

--
-- Name: epersongroup2workspaceitem; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.epersongroup2workspaceitem (
    workspace_item_id integer NOT NULL,
    eperson_group_id uuid NOT NULL
);


ALTER TABLE public.epersongroup2workspaceitem OWNER TO dspace;

--
-- Name: fileextension; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.fileextension (
    file_extension_id integer NOT NULL,
    bitstream_format_id integer,
    extension character varying(16)
);


ALTER TABLE public.fileextension OWNER TO dspace;

--
-- Name: fileextension_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.fileextension_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.fileextension_seq OWNER TO dspace;

--
-- Name: group2group; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.group2group (
    parent_id uuid NOT NULL,
    child_id uuid NOT NULL
);


ALTER TABLE public.group2group OWNER TO dspace;

--
-- Name: group2groupcache; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.group2groupcache (
    parent_id uuid NOT NULL,
    child_id uuid NOT NULL
);


ALTER TABLE public.group2groupcache OWNER TO dspace;

--
-- Name: handle; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.handle (
    handle_id integer NOT NULL,
    handle character varying(256),
    resource_type_id integer,
    resource_legacy_id integer,
    resource_id uuid
);


ALTER TABLE public.handle OWNER TO dspace;

--
-- Name: handle_id_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.handle_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.handle_id_seq OWNER TO dspace;

--
-- Name: handle_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.handle_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.handle_seq OWNER TO dspace;

--
-- Name: harvested_collection; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.harvested_collection (
    harvest_type integer,
    oai_source character varying,
    oai_set_id character varying,
    harvest_message character varying,
    metadata_config_id character varying,
    harvest_status integer,
    harvest_start_time timestamp with time zone,
    last_harvested timestamp with time zone,
    id integer NOT NULL,
    collection_id uuid
);


ALTER TABLE public.harvested_collection OWNER TO dspace;

--
-- Name: harvested_collection_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.harvested_collection_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.harvested_collection_seq OWNER TO dspace;

--
-- Name: harvested_item; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.harvested_item (
    last_harvested timestamp with time zone,
    oai_id character varying,
    id integer NOT NULL,
    item_id uuid
);


ALTER TABLE public.harvested_item OWNER TO dspace;

--
-- Name: harvested_item_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.harvested_item_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.harvested_item_seq OWNER TO dspace;

--
-- Name: history_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.history_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.history_seq OWNER TO dspace;

--
-- Name: item; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.item (
    item_id integer,
    in_archive boolean,
    withdrawn boolean,
    last_modified timestamp with time zone,
    discoverable boolean,
    uuid uuid DEFAULT public.gen_random_uuid() NOT NULL,
    submitter_id uuid,
    owning_collection uuid
);


ALTER TABLE public.item OWNER TO dspace;

--
-- Name: item2bundle; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.item2bundle (
    bundle_id uuid NOT NULL,
    item_id uuid NOT NULL
);


ALTER TABLE public.item2bundle OWNER TO dspace;

--
-- Name: metadatafieldregistry_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.metadatafieldregistry_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.metadatafieldregistry_seq OWNER TO dspace;

--
-- Name: metadatafieldregistry; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.metadatafieldregistry (
    metadata_field_id integer DEFAULT nextval('public.metadatafieldregistry_seq'::regclass) NOT NULL,
    metadata_schema_id integer NOT NULL,
    element character varying(64),
    qualifier character varying(64),
    scope_note text
);


ALTER TABLE public.metadatafieldregistry OWNER TO dspace;

--
-- Name: metadataschemaregistry_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.metadataschemaregistry_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.metadataschemaregistry_seq OWNER TO dspace;

--
-- Name: metadataschemaregistry; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.metadataschemaregistry (
    metadata_schema_id integer DEFAULT nextval('public.metadataschemaregistry_seq'::regclass) NOT NULL,
    namespace character varying(256),
    short_id character varying(32)
);


ALTER TABLE public.metadataschemaregistry OWNER TO dspace;

--
-- Name: metadatavalue_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.metadatavalue_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.metadatavalue_seq OWNER TO dspace;

--
-- Name: metadatavalue; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.metadatavalue (
    metadata_value_id integer DEFAULT nextval('public.metadatavalue_seq'::regclass) NOT NULL,
    metadata_field_id integer,
    text_value text,
    text_lang character varying(24),
    place integer,
    authority character varying(100),
    confidence integer DEFAULT '-1'::integer,
    dspace_object_id uuid
);


ALTER TABLE public.metadatavalue OWNER TO dspace;

--
-- Name: most_recent_checksum; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.most_recent_checksum (
    to_be_processed boolean NOT NULL,
    expected_checksum character varying NOT NULL,
    current_checksum character varying NOT NULL,
    last_process_start_date timestamp without time zone NOT NULL,
    last_process_end_date timestamp without time zone NOT NULL,
    checksum_algorithm character varying NOT NULL,
    matched_prev_checksum boolean NOT NULL,
    result character varying,
    bitstream_id uuid
);


ALTER TABLE public.most_recent_checksum OWNER TO dspace;

--
-- Name: registrationdata; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.registrationdata (
    registrationdata_id integer NOT NULL,
    email character varying(64),
    token character varying(48),
    expires timestamp without time zone
);


ALTER TABLE public.registrationdata OWNER TO dspace;

--
-- Name: registrationdata_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.registrationdata_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.registrationdata_seq OWNER TO dspace;

--
-- Name: requestitem; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.requestitem (
    requestitem_id integer NOT NULL,
    token character varying(48),
    allfiles boolean,
    request_email character varying(64),
    request_name character varying(64),
    request_date timestamp without time zone,
    accept_request boolean,
    decision_date timestamp without time zone,
    expires timestamp without time zone,
    request_message text,
    item_id uuid,
    bitstream_id uuid
);


ALTER TABLE public.requestitem OWNER TO dspace;

--
-- Name: requestitem_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.requestitem_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.requestitem_seq OWNER TO dspace;

--
-- Name: resourcepolicy; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.resourcepolicy (
    policy_id integer NOT NULL,
    resource_type_id integer,
    resource_id integer,
    action_id integer,
    start_date date,
    end_date date,
    rpname character varying(30),
    rptype character varying(30),
    rpdescription text,
    eperson_id uuid,
    epersongroup_id uuid,
    dspace_object uuid
);


ALTER TABLE public.resourcepolicy OWNER TO dspace;

--
-- Name: resourcepolicy_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.resourcepolicy_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.resourcepolicy_seq OWNER TO dspace;

--
-- Name: schema_version; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.schema_version (
    installed_rank integer NOT NULL,
    version character varying(50),
    description character varying(200) NOT NULL,
    type character varying(20) NOT NULL,
    script character varying(1000) NOT NULL,
    checksum integer,
    installed_by character varying(100) NOT NULL,
    installed_on timestamp without time zone DEFAULT now() NOT NULL,
    execution_time integer NOT NULL,
    success boolean NOT NULL
);


ALTER TABLE public.schema_version OWNER TO dspace;

--
-- Name: site; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.site (
    uuid uuid NOT NULL
);


ALTER TABLE public.site OWNER TO dspace;

--
-- Name: subscription; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.subscription (
    subscription_id integer NOT NULL,
    eperson_id uuid,
    collection_id uuid
);


ALTER TABLE public.subscription OWNER TO dspace;

--
-- Name: subscription_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.subscription_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.subscription_seq OWNER TO dspace;

--
-- Name: tasklistitem; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.tasklistitem (
    tasklist_id integer NOT NULL,
    workflow_id integer,
    eperson_id uuid
);


ALTER TABLE public.tasklistitem OWNER TO dspace;

--
-- Name: tasklistitem_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.tasklistitem_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tasklistitem_seq OWNER TO dspace;

--
-- Name: versionhistory; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.versionhistory (
    versionhistory_id integer NOT NULL
);


ALTER TABLE public.versionhistory OWNER TO dspace;

--
-- Name: versionhistory_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.versionhistory_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.versionhistory_seq OWNER TO dspace;

--
-- Name: versionitem; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.versionitem (
    versionitem_id integer NOT NULL,
    version_number integer,
    version_date timestamp without time zone,
    version_summary character varying(255),
    versionhistory_id integer,
    eperson_id uuid,
    item_id uuid
);


ALTER TABLE public.versionitem OWNER TO dspace;

--
-- Name: versionitem_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.versionitem_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.versionitem_seq OWNER TO dspace;

--
-- Name: webapp; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.webapp (
    webapp_id integer NOT NULL,
    appname character varying(32),
    url character varying,
    started timestamp without time zone,
    isui integer
);


ALTER TABLE public.webapp OWNER TO dspace;

--
-- Name: webapp_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.webapp_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.webapp_seq OWNER TO dspace;

--
-- Name: workflowitem; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.workflowitem (
    workflow_id integer NOT NULL,
    state integer,
    multiple_titles boolean,
    published_before boolean,
    multiple_files boolean,
    item_id uuid,
    collection_id uuid,
    owner uuid
);


ALTER TABLE public.workflowitem OWNER TO dspace;

--
-- Name: workflowitem_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.workflowitem_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.workflowitem_seq OWNER TO dspace;

--
-- Name: workspaceitem; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.workspaceitem (
    workspace_item_id integer NOT NULL,
    multiple_titles boolean,
    published_before boolean,
    multiple_files boolean,
    stage_reached integer,
    page_reached integer,
    item_id uuid,
    collection_id uuid
);


ALTER TABLE public.workspaceitem OWNER TO dspace;

--
-- Name: workspaceitem_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.workspaceitem_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.workspaceitem_seq OWNER TO dspace;

--
-- Name: checksum_history check_id; Type: DEFAULT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.checksum_history ALTER COLUMN check_id SET DEFAULT nextval('public.checksum_history_check_id_seq'::regclass);


--
-- Data for Name: bitstream; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.bitstream (bitstream_id, bitstream_format_id, checksum, checksum_algorithm, internal_id, deleted, store_number, sequence_id, size_bytes, uuid) FROM stdin;
\N	18	617edd2e3b0b36d06c7a1f14e2418b52	MD5	144399655713230589560357922182249839145	f	0	-1	40610	fd5dde54-3eef-4e27-99e7-a5b360b6dfdb
\.


--
-- Data for Name: bitstreamformatregistry; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.bitstreamformatregistry (bitstream_format_id, mimetype, short_description, description, support_level, internal) FROM stdin;
1	application/octet-stream	Unknown	Unknown data format	0	f
2	text/plain; charset=utf-8	License	Item-specific license agreed upon to submission	1	t
3	text/html; charset=utf-8	CC License	Item-specific Creative Commons license agreed upon to submission	1	t
4	application/pdf	Adobe PDF	Adobe Portable Document Format	1	f
5	text/xml	XML	Extensible Markup Language	1	f
6	text/plain	Text	Plain Text	1	f
7	text/html	HTML	Hypertext Markup Language	1	f
8	text/css	CSS	Cascading Style Sheets	1	f
9	application/msword	Microsoft Word	Microsoft Word	1	f
10	application/vnd.openxmlformats-officedocument.wordprocessingml.document	Microsoft Word XML	Microsoft Word XML	1	f
11	application/vnd.ms-powerpoint	Microsoft Powerpoint	Microsoft Powerpoint	1	f
12	application/vnd.openxmlformats-officedocument.presentationml.presentation	Microsoft Powerpoint XML	Microsoft Powerpoint XML	1	f
13	application/vnd.ms-excel	Microsoft Excel	Microsoft Excel	1	f
14	application/vnd.openxmlformats-officedocument.spreadsheetml.sheet	Microsoft Excel XML	Microsoft Excel XML	1	f
15	application/marc	MARC	Machine-Readable Cataloging records	1	f
16	image/jpeg	JPEG	Joint Photographic Experts Group/JPEG File Interchange Format (JFIF)	1	f
17	image/gif	GIF	Graphics Interchange Format	1	f
18	image/png	image/png	Portable Network Graphics	1	f
19	image/tiff	TIFF	Tag Image File Format	1	f
20	audio/x-aiff	AIFF	Audio Interchange File Format	1	f
21	audio/basic	audio/basic	Basic Audio	1	f
22	audio/x-wav	WAV	Broadcase Wave Format	1	f
23	video/mpeg	MPEG	Moving Picture Experts Group	1	f
24	text/richtext	RTF	Rich Text Format	1	f
25	application/vnd.visio	Microsoft Visio	Microsoft Visio	1	f
26	application/x-filemaker	FMP3	Filemaker Pro	1	f
27	image/x-ms-bmp	BMP	Microsoft Windows bitmap	1	f
28	application/x-photoshop	Photoshop	Photoshop	1	f
29	application/postscript	Postscript	Postscript Files	1	f
30	video/quicktime	Video Quicktime	Video Quicktime	1	f
31	audio/x-mpeg	MPEG Audio	MPEG Audio	1	f
32	application/vnd.ms-project	Microsoft Project	Microsoft Project	1	f
33	application/mathematica	Mathematica	Mathematica Notebook	1	f
34	application/x-latex	LateX	LaTeX document	1	f
35	application/x-tex	TeX	Tex/LateX document	1	f
36	application/x-dvi	TeX dvi	TeX dvi format	1	f
37	application/sgml	SGML	SGML application (RFC 1874)	1	f
38	application/wordperfect5.1	WordPerfect	WordPerfect 5.1 document	1	f
39	audio/x-pn-realaudio	RealAudio	RealAudio file	1	f
40	image/x-photo-cd	Photo CD	Kodak Photo CD image	1	f
41	application/vnd.oasis.opendocument.text	OpenDocument Text	OpenDocument Text	1	f
42	application/vnd.oasis.opendocument.text-template	OpenDocument Text Template	OpenDocument Text Template	1	f
43	application/vnd.oasis.opendocument.text-web	OpenDocument HTML Template	OpenDocument HTML Template	1	f
44	application/vnd.oasis.opendocument.text-master	OpenDocument Master Document	OpenDocument Master Document	1	f
45	application/vnd.oasis.opendocument.graphics	OpenDocument Drawing	OpenDocument Drawing	1	f
46	application/vnd.oasis.opendocument.graphics-template	OpenDocument Drawing Template	OpenDocument Drawing Template	1	f
47	application/vnd.oasis.opendocument.presentation	OpenDocument Presentation	OpenDocument Presentation	1	f
48	application/vnd.oasis.opendocument.presentation-template	OpenDocument Presentation Template	OpenDocument Presentation Template	1	f
49	application/vnd.oasis.opendocument.spreadsheet	OpenDocument Spreadsheet	OpenDocument Spreadsheet	1	f
50	application/vnd.oasis.opendocument.spreadsheet-template	OpenDocument Spreadsheet Template	OpenDocument Spreadsheet Template	1	f
51	application/vnd.oasis.opendocument.chart	OpenDocument Chart	OpenDocument Chart	1	f
52	application/vnd.oasis.opendocument.formula	OpenDocument Formula	OpenDocument Formula	1	f
53	application/vnd.oasis.opendocument.database	OpenDocument Database	OpenDocument Database	1	f
54	application/vnd.oasis.opendocument.image	OpenDocument Image	OpenDocument Image	1	f
55	application/vnd.openofficeorg.extension	OpenOffice.org extension	OpenOffice.org extension (since OOo 2.1)	1	f
56	application/vnd.sun.xml.writer	Writer 6.0 documents	Writer 6.0 documents	1	f
57	application/vnd.sun.xml.writer.template	Writer 6.0 templates	Writer 6.0 templates	1	f
58	application/vnd.sun.xml.calc	Calc 6.0 spreadsheets	Calc 6.0 spreadsheets	1	f
59	application/vnd.sun.xml.calc.template	Calc 6.0 templates	Calc 6.0 templates	1	f
60	application/vnd.sun.xml.draw	Draw 6.0 documents	Draw 6.0 documents	1	f
61	application/vnd.sun.xml.draw.template	Draw 6.0 templates	Draw 6.0 templates	1	f
62	application/vnd.sun.xml.impress	Impress 6.0 presentations	Impress 6.0 presentations	1	f
63	application/vnd.sun.xml.impress.template	Impress 6.0 templates	Impress 6.0 templates	1	f
64	application/vnd.sun.xml.writer.global	Writer 6.0 global documents	Writer 6.0 global documents	1	f
65	application/vnd.sun.xml.math	Math 6.0 documents	Math 6.0 documents	1	f
66	application/vnd.stardivision.writer	StarWriter 5.x documents	StarWriter 5.x documents	1	f
67	application/vnd.stardivision.writer-global	StarWriter 5.x global documents	StarWriter 5.x global documents	1	f
68	application/vnd.stardivision.calc	StarCalc 5.x spreadsheets	StarCalc 5.x spreadsheets	1	f
69	application/vnd.stardivision.draw	StarDraw 5.x documents	StarDraw 5.x documents	1	f
70	application/vnd.stardivision.impress	StarImpress 5.x presentations	StarImpress 5.x presentations	1	f
71	application/vnd.stardivision.impress-packed	StarImpress Packed 5.x files	StarImpress Packed 5.x files	1	f
72	application/vnd.stardivision.math	StarMath 5.x documents	StarMath 5.x documents	1	f
73	application/vnd.stardivision.chart	StarChart 5.x documents	StarChart 5.x documents	1	f
74	application/vnd.stardivision.mail	StarMail 5.x mail files	StarMail 5.x mail files	1	f
75	application/rdf+xml; charset=utf-8	RDF XML	RDF serialized in XML	1	f
76	application/epub+zip	EPUB	Electronic publishing	1	f
\.


--
-- Data for Name: bundle; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.bundle (bundle_id, uuid, primary_bitstream_id) FROM stdin;
\.


--
-- Data for Name: bundle2bitstream; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.bundle2bitstream (bitstream_order_legacy, bundle_id, bitstream_id, bitstream_order) FROM stdin;
\.


--
-- Data for Name: checksum_history; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.checksum_history (check_id, process_start_date, process_end_date, checksum_expected, checksum_calculated, result, bitstream_id) FROM stdin;
\.


--
-- Data for Name: checksum_results; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.checksum_results (result_code, result_description) FROM stdin;
INVALID_HISTORY	Install of the cheksum checking code do not consider this history as valid
BITSTREAM_NOT_FOUND	The bitstream could not be found
CHECKSUM_MATCH	Current checksum matched previous checksum
CHECKSUM_NO_MATCH	Current checksum does not match previous checksum
CHECKSUM_PREV_NOT_FOUND	Previous checksum was not found: no comparison possible
BITSTREAM_INFO_NOT_FOUND	Bitstream info not found
CHECKSUM_ALGORITHM_INVALID	Invalid checksum algorithm
BITSTREAM_NOT_PROCESSED	Bitstream marked to_be_processed=false
BITSTREAM_MARKED_DELETED	Bitstream marked deleted in bitstream table
\.


--
-- Data for Name: collection; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.collection (collection_id, uuid, workflow_step_1, workflow_step_2, workflow_step_3, submitter, template_item_id, logo_bitstream_id, admin) FROM stdin;
\N	2e3985dd-75dc-4f91-a4e9-0d48c9bcd02c	\N	\N	\N	f94370dd-6a28-4290-8d48-762c38a2836d	b42c6f36-633f-4f60-bf64-ffa45efe443c	\N	c321ce3e-512e-4ccf-9e46-8e6a0ba0a7af
\N	5ae8fd65-56aa-4ffa-bdd6-42e5de7cc7e4	\N	\N	\N	d5bd0a42-29c1-4e23-a1c2-9f505035535e	\N	\N	\N
\N	1084120c-37c7-4957-8ba1-e6dca9742dd5	\N	\N	\N	8a60c514-05bb-47dd-82be-b74ee047a4d3	\N	\N	\N
\N	d31151b6-9244-4be2-aba9-a116eac97281	\N	\N	\N	5ccf3236-4285-46f5-b274-79cf02619a8f	\N	\N	\N
\N	55c662c3-5486-4a03-9a65-6be776b744bc	\N	\N	\N	de3b6421-45e8-41c0-b76c-be018074ba2a	\N	\N	\N
\.


--
-- Data for Name: collection2item; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.collection2item (collection_id, item_id) FROM stdin;
\.


--
-- Data for Name: community; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.community (community_id, uuid, admin, logo_bitstream_id) FROM stdin;
\N	38d48d59-d49f-4b01-bd84-6bbb4abff544	1ff7ad1c-4131-4d9a-ba79-debd89d8ede7	fd5dde54-3eef-4e27-99e7-a5b360b6dfdb
\.


--
-- Data for Name: community2collection; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.community2collection (collection_id, community_id) FROM stdin;
2e3985dd-75dc-4f91-a4e9-0d48c9bcd02c	38d48d59-d49f-4b01-bd84-6bbb4abff544
5ae8fd65-56aa-4ffa-bdd6-42e5de7cc7e4	38d48d59-d49f-4b01-bd84-6bbb4abff544
1084120c-37c7-4957-8ba1-e6dca9742dd5	38d48d59-d49f-4b01-bd84-6bbb4abff544
d31151b6-9244-4be2-aba9-a116eac97281	38d48d59-d49f-4b01-bd84-6bbb4abff544
55c662c3-5486-4a03-9a65-6be776b744bc	38d48d59-d49f-4b01-bd84-6bbb4abff544
\.


--
-- Data for Name: community2community; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.community2community (parent_comm_id, child_comm_id) FROM stdin;
\.


--
-- Data for Name: doi; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.doi (doi_id, doi, resource_type_id, resource_id, status, dspace_object) FROM stdin;
\.


--
-- Data for Name: dspaceobject; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.dspaceobject (uuid) FROM stdin;
54c6e912-d753-42e6-9815-7b3507dde12c
c1e437e4-2fc3-40c3-a2c5-af4df5204e4d
b262f3d1-fe3e-44c0-9d5a-abcbb530f4c1
07a2efc2-57e0-4e0c-8547-9dea087fa998
38d48d59-d49f-4b01-bd84-6bbb4abff544
2e3985dd-75dc-4f91-a4e9-0d48c9bcd02c
f94370dd-6a28-4290-8d48-762c38a2836d
c321ce3e-512e-4ccf-9e46-8e6a0ba0a7af
f6bd8f03-d08e-4002-aa0d-27b2042b72d6
b42c6f36-633f-4f60-bf64-ffa45efe443c
16fb42bc-175c-4425-a8b0-909b7256dfd5
1ff7ad1c-4131-4d9a-ba79-debd89d8ede7
fd5dde54-3eef-4e27-99e7-a5b360b6dfdb
5ae8fd65-56aa-4ffa-bdd6-42e5de7cc7e4
d5bd0a42-29c1-4e23-a1c2-9f505035535e
1084120c-37c7-4957-8ba1-e6dca9742dd5
8a60c514-05bb-47dd-82be-b74ee047a4d3
d31151b6-9244-4be2-aba9-a116eac97281
5ccf3236-4285-46f5-b274-79cf02619a8f
55c662c3-5486-4a03-9a65-6be776b744bc
de3b6421-45e8-41c0-b76c-be018074ba2a
\.


--
-- Data for Name: eperson; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.eperson (eperson_id, email, password, can_log_in, require_certificate, self_registered, last_active, sub_frequency, netid, salt, digest_algorithm, uuid) FROM stdin;
\N	marcelo.braulio.si@gmail.com	\N	t	f	f	\N	\N	\N	\N	\N	f6bd8f03-d08e-4002-aa0d-27b2042b72d6
\N	marcelo.pedras@ict.ufvjm.edu.br	55061e3c692ee1132911af8203ebe574fc3c5c0278c5ef02d21189efe515101547789377daa2632c1115f8c66b80b85c233329718bf809c1d126f51b84c9e149	t	f	f	2019-08-29 12:17:56.954	\N	\N	6af5d907b44945b612b2c9fee4a6d3f2	SHA-512	07a2efc2-57e0-4e0c-8547-9dea087fa998
\N	bruno.pastre@ict.ufvjm.edu.br	6353ecdb3f40fe5efe8d0813453c17dea1aca7c1bf60b6bdf1599e51ab8bd8d08f836207dd27360d97dd313dd2c357a7d132482d1224ff6419d7f11bee151f7c	t	f	f	2019-08-29 12:30:07.041	\N	\N	2dafc5a8e21c9205be7e2e171017855c	SHA-512	16fb42bc-175c-4425-a8b0-909b7256dfd5
\.


--
-- Data for Name: epersongroup; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.epersongroup (eperson_group_id, uuid, permanent, name) FROM stdin;
\N	54c6e912-d753-42e6-9815-7b3507dde12c	t	Anonymous
\N	c1e437e4-2fc3-40c3-a2c5-af4df5204e4d	t	Administrator
\N	f94370dd-6a28-4290-8d48-762c38a2836d	f	COLLECTION_2e3985dd-75dc-4f91-a4e9-0d48c9bcd02c_SUBMIT
\N	c321ce3e-512e-4ccf-9e46-8e6a0ba0a7af	f	COLLECTION_2e3985dd-75dc-4f91-a4e9-0d48c9bcd02c_ADMIN
\N	d5bd0a42-29c1-4e23-a1c2-9f505035535e	f	COLLECTION_5ae8fd65-56aa-4ffa-bdd6-42e5de7cc7e4_SUBMIT
\N	8a60c514-05bb-47dd-82be-b74ee047a4d3	f	COLLECTION_1084120c-37c7-4957-8ba1-e6dca9742dd5_SUBMIT
\N	5ccf3236-4285-46f5-b274-79cf02619a8f	f	COLLECTION_d31151b6-9244-4be2-aba9-a116eac97281_SUBMIT
\N	de3b6421-45e8-41c0-b76c-be018074ba2a	f	COLLECTION_55c662c3-5486-4a03-9a65-6be776b744bc_SUBMIT
\N	1ff7ad1c-4131-4d9a-ba79-debd89d8ede7	f	COMMUNITY_38d48d59-d49f-4b01-bd84-6bbb4abff544_ADMIN
\.


--
-- Data for Name: epersongroup2eperson; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.epersongroup2eperson (eperson_group_id, eperson_id) FROM stdin;
f94370dd-6a28-4290-8d48-762c38a2836d	f6bd8f03-d08e-4002-aa0d-27b2042b72d6
d5bd0a42-29c1-4e23-a1c2-9f505035535e	07a2efc2-57e0-4e0c-8547-9dea087fa998
8a60c514-05bb-47dd-82be-b74ee047a4d3	07a2efc2-57e0-4e0c-8547-9dea087fa998
5ccf3236-4285-46f5-b274-79cf02619a8f	07a2efc2-57e0-4e0c-8547-9dea087fa998
de3b6421-45e8-41c0-b76c-be018074ba2a	07a2efc2-57e0-4e0c-8547-9dea087fa998
c1e437e4-2fc3-40c3-a2c5-af4df5204e4d	07a2efc2-57e0-4e0c-8547-9dea087fa998
1ff7ad1c-4131-4d9a-ba79-debd89d8ede7	16fb42bc-175c-4425-a8b0-909b7256dfd5
\.


--
-- Data for Name: epersongroup2workspaceitem; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.epersongroup2workspaceitem (workspace_item_id, eperson_group_id) FROM stdin;
\.


--
-- Data for Name: fileextension; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.fileextension (file_extension_id, bitstream_format_id, extension) FROM stdin;
1	4	pdf
2	5	xml
3	6	txt
4	6	asc
5	7	htm
6	7	html
7	8	css
8	9	doc
9	10	docx
10	11	ppt
11	12	pptx
12	13	xls
13	14	xlsx
14	16	jpeg
15	16	jpg
16	17	gif
17	18	png
18	19	tiff
19	19	tif
20	20	aiff
21	20	aif
22	20	aifc
23	21	au
24	21	snd
25	22	wav
26	23	mpeg
27	23	mpg
28	23	mpe
29	24	rtf
30	25	vsd
31	26	fm
32	27	bmp
33	28	psd
34	28	pdd
35	29	ps
36	29	eps
37	29	ai
38	30	mov
39	30	qt
40	31	mpa
41	31	abs
42	31	mpega
43	32	mpp
44	32	mpx
45	32	mpd
46	33	ma
47	34	latex
48	35	tex
49	36	dvi
50	37	sgm
51	37	sgml
52	38	wpd
53	39	ra
54	39	ram
55	40	pcd
56	41	odt
57	42	ott
58	43	oth
59	44	odm
60	45	odg
61	46	otg
62	47	odp
63	48	otp
64	49	ods
65	50	ots
66	51	odc
67	52	odf
68	53	odb
69	54	odi
70	55	oxt
71	56	sxw
72	57	stw
73	58	sxc
74	59	stc
75	60	sxd
76	61	std
77	62	sxi
78	63	sti
79	64	sxg
80	65	sxm
81	66	sdw
82	67	sgl
83	68	sdc
84	69	sda
85	70	sdd
86	71	sdp
87	72	smf
88	73	sds
89	74	sdm
90	75	rdf
91	76	epub
\.


--
-- Data for Name: group2group; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.group2group (parent_id, child_id) FROM stdin;
\.


--
-- Data for Name: group2groupcache; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.group2groupcache (parent_id, child_id) FROM stdin;
\.


--
-- Data for Name: handle; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.handle (handle_id, handle, resource_type_id, resource_legacy_id, resource_id) FROM stdin;
1	123456789/0	5	\N	b262f3d1-fe3e-44c0-9d5a-abcbb530f4c1
2	123456789/1	4	\N	38d48d59-d49f-4b01-bd84-6bbb4abff544
3	123456789/2	3	\N	2e3985dd-75dc-4f91-a4e9-0d48c9bcd02c
4	123456789/3	2	\N	\N
5	123456789/4	2	\N	\N
40	123456789/39	2	\N	\N
7	123456789/6	2	\N	\N
6	123456789/5	2	\N	\N
41	123456789/40	2	\N	\N
42	123456789/41	2	\N	\N
43	123456789/42	2	\N	\N
44	123456789/43	2	\N	\N
45	123456789/44	2	\N	\N
50	123456789/49	3	\N	5ae8fd65-56aa-4ffa-bdd6-42e5de7cc7e4
51	123456789/50	3	\N	1084120c-37c7-4957-8ba1-e6dca9742dd5
52	123456789/51	3	\N	d31151b6-9244-4be2-aba9-a116eac97281
53	123456789/52	3	\N	55c662c3-5486-4a03-9a65-6be776b744bc
46	123456789/45	2	\N	\N
47	123456789/46	2	\N	\N
48	123456789/47	2	\N	\N
49	123456789/48	2	\N	\N
54	123456789/53	2	\N	\N
\.


--
-- Data for Name: harvested_collection; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.harvested_collection (harvest_type, oai_source, oai_set_id, harvest_message, metadata_config_id, harvest_status, harvest_start_time, last_harvested, id, collection_id) FROM stdin;
1			\N	\N	0	\N	\N	1	2e3985dd-75dc-4f91-a4e9-0d48c9bcd02c
\.


--
-- Data for Name: harvested_item; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.harvested_item (last_harvested, oai_id, id, item_id) FROM stdin;
\.


--
-- Data for Name: item; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.item (item_id, in_archive, withdrawn, last_modified, discoverable, uuid, submitter_id, owning_collection) FROM stdin;
\N	f	f	2019-07-30 13:16:49.94+00	t	b42c6f36-633f-4f60-bf64-ffa45efe443c	\N	\N
\.


--
-- Data for Name: item2bundle; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.item2bundle (bundle_id, item_id) FROM stdin;
\.


--
-- Data for Name: metadatafieldregistry; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.metadatafieldregistry (metadata_field_id, metadata_schema_id, element, qualifier, scope_note) FROM stdin;
1	2	firstname	\N	\N
2	2	lastname	\N	\N
3	2	phone	\N	\N
4	2	language	\N	\N
5	1	provenance	\N	\N
6	1	rights	license	\N
7	1	contributor	\N	A person, organization, or service responsible for the content of the resource.  Catch-all for unspecified contributors.
8	1	contributor	advisor	Use primarily for thesis advisor.
9	1	contributor	author	\N
10	1	contributor	editor	\N
11	1	contributor	illustrator	\N
12	1	contributor	other	\N
13	1	coverage	spatial	Spatial characteristics of content.
14	1	coverage	temporal	Temporal characteristics of content.
15	1	creator	\N	Do not use; only for harvested metadata.
16	1	date	\N	Use qualified form if possible.
17	1	date	accessioned	Date DSpace takes possession of item.
18	1	date	available	Date or date range item became available to the public.
19	1	date	copyright	Date of copyright.
20	1	date	created	Date of creation or manufacture of intellectual content if different from date.issued.
21	1	date	issued	Date of publication or distribution.
22	1	date	submitted	Recommend for theses/dissertations.
23	1	identifier	\N	Catch-all for unambiguous identifiers not defined by\n    qualified form; use identifier.other for a known identifier common\n    to a local collection instead of unqualified form.
24	1	identifier	citation	Human-readable, standard bibliographic citation \n    of non-DSpace format of this item
25	1	identifier	govdoc	A government document number
26	1	identifier	isbn	International Standard Book Number
27	1	identifier	issn	International Standard Serial Number
28	1	identifier	sici	Serial Item and Contribution Identifier
29	1	identifier	ismn	International Standard Music Number
30	1	identifier	other	A known identifier type common to a local collection.
31	1	identifier	uri	Uniform Resource Identifier
32	1	description	\N	Catch-all for any description not defined by qualifiers.
33	1	description	abstract	Abstract or summary.
34	1	description	provenance	The history of custody of the item since its creation, including any changes successive custodians made to it.
35	1	description	sponsorship	Information about sponsoring agencies, individuals, or\n    contractual arrangements for the item.
36	1	description	statementofresponsibility	To preserve statement of responsibility from MARC records.
37	1	description	tableofcontents	A table of contents for a given item.
38	1	description	uri	Uniform Resource Identifier pointing to description of\n    this item.
39	1	format	\N	Catch-all for any format information not defined by qualifiers.
40	1	format	extent	Size or duration.
41	1	format	medium	Physical medium.
42	1	format	mimetype	Registered MIME type identifiers.
43	1	language	\N	Catch-all for non-ISO forms of the language of the\n    item, accommodating harvested values.
44	1	language	iso	Current ISO standard for language of intellectual content, including country codes (e.g. "en_US").
45	1	publisher	\N	Entity responsible for publication, distribution, or imprint.
46	1	relation	\N	Catch-all for references to other related items.
47	1	relation	isformatof	References additional physical form.
48	1	relation	ispartof	References physically or logically containing item.
49	1	relation	ispartofseries	Series name and number within that series, if available.
50	1	relation	haspart	References physically or logically contained item.
51	1	relation	isversionof	References earlier version.
52	1	relation	hasversion	References later version.
53	1	relation	isbasedon	References source.
54	1	relation	isreferencedby	Pointed to by referenced resource.
55	1	relation	requires	Referenced resource is required to support function,\n    delivery, or coherence of item.
56	1	relation	replaces	References preceeding item.
57	1	relation	isreplacedby	References succeeding item.
58	1	relation	uri	References Uniform Resource Identifier for related item.
59	1	rights	\N	Terms governing use and reproduction.
60	1	rights	uri	References terms governing use and reproduction.
61	1	source	\N	Do not use; only for harvested metadata.
62	1	source	uri	Do not use; only for harvested metadata.
63	1	subject	\N	Uncontrolled index term.
64	1	subject	classification	Catch-all for value from local classification system;\n    global classification systems will receive specific qualifier
65	1	subject	ddc	Dewey Decimal Classification Number
66	1	subject	lcc	Library of Congress Classification Number
67	1	subject	lcsh	Library of Congress Subject Headings
68	1	subject	mesh	MEdical Subject Headings
69	1	subject	other	Local controlled vocabulary; global vocabularies will receive specific qualifier.
70	1	title	\N	Title statement/title proper.
71	1	title	alternative	Varying (or substitute) form of title proper appearing in item,\n    e.g. abbreviation or translation
72	1	type	\N	Nature or genre of content.
73	3	abstract	\N	A summary of the resource.
74	3	accessRights	\N	Information about who can access the resource or an indication of its security status. May include information regarding access or restrictions based on privacy, security, or other policies.
75	3	accrualMethod	\N	The method by which items are added to a collection.
76	3	accrualPeriodicity	\N	The frequency with which items are added to a collection.
77	3	accrualPolicy	\N	The policy governing the addition of items to a collection.
78	3	alternative	\N	An alternative name for the resource.
79	3	audience	\N	A class of entity for whom the resource is intended or useful.
80	3	available	\N	Date (often a range) that the resource became or will become available.
81	3	bibliographicCitation	\N	Recommended practice is to include sufficient bibliographic detail to identify the resource as unambiguously as possible.
82	3	conformsTo	\N	An established standard to which the described resource conforms.
83	3	contributor	\N	An entity responsible for making contributions to the resource. Examples of a Contributor include a person, an organization, or a service.
84	3	coverage	\N	The spatial or temporal topic of the resource, the spatial applicability of the resource, or the jurisdiction under which the resource is relevant.
85	3	created	\N	Date of creation of the resource.
86	3	creator	\N	An entity primarily responsible for making the resource.
87	3	date	\N	A point or period of time associated with an event in the lifecycle of the resource.
88	3	dateAccepted	\N	Date of acceptance of the resource.
89	3	dateCopyrighted	\N	Date of copyright.
90	3	dateSubmitted	\N	Date of submission of the resource.
91	3	description	\N	An account of the resource.
92	3	educationLevel	\N	A class of entity, defined in terms of progression through an educational or training context, for which the described resource is intended.
93	3	extent	\N	The size or duration of the resource.
94	3	format	\N	The file format, physical medium, or dimensions of the resource.
95	3	hasFormat	\N	A related resource that is substantially the same as the pre-existing described resource, but in another format.
96	3	hasPart	\N	A related resource that is included either physically or logically in the described resource.
97	3	hasVersion	\N	A related resource that is a version, edition, or adaptation of the described resource.
98	3	identifier	\N	An unambiguous reference to the resource within a given context.
99	3	instructionalMethod	\N	A process, used to engender knowledge, attitudes and skills, that the described resource is designed to support.
100	3	isFormatOf	\N	A related resource that is substantially the same as the described resource, but in another format.
101	3	isPartOf	\N	A related resource in which the described resource is physically or logically included.
102	3	isReferencedBy	\N	A related resource that references, cites, or otherwise points to the described resource.
103	3	isReplacedBy	\N	A related resource that supplants, displaces, or supersedes the described resource.
104	3	isRequiredBy	\N	A related resource that requires the described resource to support its function, delivery, or coherence.
105	3	issued	\N	Date of formal issuance (e.g., publication) of the resource.
106	3	isVersionOf	\N	A related resource of which the described resource is a version, edition, or adaptation.
107	3	language	\N	A language of the resource.
108	3	license	\N	A legal document giving official permission to do something with the resource.
109	3	mediator	\N	An entity that mediates access to the resource and for whom the resource is intended or useful.
110	3	medium	\N	The material or physical carrier of the resource.
111	3	modified	\N	Date on which the resource was changed.
112	3	provenance	\N	A statement of any changes in ownership and custody of the resource since its creation that are significant for its authenticity, integrity, and interpretation.
113	3	publisher	\N	An entity responsible for making the resource available.
114	3	references	\N	A related resource that is referenced, cited, or otherwise pointed to by the described resource.
115	3	relation	\N	A related resource.
116	3	replaces	\N	A related resource that is supplanted, displaced, or superseded by the described resource.
117	3	requires	\N	A related resource that is required by the described resource to support its function, delivery, or coherence.
118	3	rights	\N	Information about rights held in and over the resource.
119	3	rightsHolder	\N	A person or organization owning or managing rights over the resource.
120	3	source	\N	A related resource from which the described resource is derived.
121	3	spatial	\N	Spatial characteristics of the resource.
122	3	subject	\N	The topic of the resource.
123	3	tableOfContents	\N	A list of subunits of the resource.
124	3	temporal	\N	Temporal characteristics of the resource.
125	3	title	\N	A name given to the resource.
126	3	type	\N	The nature or genre of the resource.
127	3	valid	\N	Date (often a range) of validity of a resource.
128	1	date	updated	The last time the item was updated via the SWORD interface
129	1	description	version	The Peer Reviewed status of an item
130	1	identifier	slug	a uri supplied via the sword slug header, as a suggested uri for the item
131	1	language	rfc3066	the rfc3066 form of the language for the item
132	1	rights	holder	The owner of the copyright
137	5	coverage	city	Município onde o sítio está localizado.
141	5	description	fulldescription	Descrição do rica em detalhes do artefato. Ex: Dois cravos inteiros produzidos em ferro.
142	5	physicalobject	category	Categoria em que a peça se enquadra. Artefato, Ecofato, Bioarqueológico, Estrutura/feição, Sedimento/solo, Arqueobotânico, Zooarqueológico ou Outros.
143	5	spatial	area	Descrição do local onde o artefato foi encontrado.
144	5	spatial	complement	Quadrícula, Quadra, Sondagem, Poço Teste ou Estrutura.
145	5	spatial	level	Nível
147	5	contributor	researcherphone	Telefone do pesquisador responsável.
148	5	contributor	researcheremail	Email do pesquisador.
150	5	date	addedtocollection	Data de incorporação no acervo.
135	5	identifier	processnumber	Número do processo junto ao IPHAN.
136	5	coverage	geographicregion	Definir a macrorregião de origem do material. Ex: Vale do Jequitinhonha. 
138	5	coverage	state	Estado aonde foi encontrado o material arqueológico.
139	5	identifier	registernumber	Número do registro inserido nas peças arquelógicas.
146	5	contributor	researchername	Nome do pesquisador responsável.
151	5	location	boxid	Identificação da caixa onde se encontra o artefato.
152	5	location	shelflevel	Identificação de qual estante da prateleira está a caixa do artefato.
153	5	location	shelfid	Identificação da prateleira onde está o artefato.
154	5	image	\N	Fotos do artefato.
155	5	text	miscdocuments	Documentos diversos. Documentação associada ao artefato.
158	5	type	productiontechnique	Técnicas de Produção. Lascado, Picoteado, Polido, Modelado, Perfurado, Roletado, Torneado, Moldado, Taxidermizado, Tecido, Assoprado, Fundido, Forjado, Indeterminado ou Outros.
159	5	type	decoration	Tipo de decoração. Alisado, Brunido, Corrugado, Escovado, Ungulado, Incisão, Impressão, Plástica, Pintado, Punção, Aplique, Engobe, Estêncil, Entalhe, Não se aplica ou Outros.
160	5	type	integrity	Integridade do artefato. Íntegro, Fragmentado ou Reconstituído.
161	5	type	conservationstate	Estado de conservação, condições físicas, grau de deterioração e a necessidade de intervenção. Bom (sem deterioração); Regular (não compromete o todo. Ex.: fissuras, esmaecimento, afloramento de sais, esfarelamento etc.); Ruim (compromete o todo. Ex.: quebradiço, com manchas, alto grau de corrosão) ou Péssimo (perdas irreversíveis).
162	5	type	conservationstatedescription	Descrição textual do estado de conservação do artefato.
163	5	modified	interventions	Intervenções sofridas. Higienização a seco, Higienização com água, Colagem/refixação, Restauração/reconstituição, Dessalinização, Remoção, Consolidação, Estabilização, Outros ou Não se aplica.
164	5	modified	packaging	Acondicionamento. Saco Plástico (Polietileno ou poliéster), Tecido não tecido de polipropileno (TNT), Não tecido de polietileno de alta densidade (Tyvek), Plástico Bolha, Papel, Papel livre de ácido ou ph neutro, Espuma de polietileno, Manta acrílica, Não possui ou Outros.
165	5	modified	unitilizationmarks	Descrição das inscrições ou marcas de uso.
166	5	format	measure	Medidas. Largura, comprimento, altura, diâmetro, profundidade.
167	5	format	weight	Peso.
168	5	relation	observations	Observações gerais.
133	5	project	name	Nome do projeto registrado junto ao IPHAN.
140	5	collection	denomination	Denominação do material. Ex: fragmento de ponta de flecha.
134	5	provenance	archaeologicalsite	Nome do(s) sítios arqueológico(s) de proveniência do material.
172	5	spatial	testpit	Poço teste.
174	5	spatial	other	Outra definição para área com respectivo valor.
169	5	spatial	square	Quadrícula.
170	5	spatial	quatrain	Quadra.
171	5	spatial	survey	Sondagem.
173	5	spatial	partofstructure	Estrutura.
156	5	medium	materialtype	Materiais que compõem o artefato. Borracha, Carvão, Cerâmica, Faiança, Porcelana, Couro, Fóssil, Lítico, Madeira, Malacológico, Metal, Osso, Papel, Sedimento, Plástico, Têxtil, Flora, Fauna, Vidro, Indeterminado ou Outros.
157	5	tableofcontents	quantity	Quantidade do artefato, quantidade de itens.
\.


--
-- Data for Name: metadataschemaregistry; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.metadataschemaregistry (metadata_schema_id, namespace, short_id) FROM stdin;
1	http://dublincore.org/documents/dcmi-terms/	dc
2	http://dspace.org/eperson	eperson
3	http://purl.org/dc/terms/	dcterms
4	http://dspace.org/namespace/local/	local
5	http://arqdata	arq
\.


--
-- Data for Name: metadatavalue; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.metadatavalue (metadata_value_id, metadata_field_id, text_value, text_lang, place, authority, confidence, dspace_object_id) FROM stdin;
38	1	Marcelo	\N	0	\N	-1	f6bd8f03-d08e-4002-aa0d-27b2042b72d6
39	2	Pedras	\N	0	\N	-1	f6bd8f03-d08e-4002-aa0d-27b2042b72d6
40	4	pt_BR	\N	0	\N	-1	f6bd8f03-d08e-4002-aa0d-27b2042b72d6
1751	1	Bruno	\N	0	\N	-1	16fb42bc-175c-4425-a8b0-909b7256dfd5
1752	2	Pastre	\N	0	\N	-1	16fb42bc-175c-4425-a8b0-909b7256dfd5
1753	4	pt_BR	\N	0	\N	-1	16fb42bc-175c-4425-a8b0-909b7256dfd5
19	1	Marcelo	\N	0	\N	-1	07a2efc2-57e0-4e0c-8547-9dea087fa998
20	2	Pedras	\N	0	\N	-1	07a2efc2-57e0-4e0c-8547-9dea087fa998
21	3		\N	0	\N	-1	07a2efc2-57e0-4e0c-8547-9dea087fa998
22	4	pt_BR	\N	0	\N	-1	07a2efc2-57e0-4e0c-8547-9dea087fa998
1754	70	Arqueologia	\N	0	\N	-1	38d48d59-d49f-4b01-bd84-6bbb4abff544
1755	33	Itens da reserva técnica do LAEP	\N	0	\N	-1	38d48d59-d49f-4b01-bd84-6bbb4abff544
1756	32	A reserva técnica do LAEP (Laboratório de Arqueologia e Estudo da Paisagem) foi criada em 2009, e desde então recebe materiais oriundos de todo o Brasil, em especial a porção norte do Estado de Minas Gerais. Os materiais provém majoritariamente de processos de licenciamento ambiental, em suas mais diferentes fases, e com uma grande diversidade cronológica e de material. Atualmente contamos com mais de 300.000 peças, que contém importantes informações sobre as sociedades humanas passadas, e que estão a disposição dos pesquisadores para a análise e investigação.	\N	0	\N	-1	38d48d59-d49f-4b01-bd84-6bbb4abff544
1757	59	Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut pulvinar consequat ipsum sed tincidunt. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Aliquam velit magna, feugiat et dapibus eget, congue ut ligula. Aliquam tristique felis eu iaculis fringilla. Curabitur eu mauris nibh. Morbi viverra arcu nisi. Nullam at lorem id turpis egestas egestas non nec odio. Donec malesuada, eros non feugiat bibendum, diam sapien convallis erat, eu posuere diam ante in tortor.	\N	0	\N	-1	38d48d59-d49f-4b01-bd84-6bbb4abff544
1758	37	Nullam porta viverra vestibulum. Aenean a eros eu odio ullamcorper volutpat ac vel tellus. Donec sollicitudin nibh euismod, ullamcorper elit sed, consectetur odio. Cras pulvinar velit non imperdiet pulvinar. Nulla sit amet elit vulputate, pretium metus sit amet, molestie massa. Aliquam erat volutpat. Nullam sagittis sem sit amet mauris efficitur auctor.	\N	0	\N	-1	38d48d59-d49f-4b01-bd84-6bbb4abff544
1759	70	Geral	\N	0	\N	-1	2e3985dd-75dc-4f91-a4e9-0d48c9bcd02c
1760	33		\N	0	\N	-1	2e3985dd-75dc-4f91-a4e9-0d48c9bcd02c
1761	32	Nesta coleção se encontra o material diversas partes de Minas Gerais e do Brasil, com grande diversidade de material e cronologia. Os materiais são em sua grande maioria frutos do licenciamento ambiental, ou de projetos temáticos do LAEP na região de Felício dos Santos.	\N	0	\N	-1	2e3985dd-75dc-4f91-a4e9-0d48c9bcd02c
1409	70	Quintal da Chica da Silva	\N	0	\N	-1	5ae8fd65-56aa-4ffa-bdd6-42e5de7cc7e4
1389	70	laep.png	\N	0	\N	-1	fd5dde54-3eef-4e27-99e7-a5b360b6dfdb
1390	61	/dspace/upload/laep.png	\N	0	\N	-1	fd5dde54-3eef-4e27-99e7-a5b360b6dfdb
1410	33		\N	0	\N	-1	5ae8fd65-56aa-4ffa-bdd6-42e5de7cc7e4
1411	32	Durante diversas temporadas entre 2013 e 2015, a equipe do LAEP realizou escavações arqueológicas que revelaram uma grande quantidade de material histórico, principalmente cerâmico, que nos ajuda a entender a história de Diamantina no auge da produção diamantífera na virada dos séculos XVIII e XIX.	\N	0	\N	-1	5ae8fd65-56aa-4ffa-bdd6-42e5de7cc7e4
1419	70	Praça do Mercado	\N	0	\N	-1	1084120c-37c7-4957-8ba1-e6dca9742dd5
1420	33		\N	0	\N	-1	1084120c-37c7-4957-8ba1-e6dca9742dd5
1421	32	Em um momento de restauração e obras na região central de Diamantina, a equipe do LAEP realizou escavações para garantir que os materiais não seriam perdidos. A coleção possui grande diversidade, e apresenta um pouco da cultura material que era descartada no centro da cidade.	\N	0	\N	-1	1084120c-37c7-4957-8ba1-e6dca9742dd5
1439	70	Porto de Santa Clara	\N	0	\N	-1	55c662c3-5486-4a03-9a65-6be776b744bc
1440	33		\N	0	\N	-1	55c662c3-5486-4a03-9a65-6be776b744bc
1441	32	No início do século XIX o transporte de mercadorias era algo custoso e demorado. Uma encomenda vindo do Rio de Janeiro para a região de Diamantina demorava mais de 9 meses através da Estrada Real. Esta dificuldade impulsionou o explorador Teófilo Otoni a buscar uma outra rota. Ele então decidiu por utilizar-se do Rio Mucuri para a navegação de mercadorias. Contudo, o rio não era inteiramente navegável, e desta forma foi necessário a construção de um porto que conectasse o rio até os mercados no interior. Este porto foi nomeado de Santa Clara, e durante duas décadas serviu de entreposto comercial no noroeste Mineiro. A empreitada foi, no entanto, um fiasco e o porto foi abandonado. No século XIX, na construção de um hidroelétrica, o porto foi escavado e seu material entregue ao LAEP. O material é muito variado, e compreende principalmente louças, cerâmicas, vidros e metais utilizados no comércio nacional e internacional.	\N	0	\N	-1	55c662c3-5486-4a03-9a65-6be776b744bc
1442	70	Sé de Mariana	\N	0	\N	-1	d31151b6-9244-4be2-aba9-a116eac97281
1443	33		\N	0	\N	-1	d31151b6-9244-4be2-aba9-a116eac97281
1444	32	A coleção Sé de Mariana é composta basicamente por ossadas de indivíduos sepultados na Igreja Sé Catedral da cidade de Mariana. Em uma restauração do imóvel, decidiu por retirar as ossadas e estudá-las. A coleção apresenta vestígios de mais de 70 indivíduos, e contém informações preciosas sobre como o estilo de vida colonial se materializou nas ossadas e nos apetrechos que acompanharam o sepultamento.	\N	0	\N	-1	d31151b6-9244-4be2-aba9-a116eac97281
\.


--
-- Data for Name: most_recent_checksum; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.most_recent_checksum (to_be_processed, expected_checksum, current_checksum, last_process_start_date, last_process_end_date, checksum_algorithm, matched_prev_checksum, result, bitstream_id) FROM stdin;
\.


--
-- Data for Name: registrationdata; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.registrationdata (registrationdata_id, email, token, expires) FROM stdin;
1	marcelo.braulio.si@gmail.com	c8d57d2a269f6f12667d7898aae00d99	\N
\.


--
-- Data for Name: requestitem; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.requestitem (requestitem_id, token, allfiles, request_email, request_name, request_date, accept_request, decision_date, expires, request_message, item_id, bitstream_id) FROM stdin;
\.


--
-- Data for Name: resourcepolicy; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.resourcepolicy (policy_id, resource_type_id, resource_id, action_id, start_date, end_date, rpname, rptype, rpdescription, eperson_id, epersongroup_id, dspace_object) FROM stdin;
3	3	\N	10	\N	\N	\N	\N	\N	\N	54c6e912-d753-42e6-9815-7b3507dde12c	2e3985dd-75dc-4f91-a4e9-0d48c9bcd02c
4	3	\N	9	\N	\N	\N	\N	\N	\N	54c6e912-d753-42e6-9815-7b3507dde12c	2e3985dd-75dc-4f91-a4e9-0d48c9bcd02c
5	3	\N	3	\N	\N	\N	\N	\N	\N	f94370dd-6a28-4290-8d48-762c38a2836d	2e3985dd-75dc-4f91-a4e9-0d48c9bcd02c
817	4	\N	11	\N	\N	\N	\N	\N	\N	1ff7ad1c-4131-4d9a-ba79-debd89d8ede7	38d48d59-d49f-4b01-bd84-6bbb4abff544
6	3	\N	11	\N	\N	\N	\N	\N	\N	c321ce3e-512e-4ccf-9e46-8e6a0ba0a7af	2e3985dd-75dc-4f91-a4e9-0d48c9bcd02c
2	3	\N	0	\N	\N	\N	\N	\N	\N	54c6e912-d753-42e6-9815-7b3507dde12c	2e3985dd-75dc-4f91-a4e9-0d48c9bcd02c
1	4	\N	0	\N	\N	\N	\N	\N	\N	54c6e912-d753-42e6-9815-7b3507dde12c	38d48d59-d49f-4b01-bd84-6bbb4abff544
803	0	\N	0	\N	\N	\N	\N	\N	\N	54c6e912-d753-42e6-9815-7b3507dde12c	\N
721	3	\N	3	\N	\N	\N	\N	\N	\N	5ccf3236-4285-46f5-b274-79cf02619a8f	d31151b6-9244-4be2-aba9-a116eac97281
708	0	\N	0	\N	\N	\N	\N	\N	\N	54c6e912-d753-42e6-9815-7b3507dde12c	fd5dde54-3eef-4e27-99e7-a5b360b6dfdb
709	0	\N	1	\N	\N	\N	\N	\N	07a2efc2-57e0-4e0c-8547-9dea087fa998	\N	fd5dde54-3eef-4e27-99e7-a5b360b6dfdb
718	3	\N	0	\N	\N	\N	\N	\N	\N	54c6e912-d753-42e6-9815-7b3507dde12c	d31151b6-9244-4be2-aba9-a116eac97281
711	3	\N	10	\N	\N	\N	\N	\N	\N	54c6e912-d753-42e6-9815-7b3507dde12c	5ae8fd65-56aa-4ffa-bdd6-42e5de7cc7e4
712	3	\N	9	\N	\N	\N	\N	\N	\N	54c6e912-d753-42e6-9815-7b3507dde12c	5ae8fd65-56aa-4ffa-bdd6-42e5de7cc7e4
713	3	\N	3	\N	\N	\N	\N	\N	\N	d5bd0a42-29c1-4e23-a1c2-9f505035535e	5ae8fd65-56aa-4ffa-bdd6-42e5de7cc7e4
710	3	\N	0	\N	\N	\N	\N	\N	\N	54c6e912-d753-42e6-9815-7b3507dde12c	5ae8fd65-56aa-4ffa-bdd6-42e5de7cc7e4
530	0	\N	0	\N	\N	\N	\N	\N	\N	54c6e912-d753-42e6-9815-7b3507dde12c	\N
715	3	\N	10	\N	\N	\N	\N	\N	\N	54c6e912-d753-42e6-9815-7b3507dde12c	1084120c-37c7-4957-8ba1-e6dca9742dd5
716	3	\N	9	\N	\N	\N	\N	\N	\N	54c6e912-d753-42e6-9815-7b3507dde12c	1084120c-37c7-4957-8ba1-e6dca9742dd5
717	3	\N	3	\N	\N	\N	\N	\N	\N	8a60c514-05bb-47dd-82be-b74ee047a4d3	1084120c-37c7-4957-8ba1-e6dca9742dd5
714	3	\N	0	\N	\N	\N	\N	\N	\N	54c6e912-d753-42e6-9815-7b3507dde12c	1084120c-37c7-4957-8ba1-e6dca9742dd5
719	3	\N	10	\N	\N	\N	\N	\N	\N	54c6e912-d753-42e6-9815-7b3507dde12c	d31151b6-9244-4be2-aba9-a116eac97281
720	3	\N	9	\N	\N	\N	\N	\N	\N	54c6e912-d753-42e6-9815-7b3507dde12c	d31151b6-9244-4be2-aba9-a116eac97281
723	3	\N	10	\N	\N	\N	\N	\N	\N	54c6e912-d753-42e6-9815-7b3507dde12c	55c662c3-5486-4a03-9a65-6be776b744bc
724	3	\N	9	\N	\N	\N	\N	\N	\N	54c6e912-d753-42e6-9815-7b3507dde12c	55c662c3-5486-4a03-9a65-6be776b744bc
725	3	\N	3	\N	\N	\N	\N	\N	\N	de3b6421-45e8-41c0-b76c-be018074ba2a	55c662c3-5486-4a03-9a65-6be776b744bc
722	3	\N	0	\N	\N	\N	\N	\N	\N	54c6e912-d753-42e6-9815-7b3507dde12c	55c662c3-5486-4a03-9a65-6be776b744bc
\.


--
-- Data for Name: schema_version; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.schema_version (installed_rank, version, description, type, script, checksum, installed_by, installed_on, execution_time, success) FROM stdin;
1	1	<< Flyway Baseline >>	BASELINE	<< Flyway Baseline >>	\N	dspace	2019-07-23 13:22:39.483327	0	t
2	1.1	Initial DSpace 1.1 database schema	SQL	V1.1__Initial_DSpace_1.1_database_schema.sql	1147897299	dspace	2019-07-23 13:22:39.712373	845	t
3	1.2	Upgrade to DSpace 1.2 schema	SQL	V1.2__Upgrade_to_DSpace_1.2_schema.sql	903973515	dspace	2019-07-23 13:22:40.582586	52	t
4	1.3	Upgrade to DSpace 1.3 schema	SQL	V1.3__Upgrade_to_DSpace_1.3_schema.sql	-783235991	dspace	2019-07-23 13:22:40.64656	129	t
5	1.3.9	Drop constraint for DSpace 1 4 schema	JDBC	org.dspace.storage.rdbms.migration.V1_3_9__Drop_constraint_for_DSpace_1_4_schema	-1	dspace	2019-07-23 13:22:40.790095	6	t
6	1.4	Upgrade to DSpace 1.4 schema	SQL	V1.4__Upgrade_to_DSpace_1.4_schema.sql	-831219528	dspace	2019-07-23 13:22:40.812621	255	t
7	1.5	Upgrade to DSpace 1.5 schema	SQL	V1.5__Upgrade_to_DSpace_1.5_schema.sql	-1234304544	dspace	2019-07-23 13:22:41.08324	389	t
8	1.5.9	Drop constraint for DSpace 1 6 schema	JDBC	org.dspace.storage.rdbms.migration.V1_5_9__Drop_constraint_for_DSpace_1_6_schema	-1	dspace	2019-07-23 13:22:41.48024	3	t
9	1.6	Upgrade to DSpace 1.6 schema	SQL	V1.6__Upgrade_to_DSpace_1.6_schema.sql	-495469766	dspace	2019-07-23 13:22:41.492778	67	t
10	1.7	Upgrade to DSpace 1.7 schema	SQL	V1.7__Upgrade_to_DSpace_1.7_schema.sql	-589640641	dspace	2019-07-23 13:22:41.570517	4	t
11	1.8	Upgrade to DSpace 1.8 schema	SQL	V1.8__Upgrade_to_DSpace_1.8_schema.sql	-171791117	dspace	2019-07-23 13:22:41.584912	2	t
12	3.0	Upgrade to DSpace 3.x schema	SQL	V3.0__Upgrade_to_DSpace_3.x_schema.sql	-1098885663	dspace	2019-07-23 13:22:41.595445	31	t
13	4.0	Upgrade to DSpace 4.x schema	SQL	V4.0__Upgrade_to_DSpace_4.x_schema.sql	1191833374	dspace	2019-07-23 13:22:41.634727	81	t
14	4.9.2015.10.26	DS-2818 registry update	SQL	V4.9_2015.10.26__DS-2818_registry_update.sql	1675451156	dspace	2019-07-23 13:22:41.727466	8	t
15	5.0.2014.08.08	DS-1945 Helpdesk Request a Copy	SQL	V5.0_2014.08.08__DS-1945_Helpdesk_Request_a_Copy.sql	-1208221648	dspace	2019-07-23 13:22:41.746047	12	t
16	5.0.2014.09.25	DS 1582 Metadata For All Objects drop constraint	JDBC	org.dspace.storage.rdbms.migration.V5_0_2014_09_25__DS_1582_Metadata_For_All_Objects_drop_constraint	-1	dspace	2019-07-23 13:22:41.77249	3	t
17	5.0.2014.09.26	DS-1582 Metadata For All Objects	SQL	V5.0_2014.09.26__DS-1582_Metadata_For_All_Objects.sql	1509433410	dspace	2019-07-23 13:22:41.785574	26	t
18	5.6.2016.08.23	DS-3097	SQL	V5.6_2016.08.23__DS-3097.sql	410632858	dspace	2019-07-23 13:22:41.821957	2	t
19	5.7.2017.04.11	DS-3563 Index metadatavalue resource type id column	SQL	V5.7_2017.04.11__DS-3563_Index_metadatavalue_resource_type_id_column.sql	912059617	dspace	2019-07-23 13:22:41.831043	12	t
20	5.7.2017.05.05	DS 3431 Add Policies for BasicWorkflow	JDBC	org.dspace.storage.rdbms.migration.V5_7_2017_05_05__DS_3431_Add_Policies_for_BasicWorkflow	-1	dspace	2019-07-23 13:22:41.852795	34	t
21	6.0.2015.03.06	DS 2701 Dso Uuid Migration	JDBC	org.dspace.storage.rdbms.migration.V6_0_2015_03_06__DS_2701_Dso_Uuid_Migration	-1	dspace	2019-07-23 13:22:41.903337	21	t
22	6.0.2015.03.07	DS-2701 Hibernate migration	SQL	V6.0_2015.03.07__DS-2701_Hibernate_migration.sql	-542830952	dspace	2019-07-23 13:22:41.933012	912	t
23	6.0.2015.08.31	DS 2701 Hibernate Workflow Migration	JDBC	org.dspace.storage.rdbms.migration.V6_0_2015_08_31__DS_2701_Hibernate_Workflow_Migration	-1	dspace	2019-07-23 13:22:42.85518	9	t
24	6.0.2016.01.03	DS-3024	SQL	V6.0_2016.01.03__DS-3024.sql	95468273	dspace	2019-07-23 13:22:42.871092	3	t
25	6.0.2016.01.26	DS 2188 Remove DBMS Browse Tables	JDBC	org.dspace.storage.rdbms.migration.V6_0_2016_01_26__DS_2188_Remove_DBMS_Browse_Tables	-1	dspace	2019-07-23 13:22:42.881671	18	t
26	6.0.2016.02.25	DS-3004-slow-searching-as-admin	SQL	V6.0_2016.02.25__DS-3004-slow-searching-as-admin.sql	-1623115511	dspace	2019-07-23 13:22:42.906018	13	t
27	6.0.2016.04.01	DS-1955 Increase embargo reason	SQL	V6.0_2016.04.01__DS-1955_Increase_embargo_reason.sql	283892016	dspace	2019-07-23 13:22:42.927419	11	t
28	6.0.2016.04.04	DS-3086-OAI-Performance-fix	SQL	V6.0_2016.04.04__DS-3086-OAI-Performance-fix.sql	445863295	dspace	2019-07-23 13:22:42.946549	30	t
29	6.0.2016.04.14	DS-3125-fix-bundle-bitstream-delete-rights	SQL	V6.0_2016.04.14__DS-3125-fix-bundle-bitstream-delete-rights.sql	-699277527	dspace	2019-07-23 13:22:42.984393	2	t
30	6.0.2016.05.10	DS-3168-fix-requestitem item id column	SQL	V6.0_2016.05.10__DS-3168-fix-requestitem_item_id_column.sql	-1122969100	dspace	2019-07-23 13:22:42.993471	21	t
31	6.0.2016.07.21	DS-2775	SQL	V6.0_2016.07.21__DS-2775.sql	-126635374	dspace	2019-07-23 13:22:43.022112	6	t
32	6.0.2016.07.26	DS-3277 fix handle assignment	SQL	V6.0_2016.07.26__DS-3277_fix_handle_assignment.sql	-284088754	dspace	2019-07-23 13:22:43.035	4	t
33	6.0.2016.08.23	DS-3097	SQL	V6.0_2016.08.23__DS-3097.sql	-1986377895	dspace	2019-07-23 13:22:43.048445	4	t
34	6.1.2017.01.03	DS 3431 Add Policies for BasicWorkflow	JDBC	org.dspace.storage.rdbms.migration.V6_1_2017_01_03__DS_3431_Add_Policies_for_BasicWorkflow	-1	dspace	2019-07-23 13:22:43.061273	25	t
\.


--
-- Data for Name: site; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.site (uuid) FROM stdin;
b262f3d1-fe3e-44c0-9d5a-abcbb530f4c1
\.


--
-- Data for Name: subscription; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.subscription (subscription_id, eperson_id, collection_id) FROM stdin;
\.


--
-- Data for Name: tasklistitem; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.tasklistitem (tasklist_id, workflow_id, eperson_id) FROM stdin;
\.


--
-- Data for Name: versionhistory; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.versionhistory (versionhistory_id) FROM stdin;
\.


--
-- Data for Name: versionitem; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.versionitem (versionitem_id, version_number, version_date, version_summary, versionhistory_id, eperson_id, item_id) FROM stdin;
\.


--
-- Data for Name: webapp; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.webapp (webapp_id, appname, url, started, isui) FROM stdin;
1	REST	http://localhost:8080/jspui	2019-07-23 13:22:56.522	0
2	JSPUI	http://localhost:8080/jspui	2019-07-23 13:23:07.483	1
3	REST	http://localhost:8080/jspui	2019-07-23 15:56:02.283	0
4	JSPUI	http://localhost:8080/jspui	2019-07-23 15:56:11.895	1
5	REST	http://localhost:8080/jspui	2019-07-24 15:40:10.082	0
6	JSPUI	http://localhost:8080/jspui	2019-07-24 15:40:19.811	1
7	REST	http://localhost:8080/jspui	2019-07-25 09:44:21.202	0
8	JSPUI	http://localhost:8080/jspui	2019-07-25 09:44:31.837	1
9	REST	http://localhost:8080/jspui	2019-07-25 14:59:39.727	0
10	JSPUI	http://localhost:8080/jspui	2019-07-25 14:59:50.73	1
11	REST	http://localhost:8080/jspui	2019-07-30 09:09:52.221	0
12	JSPUI	http://localhost:8080/jspui	2019-07-30 09:10:05.811	1
13	REST	http://localhost:8080/jspui	2019-07-30 10:38:15.712	0
14	JSPUI	http://localhost:8080/jspui	2019-07-30 10:38:24.176	1
15	REST	http://localhost:8080/jspui	2019-07-30 10:45:11.112	0
16	JSPUI	http://localhost:8080/jspui	2019-07-30 10:45:19.863	1
17	REST	http://localhost:8080/jspui	2019-07-30 11:09:11.155	0
18	JSPUI	http://localhost:8080/jspui	2019-07-30 11:09:20.426	1
19	REST	http://localhost:8080/jspui	2019-07-30 15:47:13.024	0
20	JSPUI	http://localhost:8080/jspui	2019-07-30 15:47:22.96	1
21	REST	http://localhost:8080/jspui	2019-07-30 16:41:10.345	0
22	JSPUI	http://localhost:8080/jspui	2019-07-30 16:41:18.581	1
23	REST	http://localhost:8080/jspui	2019-07-30 17:43:29.066	0
24	JSPUI	http://localhost:8080/jspui	2019-07-30 17:43:37.368	1
25	REST	http://localhost:8080/jspui	2019-08-01 10:16:07.854	0
26	JSPUI	http://localhost:8080/jspui	2019-08-01 10:16:16.299	1
27	REST	http://localhost:8080/jspui	2019-08-01 11:31:39.669	0
28	JSPUI	http://localhost:8080/jspui	2019-08-01 11:31:48.417	1
29	REST	http://localhost:8080/jspui	2019-08-01 14:07:15.322	0
30	JSPUI	http://localhost:8080/jspui	2019-08-01 14:07:25.897	1
31	REST	http://localhost:8080/jspui	2019-08-01 14:27:16.597	0
32	JSPUI	http://localhost:8080/jspui	2019-08-01 14:27:25.892	1
33	REST	http://localhost:8080/jspui	2019-08-01 15:37:32.18	0
34	JSPUI	http://localhost:8080/jspui	2019-08-01 15:37:41.095	1
35	REST	http://localhost:8080/jspui	2019-08-01 16:50:55.359	0
36	JSPUI	http://localhost:8080/jspui	2019-08-01 16:51:05.443	1
37	REST	http://localhost:8080/jspui	2019-08-02 11:05:25.57	0
38	JSPUI	http://localhost:8080/jspui	2019-08-02 11:05:34.901	1
39	REST	http://localhost:8080/jspui	2019-08-02 11:45:37.057	0
40	JSPUI	http://localhost:8080/jspui	2019-08-02 11:45:45.598	1
41	REST	http://localhost:8080/jspui	2019-08-02 12:03:17.415	0
42	JSPUI	http://localhost:8080/jspui	2019-08-02 12:03:28.164	1
43	REST	http://localhost:8080/jspui	2019-08-02 12:16:57.735	0
44	JSPUI	http://localhost:8080/jspui	2019-08-02 12:17:07.61	1
45	REST	http://localhost:8080/jspui	2019-08-02 15:37:00.296	0
46	JSPUI	http://localhost:8080/jspui	2019-08-02 15:37:12.708	1
47	REST	http://localhost:8080/jspui	2019-08-02 15:58:29.588	0
48	JSPUI	http://localhost:8080/jspui	2019-08-02 15:58:40.81	1
49	REST	http://localhost:8080/jspui	2019-08-05 10:35:09.083	0
50	JSPUI	http://localhost:8080/jspui	2019-08-05 10:35:17.505	1
51	REST	http://localhost:8080/jspui	2019-08-05 10:50:15.896	0
52	JSPUI	http://localhost:8080/jspui	2019-08-05 10:50:24.676	1
53	REST	http://localhost:8080/jspui	2019-08-05 11:03:55.287	0
54	JSPUI	http://localhost:8080/jspui	2019-08-05 11:04:04.556	1
55	REST	http://localhost:8080/jspui	2019-08-05 11:23:43.538	0
56	JSPUI	http://localhost:8080/jspui	2019-08-05 11:23:52.141	1
57	REST	http://localhost:8080/jspui	2019-08-05 11:39:49.394	0
58	JSPUI	http://localhost:8080/jspui	2019-08-05 11:39:58.762	1
59	REST	http://localhost:8080/jspui	2019-08-05 12:27:58.835	0
60	JSPUI	http://localhost:8080/jspui	2019-08-05 12:28:07.183	1
61	REST	http://localhost:8080/jspui	2019-08-05 12:51:13.451	0
62	JSPUI	http://localhost:8080/jspui	2019-08-05 12:51:25.19	1
63	REST	http://localhost:8080/jspui	2019-08-05 14:21:34.921	0
64	JSPUI	http://localhost:8080/jspui	2019-08-05 14:21:44.539	1
65	REST	http://localhost:8080/jspui	2019-08-05 14:40:46.848	0
66	JSPUI	http://localhost:8080/jspui	2019-08-05 14:40:57.251	1
67	REST	http://localhost:8080/jspui	2019-08-05 14:57:52.406	0
68	JSPUI	http://localhost:8080/jspui	2019-08-05 14:58:02.135	1
69	REST	http://localhost:8080/jspui	2019-08-05 15:32:55.632	0
70	JSPUI	http://localhost:8080/jspui	2019-08-05 15:33:08.257	1
71	REST	http://localhost:8080/jspui	2019-08-05 16:10:42.281	0
72	JSPUI	http://localhost:8080/jspui	2019-08-05 16:10:51.086	1
73	REST	http://localhost:8080/jspui	2019-08-05 16:26:43.081	0
74	JSPUI	http://localhost:8080/jspui	2019-08-05 16:26:53.078	1
75	REST	http://localhost:8080/jspui	2019-08-05 16:43:45.508	0
76	JSPUI	http://localhost:8080/jspui	2019-08-05 16:43:53.985	1
77	REST	http://localhost:8080/jspui	2019-08-05 17:30:42.745	0
78	JSPUI	http://localhost:8080/jspui	2019-08-05 17:30:55.13	1
79	REST	http://localhost:8080/jspui	2019-08-05 17:47:51.279	0
80	JSPUI	http://localhost:8080/jspui	2019-08-05 17:48:01.127	1
81	REST	http://localhost:8080/jspui	2019-08-05 18:15:45.229	0
82	JSPUI	http://localhost:8080/jspui	2019-08-05 18:15:53.713	1
83	REST	http://localhost:8080/jspui	2019-08-07 09:37:21.108	0
84	JSPUI	http://localhost:8080/jspui	2019-08-07 09:37:30.115	1
85	REST	http://localhost:8080/jspui	2019-08-07 09:40:00.576	0
86	JSPUI	http://localhost:8080/jspui	2019-08-07 09:40:09.405	1
87	REST	http://localhost:8080/jspui	2019-08-07 09:45:29.534	0
88	JSPUI	http://localhost:8080/jspui	2019-08-07 09:45:37.982	1
89	REST	http://localhost:8080/jspui	2019-08-07 10:29:07.945	0
90	JSPUI	http://localhost:8080/jspui	2019-08-07 10:29:17.125	1
225	JSPUI	http://localhost:8080/jspui	2019-08-15 11:53:16.385	1
224	REST	http://localhost:8080/jspui	2019-08-15 11:53:05.177	0
242	JSPUI	http://localhost:8080/jspui	2019-08-16 10:55:33.95	1
243	REST	http://localhost:8080/jspui	2019-08-16 10:55:47.227	0
204	REST	http://localhost:8080/jspui	2019-08-12 15:00:20.318	0
205	JSPUI	http://localhost:8080/jspui	2019-08-12 15:00:28.47	1
252	JSPUI	http://localhost:8080/jspui	2019-08-16 15:13:19.918	1
450	REST	http://localhost:8080/jspui	2019-08-29 12:14:52.939	0
451	JSPUI	http://localhost:8080/jspui	2019-08-29 12:15:22.188	1
\.


--
-- Data for Name: workflowitem; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.workflowitem (workflow_id, state, multiple_titles, published_before, multiple_files, item_id, collection_id, owner) FROM stdin;
\.


--
-- Data for Name: workspaceitem; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.workspaceitem (workspace_item_id, multiple_titles, published_before, multiple_files, stage_reached, page_reached, item_id, collection_id) FROM stdin;
\.


--
-- Name: bitstreamformatregistry_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.bitstreamformatregistry_seq', 76, true);


--
-- Name: checksum_history_check_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.checksum_history_check_id_seq', 1, false);


--
-- Name: doi_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.doi_seq', 1, false);


--
-- Name: fileextension_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.fileextension_seq', 91, true);


--
-- Name: handle_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.handle_id_seq', 54, true);


--
-- Name: handle_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.handle_seq', 53, true);


--
-- Name: harvested_collection_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.harvested_collection_seq', 1, true);


--
-- Name: harvested_item_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.harvested_item_seq', 1, false);


--
-- Name: history_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.history_seq', 1, false);


--
-- Name: metadatafieldregistry_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.metadatafieldregistry_seq', 174, true);


--
-- Name: metadataschemaregistry_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.metadataschemaregistry_seq', 5, true);


--
-- Name: metadatavalue_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.metadatavalue_seq', 1762, true);


--
-- Name: registrationdata_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.registrationdata_seq', 1, true);


--
-- Name: requestitem_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.requestitem_seq', 1, false);


--
-- Name: resourcepolicy_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.resourcepolicy_seq', 822, true);


--
-- Name: subscription_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.subscription_seq', 1, false);


--
-- Name: tasklistitem_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.tasklistitem_seq', 1, false);


--
-- Name: versionhistory_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.versionhistory_seq', 1, false);


--
-- Name: versionitem_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.versionitem_seq', 1, false);


--
-- Name: webapp_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.webapp_seq', 451, true);


--
-- Name: workflowitem_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.workflowitem_seq', 47, true);


--
-- Name: workspaceitem_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.workspaceitem_seq', 80, true);


--
-- Name: bitstream bitstream_id_unique; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.bitstream
    ADD CONSTRAINT bitstream_id_unique UNIQUE (uuid);


--
-- Name: bitstream bitstream_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.bitstream
    ADD CONSTRAINT bitstream_pkey PRIMARY KEY (uuid);


--
-- Name: bitstream bitstream_uuid_key; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.bitstream
    ADD CONSTRAINT bitstream_uuid_key UNIQUE (uuid);


--
-- Name: bitstreamformatregistry bitstreamformatregistry_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.bitstreamformatregistry
    ADD CONSTRAINT bitstreamformatregistry_pkey PRIMARY KEY (bitstream_format_id);


--
-- Name: bitstreamformatregistry bitstreamformatregistry_short_description_key; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.bitstreamformatregistry
    ADD CONSTRAINT bitstreamformatregistry_short_description_key UNIQUE (short_description);


--
-- Name: bundle2bitstream bundle2bitstream_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.bundle2bitstream
    ADD CONSTRAINT bundle2bitstream_pkey PRIMARY KEY (bitstream_id, bundle_id, bitstream_order);


--
-- Name: bundle bundle_id_unique; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.bundle
    ADD CONSTRAINT bundle_id_unique UNIQUE (uuid);


--
-- Name: bundle bundle_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.bundle
    ADD CONSTRAINT bundle_pkey PRIMARY KEY (uuid);


--
-- Name: bundle bundle_uuid_key; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.bundle
    ADD CONSTRAINT bundle_uuid_key UNIQUE (uuid);


--
-- Name: checksum_history checksum_history_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.checksum_history
    ADD CONSTRAINT checksum_history_pkey PRIMARY KEY (check_id);


--
-- Name: checksum_results checksum_results_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.checksum_results
    ADD CONSTRAINT checksum_results_pkey PRIMARY KEY (result_code);


--
-- Name: collection2item collection2item_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.collection2item
    ADD CONSTRAINT collection2item_pkey PRIMARY KEY (collection_id, item_id);


--
-- Name: collection collection_id_unique; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.collection
    ADD CONSTRAINT collection_id_unique UNIQUE (uuid);


--
-- Name: collection collection_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.collection
    ADD CONSTRAINT collection_pkey PRIMARY KEY (uuid);


--
-- Name: collection collection_uuid_key; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.collection
    ADD CONSTRAINT collection_uuid_key UNIQUE (uuid);


--
-- Name: community2collection community2collection_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.community2collection
    ADD CONSTRAINT community2collection_pkey PRIMARY KEY (collection_id, community_id);


--
-- Name: community2community community2community_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.community2community
    ADD CONSTRAINT community2community_pkey PRIMARY KEY (parent_comm_id, child_comm_id);


--
-- Name: community community_id_unique; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.community
    ADD CONSTRAINT community_id_unique UNIQUE (uuid);


--
-- Name: community community_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.community
    ADD CONSTRAINT community_pkey PRIMARY KEY (uuid);


--
-- Name: community community_uuid_key; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.community
    ADD CONSTRAINT community_uuid_key UNIQUE (uuid);


--
-- Name: doi doi_doi_key; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.doi
    ADD CONSTRAINT doi_doi_key UNIQUE (doi);


--
-- Name: doi doi_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.doi
    ADD CONSTRAINT doi_pkey PRIMARY KEY (doi_id);


--
-- Name: dspaceobject dspaceobject_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.dspaceobject
    ADD CONSTRAINT dspaceobject_pkey PRIMARY KEY (uuid);


--
-- Name: eperson eperson_email_key; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.eperson
    ADD CONSTRAINT eperson_email_key UNIQUE (email);


--
-- Name: eperson eperson_id_unique; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.eperson
    ADD CONSTRAINT eperson_id_unique UNIQUE (uuid);


--
-- Name: eperson eperson_netid_key; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.eperson
    ADD CONSTRAINT eperson_netid_key UNIQUE (netid);


--
-- Name: eperson eperson_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.eperson
    ADD CONSTRAINT eperson_pkey PRIMARY KEY (uuid);


--
-- Name: eperson eperson_uuid_key; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.eperson
    ADD CONSTRAINT eperson_uuid_key UNIQUE (uuid);


--
-- Name: epersongroup2eperson epersongroup2eperson_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.epersongroup2eperson
    ADD CONSTRAINT epersongroup2eperson_pkey PRIMARY KEY (eperson_group_id, eperson_id);


--
-- Name: epersongroup2workspaceitem epersongroup2workspaceitem_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.epersongroup2workspaceitem
    ADD CONSTRAINT epersongroup2workspaceitem_pkey PRIMARY KEY (workspace_item_id, eperson_group_id);


--
-- Name: epersongroup epersongroup_id_unique; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.epersongroup
    ADD CONSTRAINT epersongroup_id_unique UNIQUE (uuid);


--
-- Name: epersongroup epersongroup_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.epersongroup
    ADD CONSTRAINT epersongroup_pkey PRIMARY KEY (uuid);


--
-- Name: epersongroup epersongroup_uuid_key; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.epersongroup
    ADD CONSTRAINT epersongroup_uuid_key UNIQUE (uuid);


--
-- Name: fileextension fileextension_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.fileextension
    ADD CONSTRAINT fileextension_pkey PRIMARY KEY (file_extension_id);


--
-- Name: group2group group2group_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.group2group
    ADD CONSTRAINT group2group_pkey PRIMARY KEY (parent_id, child_id);


--
-- Name: group2groupcache group2groupcache_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.group2groupcache
    ADD CONSTRAINT group2groupcache_pkey PRIMARY KEY (parent_id, child_id);


--
-- Name: handle handle_handle_key; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.handle
    ADD CONSTRAINT handle_handle_key UNIQUE (handle);


--
-- Name: handle handle_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.handle
    ADD CONSTRAINT handle_pkey PRIMARY KEY (handle_id);


--
-- Name: harvested_collection harvested_collection_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.harvested_collection
    ADD CONSTRAINT harvested_collection_pkey PRIMARY KEY (id);


--
-- Name: harvested_item harvested_item_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.harvested_item
    ADD CONSTRAINT harvested_item_pkey PRIMARY KEY (id);


--
-- Name: item2bundle item2bundle_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.item2bundle
    ADD CONSTRAINT item2bundle_pkey PRIMARY KEY (bundle_id, item_id);


--
-- Name: item item_id_unique; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.item
    ADD CONSTRAINT item_id_unique UNIQUE (uuid);


--
-- Name: item item_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.item
    ADD CONSTRAINT item_pkey PRIMARY KEY (uuid);


--
-- Name: item item_uuid_key; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.item
    ADD CONSTRAINT item_uuid_key UNIQUE (uuid);


--
-- Name: metadatafieldregistry metadatafieldregistry_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.metadatafieldregistry
    ADD CONSTRAINT metadatafieldregistry_pkey PRIMARY KEY (metadata_field_id);


--
-- Name: metadataschemaregistry metadataschemaregistry_namespace_key; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.metadataschemaregistry
    ADD CONSTRAINT metadataschemaregistry_namespace_key UNIQUE (namespace);


--
-- Name: metadataschemaregistry metadataschemaregistry_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.metadataschemaregistry
    ADD CONSTRAINT metadataschemaregistry_pkey PRIMARY KEY (metadata_schema_id);


--
-- Name: metadatavalue metadatavalue_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.metadatavalue
    ADD CONSTRAINT metadatavalue_pkey PRIMARY KEY (metadata_value_id);


--
-- Name: registrationdata registrationdata_email_key; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.registrationdata
    ADD CONSTRAINT registrationdata_email_key UNIQUE (email);


--
-- Name: registrationdata registrationdata_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.registrationdata
    ADD CONSTRAINT registrationdata_pkey PRIMARY KEY (registrationdata_id);


--
-- Name: requestitem requestitem_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.requestitem
    ADD CONSTRAINT requestitem_pkey PRIMARY KEY (requestitem_id);


--
-- Name: requestitem requestitem_token_key; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.requestitem
    ADD CONSTRAINT requestitem_token_key UNIQUE (token);


--
-- Name: resourcepolicy resourcepolicy_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.resourcepolicy
    ADD CONSTRAINT resourcepolicy_pkey PRIMARY KEY (policy_id);


--
-- Name: schema_version schema_version_pk; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.schema_version
    ADD CONSTRAINT schema_version_pk PRIMARY KEY (installed_rank);


--
-- Name: site site_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.site
    ADD CONSTRAINT site_pkey PRIMARY KEY (uuid);


--
-- Name: subscription subscription_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.subscription
    ADD CONSTRAINT subscription_pkey PRIMARY KEY (subscription_id);


--
-- Name: tasklistitem tasklistitem_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.tasklistitem
    ADD CONSTRAINT tasklistitem_pkey PRIMARY KEY (tasklist_id);


--
-- Name: versionhistory versionhistory_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.versionhistory
    ADD CONSTRAINT versionhistory_pkey PRIMARY KEY (versionhistory_id);


--
-- Name: versionitem versionitem_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.versionitem
    ADD CONSTRAINT versionitem_pkey PRIMARY KEY (versionitem_id);


--
-- Name: webapp webapp_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.webapp
    ADD CONSTRAINT webapp_pkey PRIMARY KEY (webapp_id);


--
-- Name: workflowitem workflowitem_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.workflowitem
    ADD CONSTRAINT workflowitem_pkey PRIMARY KEY (workflow_id);


--
-- Name: workspaceitem workspaceitem_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.workspaceitem
    ADD CONSTRAINT workspaceitem_pkey PRIMARY KEY (workspace_item_id);


--
-- Name: bit_bitstream_fk_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX bit_bitstream_fk_idx ON public.bitstream USING btree (bitstream_format_id);


--
-- Name: bitstream_id_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX bitstream_id_idx ON public.bitstream USING btree (bitstream_id);


--
-- Name: bundle2bitstream_bitstream; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX bundle2bitstream_bitstream ON public.bundle2bitstream USING btree (bitstream_id);


--
-- Name: bundle2bitstream_bundle; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX bundle2bitstream_bundle ON public.bundle2bitstream USING btree (bundle_id);


--
-- Name: bundle_id_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX bundle_id_idx ON public.bundle USING btree (bundle_id);


--
-- Name: bundle_primary; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX bundle_primary ON public.bundle USING btree (primary_bitstream_id);


--
-- Name: ch_result_fk_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX ch_result_fk_idx ON public.checksum_history USING btree (result);


--
-- Name: checksum_history_bitstream; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX checksum_history_bitstream ON public.checksum_history USING btree (bitstream_id);


--
-- Name: collecion2item_collection; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX collecion2item_collection ON public.collection2item USING btree (collection_id);


--
-- Name: collecion2item_item; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX collecion2item_item ON public.collection2item USING btree (item_id);


--
-- Name: collection_bitstream; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX collection_bitstream ON public.collection USING btree (logo_bitstream_id);


--
-- Name: collection_id_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX collection_id_idx ON public.collection USING btree (collection_id);


--
-- Name: collection_submitter; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX collection_submitter ON public.collection USING btree (submitter);


--
-- Name: collection_template; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX collection_template ON public.collection USING btree (template_item_id);


--
-- Name: collection_workflow1; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX collection_workflow1 ON public.collection USING btree (workflow_step_1);


--
-- Name: collection_workflow2; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX collection_workflow2 ON public.collection USING btree (workflow_step_2);


--
-- Name: collection_workflow3; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX collection_workflow3 ON public.collection USING btree (workflow_step_3);


--
-- Name: community2collection_collection; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX community2collection_collection ON public.community2collection USING btree (collection_id);


--
-- Name: community2collection_community; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX community2collection_community ON public.community2collection USING btree (community_id);


--
-- Name: community2community_child; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX community2community_child ON public.community2community USING btree (child_comm_id);


--
-- Name: community2community_parent; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX community2community_parent ON public.community2community USING btree (parent_comm_id);


--
-- Name: community_admin; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX community_admin ON public.community USING btree (admin);


--
-- Name: community_bitstream; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX community_bitstream ON public.community USING btree (logo_bitstream_id);


--
-- Name: community_id_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX community_id_idx ON public.community USING btree (community_id);


--
-- Name: doi_doi_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX doi_doi_idx ON public.doi USING btree (doi);


--
-- Name: doi_object; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX doi_object ON public.doi USING btree (dspace_object);


--
-- Name: doi_resource_id_and_type_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX doi_resource_id_and_type_idx ON public.doi USING btree (resource_id, resource_type_id);


--
-- Name: eperson_email_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX eperson_email_idx ON public.eperson USING btree (email);


--
-- Name: eperson_group_id_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX eperson_group_id_idx ON public.epersongroup USING btree (eperson_group_id);


--
-- Name: eperson_id_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX eperson_id_idx ON public.eperson USING btree (eperson_id);


--
-- Name: epersongroup2eperson_group; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX epersongroup2eperson_group ON public.epersongroup2eperson USING btree (eperson_group_id);


--
-- Name: epersongroup2eperson_person; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX epersongroup2eperson_person ON public.epersongroup2eperson USING btree (eperson_id);


--
-- Name: epersongroup2workspaceitem_group; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX epersongroup2workspaceitem_group ON public.epersongroup2workspaceitem USING btree (eperson_group_id);


--
-- Name: epersongroup_unique_idx_name; Type: INDEX; Schema: public; Owner: dspace
--

CREATE UNIQUE INDEX epersongroup_unique_idx_name ON public.epersongroup USING btree (name);


--
-- Name: epg2wi_workspace_fk_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX epg2wi_workspace_fk_idx ON public.epersongroup2workspaceitem USING btree (workspace_item_id);


--
-- Name: fe_bitstream_fk_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX fe_bitstream_fk_idx ON public.fileextension USING btree (bitstream_format_id);


--
-- Name: group2group_child; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX group2group_child ON public.group2group USING btree (child_id);


--
-- Name: group2group_parent; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX group2group_parent ON public.group2group USING btree (parent_id);


--
-- Name: group2groupcache_child; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX group2groupcache_child ON public.group2groupcache USING btree (child_id);


--
-- Name: group2groupcache_parent; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX group2groupcache_parent ON public.group2groupcache USING btree (parent_id);


--
-- Name: handle_handle_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX handle_handle_idx ON public.handle USING btree (handle);


--
-- Name: handle_object; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX handle_object ON public.handle USING btree (resource_id);


--
-- Name: handle_resource_id_and_type_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX handle_resource_id_and_type_idx ON public.handle USING btree (resource_legacy_id, resource_type_id);


--
-- Name: harvested_collection_collection; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX harvested_collection_collection ON public.harvested_collection USING btree (collection_id);


--
-- Name: harvested_item_item; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX harvested_item_item ON public.harvested_item USING btree (item_id);


--
-- Name: item2bundle_bundle; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX item2bundle_bundle ON public.item2bundle USING btree (bundle_id);


--
-- Name: item2bundle_item; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX item2bundle_item ON public.item2bundle USING btree (item_id);


--
-- Name: item_collection; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX item_collection ON public.item USING btree (owning_collection);


--
-- Name: item_id_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX item_id_idx ON public.item USING btree (item_id);


--
-- Name: item_submitter; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX item_submitter ON public.item USING btree (submitter_id);


--
-- Name: metadatafield_schema_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX metadatafield_schema_idx ON public.metadatafieldregistry USING btree (metadata_schema_id);


--
-- Name: metadatafieldregistry_idx_element_qualifier; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX metadatafieldregistry_idx_element_qualifier ON public.metadatafieldregistry USING btree (element, qualifier);


--
-- Name: metadataschemaregistry_unique_idx_short_id; Type: INDEX; Schema: public; Owner: dspace
--

CREATE UNIQUE INDEX metadataschemaregistry_unique_idx_short_id ON public.metadataschemaregistry USING btree (short_id);


--
-- Name: metadatavalue_field_fk_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX metadatavalue_field_fk_idx ON public.metadatavalue USING btree (metadata_field_id);


--
-- Name: metadatavalue_field_object; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX metadatavalue_field_object ON public.metadatavalue USING btree (metadata_field_id, dspace_object_id);


--
-- Name: metadatavalue_object; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX metadatavalue_object ON public.metadatavalue USING btree (dspace_object_id);


--
-- Name: most_recent_checksum_bitstream; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX most_recent_checksum_bitstream ON public.most_recent_checksum USING btree (bitstream_id);


--
-- Name: mrc_result_fk_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX mrc_result_fk_idx ON public.most_recent_checksum USING btree (result);


--
-- Name: requestitem_bitstream; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX requestitem_bitstream ON public.requestitem USING btree (bitstream_id);


--
-- Name: requestitem_item; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX requestitem_item ON public.requestitem USING btree (item_id);


--
-- Name: resourcepolicy_group; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX resourcepolicy_group ON public.resourcepolicy USING btree (epersongroup_id);


--
-- Name: resourcepolicy_idx_rptype; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX resourcepolicy_idx_rptype ON public.resourcepolicy USING btree (rptype);


--
-- Name: resourcepolicy_object; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX resourcepolicy_object ON public.resourcepolicy USING btree (dspace_object);


--
-- Name: resourcepolicy_person; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX resourcepolicy_person ON public.resourcepolicy USING btree (eperson_id);


--
-- Name: resourcepolicy_type_id_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX resourcepolicy_type_id_idx ON public.resourcepolicy USING btree (resource_type_id, resource_id);


--
-- Name: schema_version_s_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX schema_version_s_idx ON public.schema_version USING btree (success);


--
-- Name: subscription_collection; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX subscription_collection ON public.subscription USING btree (collection_id);


--
-- Name: subscription_person; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX subscription_person ON public.subscription USING btree (eperson_id);


--
-- Name: tasklist_workflow_fk_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX tasklist_workflow_fk_idx ON public.tasklistitem USING btree (workflow_id);


--
-- Name: versionitem_item; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX versionitem_item ON public.versionitem USING btree (item_id);


--
-- Name: versionitem_person; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX versionitem_person ON public.versionitem USING btree (eperson_id);


--
-- Name: workspaceitem_coll; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX workspaceitem_coll ON public.workspaceitem USING btree (collection_id);


--
-- Name: workspaceitem_item; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX workspaceitem_item ON public.workspaceitem USING btree (item_id);


--
-- Name: bitstream bitstream_bitstream_format_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.bitstream
    ADD CONSTRAINT bitstream_bitstream_format_id_fkey FOREIGN KEY (bitstream_format_id) REFERENCES public.bitstreamformatregistry(bitstream_format_id);


--
-- Name: bitstream bitstream_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.bitstream
    ADD CONSTRAINT bitstream_uuid_fkey FOREIGN KEY (uuid) REFERENCES public.dspaceobject(uuid);


--
-- Name: bundle2bitstream bundle2bitstream_bitstream_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.bundle2bitstream
    ADD CONSTRAINT bundle2bitstream_bitstream_id_fkey FOREIGN KEY (bitstream_id) REFERENCES public.bitstream(uuid);


--
-- Name: bundle2bitstream bundle2bitstream_bundle_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.bundle2bitstream
    ADD CONSTRAINT bundle2bitstream_bundle_id_fkey FOREIGN KEY (bundle_id) REFERENCES public.bundle(uuid);


--
-- Name: bundle bundle_primary_bitstream_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.bundle
    ADD CONSTRAINT bundle_primary_bitstream_id_fkey FOREIGN KEY (primary_bitstream_id) REFERENCES public.bitstream(uuid);


--
-- Name: bundle bundle_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.bundle
    ADD CONSTRAINT bundle_uuid_fkey FOREIGN KEY (uuid) REFERENCES public.dspaceobject(uuid);


--
-- Name: checksum_history checksum_history_bitstream_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.checksum_history
    ADD CONSTRAINT checksum_history_bitstream_id_fkey FOREIGN KEY (bitstream_id) REFERENCES public.bitstream(uuid);


--
-- Name: checksum_history checksum_history_result_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.checksum_history
    ADD CONSTRAINT checksum_history_result_fkey FOREIGN KEY (result) REFERENCES public.checksum_results(result_code);


--
-- Name: collection2item collection2item_collection_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.collection2item
    ADD CONSTRAINT collection2item_collection_id_fkey FOREIGN KEY (collection_id) REFERENCES public.collection(uuid);


--
-- Name: collection2item collection2item_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.collection2item
    ADD CONSTRAINT collection2item_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.item(uuid);


--
-- Name: collection collection_admin_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.collection
    ADD CONSTRAINT collection_admin_fkey FOREIGN KEY (admin) REFERENCES public.epersongroup(uuid);


--
-- Name: collection collection_submitter_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.collection
    ADD CONSTRAINT collection_submitter_fkey FOREIGN KEY (submitter) REFERENCES public.epersongroup(uuid);


--
-- Name: collection collection_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.collection
    ADD CONSTRAINT collection_uuid_fkey FOREIGN KEY (uuid) REFERENCES public.dspaceobject(uuid);


--
-- Name: collection collection_workflow_step_1_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.collection
    ADD CONSTRAINT collection_workflow_step_1_fkey FOREIGN KEY (workflow_step_1) REFERENCES public.epersongroup(uuid);


--
-- Name: collection collection_workflow_step_2_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.collection
    ADD CONSTRAINT collection_workflow_step_2_fkey FOREIGN KEY (workflow_step_2) REFERENCES public.epersongroup(uuid);


--
-- Name: collection collection_workflow_step_3_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.collection
    ADD CONSTRAINT collection_workflow_step_3_fkey FOREIGN KEY (workflow_step_3) REFERENCES public.epersongroup(uuid);


--
-- Name: community2collection community2collection_collection_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.community2collection
    ADD CONSTRAINT community2collection_collection_id_fkey FOREIGN KEY (collection_id) REFERENCES public.collection(uuid);


--
-- Name: community2collection community2collection_community_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.community2collection
    ADD CONSTRAINT community2collection_community_id_fkey FOREIGN KEY (community_id) REFERENCES public.community(uuid);


--
-- Name: community2community community2community_child_comm_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.community2community
    ADD CONSTRAINT community2community_child_comm_id_fkey FOREIGN KEY (child_comm_id) REFERENCES public.community(uuid);


--
-- Name: community2community community2community_parent_comm_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.community2community
    ADD CONSTRAINT community2community_parent_comm_id_fkey FOREIGN KEY (parent_comm_id) REFERENCES public.community(uuid);


--
-- Name: community community_admin_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.community
    ADD CONSTRAINT community_admin_fkey FOREIGN KEY (admin) REFERENCES public.epersongroup(uuid);


--
-- Name: community community_logo_bitstream_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.community
    ADD CONSTRAINT community_logo_bitstream_id_fkey FOREIGN KEY (logo_bitstream_id) REFERENCES public.bitstream(uuid);


--
-- Name: community community_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.community
    ADD CONSTRAINT community_uuid_fkey FOREIGN KEY (uuid) REFERENCES public.dspaceobject(uuid);


--
-- Name: doi doi_dspace_object_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.doi
    ADD CONSTRAINT doi_dspace_object_fkey FOREIGN KEY (dspace_object) REFERENCES public.dspaceobject(uuid);


--
-- Name: eperson eperson_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.eperson
    ADD CONSTRAINT eperson_uuid_fkey FOREIGN KEY (uuid) REFERENCES public.dspaceobject(uuid);


--
-- Name: epersongroup2eperson epersongroup2eperson_eperson_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.epersongroup2eperson
    ADD CONSTRAINT epersongroup2eperson_eperson_group_id_fkey FOREIGN KEY (eperson_group_id) REFERENCES public.epersongroup(uuid);


--
-- Name: epersongroup2eperson epersongroup2eperson_eperson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.epersongroup2eperson
    ADD CONSTRAINT epersongroup2eperson_eperson_id_fkey FOREIGN KEY (eperson_id) REFERENCES public.eperson(uuid);


--
-- Name: epersongroup2workspaceitem epersongroup2workspaceitem_eperson_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.epersongroup2workspaceitem
    ADD CONSTRAINT epersongroup2workspaceitem_eperson_group_id_fkey FOREIGN KEY (eperson_group_id) REFERENCES public.epersongroup(uuid);


--
-- Name: epersongroup2workspaceitem epersongroup2workspaceitem_workspace_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.epersongroup2workspaceitem
    ADD CONSTRAINT epersongroup2workspaceitem_workspace_item_id_fkey FOREIGN KEY (workspace_item_id) REFERENCES public.workspaceitem(workspace_item_id);


--
-- Name: epersongroup epersongroup_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.epersongroup
    ADD CONSTRAINT epersongroup_uuid_fkey FOREIGN KEY (uuid) REFERENCES public.dspaceobject(uuid);


--
-- Name: fileextension fileextension_bitstream_format_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.fileextension
    ADD CONSTRAINT fileextension_bitstream_format_id_fkey FOREIGN KEY (bitstream_format_id) REFERENCES public.bitstreamformatregistry(bitstream_format_id);


--
-- Name: group2group group2group_child_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.group2group
    ADD CONSTRAINT group2group_child_id_fkey FOREIGN KEY (child_id) REFERENCES public.epersongroup(uuid);


--
-- Name: group2group group2group_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.group2group
    ADD CONSTRAINT group2group_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.epersongroup(uuid);


--
-- Name: group2groupcache group2groupcache_child_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.group2groupcache
    ADD CONSTRAINT group2groupcache_child_id_fkey FOREIGN KEY (child_id) REFERENCES public.epersongroup(uuid);


--
-- Name: group2groupcache group2groupcache_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.group2groupcache
    ADD CONSTRAINT group2groupcache_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.epersongroup(uuid);


--
-- Name: handle handle_resource_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.handle
    ADD CONSTRAINT handle_resource_id_fkey FOREIGN KEY (resource_id) REFERENCES public.dspaceobject(uuid);


--
-- Name: harvested_collection harvested_collection_collection_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.harvested_collection
    ADD CONSTRAINT harvested_collection_collection_id_fkey FOREIGN KEY (collection_id) REFERENCES public.collection(uuid);


--
-- Name: harvested_item harvested_item_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.harvested_item
    ADD CONSTRAINT harvested_item_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.item(uuid);


--
-- Name: item2bundle item2bundle_bundle_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.item2bundle
    ADD CONSTRAINT item2bundle_bundle_id_fkey FOREIGN KEY (bundle_id) REFERENCES public.bundle(uuid);


--
-- Name: item2bundle item2bundle_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.item2bundle
    ADD CONSTRAINT item2bundle_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.item(uuid);


--
-- Name: item item_owning_collection_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.item
    ADD CONSTRAINT item_owning_collection_fkey FOREIGN KEY (owning_collection) REFERENCES public.collection(uuid);


--
-- Name: item item_submitter_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.item
    ADD CONSTRAINT item_submitter_id_fkey FOREIGN KEY (submitter_id) REFERENCES public.eperson(uuid);


--
-- Name: item item_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.item
    ADD CONSTRAINT item_uuid_fkey FOREIGN KEY (uuid) REFERENCES public.dspaceobject(uuid);


--
-- Name: metadatafieldregistry metadatafieldregistry_metadata_schema_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.metadatafieldregistry
    ADD CONSTRAINT metadatafieldregistry_metadata_schema_id_fkey FOREIGN KEY (metadata_schema_id) REFERENCES public.metadataschemaregistry(metadata_schema_id);


--
-- Name: metadatavalue metadatavalue_dspace_object_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.metadatavalue
    ADD CONSTRAINT metadatavalue_dspace_object_id_fkey FOREIGN KEY (dspace_object_id) REFERENCES public.dspaceobject(uuid) ON DELETE CASCADE;


--
-- Name: metadatavalue metadatavalue_metadata_field_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.metadatavalue
    ADD CONSTRAINT metadatavalue_metadata_field_id_fkey FOREIGN KEY (metadata_field_id) REFERENCES public.metadatafieldregistry(metadata_field_id);


--
-- Name: most_recent_checksum most_recent_checksum_bitstream_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.most_recent_checksum
    ADD CONSTRAINT most_recent_checksum_bitstream_id_fkey FOREIGN KEY (bitstream_id) REFERENCES public.bitstream(uuid);


--
-- Name: most_recent_checksum most_recent_checksum_result_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.most_recent_checksum
    ADD CONSTRAINT most_recent_checksum_result_fkey FOREIGN KEY (result) REFERENCES public.checksum_results(result_code);


--
-- Name: requestitem requestitem_bitstream_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.requestitem
    ADD CONSTRAINT requestitem_bitstream_id_fkey FOREIGN KEY (bitstream_id) REFERENCES public.bitstream(uuid);


--
-- Name: requestitem requestitem_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.requestitem
    ADD CONSTRAINT requestitem_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.item(uuid);


--
-- Name: resourcepolicy resourcepolicy_dspace_object_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.resourcepolicy
    ADD CONSTRAINT resourcepolicy_dspace_object_fkey FOREIGN KEY (dspace_object) REFERENCES public.dspaceobject(uuid) ON DELETE CASCADE;


--
-- Name: resourcepolicy resourcepolicy_eperson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.resourcepolicy
    ADD CONSTRAINT resourcepolicy_eperson_id_fkey FOREIGN KEY (eperson_id) REFERENCES public.eperson(uuid);


--
-- Name: resourcepolicy resourcepolicy_epersongroup_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.resourcepolicy
    ADD CONSTRAINT resourcepolicy_epersongroup_id_fkey FOREIGN KEY (epersongroup_id) REFERENCES public.epersongroup(uuid);


--
-- Name: site site_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.site
    ADD CONSTRAINT site_uuid_fkey FOREIGN KEY (uuid) REFERENCES public.dspaceobject(uuid);


--
-- Name: subscription subscription_collection_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.subscription
    ADD CONSTRAINT subscription_collection_id_fkey FOREIGN KEY (collection_id) REFERENCES public.collection(uuid);


--
-- Name: subscription subscription_eperson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.subscription
    ADD CONSTRAINT subscription_eperson_id_fkey FOREIGN KEY (eperson_id) REFERENCES public.eperson(uuid);


--
-- Name: tasklistitem tasklistitem_eperson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.tasklistitem
    ADD CONSTRAINT tasklistitem_eperson_id_fkey FOREIGN KEY (eperson_id) REFERENCES public.eperson(uuid);


--
-- Name: tasklistitem tasklistitem_workflow_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.tasklistitem
    ADD CONSTRAINT tasklistitem_workflow_id_fkey FOREIGN KEY (workflow_id) REFERENCES public.workflowitem(workflow_id);


--
-- Name: versionitem versionitem_eperson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.versionitem
    ADD CONSTRAINT versionitem_eperson_id_fkey FOREIGN KEY (eperson_id) REFERENCES public.eperson(uuid);


--
-- Name: versionitem versionitem_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.versionitem
    ADD CONSTRAINT versionitem_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.item(uuid);


--
-- Name: versionitem versionitem_versionhistory_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.versionitem
    ADD CONSTRAINT versionitem_versionhistory_id_fkey FOREIGN KEY (versionhistory_id) REFERENCES public.versionhistory(versionhistory_id);


--
-- Name: workflowitem workflowitem_collection_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.workflowitem
    ADD CONSTRAINT workflowitem_collection_id_fkey FOREIGN KEY (collection_id) REFERENCES public.collection(uuid);


--
-- Name: workflowitem workflowitem_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.workflowitem
    ADD CONSTRAINT workflowitem_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.item(uuid);


--
-- Name: workflowitem workflowitem_owner_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.workflowitem
    ADD CONSTRAINT workflowitem_owner_fkey FOREIGN KEY (owner) REFERENCES public.eperson(uuid);


--
-- Name: workspaceitem workspaceitem_collection_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.workspaceitem
    ADD CONSTRAINT workspaceitem_collection_id_fk FOREIGN KEY (collection_id) REFERENCES public.collection(uuid);


--
-- Name: workspaceitem workspaceitem_collection_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.workspaceitem
    ADD CONSTRAINT workspaceitem_collection_id_fkey FOREIGN KEY (collection_id) REFERENCES public.collection(uuid);


--
-- Name: workspaceitem workspaceitem_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.workspaceitem
    ADD CONSTRAINT workspaceitem_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.item(uuid);


--
-- PostgreSQL database dump complete
--

