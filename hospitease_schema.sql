--
-- PostgreSQL database dump
--

-- Dumped from database version 15.10 (Homebrew)
-- Dumped by pg_dump version 15.10 (Homebrew)

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
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

-- *not* creating schema, since initdb creates it


--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: appointments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.appointments (
    id integer NOT NULL,
    patient_id integer NOT NULL,
    doctor_id integer NOT NULL,
    appointment_datetime character varying,
    problem character varying(255),
    appointment_type character varying(255),
    reason character varying(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    blood_pressure character varying(255),
    pulse_rate character varying(255),
    temperature character varying(255),
    spo2 character varying(255),
    weight character varying(255),
    additional_notes text,
    advice text,
    follow_up_date character varying,
    follow_up_notes text,
    appointment_date character varying(20),
    appointment_time character varying(20),
    hospital_id integer,
    status character varying(255),
    appointment_unique_id character varying(32)
);


--
-- Name: appointments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.appointments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: appointments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.appointments_id_seq OWNED BY public.appointments.id;


--
-- Name: audit_logs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.audit_logs (
    id integer NOT NULL,
    table_name character varying NOT NULL,
    record_id integer NOT NULL,
    action character varying NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    user_id integer,
    old_data text,
    new_data text
);


--
-- Name: audit_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.audit_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: audit_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.audit_logs_id_seq OWNED BY public.audit_logs.id;


--
-- Name: doctors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.doctors (
    id integer NOT NULL,
    first_name character varying(255) NOT NULL,
    last_name character varying(255) NOT NULL,
    specialization character varying(255) NOT NULL,
    phone_number character varying(20) NOT NULL,
    email character varying(255) NOT NULL,
    experience integer NOT NULL,
    is_active boolean DEFAULT true,
    hospital_id integer NOT NULL,
    title character varying(100),
    gender character varying(50),
    date_of_birth date,
    blood_group character varying(10),
    mobile_number character varying(20),
    emergency_contact character varying(20),
    address text,
    city character varying(100),
    state character varying(100),
    country character varying(100),
    zipcode character varying(20),
    medical_licence_number character varying(100),
    licence_authority character varying(255),
    license_expiry_date date,
    user_id integer
);


--
-- Name: doctors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.doctors_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: doctors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.doctors_id_seq OWNED BY public.doctors.id;


--
-- Name: documents; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.documents (
    id integer NOT NULL,
    document_name character varying(255) NOT NULL,
    document_type character varying(50) NOT NULL,
    upload_date character varying(100) NOT NULL,
    size character varying(50) NOT NULL,
    status character varying(50) NOT NULL,
    documentable_id integer NOT NULL,
    documentable_type character varying(50) NOT NULL
);


--
-- Name: documents_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.documents_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.documents_id_seq OWNED BY public.documents.id;


--
-- Name: family_history; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.family_history (
    id integer NOT NULL,
    appointment_id integer NOT NULL,
    relationship_to_you character varying(255),
    additional_notes character varying(255)
);


--
-- Name: family_history_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.family_history_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: family_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.family_history_id_seq OWNED BY public.family_history.id;


--
-- Name: health_info; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.health_info (
    id integer NOT NULL,
    appointment_id integer,
    known_allergies text,
    reaction_severity text,
    reaction_description text,
    dietary_habits text,
    physical_activity_level text,
    sleep_avg_hours integer,
    sleep_quality text,
    substance_use_smoking text,
    substance_use_alcohol text,
    stress_level text
);


--
-- Name: health_info_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.health_info_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: health_info_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.health_info_id_seq OWNED BY public.health_info.id;


--
-- Name: hospital_payments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.hospital_payments (
    id integer NOT NULL,
    hospital_id integer NOT NULL,
    date date NOT NULL,
    amount numeric(12,2) NOT NULL,
    payment_method character varying(50) NOT NULL,
    reference character varying(100),
    status character varying(50) NOT NULL,
    paid boolean DEFAULT false,
    remarks text
);


--
-- Name: hospital_payments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.hospital_payments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hospital_payments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.hospital_payments_id_seq OWNED BY public.hospital_payments.id;


--
-- Name: hospital_permissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.hospital_permissions (
    id integer NOT NULL,
    hospital_id integer,
    permission_id integer
);


--
-- Name: hospital_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.hospital_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hospital_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.hospital_permissions_id_seq OWNED BY public.hospital_permissions.id;


--
-- Name: hospitals; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.hospitals (
    id integer NOT NULL,
    name character varying NOT NULL,
    address character varying,
    city character varying,
    state character varying,
    country character varying,
    phone_number character varying,
    email character varying,
    admin_id integer,
    registration_number character varying(100),
    type character varying(100),
    logo_url text,
    website character varying(255),
    owner_name character varying(255),
    admin_contact_number character varying(20),
    number_of_beds integer,
    departments text[],
    specialties text[],
    facilities text[],
    ambulance_services boolean DEFAULT false,
    opening_hours jsonb,
    license_number character varying(100),
    license_expiry_date date,
    is_accredited boolean DEFAULT false,
    external_id character varying(255),
    timezone character varying(50),
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    zipcode character varying(255)
);


--
-- Name: hospitals_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.hospitals_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hospitals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.hospitals_id_seq OWNED BY public.hospitals.id;


--
-- Name: medical_histories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.medical_histories (
    id integer NOT NULL,
    condition character varying NOT NULL,
    diagnosis_date date NOT NULL,
    treatment text,
    doctor character varying,
    hospital character varying,
    status character varying,
    patient_id integer NOT NULL
);


--
-- Name: medical_histories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.medical_histories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: medical_histories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.medical_histories_id_seq OWNED BY public.medical_histories.id;


--
-- Name: medicines; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.medicines (
    id integer NOT NULL,
    appointment_id integer NOT NULL,
    name character varying NOT NULL,
    dosage character varying NOT NULL,
    frequency character varying NOT NULL,
    duration character varying NOT NULL,
    start_date character varying NOT NULL,
    status character varying NOT NULL,
    time_interval character varying(255),
    route character varying(255),
    quantity character varying(255),
    instruction character varying(255)
);


--
-- Name: medicines_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.medicines_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: medicines_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.medicines_id_seq OWNED BY public.medicines.id;


--
-- Name: patients; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.patients (
    id integer NOT NULL,
    first_name character varying NOT NULL,
    middle_name character varying,
    last_name character varying NOT NULL,
    date_of_birth character varying,
    gender character varying NOT NULL,
    phone_number character varying,
    landline character varying,
    address character varying,
    landmark character varying,
    city character varying,
    state character varying,
    country character varying,
    blood_group character varying,
    email character varying,
    occupation character varying,
    is_dialysis_patient boolean,
    hospital_id integer NOT NULL,
    marital_status character varying(255),
    zipcode character varying(20),
    patient_unique_id character varying(255) DEFAULT 'DUMMY_ID'::character varying NOT NULL
);


--
-- Name: patients_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.patients_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: patients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.patients_id_seq OWNED BY public.patients.id;


--
-- Name: permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: permissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.permissions (
    id integer DEFAULT nextval('public.permissions_id_seq'::regclass) NOT NULL,
    name character varying(100) NOT NULL,
    description character varying(255),
    amount numeric(12,2)
);


--
-- Name: receipt_line_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.receipt_line_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: receipt_line_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.receipt_line_items (
    id integer DEFAULT nextval('public.receipt_line_items_id_seq'::regclass) NOT NULL,
    item character varying(100),
    quantity integer,
    rate double precision,
    amount double precision,
    receipt_id integer
);


--
-- Name: receipts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.receipts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: receipts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.receipts (
    id integer DEFAULT nextval('public.receipts_id_seq'::regclass) NOT NULL,
    hospital_id integer NOT NULL,
    patient_id integer NOT NULL,
    doctor_id integer NOT NULL,
    subtotal double precision,
    discount double precision,
    tax double precision,
    total double precision,
    payment_mode character varying(50),
    is_paid boolean DEFAULT false,
    notes text,
    status character varying(50),
    receipt_unique_no character varying(100),
    created timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.roles (
    id integer NOT NULL,
    name character varying NOT NULL
);


--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.roles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;


--
-- Name: symptoms; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.symptoms (
    id integer NOT NULL,
    description character varying NOT NULL,
    duration character varying NOT NULL,
    severity character varying NOT NULL,
    onset character varying(255),
    contributing_factors character varying,
    recurring boolean DEFAULT false,
    doctor_comment character varying,
    doctor_suggestions character varying,
    appointment_id integer NOT NULL
);


--
-- Name: symptoms_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.symptoms_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: symptoms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.symptoms_id_seq OWNED BY public.symptoms.id;


--
-- Name: tests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tests (
    id integer NOT NULL,
    appointment_id integer,
    test_details character varying(255) NOT NULL,
    status character varying(50) NOT NULL,
    cost numeric(10,2) NOT NULL,
    description text,
    doctor_notes text,
    staff_notes text,
    test_date character varying(50) NOT NULL,
    test_done_date character varying(50),
    tests_docs_urls text
);


--
-- Name: tests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tests_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tests_id_seq OWNED BY public.tests.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id integer NOT NULL,
    email character varying,
    password character varying,
    first_name character varying,
    last_name character varying,
    gender character varying,
    phone_number character varying,
    role_id integer,
    marital_status character varying(255),
    zipcode character varying(20),
    hospital_id integer
);


--
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
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: vitals; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.vitals (
    id integer NOT NULL,
    appointment_id integer,
    capture_date character varying(255) NOT NULL,
    vital_name character varying(255) NOT NULL,
    vital_value text NOT NULL,
    vital_unit character varying(50) NOT NULL,
    recorded_by character varying(255) NOT NULL,
    recorded_at character varying(255) NOT NULL
);


--
-- Name: vitals_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.vitals_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: vitals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.vitals_id_seq OWNED BY public.vitals.id;


--
-- Name: appointments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.appointments ALTER COLUMN id SET DEFAULT nextval('public.appointments_id_seq'::regclass);


--
-- Name: audit_logs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audit_logs ALTER COLUMN id SET DEFAULT nextval('public.audit_logs_id_seq'::regclass);


--
-- Name: doctors id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.doctors ALTER COLUMN id SET DEFAULT nextval('public.doctors_id_seq'::regclass);


--
-- Name: documents id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.documents ALTER COLUMN id SET DEFAULT nextval('public.documents_id_seq'::regclass);


--
-- Name: family_history id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.family_history ALTER COLUMN id SET DEFAULT nextval('public.family_history_id_seq'::regclass);


--
-- Name: health_info id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.health_info ALTER COLUMN id SET DEFAULT nextval('public.health_info_id_seq'::regclass);


--
-- Name: hospital_payments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hospital_payments ALTER COLUMN id SET DEFAULT nextval('public.hospital_payments_id_seq'::regclass);


--
-- Name: hospital_permissions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hospital_permissions ALTER COLUMN id SET DEFAULT nextval('public.hospital_permissions_id_seq'::regclass);


--
-- Name: hospitals id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hospitals ALTER COLUMN id SET DEFAULT nextval('public.hospitals_id_seq'::regclass);


--
-- Name: medical_histories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.medical_histories ALTER COLUMN id SET DEFAULT nextval('public.medical_histories_id_seq'::regclass);


--
-- Name: medicines id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.medicines ALTER COLUMN id SET DEFAULT nextval('public.medicines_id_seq'::regclass);


--
-- Name: patients id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.patients ALTER COLUMN id SET DEFAULT nextval('public.patients_id_seq'::regclass);


--
-- Name: roles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);


--
-- Name: symptoms id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.symptoms ALTER COLUMN id SET DEFAULT nextval('public.symptoms_id_seq'::regclass);


--
-- Name: tests id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tests ALTER COLUMN id SET DEFAULT nextval('public.tests_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: vitals id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vitals ALTER COLUMN id SET DEFAULT nextval('public.vitals_id_seq'::regclass);


--
-- Name: appointments appointments_appointment_unique_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT appointments_appointment_unique_id_key UNIQUE (appointment_unique_id);


--
-- Name: appointments appointments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT appointments_pkey PRIMARY KEY (id);


--
-- Name: audit_logs audit_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_pkey PRIMARY KEY (id);


--
-- Name: doctors doctors_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.doctors
    ADD CONSTRAINT doctors_email_key UNIQUE (email);


--
-- Name: doctors doctors_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.doctors
    ADD CONSTRAINT doctors_pkey PRIMARY KEY (id);


--
-- Name: documents documents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.documents
    ADD CONSTRAINT documents_pkey PRIMARY KEY (id);


--
-- Name: family_history family_history_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.family_history
    ADD CONSTRAINT family_history_pkey PRIMARY KEY (id);


--
-- Name: health_info health_info_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.health_info
    ADD CONSTRAINT health_info_pkey PRIMARY KEY (id);


--
-- Name: hospital_payments hospital_payments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hospital_payments
    ADD CONSTRAINT hospital_payments_pkey PRIMARY KEY (id);


--
-- Name: hospital_permissions hospital_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hospital_permissions
    ADD CONSTRAINT hospital_permissions_pkey PRIMARY KEY (id);


--
-- Name: hospitals hospitals_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hospitals
    ADD CONSTRAINT hospitals_pkey PRIMARY KEY (id);


--
-- Name: medical_histories medical_histories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.medical_histories
    ADD CONSTRAINT medical_histories_pkey PRIMARY KEY (id);


--
-- Name: medicines medicines_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.medicines
    ADD CONSTRAINT medicines_pkey PRIMARY KEY (id);


--
-- Name: patients patients_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.patients
    ADD CONSTRAINT patients_email_key UNIQUE (email);


--
-- Name: patients patients_phone_number_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.patients
    ADD CONSTRAINT patients_phone_number_key UNIQUE (phone_number);


--
-- Name: patients patients_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.patients
    ADD CONSTRAINT patients_pkey PRIMARY KEY (id);


--
-- Name: permissions permissions_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_name_key UNIQUE (name);


--
-- Name: permissions permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);


--
-- Name: receipt_line_items receipt_line_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.receipt_line_items
    ADD CONSTRAINT receipt_line_items_pkey PRIMARY KEY (id);


--
-- Name: receipts receipts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.receipts
    ADD CONSTRAINT receipts_pkey PRIMARY KEY (id);


--
-- Name: receipts receipts_receipt_unique_no_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.receipts
    ADD CONSTRAINT receipts_receipt_unique_no_key UNIQUE (receipt_unique_no);


--
-- Name: roles roles_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_name_key UNIQUE (name);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: symptoms symptoms_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.symptoms
    ADD CONSTRAINT symptoms_pkey PRIMARY KEY (id);


--
-- Name: tests tests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tests
    ADD CONSTRAINT tests_pkey PRIMARY KEY (id);


--
-- Name: patients unique_patient_id; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.patients
    ADD CONSTRAINT unique_patient_id UNIQUE (patient_unique_id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: vitals vitals_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vitals
    ADD CONSTRAINT vitals_pkey PRIMARY KEY (id);


--
-- Name: idx_hospital_payments_hospital_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_hospital_payments_hospital_id ON public.hospital_payments USING btree (hospital_id);


--
-- Name: idx_medical_histories_patient_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_medical_histories_patient_id ON public.medical_histories USING btree (patient_id);


--
-- Name: idx_permissions_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_permissions_id ON public.permissions USING btree (id);


--
-- Name: idx_permissions_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_permissions_name ON public.permissions USING btree (name);


--
-- Name: idx_receipt_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_receipt_id ON public.receipt_line_items USING btree (receipt_id);


--
-- Name: ix_audit_logs_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_audit_logs_id ON public.audit_logs USING btree (id);


--
-- Name: ix_hospitals_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_hospitals_id ON public.hospitals USING btree (id);


--
-- Name: ix_patients_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_patients_id ON public.patients USING btree (id);


--
-- Name: ix_roles_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_roles_id ON public.roles USING btree (id);


--
-- Name: ix_users_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_users_id ON public.users USING btree (id);


--
-- Name: appointments trigger_update_appointments; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trigger_update_appointments BEFORE UPDATE ON public.appointments FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: appointments appointments_doctor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT appointments_doctor_id_fkey FOREIGN KEY (doctor_id) REFERENCES public.doctors(id) ON DELETE CASCADE;


--
-- Name: appointments appointments_patient_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT appointments_patient_id_fkey FOREIGN KEY (patient_id) REFERENCES public.patients(id) ON DELETE CASCADE;


--
-- Name: doctors doctors_hospital_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.doctors
    ADD CONSTRAINT doctors_hospital_id_fkey FOREIGN KEY (hospital_id) REFERENCES public.hospitals(id) ON DELETE CASCADE;


--
-- Name: family_history family_history_appointment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.family_history
    ADD CONSTRAINT family_history_appointment_id_fkey FOREIGN KEY (appointment_id) REFERENCES public.appointments(id) ON DELETE CASCADE;


--
-- Name: symptoms fk_appointment; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.symptoms
    ADD CONSTRAINT fk_appointment FOREIGN KEY (appointment_id) REFERENCES public.appointments(id) ON DELETE CASCADE;


--
-- Name: health_info health_info_appointment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.health_info
    ADD CONSTRAINT health_info_appointment_id_fkey FOREIGN KEY (appointment_id) REFERENCES public.appointments(id) ON DELETE CASCADE;


--
-- Name: hospital_payments hospital_payments_hospital_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hospital_payments
    ADD CONSTRAINT hospital_payments_hospital_id_fkey FOREIGN KEY (hospital_id) REFERENCES public.hospitals(id) ON DELETE CASCADE;


--
-- Name: hospital_permissions hospital_permissions_hospital_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hospital_permissions
    ADD CONSTRAINT hospital_permissions_hospital_id_fkey FOREIGN KEY (hospital_id) REFERENCES public.hospitals(id) ON DELETE CASCADE;


--
-- Name: hospital_permissions hospital_permissions_permission_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hospital_permissions
    ADD CONSTRAINT hospital_permissions_permission_id_fkey FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;


--
-- Name: hospitals hospitals_admin_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hospitals
    ADD CONSTRAINT hospitals_admin_id_fkey FOREIGN KEY (admin_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: medical_histories medical_histories_patient_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.medical_histories
    ADD CONSTRAINT medical_histories_patient_id_fkey FOREIGN KEY (patient_id) REFERENCES public.patients(id) ON DELETE CASCADE;


--
-- Name: medicines medicines_appointment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.medicines
    ADD CONSTRAINT medicines_appointment_id_fkey FOREIGN KEY (appointment_id) REFERENCES public.appointments(id) ON DELETE CASCADE;


--
-- Name: patients patients_hospital_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.patients
    ADD CONSTRAINT patients_hospital_id_fkey FOREIGN KEY (hospital_id) REFERENCES public.hospitals(id);


--
-- Name: receipt_line_items receipt_line_items_receipt_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.receipt_line_items
    ADD CONSTRAINT receipt_line_items_receipt_id_fkey FOREIGN KEY (receipt_id) REFERENCES public.receipts(id) ON DELETE CASCADE;


--
-- Name: users users_hospital_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_hospital_id_fkey FOREIGN KEY (hospital_id) REFERENCES public.hospitals(id);


--
-- Name: vitals vitals_appointment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vitals
    ADD CONSTRAINT vitals_appointment_id_fkey FOREIGN KEY (appointment_id) REFERENCES public.appointments(id) ON DELETE CASCADE;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: -
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- Name: TABLE appointments; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.appointments TO hospitease_admin;


--
-- Name: SEQUENCE appointments_id_seq; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON SEQUENCE public.appointments_id_seq TO hospitease_admin;


--
-- Name: TABLE audit_logs; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.audit_logs TO hospitease_admin;


--
-- Name: SEQUENCE audit_logs_id_seq; Type: ACL; Schema: public; Owner: -
--

GRANT SELECT,USAGE ON SEQUENCE public.audit_logs_id_seq TO hospitease_admin;


--
-- Name: TABLE doctors; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.doctors TO hospitease_admin;


--
-- Name: SEQUENCE doctors_id_seq; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON SEQUENCE public.doctors_id_seq TO hospitease_admin;


--
-- Name: TABLE documents; Type: ACL; Schema: public; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.documents TO hospitease_admin;


--
-- Name: SEQUENCE documents_id_seq; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON SEQUENCE public.documents_id_seq TO hospitease_admin;


--
-- Name: TABLE family_history; Type: ACL; Schema: public; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.family_history TO hospitease_admin;


--
-- Name: SEQUENCE family_history_id_seq; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON SEQUENCE public.family_history_id_seq TO hospitease_admin;


--
-- Name: TABLE health_info; Type: ACL; Schema: public; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.health_info TO hospitease_admin;


--
-- Name: SEQUENCE health_info_id_seq; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON SEQUENCE public.health_info_id_seq TO hospitease_admin;


--
-- Name: TABLE hospital_payments; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.hospital_payments TO hospitease_admin;


--
-- Name: SEQUENCE hospital_payments_id_seq; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON SEQUENCE public.hospital_payments_id_seq TO hospitease_admin;


--
-- Name: TABLE hospital_permissions; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.hospital_permissions TO hospitease_admin;


--
-- Name: SEQUENCE hospital_permissions_id_seq; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON SEQUENCE public.hospital_permissions_id_seq TO hospitease_admin;


--
-- Name: TABLE hospitals; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.hospitals TO postgres;


--
-- Name: TABLE medical_histories; Type: ACL; Schema: public; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.medical_histories TO hospitease_admin;


--
-- Name: SEQUENCE medical_histories_id_seq; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON SEQUENCE public.medical_histories_id_seq TO hospitease_admin;


--
-- Name: TABLE medicines; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.medicines TO hospitease_admin;


--
-- Name: SEQUENCE medicines_id_seq; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON SEQUENCE public.medicines_id_seq TO hospitease_admin;


--
-- Name: TABLE patients; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.patients TO postgres;


--
-- Name: SEQUENCE permissions_id_seq; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON SEQUENCE public.permissions_id_seq TO hospitease_admin;


--
-- Name: TABLE permissions; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.permissions TO hospitease_admin;


--
-- Name: SEQUENCE receipt_line_items_id_seq; Type: ACL; Schema: public; Owner: -
--

GRANT SELECT,USAGE ON SEQUENCE public.receipt_line_items_id_seq TO hospitease_admin;


--
-- Name: TABLE receipt_line_items; Type: ACL; Schema: public; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.receipt_line_items TO hospitease_admin;


--
-- Name: SEQUENCE receipts_id_seq; Type: ACL; Schema: public; Owner: -
--

GRANT SELECT,USAGE ON SEQUENCE public.receipts_id_seq TO hospitease_admin;


--
-- Name: TABLE receipts; Type: ACL; Schema: public; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.receipts TO hospitease_admin;


--
-- Name: TABLE roles; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.roles TO postgres;


--
-- Name: TABLE symptoms; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.symptoms TO hospitease_admin;


--
-- Name: SEQUENCE symptoms_id_seq; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON SEQUENCE public.symptoms_id_seq TO hospitease_admin;


--
-- Name: TABLE tests; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.tests TO hospitease_admin;


--
-- Name: SEQUENCE tests_id_seq; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON SEQUENCE public.tests_id_seq TO hospitease_admin;


--
-- Name: TABLE users; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.users TO postgres;


--
-- PostgreSQL database dump complete
--

