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
-- Name: public; Type: SCHEMA; Schema: -; Owner: kapiljani
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO kapiljani;

--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_updated_at_column() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: ab_claims; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ab_claims (
    ab_claim_id character varying(20) NOT NULL,
    claim_id character varying(20),
    urn character varying(30),
    utn character varying(30),
    bis_status character varying(30),
    tms_status character varying(30),
    ehr_json text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.ab_claims OWNER TO postgres;

--
-- Name: admission_diets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.admission_diets (
    id integer NOT NULL,
    admission_id integer NOT NULL,
    diet_type character varying(100) NOT NULL,
    is_veg boolean DEFAULT true NOT NULL,
    allergies text[],
    meals jsonb NOT NULL,
    notes text,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.admission_diets OWNER TO postgres;

--
-- Name: admission_diets_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.admission_diets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.admission_diets_id_seq OWNER TO postgres;

--
-- Name: admission_diets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.admission_diets_id_seq OWNED BY public.admission_diets.id;


--
-- Name: admission_discharges; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.admission_discharges (
    id integer NOT NULL,
    admission_id integer NOT NULL,
    discharge_date timestamp without time zone NOT NULL,
    discharge_type character varying(50) NOT NULL,
    summary text,
    follow_up_date date,
    follow_up_instructions text,
    attending_doctor text,
    checklist jsonb,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.admission_discharges OWNER TO postgres;

--
-- Name: admission_discharges_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.admission_discharges_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.admission_discharges_id_seq OWNER TO postgres;

--
-- Name: admission_discharges_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.admission_discharges_id_seq OWNED BY public.admission_discharges.id;


--
-- Name: admission_medicines; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.admission_medicines (
    id integer NOT NULL,
    admission_id integer NOT NULL,
    medicine_name character varying(100) NOT NULL,
    dosage character varying(50),
    frequency character varying(50),
    duration character varying(50),
    route character varying(50),
    status character varying(50) DEFAULT 'active'::character varying NOT NULL,
    prescribed_by character varying(100),
    prescribed_on date,
    prescribed_till date,
    notes text
);


ALTER TABLE public.admission_medicines OWNER TO postgres;

--
-- Name: admission_medicines_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.admission_medicines_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.admission_medicines_id_seq OWNER TO postgres;

--
-- Name: admission_medicines_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.admission_medicines_id_seq OWNED BY public.admission_medicines.id;


--
-- Name: admission_tests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.admission_tests (
    id integer NOT NULL,
    admission_id integer NOT NULL,
    test_name character varying(100) NOT NULL,
    status character varying(50) DEFAULT 'pending'::character varying NOT NULL,
    cost double precision,
    description text,
    doctor_notes text,
    staff_notes text,
    test_date date,
    test_done_date date,
    suggested_by character varying(100),
    performed_by character varying(100),
    report_urls text[]
);


ALTER TABLE public.admission_tests OWNER TO postgres;

--
-- Name: admission_tests_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.admission_tests_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.admission_tests_id_seq OWNER TO postgres;

--
-- Name: admission_tests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.admission_tests_id_seq OWNED BY public.admission_tests.id;


--
-- Name: admission_vitals; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.admission_vitals (
    id integer NOT NULL,
    admission_id integer NOT NULL,
    temperature double precision,
    pulse integer,
    blood_pressure character varying(20),
    spo2 integer,
    notes text,
    recorded_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    captured_by character varying(100)
);


ALTER TABLE public.admission_vitals OWNER TO postgres;

--
-- Name: admission_vitals_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.admission_vitals_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.admission_vitals_id_seq OWNER TO postgres;

--
-- Name: admission_vitals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.admission_vitals_id_seq OWNED BY public.admission_vitals.id;


--
-- Name: admissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.admissions (
    id integer NOT NULL,
    patient_id integer NOT NULL,
    appointment_id integer,
    doctor_id integer NOT NULL,
    admission_date date NOT NULL,
    reason text,
    status character varying(50) DEFAULT 'admitted'::character varying NOT NULL,
    bed_id integer,
    discharge_date date,
    critical_care_required boolean DEFAULT false,
    care_24x7_required boolean DEFAULT false,
    notes text,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    hospital_id integer
);


ALTER TABLE public.admissions OWNER TO postgres;

--
-- Name: admissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.admissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.admissions_id_seq OWNER TO postgres;

--
-- Name: admissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.admissions_id_seq OWNED BY public.admissions.id;


--
-- Name: appointments; Type: TABLE; Schema: public; Owner: postgres
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
    appointment_unique_id character varying(32),
    mode_of_appointment character varying
);


ALTER TABLE public.appointments OWNER TO postgres;

--
-- Name: appointments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.appointments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.appointments_id_seq OWNER TO postgres;

--
-- Name: appointments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.appointments_id_seq OWNED BY public.appointments.id;


--
-- Name: audit_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.audit_logs (
    id integer NOT NULL,
    table_name character varying NOT NULL,
    record_id character varying NOT NULL,
    action character varying NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    user_id integer,
    old_data text,
    new_data text
);


ALTER TABLE public.audit_logs OWNER TO postgres;

--
-- Name: audit_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.audit_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.audit_logs_id_seq OWNER TO postgres;

--
-- Name: audit_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.audit_logs_id_seq OWNED BY public.audit_logs.id;


--
-- Name: bed_types; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bed_types (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    amount double precision NOT NULL,
    charge_type character varying(50) NOT NULL
);


ALTER TABLE public.bed_types OWNER TO postgres;

--
-- Name: bed_types_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.bed_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.bed_types_id_seq OWNER TO postgres;

--
-- Name: bed_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.bed_types_id_seq OWNED BY public.bed_types.id;


--
-- Name: beds; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.beds (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    bed_type_id integer NOT NULL,
    ward_id integer NOT NULL,
    status character varying(50) DEFAULT 'available'::character varying NOT NULL,
    features text,
    equipment text,
    is_active boolean DEFAULT true,
    notes text
);


ALTER TABLE public.beds OWNER TO postgres;

--
-- Name: beds_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.beds_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.beds_id_seq OWNER TO postgres;

--
-- Name: beds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.beds_id_seq OWNED BY public.beds.id;


--
-- Name: chat_messages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.chat_messages (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    sender_id character varying(50),
    receiver_id character varying(50),
    message text,
    sent_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    seen_by_sender boolean DEFAULT true,
    seen_by_receiver boolean DEFAULT false,
    doc_url text
);


ALTER TABLE public.chat_messages OWNER TO postgres;

--
-- Name: chat_messages_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.chat_messages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.chat_messages_id_seq OWNER TO postgres;

--
-- Name: chat_messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.chat_messages_id_seq OWNED BY public.chat_messages.id;


--
-- Name: credit_ledgers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.credit_ledgers (
    credit_id character varying(20) NOT NULL,
    invoice_id character varying(20),
    due_date date,
    amount_due numeric(10,2),
    amount_paid numeric(10,2) DEFAULT 0.0,
    status character varying(20),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.credit_ledgers OWNER TO postgres;

--
-- Name: doctors; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.doctors OWNER TO postgres;

--
-- Name: doctors_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.doctors_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.doctors_id_seq OWNER TO postgres;

--
-- Name: doctors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.doctors_id_seq OWNED BY public.doctors.id;


--
-- Name: documents; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.documents OWNER TO postgres;

--
-- Name: documents_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.documents_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.documents_id_seq OWNER TO postgres;

--
-- Name: documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.documents_id_seq OWNED BY public.documents.id;


--
-- Name: encounters; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.encounters (
    encounter_id character varying(20) NOT NULL,
    patient_id integer,
    encounter_date timestamp without time zone,
    type character varying(20),
    status character varying(20),
    admission_date timestamp without time zone,
    discharge_date timestamp without time zone,
    notes text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.encounters OWNER TO postgres;

--
-- Name: family_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.family_history (
    id integer NOT NULL,
    appointment_id integer NOT NULL,
    relationship_to_you character varying(255),
    additional_notes character varying(255)
);


ALTER TABLE public.family_history OWNER TO postgres;

--
-- Name: family_history_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.family_history_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.family_history_id_seq OWNER TO postgres;

--
-- Name: family_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.family_history_id_seq OWNED BY public.family_history.id;


--
-- Name: health_info; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.health_info OWNER TO postgres;

--
-- Name: health_info_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.health_info_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.health_info_id_seq OWNER TO postgres;

--
-- Name: health_info_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.health_info_id_seq OWNED BY public.health_info.id;


--
-- Name: hospital_payments; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.hospital_payments OWNER TO postgres;

--
-- Name: hospital_payments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.hospital_payments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.hospital_payments_id_seq OWNER TO postgres;

--
-- Name: hospital_payments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.hospital_payments_id_seq OWNED BY public.hospital_payments.id;


--
-- Name: hospital_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.hospital_permissions (
    id integer NOT NULL,
    hospital_id integer,
    permission_id integer
);


ALTER TABLE public.hospital_permissions OWNER TO postgres;

--
-- Name: hospital_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.hospital_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.hospital_permissions_id_seq OWNER TO postgres;

--
-- Name: hospital_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.hospital_permissions_id_seq OWNED BY public.hospital_permissions.id;


--
-- Name: hospitals; Type: TABLE; Schema: public; Owner: hospitease_admin
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


ALTER TABLE public.hospitals OWNER TO hospitease_admin;

--
-- Name: hospitals_id_seq; Type: SEQUENCE; Schema: public; Owner: hospitease_admin
--

CREATE SEQUENCE public.hospitals_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.hospitals_id_seq OWNER TO hospitease_admin;

--
-- Name: hospitals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: hospitease_admin
--

ALTER SEQUENCE public.hospitals_id_seq OWNED BY public.hospitals.id;


--
-- Name: insurance_claims; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.insurance_claims (
    claim_id character varying(20) NOT NULL,
    encounter_id character varying(20),
    insurance_id character varying(20),
    claim_number character varying(50),
    preauth_number character varying(50),
    status character varying(30),
    submitted_at timestamp without time zone,
    approved_at timestamp without time zone,
    rejected_at timestamp without time zone,
    amount_claimed numeric(10,2),
    amount_approved numeric(10,2),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.insurance_claims OWNER TO postgres;

--
-- Name: insurance_providers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.insurance_providers (
    insurance_id character varying(20) NOT NULL,
    name character varying(100),
    type character varying(50),
    api_endpoint text,
    contact_info text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.insurance_providers OWNER TO postgres;

--
-- Name: invoices; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.invoices (
    invoice_id character varying(20) NOT NULL,
    encounter_id character varying(20),
    total_amount numeric(10,2),
    paid_amount numeric(10,2),
    balance numeric(10,2),
    status character varying(20),
    credit_allowed boolean DEFAULT false,
    due_date date,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.invoices OWNER TO postgres;

--
-- Name: items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.items (
    item_id character varying(20) NOT NULL,
    name character varying(100) NOT NULL,
    category character varying(50),
    description text,
    price numeric(10,2),
    is_taxable boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.items OWNER TO postgres;

--
-- Name: medical_histories; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.medical_histories OWNER TO postgres;

--
-- Name: medical_histories_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.medical_histories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.medical_histories_id_seq OWNER TO postgres;

--
-- Name: medical_histories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.medical_histories_id_seq OWNED BY public.medical_histories.id;


--
-- Name: medicines; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.medicines OWNER TO postgres;

--
-- Name: medicines_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.medicines_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.medicines_id_seq OWNER TO postgres;

--
-- Name: medicines_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.medicines_id_seq OWNED BY public.medicines.id;


--
-- Name: nursing_notes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.nursing_notes (
    id integer NOT NULL,
    admission_id integer NOT NULL,
    note text NOT NULL,
    date date NOT NULL,
    added_by character varying(100) NOT NULL,
    role character varying(50) NOT NULL
);


ALTER TABLE public.nursing_notes OWNER TO postgres;

--
-- Name: nursing_notes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.nursing_notes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.nursing_notes_id_seq OWNER TO postgres;

--
-- Name: nursing_notes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.nursing_notes_id_seq OWNED BY public.nursing_notes.id;


--
-- Name: patients; Type: TABLE; Schema: public; Owner: hospitease_admin
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
    patient_unique_id character varying(255) DEFAULT 'DUMMY_ID'::character varying NOT NULL,
    mrd_number bigint
);


ALTER TABLE public.patients OWNER TO hospitease_admin;

--
-- Name: patients_id_seq; Type: SEQUENCE; Schema: public; Owner: hospitease_admin
--

CREATE SEQUENCE public.patients_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.patients_id_seq OWNER TO hospitease_admin;

--
-- Name: patients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: hospitease_admin
--

ALTER SEQUENCE public.patients_id_seq OWNED BY public.patients.id;


--
-- Name: payments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payments (
    payment_id character varying(20) NOT NULL,
    invoice_id character varying(20),
    payment_date date,
    amount numeric(10,2),
    mode character varying(20),
    payer character varying(50),
    transaction_ref character varying(50),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.payments OWNER TO postgres;

--
-- Name: permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.permissions_id_seq OWNER TO postgres;

--
-- Name: permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.permissions (
    id integer DEFAULT nextval('public.permissions_id_seq'::regclass) NOT NULL,
    name character varying(100) NOT NULL,
    description character varying(255),
    amount numeric(12,2)
);


ALTER TABLE public.permissions OWNER TO postgres;

--
-- Name: receipt_line_items_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.receipt_line_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.receipt_line_items_id_seq OWNER TO postgres;

--
-- Name: receipt_line_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.receipt_line_items (
    id integer DEFAULT nextval('public.receipt_line_items_id_seq'::regclass) NOT NULL,
    item character varying(100),
    quantity integer,
    rate double precision,
    amount double precision,
    receipt_id integer
);


ALTER TABLE public.receipt_line_items OWNER TO postgres;

--
-- Name: receipts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.receipts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.receipts_id_seq OWNER TO postgres;

--
-- Name: receipts; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.receipts OWNER TO postgres;

--
-- Name: roles; Type: TABLE; Schema: public; Owner: hospitease_admin
--

CREATE TABLE public.roles (
    id integer NOT NULL,
    name character varying NOT NULL
);


ALTER TABLE public.roles OWNER TO hospitease_admin;

--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: hospitease_admin
--

CREATE SEQUENCE public.roles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.roles_id_seq OWNER TO hospitease_admin;

--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: hospitease_admin
--

ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;


--
-- Name: staff; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.staff (
    id integer NOT NULL,
    hospital_id integer NOT NULL,
    user_id integer NOT NULL,
    first_name character varying(100) NOT NULL,
    last_name character varying(100) NOT NULL,
    title character varying(50),
    gender character varying(10),
    date_of_birth date,
    phone_number character varying(20),
    email character varying(100),
    role character varying(50) NOT NULL,
    department character varying(100),
    specialization character varying(100),
    qualification text,
    experience integer,
    joining_date date,
    is_active boolean DEFAULT true,
    address text,
    city character varying(100),
    state character varying(100),
    country character varying(100),
    zipcode character varying(20),
    emergency_contact character varying(20),
    photo_url text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.staff OWNER TO postgres;

--
-- Name: staff_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.staff_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.staff_id_seq OWNER TO postgres;

--
-- Name: staff_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.staff_id_seq OWNED BY public.staff.id;


--
-- Name: staff_responsibilities; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.staff_responsibilities (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    value character varying(100) NOT NULL,
    description text
);


ALTER TABLE public.staff_responsibilities OWNER TO postgres;

--
-- Name: staff_responsibilities_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.staff_responsibilities_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.staff_responsibilities_id_seq OWNER TO postgres;

--
-- Name: staff_responsibilities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.staff_responsibilities_id_seq OWNED BY public.staff_responsibilities.id;


--
-- Name: staff_responsibility_assignments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.staff_responsibility_assignments (
    id integer NOT NULL,
    staff_id integer NOT NULL,
    responsibility_id integer NOT NULL,
    assigned_by integer NOT NULL,
    assigned_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    revoked_at timestamp without time zone,
    revoked_by integer
);


ALTER TABLE public.staff_responsibility_assignments OWNER TO postgres;

--
-- Name: staff_responsibility_assignments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.staff_responsibility_assignments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.staff_responsibility_assignments_id_seq OWNER TO postgres;

--
-- Name: staff_responsibility_assignments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.staff_responsibility_assignments_id_seq OWNED BY public.staff_responsibility_assignments.id;


--
-- Name: symptoms; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.symptoms OWNER TO postgres;

--
-- Name: symptoms_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.symptoms_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.symptoms_id_seq OWNER TO postgres;

--
-- Name: symptoms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.symptoms_id_seq OWNED BY public.symptoms.id;


--
-- Name: tests; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.tests OWNER TO postgres;

--
-- Name: tests_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tests_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tests_id_seq OWNER TO postgres;

--
-- Name: tests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tests_id_seq OWNED BY public.tests.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: hospitease_admin
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


ALTER TABLE public.users OWNER TO hospitease_admin;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: hospitease_admin
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO hospitease_admin;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: hospitease_admin
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: vitals; Type: TABLE; Schema: public; Owner: hospitease_admin
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


ALTER TABLE public.vitals OWNER TO hospitease_admin;

--
-- Name: vitals_id_seq; Type: SEQUENCE; Schema: public; Owner: hospitease_admin
--

CREATE SEQUENCE public.vitals_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.vitals_id_seq OWNER TO hospitease_admin;

--
-- Name: vitals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: hospitease_admin
--

ALTER SEQUENCE public.vitals_id_seq OWNED BY public.vitals.id;


--
-- Name: wards; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.wards (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    description character varying(255),
    floor character varying(50),
    total_beds integer NOT NULL,
    available_beds integer NOT NULL,
    is_active boolean DEFAULT true,
    hospital_id integer NOT NULL
);


ALTER TABLE public.wards OWNER TO postgres;

--
-- Name: wards_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.wards_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.wards_id_seq OWNER TO postgres;

--
-- Name: wards_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.wards_id_seq OWNED BY public.wards.id;


--
-- Name: admission_diets id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admission_diets ALTER COLUMN id SET DEFAULT nextval('public.admission_diets_id_seq'::regclass);


--
-- Name: admission_discharges id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admission_discharges ALTER COLUMN id SET DEFAULT nextval('public.admission_discharges_id_seq'::regclass);


--
-- Name: admission_medicines id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admission_medicines ALTER COLUMN id SET DEFAULT nextval('public.admission_medicines_id_seq'::regclass);


--
-- Name: admission_tests id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admission_tests ALTER COLUMN id SET DEFAULT nextval('public.admission_tests_id_seq'::regclass);


--
-- Name: admission_vitals id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admission_vitals ALTER COLUMN id SET DEFAULT nextval('public.admission_vitals_id_seq'::regclass);


--
-- Name: admissions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admissions ALTER COLUMN id SET DEFAULT nextval('public.admissions_id_seq'::regclass);


--
-- Name: appointments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointments ALTER COLUMN id SET DEFAULT nextval('public.appointments_id_seq'::regclass);


--
-- Name: audit_logs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_logs ALTER COLUMN id SET DEFAULT nextval('public.audit_logs_id_seq'::regclass);


--
-- Name: bed_types id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bed_types ALTER COLUMN id SET DEFAULT nextval('public.bed_types_id_seq'::regclass);


--
-- Name: beds id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.beds ALTER COLUMN id SET DEFAULT nextval('public.beds_id_seq'::regclass);


--
-- Name: doctors id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctors ALTER COLUMN id SET DEFAULT nextval('public.doctors_id_seq'::regclass);


--
-- Name: documents id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.documents ALTER COLUMN id SET DEFAULT nextval('public.documents_id_seq'::regclass);


--
-- Name: family_history id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.family_history ALTER COLUMN id SET DEFAULT nextval('public.family_history_id_seq'::regclass);


--
-- Name: health_info id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.health_info ALTER COLUMN id SET DEFAULT nextval('public.health_info_id_seq'::regclass);


--
-- Name: hospital_payments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hospital_payments ALTER COLUMN id SET DEFAULT nextval('public.hospital_payments_id_seq'::regclass);


--
-- Name: hospital_permissions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hospital_permissions ALTER COLUMN id SET DEFAULT nextval('public.hospital_permissions_id_seq'::regclass);


--
-- Name: hospitals id; Type: DEFAULT; Schema: public; Owner: hospitease_admin
--

ALTER TABLE ONLY public.hospitals ALTER COLUMN id SET DEFAULT nextval('public.hospitals_id_seq'::regclass);


--
-- Name: medical_histories id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medical_histories ALTER COLUMN id SET DEFAULT nextval('public.medical_histories_id_seq'::regclass);


--
-- Name: medicines id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medicines ALTER COLUMN id SET DEFAULT nextval('public.medicines_id_seq'::regclass);


--
-- Name: nursing_notes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nursing_notes ALTER COLUMN id SET DEFAULT nextval('public.nursing_notes_id_seq'::regclass);


--
-- Name: patients id; Type: DEFAULT; Schema: public; Owner: hospitease_admin
--

ALTER TABLE ONLY public.patients ALTER COLUMN id SET DEFAULT nextval('public.patients_id_seq'::regclass);


--
-- Name: roles id; Type: DEFAULT; Schema: public; Owner: hospitease_admin
--

ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);


--
-- Name: staff id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff ALTER COLUMN id SET DEFAULT nextval('public.staff_id_seq'::regclass);


--
-- Name: staff_responsibilities id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff_responsibilities ALTER COLUMN id SET DEFAULT nextval('public.staff_responsibilities_id_seq'::regclass);


--
-- Name: staff_responsibility_assignments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff_responsibility_assignments ALTER COLUMN id SET DEFAULT nextval('public.staff_responsibility_assignments_id_seq'::regclass);


--
-- Name: symptoms id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.symptoms ALTER COLUMN id SET DEFAULT nextval('public.symptoms_id_seq'::regclass);


--
-- Name: tests id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tests ALTER COLUMN id SET DEFAULT nextval('public.tests_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: hospitease_admin
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: vitals id; Type: DEFAULT; Schema: public; Owner: hospitease_admin
--

ALTER TABLE ONLY public.vitals ALTER COLUMN id SET DEFAULT nextval('public.vitals_id_seq'::regclass);


--
-- Name: wards id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wards ALTER COLUMN id SET DEFAULT nextval('public.wards_id_seq'::regclass);


--
-- Data for Name: ab_claims; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ab_claims (ab_claim_id, claim_id, urn, utn, bis_status, tms_status, ehr_json, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: admission_diets; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.admission_diets (id, admission_id, diet_type, is_veg, allergies, meals, notes, created_at, updated_at) FROM stdin;
1	3	asdad	t	{as}	[{"name": "Breakfast", "time": "08:00", "items": ["ass"], "notes": "as"}, {"name": "Lunch", "time": "13:00", "items": ["as"], "notes": "df"}, {"name": "Dinner", "time": "19:00", "items": ["asdasd", "fgh"], "notes": "asd"}]	dfghnghfd	2025-06-29 21:03:08.010696+05:30	2025-06-29 21:03:25.266328+05:30
\.


--
-- Data for Name: admission_discharges; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.admission_discharges (id, admission_id, discharge_date, discharge_type, summary, follow_up_date, follow_up_instructions, attending_doctor, checklist, created_at, updated_at) FROM stdin;
1	2	2025-06-29 17:18:00	Normal	clinical report	2025-07-04	Date	Dr. (Ms.) Imaran Pandey	{"summary": true, "final_bill": true, "test_reports": true, "time_logging": true, "consent_forms": true, "final_approval": true, "clearance_slips": true, "doctor_clearance": true, "billing_clearance": true, "nursing_clearance": true, "pharmacy_clearance": true, "followup_instructions": true, "medication_prescription": true}	2025-06-29 22:51:00.521757	2025-06-29 22:51:00.521757
2	2	2025-06-30 17:15:00	Transfer		2025-07-02	as	Dr. (Ms.) Imaran Pandey	{"summary": false, "final_bill": false, "test_reports": false, "time_logging": false, "consent_forms": false, "final_approval": false, "clearance_slips": false, "doctor_clearance": false, "billing_clearance": false, "nursing_clearance": false, "pharmacy_clearance": false, "followup_instructions": false, "medication_prescription": false}	2025-06-30 22:47:55.275796	2025-06-30 22:47:55.275796
\.


--
-- Data for Name: admission_medicines; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.admission_medicines (id, admission_id, medicine_name, dosage, frequency, duration, route, status, prescribed_by, prescribed_on, prescribed_till, notes) FROM stdin;
1	3	adasd	asd	asd	asd	asd	Active	asd	2025-06-29	2025-06-13	\N
\.


--
-- Data for Name: admission_tests; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.admission_tests (id, admission_id, test_name, status, cost, description, doctor_notes, staff_notes, test_date, test_done_date, suggested_by, performed_by, report_urls) FROM stdin;
1	3	sad	Pending	5	asd	asd	asd	2025-07-02	2025-07-01	sad	sd	\N
\.


--
-- Data for Name: admission_vitals; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.admission_vitals (id, admission_id, temperature, pulse, blood_pressure, spo2, notes, recorded_at, captured_by) FROM stdin;
1	3	98.6	72	120/80	98	All good	2025-07-02 15:11:00+05:30	Reshmi Nurse
\.


--
-- Data for Name: admissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.admissions (id, patient_id, appointment_id, doctor_id, admission_date, reason, status, bed_id, discharge_date, critical_care_required, care_24x7_required, notes, created_at, updated_at, hospital_id) FROM stdin;
3	2	9954	7	2025-06-30		admitted	2	2025-07-01	t	t		2025-06-29 20:26:46.519512+05:30	2025-06-29 20:26:46.519512+05:30	3
4	2	9577	9	2025-06-16		admitted	2	2025-07-02	t	t		2025-06-29 20:28:10.123+05:30	2025-06-29 20:28:10.123+05:30	3
5	2	10190	9	2025-07-01	Ferv & vomit	admitted	1	2025-07-05	t	t		2025-06-30 22:43:39.599304+05:30	2025-06-30 22:43:39.599304+05:30	3
2	4	9002	4	2025-06-27	string	Discharged	1	2025-06-27	f	f	string	2025-06-28 00:08:40.156765+05:30	2025-07-01 23:09:32.605285+05:30	3
6	2	11006	3	2025-07-04	very severe back ache.	admitted	2	2025-07-15	f	t		2025-07-03 23:56:31.860032+05:30	2025-07-03 23:56:31.860032+05:30	3
\.


--
-- Data for Name: appointments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.appointments (id, patient_id, doctor_id, appointment_datetime, problem, appointment_type, reason, created_at, updated_at, blood_pressure, pulse_rate, temperature, spo2, weight, additional_notes, advice, follow_up_date, follow_up_notes, appointment_date, appointment_time, hospital_id, status, appointment_unique_id, mode_of_appointment) FROM stdin;
9002	105	7	2025-06-26 15:30:00	Skin Rash	New	Possimus quae quo est nemo voluptate rerum.	2025-06-26 22:30:08	2025-06-26 22:30:08	112/72	65	99.9	95	74	Vero rerum nihil iure quidem animi.	Quasi quod dolorum ipsa aliquam nisi.	2025-07-19	Unde harum officia non ex eaque saepe.	2025-06-26	15:30	3	pending	APT10001	\N
9003	475	5	2025-06-26 12:15:00	Back Pain	Emergency	Quae harum atque.	2025-06-26 22:30:08	2025-06-26 22:30:08	106/64	70	100.1	96	80	Deserunt iusto placeat sequi. Commodi error unde provident.	Accusantium ut vero enim quasi vero iste illo.	2025-07-13	Ipsa nihil ullam unde.	2025-06-26	12:15	3	pending	APT10002	\N
9004	456	9	2025-06-26 14:30:00	Headache	OPD	Ad hic facere.	2025-06-26 22:30:08	2025-06-26 22:30:08	127/86	85	99.8	95	80	Minima consequatur quis.	Animi quia ipsum quam voluptatibus dolorem nisi hic voluptates ratione.	2025-07-03	Excepturi itaque sed voluptates alias quia.	2025-06-26	14:30	3	pending	APT10003	\N
9005	105	10	2025-06-26 12:45:00	High BP	Follow-up	Ipsam officiis neque minus sequi dignissimos omnis.	2025-06-26 22:30:08	2025-06-26 22:30:08	134/60	98	100.4	99	80	Corrupti dolorem molestias voluptatem natus.	Debitis vel aliquam nisi nemo quaerat rem ut facilis quae.	2025-07-21	Aperiam odit voluptate velit quos.	2025-06-26	12:45	3	pending	APT10004	\N
9006	458	6	2025-06-26 14:45:00	Headache	New	Sint recusandae ab vel voluptatem porro assumenda.	2025-06-26 22:30:08	2025-06-26 22:30:08	117/79	68	100.2	95	55	Quaerat provident eveniet repudiandae deserunt magnam.	Quos ratione iure labore sed.	2025-07-03	Unde ut consequuntur non.	2025-06-26	14:45	3	pending	APT10005	\N
9007	285	10	2025-06-26 11:00:00	High BP	Emergency	Magnam rem aliquid illum eum iusto alias expedita.	2025-06-26 22:30:08	2025-06-26 22:30:08	110/78	65	97.9	100	78	Nesciunt temporibus ullam hic perspiciatis aperiam itaque.	Cupiditate nam aspernatur ipsum beatae alias ut placeat.	2025-07-21	Maxime earum perferendis facilis necessitatibus.	2025-06-26	11:00	3	pending	APT10006	\N
9008	293	9	2025-06-26 11:45:00	Cough	OPD	Omnis omnis laborum dicta et dolorem quibusdam.	2025-06-26 22:30:08	2025-06-26 22:30:08	133/75	80	99.8	96	63	Sequi nesciunt id praesentium.	Eum optio sit quidem aut.	2025-07-05	Doloribus est incidunt accusamus.	2025-06-26	11:45	3	pending	APT10007	\N
9009	49	7	2025-06-26 11:15:00	Fever	Follow-up	Similique unde laborum nihil enim optio accusantium.	2025-06-26 22:30:08	2025-06-26 22:30:08	105/89	75	97.6	97	85	Voluptatibus vitae beatae quis vitae at harum.	Tenetur quaerat error distinctio sed.	2025-07-15	Porro nam dolorum molestiae aspernatur in soluta sequi.	2025-06-26	11:15	3	pending	APT10008	\N
9010	117	8	2025-06-26 16:45:00	Cough	Emergency	Facilis quaerat earum deserunt.	2025-06-26 22:30:08	2025-06-26 22:30:08	101/69	70	99.1	97	68	Deleniti suscipit soluta recusandae exercitationem.	Praesentium nesciunt quam ullam ullam quisquam quod corrupti omnis sunt repudiandae.	2025-07-19	Reiciendis non facilis quis nam alias.	2025-06-26	16:45	3	pending	APT10009	\N
9011	245	10	2025-06-26 11:45:00	Headache	Follow-up	Temporibus dolorem consequuntur in.	2025-06-26 22:30:08	2025-06-26 22:30:08	126/72	100	98.4	98	74	Enim possimus consequatur pariatur architecto.	Nesciunt cupiditate corrupti ut amet perspiciatis.	2025-07-14	Temporibus eligendi a hic fugit.	2025-06-26	11:45	3	pending	APT10010	\N
9012	260	6	2025-06-26 11:00:00	Fever	New	Fugit a assumenda quidem.	2025-06-26 22:30:08	2025-06-26 22:30:08	111/89	75	98.3	96	81	Nisi ex molestiae aperiam sint. Ut beatae rerum a.	Vel repellendus asperiores fugit ut ipsam veniam aliquam pariatur.	2025-07-11	Molestiae doloribus error ut consequuntur.	2025-06-26	11:00	3	pending	APT10011	\N
9013	57	7	2025-06-26 11:45:00	Back Pain	Emergency	Dolorem ducimus distinctio vero quibusdam et.	2025-06-26 22:30:08	2025-06-26 22:30:08	127/61	89	100.4	95	57	Occaecati saepe velit culpa ratione.	Fuga veniam impedit quidem quaerat assumenda repellat aperiam.	2025-07-05	Quibusdam quia aliquam cupiditate repudiandae accusantium delectus quae.	2025-06-26	11:45	3	pending	APT10012	\N
9014	401	3	2025-06-26 16:30:00	Routine Checkup	New	Atque exercitationem totam officiis incidunt.	2025-06-26 22:30:08	2025-06-26 22:30:08	107/64	81	98.8	98	70	Vitae in qui praesentium rerum.	Soluta eos corporis eius quibusdam numquam repellat amet eius debitis.	2025-07-25	Nam fugiat dolore et eos animi aperiam sit.	2025-06-26	16:30	3	pending	APT10013	\N
9015	300	5	2025-06-26 16:00:00	Skin Rash	Follow-up	Accusamus quas magni sapiente possimus.	2025-06-26 22:30:08	2025-06-26 22:30:08	102/60	68	100.1	99	79	Eaque optio nisi sapiente officia.	Error sit dicta eius suscipit.	2025-07-18	Voluptatem iure natus aliquid eaque distinctio vitae.	2025-06-26	16:00	3	pending	APT10014	\N
9016	48	7	2025-06-26 14:15:00	Skin Rash	OPD	Incidunt ad sunt placeat excepturi.	2025-06-26 22:30:08	2025-06-26 22:30:08	131/61	99	98.1	97	82	Optio aut minus animi.	Quas unde sapiente occaecati hic sequi.	2025-07-04	Quas ratione fugiat veniam.	2025-06-26	14:15	3	pending	APT10015	\N
9017	499	3	2025-06-26 16:45:00	Skin Rash	Follow-up	Sed maxime consequatur magnam laborum eligendi dolores.	2025-06-26 22:30:08	2025-06-26 22:30:08	101/74	92	99.0	97	82	Pariatur magnam optio eius.	Cupiditate laudantium dolorum maiores perspiciatis quam beatae.	2025-07-05	Fugiat vitae rem dolore labore modi.	2025-06-26	16:45	3	pending	APT10016	\N
9018	376	10	2025-06-26 16:30:00	Diabetes Check	Follow-up	Ab maxime aliquid.	2025-06-26 22:30:08	2025-06-26 22:30:08	102/70	79	99.1	97	74	Consectetur unde nemo autem.	Quis sapiente ipsam veritatis unde.	2025-07-03	Atque sunt velit facilis dignissimos.	2025-06-26	16:30	3	pending	APT10017	\N
9019	219	9	2025-06-26 12:00:00	Skin Rash	OPD	Natus ab assumenda.	2025-06-26 22:30:08	2025-06-26 22:30:08	128/82	90	98.4	99	73	Perspiciatis temporibus quo sit repellat.	Soluta molestiae eligendi pariatur reiciendis velit magnam voluptatibus quo.	2025-07-19	Labore est molestias nam.	2025-06-26	12:00	3	pending	APT10018	\N
9020	241	3	2025-06-26 16:30:00	Cough	Follow-up	Est officia porro repellendus placeat sit in.	2025-06-26 22:30:08	2025-06-26 22:30:08	120/76	82	98.2	100	58	Dicta ducimus numquam repellat.	Reiciendis corrupti hic reiciendis perferendis error asperiores ipsam.	2025-07-07	Quo blanditiis pariatur quisquam odio porro amet.	2025-06-26	16:30	3	pending	APT10019	\N
9021	280	9	2025-06-26 15:30:00	Back Pain	OPD	Natus tempora deleniti odit perferendis.	2025-06-26 22:30:08	2025-06-26 22:30:08	113/89	78	98.8	100	70	Quia occaecati exercitationem necessitatibus libero.	Ipsam magni asperiores ut in autem nulla doloribus asperiores at.	2025-07-25	Repellendus modi illum.	2025-06-26	15:30	3	pending	APT10020	\N
9022	92	3	2025-06-26 16:45:00	Routine Checkup	Emergency	Esse eveniet veniam voluptatibus.	2025-06-26 22:30:08	2025-06-26 22:30:08	128/64	91	99.9	99	81	Suscipit dignissimos et totam blanditiis saepe.	Pariatur atque minus fugit quidem veniam.	2025-07-19	Aut deserunt maiores voluptates voluptate.	2025-06-26	16:45	3	pending	APT10021	\N
9023	351	7	2025-06-26 14:45:00	Fever	Emergency	Qui quisquam pariatur ullam dolore quos.	2025-06-26 22:30:08	2025-06-26 22:30:08	131/87	79	99.2	96	59	Labore distinctio cum. Itaque inventore consequatur.	Occaecati quis explicabo omnis reprehenderit quidem possimus.	2025-07-23	Voluptatem beatae commodi ipsum quis consectetur quasi.	2025-06-26	14:45	3	pending	APT10022	\N
9024	472	4	2025-06-26 14:00:00	Routine Checkup	OPD	Totam ipsam voluptates hic.	2025-06-26 22:30:08	2025-06-26 22:30:08	107/66	92	99.5	96	79	Dolorem placeat quia quas debitis explicabo.	Facere facilis saepe quis dolores ad fugiat quia adipisci.	2025-07-22	Ipsam at omnis sunt ullam incidunt quo nostrum.	2025-06-26	14:00	3	pending	APT10023	\N
9025	109	9	2025-06-26 11:30:00	Cough	New	Consectetur pariatur ex ex dolore.	2025-06-26 22:30:08	2025-06-26 22:30:08	105/70	88	99.7	100	62	Est reiciendis dolor ut deleniti soluta.	Porro doloremque voluptates tempore error quod ipsam in totam ad.	2025-07-20	Nostrum necessitatibus quo cumque ipsa voluptas earum.	2025-06-26	11:30	3	pending	APT10024	\N
9026	225	3	2025-06-26 16:15:00	Skin Rash	Emergency	Et porro quos quod.	2025-06-26 22:30:08	2025-06-26 22:30:08	133/90	82	99.0	98	66	Soluta repellendus cum nam ullam debitis tenetur.	Illum praesentium consequatur eveniet hic a quia.	2025-07-20	Architecto hic vel esse.	2025-06-26	16:15	3	pending	APT10025	\N
9027	120	9	2025-06-26 15:45:00	Back Pain	OPD	Eligendi voluptatibus animi atque.	2025-06-26 22:30:08	2025-06-26 22:30:08	120/90	99	99.3	97	61	Delectus molestias nemo id amet.	Ad magnam dolor similique doloremque corrupti ipsum.	2025-07-22	Eos voluptas laudantium a natus nemo facere.	2025-06-26	15:45	3	pending	APT10026	\N
9028	353	8	2025-06-26 11:15:00	High BP	OPD	Sed provident ducimus.	2025-06-26 22:30:08	2025-06-26 22:30:08	108/79	94	99.3	100	72	Unde vero autem saepe officia quasi.	Fuga magni repellat officia dolore cumque veritatis illum quis corporis.	2025-07-16	Fuga repellendus maxime impedit doloribus.	2025-06-26	11:15	3	pending	APT10027	\N
9029	233	8	2025-06-26 16:30:00	Diabetes Check	New	Sed aperiam eos animi fuga commodi facilis.	2025-06-26 22:30:08	2025-06-26 22:30:08	110/87	80	100.2	98	81	Ab veritatis iure laboriosam quod inventore dolor.	Ullam esse ipsa veniam numquam.	2025-07-26	Voluptatem sapiente odio unde cum.	2025-06-26	16:30	3	pending	APT10028	\N
9030	434	6	2025-06-27 14:00:00	High BP	New	Saepe deleniti atque tenetur placeat sunt beatae.	2025-06-26 22:30:08	2025-06-26 22:30:08	123/61	99	97.9	100	78	Soluta beatae nisi sunt labore quod aliquam.	Consectetur sint consequatur nihil tempora est sit optio ex.	2025-07-17	Nam a iste neque molestiae provident.	2025-06-27	14:00	3	pending	APT10029	\N
9031	254	3	2025-06-27 13:30:00	Back Pain	Emergency	Enim molestiae numquam voluptatem ut commodi cupiditate omnis.	2025-06-26 22:30:08	2025-06-26 22:30:08	131/65	86	99.0	96	66	Accusamus reprehenderit quae nulla soluta.	Repudiandae error repellendus porro id nulla voluptate.	2025-07-27	Beatae quasi earum.	2025-06-27	13:30	3	pending	APT10030	\N
9032	213	7	2025-06-27 11:00:00	Fever	New	Dolore aspernatur mollitia praesentium.	2025-06-26 22:30:08	2025-06-26 22:30:08	132/85	96	98.9	96	74	Quas ipsum magni fugiat optio officiis. Nam ullam eum.	Dolor eum sunt quisquam delectus facere placeat rem.	2025-07-17	Sit enim maxime iusto rerum necessitatibus impedit.	2025-06-27	11:00	3	pending	APT10031	\N
9033	59	8	2025-06-27 14:00:00	High BP	OPD	At corporis hic rem voluptate reiciendis cumque.	2025-06-26 22:30:08	2025-06-26 22:30:08	125/79	76	98.7	97	74	Praesentium quod aspernatur quia optio.	Quos maiores non voluptatem quas explicabo dolorem esse nihil possimus.	2025-07-21	Reiciendis in eligendi itaque.	2025-06-27	14:00	3	pending	APT10032	\N
9034	51	6	2025-06-27 14:30:00	High BP	Emergency	Enim architecto ut cumque doloremque saepe deleniti.	2025-06-26 22:30:08	2025-06-26 22:30:08	110/84	79	99.0	98	74	Fugiat repellat recusandae aut officiis nesciunt.	Quisquam recusandae similique saepe enim aliquid adipisci repellat.	2025-07-23	Nam doloremque quidem id.	2025-06-27	14:30	3	pending	APT10033	\N
9035	462	7	2025-06-27 16:45:00	Fever	Emergency	Iusto similique repellendus impedit eos fugit voluptate nam.	2025-06-26 22:30:08	2025-06-26 22:30:08	114/70	69	100.3	95	84	Similique voluptas est nobis velit dolor.	Commodi non impedit commodi.	2025-07-27	Sunt nobis vero inventore.	2025-06-27	16:45	3	pending	APT10034	\N
9036	160	4	2025-06-27 13:15:00	Skin Rash	Emergency	Vero itaque aspernatur eum corporis enim quos.	2025-06-26 22:30:08	2025-06-26 22:30:08	101/84	86	98.2	95	57	Ipsa harum animi fugiat.	Ducimus aliquam deleniti veritatis eveniet hic reprehenderit vel reiciendis.	2025-07-23	Maiores commodi recusandae.	2025-06-27	13:15	3	pending	APT10035	\N
9037	258	3	2025-06-27 11:00:00	Back Pain	Emergency	Dolores id magnam saepe distinctio odit vero.	2025-06-26 22:30:08	2025-06-26 22:30:08	101/66	78	97.9	95	65	Tenetur sapiente quis vel similique esse.	Nam aliquid natus quaerat ipsa.	2025-07-09	Voluptates adipisci eaque voluptas quod assumenda.	2025-06-27	11:00	3	pending	APT10036	\N
9038	230	6	2025-06-27 15:30:00	Headache	OPD	Corrupti eveniet sit nobis odio dolorem.	2025-06-26 22:30:08	2025-06-26 22:30:08	137/68	100	100.4	95	78	Consequatur repellat nam voluptate.	Eaque accusamus vel sint ut facilis.	2025-07-15	Vel consequatur libero laboriosam animi corrupti molestiae.	2025-06-27	15:30	3	pending	APT10037	\N
9039	404	3	2025-06-27 14:45:00	Fever	New	Distinctio rerum totam voluptatibus odit accusamus voluptatibus.	2025-06-26 22:30:08	2025-06-26 22:30:08	109/84	92	99.1	96	66	Tempore provident veniam deserunt.	Totam sint autem cupiditate rem animi sit iure numquam.	2025-07-08	Sequi blanditiis odit dolores.	2025-06-27	14:45	3	pending	APT10038	\N
9040	371	8	2025-06-27 14:30:00	Skin Rash	Emergency	Enim delectus fuga non repellendus officia.	2025-06-26 22:30:08	2025-06-26 22:30:08	119/70	92	99.6	95	59	Necessitatibus error vel voluptatem incidunt.	Ullam accusantium nulla qui iusto quas.	2025-07-27	Eum a asperiores molestias eligendi.	2025-06-27	14:30	3	pending	APT10039	\N
9041	33	7	2025-06-27 11:15:00	Cough	Follow-up	Deserunt perferendis aliquam voluptate eaque aut.	2025-06-26 22:30:08	2025-06-26 22:30:08	114/90	76	97.8	96	85	Sapiente rem reiciendis error nulla.	Maxime doloremque eaque nisi magnam explicabo eligendi.	2025-07-14	Explicabo dolores dicta quos recusandae.	2025-06-27	11:15	3	pending	APT10040	\N
9042	216	6	2025-06-27 14:15:00	Fever	Emergency	Ratione molestias eos ratione.	2025-06-26 22:30:08	2025-06-26 22:30:08	128/69	91	99.0	98	64	Est quo doloribus voluptate mollitia.	Suscipit explicabo eius deserunt necessitatibus blanditiis aliquam sapiente similique.	2025-07-13	Numquam eligendi earum cumque consectetur error voluptate praesentium.	2025-06-27	14:15	3	pending	APT10041	\N
9043	378	5	2025-06-27 14:15:00	Skin Rash	OPD	Doloremque ad placeat accusamus vero natus blanditiis.	2025-06-26 22:30:08	2025-06-26 22:30:08	124/84	97	99.2	95	66	Facilis dolores aut itaque eveniet dolorem molestias.	Quisquam consequatur consequatur ducimus suscipit a eligendi.	2025-07-11	Facilis labore aspernatur perferendis dolorem ex inventore.	2025-06-27	14:15	3	pending	APT10042	\N
9044	51	7	2025-06-27 16:15:00	Routine Checkup	OPD	Odio adipisci voluptas.	2025-06-26 22:30:08	2025-06-26 22:30:08	112/77	74	98.5	100	81	Cumque debitis dignissimos provident totam ad animi.	Non dolorum dolore commodi inventore ab accusantium repellendus alias.	2025-07-12	Architecto ut commodi mollitia.	2025-06-27	16:15	3	pending	APT10043	\N
9045	414	7	2025-06-27 12:45:00	Fever	Emergency	Totam asperiores corporis accusantium expedita alias.	2025-06-26 22:30:08	2025-06-26 22:30:08	119/85	77	98.3	98	82	Impedit sint dignissimos tempora repudiandae repudiandae a.	Soluta alias magnam eos deleniti aliquid est odio.	2025-07-21	Doloremque odit soluta.	2025-06-27	12:45	3	pending	APT10044	\N
9046	322	4	2025-06-27 12:00:00	Back Pain	Follow-up	Veniam repellendus aperiam perferendis vero quo eligendi.	2025-06-26 22:30:08	2025-06-26 22:30:08	125/78	71	100.4	95	57	Voluptates accusamus amet.	Quisquam consequuntur eveniet laudantium debitis nobis deserunt.	2025-07-12	Repellat voluptatibus distinctio assumenda esse fugiat.	2025-06-27	12:00	3	pending	APT10045	\N
9091	492	7	2025-06-29 15:30:00	Cough	Emergency	Incidunt fugit enim autem aspernatur beatae et.	2025-06-26 22:30:08	2025-06-26 22:30:08	101/62	71	99.9	96	64	Fugiat magnam corrupti sit.	Quibusdam distinctio cum quisquam quasi vitae.	2025-07-13	Eligendi vitae repellat accusamus.	2025-06-29	15:30	3	pending	APT10090	\N
9047	460	9	2025-06-27 13:15:00	Headache	New	Eligendi impedit sequi nesciunt aut quae velit.	2025-06-26 22:30:08	2025-06-26 22:30:08	100/79	92	99.4	95	68	Numquam tempora dicta aperiam labore ut.	Qui rerum possimus repellendus officiis maiores vitae distinctio minima.	2025-07-18	Sint porro aut corrupti voluptas iusto.	2025-06-27	13:15	3	pending	APT10046	\N
9048	313	3	2025-06-27 11:00:00	Skin Rash	New	Neque quis hic sed asperiores praesentium.	2025-06-26 22:30:08	2025-06-26 22:30:08	104/74	88	98.0	99	80	Sed quas ea dolores nulla velit.	Impedit temporibus delectus maxime magnam ratione enim veniam possimus architecto.	2025-07-08	Dolorum distinctio nesciunt quisquam.	2025-06-27	11:00	3	pending	APT10047	\N
9049	187	7	2025-06-27 12:00:00	Routine Checkup	Follow-up	Perspiciatis harum culpa tenetur maiores.	2025-06-26 22:30:08	2025-06-26 22:30:08	121/86	95	100.4	100	81	Fugit dolores dolorem dicta unde temporibus.	Ullam quasi id sunt officiis fugiat laudantium sit.	2025-07-07	Delectus aliquam veritatis a.	2025-06-27	12:00	3	pending	APT10048	\N
9050	137	6	2025-06-27 12:30:00	Headache	New	Eos at aperiam veniam officiis id maxime.	2025-06-26 22:30:08	2025-06-26 22:30:08	114/60	81	99.9	99	55	Error saepe et dignissimos molestiae eaque iste.	Voluptatum quidem libero numquam.	2025-07-10	Amet provident numquam odio id cumque beatae.	2025-06-27	12:30	3	pending	APT10049	\N
9051	144	10	2025-06-27 16:00:00	Routine Checkup	Follow-up	Dignissimos explicabo corporis necessitatibus.	2025-06-26 22:30:08	2025-06-26 22:30:08	117/78	81	99.8	97	69	Quisquam doloribus fugit expedita provident maiores.	Consequatur voluptate nam adipisci voluptatum.	2025-07-15	Delectus reprehenderit quos distinctio facilis labore.	2025-06-27	16:00	3	pending	APT10050	\N
9052	41	5	2025-06-27 16:30:00	Headache	Emergency	Iste beatae similique recusandae.	2025-06-26 22:30:08	2025-06-26 22:30:08	102/70	86	100.2	100	83	Eum adipisci ipsum placeat perferendis ab perferendis.	Dolorum molestias blanditiis distinctio dolorum neque numquam nostrum nulla quas.	2025-07-26	Recusandae aliquam fugit alias fuga soluta possimus.	2025-06-27	16:30	3	pending	APT10051	\N
9053	238	4	2025-06-27 15:30:00	Diabetes Check	Follow-up	Ut repellat dolores eos laborum qui harum.	2025-06-26 22:30:08	2025-06-26 22:30:08	115/68	98	100.0	95	84	Iste minus quis reprehenderit. Placeat illo ut veritatis.	Itaque quas reiciendis molestiae dolores laborum maxime at quidem quo ex.	2025-07-07	Enim quae molestiae consequuntur tenetur provident nobis pariatur.	2025-06-27	15:30	3	pending	APT10052	\N
9054	190	4	2025-06-28 16:45:00	Routine Checkup	OPD	Deserunt laudantium aut recusandae quasi error.	2025-06-26 22:30:08	2025-06-26 22:30:08	134/78	99	99.6	98	82	Suscipit iusto fugiat dignissimos doloremque.	Quisquam inventore voluptatem voluptatum aut dicta aliquid fuga illum.	2025-07-19	Rem dolorem libero.	2025-06-28	16:45	3	pending	APT10053	\N
9055	291	3	2025-06-28 14:45:00	Back Pain	New	Sequi laboriosam doloremque hic mollitia.	2025-06-26 22:30:08	2025-06-26 22:30:08	123/64	80	98.5	100	83	Numquam quas quaerat cumque reiciendis ipsam.	Quos dolor facere ex debitis consequuntur vitae.	2025-07-18	Ullam non est reprehenderit ut.	2025-06-28	14:45	3	pending	APT10054	\N
9056	113	4	2025-06-28 14:00:00	Diabetes Check	Emergency	Magni dolorem magni nulla quam rerum.	2025-06-26 22:30:08	2025-06-26 22:30:08	103/84	100	99.3	95	56	Facere sunt distinctio consectetur numquam modi.	Voluptatum mollitia commodi et modi unde incidunt fuga voluptas tempore.	2025-07-12	Explicabo quas architecto necessitatibus.	2025-06-28	14:00	3	pending	APT10055	\N
9057	478	3	2025-06-28 14:15:00	Headache	Emergency	Sit tenetur ut debitis explicabo quam quidem.	2025-06-26 22:30:08	2025-06-26 22:30:08	124/86	73	98.6	99	67	Earum nemo ut architecto assumenda odit.	Molestiae asperiores rerum animi vitae quos alias quidem cupiditate.	2025-07-16	Optio accusantium temporibus consequuntur.	2025-06-28	14:15	3	pending	APT10056	\N
9058	330	3	2025-06-28 13:45:00	Skin Rash	OPD	A consequuntur at eum exercitationem.	2025-06-26 22:30:08	2025-06-26 22:30:08	112/73	92	99.7	95	78	Mollitia sapiente saepe ut quod.	Eaque reprehenderit possimus non veritatis totam adipisci voluptate.	2025-07-23	Aliquid voluptatum at expedita beatae vitae dolores.	2025-06-28	13:45	3	pending	APT10057	\N
9059	471	9	2025-06-28 12:30:00	Skin Rash	Follow-up	Aliquid dolorum consectetur.	2025-06-26 22:30:08	2025-06-26 22:30:08	137/77	76	97.6	97	66	Molestias est corrupti qui.	Alias pariatur provident reiciendis corrupti.	2025-07-14	Soluta dolorem illo porro.	2025-06-28	12:30	3	pending	APT10058	\N
9060	183	7	2025-06-28 15:30:00	High BP	Follow-up	Non ullam adipisci atque laborum enim quod.	2025-06-26 22:30:08	2025-06-26 22:30:08	103/69	89	99.2	100	84	Itaque adipisci nihil at eum modi.	Laborum culpa perspiciatis voluptate tenetur voluptates sed eveniet quos dolore eaque.	2025-07-07	Culpa aperiam quisquam soluta.	2025-06-28	15:30	3	pending	APT10059	\N
9061	169	7	2025-06-28 13:00:00	Back Pain	Follow-up	Reprehenderit facere recusandae.	2025-06-26 22:30:08	2025-06-26 22:30:08	130/76	98	99.1	97	62	Aliquam veritatis maiores qui.	Culpa explicabo dignissimos iusto animi quae sed inventore error eius.	2025-07-12	Quibusdam aliquid velit qui quae libero.	2025-06-28	13:00	3	pending	APT10060	\N
9062	375	8	2025-06-28 11:45:00	High BP	New	Assumenda aliquid dignissimos provident.	2025-06-26 22:30:08	2025-06-26 22:30:08	127/81	95	99.0	96	71	Error placeat corrupti.	Ut quis praesentium aperiam cum animi voluptatem incidunt totam sapiente.	2025-07-09	Saepe nemo magni ipsa.	2025-06-28	11:45	3	pending	APT10061	\N
9063	485	4	2025-06-28 12:45:00	Headache	Emergency	Aliquam illo est vero suscipit.	2025-06-26 22:30:08	2025-06-26 22:30:08	106/88	86	98.9	97	82	Id voluptatibus alias eaque vitae.	Qui debitis laborum corporis repudiandae maiores adipisci consequatur corporis.	2025-07-06	Fuga explicabo vitae rerum.	2025-06-28	12:45	3	pending	APT10062	\N
9064	101	5	2025-06-28 13:45:00	Cough	New	Architecto quisquam at totam.	2025-06-26 22:30:08	2025-06-26 22:30:08	132/86	88	97.6	96	83	Eos ea tenetur sit officia id.	Ducimus aliquid eaque eos commodi debitis architecto.	2025-07-08	Adipisci ipsa cum nostrum.	2025-06-28	13:45	3	pending	APT10063	\N
9065	344	4	2025-06-28 11:00:00	Fever	Follow-up	Qui recusandae nam mollitia ipsa odit quasi consequatur.	2025-06-26 22:30:08	2025-06-26 22:30:08	107/72	79	99.2	98	58	Repellat dolorem rem reprehenderit provident.	Sunt quos atque non sapiente accusamus laboriosam accusantium.	2025-07-16	Tenetur alias autem iusto voluptas nisi.	2025-06-28	11:00	3	pending	APT10064	\N
9066	345	4	2025-06-28 15:30:00	Diabetes Check	Emergency	Voluptates deserunt molestias dolore.	2025-06-26 22:30:08	2025-06-26 22:30:08	139/78	66	100.3	97	77	Nostrum occaecati repudiandae dolorum.	Harum occaecati et tempore fuga asperiores mollitia deserunt atque.	2025-07-14	Vel ad cum nisi architecto possimus.	2025-06-28	15:30	3	pending	APT10065	\N
9067	33	4	2025-06-28 15:30:00	Diabetes Check	Follow-up	Consectetur doloremque vero velit labore alias dolor.	2025-06-26 22:30:08	2025-06-26 22:30:08	104/69	95	99.0	100	70	Quos velit molestiae quis autem.	Reiciendis quia minus magnam itaque sequi numquam fugiat commodi cupiditate.	2025-07-05	Veniam debitis sint blanditiis ab earum distinctio.	2025-06-28	15:30	3	pending	APT10066	\N
9068	459	5	2025-06-28 13:30:00	Diabetes Check	Follow-up	Modi debitis amet recusandae.	2025-06-26 22:30:08	2025-06-26 22:30:08	116/79	93	99.1	95	77	Tempora odio maiores porro impedit.	At dolorem velit beatae illo dolores magnam voluptas reiciendis.	2025-07-22	Quam tempore praesentium occaecati velit temporibus.	2025-06-28	13:30	3	pending	APT10067	\N
11010	2	3	2025-06-30T10:00Z	\N	regular	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-06-30	10:00	3	pending	APT-20250705-004	\N
9069	399	9	2025-06-28 11:00:00	Routine Checkup	Follow-up	Exercitationem explicabo voluptate iusto.	2025-06-26 22:30:08	2025-06-26 22:30:08	100/62	78	97.9	95	63	Tempora eligendi quae.	A similique explicabo explicabo iste facilis nostrum totam.	2025-07-17	Possimus atque dolorem necessitatibus molestias labore itaque.	2025-06-28	11:00	3	pending	APT10068	\N
9070	4	10	2025-06-28 15:45:00	Cough	Follow-up	Laudantium aspernatur odit.	2025-06-26 22:30:08	2025-06-26 22:30:08	107/79	71	100.0	95	70	Veritatis laborum repellendus sequi minus quis neque.	Minima temporibus praesentium odio molestias natus repellat molestias placeat illum.	2025-07-06	Quibusdam praesentium iste voluptatibus quae distinctio non.	2025-06-28	15:45	3	pending	APT10069	\N
9071	143	6	2025-06-28 11:00:00	High BP	OPD	Hic cupiditate quia nobis ab ratione.	2025-06-26 22:30:08	2025-06-26 22:30:08	113/66	72	99.1	98	59	Magnam eius consequatur porro harum quo eaque.	Aperiam impedit qui modi repellendus eius expedita molestiae modi porro in.	2025-07-15	Iusto recusandae adipisci porro officia iure.	2025-06-28	11:00	3	pending	APT10070	\N
9072	459	7	2025-06-28 13:00:00	High BP	OPD	Quas esse repudiandae accusamus corporis assumenda.	2025-06-26 22:30:08	2025-06-26 22:30:08	120/63	93	98.8	95	57	Ullam tenetur facilis eligendi ipsa error.	Nemo id officia voluptatum soluta inventore.	2025-07-24	Occaecati ratione saepe blanditiis optio.	2025-06-28	13:00	3	pending	APT10071	\N
9073	401	6	2025-06-28 12:30:00	Headache	New	Voluptate excepturi illo qui.	2025-06-26 22:30:08	2025-06-26 22:30:08	101/86	95	100.0	100	60	Cum odit voluptas facere.	Quas sint placeat delectus voluptatem voluptatum accusamus cumque tenetur.	2025-07-17	Reiciendis veniam deserunt quam tempore.	2025-06-28	12:30	3	pending	APT10072	\N
9074	411	4	2025-06-28 13:15:00	Routine Checkup	OPD	Quos delectus veritatis tempore nemo distinctio dolores.	2025-06-26 22:30:08	2025-06-26 22:30:08	120/69	88	97.7	95	79	Ex corrupti dolorum soluta.	Expedita qui nisi in excepturi error optio itaque corporis vero.	2025-07-13	Deleniti ratione ad eligendi ipsa labore corrupti.	2025-06-28	13:15	3	pending	APT10073	\N
9075	252	3	2025-06-28 16:00:00	Routine Checkup	New	Aut aliquid cumque laudantium occaecati repellat nemo.	2025-06-26 22:30:08	2025-06-26 22:30:08	121/68	86	99.5	97	66	Eveniet soluta veniam voluptatibus temporibus eos.	Consectetur enim doloribus esse nesciunt.	2025-07-28	Officia officiis corporis voluptate dolor cumque deserunt.	2025-06-28	16:00	3	pending	APT10074	\N
9076	216	8	2025-06-29 12:45:00	Fever	Emergency	Sint iure unde.	2025-06-26 22:30:08	2025-06-26 22:30:08	134/82	79	98.6	97	63	Veniam ad beatae ex facilis vel fuga.	Minima laboriosam suscipit quo incidunt ab quia quis.	2025-07-19	Molestias recusandae rem perspiciatis possimus.	2025-06-29	12:45	3	pending	APT10075	\N
9077	318	3	2025-06-29 13:00:00	Skin Rash	OPD	Minus voluptatem maiores reiciendis et illo.	2025-06-26 22:30:08	2025-06-26 22:30:08	110/78	65	98.1	95	75	Quas dolorum reiciendis omnis in quisquam.	Esse cupiditate eos iusto odit magni numquam consequuntur aut.	2025-07-11	Modi animi beatae minus consequuntur et.	2025-06-29	13:00	3	pending	APT10076	\N
9078	65	9	2025-06-29 13:00:00	Fever	OPD	Ipsam quae impedit molestias nulla aliquam ducimus accusamus.	2025-06-26 22:30:08	2025-06-26 22:30:08	139/78	81	97.9	100	59	Impedit ratione corrupti ducimus corrupti excepturi cumque.	Quo distinctio cupiditate officiis pariatur ipsum vero voluptatum veritatis similique molestias.	2025-07-23	Suscipit voluptatum corrupti sed.	2025-06-29	13:00	3	pending	APT10077	\N
9079	272	8	2025-06-29 11:30:00	Back Pain	OPD	Earum eveniet voluptatibus exercitationem.	2025-06-26 22:30:08	2025-06-26 22:30:08	108/78	81	99.2	98	83	Aliquam quas aspernatur similique sapiente.	Error modi neque alias minus.	2025-07-16	Et natus porro quos.	2025-06-29	11:30	3	pending	APT10078	\N
9080	192	10	2025-06-29 12:15:00	Routine Checkup	New	Ipsam asperiores excepturi optio.	2025-06-26 22:30:08	2025-06-26 22:30:08	116/80	98	99.5	100	57	Magnam assumenda laboriosam assumenda.	Tempora rerum odit illum tempora.	2025-07-24	Ipsum blanditiis voluptatem rem neque.	2025-06-29	12:15	3	pending	APT10079	\N
9081	207	8	2025-06-29 13:45:00	High BP	OPD	Nemo quaerat recusandae eveniet repellendus incidunt.	2025-06-26 22:30:08	2025-06-26 22:30:08	119/87	80	97.9	97	82	Quo deserunt neque repudiandae.	Maiores occaecati eius eum repellendus temporibus perspiciatis neque.	2025-07-29	Repellat aliquid officia consectetur mollitia.	2025-06-29	13:45	3	pending	APT10080	\N
9082	106	7	2025-06-29 16:30:00	Routine Checkup	OPD	Nulla dolore ducimus iure deleniti ducimus.	2025-06-26 22:30:08	2025-06-26 22:30:08	118/65	78	99.0	97	57	Facere veritatis animi aliquam.	Pariatur ipsum porro nobis.	2025-07-28	Quasi fuga neque nulla quo voluptatibus ullam molestias.	2025-06-29	16:30	3	pending	APT10081	\N
9083	314	4	2025-06-29 12:45:00	Diabetes Check	New	Fugit autem vero dolor animi fugiat.	2025-06-26 22:30:08	2025-06-26 22:30:08	120/89	70	97.7	98	67	Sint quia rem voluptate blanditiis maxime.	Fuga a est explicabo assumenda dolorum at eligendi autem.	2025-07-11	Possimus cumque saepe iusto.	2025-06-29	12:45	3	pending	APT10082	\N
9084	293	4	2025-06-29 14:45:00	Headache	OPD	Quis provident et molestiae quo.	2025-06-26 22:30:08	2025-06-26 22:30:08	118/82	82	97.7	97	84	Doloremque eius consequuntur et.	Velit ratione eligendi animi voluptates dolor iure.	2025-07-19	Hic cum a corrupti harum.	2025-06-29	14:45	3	pending	APT10083	\N
9085	256	9	2025-06-29 11:45:00	Cough	Emergency	Doloribus cumque illo nemo saepe molestias.	2025-06-26 22:30:08	2025-06-26 22:30:08	129/75	88	97.9	97	80	Nemo ea dolorem expedita.	Natus molestias expedita totam at veritatis blanditiis distinctio voluptates praesentium.	2025-07-24	Enim molestiae beatae itaque non.	2025-06-29	11:45	3	pending	APT10084	\N
9086	164	4	2025-06-29 14:45:00	Skin Rash	Follow-up	Vitae praesentium provident repudiandae in enim.	2025-06-26 22:30:08	2025-06-26 22:30:08	138/84	71	99.3	96	67	Nemo laudantium repellat repellendus blanditiis ex tenetur.	Laudantium ullam doloribus placeat perferendis in.	2025-07-17	Vel culpa cupiditate eaque atque temporibus officia est.	2025-06-29	14:45	3	pending	APT10085	\N
9087	93	8	2025-06-29 16:45:00	Fever	Emergency	Quis quam animi reiciendis.	2025-06-26 22:30:08	2025-06-26 22:30:08	108/79	96	100.5	100	78	Sequi necessitatibus est animi.	Ad dignissimos cumque magni soluta doloribus possimus.	2025-07-07	Molestiae ex repudiandae deleniti impedit doloremque.	2025-06-29	16:45	3	pending	APT10086	\N
9088	263	8	2025-06-29 15:45:00	Routine Checkup	Emergency	Nesciunt perspiciatis placeat tenetur debitis.	2025-06-26 22:30:08	2025-06-26 22:30:08	102/68	73	98.9	98	75	Laborum quas quis harum est.	Dicta accusantium iure praesentium sunt laboriosam tenetur quaerat.	2025-07-13	Nam nesciunt iusto excepturi quaerat.	2025-06-29	15:45	3	pending	APT10087	\N
9089	222	10	2025-06-29 16:30:00	Skin Rash	OPD	Impedit quo ipsa dolorum.	2025-06-26 22:30:08	2025-06-26 22:30:08	106/69	82	98.3	96	56	Cupiditate doloribus aliquam corrupti magni aperiam cumque.	Explicabo aliquam quas quod perferendis ratione voluptatum.	2025-07-19	Distinctio nihil placeat nobis alias.	2025-06-29	16:30	3	pending	APT10088	\N
9090	27	4	2025-06-29 12:30:00	High BP	New	Necessitatibus mollitia vitae placeat ex.	2025-06-26 22:30:08	2025-06-26 22:30:08	119/61	95	99.8	99	79	Quaerat rerum quidem consequatur soluta.	Impedit temporibus officiis velit ad assumenda totam voluptate magnam rem.	2025-07-21	Dolorem illum incidunt rem omnis distinctio.	2025-06-29	12:30	3	pending	APT10089	\N
11003	507	4	2025-07-04T11:00:00	Fever & vomit	Rotuine	-	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-07-04	11:00	3	scheduled	APT-20250703-002	\N
11011	511	3	2025-07-09T14:00Z	\N	regular	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-07-09	14:00	3	pending	APT-20250706-001	\N
9092	5	8	2025-06-29 13:15:00	Fever	OPD	Adipisci odit eos enim quia nisi.	2025-06-26 22:30:08	2025-06-26 22:30:08	101/83	94	98.6	97	72	Autem quia cum ex nisi aut.	Libero ab odio dignissimos corrupti.	2025-07-22	A eius dolores voluptatibus ab iure vero.	2025-06-29	13:15	3	pending	APT10091	\N
9093	252	6	2025-06-29 14:30:00	Skin Rash	New	Cum cupiditate velit quisquam.	2025-06-26 22:30:08	2025-06-26 22:30:08	125/80	97	100.4	97	61	Expedita omnis veritatis dolores veniam maiores.	Laudantium corrupti eaque sint nostrum nostrum.	2025-07-10	Totam at earum laudantium.	2025-06-29	14:30	3	pending	APT10092	\N
9094	169	7	2025-06-29 15:45:00	Diabetes Check	OPD	Veritatis porro sapiente nihil non nulla perferendis.	2025-06-26 22:30:08	2025-06-26 22:30:08	119/84	72	99.1	97	81	Eum nostrum voluptatibus. Quas quibusdam error vero.	Totam non voluptate dignissimos ab soluta.	2025-07-20	Aperiam iste sed quam porro.	2025-06-29	15:45	3	pending	APT10093	\N
9095	471	9	2025-06-29 15:30:00	Fever	New	Voluptatibus laboriosam inventore maiores.	2025-06-26 22:30:08	2025-06-26 22:30:08	118/85	86	100.1	96	83	Perspiciatis rerum libero est reiciendis in.	Nemo quisquam voluptates reprehenderit eius atque.	2025-07-12	Voluptate repudiandae rerum mollitia vitae suscipit laudantium ducimus.	2025-06-29	15:30	3	pending	APT10094	\N
9096	270	5	2025-06-29 12:30:00	Back Pain	Emergency	Iste pariatur quae velit repudiandae molestiae.	2025-06-26 22:30:08	2025-06-26 22:30:08	109/63	86	97.9	96	59	Culpa consequatur enim.	Corporis exercitationem iste distinctio dolorum.	2025-07-13	Inventore quia non quam quo aliquid eaque reiciendis.	2025-06-29	12:30	3	pending	APT10095	\N
9097	302	5	2025-06-29 15:00:00	Headache	OPD	Architecto nesciunt nisi veritatis iusto.	2025-06-26 22:30:08	2025-06-26 22:30:08	140/87	86	100.5	99	58	Itaque maiores asperiores hic quidem.	Rem quas officiis minima minus voluptatum at dolor laboriosam.	2025-07-23	Tempore sint ex inventore qui.	2025-06-29	15:00	3	pending	APT10096	\N
9098	6	3	2025-06-29 16:00:00	Routine Checkup	OPD	Ex animi error incidunt laboriosam.	2025-06-26 22:30:08	2025-06-26 22:30:08	120/67	91	99.1	96	78	Ipsum perferendis eaque aspernatur voluptates dignissimos.	Laudantium voluptatem atque tempora quo pariatur ad.	2025-07-26	Nihil sint dolorum odio ducimus.	2025-06-29	16:00	3	pending	APT10097	\N
9099	107	7	2025-06-29 13:30:00	Routine Checkup	Emergency	Aspernatur cum numquam nulla quisquam.	2025-06-26 22:30:08	2025-06-26 22:30:08	129/80	74	100.1	99	76	Nostrum assumenda numquam omnis sunt asperiores illum.	Adipisci facilis vel nulla ea eveniet.	2025-07-16	Assumenda illo minima voluptatem placeat.	2025-06-29	13:30	3	pending	APT10098	\N
9100	434	3	2025-06-29 12:00:00	Back Pain	Emergency	Placeat rem ad tempora optio nulla quam.	2025-06-26 22:30:08	2025-06-26 22:30:08	112/77	92	97.6	97	77	Voluptate adipisci sint debitis neque repudiandae.	Facere ab atque eligendi iure.	2025-07-13	Incidunt incidunt quis beatae dolore vero laborum eligendi.	2025-06-29	12:00	3	pending	APT10099	\N
9101	20	5	2025-06-29 13:45:00	Routine Checkup	Emergency	Porro distinctio quos qui aperiam quas.	2025-06-26 22:30:08	2025-06-26 22:30:08	128/76	86	98.6	100	70	Ab nisi debitis provident aliquid.	Repellendus sint ducimus culpa maxime.	2025-07-27	Eos consequuntur nesciunt.	2025-06-29	13:45	3	pending	APT10100	\N
9102	262	3	2025-06-29 11:00:00	Fever	Emergency	Deserunt odio aut laudantium at.	2025-06-26 22:30:08	2025-06-26 22:30:08	104/66	88	100.1	96	73	Dolorum distinctio nemo repellat qui facilis.	Cum consequuntur velit maxime consectetur.	2025-07-19	Dolor quis accusamus explicabo eligendi dolorem earum.	2025-06-29	11:00	3	pending	APT10101	\N
9103	343	5	2025-06-29 13:00:00	Cough	New	Sapiente ab maiores ea nobis dolores praesentium.	2025-06-26 22:30:08	2025-06-26 22:30:08	106/76	77	99.6	100	79	Dolor culpa quo labore repudiandae nemo.	Impedit rem laudantium culpa error voluptates.	2025-07-11	Accusamus atque quas.	2025-06-29	13:00	3	pending	APT10102	\N
9104	13	10	2025-06-29 14:30:00	Headache	New	Fugit unde natus ut cumque commodi.	2025-06-26 22:30:08	2025-06-26 22:30:08	127/81	83	98.9	97	84	Est odit dolorem distinctio nisi.	Quibusdam sit perferendis quidem illum.	2025-07-20	Dolorum minima voluptatum rem ea facilis illum.	2025-06-29	14:30	3	pending	APT10103	\N
9105	274	6	2025-06-29 12:00:00	Cough	Emergency	Id qui quas exercitationem sed quia nemo vitae.	2025-06-26 22:30:08	2025-06-26 22:30:08	129/60	83	99.8	95	58	Reprehenderit enim ipsa quos fugit recusandae.	Saepe nemo nobis quidem vero id temporibus odit harum.	2025-07-14	Quas exercitationem provident fuga.	2025-06-29	12:00	3	pending	APT10104	\N
9106	202	8	2025-06-30 12:00:00	Back Pain	Emergency	Magni aliquid dolore aspernatur.	2025-06-26 22:30:08	2025-06-26 22:30:08	102/80	70	100.5	98	66	Culpa exercitationem illo molestiae consequatur.	Earum omnis autem iure ad illum qui voluptatibus atque.	2025-07-28	Adipisci tenetur dolore voluptate necessitatibus.	2025-06-30	12:00	3	pending	APT10105	\N
9107	93	3	2025-06-30 15:30:00	Fever	OPD	Odit aliquid soluta amet minus.	2025-06-26 22:30:08	2025-06-26 22:30:08	110/82	66	100.2	95	61	Hic facilis rerum corporis nemo enim perspiciatis.	Error saepe illo ipsam ratione debitis quam rerum mollitia.	2025-07-23	Eaque dolorem ipsa.	2025-06-30	15:30	3	pending	APT10106	\N
9108	144	5	2025-06-30 16:30:00	Headache	Emergency	Voluptate minus sit laborum quos animi.	2025-06-26 22:30:08	2025-06-26 22:30:08	119/89	73	99.8	99	73	Dolorem est quae mollitia.	Porro sed ullam vitae nobis rem deleniti ea.	2025-07-25	Mollitia eaque accusamus ullam.	2025-06-30	16:30	3	pending	APT10107	\N
9109	90	6	2025-06-30 11:15:00	High BP	Follow-up	Fuga officia molestiae quisquam porro sed voluptate.	2025-06-26 22:30:08	2025-06-26 22:30:08	139/64	77	99.6	98	70	Nulla ipsum quia. Quam cum accusamus itaque eligendi iste.	Similique sequi ab inventore accusamus ipsa et doloribus beatae est.	2025-07-11	Reprehenderit veniam autem libero.	2025-06-30	11:15	3	pending	APT10108	\N
9110	421	7	2025-06-30 13:00:00	Back Pain	Emergency	Exercitationem nihil quisquam architecto laborum quas.	2025-06-26 22:30:08	2025-06-26 22:30:08	119/81	96	99.2	100	76	Fugiat pariatur aspernatur aut rem.	Quae accusantium soluta quo magni.	2025-07-16	Iste blanditiis at dolore omnis tempore nobis quisquam.	2025-06-30	13:00	3	pending	APT10109	\N
9111	126	6	2025-06-30 14:15:00	Diabetes Check	New	Quam minima repellendus debitis consequatur voluptatibus aliquam excepturi.	2025-06-26 22:30:08	2025-06-26 22:30:08	125/78	92	98.8	96	57	Nisi ea unde officia blanditiis nemo autem.	Sed laudantium repudiandae sed vel maxime ullam at quae.	2025-07-20	Facere aliquid voluptates excepturi illum exercitationem eligendi.	2025-06-30	14:15	3	pending	APT10110	\N
9112	77	4	2025-06-30 13:45:00	Routine Checkup	Emergency	Temporibus aspernatur necessitatibus enim error nostrum omnis magni.	2025-06-26 22:30:08	2025-06-26 22:30:08	116/83	65	100.4	98	81	Iusto animi laborum.	At maxime hic cupiditate repellendus nihil magni corrupti incidunt.	2025-07-18	Exercitationem eum id.	2025-06-30	13:45	3	pending	APT10111	\N
9113	176	10	2025-06-30 15:30:00	Routine Checkup	New	Doloribus est tempora quae ullam.	2025-06-26 22:30:08	2025-06-26 22:30:08	123/65	81	100.4	96	82	Blanditiis ratione saepe nemo in.	Necessitatibus consequatur perferendis in tempora corporis.	2025-07-12	Cumque modi esse facere repellendus laborum corporis.	2025-06-30	15:30	3	pending	APT10112	\N
9114	108	9	2025-06-30 14:45:00	Fever	New	Ducimus facere ipsa.	2025-06-26 22:30:08	2025-06-26 22:30:08	122/72	84	99.5	100	74	At porro sit. Labore dolorem earum accusamus esse.	Doloribus vero distinctio nisi asperiores eum.	2025-07-20	Quod fugit commodi sed natus quos nisi.	2025-06-30	14:45	3	pending	APT10113	\N
9115	390	7	2025-06-30 14:45:00	Fever	Follow-up	Optio accusantium similique.	2025-06-26 22:30:08	2025-06-26 22:30:08	123/75	72	100.0	95	66	Voluptatum saepe neque soluta earum facere qui minima.	Officia dolorum natus enim iure voluptatibus voluptatum quis minima.	2025-07-20	Molestias voluptatem tempora dignissimos.	2025-06-30	14:45	3	pending	APT10114	\N
9116	295	5	2025-06-30 14:00:00	Headache	Follow-up	Excepturi praesentium velit.	2025-06-26 22:30:08	2025-06-26 22:30:08	140/65	71	98.2	95	61	Quidem inventore culpa occaecati illo.	Sunt consequuntur excepturi voluptatum vero voluptates corrupti ipsum.	2025-07-09	A sunt officiis adipisci tempora possimus numquam.	2025-06-30	14:00	3	pending	APT10115	\N
9117	311	7	2025-06-30 11:30:00	Headache	OPD	Non repellendus magni iusto.	2025-06-26 22:30:08	2025-06-26 22:30:08	101/60	70	98.4	98	84	Deleniti quis nisi facere nam.	Nihil amet qui maiores totam asperiores.	2025-07-08	Cumque dolores dolores eveniet mollitia repudiandae cum odio.	2025-06-30	11:30	3	pending	APT10116	\N
9118	455	5	2025-06-30 15:00:00	Routine Checkup	New	Quasi iure aliquam praesentium adipisci sunt incidunt.	2025-06-26 22:30:08	2025-06-26 22:30:08	135/79	80	100.4	100	76	Laboriosam harum soluta.	At natus suscipit at odio recusandae soluta.	2025-07-21	Dicta est rerum quaerat reiciendis corporis.	2025-06-30	15:00	3	pending	APT10117	\N
9119	250	4	2025-06-30 16:00:00	High BP	Follow-up	Sequi quos id numquam officia quibusdam.	2025-06-26 22:30:08	2025-06-26 22:30:08	107/83	69	99.2	100	56	Eaque unde asperiores. Non fugiat veniam a.	Libero eaque quae fugiat architecto recusandae quidem sed quis.	2025-07-22	Perferendis doloribus quis harum.	2025-06-30	16:00	3	pending	APT10118	\N
9120	66	10	2025-06-30 16:45:00	Back Pain	New	Veniam fugit soluta officiis dolores.	2025-06-26 22:30:08	2025-06-26 22:30:08	117/74	91	97.6	99	78	Repudiandae blanditiis quae ad.	Minima in totam odit nihil perspiciatis assumenda ea non.	2025-07-18	Qui similique porro laboriosam.	2025-06-30	16:45	3	pending	APT10119	\N
9121	484	9	2025-06-30 14:30:00	Fever	Emergency	Voluptate sed blanditiis expedita.	2025-06-26 22:30:08	2025-06-26 22:30:08	101/79	97	98.9	98	81	Atque numquam doloremque magni nesciunt nostrum.	Et suscipit repellendus aliquid ab voluptates ab at in.	2025-07-10	Nihil accusamus est nesciunt.	2025-06-30	14:30	3	pending	APT10120	\N
9122	407	9	2025-06-30 16:30:00	Routine Checkup	New	Perspiciatis perspiciatis fuga consectetur.	2025-06-26 22:30:08	2025-06-26 22:30:08	129/86	76	99.7	99	83	Sapiente iusto odit doloribus.	Enim odit quam distinctio iusto asperiores.	2025-07-21	Optio enim eligendi totam praesentium voluptate dicta.	2025-06-30	16:30	3	pending	APT10121	\N
9123	406	9	2025-06-30 12:00:00	Cough	New	Illo voluptas esse.	2025-06-26 22:30:08	2025-06-26 22:30:08	138/73	66	98.8	97	57	Beatae repellat possimus ad inventore ad.	Tempore maiores fugiat similique ab tempora tempore tempora.	2025-07-21	Accusamus excepturi dignissimos inventore tenetur eveniet iure.	2025-06-30	12:00	3	pending	APT10122	\N
9124	377	9	2025-06-30 13:30:00	Fever	New	Asperiores placeat numquam repellendus facere similique.	2025-06-26 22:30:08	2025-06-26 22:30:08	121/82	97	99.4	99	60	Magnam veniam doloribus laborum delectus ea.	Fuga labore earum magni maxime assumenda expedita libero asperiores totam laboriosam.	2025-07-14	Quasi occaecati enim excepturi maiores mollitia inventore.	2025-06-30	13:30	3	pending	APT10123	\N
9125	252	3	2025-06-30 13:45:00	Back Pain	Follow-up	Explicabo earum repellendus.	2025-06-26 22:30:08	2025-06-26 22:30:08	140/90	82	99.2	99	72	Animi maiores error quidem ducimus.	Quasi rerum odio numquam eveniet.	2025-07-20	Soluta exercitationem libero velit quae voluptatem.	2025-06-30	13:45	3	pending	APT10124	\N
9126	200	4	2025-06-30 12:30:00	Diabetes Check	Emergency	Doloribus excepturi mollitia unde culpa itaque ipsum.	2025-06-26 22:30:08	2025-06-26 22:30:08	127/85	67	99.5	99	83	Aliquam inventore mollitia. Modi quas autem quam.	Eos porro at corporis esse amet velit deleniti omnis sed.	2025-07-21	Aperiam a odit ea iste magni eum.	2025-06-30	12:30	3	pending	APT10125	\N
9127	345	7	2025-06-30 11:15:00	Routine Checkup	New	Velit cumque eaque fugiat unde.	2025-06-26 22:30:08	2025-06-26 22:30:08	112/80	76	98.0	99	57	Ipsum quod debitis id nostrum modi iusto.	Distinctio natus odit aperiam impedit modi odio.	2025-07-27	Suscipit quis saepe quos amet porro.	2025-06-30	11:15	3	pending	APT10126	\N
9128	24	6	2025-06-30 12:45:00	High BP	Emergency	Ipsa voluptatibus culpa similique quibusdam.	2025-06-26 22:30:08	2025-06-26 22:30:08	127/74	67	97.7	95	62	Et facilis quod alias officiis eius aperiam.	Saepe architecto architecto iste debitis accusantium magnam sit aspernatur.	2025-07-15	Officiis dolores ad eum inventore dolore.	2025-06-30	12:45	3	pending	APT10127	\N
9129	300	9	2025-07-01 13:15:00	Back Pain	OPD	Dolorum fuga aperiam sapiente.	2025-06-26 22:30:08	2025-06-26 22:30:08	130/87	100	98.5	98	64	Esse at nemo beatae vel.	Qui quidem laborum eum repellat totam natus.	2025-07-14	Perferendis assumenda illum qui.	2025-07-01	13:15	3	pending	APT10128	\N
9130	71	7	2025-07-01 12:45:00	Back Pain	New	Quo voluptatibus quos veritatis enim quibusdam quia quos.	2025-06-26 22:30:08	2025-06-26 22:30:08	107/84	71	99.7	96	59	Beatae nobis quos aperiam perspiciatis cumque explicabo.	Error quibusdam quod qui nesciunt placeat sunt nobis.	2025-07-10	Fugiat tempora maiores aut esse nulla sed dolorem.	2025-07-01	12:45	3	pending	APT10129	\N
9131	335	4	2025-07-01 11:30:00	Back Pain	New	Exercitationem corporis non repellendus velit repudiandae corrupti.	2025-06-26 22:30:08	2025-06-26 22:30:08	129/70	98	98.1	96	58	Quae veniam qui quas illo harum non.	Architecto itaque facere exercitationem totam.	2025-07-10	Rerum ducimus earum optio placeat.	2025-07-01	11:30	3	pending	APT10130	\N
9132	493	7	2025-07-01 12:45:00	Diabetes Check	New	Ipsum incidunt veritatis necessitatibus exercitationem consequatur.	2025-06-26 22:30:08	2025-06-26 22:30:08	113/76	65	99.7	95	85	Reiciendis facere ipsam enim asperiores.	Illo asperiores dignissimos explicabo consequatur excepturi minima a voluptate.	2025-07-26	Animi sint quae nihil.	2025-07-01	12:45	3	pending	APT10131	\N
9133	437	5	2025-07-01 13:00:00	Cough	Follow-up	Laudantium perferendis consequuntur at deserunt velit ut.	2025-06-26 22:30:08	2025-06-26 22:30:08	127/64	69	98.3	99	74	Odit labore fugiat neque suscipit sapiente ab.	Mollitia praesentium fugiat quos labore numquam fugit id aut.	2025-07-18	Delectus repellat eos doloremque maxime exercitationem.	2025-07-01	13:00	3	pending	APT10132	\N
9134	313	9	2025-07-01 15:45:00	Routine Checkup	Follow-up	Quos recusandae adipisci.	2025-06-26 22:30:08	2025-06-26 22:30:08	133/69	99	98.9	99	62	Dolores hic saepe eum cupiditate velit.	Facere eum magni quidem ipsam eligendi rem cupiditate sint quo.	2025-07-17	Accusamus modi officia nam.	2025-07-01	15:45	3	pending	APT10133	\N
9135	91	4	2025-07-01 11:45:00	High BP	New	Iste omnis dolorem voluptatibus quos amet eveniet.	2025-06-26 22:30:08	2025-06-26 22:30:08	121/88	65	98.7	99	82	Fugit voluptatem animi natus vero consectetur laudantium.	Porro perferendis a numquam perferendis vel.	2025-07-31	Repellat molestiae earum fugiat aliquam nemo.	2025-07-01	11:45	3	pending	APT10134	\N
9136	198	3	2025-07-01 11:15:00	Skin Rash	New	Saepe accusantium ea deleniti iusto laboriosam.	2025-06-26 22:30:08	2025-06-26 22:30:08	135/65	97	98.5	95	65	Saepe odit placeat non est.	Corporis dolorum nulla iure exercitationem incidunt in ratione consectetur dolore.	2025-07-17	Reprehenderit dolorem ea voluptatibus nostrum tempora.	2025-07-01	11:15	3	pending	APT10135	\N
11004	507	4	2025-07-05T12:30:00	Severe fever & vomit	followup	Having severe body ache & stuffness 	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-07-05	12:30	3	scheduled	APT-20250703-003	\N
9137	398	6	2025-07-01 15:30:00	Routine Checkup	Follow-up	Inventore repudiandae modi est distinctio labore.	2025-06-26 22:30:08	2025-06-26 22:30:08	111/61	73	98.5	98	71	Non dolore ex. Laudantium repudiandae a autem dolor.	Voluptates sapiente inventore saepe perspiciatis.	2025-07-25	Eveniet cum reiciendis consequatur iusto eaque nobis.	2025-07-01	15:30	3	pending	APT10136	\N
9138	381	4	2025-07-01 14:15:00	Skin Rash	Follow-up	Explicabo nisi numquam fugit.	2025-06-26 22:30:08	2025-06-26 22:30:08	130/82	68	98.0	98	84	At dolore veritatis quod. Impedit sequi minus occaecati.	Natus cupiditate natus commodi perspiciatis harum quas qui.	2025-07-22	Eum in officiis architecto.	2025-07-01	14:15	3	pending	APT10137	\N
9139	409	5	2025-07-01 16:45:00	Routine Checkup	Follow-up	Quam temporibus odit omnis nulla.	2025-06-26 22:30:08	2025-06-26 22:30:08	122/78	99	98.5	97	57	Optio praesentium voluptatibus omnis natus.	Dolores perspiciatis ad officiis laborum illum dolorem.	2025-07-19	Alias debitis iusto dolorem deserunt quasi officiis.	2025-07-01	16:45	3	pending	APT10138	\N
9140	301	9	2025-07-01 15:15:00	Diabetes Check	Follow-up	Dolor cupiditate aut.	2025-06-26 22:30:08	2025-06-26 22:30:08	127/74	83	99.0	98	61	Vitae exercitationem minus ut ipsum quibusdam excepturi.	Eius velit ullam minus corporis hic ipsam officiis repudiandae.	2025-07-30	Dignissimos molestias natus magnam beatae eaque.	2025-07-01	15:15	3	pending	APT10139	\N
9141	283	8	2025-07-01 12:15:00	Cough	New	Dolorum incidunt dolore perferendis quae voluptatem asperiores.	2025-06-26 22:30:08	2025-06-26 22:30:08	111/69	67	98.4	97	55	Tempore id officiis molestiae.	Mollitia esse voluptatem ea quibusdam ducimus.	2025-07-12	Deleniti soluta deleniti commodi.	2025-07-01	12:15	3	pending	APT10140	\N
9142	65	7	2025-07-01 13:45:00	Diabetes Check	Follow-up	Nulla nihil dolore fugiat.	2025-06-26 22:30:08	2025-06-26 22:30:08	118/70	93	99.0	96	58	Fugiat ut odit impedit voluptatum. Tempora vel aspernatur.	Unde cum aliquam provident deleniti pariatur deserunt.	2025-07-13	Quibusdam ad delectus soluta rerum voluptatum.	2025-07-01	13:45	3	pending	APT10141	\N
9143	16	3	2025-07-01 16:00:00	Diabetes Check	Emergency	Officiis autem vel veniam tenetur corporis asperiores.	2025-06-26 22:30:08	2025-06-26 22:30:08	111/70	92	99.6	96	79	Quia error pariatur quasi. Sequi quaerat commodi quis odio.	Nam voluptate quia animi sed amet labore atque possimus neque.	2025-07-12	Libero hic vel doloribus enim doloremque tempora.	2025-07-01	16:00	3	pending	APT10142	\N
9144	281	3	2025-07-01 16:00:00	Routine Checkup	New	Perspiciatis sint numquam iure nostrum.	2025-06-26 22:30:08	2025-06-26 22:30:08	111/70	86	99.9	96	64	Perferendis incidunt itaque vero voluptatem non id.	Sequi omnis inventore laborum dignissimos placeat.	2025-07-19	Ipsum id doloribus.	2025-07-01	16:00	3	pending	APT10143	\N
9145	366	3	2025-07-01 12:45:00	Back Pain	Emergency	Eligendi neque provident nostrum vitae asperiores corporis.	2025-06-26 22:30:08	2025-06-26 22:30:08	125/78	73	99.4	97	68	Et a natus fuga voluptatibus vitae dicta.	Et voluptas fugit ut id doloremque cupiditate illo ullam itaque.	2025-07-12	Ducimus laboriosam pariatur omnis.	2025-07-01	12:45	3	pending	APT10144	\N
9146	351	7	2025-07-01 12:45:00	Routine Checkup	Follow-up	Magni placeat asperiores exercitationem pariatur.	2025-06-26 22:30:08	2025-06-26 22:30:08	129/83	98	98.4	98	67	Veniam ipsam exercitationem voluptas.	Cum doloremque blanditiis expedita excepturi id sed ut animi officia.	2025-07-14	Aliquid minus sit porro tempora.	2025-07-01	12:45	3	pending	APT10145	\N
9147	17	3	2025-07-01 15:45:00	Routine Checkup	Emergency	Hic sint velit iure temporibus vel.	2025-06-26 22:30:08	2025-06-26 22:30:08	129/60	90	98.2	96	79	Consectetur ea vero consequatur commodi vitae veritatis.	Aperiam temporibus aspernatur deserunt similique similique sit eius fugit nihil.	2025-07-08	Non eum numquam quaerat est in eligendi.	2025-07-01	15:45	3	pending	APT10146	\N
9148	10	8	2025-07-01 16:00:00	Back Pain	Follow-up	Veniam porro eligendi occaecati ullam ratione dolores.	2025-06-26 22:30:08	2025-06-26 22:30:08	108/90	75	97.9	95	59	Vel voluptatem recusandae eaque. Architecto numquam libero.	Eveniet dignissimos vero in saepe corrupti.	2025-07-17	Asperiores eos ipsum iure non hic.	2025-07-01	16:00	3	pending	APT10147	\N
9149	255	9	2025-07-01 15:15:00	Skin Rash	Emergency	Quisquam alias quia laboriosam eligendi sint dicta.	2025-06-26 22:30:08	2025-06-26 22:30:08	125/74	84	98.1	95	63	Cupiditate nesciunt neque deleniti pariatur praesentium.	Ea repudiandae ad neque repellendus minima eum dolor occaecati.	2025-07-17	Ex cumque occaecati est quo.	2025-07-01	15:15	3	pending	APT10148	\N
9150	277	7	2025-07-01 15:00:00	Back Pain	OPD	Suscipit dicta dicta aspernatur enim.	2025-06-26 22:30:08	2025-06-26 22:30:08	109/76	75	97.6	99	85	Illo eos repellat repellat aliquid.	Harum voluptate pariatur libero rem nostrum cumque saepe.	2025-07-31	Sunt optio eaque sequi ducimus quidem.	2025-07-01	15:00	3	pending	APT10149	\N
9151	196	6	2025-07-01 16:00:00	Cough	New	Quidem optio repudiandae nisi pariatur ut libero.	2025-06-26 22:30:08	2025-06-26 22:30:08	128/60	88	100.1	100	70	Nam incidunt quam error voluptates necessitatibus non qui.	Natus maiores iure quaerat officia blanditiis molestiae non.	2025-07-08	Cumque vel corporis illo recusandae.	2025-07-01	16:00	3	pending	APT10150	\N
9152	350	6	2025-07-01 12:00:00	Back Pain	OPD	Nobis expedita qui.	2025-06-26 22:30:08	2025-06-26 22:30:08	117/72	77	100.5	95	56	Beatae optio ut odit quia ea.	Quam deleniti neque beatae deserunt illo quisquam perspiciatis quas nostrum.	2025-07-29	Velit quidem aspernatur inventore nemo minima veniam.	2025-07-01	12:00	3	pending	APT10151	\N
9153	363	6	2025-07-01 15:00:00	Back Pain	OPD	Ducimus quo saepe exercitationem officiis.	2025-06-26 22:30:08	2025-06-26 22:30:08	101/82	76	99.0	97	70	Autem officia incidunt praesentium doloremque ex adipisci.	Harum iure quasi voluptatem eos repellendus maiores.	2025-07-12	Eum eius autem dolore iure error tempore.	2025-07-01	15:00	3	pending	APT10152	\N
9154	440	8	2025-07-01 12:00:00	Diabetes Check	Emergency	Nihil eaque eos consectetur amet.	2025-06-26 22:30:08	2025-06-26 22:30:08	112/74	81	97.7	97	68	Odit consectetur animi tempore accusantium quasi.	Quisquam molestias corrupti doloribus illo dolor ut.	2025-07-27	Sapiente perspiciatis nostrum debitis eum nemo magni beatae.	2025-07-01	12:00	3	pending	APT10153	\N
9155	124	8	2025-07-02 12:30:00	Diabetes Check	Emergency	Fugit quae praesentium sed.	2025-06-26 22:30:08	2025-06-26 22:30:08	132/83	66	99.0	98	69	Mollitia fugit voluptas aliquam laborum sunt eos.	Maxime facilis ut tempore consequuntur.	2025-07-20	Occaecati magni laudantium iste eligendi.	2025-07-02	12:30	3	pending	APT10154	\N
9156	244	6	2025-07-02 16:15:00	Back Pain	Emergency	Perferendis minus error corporis.	2025-06-26 22:30:08	2025-06-26 22:30:08	117/83	77	97.7	96	60	Totam exercitationem a aliquam illum.	Nobis corporis nisi illo nesciunt vero.	2025-07-10	Accusantium ad commodi voluptatum.	2025-07-02	16:15	3	pending	APT10155	\N
9157	379	9	2025-07-02 16:15:00	High BP	Emergency	Laudantium eveniet voluptate distinctio perspiciatis voluptatibus.	2025-06-26 22:30:08	2025-06-26 22:30:08	108/84	79	100.0	99	83	Sint eveniet reiciendis omnis natus.	Excepturi quisquam quasi illum consequuntur at cupiditate reprehenderit facilis magnam magni.	2025-07-20	Fugit soluta excepturi similique.	2025-07-02	16:15	3	pending	APT10156	\N
9158	156	3	2025-07-02 11:30:00	Routine Checkup	Emergency	Quos harum sed voluptate itaque voluptas.	2025-06-26 22:30:08	2025-06-26 22:30:08	138/80	67	97.9	97	76	Esse enim architecto vel quam perspiciatis pariatur.	Deserunt quam nihil consequuntur natus aut.	2025-07-09	Ducimus ipsum voluptate ullam.	2025-07-02	11:30	3	pending	APT10157	\N
9159	283	8	2025-07-02 13:00:00	Cough	New	Dolor soluta quasi impedit dolor deleniti adipisci.	2025-06-26 22:30:08	2025-06-26 22:30:08	140/66	67	97.8	99	70	Eveniet fugiat eligendi quas culpa.	Rem molestias animi labore sed.	2025-07-10	Nostrum unde nobis ea voluptate consequuntur.	2025-07-02	13:00	3	pending	APT10158	\N
9160	177	3	2025-07-02 14:00:00	Cough	Emergency	Iste laudantium odio.	2025-06-26 22:30:08	2025-06-26 22:30:08	103/70	80	98.3	95	78	Repellat voluptates sunt fuga ipsum.	Porro molestiae mollitia laudantium nostrum doloribus.	2025-07-16	Suscipit animi consequatur.	2025-07-02	14:00	3	pending	APT10159	\N
9161	220	6	2025-07-02 12:45:00	High BP	Emergency	Exercitationem impedit inventore dignissimos.	2025-06-26 22:30:08	2025-06-26 22:30:08	138/75	67	100.1	95	71	Corporis sequi deserunt impedit.	Quo ut non eius assumenda non tempore.	2025-07-26	In a dolore sunt cumque modi ratione.	2025-07-02	12:45	3	pending	APT10160	\N
9162	200	5	2025-07-02 14:00:00	Cough	OPD	Nemo dolore itaque voluptatibus nostrum animi.	2025-06-26 22:30:08	2025-06-26 22:30:08	129/86	70	97.6	99	66	Beatae impedit deleniti magnam nam itaque laudantium.	Dolorum debitis tempora dolorum vel.	2025-07-11	Sapiente veniam delectus eum suscipit praesentium omnis.	2025-07-02	14:00	3	pending	APT10161	\N
9163	303	4	2025-07-02 12:15:00	Routine Checkup	Follow-up	Possimus illum id corporis officiis numquam nemo.	2025-06-26 22:30:08	2025-06-26 22:30:08	130/76	83	100.4	99	57	Amet nostrum odio. Repellat animi quas quae.	Necessitatibus accusantium quam impedit amet magnam quasi quia excepturi facere.	2025-08-01	Aperiam quasi non magni iusto.	2025-07-02	12:15	3	pending	APT10162	\N
9164	489	4	2025-07-02 12:00:00	Skin Rash	Emergency	Unde maiores consequuntur porro.	2025-06-26 22:30:08	2025-06-26 22:30:08	119/80	85	97.7	99	67	Nostrum expedita qui impedit corporis quas.	Maiores eligendi voluptatem ipsa doloremque nulla atque.	2025-07-28	Odit expedita suscipit consectetur.	2025-07-02	12:00	3	pending	APT10163	\N
9165	172	10	2025-07-02 12:15:00	High BP	Emergency	Rerum commodi dicta aliquam voluptate eos nobis praesentium.	2025-06-26 22:30:08	2025-06-26 22:30:08	103/84	83	98.5	98	75	Ullam voluptate saepe quod atque odit doloremque inventore.	Adipisci dolorem facilis nobis eum temporibus facilis aspernatur minima.	2025-07-23	Ea voluptate corrupti doloremque sunt voluptates placeat.	2025-07-02	12:15	3	pending	APT10164	\N
9166	204	3	2025-07-02 15:15:00	Routine Checkup	Follow-up	Nihil asperiores occaecati quasi impedit.	2025-06-26 22:30:08	2025-06-26 22:30:08	138/81	96	97.7	99	56	Praesentium ex soluta soluta odio voluptates.	Deserunt exercitationem incidunt similique velit.	2025-07-25	Natus consectetur molestiae iste eum consequatur.	2025-07-02	15:15	3	pending	APT10165	\N
9167	479	8	2025-07-02 16:15:00	Diabetes Check	Follow-up	Optio voluptas beatae rem tempora libero.	2025-06-26 22:30:08	2025-06-26 22:30:08	134/77	99	99.4	96	82	Ipsam sunt id similique tempora natus.	Expedita repellendus architecto assumenda velit atque distinctio repudiandae.	2025-07-10	Dolore earum sit laudantium qui qui exercitationem omnis.	2025-07-02	16:15	3	pending	APT10166	\N
9168	135	7	2025-07-02 12:00:00	Headache	Emergency	Autem sit sed dolore labore occaecati suscipit.	2025-06-26 22:30:08	2025-06-26 22:30:08	115/67	85	98.5	96	59	Tempore fuga amet molestias quis nam sequi.	Atque minus explicabo delectus excepturi debitis.	2025-07-09	In beatae voluptate tempora harum quos velit.	2025-07-02	12:00	3	pending	APT10167	\N
9169	45	7	2025-07-02 16:15:00	High BP	Emergency	Non reprehenderit iure et accusamus.	2025-06-26 22:30:08	2025-06-26 22:30:08	100/81	68	98.8	99	77	Voluptatibus qui praesentium expedita.	Dicta excepturi ea quaerat velit magnam.	2025-07-22	Sapiente dolore delectus iusto.	2025-07-02	16:15	3	pending	APT10168	\N
9170	473	10	2025-07-02 11:15:00	Headache	New	Ut occaecati aspernatur dolores magni perferendis vero modi.	2025-06-26 22:30:08	2025-06-26 22:30:08	139/68	82	99.5	100	60	Sed labore error officiis ducimus.	Quas architecto molestiae ad minima.	2025-07-09	Sint excepturi unde asperiores blanditiis.	2025-07-02	11:15	3	pending	APT10169	\N
9171	52	4	2025-07-02 14:00:00	Routine Checkup	New	Voluptates illum nam exercitationem totam qui.	2025-06-26 22:30:08	2025-06-26 22:30:08	104/87	96	98.4	97	77	Quos voluptate veritatis provident.	Veritatis aspernatur ea odio beatae ab amet veniam assumenda excepturi.	2025-07-26	Aliquam nisi illo doloribus labore ad nulla.	2025-07-02	14:00	3	pending	APT10170	\N
9172	45	8	2025-07-02 16:00:00	Diabetes Check	Emergency	Exercitationem ad a est ipsa adipisci sapiente.	2025-06-26 22:30:08	2025-06-26 22:30:08	108/86	96	99.9	95	77	Necessitatibus quaerat voluptate fugiat deleniti repellat.	Nostrum odit modi veniam labore odit perspiciatis laudantium hic fugit.	2025-07-11	Doloribus asperiores harum molestias.	2025-07-02	16:00	3	pending	APT10171	\N
9173	147	4	2025-07-02 14:30:00	Back Pain	Follow-up	Minus soluta maxime pariatur dignissimos facere assumenda molestias.	2025-06-26 22:30:08	2025-06-26 22:30:08	140/63	85	97.7	100	56	Debitis illo non quae sed enim nisi.	Reiciendis ut officia exercitationem distinctio accusamus debitis dolor sint enim.	2025-07-15	Ea ut excepturi qui.	2025-07-02	14:30	3	pending	APT10172	\N
9174	198	8	2025-07-02 12:00:00	High BP	New	Vel accusantium laudantium quos ipsum totam.	2025-06-26 22:30:08	2025-06-26 22:30:08	109/78	83	97.7	98	78	Quam delectus aliquid necessitatibus.	Quis consectetur et libero iusto quibusdam.	2025-08-01	Sapiente qui repellat deleniti magnam quam sit nesciunt.	2025-07-02	12:00	3	pending	APT10173	\N
9175	428	8	2025-07-02 12:15:00	High BP	New	Saepe unde distinctio placeat minima optio.	2025-06-26 22:30:08	2025-06-26 22:30:08	112/67	66	100.2	97	66	Facilis fuga repudiandae.	Aut dolore rerum neque ducimus ullam laboriosam nostrum modi cum.	2025-07-20	Rem corporis iure repellendus.	2025-07-02	12:15	3	pending	APT10174	\N
9176	398	5	2025-07-02 14:00:00	Routine Checkup	Follow-up	Voluptatibus error provident impedit molestiae dolor sed perferendis.	2025-06-26 22:30:08	2025-06-26 22:30:08	137/79	81	99.9	95	70	Consequuntur nam rem repudiandae nesciunt.	Quidem praesentium ab recusandae facilis sapiente aspernatur animi accusantium.	2025-07-11	Temporibus repudiandae nostrum ducimus quidem incidunt.	2025-07-02	14:00	3	pending	APT10175	\N
9177	379	7	2025-07-02 16:45:00	Diabetes Check	New	Placeat natus magni dolore porro consequuntur nemo.	2025-06-26 22:30:08	2025-06-26 22:30:08	114/74	70	97.6	95	76	Fuga cum quibusdam quidem cupiditate odit.	Nesciunt quaerat eos debitis ex.	2025-07-09	Nisi delectus dicta amet expedita dolore illo maiores.	2025-07-02	16:45	3	pending	APT10176	\N
9178	347	8	2025-07-02 14:15:00	Fever	Follow-up	Aliquam alias doloremque eveniet deserunt ipsum.	2025-06-26 22:30:08	2025-06-26 22:30:08	124/67	66	98.5	99	71	Odio eius assumenda asperiores iure.	Cum ex expedita natus saepe quasi quam velit.	2025-07-25	Possimus nihil molestias.	2025-07-02	14:15	3	pending	APT10177	\N
9179	113	3	2025-07-03 11:15:00	Back Pain	OPD	Consequatur asperiores nesciunt alias sequi officia.	2025-06-26 22:30:08	2025-06-26 22:30:08	115/60	85	99.9	99	80	Magni rerum esse veritatis ullam.	Cum laborum quaerat nihil unde soluta vel sed atque.	2025-07-11	Nihil quidem dolore.	2025-07-03	11:15	3	pending	APT10178	\N
9180	163	7	2025-07-03 16:00:00	Routine Checkup	Follow-up	Fugiat consequatur perferendis soluta beatae commodi vero harum.	2025-06-26 22:30:08	2025-06-26 22:30:08	118/86	81	100.0	96	79	Consequatur mollitia voluptate fuga illo harum.	Sunt molestias sed laudantium minus commodi et consectetur reiciendis quo.	2025-08-02	Expedita mollitia rerum et minima quibusdam officia.	2025-07-03	16:00	3	pending	APT10179	\N
9181	158	6	2025-07-03 14:00:00	Headache	OPD	Rem odio maiores praesentium.	2025-06-26 22:30:08	2025-06-26 22:30:08	131/87	74	98.8	95	79	Delectus nobis ullam nulla.	Commodi harum voluptatem exercitationem quaerat repellat nobis.	2025-07-25	Numquam esse veritatis earum.	2025-07-03	14:00	3	pending	APT10180	\N
9182	462	9	2025-07-03 13:30:00	High BP	Emergency	Mollitia quo voluptatum inventore.	2025-06-26 22:30:08	2025-06-26 22:30:08	104/61	80	100.2	100	58	Reprehenderit error vitae sit officia temporibus.	Libero excepturi nesciunt odit.	2025-08-02	Maxime esse molestiae minima quae.	2025-07-03	13:30	3	pending	APT10181	\N
9183	161	7	2025-07-03 16:00:00	Fever	Follow-up	Consequatur delectus est inventore.	2025-06-26 22:30:08	2025-06-26 22:30:08	139/62	85	99.6	100	83	Voluptatibus impedit est id placeat necessitatibus.	Nulla facere facilis voluptates deserunt aperiam expedita repudiandae.	2025-07-30	Nulla vitae expedita rerum corporis distinctio.	2025-07-03	16:00	3	pending	APT10182	\N
9184	278	4	2025-07-03 16:00:00	Routine Checkup	Emergency	Corporis tempora modi tempora aliquid sapiente animi.	2025-06-26 22:30:08	2025-06-26 22:30:08	134/68	84	97.6	96	65	Assumenda delectus natus accusamus incidunt odio.	Asperiores ea necessitatibus in sapiente incidunt.	2025-07-16	Porro dolore natus repellendus mollitia rem sunt.	2025-07-03	16:00	3	pending	APT10183	\N
9185	16	8	2025-07-03 14:45:00	Fever	Follow-up	Possimus voluptatem illum harum fugit deleniti quibusdam.	2025-06-26 22:30:08	2025-06-26 22:30:08	118/75	72	99.5	97	55	Dolorem libero ab quas quo vel modi temporibus.	Animi soluta cum quos veritatis laboriosam rem atque et.	2025-07-25	Voluptatem modi cum.	2025-07-03	14:45	3	pending	APT10184	\N
9186	171	9	2025-07-03 15:15:00	Diabetes Check	Emergency	Repellat neque sed possimus ipsam nobis.	2025-06-26 22:30:08	2025-06-26 22:30:08	129/61	74	98.7	99	67	Nam a rerum quisquam possimus.	Facere ea aut cupiditate sequi non quam dolor.	2025-07-14	Explicabo cumque consequuntur.	2025-07-03	15:15	3	pending	APT10185	\N
9187	292	7	2025-07-03 14:15:00	Back Pain	New	Officiis facilis dicta est.	2025-06-26 22:30:08	2025-06-26 22:30:08	118/74	71	100.3	96	83	Veniam sunt in ad a et laborum porro.	Eos id quos quisquam assumenda repellendus cumque.	2025-07-27	Sed aliquam quisquam repellendus.	2025-07-03	14:15	3	pending	APT10186	\N
9188	77	10	2025-07-03 14:00:00	Headache	New	Dolores asperiores voluptatem saepe natus.	2025-06-26 22:30:08	2025-06-26 22:30:08	106/77	77	97.6	99	81	Architecto magnam quisquam impedit pariatur illo.	Aut expedita recusandae blanditiis laudantium recusandae ex.	2025-07-29	Libero dignissimos fugiat dolor molestiae.	2025-07-03	14:00	3	pending	APT10187	\N
9189	69	5	2025-07-03 12:30:00	Diabetes Check	Follow-up	Quis corporis aperiam magni deserunt occaecati exercitationem.	2025-06-26 22:30:08	2025-06-26 22:30:08	122/60	92	97.8	96	76	Harum nemo eaque reiciendis laboriosam quasi aperiam.	Enim provident dicta quasi reiciendis sapiente sunt atque.	2025-08-01	Numquam rerum blanditiis laboriosam.	2025-07-03	12:30	3	pending	APT10188	\N
9190	25	3	2025-07-03 14:45:00	High BP	New	Vel enim labore eum veritatis.	2025-06-26 22:30:08	2025-06-26 22:30:08	102/79	65	99.9	98	62	Sit ipsam impedit temporibus nemo asperiores quisquam.	Tempore corrupti neque ab modi porro pariatur animi.	2025-07-13	Ex ipsa velit eos dicta consequatur quidem.	2025-07-03	14:45	3	pending	APT10189	\N
9191	157	7	2025-07-03 15:00:00	Headache	Follow-up	Recusandae provident consequatur unde iste.	2025-06-26 22:30:08	2025-06-26 22:30:08	138/71	76	98.4	97	70	Beatae voluptatibus sequi sed sunt.	Consequuntur cumque eum sequi nihil.	2025-07-25	Porro magnam aliquam corporis aut tempore tempora ullam.	2025-07-03	15:00	3	pending	APT10190	\N
9192	470	5	2025-07-03 13:30:00	Fever	Emergency	Debitis amet tempore porro ea.	2025-06-26 22:30:08	2025-06-26 22:30:08	130/90	74	99.5	100	79	Alias nesciunt perferendis aut tempora consectetur libero.	Totam nesciunt ut laborum voluptatem officiis impedit.	2025-07-11	Minima dignissimos rerum expedita autem assumenda.	2025-07-03	13:30	3	pending	APT10191	\N
9193	333	8	2025-07-03 12:30:00	Fever	Emergency	Laboriosam magni harum accusantium voluptates tenetur.	2025-06-26 22:30:08	2025-06-26 22:30:08	139/89	75	98.7	98	68	Maiores ea accusamus non.	Ab dignissimos id tempore soluta quas expedita optio eius.	2025-08-02	Excepturi tempora rem.	2025-07-03	12:30	3	pending	APT10192	\N
9194	292	6	2025-07-03 11:45:00	Routine Checkup	Emergency	Nisi nemo non quisquam.	2025-06-26 22:30:08	2025-06-26 22:30:08	138/87	83	97.7	97	79	Repellendus iure fugit neque modi cumque.	Amet laborum vero tempora vitae impedit perspiciatis voluptate.	2025-07-10	At voluptate quo ab ipsum odit reiciendis.	2025-07-03	11:45	3	pending	APT10193	\N
9195	277	7	2025-07-03 15:15:00	High BP	New	Deleniti a repudiandae hic sapiente tempora.	2025-06-26 22:30:08	2025-06-26 22:30:08	131/87	98	98.6	99	85	Magnam impedit reprehenderit praesentium.	Totam atque nemo quibusdam cum occaecati porro officia in.	2025-07-12	Porro aliquam fugiat praesentium commodi.	2025-07-03	15:15	3	pending	APT10194	\N
9196	465	3	2025-07-03 15:15:00	Skin Rash	Follow-up	Labore error saepe cupiditate eum.	2025-06-26 22:30:08	2025-06-26 22:30:08	125/73	67	99.8	98	56	Dolorum autem facere id magni quos iure.	Ex nisi aspernatur sunt exercitationem incidunt culpa quibusdam sequi magni.	2025-08-01	Iure nesciunt officiis nobis neque.	2025-07-03	15:15	3	pending	APT10195	\N
9197	492	8	2025-07-03 15:45:00	Back Pain	New	Est voluptatem et nostrum amet suscipit asperiores.	2025-06-26 22:30:08	2025-06-26 22:30:08	100/68	78	98.1	100	78	Ut minus odit minima totam dolorum doloribus.	Illum similique molestias veritatis fugit officiis praesentium modi eveniet.	2025-07-28	Error tenetur delectus autem.	2025-07-03	15:45	3	pending	APT10196	\N
9198	86	5	2025-07-03 15:45:00	Cough	OPD	Ea consequatur minima architecto veniam deleniti magni.	2025-06-26 22:30:08	2025-06-26 22:30:08	108/82	86	97.9	99	78	Perspiciatis corrupti animi nam laboriosam accusamus.	Atque beatae facilis laudantium nam nam omnis.	2025-07-31	Quo corrupti id in beatae quia enim minus.	2025-07-03	15:45	3	pending	APT10197	\N
9199	25	7	2025-07-03 14:15:00	Fever	New	Fuga laboriosam hic similique.	2025-06-26 22:30:08	2025-06-26 22:30:08	106/70	99	98.7	100	59	Nostrum similique maxime iusto pariatur.	Placeat atque corrupti aut ex.	2025-07-31	Laboriosam laborum ea tenetur.	2025-07-03	14:15	3	pending	APT10198	\N
9200	475	4	2025-07-03 16:00:00	Fever	New	Natus ipsam reprehenderit impedit quaerat possimus dolore.	2025-06-26 22:30:08	2025-06-26 22:30:08	129/64	80	97.9	100	65	Exercitationem animi quam repellat ipsam.	Autem neque nostrum blanditiis corrupti dolorem vero neque similique.	2025-07-12	Sequi esse placeat delectus.	2025-07-03	16:00	3	pending	APT10199	\N
9201	145	5	2025-07-03 13:00:00	Cough	New	Dolorum optio non quo nam nostrum mollitia.	2025-06-26 22:30:08	2025-06-26 22:30:08	113/71	83	99.5	97	80	Odit eaque voluptatum quisquam laudantium in.	Numquam itaque provident aspernatur sint aliquid quos.	2025-07-10	Ratione debitis deserunt nihil voluptas at.	2025-07-03	13:00	3	pending	APT10200	\N
9202	21	9	2025-07-04 12:00:00	Fever	Emergency	Dolor totam non eveniet labore iure.	2025-06-26 22:30:08	2025-06-26 22:30:08	107/89	89	97.8	98	84	Delectus et a iure.	Perspiciatis aspernatur vitae odit reiciendis.	2025-07-26	Quae veniam voluptatem quo quae.	2025-07-04	12:00	3	pending	APT10201	\N
9203	229	5	2025-07-04 14:00:00	Diabetes Check	OPD	Sunt eligendi sequi assumenda dolores.	2025-06-26 22:30:08	2025-06-26 22:30:08	110/74	80	100.0	97	69	Sit vero magnam accusantium magnam.	Distinctio incidunt quibusdam harum perspiciatis id tenetur.	2025-07-26	A earum deserunt cumque debitis.	2025-07-04	14:00	3	pending	APT10202	\N
9204	389	8	2025-07-04 16:30:00	Routine Checkup	Follow-up	Temporibus nesciunt voluptatibus eos voluptate aliquam.	2025-06-26 22:30:08	2025-06-26 22:30:08	103/66	81	97.8	97	57	Eos sint est recusandae mollitia.	A fugit eum sapiente nihil.	2025-07-30	Architecto explicabo aliquam fuga dicta delectus.	2025-07-04	16:30	3	pending	APT10203	\N
9205	495	3	2025-07-04 16:30:00	Routine Checkup	New	Officiis nisi distinctio laudantium sed.	2025-06-26 22:30:08	2025-06-26 22:30:08	120/69	70	99.8	95	82	Atque hic provident eligendi deleniti.	Rem fuga vitae similique aliquam nesciunt a ipsam delectus excepturi.	2025-07-16	A doloribus laudantium aliquid.	2025-07-04	16:30	3	pending	APT10204	\N
9206	480	4	2025-07-04 12:00:00	Back Pain	OPD	Unde quisquam officiis totam fugit nulla.	2025-06-26 22:30:08	2025-06-26 22:30:08	116/88	85	100.3	98	83	Officia impedit nulla odio quam.	At modi optio maxime.	2025-08-01	Accusamus omnis sint.	2025-07-04	12:00	3	pending	APT10205	\N
9207	194	8	2025-07-04 14:30:00	Diabetes Check	OPD	Necessitatibus beatae porro necessitatibus ipsam consequatur tenetur.	2025-06-26 22:30:08	2025-06-26 22:30:08	115/77	91	99.1	95	85	Quisquam facere nulla rerum pariatur quidem nulla eos.	Laudantium magni exercitationem totam quam nostrum blanditiis autem ut.	2025-07-22	Dignissimos nobis quasi cum ullam.	2025-07-04	14:30	3	pending	APT10206	\N
9208	120	6	2025-07-04 12:30:00	Skin Rash	New	Atque tempora enim facilis totam ullam dolorum.	2025-06-26 22:30:08	2025-06-26 22:30:08	130/70	99	98.8	95	64	Quod saepe numquam itaque facilis sunt expedita vitae.	Itaque quae consequatur quas impedit.	2025-07-11	Accusantium velit aut voluptas voluptatum sunt neque.	2025-07-04	12:30	3	pending	APT10207	\N
9209	247	5	2025-07-04 14:45:00	Skin Rash	Emergency	Dolorem beatae sit quae itaque pariatur eaque.	2025-06-26 22:30:08	2025-06-26 22:30:08	129/66	81	100.3	99	59	Culpa culpa id fuga consequuntur modi.	Expedita dolor eligendi veniam hic cumque eveniet repudiandae nostrum eum.	2025-07-26	Quod repudiandae culpa ratione.	2025-07-04	14:45	3	pending	APT10208	\N
9210	366	5	2025-07-04 13:30:00	Back Pain	Emergency	Neque beatae a esse quibusdam ipsum.	2025-06-26 22:30:08	2025-06-26 22:30:08	131/71	86	97.7	99	73	Asperiores culpa consequuntur.	Provident magni autem quaerat modi quisquam exercitationem unde explicabo unde.	2025-07-21	Totam voluptatibus ex soluta.	2025-07-04	13:30	3	pending	APT10209	\N
9211	82	3	2025-07-04 12:00:00	Skin Rash	Emergency	Corporis possimus rerum facere veritatis molestiae nam.	2025-06-26 22:30:08	2025-06-26 22:30:08	137/62	76	98.2	99	70	Sapiente iste voluptate officiis dolor nam veritatis earum.	Omnis voluptates ullam ea aliquid minima.	2025-07-16	Neque labore non.	2025-07-04	12:00	3	pending	APT10210	\N
9212	499	8	2025-07-04 14:15:00	High BP	New	Sunt molestiae hic ab.	2025-06-26 22:30:08	2025-06-26 22:30:08	120/80	74	99.4	95	66	Voluptatem consectetur alias natus quia.	Repellendus laboriosam assumenda eum quos qui quod.	2025-07-31	Deserunt esse blanditiis accusamus id velit corrupti.	2025-07-04	14:15	3	pending	APT10211	\N
9213	263	8	2025-07-04 14:15:00	Fever	Emergency	Minima architecto architecto quaerat repellendus.	2025-06-26 22:30:08	2025-06-26 22:30:08	119/62	95	100.0	96	81	Quae quam velit. Debitis fuga aperiam maiores voluptatem.	In quisquam nostrum molestiae facere cupiditate laboriosam expedita ad commodi.	2025-07-21	Pariatur nostrum aliquam libero harum corrupti.	2025-07-04	14:15	3	pending	APT10212	\N
9214	390	10	2025-07-04 16:15:00	Back Pain	Emergency	A repellat nisi provident.	2025-06-26 22:30:08	2025-06-26 22:30:08	139/90	97	99.7	99	72	Eius explicabo est velit.	Repellat dolores dignissimos optio ad recusandae molestiae totam dolore necessitatibus veritatis.	2025-07-16	Placeat laborum nobis hic quas aspernatur ipsum.	2025-07-04	16:15	3	pending	APT10213	\N
9215	346	6	2025-07-04 14:45:00	Diabetes Check	Follow-up	Eligendi fuga quaerat voluptatibus animi suscipit.	2025-06-26 22:30:08	2025-06-26 22:30:08	115/63	90	99.1	95	67	Quidem laborum facilis minima deserunt minus inventore.	Consectetur modi reprehenderit accusamus doloremque odit maiores quo laborum ducimus.	2025-07-18	Doloremque odio veritatis doloribus unde vitae.	2025-07-04	14:45	3	pending	APT10214	\N
9216	293	6	2025-07-04 15:00:00	Cough	Follow-up	Itaque soluta voluptatem occaecati nam.	2025-06-26 22:30:08	2025-06-26 22:30:08	111/83	71	98.0	98	63	Nisi repellendus ea sed delectus aliquam.	Saepe hic iste ipsa suscipit sint ut dolores.	2025-07-17	A vel similique.	2025-07-04	15:00	3	pending	APT10215	\N
9217	89	8	2025-07-04 11:00:00	Cough	Follow-up	Atque asperiores eos in ratione a asperiores.	2025-06-26 22:30:08	2025-06-26 22:30:08	135/90	91	98.6	95	56	Rem ea optio. Vitae repellendus eum quaerat.	Ipsa dolor delectus fugiat eveniet ipsam commodi non cum laboriosam.	2025-07-31	Porro possimus quis voluptates itaque hic vitae.	2025-07-04	11:00	3	pending	APT10216	\N
9218	53	4	2025-07-04 14:30:00	High BP	Emergency	Numquam sed alias quidem earum occaecati id veniam.	2025-06-26 22:30:08	2025-06-26 22:30:08	122/64	92	100.1	96	55	Est unde voluptas repellat porro illum.	Amet inventore vero at provident sit eaque voluptate sed.	2025-07-12	Odio laudantium distinctio distinctio laborum delectus at repellat.	2025-07-04	14:30	3	pending	APT10217	\N
9219	437	6	2025-07-04 16:00:00	Fever	Emergency	Amet a quia commodi eaque quasi.	2025-06-26 22:30:08	2025-06-26 22:30:08	128/61	73	98.4	96	82	Voluptates ut recusandae veritatis animi asperiores.	Debitis non sit illo nesciunt.	2025-07-15	Atque laudantium laborum impedit dolor repudiandae dolorum.	2025-07-04	16:00	3	pending	APT10218	\N
9220	180	6	2025-07-04 11:15:00	Diabetes Check	New	Quibusdam expedita illum eos eveniet eum pariatur.	2025-06-26 22:30:08	2025-06-26 22:30:08	119/89	81	98.6	100	80	Cupiditate culpa sequi eum eaque nostrum.	Dolorum sunt aspernatur aut aliquid occaecati repellat exercitationem corporis dolorem.	2025-07-23	Ipsam nobis quis maiores.	2025-07-04	11:15	3	pending	APT10219	\N
9221	293	3	2025-07-04 11:30:00	Headache	Follow-up	Animi itaque perferendis.	2025-06-26 22:30:08	2025-06-26 22:30:08	123/69	95	99.8	97	68	Itaque modi repellendus fugiat aliquid fuga.	Atque quae unde praesentium eum voluptates.	2025-07-24	Quo placeat cupiditate fugit laborum.	2025-07-04	11:30	3	pending	APT10220	\N
9222	369	10	2025-07-04 14:45:00	High BP	Follow-up	Quibusdam praesentium corporis nihil accusamus ad vel explicabo.	2025-06-26 22:30:08	2025-06-26 22:30:08	109/76	98	100.0	98	66	Tenetur et minima velit delectus dolore.	Tempora eveniet ab repellat atque illum sapiente quia assumenda ea.	2025-07-21	Inventore at quam aperiam ipsam dicta.	2025-07-04	14:45	3	pending	APT10221	\N
9223	148	4	2025-07-04 15:15:00	Back Pain	Follow-up	Nobis architecto nulla doloribus.	2025-06-26 22:30:08	2025-06-26 22:30:08	125/77	100	100.0	100	60	Maiores atque officia numquam rem veniam.	Rerum nisi similique odio ipsa architecto.	2025-07-20	Doloremque unde eum temporibus ex minima.	2025-07-04	15:15	3	pending	APT10222	\N
9224	492	10	2025-07-04 12:45:00	Back Pain	Follow-up	Voluptatibus expedita aspernatur nihil optio.	2025-06-26 22:30:08	2025-06-26 22:30:08	111/67	96	98.8	99	61	Accusantium voluptatum atque minus occaecati esse ipsa.	Atque magnam beatae ab sed quos maiores reprehenderit.	2025-08-01	Nemo dolores saepe magnam nulla magnam.	2025-07-04	12:45	3	pending	APT10223	\N
9225	233	5	2025-07-04 13:30:00	High BP	OPD	Autem totam distinctio praesentium provident.	2025-06-26 22:30:08	2025-06-26 22:30:08	105/72	77	99.3	99	60	Distinctio minima fugiat.	Possimus ullam mollitia illo debitis blanditiis voluptatum aut dolores.	2025-07-20	Et quibusdam accusamus officia eaque dolorum soluta.	2025-07-04	13:30	3	pending	APT10224	\N
9226	113	5	2025-07-05 13:45:00	Skin Rash	Follow-up	Neque modi dolorem animi quos officia suscipit.	2025-06-26 22:30:08	2025-06-26 22:30:08	117/88	99	100.2	95	67	Eligendi exercitationem excepturi iure nemo distinctio.	Dolore consequuntur consequuntur deserunt deserunt tenetur hic laboriosam.	2025-07-24	Perferendis libero laboriosam error voluptatibus maxime magnam consequuntur.	2025-07-05	13:45	3	pending	APT10225	\N
9227	356	8	2025-07-05 15:45:00	Fever	Follow-up	Aspernatur dolorum illum laboriosam rerum deserunt debitis.	2025-06-26 22:30:08	2025-06-26 22:30:08	114/77	83	99.0	98	81	Provident architecto totam consequatur nihil.	Nobis alias non voluptatem veniam unde tenetur maiores.	2025-07-13	Ducimus labore aperiam optio repellendus.	2025-07-05	15:45	3	pending	APT10226	\N
9229	208	7	2025-07-05 16:45:00	Back Pain	Emergency	Animi inventore sit laboriosam.	2025-06-26 22:30:08	2025-06-26 22:30:08	107/77	95	98.4	95	63	Nesciunt mollitia odit aspernatur.	Iusto expedita laboriosam totam eos ut fugiat libero facilis porro atque.	2025-07-17	Inventore rerum amet similique.	2025-07-05	16:45	3	pending	APT10228	\N
9230	338	8	2025-07-05 13:00:00	Headache	Follow-up	Accusantium minus dignissimos.	2025-06-26 22:30:08	2025-06-26 22:30:08	126/82	96	98.1	100	75	Numquam rem aut error eligendi cupiditate repellat.	Voluptas ipsa quae quia numquam praesentium voluptate consectetur.	2025-08-02	Quaerat impedit ducimus molestias reiciendis.	2025-07-05	13:00	3	pending	APT10229	\N
9231	189	9	2025-07-05 14:30:00	Diabetes Check	Follow-up	Quidem consectetur nemo.	2025-06-26 22:30:08	2025-06-26 22:30:08	138/62	91	98.8	99	59	Non neque numquam corporis consequuntur.	Similique at cumque blanditiis adipisci laudantium unde occaecati recusandae.	2025-07-13	Occaecati totam temporibus optio.	2025-07-05	14:30	3	pending	APT10230	\N
9232	427	9	2025-07-05 14:00:00	Fever	Emergency	Harum iure et harum consequuntur.	2025-06-26 22:30:08	2025-06-26 22:30:08	116/62	81	100.3	99	75	Ut asperiores minima architecto natus perspiciatis.	Quos explicabo dolore harum vitae explicabo adipisci debitis eligendi cupiditate.	2025-07-28	Sapiente quo adipisci.	2025-07-05	14:00	3	pending	APT10231	\N
9233	28	9	2025-07-05 13:30:00	Skin Rash	OPD	Expedita laboriosam praesentium tempore debitis molestias laboriosam.	2025-06-26 22:30:08	2025-06-26 22:30:08	101/85	65	98.6	100	74	Tempore repudiandae odio quibusdam placeat consectetur quo.	Atque temporibus saepe hic recusandae impedit quos ratione sit.	2025-07-22	Ipsam minima quisquam culpa mollitia exercitationem.	2025-07-05	13:30	3	pending	APT10232	\N
9234	292	4	2025-07-05 14:45:00	Cough	Follow-up	Laborum tenetur in atque.	2025-06-26 22:30:08	2025-06-26 22:30:08	103/69	85	97.6	95	55	Eveniet adipisci tempore. Nam magni quis ipsam delectus.	Ex corporis quod sunt asperiores suscipit asperiores.	2025-07-21	Quaerat nemo nulla temporibus provident quos occaecati.	2025-07-05	14:45	3	pending	APT10233	\N
9236	416	7	2025-07-05 11:45:00	Cough	Emergency	Sequi ad reiciendis inventore animi.	2025-06-26 22:30:08	2025-06-26 22:30:08	102/79	72	99.8	100	57	Animi provident voluptas nisi. Quas qui nam.	Aperiam aut nobis veniam in tempora.	2025-08-01	Consequatur inventore doloremque soluta placeat veritatis.	2025-07-05	11:45	3	pending	APT10235	\N
9237	181	7	2025-07-05 14:30:00	Back Pain	Follow-up	Dolor adipisci fuga quia aut impedit.	2025-06-26 22:30:08	2025-06-26 22:30:08	128/88	66	98.7	98	60	Accusamus neque dignissimos eos quaerat.	Ipsam quam accusamus temporibus dolor recusandae.	2025-07-29	Odio earum asperiores.	2025-07-05	14:30	3	pending	APT10236	\N
9238	215	10	2025-07-05 15:00:00	Fever	Follow-up	Cum distinctio facilis eius illo doloremque est.	2025-06-26 22:30:08	2025-06-26 22:30:08	140/71	71	98.8	100	76	Error pariatur placeat cupiditate cupiditate.	Esse voluptatum nostrum soluta quod similique velit ullam laborum eaque explicabo.	2025-07-24	Deserunt minima molestiae.	2025-07-05	15:00	3	pending	APT10237	\N
9239	94	4	2025-07-05 15:15:00	Fever	New	Libero quo deleniti velit explicabo magnam.	2025-06-26 22:30:08	2025-06-26 22:30:08	123/84	94	97.5	95	64	Aperiam assumenda ipsam repellat est odio.	Iusto excepturi saepe voluptates sed magnam.	2025-07-23	Aliquid rem culpa dolor et sed.	2025-07-05	15:15	3	pending	APT10238	\N
9240	333	10	2025-07-05 11:30:00	High BP	Emergency	Sit eos provident quas.	2025-06-26 22:30:08	2025-06-26 22:30:08	119/61	72	98.4	99	76	Officiis atque dolorum nisi recusandae consequatur.	Nam voluptate consequuntur vel magnam id quibusdam cum unde.	2025-07-24	Quasi recusandae facere reiciendis.	2025-07-05	11:30	3	pending	APT10239	\N
9241	13	7	2025-07-05 13:15:00	Skin Rash	OPD	Quas cupiditate quis non.	2025-06-26 22:30:08	2025-06-26 22:30:08	105/73	93	99.2	98	64	Placeat esse fuga reiciendis a repudiandae ea.	Quibusdam maiores provident minima iste illo vel voluptatem distinctio.	2025-07-29	Perspiciatis impedit occaecati consequuntur.	2025-07-05	13:15	3	pending	APT10240	\N
9242	65	3	2025-07-05 15:15:00	High BP	New	Explicabo illum quia laudantium iure molestias.	2025-06-26 22:30:08	2025-06-26 22:30:08	129/73	69	99.1	97	58	Dicta vel iusto aperiam fugiat.	Minus vel ut hic consectetur reprehenderit ex alias sit.	2025-07-20	Eos magni fuga distinctio laudantium temporibus explicabo ex.	2025-07-05	15:15	3	pending	APT10241	\N
9243	271	5	2025-07-05 15:45:00	Skin Rash	Follow-up	Itaque harum omnis hic veniam necessitatibus.	2025-06-26 22:30:08	2025-06-26 22:30:08	100/88	80	97.9	99	55	Accusantium enim totam ullam.	Inventore explicabo neque libero laboriosam enim.	2025-07-21	Voluptas vel culpa.	2025-07-05	15:45	3	pending	APT10242	\N
9244	326	4	2025-07-05 13:00:00	Back Pain	OPD	Iure dicta natus accusantium.	2025-06-26 22:30:08	2025-06-26 22:30:08	134/78	68	97.6	96	71	Dolorum laborum ullam natus illum expedita necessitatibus.	Numquam nobis aspernatur blanditiis ipsum laudantium in ut.	2025-07-31	Corporis perspiciatis eius voluptate incidunt.	2025-07-05	13:00	3	pending	APT10243	\N
9245	38	6	2025-07-05 16:30:00	Diabetes Check	New	Dolorem nisi non enim temporibus distinctio provident.	2025-06-26 22:30:08	2025-06-26 22:30:08	135/73	79	100.0	97	78	Praesentium corporis doloribus corporis.	Minus quo aspernatur rerum dolores voluptatum illo amet.	2025-07-21	A necessitatibus ipsam culpa nesciunt id.	2025-07-05	16:30	3	pending	APT10244	\N
9246	433	4	2025-07-05 14:45:00	Back Pain	New	Provident minima id harum doloribus sunt eaque.	2025-06-26 22:30:08	2025-06-26 22:30:08	127/67	87	99.6	100	63	Facilis similique alias atque ratione.	Perspiciatis aliquam fugiat minima iusto omnis.	2025-08-03	Iure repudiandae eligendi ipsam delectus.	2025-07-05	14:45	3	pending	APT10245	\N
9247	390	3	2025-07-05 13:30:00	Routine Checkup	New	Facere corrupti vel dolor debitis impedit aperiam.	2025-06-26 22:30:08	2025-06-26 22:30:08	102/68	86	98.2	95	76	Placeat nostrum tenetur nobis.	Ipsa ut dolorum laudantium.	2025-07-12	Minus error doloremque atque doloremque.	2025-07-05	13:30	3	pending	APT10246	\N
11005	507	4	2025-07-06T12:00:00	S	procedure	S	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-07-06	12:00	3	scheduled	APT-20250703-004	video
9248	399	7	2025-07-05 15:15:00	Back Pain	OPD	Distinctio amet cum fugiat magnam molestiae laboriosam.	2025-06-26 22:30:08	2025-06-26 22:30:08	111/60	95	97.7	96	61	Aliquid quod earum illum vero optio aperiam.	Aliquam nostrum repellat sint laborum vel minima est voluptate sunt.	2025-07-27	Dolor dignissimos non perspiciatis unde autem.	2025-07-05	15:15	3	pending	APT10247	\N
9249	144	7	2025-07-05 12:15:00	Headache	OPD	Quos corrupti numquam nostrum est similique.	2025-06-26 22:30:08	2025-06-26 22:30:08	100/74	95	100.1	98	58	Officia sint quam cum. Maiores maxime sed nihil.	Repellat possimus dolorem commodi rerum veniam consequuntur molestiae ratione.	2025-08-02	Quod laborum praesentium qui rerum earum.	2025-07-05	12:15	3	pending	APT10248	\N
9250	413	7	2025-07-05 16:00:00	Diabetes Check	Follow-up	Distinctio libero maiores itaque tempore.	2025-06-26 22:30:08	2025-06-26 22:30:08	129/68	89	99.1	96	81	Autem perspiciatis accusamus ipsum provident praesentium.	Dolores provident ut praesentium nemo soluta.	2025-08-02	Ea incidunt dicta excepturi debitis rerum.	2025-07-05	16:00	3	pending	APT10249	\N
9251	36	3	2025-07-05 16:15:00	Diabetes Check	OPD	Eos iusto assumenda officia quidem at necessitatibus.	2025-06-26 22:30:08	2025-06-26 22:30:08	118/78	100	99.0	98	73	Laborum magnam adipisci recusandae occaecati sit.	Iste ducimus ex reprehenderit animi eius delectus dolore.	2025-07-31	Adipisci porro quia dolore.	2025-07-05	16:15	3	pending	APT10250	\N
9252	497	4	2025-07-05 13:00:00	Routine Checkup	Emergency	Animi distinctio ullam.	2025-06-26 22:30:08	2025-06-26 22:30:08	105/76	81	98.4	97	63	Ex provident nulla doloremque.	Harum amet laboriosam velit qui excepturi possimus nisi.	2025-07-15	Accusantium reprehenderit sed sint quaerat dolorem similique.	2025-07-05	13:00	3	pending	APT10251	\N
9253	347	4	2025-07-06 16:15:00	Headache	Follow-up	Quam odio itaque voluptate amet.	2025-06-26 22:30:08	2025-06-26 22:30:08	121/65	87	100.0	97	65	Ex nihil facere quae.	Commodi asperiores vel iusto suscipit magnam tempora pariatur.	2025-07-28	Reprehenderit quo qui consequatur minima.	2025-07-06	16:15	3	pending	APT10252	\N
9254	405	7	2025-07-06 13:00:00	Cough	Emergency	Maxime quis omnis quos doloremque enim.	2025-06-26 22:30:08	2025-06-26 22:30:08	132/65	66	100.2	100	70	Delectus excepturi eos fugit numquam eaque quaerat fuga.	Odio architecto occaecati ratione consequuntur distinctio officiis molestias.	2025-08-02	Eum perspiciatis quis magni mollitia deleniti consequuntur.	2025-07-06	13:00	3	pending	APT10253	\N
9255	3	6	2025-07-06 16:15:00	Diabetes Check	Follow-up	Eos tenetur dolorum ducimus maiores ut assumenda.	2025-06-26 22:30:08	2025-06-26 22:30:08	115/74	79	98.6	95	83	Excepturi officiis dolorem eaque dolorum.	Veritatis veniam dicta sapiente laudantium delectus quas veritatis.	2025-08-02	Eius voluptates reprehenderit magni necessitatibus quaerat amet.	2025-07-06	16:15	3	pending	APT10254	\N
9256	333	9	2025-07-06 13:00:00	Back Pain	New	Est rem architecto est.	2025-06-26 22:30:08	2025-06-26 22:30:08	124/84	71	100.0	98	57	Consectetur in nam aliquam quasi qui.	Blanditiis debitis sit architecto numquam alias maxime laboriosam pariatur veniam reiciendis.	2025-07-14	Officia hic repudiandae molestias rem.	2025-07-06	13:00	3	pending	APT10255	\N
9257	497	7	2025-07-06 15:45:00	High BP	Follow-up	Beatae nisi vitae temporibus hic non soluta.	2025-06-26 22:30:08	2025-06-26 22:30:08	118/78	79	100.4	95	61	Amet facere veritatis optio tempore officia.	Libero at totam molestiae odit corrupti illum sint magnam illum.	2025-07-25	A veniam sequi iusto quasi nesciunt in.	2025-07-06	15:45	3	pending	APT10256	\N
9258	330	7	2025-07-06 12:15:00	Back Pain	OPD	Aperiam voluptatem dolorum repellat odio sunt.	2025-06-26 22:30:08	2025-06-26 22:30:08	109/87	74	98.9	98	65	Eveniet doloremque laudantium cum voluptas.	Consectetur enim sunt esse aspernatur et voluptas nisi eius deserunt.	2025-07-26	Aliquid debitis ad autem nisi.	2025-07-06	12:15	3	pending	APT10257	\N
9259	55	3	2025-07-06 16:45:00	Skin Rash	OPD	Nemo ullam labore quos.	2025-06-26 22:30:08	2025-06-26 22:30:08	121/63	90	98.6	99	78	Doloremque aliquid libero corporis explicabo.	Molestiae sed dicta iusto ex doloremque quia.	2025-08-03	Aliquid deleniti id nihil eaque.	2025-07-06	16:45	3	pending	APT10258	\N
9260	391	9	2025-07-06 14:30:00	High BP	Follow-up	Explicabo rerum odit aliquam facere nihil.	2025-06-26 22:30:08	2025-06-26 22:30:08	135/78	66	98.0	95	82	Dolores odio labore vitae laborum blanditiis aliquid.	Sint architecto perferendis non et.	2025-07-30	Nobis consectetur laboriosam.	2025-07-06	14:30	3	pending	APT10259	\N
9261	393	5	2025-07-06 11:15:00	Diabetes Check	Follow-up	Cupiditate sit error.	2025-06-26 22:30:08	2025-06-26 22:30:08	139/74	74	98.6	99	64	Laborum mollitia minus aperiam.	Iusto temporibus perspiciatis soluta reiciendis dolore possimus ipsam sed.	2025-07-25	Dignissimos enim nesciunt iure fugiat ea eligendi.	2025-07-06	11:15	3	pending	APT10260	\N
9262	465	7	2025-07-06 13:45:00	Back Pain	Follow-up	Corrupti nobis voluptatem doloremque consectetur vitae.	2025-06-26 22:30:08	2025-06-26 22:30:08	115/88	66	98.6	99	71	Neque at ab occaecati aspernatur.	Quod doloremque totam illo aliquid vitae sit.	2025-08-02	Harum rem ipsa voluptates aliquam consequuntur rerum.	2025-07-06	13:45	3	pending	APT10261	\N
9263	134	7	2025-07-06 16:15:00	High BP	OPD	Nulla delectus qui libero libero sequi odit.	2025-06-26 22:30:08	2025-06-26 22:30:08	114/68	70	100.5	100	57	Nemo nobis nihil fugit quos aspernatur.	Adipisci enim necessitatibus perferendis eos id explicabo numquam aliquid.	2025-08-03	Necessitatibus necessitatibus totam aperiam ea placeat tenetur.	2025-07-06	16:15	3	pending	APT10262	\N
9264	190	7	2025-07-06 15:30:00	Cough	OPD	Natus quis quas nisi deserunt.	2025-06-26 22:30:08	2025-06-26 22:30:08	135/78	78	99.2	98	76	Possimus impedit pariatur non ullam aperiam maxime.	Nobis impedit iste quasi cumque.	2025-07-15	Illo nostrum quos pariatur quasi.	2025-07-06	15:30	3	pending	APT10263	\N
9265	276	8	2025-07-06 15:00:00	Fever	New	Tenetur consectetur totam animi magnam adipisci voluptate.	2025-06-26 22:30:08	2025-06-26 22:30:08	116/77	79	97.8	95	56	Molestias debitis odit at quod officia.	Rerum ab pariatur maxime in.	2025-07-31	Dolores voluptates repellat blanditiis aperiam nemo.	2025-07-06	15:00	3	pending	APT10264	\N
9266	359	6	2025-07-06 15:30:00	Back Pain	New	Soluta quisquam deleniti nam perspiciatis ea praesentium.	2025-06-26 22:30:08	2025-06-26 22:30:08	127/76	93	98.6	99	71	Illo distinctio hic aliquid nemo unde.	Blanditiis tempore odio voluptate vero tempore molestias.	2025-07-13	Dolore commodi eum ab accusantium corporis laboriosam.	2025-07-06	15:30	3	pending	APT10265	\N
9267	416	7	2025-07-06 12:00:00	Routine Checkup	Emergency	Commodi tenetur quos.	2025-06-26 22:30:08	2025-06-26 22:30:08	105/68	99	99.0	96	85	Sunt dolorem vel illo animi mollitia iure.	Eligendi quae eum laboriosam tempora perferendis fugiat.	2025-07-26	Quia accusamus commodi.	2025-07-06	12:00	3	pending	APT10266	\N
9268	456	6	2025-07-06 16:45:00	Fever	Follow-up	Inventore accusamus accusamus eos ipsum nobis voluptate.	2025-06-26 22:30:08	2025-06-26 22:30:08	104/71	80	97.8	97	78	Beatae nesciunt harum voluptas.	Quod amet blanditiis asperiores earum reiciendis impedit hic.	2025-07-26	Blanditiis suscipit sint.	2025-07-06	16:45	3	pending	APT10267	\N
9269	378	9	2025-07-06 16:00:00	Fever	OPD	Quod animi sunt ipsum saepe.	2025-06-26 22:30:08	2025-06-26 22:30:08	119/73	74	100.0	99	69	Incidunt alias dicta corporis labore nisi quibusdam.	Repellat in eligendi nesciunt aspernatur laboriosam.	2025-08-01	Illum ipsa sint.	2025-07-06	16:00	3	pending	APT10268	\N
11006	2	3	2025-07-15T13:55Z	\N	followup	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-07-15	13:55	3	pending	APT-20250703-005	\N
9270	74	9	2025-07-06 14:15:00	Skin Rash	New	Dicta dicta architecto ipsam.	2025-06-26 22:30:08	2025-06-26 22:30:08	105/64	93	98.1	99	68	Nisi facere explicabo harum voluptatibus ad repellat a.	Fugit doloribus repellendus dolore modi natus ex ea sit a eius.	2025-07-31	Et labore dolor sunt nobis doloribus ipsam.	2025-07-06	14:15	3	pending	APT10269	\N
9271	143	4	2025-07-06 11:00:00	Fever	OPD	Mollitia nesciunt sint ullam.	2025-06-26 22:30:08	2025-06-26 22:30:08	131/64	70	99.7	97	71	Consequuntur nobis eum temporibus est eos.	Commodi eaque minus quasi soluta id.	2025-08-03	Perferendis facere ut similique amet.	2025-07-06	11:00	3	pending	APT10270	\N
9272	442	6	2025-07-06 16:15:00	Routine Checkup	OPD	Earum rem ducimus beatae tenetur.	2025-06-26 22:30:08	2025-06-26 22:30:08	112/76	91	98.1	97	71	Dolor odio dolores magnam labore accusamus.	Dolorum reprehenderit eaque earum eligendi consequuntur laboriosam dolorum.	2025-08-01	Distinctio animi nisi nulla perferendis quas hic.	2025-07-06	16:15	3	pending	APT10271	\N
9273	276	5	2025-07-06 15:15:00	Fever	OPD	Veniam labore eius repellat.	2025-06-26 22:30:08	2025-06-26 22:30:08	126/73	94	99.9	97	71	Voluptatem corporis nihil nobis.	Ipsum amet aliquam laborum aspernatur est.	2025-08-04	Necessitatibus ipsum beatae omnis aperiam inventore.	2025-07-06	15:15	3	pending	APT10272	\N
9274	7	4	2025-07-06 11:45:00	Skin Rash	Emergency	A placeat vitae assumenda.	2025-06-26 22:30:08	2025-06-26 22:30:08	139/88	87	100.4	96	64	Soluta cupiditate totam incidunt dicta.	Placeat tenetur cumque culpa voluptatum beatae.	2025-07-21	Soluta qui fugiat incidunt est asperiores.	2025-07-06	11:45	3	pending	APT10273	\N
9275	469	5	2025-07-06 12:30:00	Fever	Follow-up	Facere maxime deserunt illo nemo.	2025-06-26 22:30:08	2025-06-26 22:30:08	129/71	90	98.5	100	81	Maxime odit perspiciatis minus inventore.	Fugit a numquam nobis cumque impedit ex sit soluta commodi.	2025-07-19	Cumque eius magni aut veniam eius.	2025-07-06	12:30	3	pending	APT10274	\N
9276	67	7	2025-07-06 15:30:00	Skin Rash	Emergency	Esse voluptate totam occaecati.	2025-06-26 22:30:08	2025-06-26 22:30:08	135/80	76	99.0	100	57	Quos veniam tempore enim ea.	Eaque dignissimos perspiciatis autem laudantium placeat in.	2025-07-25	Aut vel tempore quam facere minus eveniet esse.	2025-07-06	15:30	3	pending	APT10275	\N
9277	119	6	2025-07-06 16:30:00	High BP	Follow-up	Voluptas rerum quod excepturi facere sed.	2025-06-26 22:30:08	2025-06-26 22:30:08	112/64	75	98.8	98	64	Vel voluptates illum maiores rerum. Eius repudiandae quod.	Voluptates consectetur laudantium ab illo fuga placeat officiis eos.	2025-08-05	Nihil id minima quam.	2025-07-06	16:30	3	pending	APT10276	\N
9278	351	10	2025-07-06 15:15:00	Skin Rash	Emergency	Repudiandae natus exercitationem doloribus.	2025-06-26 22:30:08	2025-06-26 22:30:08	107/69	94	98.1	100	78	Consequuntur delectus voluptas quia reprehenderit.	Distinctio dolor culpa nostrum distinctio ipsam fugit repellat natus eaque.	2025-08-03	Incidunt deleniti quis hic.	2025-07-06	15:15	3	pending	APT10277	\N
9279	184	10	2025-07-06 11:00:00	Routine Checkup	OPD	Alias beatae animi dolorem tempore.	2025-06-26 22:30:08	2025-06-26 22:30:08	111/75	84	99.9	97	66	Maxime et debitis quasi in.	Exercitationem quae odit consectetur quasi quo iure atque.	2025-07-26	Reiciendis eveniet temporibus nemo corrupti distinctio asperiores.	2025-07-06	11:00	3	pending	APT10278	\N
9280	355	6	2025-07-06 15:30:00	High BP	New	Quo veritatis reprehenderit amet rem minus.	2025-06-26 22:30:08	2025-06-26 22:30:08	106/84	77	99.4	98	69	Nostrum tempore neque error.	Nesciunt tempore possimus illum reiciendis assumenda enim repellendus.	2025-07-20	Natus soluta debitis consequatur itaque.	2025-07-06	15:30	3	pending	APT10279	\N
9281	449	9	2025-07-06 16:45:00	Fever	OPD	Debitis facilis aspernatur cumque officia.	2025-06-26 22:30:08	2025-06-26 22:30:08	108/60	71	99.8	100	59	Ipsum autem voluptatem dolore nobis.	Assumenda animi ab velit hic ratione praesentium quas cum.	2025-07-14	Tempora commodi occaecati assumenda reiciendis.	2025-07-06	16:45	3	pending	APT10280	\N
9282	109	8	2025-07-06 12:15:00	High BP	Emergency	Laudantium minima aperiam placeat molestias deleniti.	2025-06-26 22:30:08	2025-06-26 22:30:08	119/80	87	98.4	100	80	Laboriosam dignissimos repellat at aperiam inventore.	Vel nobis ab saepe aliquam veritatis voluptatum iste.	2025-08-02	Sed molestias facere eos.	2025-07-06	12:15	3	pending	APT10281	\N
9283	46	8	2025-07-07 15:00:00	Fever	Follow-up	Accusantium eius tempora numquam.	2025-06-26 22:30:08	2025-06-26 22:30:08	139/63	72	99.9	96	67	Fuga repellat quo. Error in tempore esse.	Cum possimus aperiam in provident esse quisquam voluptatibus ea.	2025-07-17	Accusamus nihil magnam praesentium.	2025-07-07	15:00	3	pending	APT10282	\N
9284	392	6	2025-07-07 14:15:00	Fever	OPD	Perspiciatis commodi velit voluptas eveniet.	2025-06-26 22:30:08	2025-06-26 22:30:08	116/74	69	100.3	100	63	Dolorum blanditiis minima inventore quos omnis porro.	Tempore aspernatur totam in repellendus et natus quos.	2025-07-23	Odit dicta dolor sit libero quas.	2025-07-07	14:15	3	pending	APT10283	\N
9285	124	3	2025-07-07 13:00:00	High BP	New	Debitis animi reprehenderit totam.	2025-06-26 22:30:08	2025-06-26 22:30:08	108/84	65	98.8	97	72	Ad odit tenetur facilis harum.	Enim eius libero facilis hic fugiat laborum.	2025-07-23	Eius nesciunt reprehenderit quod.	2025-07-07	13:00	3	pending	APT10284	\N
9286	261	8	2025-07-07 16:45:00	High BP	New	Quo perferendis nesciunt praesentium quibusdam.	2025-06-26 22:30:08	2025-06-26 22:30:08	104/71	76	98.2	99	74	Autem odit rem eius temporibus. At sunt quam cumque magnam.	Deleniti mollitia exercitationem inventore praesentium.	2025-07-14	Perferendis autem dicta ducimus.	2025-07-07	16:45	3	pending	APT10285	\N
9287	296	3	2025-07-07 13:30:00	Routine Checkup	Follow-up	Ad velit id placeat.	2025-06-26 22:30:08	2025-06-26 22:30:08	120/74	80	98.2	97	78	Provident minima exercitationem rerum.	Quas repellendus incidunt cumque sapiente odio numquam placeat.	2025-07-26	Quisquam error non iusto.	2025-07-07	13:30	3	pending	APT10286	\N
9288	309	6	2025-07-07 12:00:00	Routine Checkup	OPD	Blanditiis a impedit ipsum.	2025-06-26 22:30:08	2025-06-26 22:30:08	123/60	83	99.9	99	61	Exercitationem ipsam aspernatur quidem.	Iusto praesentium amet explicabo atque consectetur dicta.	2025-08-01	Odio ipsa alias laboriosam dolorum rerum.	2025-07-07	12:00	3	pending	APT10287	\N
9289	288	9	2025-07-07 13:45:00	Fever	New	Temporibus architecto fugit.	2025-06-26 22:30:08	2025-06-26 22:30:08	136/81	100	99.8	95	59	Facilis autem tempora architecto aut vel.	Sequi maxime sed officia deserunt repellat mollitia tenetur.	2025-07-18	Ratione ratione laboriosam debitis tempora.	2025-07-07	13:45	3	pending	APT10288	\N
9290	315	7	2025-07-07 12:30:00	Skin Rash	OPD	Eligendi ullam a nostrum repudiandae nesciunt.	2025-06-26 22:30:08	2025-06-26 22:30:08	129/90	98	97.6	99	55	Quod architecto rerum consequatur debitis.	Nisi pariatur architecto quaerat nulla.	2025-07-24	Doloremque dolor ipsa voluptatum.	2025-07-07	12:30	3	pending	APT10289	\N
9291	116	6	2025-07-07 12:00:00	Skin Rash	New	Debitis ipsum facere.	2025-06-26 22:30:08	2025-06-26 22:30:08	125/66	89	97.8	96	83	Ad distinctio quam dolore tempora.	Delectus sequi cumque amet aperiam perspiciatis.	2025-07-27	Recusandae vero ratione asperiores nesciunt.	2025-07-07	12:00	3	pending	APT10290	\N
9292	306	8	2025-07-07 14:00:00	Back Pain	Emergency	Voluptate vel quia animi aut assumenda.	2025-06-26 22:30:08	2025-06-26 22:30:08	140/77	71	98.9	100	66	Eius laudantium officia deleniti nobis ipsam.	At molestias quas fuga tenetur eaque accusamus dignissimos.	2025-07-27	Molestiae recusandae voluptas labore architecto commodi veritatis.	2025-07-07	14:00	3	pending	APT10291	\N
11007	2	3	2025-07-05T11:30Z	\N	emergency	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-07-05	11:30	3	pending	APT-20250705-001	\N
9293	314	7	2025-07-07 14:45:00	High BP	Emergency	Adipisci ea commodi alias earum recusandae.	2025-06-26 22:30:08	2025-06-26 22:30:08	110/61	87	99.6	95	75	Dignissimos eligendi nisi explicabo in quidem quasi.	Deleniti corporis iure amet ab.	2025-07-17	Perferendis quo commodi molestiae beatae eligendi officiis ratione.	2025-07-07	14:45	3	pending	APT10292	\N
9294	387	9	2025-07-07 15:00:00	Cough	New	Ut cupiditate debitis nihil mollitia incidunt.	2025-06-26 22:30:08	2025-06-26 22:30:08	103/64	76	97.7	95	59	Exercitationem incidunt beatae sapiente modi.	Magnam a eos harum inventore eveniet animi commodi iusto aliquid.	2025-07-22	Vitae minima illo qui.	2025-07-07	15:00	3	pending	APT10293	\N
9295	318	4	2025-07-07 15:45:00	Cough	OPD	Nemo optio quisquam distinctio harum voluptatum.	2025-06-26 22:30:08	2025-06-26 22:30:08	133/72	68	99.0	100	63	Quasi voluptate quam assumenda illum excepturi delectus.	Recusandae tempore provident voluptas dolorum non itaque.	2025-07-21	Deleniti odit beatae provident.	2025-07-07	15:45	3	pending	APT10294	\N
9296	64	6	2025-07-07 12:15:00	Routine Checkup	Emergency	Ut quis expedita magni perferendis inventore.	2025-06-26 22:30:08	2025-06-26 22:30:08	126/73	79	97.7	96	85	In libero neque velit. Dolor eos dicta sequi.	Commodi et nam reiciendis debitis qui.	2025-07-22	Labore ad nisi qui repudiandae optio sunt quos.	2025-07-07	12:15	3	pending	APT10295	\N
9297	310	10	2025-07-07 12:30:00	High BP	Emergency	Atque inventore unde consequatur sapiente quia similique.	2025-06-26 22:30:08	2025-06-26 22:30:08	114/82	75	99.2	97	55	Cum sit ad ut.	Accusantium tempore maiores ab sint.	2025-07-23	In exercitationem aut ullam pariatur.	2025-07-07	12:30	3	pending	APT10296	\N
9298	372	6	2025-07-07 12:15:00	Skin Rash	New	Eius odio eius a nulla exercitationem.	2025-06-26 22:30:08	2025-06-26 22:30:08	126/90	80	98.1	99	84	Perspiciatis libero illum quasi quasi iure quos quidem.	Commodi ea pariatur totam culpa possimus eveniet exercitationem totam odit.	2025-08-03	Aperiam quo error nulla nobis ullam.	2025-07-07	12:15	3	pending	APT10297	\N
9299	280	6	2025-07-07 14:15:00	High BP	Follow-up	Voluptates aut laudantium iste.	2025-06-26 22:30:08	2025-06-26 22:30:08	106/72	73	98.3	98	63	Vitae corrupti expedita saepe consequatur.	At modi odio culpa dicta iure accusamus accusamus illo.	2025-08-02	Voluptatibus magnam earum vitae officiis ipsam numquam quae.	2025-07-07	14:15	3	pending	APT10298	\N
9300	366	4	2025-07-07 13:45:00	Cough	Follow-up	Iste explicabo unde laudantium architecto.	2025-06-26 22:30:08	2025-06-26 22:30:08	126/69	84	100.2	100	66	Laboriosam expedita esse neque deserunt est ullam.	Sed labore quisquam ipsum dolore asperiores.	2025-07-26	Ipsam voluptatem similique nostrum.	2025-07-07	13:45	3	pending	APT10299	\N
9301	11	8	2025-07-07 15:00:00	Headache	OPD	Aspernatur iure iusto voluptas eos perferendis.	2025-06-26 22:30:08	2025-06-26 22:30:08	107/82	95	97.7	99	55	Reprehenderit id a. Inventore sapiente a natus.	Voluptatibus quas deserunt totam corrupti excepturi.	2025-08-02	Facilis ea cum animi voluptate ab similique.	2025-07-07	15:00	3	pending	APT10300	\N
9302	334	8	2025-07-07 11:00:00	Routine Checkup	OPD	Ullam vitae numquam.	2025-06-26 22:30:08	2025-06-26 22:30:08	119/69	71	97.8	95	61	Voluptate facilis laudantium ipsum autem.	Ut delectus occaecati natus quis tempora.	2025-07-22	Corrupti laudantium deserunt nobis nihil.	2025-07-07	11:00	3	pending	APT10301	\N
9303	74	6	2025-07-07 14:30:00	Fever	Follow-up	Pariatur deleniti vel qui incidunt.	2025-06-26 22:30:08	2025-06-26 22:30:08	129/87	100	99.2	98	84	Rem dolore cupiditate aut totam esse inventore.	Eligendi culpa tempore autem amet in veritatis nostrum impedit ipsam exercitationem.	2025-08-04	Repudiandae velit accusamus tenetur quia.	2025-07-07	14:30	3	pending	APT10302	\N
9304	153	7	2025-07-07 11:15:00	Back Pain	Emergency	Corporis nemo laborum.	2025-06-26 22:30:08	2025-06-26 22:30:08	140/70	75	98.9	96	66	Vel at dolorem corrupti hic corrupti.	Debitis suscipit nostrum molestiae optio laudantium repudiandae.	2025-07-24	Porro quas incidunt similique velit.	2025-07-07	11:15	3	pending	APT10303	\N
9305	173	3	2025-07-07 14:00:00	Skin Rash	Emergency	Ut impedit assumenda modi.	2025-06-26 22:30:08	2025-06-26 22:30:08	108/69	96	100.5	98	61	Perferendis enim ut. Veniam suscipit aliquid.	Maxime a magni reprehenderit consequuntur blanditiis praesentium esse possimus.	2025-07-26	Officiis harum est accusantium quo error consequuntur.	2025-07-07	14:00	3	pending	APT10304	\N
9306	175	10	2025-07-07 13:15:00	Headache	New	Saepe fugit architecto earum ipsum.	2025-06-26 22:30:08	2025-06-26 22:30:08	132/75	68	99.9	96	55	Ipsa tempora quasi accusantium maxime sunt.	Esse eaque illum eligendi deleniti facere libero recusandae aliquid est illum.	2025-07-25	Eligendi corrupti porro deleniti mollitia porro dolore assumenda.	2025-07-07	13:15	3	pending	APT10305	\N
9307	442	10	2025-07-08 15:30:00	Headache	New	Dolores fugiat possimus veritatis amet.	2025-06-26 22:30:08	2025-06-26 22:30:08	107/86	88	99.4	95	69	Voluptate veritatis a architecto facilis dolor.	Tempore nesciunt accusamus harum molestiae recusandae sapiente voluptate dignissimos.	2025-07-17	Aspernatur rem aperiam accusamus.	2025-07-08	15:30	3	pending	APT10306	\N
9308	200	4	2025-07-08 14:30:00	Diabetes Check	Emergency	Quidem ad ullam distinctio soluta tenetur.	2025-06-26 22:30:08	2025-06-26 22:30:08	137/71	81	99.4	100	79	Ullam molestiae sed mollitia omnis earum maxime.	Dolorum laudantium iste vel praesentium.	2025-07-24	Temporibus commodi dolorem iste officiis quos.	2025-07-08	14:30	3	pending	APT10307	\N
9309	204	3	2025-07-08 12:45:00	High BP	OPD	Ipsam fuga praesentium officiis consequuntur.	2025-06-26 22:30:08	2025-06-26 22:30:08	105/80	88	100.3	100	68	Nemo reprehenderit eligendi molestiae eveniet.	Cum libero iure qui in distinctio.	2025-07-28	Eveniet dignissimos numquam.	2025-07-08	12:45	3	pending	APT10308	\N
9310	23	10	2025-07-08 13:15:00	Back Pain	OPD	Eligendi totam eaque eum perferendis.	2025-06-26 22:30:08	2025-06-26 22:30:08	119/74	89	97.6	98	62	Impedit labore ipsum sint tempora.	Rem accusamus asperiores maxime magnam quia.	2025-07-23	Harum nemo nemo odit velit.	2025-07-08	13:15	3	pending	APT10309	\N
9311	191	4	2025-07-08 11:30:00	High BP	New	Perspiciatis nihil culpa perferendis voluptatibus voluptates accusantium.	2025-06-26 22:30:08	2025-06-26 22:30:08	123/66	95	98.5	96	78	Nobis placeat hic facere nobis hic impedit doloremque.	Quae voluptatibus exercitationem blanditiis repellat in facere eaque illo harum.	2025-07-22	Adipisci illum nobis quas ipsa.	2025-07-08	11:30	3	pending	APT10310	\N
9312	30	5	2025-07-08 11:00:00	Back Pain	New	Unde laudantium eveniet suscipit voluptate commodi quod.	2025-06-26 22:30:08	2025-06-26 22:30:08	128/61	94	100.5	99	81	Officiis quo corporis quia excepturi perspiciatis impedit.	Occaecati expedita ea atque quo unde perferendis animi dicta nihil.	2025-07-23	Eaque ut quam veritatis vitae pariatur quasi.	2025-07-08	11:00	3	pending	APT10311	\N
9313	361	5	2025-07-08 12:15:00	Skin Rash	New	Consectetur accusantium molestiae quam odit.	2025-06-26 22:30:08	2025-06-26 22:30:08	114/70	91	98.1	99	70	Perspiciatis aliquid at tempora molestias vitae.	Animi ipsa nostrum soluta laborum officiis culpa sequi itaque provident.	2025-07-18	Provident temporibus aliquam modi incidunt possimus.	2025-07-08	12:15	3	pending	APT10312	\N
9314	236	5	2025-07-08 11:45:00	Cough	Follow-up	Sed blanditiis numquam dicta accusamus.	2025-06-26 22:30:08	2025-06-26 22:30:08	103/82	70	99.8	96	63	Odio libero rerum dignissimos ipsa ea.	Repudiandae fuga eaque quam consequuntur.	2025-07-26	Perferendis incidunt animi vero.	2025-07-08	11:45	3	pending	APT10313	\N
11008	2	3	2025-07-05T11:45Z	\N	regular	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-07-05	11:45	3	pending	APT-20250705-002	\N
9315	327	6	2025-07-08 14:15:00	Fever	Follow-up	Sapiente consectetur ipsa ea perferendis.	2025-06-26 22:30:08	2025-06-26 22:30:08	117/65	77	100.4	98	66	Sapiente maxime voluptate perspiciatis at in unde.	Placeat iusto provident libero porro non deleniti voluptatum.	2025-07-31	Quaerat libero nam quos.	2025-07-08	14:15	3	pending	APT10314	\N
9316	300	5	2025-07-08 15:45:00	Back Pain	Follow-up	Natus quae ipsam illo optio.	2025-06-26 22:30:08	2025-06-26 22:30:08	138/88	90	98.0	100	85	Ut perspiciatis soluta libero pariatur recusandae ipsum.	Aliquid ad voluptatum laborum cumque.	2025-07-28	A aspernatur incidunt repellendus itaque nostrum atque neque.	2025-07-08	15:45	3	pending	APT10315	\N
9317	133	5	2025-07-08 15:45:00	Skin Rash	New	Voluptatum recusandae assumenda provident.	2025-06-26 22:30:08	2025-06-26 22:30:08	135/63	92	98.9	96	61	Fugiat quaerat nemo quibusdam autem distinctio.	Cumque eveniet sapiente error sint.	2025-07-26	Animi minus tempore doloribus illum incidunt debitis excepturi.	2025-07-08	15:45	3	pending	APT10316	\N
9318	90	3	2025-07-08 13:45:00	Routine Checkup	New	Cumque quae repellendus nesciunt aperiam impedit.	2025-06-26 22:30:08	2025-06-26 22:30:08	128/72	78	99.3	97	55	Expedita quia quos dolore facilis.	Assumenda illo magnam nisi tempora eligendi.	2025-08-02	Necessitatibus expedita id dicta architecto.	2025-07-08	13:45	3	pending	APT10317	\N
9319	240	10	2025-07-08 15:30:00	Diabetes Check	OPD	Id tempore quas ea.	2025-06-26 22:30:08	2025-06-26 22:30:08	140/70	71	97.6	100	83	Odit neque eius laudantium.	Quam possimus perspiciatis porro debitis.	2025-07-25	Mollitia itaque id veniam nam ratione nulla.	2025-07-08	15:30	3	pending	APT10318	\N
9320	493	3	2025-07-08 11:45:00	Headache	OPD	Fuga delectus ducimus.	2025-06-26 22:30:08	2025-06-26 22:30:08	114/86	68	98.8	100	79	Odio laboriosam ex vero neque ratione adipisci.	Vel repellendus dignissimos exercitationem natus.	2025-07-29	Incidunt aperiam saepe sint.	2025-07-08	11:45	3	pending	APT10319	\N
9321	401	9	2025-07-08 13:15:00	Cough	Follow-up	Dolores earum totam officia consequuntur minima.	2025-06-26 22:30:08	2025-06-26 22:30:08	137/74	68	97.8	98	73	Libero modi libero eaque vel quam commodi.	Similique ex laborum accusamus illo porro.	2025-07-28	Aliquam ex quos magni eos eveniet nulla.	2025-07-08	13:15	3	pending	APT10320	\N
9322	183	7	2025-07-08 16:45:00	Skin Rash	Emergency	Dicta quam facere accusantium.	2025-06-26 22:30:08	2025-06-26 22:30:08	137/76	100	97.7	100	65	Dolores natus magni voluptatum quos itaque voluptate.	Corporis mollitia labore magni necessitatibus numquam soluta reprehenderit nisi dolores.	2025-08-04	Amet explicabo magnam.	2025-07-08	16:45	3	pending	APT10321	\N
9323	408	8	2025-07-08 16:15:00	Diabetes Check	Follow-up	Quas provident dolorum tempore minima quos.	2025-06-26 22:30:08	2025-06-26 22:30:08	139/61	84	100.2	100	59	Vero at fugiat dolor eveniet velit.	Porro aliquid quas vitae id.	2025-07-17	Dolorum quam nostrum repellendus.	2025-07-08	16:15	3	pending	APT10322	\N
9324	61	4	2025-07-08 16:15:00	Cough	New	Illo voluptates dignissimos atque impedit.	2025-06-26 22:30:08	2025-06-26 22:30:08	121/88	85	98.1	97	74	Eos cupiditate animi natus.	Optio aut tempore necessitatibus nesciunt id voluptate.	2025-07-31	Earum fugit fugiat perspiciatis.	2025-07-08	16:15	3	pending	APT10323	\N
9325	52	6	2025-07-08 14:00:00	High BP	Follow-up	Aspernatur impedit ipsum.	2025-06-26 22:30:08	2025-06-26 22:30:08	131/88	91	100.3	95	65	Nobis voluptatibus quaerat minima pariatur.	Amet minima voluptate dolore ipsa temporibus enim quia atque doloremque.	2025-07-18	Facere animi blanditiis dolor in.	2025-07-08	14:00	3	pending	APT10324	\N
9326	335	6	2025-07-08 13:45:00	Diabetes Check	Emergency	Architecto provident soluta id doloremque distinctio temporibus.	2025-06-26 22:30:08	2025-06-26 22:30:08	103/61	75	98.3	98	84	Voluptatem sit occaecati aperiam consequatur.	Porro temporibus animi vero sunt fugiat suscipit architecto deleniti perferendis.	2025-07-27	Occaecati voluptas at fugit eligendi reprehenderit.	2025-07-08	13:45	3	pending	APT10325	\N
9327	96	7	2025-07-08 15:45:00	Headache	OPD	Id veniam praesentium possimus commodi accusantium ex quibusdam.	2025-06-26 22:30:08	2025-06-26 22:30:08	124/68	81	98.7	100	56	Delectus nam accusamus magni praesentium dicta.	Asperiores nostrum pariatur nostrum fuga aspernatur quas quasi ullam.	2025-07-21	Autem possimus incidunt illo.	2025-07-08	15:45	3	pending	APT10326	\N
9328	472	5	2025-07-08 16:30:00	Routine Checkup	OPD	Autem impedit dignissimos.	2025-06-26 22:30:08	2025-06-26 22:30:08	122/62	79	99.1	97	55	Deleniti modi aliquam nisi eum debitis.	Placeat adipisci recusandae sed temporibus minus deserunt eveniet enim est.	2025-07-26	Provident reiciendis sapiente ducimus veritatis.	2025-07-08	16:30	3	pending	APT10327	\N
9329	486	8	2025-07-08 11:15:00	Diabetes Check	OPD	Cupiditate occaecati debitis rem.	2025-06-26 22:30:08	2025-06-26 22:30:08	137/67	84	98.1	96	85	Aspernatur alias deserunt illo hic.	Pariatur minus voluptatum placeat debitis.	2025-07-30	Asperiores quis in quod assumenda est.	2025-07-08	11:15	3	pending	APT10328	\N
9330	409	7	2025-07-08 11:45:00	Headache	New	Inventore aperiam fugit placeat nostrum a non.	2025-06-26 22:30:08	2025-06-26 22:30:08	127/69	76	99.4	95	58	Iusto harum eligendi occaecati. Vitae earum commodi.	Quae minima eveniet maxime in id officia nulla nisi.	2025-07-31	Ut quos accusamus quam.	2025-07-08	11:45	3	pending	APT10329	\N
9331	242	5	2025-07-08 16:00:00	Diabetes Check	OPD	Quos dignissimos fuga pariatur repudiandae est accusamus ducimus.	2025-06-26 22:30:08	2025-06-26 22:30:08	127/60	90	99.2	98	79	Vel corrupti unde maxime laudantium.	Sunt iusto repellat animi porro.	2025-07-28	Unde dicta vitae veniam.	2025-07-08	16:00	3	pending	APT10330	\N
9332	86	8	2025-07-08 15:00:00	Diabetes Check	Follow-up	Consequatur repudiandae deleniti.	2025-06-26 22:30:08	2025-06-26 22:30:08	140/79	65	98.3	98	68	Ratione provident architecto aperiam ea unde.	Alias a maxime deserunt enim nulla.	2025-08-01	Laborum quia optio esse debitis vitae.	2025-07-08	15:00	3	pending	APT10331	\N
9333	235	10	2025-07-08 16:15:00	Back Pain	OPD	Quasi voluptate sapiente nobis velit facilis.	2025-06-26 22:30:08	2025-06-26 22:30:08	111/62	79	98.6	97	71	Alias dicta nihil. Debitis odio dolor aperiam.	Ipsam non occaecati magnam ad ab repellendus.	2025-07-22	Similique iste quae aut id quisquam.	2025-07-08	16:15	3	pending	APT10332	\N
9334	85	7	2025-07-08 15:15:00	Skin Rash	Emergency	Consequuntur vero id cum aliquid qui eum.	2025-06-26 22:30:08	2025-06-26 22:30:08	127/68	100	99.6	97	72	Fugit qui voluptatem minima.	Laborum dicta sunt vero odio earum.	2025-07-21	Facilis laboriosam veritatis odio nemo.	2025-07-08	15:15	3	pending	APT10333	\N
9335	267	9	2025-07-08 16:45:00	Diabetes Check	New	Nam possimus reprehenderit est nesciunt maiores pariatur.	2025-06-26 22:30:08	2025-06-26 22:30:08	131/69	71	99.2	99	67	Quis repellat molestias accusamus dolores magni ea libero.	Earum id in magni adipisci deserunt magnam voluptatum in.	2025-07-30	Mollitia reiciendis dolores.	2025-07-08	16:45	3	pending	APT10334	\N
9336	74	7	2025-07-08 14:30:00	Routine Checkup	New	Ratione velit assumenda magnam saepe.	2025-06-26 22:30:08	2025-06-26 22:30:08	139/84	83	99.8	100	56	Quos quos eum.	Qui aliquid modi reprehenderit consequuntur quae porro.	2025-07-31	A consequuntur deserunt culpa.	2025-07-08	14:30	3	pending	APT10335	\N
9337	212	9	2025-07-09 12:30:00	Routine Checkup	Emergency	Quaerat sed temporibus nam accusantium doloremque atque velit.	2025-06-26 22:30:08	2025-06-26 22:30:08	102/88	98	98.8	95	60	Enim officiis nihil autem excepturi expedita aspernatur.	Assumenda reiciendis quia inventore quo saepe.	2025-07-19	Perspiciatis consectetur in temporibus quisquam.	2025-07-09	12:30	3	pending	APT10336	\N
9338	173	3	2025-07-09 12:45:00	Back Pain	New	Rem adipisci tempore exercitationem aspernatur.	2025-06-26 22:30:08	2025-06-26 22:30:08	127/60	70	99.0	98	65	Quidem est at ipsa rerum. Sed ratione ipsum.	Quas nam odio architecto debitis occaecati nemo atque porro doloremque.	2025-08-02	Quae doloremque a molestiae.	2025-07-09	12:45	3	pending	APT10337	\N
9339	15	9	2025-07-09 14:00:00	Routine Checkup	New	Non molestias asperiores.	2025-06-26 22:30:08	2025-06-26 22:30:08	108/79	96	98.6	95	61	Officiis in minima architecto ipsum.	Sit numquam eius provident minima veritatis perspiciatis.	2025-07-16	Adipisci dolorem similique totam possimus.	2025-07-09	14:00	3	pending	APT10338	\N
9340	185	7	2025-07-09 15:45:00	Routine Checkup	OPD	Culpa iste sequi quam.	2025-06-26 22:30:08	2025-06-26 22:30:08	115/65	84	97.5	96	64	Officiis nihil voluptatibus quae.	Assumenda ea molestias nobis temporibus ratione distinctio corrupti.	2025-07-25	Repellat labore quibusdam eaque deleniti deserunt quas deleniti.	2025-07-09	15:45	3	pending	APT10339	\N
9341	144	4	2025-07-09 12:30:00	Routine Checkup	New	Incidunt magnam alias quibusdam ut.	2025-06-26 22:30:08	2025-06-26 22:30:08	135/66	74	98.4	99	60	Eligendi aliquam quam.	Rem non veritatis praesentium aspernatur enim ut expedita.	2025-07-17	Sapiente aliquid iste maiores omnis officia earum doloremque.	2025-07-09	12:30	3	pending	APT10340	\N
9342	361	3	2025-07-09 13:45:00	Back Pain	Follow-up	Quo distinctio voluptates occaecati maxime provident.	2025-06-26 22:30:08	2025-06-26 22:30:08	112/71	78	99.9	99	55	Iste nulla neque tempore est commodi.	Earum architecto in quisquam aut dicta tempore neque.	2025-07-27	Culpa possimus expedita voluptatem labore atque laboriosam.	2025-07-09	13:45	3	pending	APT10341	\N
9343	239	6	2025-07-09 14:30:00	High BP	New	Aliquam ut tenetur repellendus.	2025-06-26 22:30:08	2025-06-26 22:30:08	101/67	73	99.7	98	64	Nobis est voluptates earum et officiis.	Repudiandae quis quod illo numquam eum perferendis excepturi.	2025-08-07	Tempora unde aliquid voluptas cumque vero quibusdam.	2025-07-09	14:30	3	pending	APT10342	\N
9344	406	5	2025-07-09 13:45:00	Routine Checkup	New	Esse ratione cum odio optio.	2025-06-26 22:30:08	2025-06-26 22:30:08	131/70	94	99.5	100	74	Est consectetur sint est labore doloremque.	Voluptas aperiam vitae adipisci accusantium minima consequatur.	2025-08-04	Facere pariatur totam repudiandae dolores.	2025-07-09	13:45	3	pending	APT10343	\N
9345	273	10	2025-07-09 11:30:00	Skin Rash	Follow-up	Illo hic quo sequi vero consequatur iusto.	2025-06-26 22:30:08	2025-06-26 22:30:08	120/84	79	98.6	95	61	Vel quas expedita consequatur.	Voluptas odio asperiores impedit ab pariatur esse qui temporibus.	2025-08-03	Odit suscipit quisquam.	2025-07-09	11:30	3	pending	APT10344	\N
9346	352	4	2025-07-09 13:00:00	Back Pain	Emergency	Nemo corrupti a quia neque.	2025-06-26 22:30:08	2025-06-26 22:30:08	128/85	71	98.0	96	74	Accusamus ducimus odit in.	Laboriosam eos recusandae sapiente quos perferendis molestias adipisci rerum tenetur.	2025-08-01	Nam quo iusto unde.	2025-07-09	13:00	3	pending	APT10345	\N
9347	244	10	2025-07-09 11:15:00	Routine Checkup	Follow-up	Facilis libero porro ullam incidunt sit.	2025-06-26 22:30:08	2025-06-26 22:30:08	135/69	69	100.3	97	78	Aliquam tenetur sit sed deserunt fuga.	Expedita excepturi natus in omnis a nobis velit voluptatem animi.	2025-07-26	Optio magni eveniet nisi deleniti.	2025-07-09	11:15	3	pending	APT10346	\N
9348	341	3	2025-07-09 11:00:00	Diabetes Check	Emergency	Nisi fugit beatae.	2025-06-26 22:30:08	2025-06-26 22:30:08	121/67	83	99.2	96	66	Eaque illo eum recusandae ullam ullam ipsam.	Autem rerum iusto natus quaerat.	2025-08-06	Illo sit iusto voluptatum velit omnis ipsam.	2025-07-09	11:00	3	pending	APT10347	\N
9349	312	8	2025-07-09 16:00:00	High BP	New	In pariatur iure doloremque consequuntur.	2025-06-26 22:30:08	2025-06-26 22:30:08	103/67	79	98.2	100	67	Occaecati voluptate neque sint exercitationem voluptate.	Illo nobis tenetur ducimus rerum.	2025-08-01	Cum maiores aliquid cum qui nihil ducimus ut.	2025-07-09	16:00	3	pending	APT10348	\N
9350	437	10	2025-07-09 15:45:00	Diabetes Check	Follow-up	Autem consectetur illum eius provident expedita laudantium.	2025-06-26 22:30:08	2025-06-26 22:30:08	129/82	72	100.3	96	74	Similique quasi veritatis ex dolores. Et optio distinctio.	Voluptas molestias sequi exercitationem sunt voluptas aliquid.	2025-07-27	Nemo dolores corporis fugit aliquam necessitatibus dignissimos sapiente.	2025-07-09	15:45	3	pending	APT10349	\N
9351	435	10	2025-07-09 12:15:00	High BP	Follow-up	Consequatur accusantium porro.	2025-06-26 22:30:08	2025-06-26 22:30:08	107/66	81	100.2	99	60	Assumenda molestias modi eius nesciunt optio reiciendis.	Reiciendis natus maiores ea ut ab possimus voluptatum quos magnam.	2025-07-29	A aperiam voluptatibus ad quisquam.	2025-07-09	12:15	3	pending	APT10350	\N
9352	43	10	2025-07-09 14:15:00	Routine Checkup	Follow-up	Minima consequatur praesentium velit maxime.	2025-06-26 22:30:08	2025-06-26 22:30:08	103/69	70	99.8	97	62	Vitae quod itaque libero accusamus amet dolores.	Recusandae ex similique porro vel.	2025-08-02	Necessitatibus expedita tenetur.	2025-07-09	14:15	3	pending	APT10351	\N
9353	463	7	2025-07-09 16:15:00	Routine Checkup	New	Consequatur fugit itaque assumenda officiis aliquid.	2025-06-26 22:30:08	2025-06-26 22:30:08	130/81	65	100.4	99	58	Sint nulla quas perferendis inventore ad.	Provident et fugiat voluptatibus fugit omnis itaque.	2025-07-30	Fuga recusandae inventore.	2025-07-09	16:15	3	pending	APT10352	\N
9354	175	6	2025-07-09 13:00:00	Cough	New	Laborum exercitationem eligendi omnis dolor culpa voluptatem reprehenderit.	2025-06-26 22:30:08	2025-06-26 22:30:08	124/83	89	100.4	96	66	Asperiores praesentium accusantium voluptatibus.	Dolorem optio odit veniam tempore nostrum.	2025-07-20	Fugiat voluptas accusamus praesentium debitis ut.	2025-07-09	13:00	3	pending	APT10353	\N
9355	279	4	2025-07-09 14:15:00	Cough	New	Neque modi totam assumenda omnis animi.	2025-06-26 22:30:08	2025-06-26 22:30:08	139/77	89	99.2	99	70	Totam quia at tempora sit velit fugit.	Quibusdam hic voluptate nemo expedita voluptatum ipsum voluptate reiciendis qui.	2025-08-08	Exercitationem suscipit delectus esse.	2025-07-09	14:15	3	pending	APT10354	\N
9356	161	10	2025-07-09 11:30:00	Fever	OPD	Alias aperiam eos ab.	2025-06-26 22:30:08	2025-06-26 22:30:08	119/90	99	98.3	95	69	Error veritatis quo minima accusamus ea est debitis.	Eaque commodi vero laudantium autem adipisci sit quibusdam sapiente.	2025-08-04	Dolorem veritatis optio culpa modi aliquid nulla.	2025-07-09	11:30	3	pending	APT10355	\N
9357	302	5	2025-07-09 15:30:00	Headache	Follow-up	Vero qui esse.	2025-06-26 22:30:08	2025-06-26 22:30:08	114/89	86	98.5	100	60	Enim cumque consequatur ad asperiores officia debitis.	Error veritatis nam laboriosam libero aut vero iure.	2025-07-20	Voluptas numquam sunt sed iure.	2025-07-09	15:30	3	pending	APT10356	\N
9358	440	9	2025-07-09 14:00:00	Fever	New	Sequi earum neque maxime illum.	2025-06-26 22:30:08	2025-06-26 22:30:08	119/66	71	98.6	95	62	Ullam quaerat quam saepe in eos architecto.	Laboriosam ab quo adipisci recusandae porro.	2025-08-02	Pariatur recusandae ipsam delectus voluptatem.	2025-07-09	14:00	3	pending	APT10357	\N
9359	53	6	2025-07-09 13:00:00	High BP	OPD	Mollitia esse quas repellat quod.	2025-06-26 22:30:08	2025-06-26 22:30:08	121/70	80	99.0	100	74	Eaque harum repellat quis veritatis exercitationem.	Voluptas magnam voluptatibus ut vitae blanditiis.	2025-08-04	Rem deserunt quos.	2025-07-09	13:00	3	pending	APT10358	\N
11009	507	4	2025-07-06T12:30:00	Ferve	emergency	feve	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-07-06	12:30	3	scheduled	APT-20250705-003	offline
9360	29	7	2025-07-09 12:00:00	Fever	New	Mollitia assumenda mollitia nostrum incidunt praesentium architecto.	2025-06-26 22:30:08	2025-06-26 22:30:08	102/87	93	99.2	95	79	Dolorum quia magnam doloribus quod veritatis molestiae.	Quo asperiores saepe consequatur error modi labore.	2025-08-08	Natus nam iusto nostrum pariatur eum.	2025-07-09	12:00	3	pending	APT10359	\N
9361	455	3	2025-07-10 13:00:00	Cough	Emergency	Ea quisquam facere officiis recusandae illum voluptates.	2025-06-26 22:30:08	2025-06-26 22:30:08	123/84	82	97.8	95	72	Accusamus enim dicta vel nulla.	Dicta cumque sed quis saepe ut facilis aliquam dicta.	2025-08-09	A laborum mollitia corrupti eius.	2025-07-10	13:00	3	pending	APT10360	\N
9362	438	6	2025-07-10 14:15:00	High BP	OPD	Culpa alias iste inventore non corrupti voluptatum.	2025-06-26 22:30:08	2025-06-26 22:30:08	115/73	92	97.8	100	71	Recusandae cumque nobis accusamus cum.	Iste optio molestias alias veniam quaerat tempora nisi illum.	2025-08-02	Expedita porro nostrum nisi optio qui.	2025-07-10	14:15	3	pending	APT10361	\N
9363	152	7	2025-07-10 15:15:00	Fever	Emergency	Recusandae magnam consequatur quam odit qui eveniet.	2025-06-26 22:30:08	2025-06-26 22:30:08	135/87	69	99.7	97	75	Laudantium fugit fugit recusandae ullam.	Non placeat recusandae exercitationem asperiores beatae vero eaque laudantium at fugit.	2025-08-04	Provident natus minima quia iste repellat.	2025-07-10	15:15	3	pending	APT10362	\N
9364	458	9	2025-07-10 11:00:00	Fever	New	Aut accusantium sint similique.	2025-06-26 22:30:08	2025-06-26 22:30:08	109/72	67	100.0	100	74	Neque dolorem animi quo est dolorem.	At incidunt soluta exercitationem quia.	2025-07-22	Velit voluptates cupiditate eaque nisi.	2025-07-10	11:00	3	pending	APT10363	\N
9365	91	7	2025-07-10 13:00:00	Routine Checkup	Follow-up	Corporis explicabo numquam est.	2025-06-26 22:30:08	2025-06-26 22:30:08	140/62	94	100.1	99	59	Iusto inventore exercitationem totam.	Repellat cumque totam at nam perspiciatis praesentium eaque facilis quo.	2025-07-24	Exercitationem vero ea ab laudantium nulla.	2025-07-10	13:00	3	pending	APT10364	\N
9366	225	9	2025-07-10 16:30:00	Diabetes Check	OPD	Necessitatibus reprehenderit quibusdam suscipit quis perspiciatis quia provident.	2025-06-26 22:30:08	2025-06-26 22:30:08	139/88	100	100.4	95	66	Fugit dolor voluptatum error.	Possimus repellendus eum soluta maxime aut laborum.	2025-07-18	Ullam provident consequuntur doloremque nostrum error explicabo itaque.	2025-07-10	16:30	3	pending	APT10365	\N
9367	210	9	2025-07-10 11:45:00	Fever	Follow-up	Libero numquam rem animi.	2025-06-26 22:30:08	2025-06-26 22:30:08	124/60	80	99.5	96	71	Assumenda ut molestiae ut in voluptates.	Eaque velit cupiditate nobis dolorum delectus.	2025-07-27	Perspiciatis eaque consectetur praesentium non minus quod.	2025-07-10	11:45	3	pending	APT10366	\N
9368	135	10	2025-07-10 14:00:00	Back Pain	Follow-up	Dignissimos iste ratione maiores numquam magni doloremque.	2025-06-26 22:30:08	2025-06-26 22:30:08	115/64	83	99.8	100	55	Quae distinctio illo enim soluta ad omnis.	Recusandae cumque officiis tempora quas temporibus nihil laudantium.	2025-07-23	Sed assumenda error tempora possimus possimus.	2025-07-10	14:00	3	pending	APT10367	\N
9369	377	5	2025-07-10 16:30:00	Fever	OPD	Unde fuga tempora sapiente repudiandae tenetur.	2025-06-26 22:30:08	2025-06-26 22:30:08	130/74	71	98.2	99	73	Quam nesciunt inventore quos dolorum maxime ea.	Asperiores facere fuga esse placeat consequuntur fugit id possimus.	2025-08-02	Nihil soluta est ea molestias voluptatibus molestiae ad.	2025-07-10	16:30	3	pending	APT10368	\N
9370	465	4	2025-07-10 13:15:00	Fever	New	Ullam magnam nam nulla tempora.	2025-06-26 22:30:08	2025-06-26 22:30:08	124/68	90	98.9	97	72	Quasi consectetur consectetur vel.	Aliquid laboriosam ducimus ex occaecati facilis.	2025-08-04	Beatae maxime sit neque odit suscipit a.	2025-07-10	13:15	3	pending	APT10369	\N
9371	299	6	2025-07-10 14:00:00	Back Pain	Follow-up	Dolore quisquam dolorum impedit adipisci.	2025-06-26 22:30:08	2025-06-26 22:30:08	107/60	99	100.3	97	60	Odit laborum enim libero. Veritatis debitis autem libero.	Earum eum molestias eligendi repellat velit rem.	2025-07-17	Qui magni architecto saepe voluptatum laboriosam aperiam.	2025-07-10	14:00	3	pending	APT10370	\N
9372	438	6	2025-07-10 12:15:00	Skin Rash	OPD	At non esse unde exercitationem quasi voluptatibus.	2025-06-26 22:30:08	2025-06-26 22:30:08	112/60	92	100.4	97	81	Iste sed incidunt impedit quae.	Ipsum unde laboriosam inventore quo nostrum doloribus harum vel.	2025-07-30	At consequuntur ullam necessitatibus sed at excepturi repellendus.	2025-07-10	12:15	3	pending	APT10371	\N
9373	470	9	2025-07-10 16:45:00	Routine Checkup	Emergency	Aliquam et reiciendis earum quo molestiae inventore.	2025-06-26 22:30:08	2025-06-26 22:30:08	126/60	100	98.7	95	75	Vero molestias sunt qui consectetur optio neque aliquam.	Eligendi eaque facilis veniam voluptatem vel.	2025-07-17	Inventore veritatis harum deleniti quas deleniti.	2025-07-10	16:45	3	pending	APT10372	\N
9374	286	8	2025-07-10 12:00:00	Fever	OPD	Cupiditate doloremque sint perspiciatis tenetur.	2025-06-26 22:30:08	2025-06-26 22:30:08	128/90	79	98.6	100	71	Cum nobis molestiae ipsum illum nesciunt.	Optio ducimus explicabo illo molestias.	2025-07-30	Commodi harum cumque praesentium assumenda repellendus dolores.	2025-07-10	12:00	3	pending	APT10373	\N
9375	315	10	2025-07-10 13:15:00	Diabetes Check	Follow-up	Magnam iusto unde architecto.	2025-06-26 22:30:08	2025-06-26 22:30:08	117/89	99	98.1	100	76	Modi eligendi molestias nostrum debitis.	Excepturi quisquam odio placeat impedit illum numquam consequatur laboriosam rerum.	2025-07-20	Illum eveniet similique dolorem.	2025-07-10	13:15	3	pending	APT10374	\N
9376	262	5	2025-07-10 16:45:00	Cough	Follow-up	Praesentium in quaerat molestiae.	2025-06-26 22:30:08	2025-06-26 22:30:08	124/78	78	98.4	98	66	Repudiandae provident doloribus tempora esse.	Ullam dolorem corrupti iste fugit adipisci iste a perspiciatis.	2025-07-29	Itaque nam perferendis repellat suscipit tempore maiores.	2025-07-10	16:45	3	pending	APT10375	\N
9377	236	8	2025-07-10 16:00:00	Routine Checkup	New	Ipsam exercitationem ullam animi animi at eligendi.	2025-06-26 22:30:08	2025-06-26 22:30:08	140/77	78	99.3	97	71	Dicta nam nihil quam hic ea doloribus.	Nostrum repellendus corrupti maxime velit eaque eaque expedita vero optio.	2025-07-30	Quas blanditiis quod pariatur.	2025-07-10	16:00	3	pending	APT10376	\N
9378	283	7	2025-07-10 15:30:00	Routine Checkup	Follow-up	Nisi perferendis non error sunt doloremque voluptatibus.	2025-06-26 22:30:08	2025-06-26 22:30:08	101/86	80	98.4	99	67	Sapiente temporibus dolorum.	Reprehenderit quod quibusdam magni tempore adipisci iure quidem.	2025-07-26	Est quia sunt modi.	2025-07-10	15:30	3	pending	APT10377	\N
9379	106	9	2025-07-10 16:00:00	Diabetes Check	New	Atque dignissimos quis ea.	2025-06-26 22:30:08	2025-06-26 22:30:08	101/60	98	97.7	96	71	Sint quod amet beatae dolorum asperiores.	Nisi laudantium error minima ad assumenda nam aperiam alias nulla.	2025-07-18	Autem dolor incidunt officiis voluptatem laborum.	2025-07-10	16:00	3	pending	APT10378	\N
9380	316	4	2025-07-10 14:30:00	High BP	OPD	Voluptates quae modi asperiores temporibus facere.	2025-06-26 22:30:08	2025-06-26 22:30:08	132/89	67	97.9	98	61	Quam voluptatibus labore voluptas dolor neque perferendis.	Provident sunt nemo velit quos esse corporis.	2025-08-09	Quod quo saepe dolorum.	2025-07-10	14:30	3	pending	APT10379	\N
9381	106	10	2025-07-10 16:30:00	Fever	Emergency	Deleniti esse ex earum.	2025-06-26 22:30:08	2025-06-26 22:30:08	140/74	95	99.8	96	62	Sed tempore voluptatum ipsum exercitationem tenetur dolore.	Nulla ipsam laboriosam molestias consectetur consequatur.	2025-07-23	Vero adipisci occaecati illo inventore.	2025-07-10	16:30	3	pending	APT10380	\N
9382	232	5	2025-07-10 11:30:00	Fever	OPD	Quaerat voluptas adipisci aliquid.	2025-06-26 22:30:08	2025-06-26 22:30:08	139/80	78	99.1	96	65	Magnam quas pariatur ut.	Dolorem quam saepe dolore fuga nesciunt ut voluptas.	2025-07-24	Eius suscipit ad eaque explicabo.	2025-07-10	11:30	3	pending	APT10381	\N
9383	275	10	2025-07-10 15:30:00	High BP	OPD	Id pariatur odio.	2025-06-26 22:30:08	2025-06-26 22:30:08	111/72	84	99.8	98	73	Officia doloribus quo repellat.	Nemo debitis voluptates iusto sit eius necessitatibus eius nisi quasi.	2025-08-03	Fuga sunt optio quidem deserunt deserunt adipisci.	2025-07-10	15:30	3	pending	APT10382	\N
9384	470	6	2025-07-10 16:15:00	High BP	OPD	Necessitatibus quasi dolorem maiores.	2025-06-26 22:30:08	2025-06-26 22:30:08	124/64	71	97.6	100	56	Nostrum assumenda minima magnam quos.	Neque corporis vel totam sunt nemo tenetur.	2025-07-21	Dolorum earum provident pariatur.	2025-07-10	16:15	3	pending	APT10383	\N
9385	268	9	2025-07-10 16:00:00	High BP	OPD	Nostrum voluptatem quae praesentium debitis voluptates delectus.	2025-06-26 22:30:08	2025-06-26 22:30:08	135/89	84	97.7	100	79	Id molestias incidunt quia.	Ullam sint placeat ipsa a.	2025-07-28	Alias repellendus molestias repudiandae quibusdam.	2025-07-10	16:00	3	pending	APT10384	\N
9386	48	5	2025-07-10 12:15:00	Headache	Emergency	Magnam dolore asperiores eveniet numquam maiores aliquam.	2025-06-26 22:30:08	2025-06-26 22:30:08	128/74	83	100.3	100	69	Occaecati distinctio minima voluptatibus illum.	Accusamus nemo inventore fugit quo officia doloremque odit reprehenderit.	2025-08-08	Dicta nemo ab animi vel a non.	2025-07-10	12:15	3	pending	APT10385	\N
9387	252	10	2025-07-10 13:15:00	Cough	New	Facere illo occaecati repellat.	2025-06-26 22:30:08	2025-06-26 22:30:08	123/79	68	99.1	96	56	Facilis nisi illo illum.	Nihil rerum nihil tempora ipsa cum.	2025-08-09	Alias voluptates hic doloremque.	2025-07-10	13:15	3	pending	APT10386	\N
9388	282	4	2025-07-10 15:30:00	High BP	Emergency	Perferendis ratione eos officiis corrupti dignissimos.	2025-06-26 22:30:08	2025-06-26 22:30:08	104/69	71	100.3	96	77	Eos suscipit cum.	Debitis nesciunt eaque amet debitis sunt.	2025-07-31	Laudantium adipisci consectetur sapiente facere.	2025-07-10	15:30	3	pending	APT10387	\N
9389	242	3	2025-07-10 14:45:00	Diabetes Check	Emergency	Dolore illum error accusamus.	2025-06-26 22:30:08	2025-06-26 22:30:08	105/86	80	100.3	98	70	Omnis officiis quas optio repellendus adipisci.	Eos blanditiis quo expedita aperiam corporis.	2025-07-30	Assumenda reiciendis consectetur placeat.	2025-07-10	14:45	3	pending	APT10388	\N
9390	49	10	2025-07-11 15:30:00	High BP	Emergency	Nemo quis ut porro.	2025-06-26 22:30:08	2025-06-26 22:30:08	123/62	90	98.0	99	56	Nesciunt ipsum odio cum. Voluptatem similique sequi iusto.	Et neque sed voluptate quo debitis iusto.	2025-08-02	Eveniet cumque quasi ab libero.	2025-07-11	15:30	3	pending	APT10389	\N
9391	149	10	2025-07-11 14:45:00	Routine Checkup	OPD	Voluptatem tenetur dolore quo sit vero.	2025-06-26 22:30:08	2025-06-26 22:30:08	131/73	68	99.2	100	82	Quasi eligendi optio dolorum dolorum.	Aliquid molestias adipisci provident ab odit perspiciatis laudantium.	2025-07-23	Libero delectus harum error vero iste fugiat.	2025-07-11	14:45	3	pending	APT10390	\N
9392	313	7	2025-07-11 14:15:00	Back Pain	Emergency	Dolorum deleniti delectus omnis qui.	2025-06-26 22:30:08	2025-06-26 22:30:08	116/81	87	98.7	96	76	Quidem deserunt doloribus excepturi blanditiis laborum ea.	Minima nihil vel voluptas perspiciatis animi voluptatem voluptatibus expedita error.	2025-07-25	Exercitationem minus fugit officiis voluptatum neque.	2025-07-11	14:15	3	pending	APT10391	\N
9393	38	6	2025-07-11 15:45:00	Skin Rash	OPD	Magnam iure facere molestiae harum suscipit.	2025-06-26 22:30:08	2025-06-26 22:30:08	116/77	79	97.9	100	72	Omnis odit vero blanditiis facere perspiciatis.	Excepturi fugiat in vel repellat vel dolorum eaque eaque deleniti.	2025-07-19	Dicta impedit animi.	2025-07-11	15:45	3	pending	APT10392	\N
9394	138	7	2025-07-11 14:30:00	High BP	OPD	Impedit voluptate ipsum quidem.	2025-06-26 22:30:08	2025-06-26 22:30:08	112/79	85	99.1	100	72	Repudiandae ullam harum magni.	Dolorem suscipit tempora eligendi reiciendis incidunt nemo voluptas.	2025-08-10	Tempora mollitia dolorum.	2025-07-11	14:30	3	pending	APT10393	\N
9395	434	5	2025-07-11 13:30:00	Back Pain	OPD	Inventore quibusdam cumque harum laboriosam sapiente minima.	2025-06-26 22:30:08	2025-06-26 22:30:08	101/65	99	99.2	100	84	Deserunt laudantium voluptas.	Nihil dignissimos officia alias modi quaerat cumque ratione.	2025-07-28	Minus delectus sed accusamus quas ipsa aperiam.	2025-07-11	13:30	3	pending	APT10394	\N
9396	319	10	2025-07-11 14:15:00	Routine Checkup	Follow-up	Amet deleniti neque est dignissimos et perspiciatis.	2025-06-26 22:30:08	2025-06-26 22:30:08	140/81	70	97.7	97	62	Quam repellendus vel architecto perspiciatis.	Totam accusantium sit praesentium laudantium.	2025-07-24	Necessitatibus expedita amet eos dicta.	2025-07-11	14:15	3	pending	APT10395	\N
9397	67	3	2025-07-11 15:00:00	Back Pain	New	Nemo porro voluptatem iste quasi at.	2025-06-26 22:30:08	2025-06-26 22:30:08	121/66	94	98.4	100	82	Impedit veniam magni exercitationem earum tempore beatae.	Quisquam omnis repellat reiciendis non officiis aspernatur nisi iure.	2025-07-26	Commodi provident eveniet molestiae provident earum.	2025-07-11	15:00	3	pending	APT10396	\N
9398	306	8	2025-07-11 16:30:00	Skin Rash	Follow-up	Deserunt inventore cupiditate illum sequi soluta quo.	2025-06-26 22:30:08	2025-06-26 22:30:08	124/74	81	99.0	100	73	Similique molestiae natus similique architecto.	Distinctio voluptas quod illo aperiam.	2025-08-05	Eos nihil inventore debitis quae amet.	2025-07-11	16:30	3	pending	APT10397	\N
9399	124	7	2025-07-11 11:30:00	High BP	Follow-up	Animi iusto perspiciatis quis.	2025-06-26 22:30:08	2025-06-26 22:30:08	117/83	86	99.1	97	76	Quo totam voluptas facere esse officia magnam in.	Quasi voluptatem magni voluptatem cum assumenda alias cumque vero rerum.	2025-08-07	Nemo molestiae adipisci sit.	2025-07-11	11:30	3	pending	APT10398	\N
9400	471	4	2025-07-11 12:30:00	Headache	Follow-up	Qui illum aliquam libero minima dolores.	2025-06-26 22:30:08	2025-06-26 22:30:08	113/69	96	98.0	95	57	Quod optio repellat quasi vero eaque excepturi.	Molestias vitae alias tempore quaerat sint nam.	2025-08-03	Iusto laboriosam nemo similique quae.	2025-07-11	12:30	3	pending	APT10399	\N
9401	51	3	2025-07-11 11:15:00	Skin Rash	OPD	Quia quasi placeat impedit minima.	2025-06-26 22:30:08	2025-06-26 22:30:08	102/80	89	98.2	99	71	Dolorum aut eos ut.	Hic dolorum incidunt enim reiciendis omnis velit.	2025-08-10	Vero autem nostrum tempora totam alias porro.	2025-07-11	11:15	3	pending	APT10400	\N
9402	365	3	2025-07-11 15:30:00	Back Pain	New	Fugiat ab delectus vel maiores ullam.	2025-06-26 22:30:08	2025-06-26 22:30:08	101/83	70	98.9	98	70	Quaerat labore excepturi neque aliquid.	Molestiae quos delectus assumenda quibusdam deleniti minima eaque.	2025-08-09	Placeat molestiae nobis ad necessitatibus.	2025-07-11	15:30	3	pending	APT10401	\N
9403	60	4	2025-07-11 15:30:00	High BP	OPD	Debitis fuga mollitia dolorum minima corporis corporis.	2025-06-26 22:30:08	2025-06-26 22:30:08	123/72	96	99.1	100	59	Ex unde beatae corporis.	Corrupti nisi porro facilis optio ipsum maiores illum enim veritatis.	2025-08-10	Aliquid inventore at dolores dolor cumque consectetur.	2025-07-11	15:30	3	pending	APT10402	\N
9404	44	3	2025-07-11 11:30:00	Skin Rash	OPD	Cupiditate numquam dolores assumenda earum deserunt enim magni.	2025-06-26 22:30:08	2025-06-26 22:30:08	100/69	67	97.7	97	80	Magnam neque ratione porro ipsa enim.	Possimus similique asperiores blanditiis eos itaque.	2025-08-07	Eum qui deserunt ratione consequatur.	2025-07-11	11:30	3	pending	APT10403	\N
9405	456	5	2025-07-11 15:45:00	Skin Rash	Follow-up	Minus placeat at culpa corporis voluptates.	2025-06-26 22:30:08	2025-06-26 22:30:08	139/62	67	100.3	97	64	Hic voluptatum nemo et.	Sunt consectetur fugit vero excepturi repudiandae saepe modi.	2025-07-29	Iusto eos vero minima reiciendis sed.	2025-07-11	15:45	3	pending	APT10404	\N
9406	91	4	2025-07-11 13:00:00	Routine Checkup	Follow-up	Labore vel consectetur.	2025-06-26 22:30:08	2025-06-26 22:30:08	107/68	100	97.8	99	59	Amet nostrum reprehenderit debitis cum.	Esse delectus blanditiis ipsam provident.	2025-08-02	Veniam deleniti officia optio velit vel.	2025-07-11	13:00	3	pending	APT10405	\N
9407	204	3	2025-07-11 12:30:00	Routine Checkup	Emergency	Doloremque error facilis est architecto.	2025-06-26 22:30:08	2025-06-26 22:30:08	125/84	66	100.2	99	83	Fugiat voluptatibus sequi vitae in culpa.	Nisi eius ipsam numquam fugit similique sint tenetur doloribus.	2025-08-08	Ullam nostrum saepe odit natus vero.	2025-07-11	12:30	3	pending	APT10406	\N
9408	38	9	2025-07-11 15:30:00	High BP	OPD	Soluta nesciunt veniam a tempora corrupti eligendi quibusdam.	2025-06-26 22:30:08	2025-06-26 22:30:08	133/74	81	100.5	99	75	Tempore in laborum ratione ducimus.	Voluptas in voluptates dignissimos a odit ut temporibus quidem quos.	2025-07-24	Quas repellendus molestias saepe ex et.	2025-07-11	15:30	3	pending	APT10407	\N
9409	459	5	2025-07-11 12:00:00	Skin Rash	Emergency	Minima excepturi veniam doloremque ipsum eaque illo.	2025-06-26 22:30:08	2025-06-26 22:30:08	111/84	65	99.9	99	57	Quod eligendi ipsa nesciunt.	Fugit accusamus facilis eligendi sint ducimus quas ullam pariatur illo.	2025-07-22	Nemo eius impedit quaerat aliquam quisquam.	2025-07-11	12:00	3	pending	APT10408	\N
9410	111	5	2025-07-11 13:45:00	Back Pain	Follow-up	Dolor veritatis natus id a labore voluptatibus.	2025-06-26 22:30:08	2025-06-26 22:30:08	140/68	86	100.1	97	61	Officiis at ea atque voluptates totam iure debitis.	Voluptates neque aliquid nisi deleniti reprehenderit sequi nam.	2025-08-06	Dolorum est eaque.	2025-07-11	13:45	3	pending	APT10409	\N
9411	307	6	2025-07-11 15:30:00	Fever	OPD	Facilis blanditiis nostrum quis eaque quod.	2025-06-26 22:30:08	2025-06-26 22:30:08	108/76	83	98.0	97	80	Perferendis consequuntur veritatis ea iure.	Quas ex quis delectus voluptatem maiores ratione.	2025-08-01	In odio nobis iure vel.	2025-07-11	15:30	3	pending	APT10410	\N
9412	187	4	2025-07-11 12:00:00	Fever	Follow-up	Facilis quo perspiciatis voluptates.	2025-06-26 22:30:08	2025-06-26 22:30:08	123/70	83	98.7	99	79	Aliquam facilis reiciendis veritatis unde maiores dolorem.	Esse odit ipsum neque minima dolores.	2025-07-21	Optio illum quasi nam sed soluta eos at.	2025-07-11	12:00	3	pending	APT10411	\N
9413	61	3	2025-07-11 11:30:00	Cough	OPD	Neque quos quibusdam beatae.	2025-06-26 22:30:08	2025-06-26 22:30:08	110/75	77	98.5	98	64	Perspiciatis eveniet optio nisi tenetur.	Corrupti corporis sunt quibusdam minima magni quidem.	2025-07-19	Dignissimos error accusamus optio.	2025-07-11	11:30	3	pending	APT10412	\N
9414	257	10	2025-07-11 12:45:00	Skin Rash	Follow-up	Autem ducimus nulla commodi quae ipsum.	2025-06-26 22:30:08	2025-06-26 22:30:08	107/71	66	99.4	95	55	Blanditiis neque natus tempora natus accusamus possimus.	Expedita recusandae molestias asperiores repellat assumenda soluta.	2025-07-31	Blanditiis porro doloremque labore possimus voluptas.	2025-07-11	12:45	3	pending	APT10413	\N
9415	166	4	2025-07-12 13:00:00	Fever	Follow-up	Hic natus dolorum distinctio praesentium consequatur officia.	2025-06-26 22:30:08	2025-06-26 22:30:08	113/79	97	99.6	99	55	Nihil deleniti hic libero ipsum similique provident animi.	Ex quaerat id vel.	2025-08-11	Veritatis magnam exercitationem sunt ab deleniti.	2025-07-12	13:00	3	pending	APT10414	\N
9416	26	5	2025-07-12 11:00:00	Routine Checkup	Emergency	Dignissimos pariatur quasi quo perferendis vitae magni.	2025-06-26 22:30:08	2025-06-26 22:30:08	115/68	84	98.1	100	59	Rem dolorum facilis aut.	Dicta velit quasi sapiente magnam neque in fugiat repellat.	2025-07-30	Quibusdam laboriosam molestiae enim quod enim.	2025-07-12	11:00	3	pending	APT10415	\N
9417	229	5	2025-07-12 12:45:00	Headache	OPD	Est hic aut architecto quidem.	2025-06-26 22:30:08	2025-06-26 22:30:08	133/63	88	99.7	98	59	Facere eligendi facere veritatis recusandae.	Officiis reprehenderit voluptatum ratione odio at maxime assumenda a.	2025-07-28	Repellendus inventore nam maxime quaerat.	2025-07-12	12:45	3	pending	APT10416	\N
9418	239	8	2025-07-12 12:30:00	High BP	OPD	Cumque consequatur provident eum ipsa dolorem.	2025-06-26 22:30:08	2025-06-26 22:30:08	136/82	94	100.3	95	80	Laborum vitae sit. Dolorum porro temporibus.	Modi illum eum illo vero inventore exercitationem.	2025-07-20	Nesciunt occaecati perferendis nemo magnam.	2025-07-12	12:30	3	pending	APT10417	\N
9419	376	9	2025-07-12 16:00:00	Cough	Emergency	Aperiam nobis ducimus amet quaerat nisi.	2025-06-26 22:30:08	2025-06-26 22:30:08	117/75	81	97.7	97	66	Minima debitis nisi aspernatur voluptates.	Saepe quam qui doloribus vero sint vero sapiente.	2025-08-01	Beatae velit blanditiis assumenda illum nemo.	2025-07-12	16:00	3	pending	APT10418	\N
9420	41	8	2025-07-12 14:30:00	Diabetes Check	Emergency	Nam officia sunt error temporibus numquam reprehenderit.	2025-06-26 22:30:08	2025-06-26 22:30:08	133/76	85	100.1	100	77	Quos unde praesentium eligendi.	Eligendi laboriosam mollitia ipsa totam maxime pariatur rerum veniam.	2025-07-29	Enim cum dolores nam optio corrupti placeat.	2025-07-12	14:30	3	pending	APT10419	\N
9421	466	6	2025-07-12 12:30:00	Skin Rash	Follow-up	Quod nemo facilis libero ipsa cumque accusantium quo.	2025-06-26 22:30:08	2025-06-26 22:30:08	116/81	90	99.7	95	55	Distinctio numquam atque iste harum quaerat.	Voluptatibus fugiat blanditiis dolorum quas incidunt impedit debitis.	2025-07-22	Ea molestiae architecto sunt.	2025-07-12	12:30	3	pending	APT10420	\N
9422	221	5	2025-07-12 11:15:00	Back Pain	New	Enim natus alias tenetur exercitationem iste.	2025-06-26 22:30:08	2025-06-26 22:30:08	133/83	84	97.9	96	82	Incidunt labore est.	Esse libero totam dolores molestias consequuntur.	2025-07-23	Occaecati natus sit non excepturi.	2025-07-12	11:15	3	pending	APT10421	\N
9423	176	5	2025-07-12 13:00:00	High BP	Emergency	Suscipit recusandae aperiam consectetur sapiente.	2025-06-26 22:30:08	2025-06-26 22:30:08	132/75	66	97.7	95	84	Voluptatem vero molestiae earum ut.	Sunt quidem nostrum ipsum incidunt.	2025-07-31	Odit accusamus ut architecto deserunt nobis eos.	2025-07-12	13:00	3	pending	APT10422	\N
9424	36	4	2025-07-12 16:00:00	Headache	Follow-up	Odit consequatur reiciendis nobis vitae ab aspernatur.	2025-06-26 22:30:08	2025-06-26 22:30:08	114/80	100	99.4	99	85	Molestiae praesentium quam voluptatum ex tenetur.	Nesciunt non voluptatibus eligendi aut nam.	2025-07-22	Id rerum natus ad quae incidunt alias eveniet.	2025-07-12	16:00	3	pending	APT10423	\N
9425	285	7	2025-07-12 11:45:00	Fever	New	Exercitationem atque veritatis aliquam voluptates.	2025-06-26 22:30:08	2025-06-26 22:30:08	133/62	67	99.7	95	64	In provident minus consequuntur adipisci.	Corporis esse mollitia corrupti suscipit labore beatae eum.	2025-07-20	Repellat blanditiis placeat nam.	2025-07-12	11:45	3	pending	APT10424	\N
9426	217	3	2025-07-12 15:45:00	Routine Checkup	Follow-up	Nostrum iusto repellendus maxime eveniet distinctio a.	2025-06-26 22:30:08	2025-06-26 22:30:08	101/60	66	98.7	97	70	Voluptatem animi quisquam adipisci fugiat.	Debitis suscipit nulla dicta nesciunt.	2025-08-04	Fugiat velit dolore occaecati sint sit.	2025-07-12	15:45	3	pending	APT10425	\N
9427	393	4	2025-07-12 13:00:00	Diabetes Check	Emergency	Aperiam dolore pariatur perferendis provident recusandae.	2025-06-26 22:30:08	2025-06-26 22:30:08	138/71	67	99.5	98	76	Corrupti sed excepturi quod.	Tempora in quaerat porro praesentium autem ullam dolorum eum.	2025-08-06	Nulla laboriosam unde cupiditate quaerat deleniti vitae.	2025-07-12	13:00	3	pending	APT10426	\N
9428	327	6	2025-07-12 14:45:00	Cough	OPD	Consequuntur placeat pariatur reprehenderit.	2025-06-26 22:30:08	2025-06-26 22:30:08	120/87	85	98.4	99	67	Natus vero adipisci quaerat.	Qui molestiae necessitatibus quisquam dignissimos.	2025-07-23	Deleniti praesentium occaecati enim debitis nobis neque nihil.	2025-07-12	14:45	3	pending	APT10427	\N
9429	25	6	2025-07-12 16:15:00	Cough	New	Adipisci illo id non.	2025-06-26 22:30:08	2025-06-26 22:30:08	139/72	84	100.4	100	63	Est explicabo vel soluta rem ratione soluta.	Cumque molestias illo sit impedit tempore aut facere accusantium consequuntur.	2025-07-21	Nulla consectetur recusandae ipsa magni pariatur.	2025-07-12	16:15	3	pending	APT10428	\N
9430	241	10	2025-07-12 14:30:00	Back Pain	New	Mollitia dicta sint vel dolore illo aliquid.	2025-06-26 22:30:08	2025-06-26 22:30:08	107/84	72	99.9	95	65	Quos recusandae maxime commodi.	Illum non nam sint fuga molestias saepe.	2025-07-26	Eius eum sed veritatis.	2025-07-12	14:30	3	pending	APT10429	\N
9431	454	9	2025-07-12 16:30:00	Skin Rash	Follow-up	Nulla alias est maxime.	2025-06-26 22:30:08	2025-06-26 22:30:08	118/87	82	99.5	96	56	Iste corporis rem blanditiis.	Deleniti expedita perferendis sunt.	2025-08-07	Nam beatae blanditiis amet magnam harum.	2025-07-12	16:30	3	pending	APT10430	\N
9432	199	3	2025-07-12 15:30:00	High BP	New	Aut dolores dolores debitis nam dolor eius.	2025-06-26 22:30:08	2025-06-26 22:30:08	130/88	94	98.9	97	70	Odio tempora impedit magnam quaerat aperiam.	Maiores maxime sint laboriosam culpa nam laboriosam nihil veritatis.	2025-08-09	Doloribus et ratione praesentium minima.	2025-07-12	15:30	3	pending	APT10431	\N
9433	325	3	2025-07-12 15:00:00	Diabetes Check	OPD	Corrupti consectetur quisquam dolore blanditiis.	2025-06-26 22:30:08	2025-06-26 22:30:08	114/72	69	97.8	98	78	Tempore ea sunt earum.	Amet cupiditate ducimus at illum dolores iure deleniti.	2025-08-02	Rerum accusantium omnis ab omnis dolore.	2025-07-12	15:00	3	pending	APT10432	\N
9434	199	10	2025-07-12 13:00:00	Diabetes Check	Follow-up	Vitae tempora sunt autem reiciendis quidem.	2025-06-26 22:30:08	2025-06-26 22:30:08	119/64	96	98.9	100	73	Est harum ipsum vitae. Vero fugiat repellat quidem.	Accusantium officia iure praesentium tenetur corrupti nulla eveniet inventore harum.	2025-08-11	Deserunt ab asperiores fugiat.	2025-07-12	13:00	3	pending	APT10433	\N
9435	31	4	2025-07-12 11:15:00	Diabetes Check	OPD	Voluptatem blanditiis consectetur vel facilis nulla.	2025-06-26 22:30:08	2025-06-26 22:30:08	130/73	91	98.8	96	80	Laborum sunt nesciunt facilis rem.	Fugiat saepe velit occaecati suscipit blanditiis voluptatum eveniet recusandae error.	2025-07-24	Molestias neque doloremque aut debitis distinctio vitae.	2025-07-12	11:15	3	pending	APT10434	\N
9436	302	6	2025-07-12 14:00:00	Diabetes Check	Emergency	Suscipit dolore cupiditate sequi.	2025-06-26 22:30:08	2025-06-26 22:30:08	128/89	67	98.3	95	65	Autem culpa maiores modi illum cumque itaque.	Architecto unde earum tenetur esse repudiandae.	2025-07-25	Iusto suscipit maxime similique ullam sit.	2025-07-12	14:00	3	pending	APT10435	\N
9437	98	6	2025-07-12 14:30:00	Headache	Follow-up	Assumenda placeat quas neque.	2025-06-26 22:30:08	2025-06-26 22:30:08	124/86	97	100.2	95	68	Excepturi quos est quos neque est cupiditate.	Aut minima dolore eius voluptate debitis occaecati quidem.	2025-07-24	Commodi quis nostrum tempore corrupti eveniet.	2025-07-12	14:30	3	pending	APT10436	\N
9438	218	7	2025-07-12 14:45:00	Routine Checkup	New	Non doloremque commodi vel sint aliquam nemo.	2025-06-26 22:30:08	2025-06-26 22:30:08	102/73	81	98.3	99	78	Quam ex eos similique.	Sunt incidunt perferendis tenetur minima.	2025-07-26	Ipsam a neque esse.	2025-07-12	14:45	3	pending	APT10437	\N
9439	151	9	2025-07-13 15:00:00	Cough	OPD	Deleniti nulla doloribus aperiam tempore.	2025-06-26 22:30:08	2025-06-26 22:30:08	104/74	82	99.7	95	77	Rerum dolorem rem delectus.	Necessitatibus eius vero laudantium fugit consequatur amet ratione.	2025-07-25	Ipsum quam alias laboriosam.	2025-07-13	15:00	3	pending	APT10438	\N
9440	460	4	2025-07-13 11:45:00	Cough	OPD	Tenetur libero architecto autem quisquam asperiores.	2025-06-26 22:30:08	2025-06-26 22:30:08	101/87	90	100.2	95	74	Praesentium voluptas alias accusantium nobis.	Labore labore illum assumenda sapiente.	2025-08-04	Numquam iure nesciunt molestiae nesciunt reprehenderit.	2025-07-13	11:45	3	pending	APT10439	\N
9441	201	8	2025-07-13 12:30:00	Cough	Follow-up	Temporibus fuga nobis nostrum.	2025-06-26 22:30:08	2025-06-26 22:30:08	139/83	75	97.5	100	82	Eveniet eum facere.	Beatae dignissimos sint ullam sapiente.	2025-08-03	Nulla voluptatum sit occaecati soluta tempore similique temporibus.	2025-07-13	12:30	3	pending	APT10440	\N
9442	367	7	2025-07-13 13:15:00	Fever	Emergency	A animi delectus.	2025-06-26 22:30:08	2025-06-26 22:30:08	130/75	65	98.9	96	57	Occaecati quibusdam quis reprehenderit.	Neque repudiandae quis ut velit fuga repudiandae cupiditate.	2025-07-23	Nemo accusantium ipsam consequatur.	2025-07-13	13:15	3	pending	APT10441	\N
9443	88	3	2025-07-13 11:00:00	High BP	New	Culpa ipsum alias labore doloribus numquam.	2025-06-26 22:30:08	2025-06-26 22:30:08	136/75	71	98.6	100	84	Est voluptatum optio perspiciatis.	Eos quod fugit illo assumenda nam voluptatibus quisquam.	2025-07-27	Commodi maxime distinctio minus eum unde ad.	2025-07-13	11:00	3	pending	APT10442	\N
9444	477	10	2025-07-13 16:00:00	High BP	Emergency	Assumenda eligendi nam tempora.	2025-06-26 22:30:08	2025-06-26 22:30:08	104/72	96	99.6	96	78	Hic ut quam modi dolores dolore.	Ullam voluptate dolorum dicta labore ratione repellat dicta.	2025-07-26	Placeat fugit ipsum velit deserunt nisi.	2025-07-13	16:00	3	pending	APT10443	\N
9445	459	4	2025-07-13 12:00:00	High BP	Follow-up	Odit quae beatae nihil.	2025-06-26 22:30:08	2025-06-26 22:30:08	113/60	78	100.3	96	55	Dicta recusandae sunt in veritatis eos corporis quod.	Voluptas est ut magnam illum id doloremque neque fugit.	2025-07-25	A officia inventore.	2025-07-13	12:00	3	pending	APT10444	\N
9446	235	7	2025-07-13 16:00:00	High BP	Follow-up	Earum ipsam tempore quibusdam qui consequuntur eveniet.	2025-06-26 22:30:08	2025-06-26 22:30:08	120/66	88	98.4	100	55	Modi error culpa nisi porro id magni.	Maiores quae necessitatibus voluptas labore exercitationem natus recusandae saepe.	2025-07-30	Officiis porro temporibus asperiores nihil labore tempora nisi.	2025-07-13	16:00	3	pending	APT10445	\N
9447	300	4	2025-07-13 16:00:00	Skin Rash	Follow-up	Optio iure vero architecto suscipit.	2025-06-26 22:30:08	2025-06-26 22:30:08	114/70	88	99.3	98	84	Perspiciatis ad quis ut harum.	Nemo tempora sit odit expedita mollitia voluptatum.	2025-07-21	Nobis perspiciatis quam laudantium odio.	2025-07-13	16:00	3	pending	APT10446	\N
9448	248	5	2025-07-13 11:45:00	Skin Rash	Emergency	Dolore exercitationem animi numquam ullam perspiciatis.	2025-06-26 22:30:08	2025-06-26 22:30:08	115/78	65	98.7	100	70	Quod aspernatur sit laborum beatae voluptates.	Numquam ratione explicabo saepe aliquam maiores reprehenderit.	2025-08-04	Perspiciatis quisquam dolor laboriosam numquam.	2025-07-13	11:45	3	pending	APT10447	\N
9449	133	5	2025-07-13 14:00:00	Back Pain	OPD	Beatae nisi voluptates vero voluptatibus quos.	2025-06-26 22:30:08	2025-06-26 22:30:08	123/66	79	99.7	96	79	Est occaecati nostrum nulla nostrum.	Dolorem perspiciatis accusamus tenetur vel quia culpa.	2025-08-11	Necessitatibus similique aliquid reiciendis vero vero.	2025-07-13	14:00	3	pending	APT10448	\N
9450	280	3	2025-07-13 13:15:00	Fever	Follow-up	Deleniti illo ut optio.	2025-06-26 22:30:08	2025-06-26 22:30:08	133/81	99	98.3	100	66	Et officiis fugiat consectetur iste repudiandae dolore.	Ipsam cum cumque excepturi consequuntur quisquam soluta eveniet.	2025-08-08	Dignissimos doloremque ut itaque velit impedit.	2025-07-13	13:15	3	pending	APT10449	\N
9451	40	9	2025-07-13 12:00:00	Skin Rash	Emergency	Tempore est numquam excepturi.	2025-06-26 22:30:08	2025-06-26 22:30:08	116/62	68	98.5	95	84	Iure impedit eos maxime possimus ipsum.	Provident dolorem laudantium placeat voluptatem consectetur quisquam amet magnam.	2025-07-20	Et ab pariatur excepturi vitae occaecati a minus.	2025-07-13	12:00	3	pending	APT10450	\N
9452	11	9	2025-07-13 16:30:00	Fever	Emergency	Sunt minima accusamus veniam facilis temporibus quia.	2025-06-26 22:30:08	2025-06-26 22:30:08	132/74	87	98.0	96	73	Possimus sint excepturi explicabo repudiandae.	Laborum illum et deserunt cumque vero culpa deleniti.	2025-08-04	Nulla veniam architecto odit quaerat quam excepturi exercitationem.	2025-07-13	16:30	3	pending	APT10451	\N
9453	297	3	2025-07-13 16:45:00	Cough	Emergency	Cumque magni nobis eius odit.	2025-06-26 22:30:08	2025-06-26 22:30:08	139/85	76	99.3	100	67	Quae animi eius temporibus enim cum.	Laudantium dignissimos ab reprehenderit voluptate doloremque delectus error velit.	2025-08-05	Necessitatibus similique saepe molestiae quae enim a iure.	2025-07-13	16:45	3	pending	APT10452	\N
9454	409	4	2025-07-13 14:00:00	Skin Rash	OPD	Iure quibusdam itaque atque.	2025-06-26 22:30:08	2025-06-26 22:30:08	109/89	99	98.3	96	75	Accusamus voluptates alias debitis illum eos.	Incidunt quam aliquam enim repellendus.	2025-08-10	Architecto sed rerum.	2025-07-13	14:00	3	pending	APT10453	\N
9455	151	4	2025-07-13 13:15:00	Headache	Follow-up	Eveniet quo sit provident vel doloremque.	2025-06-26 22:30:08	2025-06-26 22:30:08	134/61	68	98.2	99	79	Dolores atque expedita maiores.	Ab inventore architecto quae corporis sunt modi blanditiis cum.	2025-07-28	Aliquam quo accusantium quos ipsam.	2025-07-13	13:15	3	pending	APT10454	\N
9456	29	5	2025-07-13 15:45:00	Fever	Emergency	Quia sapiente libero cupiditate consequatur vitae.	2025-06-26 22:30:08	2025-06-26 22:30:08	105/89	74	100.4	100	64	Ex deleniti qui.	Veritatis consequatur ex veritatis minus harum veniam minus nostrum minus.	2025-08-09	Quas nihil omnis consectetur quis ad.	2025-07-13	15:45	3	pending	APT10455	\N
9457	283	4	2025-07-13 13:15:00	Routine Checkup	New	Mollitia corporis blanditiis eveniet perferendis.	2025-06-26 22:30:08	2025-06-26 22:30:08	136/75	81	97.9	99	61	Iusto placeat corporis id.	Architecto laborum nobis sint eius perspiciatis provident beatae facilis.	2025-08-02	Placeat eaque natus temporibus consectetur quidem officia.	2025-07-13	13:15	3	pending	APT10456	\N
9458	56	10	2025-07-13 11:45:00	Skin Rash	Follow-up	Eos minima ipsam cumque atque quos fuga beatae.	2025-06-26 22:30:08	2025-06-26 22:30:08	132/67	65	97.8	98	68	Repellat qui quia corporis.	Voluptatum laudantium fugit ut.	2025-07-26	Itaque perferendis recusandae pariatur aliquam iusto ipsa voluptas.	2025-07-13	11:45	3	pending	APT10457	\N
9459	246	8	2025-07-13 16:45:00	Headache	Emergency	Ad quis nostrum harum fugiat.	2025-06-26 22:30:08	2025-06-26 22:30:08	104/61	85	99.5	98	58	Nesciunt a eveniet ipsam.	Nesciunt quaerat quibusdam maiores unde.	2025-08-03	Fugit veritatis soluta nemo.	2025-07-13	16:45	3	pending	APT10458	\N
9460	422	3	2025-07-13 13:30:00	Back Pain	Follow-up	Maxime et architecto velit veniam.	2025-06-26 22:30:08	2025-06-26 22:30:08	101/85	74	99.4	99	81	Quia distinctio facilis minus veniam sunt.	Facere illum omnis animi cupiditate.	2025-08-11	Autem cumque tempora soluta quibusdam.	2025-07-13	13:30	3	pending	APT10459	\N
9461	466	6	2025-07-13 14:30:00	Cough	OPD	Enim distinctio provident velit maxime aliquid.	2025-06-26 22:30:08	2025-06-26 22:30:08	131/88	79	98.0	97	74	Quisquam dolorum magni cum.	Iusto fugit debitis libero autem praesentium nihil laudantium esse dolor omnis.	2025-08-02	Corporis nemo saepe labore veniam veniam.	2025-07-13	14:30	3	pending	APT10460	\N
9462	173	3	2025-07-13 12:00:00	Routine Checkup	Follow-up	Autem aperiam quae magnam.	2025-06-26 22:30:08	2025-06-26 22:30:08	134/78	79	100.2	99	76	Illum tempore consequatur perspiciatis voluptatum ipsa.	Soluta eligendi unde quae optio nisi officiis cupiditate.	2025-08-01	Perspiciatis repellendus praesentium ea.	2025-07-13	12:00	3	pending	APT10461	\N
9463	262	9	2025-07-13 11:45:00	Back Pain	Emergency	Est voluptates similique excepturi nemo.	2025-06-26 22:30:08	2025-06-26 22:30:08	104/69	71	98.8	95	69	Omnis ea nulla sequi ducimus perspiciatis.	Voluptates quaerat ullam ab sunt non natus accusamus.	2025-07-24	Libero exercitationem iusto totam ratione.	2025-07-13	11:45	3	pending	APT10462	\N
9464	279	5	2025-07-13 15:15:00	Diabetes Check	New	Non soluta praesentium expedita unde placeat.	2025-06-26 22:30:08	2025-06-26 22:30:08	117/88	94	98.2	98	69	Beatae numquam fugiat ad dolores.	Illo ea cum commodi perspiciatis.	2025-08-01	Repellendus nostrum a non.	2025-07-13	15:15	3	pending	APT10463	\N
9465	262	3	2025-07-14 12:00:00	Headache	Follow-up	Consequatur modi enim sint.	2025-06-26 22:30:08	2025-06-26 22:30:08	108/63	97	100.2	99	57	Delectus iste sit quam nobis soluta.	Ex tenetur repellat sint ipsum amet cupiditate ad esse.	2025-07-30	Voluptatum fugiat occaecati harum exercitationem temporibus assumenda.	2025-07-14	12:00	3	pending	APT10464	\N
9466	406	5	2025-07-14 16:00:00	Cough	New	Eveniet sit tempore doloribus minus qui rerum.	2025-06-26 22:30:08	2025-06-26 22:30:08	112/84	77	98.5	97	64	Accusamus qui suscipit eaque eius molestiae.	Asperiores quod cupiditate consequuntur possimus quod.	2025-07-28	Sequi vero ducimus repudiandae culpa.	2025-07-14	16:00	3	pending	APT10465	\N
9467	257	4	2025-07-14 13:45:00	Fever	OPD	Veritatis est occaecati optio soluta ipsam.	2025-06-26 22:30:08	2025-06-26 22:30:08	137/77	68	100.2	100	73	Sit iste ut.	Distinctio quae earum ab rerum architecto incidunt corporis soluta.	2025-08-04	Sunt iure beatae aliquid adipisci suscipit.	2025-07-14	13:45	3	pending	APT10466	\N
9468	210	9	2025-07-14 13:45:00	Headache	OPD	Distinctio vero ea.	2025-06-26 22:30:08	2025-06-26 22:30:08	126/88	65	99.5	100	61	Recusandae labore praesentium est.	Doloremque perferendis ipsam nam exercitationem occaecati vel.	2025-07-28	Sapiente eligendi minima harum.	2025-07-14	13:45	3	pending	APT10467	\N
9469	367	9	2025-07-14 16:45:00	Diabetes Check	Follow-up	Error et numquam nam.	2025-06-26 22:30:08	2025-06-26 22:30:08	104/80	77	97.9	96	82	Ex voluptas quidem minus expedita.	Saepe reprehenderit pariatur mollitia accusamus earum ut iste laborum.	2025-07-27	Exercitationem quae architecto quae corrupti.	2025-07-14	16:45	3	pending	APT10468	\N
9470	195	8	2025-07-14 16:15:00	Fever	Emergency	Possimus repudiandae officia necessitatibus pariatur.	2025-06-26 22:30:08	2025-06-26 22:30:08	140/64	85	100.0	96	68	Exercitationem ad natus magnam.	Voluptatum exercitationem vel ipsum id distinctio provident.	2025-07-21	Tempora nostrum odio minima qui repellendus eveniet.	2025-07-14	16:15	3	pending	APT10469	\N
9471	24	8	2025-07-14 15:15:00	Fever	Follow-up	Alias molestias minima officia in corrupti quas.	2025-06-26 22:30:08	2025-06-26 22:30:08	135/83	79	97.7	98	81	Porro ipsam excepturi quam.	In nobis minima sit.	2025-08-13	Quisquam nostrum magni ipsa tenetur at quis.	2025-07-14	15:15	3	pending	APT10470	\N
9472	206	6	2025-07-14 13:45:00	Cough	OPD	Tempore ducimus modi corporis.	2025-06-26 22:30:08	2025-06-26 22:30:08	120/88	90	100.2	100	71	Quidem error perferendis officiis.	Culpa eius beatae nesciunt itaque totam aspernatur eligendi similique.	2025-07-21	Mollitia cumque omnis excepturi accusamus deserunt dolor.	2025-07-14	13:45	3	pending	APT10471	\N
9473	348	5	2025-07-14 12:15:00	Skin Rash	Emergency	Minima quam magni quisquam neque.	2025-06-26 22:30:08	2025-06-26 22:30:08	101/72	95	99.7	97	65	A et odit minus. Ut possimus esse delectus.	Culpa beatae repudiandae explicabo tempora.	2025-07-24	Quo soluta repellendus ex officiis repellat.	2025-07-14	12:15	3	pending	APT10472	\N
9474	175	9	2025-07-14 11:45:00	Diabetes Check	Emergency	Autem debitis sapiente fugiat modi repudiandae nobis iure.	2025-06-26 22:30:08	2025-06-26 22:30:08	111/70	100	100.3	98	60	Mollitia maxime rerum nisi numquam consectetur laudantium.	Quas incidunt eaque eum alias earum debitis.	2025-07-30	Voluptates enim nisi error expedita est.	2025-07-14	11:45	3	pending	APT10473	\N
9475	190	7	2025-07-14 12:15:00	Cough	New	Reprehenderit iste dolores quas praesentium perferendis.	2025-06-26 22:30:08	2025-06-26 22:30:08	109/63	95	98.4	98	64	Inventore exercitationem nesciunt similique.	Consectetur dolore nostrum ipsa itaque ex cum.	2025-07-25	Nisi nostrum ea tempora officiis cupiditate itaque.	2025-07-14	12:15	3	pending	APT10474	\N
9476	312	10	2025-07-14 14:45:00	Skin Rash	Follow-up	Aspernatur amet aliquam necessitatibus illum quidem quod aperiam.	2025-06-26 22:30:08	2025-06-26 22:30:08	125/69	67	99.2	100	57	Pariatur cupiditate quae culpa ratione asperiores.	Veritatis ad facere minus officia.	2025-07-31	Ea accusantium cumque.	2025-07-14	14:45	3	pending	APT10475	\N
9477	308	10	2025-07-14 16:45:00	Back Pain	Follow-up	Commodi ducimus quod velit facilis amet delectus eveniet.	2025-06-26 22:30:08	2025-06-26 22:30:08	114/66	97	99.1	97	65	Eum praesentium mollitia similique nulla nulla adipisci.	Explicabo beatae vel incidunt expedita eius.	2025-07-21	Optio quisquam asperiores eius perferendis aliquid.	2025-07-14	16:45	3	pending	APT10476	\N
9478	456	5	2025-07-14 16:30:00	Skin Rash	OPD	Nam perferendis impedit doloribus voluptate magnam.	2025-06-26 22:30:08	2025-06-26 22:30:08	126/64	74	99.7	98	80	Asperiores autem amet fugit velit provident.	Sed corporis dignissimos ullam maxime.	2025-08-11	Sapiente officia nihil sequi voluptatibus.	2025-07-14	16:30	3	pending	APT10477	\N
9479	430	10	2025-07-14 16:45:00	High BP	Emergency	Totam quos odio quod.	2025-06-26 22:30:08	2025-06-26 22:30:08	132/67	67	97.8	99	83	Ipsum beatae vero accusamus impedit.	Aliquam accusantium quaerat doloremque molestias porro sapiente et id voluptates.	2025-08-02	Molestias quis odio ratione nobis nostrum.	2025-07-14	16:45	3	pending	APT10478	\N
9480	417	8	2025-07-14 11:30:00	Headache	Emergency	Aperiam porro recusandae.	2025-06-26 22:30:08	2025-06-26 22:30:08	115/61	100	98.2	99	64	Fuga quam cupiditate quae magnam.	Harum sunt voluptas sequi veritatis veritatis autem.	2025-08-04	Accusantium placeat delectus tenetur.	2025-07-14	11:30	3	pending	APT10479	\N
9481	138	4	2025-07-14 15:30:00	Routine Checkup	Emergency	Reiciendis nemo eligendi repellendus possimus.	2025-06-26 22:30:08	2025-06-26 22:30:08	100/87	96	98.8	95	82	Possimus repudiandae numquam eius laboriosam ducimus.	Cum excepturi cumque recusandae saepe impedit cumque sint aut dicta.	2025-07-30	Unde facere asperiores voluptate.	2025-07-14	15:30	3	pending	APT10480	\N
9482	229	5	2025-07-14 15:15:00	High BP	Emergency	Sit maiores ut quos eum autem fugit.	2025-06-26 22:30:08	2025-06-26 22:30:08	129/62	74	97.7	98	63	Ex culpa eum.	Ratione sequi eos iste nulla perspiciatis totam hic.	2025-08-07	Tenetur natus officia vel magnam.	2025-07-14	15:15	3	pending	APT10481	\N
9483	330	7	2025-07-14 16:00:00	Back Pain	Emergency	Laborum cum commodi ipsam eum.	2025-06-26 22:30:08	2025-06-26 22:30:08	131/80	96	98.2	97	65	Amet voluptates libero quas minima reiciendis voluptatum.	Nulla nostrum quis molestias distinctio consequuntur numquam at atque.	2025-07-24	Sapiente amet fugit earum veniam ea.	2025-07-14	16:00	3	pending	APT10482	\N
9484	458	4	2025-07-14 16:00:00	Headache	OPD	Illo eum at fuga veritatis nam.	2025-06-26 22:30:08	2025-06-26 22:30:08	120/70	83	98.9	96	69	Aliquam laboriosam sequi corrupti cumque odio fugit.	Impedit porro inventore aperiam placeat minima.	2025-07-25	Tempora velit quis accusamus similique.	2025-07-14	16:00	3	pending	APT10483	\N
9485	317	8	2025-07-14 13:30:00	Headache	OPD	Corporis atque fuga aperiam veniam magnam magnam veniam.	2025-06-26 22:30:08	2025-06-26 22:30:08	140/89	82	98.1	99	74	Quibusdam vitae similique voluptatum neque molestias vel.	Consequuntur rem omnis explicabo repudiandae nemo dignissimos ut placeat asperiores.	2025-08-12	Reiciendis cumque doloribus doloremque cupiditate.	2025-07-14	13:30	3	pending	APT10484	\N
9486	421	5	2025-07-14 15:00:00	Skin Rash	Follow-up	Ab ullam eos hic magnam a earum.	2025-06-26 22:30:08	2025-06-26 22:30:08	127/70	100	98.6	96	78	Reiciendis dolore veniam corporis a iusto dolorum.	Voluptas optio in natus blanditiis.	2025-08-12	Fugiat nihil inventore quam.	2025-07-14	15:00	3	pending	APT10485	\N
9487	498	6	2025-07-14 14:30:00	Back Pain	New	Voluptas magni impedit excepturi praesentium maxime ducimus.	2025-06-26 22:30:08	2025-06-26 22:30:08	106/67	67	99.1	96	70	Aut quam adipisci delectus ducimus.	Cum vel quaerat labore a eligendi nemo.	2025-08-08	Iure itaque quod ratione enim.	2025-07-14	14:30	3	pending	APT10486	\N
9488	104	7	2025-07-14 14:45:00	High BP	Follow-up	Recusandae veniam perferendis.	2025-06-26 22:30:08	2025-06-26 22:30:08	106/79	97	98.1	100	61	Rem suscipit similique dolorem. Soluta repellendus eaque.	At itaque sit excepturi doloremque maiores.	2025-08-01	Ipsam maiores aliquid qui officiis.	2025-07-14	14:45	3	pending	APT10487	\N
9489	307	3	2025-07-14 12:00:00	Diabetes Check	Emergency	Quibusdam illum fugiat sunt porro ut.	2025-06-26 22:30:08	2025-06-26 22:30:08	111/88	86	100.4	97	82	Blanditiis fuga at asperiores ipsam.	Inventore nobis accusantium ullam tenetur molestiae officia soluta commodi maxime vero.	2025-07-21	Inventore optio blanditiis eum numquam.	2025-07-14	12:00	3	pending	APT10488	\N
9490	94	3	2025-07-14 12:30:00	Cough	New	Magni ex consectetur.	2025-06-26 22:30:08	2025-06-26 22:30:08	126/76	67	98.3	98	68	Sunt ratione eaque cumque doloremque rerum dicta error.	Ducimus rerum rerum fuga architecto quae quasi assumenda.	2025-08-03	Culpa rerum incidunt modi maxime.	2025-07-14	12:30	3	pending	APT10489	\N
9491	86	8	2025-07-14 11:45:00	Diabetes Check	New	Rem dolorem eveniet iure reprehenderit est optio nemo.	2025-06-26 22:30:08	2025-06-26 22:30:08	132/85	79	100.1	100	76	Et maxime ab explicabo ea aut perferendis.	Vitae repellendus quam sapiente eos enim facere a quas.	2025-08-11	Iure assumenda impedit quibusdam iste eum cum.	2025-07-14	11:45	3	pending	APT10490	\N
9492	259	9	2025-07-15 11:30:00	Diabetes Check	Follow-up	Facilis voluptates molestiae.	2025-06-26 22:30:08	2025-06-26 22:30:08	137/60	66	99.5	98	68	Provident quis ipsum eligendi.	Esse nostrum eveniet itaque possimus nostrum iure.	2025-08-08	Adipisci dolorem eos molestias quasi inventore.	2025-07-15	11:30	3	pending	APT10491	\N
9493	179	8	2025-07-15 11:45:00	Routine Checkup	Follow-up	Enim accusamus vero dolorum deleniti facere exercitationem.	2025-06-26 22:30:08	2025-06-26 22:30:08	140/87	94	99.3	96	56	Rem omnis recusandae accusamus nemo.	Nobis rerum assumenda sed molestias laborum.	2025-08-01	Placeat quia nobis aut expedita ipsum.	2025-07-15	11:45	3	pending	APT10492	\N
9494	57	7	2025-07-15 14:00:00	Skin Rash	OPD	Laboriosam asperiores id.	2025-06-26 22:30:08	2025-06-26 22:30:08	120/77	71	99.4	98	85	Cum eveniet saepe ipsam unde porro.	Consectetur sed dolorum ex doloremque molestiae libero sit blanditiis ad.	2025-08-09	Occaecati recusandae reiciendis.	2025-07-15	14:00	3	pending	APT10493	\N
9541	190	6	2025-07-17 15:15:00	Cough	Emergency	Placeat sunt aut sed.	2025-06-26 22:30:08	2025-06-26 22:30:08	112/72	79	100.3	100	58	Optio molestiae fuga nam.	Earum dolores quos praesentium voluptate ullam rem non itaque.	2025-08-02	Animi nihil rerum rerum.	2025-07-17	15:15	3	pending	APT10540	\N
9495	13	7	2025-07-15 15:15:00	Back Pain	New	Occaecati a quis ratione doloremque.	2025-06-26 22:30:08	2025-06-26 22:30:08	128/80	78	98.3	98	80	Iusto numquam doloribus est praesentium magnam odit.	Id enim eos accusantium tempore quam voluptas saepe nulla qui.	2025-08-14	Itaque animi pariatur recusandae.	2025-07-15	15:15	3	pending	APT10494	\N
9496	157	3	2025-07-15 12:00:00	Routine Checkup	New	Minima similique nemo neque non.	2025-06-26 22:30:08	2025-06-26 22:30:08	108/78	78	98.2	97	84	Magnam sint et laudantium vero voluptatibus iure.	Quisquam excepturi fugit est non in ab possimus ullam temporibus.	2025-07-22	Sed magni assumenda.	2025-07-15	12:00	3	pending	APT10495	\N
9497	203	6	2025-07-15 16:45:00	Cough	Emergency	Consequuntur excepturi blanditiis.	2025-06-26 22:30:08	2025-06-26 22:30:08	104/67	80	98.9	97	74	Iusto suscipit ab minima. Tenetur ipsum temporibus nam.	Cumque id facere mollitia doloribus perspiciatis soluta repellendus similique.	2025-07-25	Nam nobis tenetur odit non ipsam porro.	2025-07-15	16:45	3	pending	APT10496	\N
9498	239	8	2025-07-15 12:00:00	Headache	OPD	Nesciunt ducimus magni quod.	2025-06-26 22:30:08	2025-06-26 22:30:08	116/79	88	99.6	99	58	Iusto facere aut aliquid sint fuga quo.	Omnis officiis nam explicabo dolorum nemo vero blanditiis asperiores sit.	2025-08-05	Illo temporibus fugiat incidunt praesentium sapiente modi.	2025-07-15	12:00	3	pending	APT10497	\N
9499	245	5	2025-07-15 13:00:00	Cough	Follow-up	Voluptate nisi distinctio.	2025-06-26 22:30:08	2025-06-26 22:30:08	133/81	85	99.6	95	83	Unde beatae ex odio ea explicabo autem.	Autem officiis impedit neque ab.	2025-08-03	Eos facilis unde ducimus quasi consequatur vero.	2025-07-15	13:00	3	pending	APT10498	\N
9500	98	7	2025-07-15 15:15:00	Fever	New	Voluptas quasi ipsum sapiente fuga doloribus.	2025-06-26 22:30:08	2025-06-26 22:30:08	140/89	71	98.5	100	64	Minus dicta consectetur debitis pariatur dolores.	Ipsum autem corporis ab voluptatibus delectus quidem voluptates.	2025-07-31	Rerum inventore aspernatur recusandae consectetur dolorum rem.	2025-07-15	15:15	3	pending	APT10499	\N
9501	106	10	2025-07-15 11:15:00	Headache	New	Id cupiditate eaque atque explicabo.	2025-06-26 22:30:08	2025-06-26 22:30:08	103/90	70	98.5	99	76	Iste sapiente ex porro praesentium quos.	Distinctio ipsam non dolores officia maxime impedit nihil.	2025-07-24	Iste officia laboriosam dolor.	2025-07-15	11:15	3	pending	APT10500	\N
9502	392	8	2025-07-15 14:45:00	Skin Rash	Follow-up	Laudantium quaerat aliquam et.	2025-06-26 22:30:08	2025-06-26 22:30:08	118/77	74	98.8	100	64	Deserunt ex necessitatibus laborum rerum.	Quibusdam minus ea nam nihil minus voluptatibus perferendis.	2025-07-23	Repellat alias in error facere.	2025-07-15	14:45	3	pending	APT10501	\N
9503	498	5	2025-07-15 12:30:00	Routine Checkup	Follow-up	Aspernatur earum iure dolores accusamus saepe id.	2025-06-26 22:30:08	2025-06-26 22:30:08	131/62	70	97.6	98	68	Odio itaque officiis officia. Soluta esse tempore.	A nemo id voluptates reprehenderit ipsam incidunt ab a.	2025-08-04	Dolorum harum molestias reprehenderit.	2025-07-15	12:30	3	pending	APT10502	\N
9504	438	6	2025-07-15 16:15:00	Cough	OPD	Dicta nihil quasi iusto.	2025-06-26 22:30:08	2025-06-26 22:30:08	130/90	80	98.6	96	84	Saepe illo quam occaecati quae ea consectetur.	Similique blanditiis nisi perspiciatis molestias ratione unde laboriosam.	2025-08-07	Quidem ipsum sequi rerum impedit sed est.	2025-07-15	16:15	3	pending	APT10503	\N
9505	57	7	2025-07-15 13:45:00	Fever	Emergency	Voluptatum distinctio facilis autem autem vitae est eius.	2025-06-26 22:30:08	2025-06-26 22:30:08	138/83	80	97.6	97	55	Explicabo quae beatae quasi.	Quod asperiores commodi perspiciatis adipisci eos asperiores facilis.	2025-08-04	Fuga exercitationem expedita mollitia.	2025-07-15	13:45	3	pending	APT10504	\N
9506	173	5	2025-07-15 13:00:00	Cough	New	Neque eos aperiam debitis ut asperiores ipsa.	2025-06-26 22:30:08	2025-06-26 22:30:08	116/90	72	99.8	96	64	Doloremque voluptatibus hic vel. Excepturi minima totam ad.	Ipsa recusandae numquam nesciunt totam.	2025-08-14	Facilis perspiciatis soluta deleniti sint voluptas sed.	2025-07-15	13:00	3	pending	APT10505	\N
9507	154	10	2025-07-15 14:00:00	Diabetes Check	Follow-up	Fuga exercitationem nobis laudantium aliquam molestias.	2025-06-26 22:30:08	2025-06-26 22:30:08	109/73	70	100.0	100	80	Nisi tenetur odio.	Voluptate ad asperiores deleniti accusantium.	2025-07-29	Quod numquam delectus minus omnis at.	2025-07-15	14:00	3	pending	APT10506	\N
9508	89	8	2025-07-15 11:15:00	Cough	OPD	Fuga voluptate id culpa architecto explicabo id.	2025-06-26 22:30:08	2025-06-26 22:30:08	123/65	66	100.0	95	68	Veniam harum alias. Eius sunt sint delectus.	Qui reprehenderit aliquid possimus quo.	2025-08-12	Labore repellat nostrum inventore veniam iste provident.	2025-07-15	11:15	3	pending	APT10507	\N
9509	65	6	2025-07-15 13:15:00	Skin Rash	New	Ea deleniti corporis voluptate repellat.	2025-06-26 22:30:08	2025-06-26 22:30:08	102/82	96	98.9	97	79	Itaque omnis quae aspernatur fuga.	Praesentium quod praesentium accusamus amet.	2025-07-27	Magni magni excepturi molestiae libero.	2025-07-15	13:15	3	pending	APT10508	\N
9510	235	6	2025-07-15 15:45:00	Headache	Follow-up	Rerum quaerat distinctio velit.	2025-06-26 22:30:08	2025-06-26 22:30:08	103/73	76	97.7	99	59	A aspernatur nobis nam consectetur quidem aliquid.	Nisi iure possimus architecto ad repellendus mollitia consequatur.	2025-08-05	Magni voluptas nemo molestiae nesciunt tempora.	2025-07-15	15:45	3	pending	APT10509	\N
9511	258	8	2025-07-15 16:45:00	Back Pain	Follow-up	Soluta reiciendis harum cupiditate.	2025-06-26 22:30:08	2025-06-26 22:30:08	134/84	65	99.2	95	78	A natus nostrum sequi ipsum libero.	Iure nesciunt temporibus sit nesciunt libero non qui fuga.	2025-08-08	Voluptate occaecati ducimus.	2025-07-15	16:45	3	pending	APT10510	\N
9512	453	3	2025-07-15 12:45:00	Back Pain	Follow-up	Soluta perferendis sint.	2025-06-26 22:30:08	2025-06-26 22:30:08	126/84	67	100.3	95	73	Eius soluta commodi adipisci perferendis.	Rerum accusamus dicta consequuntur non corrupti occaecati ullam explicabo.	2025-07-24	Quis similique saepe.	2025-07-15	12:45	3	pending	APT10511	\N
9513	97	4	2025-07-15 11:15:00	Cough	Follow-up	Sunt repellat vero nobis.	2025-06-26 22:30:08	2025-06-26 22:30:08	102/60	85	99.2	98	60	Perferendis recusandae aliquam natus.	Amet laboriosam vitae maxime magnam.	2025-07-29	Enim optio explicabo sint animi velit facilis.	2025-07-15	11:15	3	pending	APT10512	\N
9514	195	6	2025-07-15 16:00:00	Headache	Emergency	Fugiat ipsam error rerum incidunt.	2025-06-26 22:30:08	2025-06-26 22:30:08	124/69	90	100.4	97	61	Cumque corrupti fugiat consectetur.	Magni alias maxime commodi occaecati animi deserunt nobis.	2025-08-09	Veritatis blanditiis explicabo voluptates officia culpa.	2025-07-15	16:00	3	pending	APT10513	\N
9515	200	5	2025-07-15 11:00:00	Routine Checkup	OPD	Facilis hic porro.	2025-06-26 22:30:08	2025-06-26 22:30:08	134/72	73	100.4	100	58	Dicta officiis numquam excepturi aliquam beatae.	Velit ad in tempora ipsa reiciendis eligendi non.	2025-07-22	Eos distinctio quam accusantium reiciendis accusantium.	2025-07-15	11:00	3	pending	APT10514	\N
9516	178	6	2025-07-15 12:15:00	High BP	Emergency	Voluptatibus labore quo.	2025-06-26 22:30:08	2025-06-26 22:30:08	110/84	78	98.2	95	72	Animi placeat itaque ducimus repellat.	Dolore quam minima possimus temporibus non odit ipsa animi ipsam.	2025-08-05	Voluptas magnam adipisci animi debitis.	2025-07-15	12:15	3	pending	APT10515	\N
9517	269	3	2025-07-15 14:45:00	Diabetes Check	OPD	Adipisci at id eligendi illo.	2025-06-26 22:30:08	2025-06-26 22:30:08	134/65	96	98.7	98	80	Tempora eum quo cumque minus.	Quasi harum dignissimos quos unde iste.	2025-07-24	Sit recusandae consequatur quas corporis nihil et.	2025-07-15	14:45	3	pending	APT10516	\N
9518	467	10	2025-07-15 13:15:00	Fever	Emergency	Ipsum harum consequuntur asperiores molestias reiciendis.	2025-06-26 22:30:08	2025-06-26 22:30:08	120/60	81	100.1	95	59	Quae reprehenderit hic rem in aspernatur natus soluta.	Earum voluptas velit facere earum natus explicabo voluptatum ratione quod.	2025-07-25	Consequuntur nemo ipsa blanditiis sint.	2025-07-15	13:15	3	pending	APT10517	\N
9519	347	5	2025-07-16 16:00:00	Routine Checkup	Emergency	Officia eligendi dolorem quis ea vero in.	2025-06-26 22:30:08	2025-06-26 22:30:08	109/79	95	97.9	95	59	Ab quasi in.	Ipsum reiciendis quos vero delectus sunt porro quibusdam doloribus voluptatum.	2025-07-25	Ex omnis repellat corporis.	2025-07-16	16:00	3	pending	APT10518	\N
9520	87	4	2025-07-16 15:15:00	Back Pain	Emergency	Sunt sint ducimus excepturi distinctio necessitatibus nam.	2025-06-26 22:30:08	2025-06-26 22:30:08	136/61	72	98.4	96	56	Dignissimos ad sint voluptate explicabo.	Est saepe voluptatum sed itaque consequatur quo excepturi perspiciatis sunt atque.	2025-08-01	Harum possimus voluptas aspernatur quaerat asperiores.	2025-07-16	15:15	3	pending	APT10519	\N
9521	422	5	2025-07-16 12:45:00	Skin Rash	New	Ut nihil aliquam aliquam.	2025-06-26 22:30:08	2025-06-26 22:30:08	117/69	78	97.8	96	69	Doloribus iusto voluptatem doloremque neque ea dolor.	Architecto at voluptate tenetur unde.	2025-07-27	Fuga ipsum dignissimos aliquid ut.	2025-07-16	12:45	3	pending	APT10520	\N
9522	457	10	2025-07-16 13:45:00	High BP	Follow-up	Velit rem omnis quam expedita error ut.	2025-06-26 22:30:08	2025-06-26 22:30:08	104/65	76	98.4	95	78	Cum quisquam autem voluptatem molestiae.	Consequatur nobis consequuntur doloribus iure earum consequuntur.	2025-07-29	Blanditiis debitis minima vel.	2025-07-16	13:45	3	pending	APT10521	\N
9523	287	5	2025-07-16 15:45:00	Fever	New	Ipsa nesciunt dolorem.	2025-06-26 22:30:08	2025-06-26 22:30:08	139/68	73	98.9	96	79	Esse dicta placeat earum.	Incidunt voluptatibus ut voluptatibus saepe assumenda.	2025-07-24	Commodi officia excepturi molestiae amet alias.	2025-07-16	15:45	3	pending	APT10522	\N
9524	175	7	2025-07-16 13:00:00	Headache	OPD	Ipsum dolore eum adipisci vero culpa enim.	2025-06-26 22:30:08	2025-06-26 22:30:08	106/78	88	99.3	100	57	Cumque ipsa itaque et delectus fugit quae.	Ullam consequatur ducimus laboriosam suscipit quod quam fugit delectus maxime.	2025-07-27	Repellendus dignissimos nostrum at officia.	2025-07-16	13:00	3	pending	APT10523	\N
9525	456	6	2025-07-16 12:30:00	Routine Checkup	Emergency	Quasi totam quo.	2025-06-26 22:30:08	2025-06-26 22:30:08	106/69	66	98.2	99	70	Unde delectus esse non numquam facere.	Cumque sunt necessitatibus similique necessitatibus deserunt veritatis error voluptatum qui.	2025-08-07	Voluptates veritatis aspernatur quam vel.	2025-07-16	12:30	3	pending	APT10524	\N
9526	63	10	2025-07-16 16:15:00	Diabetes Check	OPD	Deleniti iste consectetur adipisci ut.	2025-06-26 22:30:08	2025-06-26 22:30:08	131/78	93	98.1	96	83	Quae excepturi voluptates et.	Minus occaecati fugit quos aperiam.	2025-07-28	Qui fugiat ipsa quidem ut.	2025-07-16	16:15	3	pending	APT10525	\N
9527	441	5	2025-07-16 14:15:00	Cough	New	Iste nobis dolore quod nisi.	2025-06-26 22:30:08	2025-06-26 22:30:08	116/60	70	99.7	99	63	Sed tempore error pariatur voluptatum.	Autem voluptas totam ullam atque.	2025-08-03	In perferendis deleniti at.	2025-07-16	14:15	3	pending	APT10526	\N
9528	114	10	2025-07-16 13:30:00	Skin Rash	OPD	Occaecati expedita numquam sunt laudantium.	2025-06-26 22:30:08	2025-06-26 22:30:08	133/79	71	98.9	96	58	Adipisci magnam voluptate minus.	Neque qui recusandae impedit nostrum itaque nemo.	2025-07-30	Architecto illo unde ipsa deserunt vitae dolore.	2025-07-16	13:30	3	pending	APT10527	\N
9529	338	6	2025-07-16 12:30:00	Routine Checkup	Follow-up	Sed voluptates laborum in.	2025-06-26 22:30:08	2025-06-26 22:30:08	126/87	69	98.3	96	69	Eveniet nihil error quidem eligendi.	Est error aliquid necessitatibus blanditiis laboriosam unde cupiditate.	2025-08-11	Quam quae aspernatur voluptatem culpa.	2025-07-16	12:30	3	pending	APT10528	\N
9530	198	9	2025-07-16 15:30:00	Back Pain	OPD	Rerum blanditiis corrupti doloremque cumque beatae.	2025-06-26 22:30:08	2025-06-26 22:30:08	103/75	66	100.3	98	66	Consectetur accusamus voluptatum expedita dolore cumque.	Minima minus occaecati iusto corrupti quia hic sapiente.	2025-07-30	Nobis reiciendis reprehenderit a.	2025-07-16	15:30	3	pending	APT10529	\N
9531	487	8	2025-07-16 11:45:00	Skin Rash	Follow-up	Numquam quidem distinctio voluptate.	2025-06-26 22:30:08	2025-06-26 22:30:08	131/72	85	97.8	100	68	Adipisci veritatis nisi aut.	Ea amet libero mollitia in quam ab illum rem sapiente optio.	2025-07-24	Voluptatem deleniti nobis doloribus harum consectetur.	2025-07-16	11:45	3	pending	APT10530	\N
9532	491	10	2025-07-16 12:30:00	Routine Checkup	Emergency	Culpa minus error rem amet.	2025-06-26 22:30:08	2025-06-26 22:30:08	121/76	99	97.9	99	74	Quidem nulla magnam. Illum laboriosam sapiente repellendus.	Eum facilis sit adipisci officia maxime.	2025-08-07	Natus deserunt voluptates at laborum.	2025-07-16	12:30	3	pending	APT10531	\N
9533	57	6	2025-07-16 15:00:00	Skin Rash	Emergency	Alias excepturi occaecati blanditiis fugiat minus.	2025-06-26 22:30:08	2025-06-26 22:30:08	106/80	92	100.3	98	81	Unde similique itaque laudantium totam quidem.	Dignissimos fugiat voluptate facere labore atque iure.	2025-07-30	Quod excepturi hic explicabo doloribus ab alias aliquam.	2025-07-16	15:00	3	pending	APT10532	\N
9534	463	9	2025-07-16 13:30:00	Back Pain	New	Dolorum eum nihil vero nobis repellat.	2025-06-26 22:30:08	2025-06-26 22:30:08	105/62	87	99.0	96	70	Dignissimos voluptate quia nihil illo accusantium.	Suscipit at fuga ipsa ipsa qui optio.	2025-07-29	Laborum accusamus ratione velit cum sint.	2025-07-16	13:30	3	pending	APT10533	\N
9535	386	10	2025-07-16 12:30:00	Fever	Follow-up	Non recusandae amet earum hic dolorum.	2025-06-26 22:30:08	2025-06-26 22:30:08	124/76	76	97.9	99	81	Nesciunt quidem voluptatum magnam enim.	Quasi nihil autem nemo beatae in natus.	2025-07-24	Quo quia temporibus consectetur sunt voluptatibus perspiciatis et.	2025-07-16	12:30	3	pending	APT10534	\N
9536	148	3	2025-07-16 13:15:00	Back Pain	New	Provident consequuntur saepe qui accusamus.	2025-06-26 22:30:08	2025-06-26 22:30:08	118/61	83	97.9	98	73	Ad facilis ab natus omnis eveniet.	Laboriosam qui ullam nemo facilis perferendis laborum tempore.	2025-08-02	Saepe natus ab repellendus alias excepturi.	2025-07-16	13:15	3	pending	APT10535	\N
9537	238	9	2025-07-16 16:00:00	Back Pain	Follow-up	Reiciendis fuga non accusantium iste cupiditate.	2025-06-26 22:30:08	2025-06-26 22:30:08	101/72	75	100.4	98	74	Recusandae minima nulla vitae dolorum.	Ad nobis accusamus quidem libero.	2025-07-23	Labore corrupti pariatur temporibus veniam.	2025-07-16	16:00	3	pending	APT10536	\N
9538	61	7	2025-07-16 12:30:00	Diabetes Check	New	Quo iure iusto.	2025-06-26 22:30:08	2025-06-26 22:30:08	120/87	85	100.5	96	70	Aspernatur debitis quidem laborum laudantium doloribus.	Molestias quam facilis non in a saepe maxime.	2025-08-10	Quibusdam doloremque quidem perspiciatis voluptatem totam facilis.	2025-07-16	12:30	3	pending	APT10537	\N
9539	68	10	2025-07-16 11:30:00	High BP	New	Culpa pariatur ex vero.	2025-06-26 22:30:08	2025-06-26 22:30:08	128/64	74	99.9	96	83	Sed reiciendis possimus a praesentium dolorum odit ea.	Aliquid excepturi ad expedita totam.	2025-08-11	Neque commodi quis possimus et.	2025-07-16	11:30	3	pending	APT10538	\N
9540	247	6	2025-07-17 16:15:00	Routine Checkup	New	Vitae corrupti libero harum dolores odit.	2025-06-26 22:30:08	2025-06-26 22:30:08	132/75	90	100.0	98	73	Nam voluptate aspernatur assumenda culpa.	Perferendis autem eaque quisquam eum perferendis modi ex nostrum.	2025-08-14	Quae fugiat a repellat quas fuga corporis recusandae.	2025-07-17	16:15	3	pending	APT10539	\N
9542	422	4	2025-07-17 16:15:00	Cough	New	Voluptate architecto corrupti.	2025-06-26 22:30:08	2025-06-26 22:30:08	119/83	65	98.7	100	72	Veniam ea rerum veritatis.	Architecto consectetur rerum culpa omnis praesentium.	2025-07-27	Nulla nam quibusdam fuga saepe.	2025-07-17	16:15	3	pending	APT10541	\N
9543	192	8	2025-07-17 13:15:00	Fever	Follow-up	Iusto maiores harum nobis atque cum totam commodi.	2025-06-26 22:30:08	2025-06-26 22:30:08	115/75	89	99.8	96	79	Officia quae eveniet incidunt.	Ipsa asperiores sapiente nihil iusto debitis tempora.	2025-08-12	Cumque ratione at minima itaque.	2025-07-17	13:15	3	pending	APT10542	\N
9544	231	4	2025-07-17 13:30:00	Cough	Emergency	Sint praesentium architecto quos odit odit soluta.	2025-06-26 22:30:08	2025-06-26 22:30:08	126/79	72	99.1	99	74	Eum veritatis facere itaque dolores exercitationem.	Recusandae amet sed recusandae similique aliquid.	2025-07-27	Dignissimos quibusdam sint nisi minus dolorum et.	2025-07-17	13:30	3	pending	APT10543	\N
9545	257	8	2025-07-17 16:30:00	Back Pain	Follow-up	Sed neque dolores deleniti.	2025-06-26 22:30:08	2025-06-26 22:30:08	104/70	89	98.2	99	67	Provident voluptatum ratione sunt adipisci quasi explicabo.	Similique quod dolores dolorem inventore repellendus autem totam qui.	2025-07-27	Quidem totam iure quibusdam sunt.	2025-07-17	16:30	3	pending	APT10544	\N
9546	223	4	2025-07-17 13:00:00	Back Pain	New	Numquam maiores doloremque dolorum nisi ad.	2025-06-26 22:30:08	2025-06-26 22:30:08	102/77	66	100.2	95	60	Sed voluptas nobis fugit tempore perferendis eum.	Odio sed perspiciatis aperiam esse quam laborum.	2025-08-02	Ex ab nihil vitae deserunt natus.	2025-07-17	13:00	3	pending	APT10545	\N
9547	246	10	2025-07-17 15:15:00	Skin Rash	Follow-up	Sint veritatis quis.	2025-06-26 22:30:08	2025-06-26 22:30:08	123/64	96	100.1	98	65	Corporis et adipisci repellendus.	Sed quod eaque provident id.	2025-08-11	Optio quis veniam architecto impedit officia.	2025-07-17	15:15	3	pending	APT10546	\N
9548	233	4	2025-07-17 14:00:00	Routine Checkup	Follow-up	Exercitationem vel quibusdam eum ea voluptate ad.	2025-06-26 22:30:08	2025-06-26 22:30:08	121/69	82	99.3	98	58	Sunt doloremque ipsam voluptatem quos maiores quam.	Itaque illum ipsa consequatur.	2025-08-10	Repellendus rerum dolor molestiae harum impedit iste exercitationem.	2025-07-17	14:00	3	pending	APT10547	\N
9549	384	9	2025-07-17 16:15:00	Fever	Follow-up	Minus a sapiente excepturi perferendis maxime.	2025-06-26 22:30:08	2025-06-26 22:30:08	100/79	97	99.0	98	77	Natus sunt ad exercitationem esse velit sed.	Doloribus recusandae dolores perspiciatis error ducimus ad atque dolores fugit molestiae.	2025-08-05	Beatae fugit et nisi perferendis molestiae error.	2025-07-17	16:15	3	pending	APT10548	\N
9550	179	10	2025-07-17 12:30:00	Fever	Follow-up	Libero ratione nihil culpa officiis possimus.	2025-06-26 22:30:08	2025-06-26 22:30:08	111/70	65	98.6	97	79	Necessitatibus accusamus adipisci aut et ex.	Accusantium explicabo cum similique quibusdam laboriosam.	2025-08-03	Vitae nulla omnis est excepturi ut consequatur.	2025-07-17	12:30	3	pending	APT10549	\N
9551	172	3	2025-07-17 15:00:00	Back Pain	OPD	Iure consectetur natus saepe ad dolorem.	2025-06-26 22:30:08	2025-06-26 22:30:08	109/84	99	100.0	97	82	Ut corporis laboriosam nesciunt.	Illo cum labore numquam expedita adipisci consequuntur cum.	2025-07-24	Enim assumenda recusandae vero blanditiis.	2025-07-17	15:00	3	pending	APT10550	\N
9552	342	7	2025-07-17 13:00:00	Fever	New	Asperiores cumque saepe sequi laborum corporis earum.	2025-06-26 22:30:08	2025-06-26 22:30:08	106/64	88	100.3	100	66	Error modi sapiente. Rem consequatur sint nisi maiores rem.	Eaque dicta doloremque magni quos dicta eveniet maxime.	2025-07-27	Iusto consectetur similique at sit.	2025-07-17	13:00	3	pending	APT10551	\N
9553	444	10	2025-07-17 14:00:00	Skin Rash	OPD	Voluptas reprehenderit aspernatur sunt sunt non saepe.	2025-06-26 22:30:08	2025-06-26 22:30:08	137/77	85	99.5	95	72	Numquam possimus temporibus facilis eius repellat facere.	Doloribus suscipit fugiat nihil consequatur repudiandae rerum nulla aut.	2025-08-05	Nemo omnis ipsum recusandae qui amet placeat.	2025-07-17	14:00	3	pending	APT10552	\N
9554	351	3	2025-07-17 14:30:00	Cough	Emergency	Dicta quo quia nihil.	2025-06-26 22:30:08	2025-06-26 22:30:08	137/90	81	98.2	98	67	Expedita eligendi molestias.	Cupiditate earum commodi incidunt sunt.	2025-07-25	Sed excepturi possimus.	2025-07-17	14:30	3	pending	APT10553	\N
9555	411	7	2025-07-17 12:30:00	Back Pain	New	Tenetur asperiores reprehenderit iste.	2025-06-26 22:30:08	2025-06-26 22:30:08	139/86	89	98.3	95	55	Minima molestiae eligendi voluptates.	Voluptatem exercitationem quas laudantium quibusdam.	2025-08-10	Eligendi amet nostrum quo.	2025-07-17	12:30	3	pending	APT10554	\N
9556	281	4	2025-07-17 11:45:00	Headache	OPD	Sequi ratione praesentium quasi voluptatum recusandae.	2025-06-26 22:30:08	2025-06-26 22:30:08	120/70	98	100.3	95	55	Molestias quis corrupti commodi quas voluptate.	Dolorum soluta itaque animi distinctio illum occaecati.	2025-07-28	Nobis alias ipsum distinctio.	2025-07-17	11:45	3	pending	APT10555	\N
9557	103	3	2025-07-17 15:30:00	Routine Checkup	Follow-up	Quam minus quisquam molestiae.	2025-06-26 22:30:08	2025-06-26 22:30:08	116/64	92	99.5	100	69	Repudiandae cum earum error harum.	Itaque perspiciatis rerum ipsa asperiores accusantium porro architecto.	2025-08-15	Laborum impedit incidunt dicta quae.	2025-07-17	15:30	3	pending	APT10556	\N
9558	444	5	2025-07-17 13:15:00	Cough	OPD	Sit officia possimus est aspernatur quasi.	2025-06-26 22:30:08	2025-06-26 22:30:08	123/62	77	97.7	95	76	Sed adipisci doloribus voluptates. Vitae sunt nobis.	Perferendis quis atque cupiditate necessitatibus modi.	2025-08-07	Ex voluptas dolore.	2025-07-17	13:15	3	pending	APT10557	\N
9559	5	3	2025-07-17 16:00:00	Diabetes Check	Emergency	Dolorem aliquam minima repellat animi.	2025-06-26 22:30:08	2025-06-26 22:30:08	110/62	84	98.8	96	77	Pariatur corporis minima facere ipsum voluptate.	Deleniti ipsam aliquam error saepe rerum labore quod qui laborum.	2025-08-08	Quia molestiae ducimus.	2025-07-17	16:00	3	pending	APT10558	\N
9560	290	7	2025-07-17 13:15:00	Back Pain	OPD	Omnis ullam voluptatum dignissimos quam deleniti.	2025-06-26 22:30:08	2025-06-26 22:30:08	106/63	69	99.0	97	66	Ipsum ea architecto nobis. Ex facilis rerum optio tempore.	Qui architecto natus esse harum ullam similique officiis.	2025-08-14	Necessitatibus reprehenderit sunt.	2025-07-17	13:15	3	pending	APT10559	\N
9561	32	9	2025-07-17 12:00:00	Routine Checkup	Follow-up	Ullam exercitationem ipsum ab deleniti sed vel magnam.	2025-06-26 22:30:08	2025-06-26 22:30:08	135/65	75	100.0	96	74	Veniam tenetur animi repellat.	Incidunt iusto in natus quam esse expedita aperiam corporis suscipit esse.	2025-08-14	Rem repellendus animi a laboriosam tenetur minus.	2025-07-17	12:00	3	pending	APT10560	\N
9562	163	6	2025-07-17 15:15:00	Headache	New	Alias reiciendis modi laboriosam ad est qui eos.	2025-06-26 22:30:08	2025-06-26 22:30:08	131/77	92	97.8	98	81	Dolores at saepe aut.	Explicabo nihil recusandae quas commodi perferendis.	2025-08-08	Quod quae non.	2025-07-17	15:15	3	pending	APT10561	\N
9563	404	10	2025-07-18 13:15:00	Skin Rash	New	Omnis sed dicta vero sequi.	2025-06-26 22:30:08	2025-06-26 22:30:08	122/66	72	98.7	95	62	Possimus alias illum provident ipsam iusto voluptatibus.	Facilis cum esse maiores consequatur.	2025-08-07	Impedit doloremque amet esse.	2025-07-18	13:15	3	pending	APT10562	\N
9564	287	7	2025-07-18 15:15:00	Routine Checkup	OPD	Consequatur culpa aliquam magni ex.	2025-06-26 22:30:08	2025-06-26 22:30:08	138/83	74	100.1	95	65	Dolor id debitis molestias.	Ex pariatur voluptatem hic eum minus culpa odit atque ratione.	2025-08-08	Est ipsam quisquam dignissimos commodi saepe.	2025-07-18	15:15	3	pending	APT10563	\N
9565	257	10	2025-07-18 14:45:00	Routine Checkup	Emergency	Placeat commodi sunt soluta tempore dolore.	2025-06-26 22:30:08	2025-06-26 22:30:08	118/79	90	97.9	99	78	Autem placeat quam accusamus possimus voluptatibus dicta.	Dolore tempora voluptates quibusdam aut optio repellendus eum doloremque dolorum.	2025-08-06	Odio quisquam quisquam doloribus qui magni.	2025-07-18	14:45	3	pending	APT10564	\N
9566	117	7	2025-07-18 14:45:00	High BP	OPD	Reprehenderit adipisci alias error.	2025-06-26 22:30:08	2025-06-26 22:30:08	112/71	68	99.4	96	68	Commodi voluptatem explicabo sed.	Porro laboriosam accusantium nemo quaerat nisi non voluptas non.	2025-08-14	Asperiores voluptas fugit beatae saepe necessitatibus optio.	2025-07-18	14:45	3	pending	APT10565	\N
9567	411	9	2025-07-18 13:15:00	Back Pain	OPD	Alias atque numquam est.	2025-06-26 22:30:08	2025-06-26 22:30:08	122/79	93	98.3	99	77	Corrupti officiis vel fugiat labore maiores id.	Cum in quas harum similique optio nostrum quaerat vero libero.	2025-08-02	Quia ipsam recusandae.	2025-07-18	13:15	3	pending	APT10566	\N
9568	226	9	2025-07-18 16:15:00	Routine Checkup	Emergency	Ullam nemo fugit dolorem praesentium.	2025-06-26 22:30:08	2025-06-26 22:30:08	106/81	100	97.7	97	82	Deleniti maiores occaecati dolorem aliquam id.	Illum beatae sed voluptates delectus id a alias.	2025-08-13	Pariatur saepe ab eos.	2025-07-18	16:15	3	pending	APT10567	\N
9569	376	3	2025-07-18 12:15:00	Cough	Emergency	Unde dicta quos dolor.	2025-06-26 22:30:08	2025-06-26 22:30:08	105/90	94	99.5	100	76	Earum molestiae voluptate quos.	Libero praesentium laudantium ut assumenda eveniet voluptas.	2025-08-10	Minus ex enim consectetur molestias impedit.	2025-07-18	12:15	3	pending	APT10568	\N
9570	291	5	2025-07-18 13:30:00	Routine Checkup	Emergency	Atque eos voluptatibus ad voluptas mollitia magni animi.	2025-06-26 22:30:08	2025-06-26 22:30:08	103/78	97	100.4	96	81	Adipisci beatae dolore eaque beatae explicabo cumque.	Pariatur nisi sit sint cupiditate blanditiis occaecati.	2025-08-11	Distinctio blanditiis architecto esse.	2025-07-18	13:30	3	pending	APT10569	\N
9571	339	4	2025-07-18 16:45:00	Skin Rash	Follow-up	Ipsum et exercitationem vel ea illum totam.	2025-06-26 22:30:08	2025-06-26 22:30:08	134/73	90	98.5	99	85	Reprehenderit facilis consequatur pariatur.	Libero modi exercitationem enim nostrum est.	2025-08-02	Iusto cum id nulla debitis omnis.	2025-07-18	16:45	3	pending	APT10570	\N
9572	48	5	2025-07-18 12:45:00	Cough	OPD	Quos molestias ex consequatur error dolorem commodi tempora.	2025-06-26 22:30:08	2025-06-26 22:30:08	124/71	88	99.1	100	84	Et blanditiis molestiae veniam nesciunt laboriosam.	Optio molestiae nisi debitis temporibus aliquid.	2025-08-01	Assumenda neque inventore.	2025-07-18	12:45	3	pending	APT10571	\N
9573	5	5	2025-07-18 12:30:00	Headache	New	Delectus dicta ea cumque iure amet doloribus minima.	2025-06-26 22:30:08	2025-06-26 22:30:08	132/61	93	97.7	98	57	Alias veritatis nihil porro quibusdam.	Quidem labore minima aliquam dolores velit magnam.	2025-07-29	Sequi explicabo nemo animi corrupti fuga nam.	2025-07-18	12:30	3	pending	APT10572	\N
9574	345	3	2025-07-18 15:00:00	Back Pain	Emergency	Possimus dolorum mollitia nam corrupti nostrum.	2025-06-26 22:30:08	2025-06-26 22:30:08	125/80	71	98.5	96	61	Sequi quaerat quam nihil.	Earum harum recusandae molestias dignissimos eos suscipit doloribus porro.	2025-07-29	Reiciendis nostrum assumenda repellat.	2025-07-18	15:00	3	pending	APT10573	\N
9575	211	6	2025-07-18 12:15:00	Fever	OPD	Dolorem architecto recusandae est.	2025-06-26 22:30:08	2025-06-26 22:30:08	118/74	69	99.5	97	58	Tempora natus numquam voluptatem.	Architecto aliquam aliquam corporis dolore.	2025-07-26	Iste eius tempore sed.	2025-07-18	12:15	3	pending	APT10574	\N
9576	248	7	2025-07-18 12:00:00	Fever	Follow-up	Veritatis voluptate quasi sequi corporis sed eum.	2025-06-26 22:30:08	2025-06-26 22:30:08	102/67	95	100.1	98	84	Est ipsam odit quia consequatur debitis.	Consectetur asperiores repellat inventore quisquam suscipit.	2025-08-09	Quo ut veniam consectetur.	2025-07-18	12:00	3	pending	APT10575	\N
9577	2	9	2025-07-18 13:15:00	Skin Rash	OPD	Commodi laudantium nemo dolores non temporibus numquam.	2025-06-26 22:30:08	2025-06-26 22:30:08	101/70	79	100.3	96	55	Error dolorum ipsa deserunt molestias delectus fuga.	Tenetur odit dolores asperiores nisi laboriosam optio aliquam eveniet excepturi.	2025-07-25	Consectetur minima fuga assumenda.	2025-07-18	13:15	3	pending	APT10576	\N
9578	261	3	2025-07-18 15:00:00	Headache	Follow-up	Earum error animi sapiente molestiae cum alias.	2025-06-26 22:30:08	2025-06-26 22:30:08	137/85	99	99.5	100	73	Laudantium optio libero ullam.	Omnis eius soluta commodi rerum ipsa.	2025-08-03	Animi sapiente minima sunt cupiditate laborum.	2025-07-18	15:00	3	pending	APT10577	\N
9579	247	6	2025-07-18 13:30:00	High BP	Emergency	Perspiciatis doloremque deserunt suscipit itaque.	2025-06-26 22:30:08	2025-06-26 22:30:08	137/84	75	100.1	100	74	Delectus quasi quia ipsa harum. Accusamus veniam rem fugit.	Ipsa corporis dolore necessitatibus tempora facilis.	2025-08-07	Nisi voluptas minima quod fuga ducimus.	2025-07-18	13:30	3	pending	APT10578	\N
9580	61	4	2025-07-18 16:15:00	Skin Rash	OPD	Cum incidunt veritatis fugit rem tempore.	2025-06-26 22:30:08	2025-06-26 22:30:08	123/73	78	99.0	97	67	Vero aut quo exercitationem saepe soluta.	Facere nisi ullam ratione odio dolores.	2025-07-31	Amet adipisci at sequi itaque vel corporis.	2025-07-18	16:15	3	pending	APT10579	\N
9581	472	6	2025-07-18 11:00:00	Headache	Follow-up	Impedit ipsam architecto velit culpa molestiae.	2025-06-26 22:30:08	2025-06-26 22:30:08	133/78	88	99.4	98	80	Optio alias labore aut debitis.	Ullam ut amet esse atque fugiat quia ex non.	2025-08-16	Tempora quod quidem repudiandae ipsam.	2025-07-18	11:00	3	pending	APT10580	\N
9582	66	4	2025-07-18 12:30:00	Cough	Follow-up	Adipisci iusto ab autem vitae.	2025-06-26 22:30:08	2025-06-26 22:30:08	139/90	93	97.6	99	56	A distinctio veritatis distinctio. Totam ea dolores sint.	Quo itaque deserunt veniam maiores ipsum assumenda eum.	2025-08-16	Consequuntur quos illum totam consequuntur.	2025-07-18	12:30	3	pending	APT10581	\N
9583	211	8	2025-07-19 13:45:00	High BP	Emergency	Necessitatibus atque eligendi illo.	2025-06-26 22:30:08	2025-06-26 22:30:08	135/66	92	100.4	98	67	Odio repudiandae quasi dolorum qui.	Eaque saepe reprehenderit libero incidunt adipisci.	2025-07-31	Magnam eveniet soluta adipisci aspernatur facilis voluptatibus dolorum.	2025-07-19	13:45	3	pending	APT10582	\N
9584	88	3	2025-07-19 16:15:00	High BP	OPD	Omnis quos necessitatibus accusantium nemo nemo distinctio.	2025-06-26 22:30:08	2025-06-26 22:30:08	127/70	81	100.2	98	79	Sit eveniet consequuntur officia et.	Vero odit quas omnis rem libero esse.	2025-07-28	Corporis laudantium itaque ipsa vero.	2025-07-19	16:15	3	pending	APT10583	\N
9585	307	8	2025-07-19 15:30:00	Cough	Follow-up	At quidem temporibus sequi asperiores incidunt ex iste.	2025-06-26 22:30:08	2025-06-26 22:30:08	102/66	73	99.8	97	65	Quia unde id doloribus in quisquam animi.	Totam id eveniet dolore praesentium cupiditate a quis.	2025-08-06	Labore cupiditate sed repellendus.	2025-07-19	15:30	3	pending	APT10584	\N
9586	33	10	2025-07-19 15:00:00	Cough	New	Amet dolore corrupti dolorem cumque.	2025-06-26 22:30:08	2025-06-26 22:30:08	123/89	87	98.5	95	72	Dolor consequuntur soluta officiis.	Fuga hic dolor nostrum dignissimos dolores velit fuga.	2025-07-27	Alias adipisci veniam beatae totam voluptate qui.	2025-07-19	15:00	3	pending	APT10585	\N
9587	302	6	2025-07-19 16:45:00	Fever	Follow-up	Accusantium ab amet earum sint molestias.	2025-06-26 22:30:08	2025-06-26 22:30:08	131/65	75	100.0	96	70	Eum officia eveniet dolores voluptatibus eligendi.	Qui laborum laudantium eaque aspernatur quia harum quis.	2025-08-13	Modi facere cum.	2025-07-19	16:45	3	pending	APT10586	\N
9588	493	8	2025-07-19 12:00:00	Skin Rash	OPD	Labore nihil rerum porro.	2025-06-26 22:30:08	2025-06-26 22:30:08	107/66	76	99.1	98	58	Deserunt quo officia dolor at.	Illum atque a qui iure eius minus doloribus deserunt ducimus.	2025-08-05	Maiores veritatis corporis saepe.	2025-07-19	12:00	3	pending	APT10587	\N
9589	46	3	2025-07-19 16:30:00	Fever	Emergency	Officiis error quibusdam.	2025-06-26 22:30:08	2025-06-26 22:30:08	122/67	98	98.4	100	62	Iste error rem perspiciatis libero.	Laboriosam perferendis assumenda optio facere.	2025-07-30	Nobis quia dolore autem consequuntur.	2025-07-19	16:30	3	pending	APT10588	\N
9590	364	3	2025-07-19 14:00:00	Skin Rash	Follow-up	Voluptas earum omnis tempora inventore.	2025-06-26 22:30:08	2025-06-26 22:30:08	137/86	97	99.1	95	66	Ratione voluptatibus expedita sint sed.	Recusandae reprehenderit unde error voluptas voluptatibus neque quos molestias.	2025-07-29	Ea veritatis natus amet culpa.	2025-07-19	14:00	3	pending	APT10589	\N
9591	154	3	2025-07-19 16:00:00	High BP	New	Maiores adipisci tenetur placeat quos.	2025-06-26 22:30:08	2025-06-26 22:30:08	135/90	99	99.6	97	82	Deleniti corrupti amet alias fuga facilis iure.	Sed est deserunt eos iusto incidunt rerum.	2025-08-06	Vero corrupti est cupiditate.	2025-07-19	16:00	3	pending	APT10590	\N
9592	30	6	2025-07-19 15:45:00	Diabetes Check	OPD	Modi sed quibusdam error totam ut.	2025-06-26 22:30:08	2025-06-26 22:30:08	112/64	92	97.7	97	74	Ratione deleniti veniam neque nam nesciunt accusantium.	Facilis id optio voluptatem optio amet eligendi.	2025-08-14	Impedit deleniti enim quaerat eum.	2025-07-19	15:45	3	pending	APT10591	\N
9593	25	8	2025-07-19 12:45:00	Routine Checkup	Follow-up	Quasi eligendi earum reiciendis unde voluptas.	2025-06-26 22:30:08	2025-06-26 22:30:08	113/83	94	98.8	97	83	Numquam ullam rerum est deleniti.	Maxime hic ipsam unde nisi veritatis hic praesentium.	2025-08-14	Iure vero rem officiis officia beatae culpa.	2025-07-19	12:45	3	pending	APT10592	\N
9594	437	7	2025-07-19 14:00:00	Headache	New	Voluptatem tempore consequuntur debitis at alias.	2025-06-26 22:30:08	2025-06-26 22:30:08	128/83	73	100.4	100	75	Tempore molestiae reprehenderit.	Temporibus architecto id ex tempora voluptatum dolorum ipsam.	2025-08-02	Commodi molestias odit similique vitae.	2025-07-19	14:00	3	pending	APT10593	\N
9595	50	6	2025-07-19 14:15:00	Skin Rash	New	Perferendis consectetur eligendi accusantium laudantium sapiente ex.	2025-06-26 22:30:08	2025-06-26 22:30:08	114/73	66	99.8	98	56	Molestias dolorum reprehenderit repudiandae.	Eius blanditiis aliquid dicta aliquam quasi accusantium architecto.	2025-07-30	Excepturi aliquam ab quam tempora eum.	2025-07-19	14:15	3	pending	APT10594	\N
9596	316	8	2025-07-19 11:15:00	Skin Rash	Follow-up	Ipsum temporibus enim non.	2025-06-26 22:30:08	2025-06-26 22:30:08	114/88	67	99.8	98	60	Optio earum ex accusamus minus nobis.	Unde cum deleniti iure nisi eaque vero.	2025-07-28	Quod debitis ducimus rem.	2025-07-19	11:15	3	pending	APT10595	\N
9597	114	5	2025-07-19 12:00:00	Cough	Follow-up	Ullam nostrum dolore omnis.	2025-06-26 22:30:08	2025-06-26 22:30:08	127/89	100	99.5	100	84	Facilis accusantium magni id quod voluptatum suscipit.	Nemo incidunt minus quibusdam libero modi quo alias quas similique.	2025-08-13	Voluptates sit quam atque distinctio occaecati quia.	2025-07-19	12:00	3	pending	APT10596	\N
9598	136	8	2025-07-19 14:15:00	High BP	OPD	Dolor provident at.	2025-06-26 22:30:08	2025-06-26 22:30:08	138/70	88	99.5	96	56	Aspernatur voluptate ea occaecati.	Molestias dignissimos veritatis voluptate distinctio earum voluptatibus.	2025-08-07	Incidunt atque quae repellat in perferendis sapiente.	2025-07-19	14:15	3	pending	APT10597	\N
9599	193	6	2025-07-19 15:15:00	Skin Rash	OPD	Cumque aliquam ab reiciendis.	2025-06-26 22:30:08	2025-06-26 22:30:08	139/63	73	98.1	96	83	Similique nihil perspiciatis enim sed ea.	Adipisci quos odit perspiciatis reiciendis est sunt.	2025-08-06	Libero distinctio temporibus rem illum.	2025-07-19	15:15	3	pending	APT10598	\N
9600	4	8	2025-07-19 11:15:00	Fever	New	Doloribus quaerat neque ea.	2025-06-26 22:30:08	2025-06-26 22:30:08	107/89	69	100.1	96	72	Necessitatibus impedit labore.	Nostrum voluptatum perferendis aperiam odio ad tenetur culpa voluptates.	2025-08-18	Error consequatur exercitationem maiores corporis.	2025-07-19	11:15	3	pending	APT10599	\N
9601	236	10	2025-07-19 15:30:00	Cough	Emergency	Possimus occaecati culpa dolor ratione.	2025-06-26 22:30:08	2025-06-26 22:30:08	128/77	68	97.7	98	61	Nostrum dicta iste commodi quaerat.	Minus placeat aspernatur quos doloremque voluptatibus minima repudiandae.	2025-08-14	Reprehenderit voluptas animi facere maiores atque.	2025-07-19	15:30	3	pending	APT10600	\N
9602	123	7	2025-07-19 16:15:00	Cough	Emergency	Dolorum doloremque a eaque.	2025-06-26 22:30:08	2025-06-26 22:30:08	100/69	94	100.5	98	61	Dolores quam veritatis alias eius autem corrupti facere.	Fugit corrupti quas vero necessitatibus eligendi tenetur a quo.	2025-08-07	Nisi cumque ex eaque quidem excepturi vero voluptas.	2025-07-19	16:15	3	pending	APT10601	\N
9603	422	10	2025-07-19 14:00:00	Headache	Emergency	Voluptate neque qui inventore maxime.	2025-06-26 22:30:08	2025-06-26 22:30:08	107/76	71	100.0	98	71	Laboriosam occaecati alias quasi.	Dolore blanditiis hic vitae officiis ipsam.	2025-08-12	Iure animi soluta.	2025-07-19	14:00	3	pending	APT10602	\N
9604	342	9	2025-07-19 14:00:00	Back Pain	OPD	Illo dolor sapiente dignissimos molestias ut.	2025-06-26 22:30:08	2025-06-26 22:30:08	114/74	78	99.2	99	56	At porro odio vero. Temporibus amet laudantium inventore.	Natus beatae quasi tempora necessitatibus.	2025-08-15	Voluptatibus iste consequuntur ratione impedit maxime pariatur.	2025-07-19	14:00	3	pending	APT10603	\N
9605	288	9	2025-07-19 15:45:00	Skin Rash	OPD	Provident eius voluptates iusto dolor.	2025-06-26 22:30:08	2025-06-26 22:30:08	108/74	79	99.3	95	58	Animi consequatur aliquid ratione at maxime totam.	Dignissimos voluptate molestiae amet vero natus minus reprehenderit veritatis quasi.	2025-07-30	Ratione nesciunt ea ab eos dolorem suscipit.	2025-07-19	15:45	3	pending	APT10604	\N
9606	353	7	2025-07-19 16:00:00	High BP	Follow-up	Corrupti molestiae ex.	2025-06-26 22:30:08	2025-06-26 22:30:08	114/80	87	99.0	99	69	Sint commodi perferendis non rem. Iure doloremque ipsum.	Fugiat delectus corporis minima dolor totam.	2025-08-01	Vero accusamus tenetur eveniet consequatur quo.	2025-07-19	16:00	3	pending	APT10605	\N
9607	466	6	2025-07-19 15:45:00	Cough	OPD	In incidunt facilis sint sapiente qui.	2025-06-26 22:30:08	2025-06-26 22:30:08	131/60	86	100.2	95	78	Repudiandae ad libero ea.	Praesentium sunt quod velit quam omnis fuga sapiente explicabo.	2025-07-29	Alias aut eum vero sint eligendi.	2025-07-19	15:45	3	pending	APT10606	\N
9608	214	6	2025-07-19 12:15:00	Diabetes Check	OPD	Cum impedit sunt.	2025-06-26 22:30:08	2025-06-26 22:30:08	111/76	90	100.2	100	57	Recusandae sit vero quos itaque. Voluptas nemo nihil unde.	Reprehenderit sunt debitis impedit laudantium deleniti molestiae.	2025-07-28	Eius doloremque occaecati.	2025-07-19	12:15	3	pending	APT10607	\N
9609	306	3	2025-07-19 11:45:00	Diabetes Check	New	Minima odit voluptatum magnam maxime sint in.	2025-06-26 22:30:08	2025-06-26 22:30:08	129/63	71	100.3	95	70	Dicta totam ipsa.	Animi totam vitae maiores necessitatibus voluptate eos iusto modi quo culpa.	2025-08-17	Laboriosam aliquam assumenda facilis in aliquam minus.	2025-07-19	11:45	3	pending	APT10608	\N
9610	435	9	2025-07-20 13:45:00	Headache	Follow-up	Quisquam pariatur voluptatum expedita.	2025-06-26 22:30:08	2025-06-26 22:30:08	119/73	72	99.7	98	57	Quia quae iure. Cumque magnam aliquid id.	Iste sequi aut odio esse in minus alias quaerat ullam.	2025-08-03	Inventore tenetur ab ipsum.	2025-07-20	13:45	3	pending	APT10609	\N
9611	205	9	2025-07-20 16:30:00	Skin Rash	Follow-up	Commodi reiciendis iste quasi.	2025-06-26 22:30:08	2025-06-26 22:30:08	127/88	84	100.4	100	61	Blanditiis quo asperiores laborum odio.	Odit accusamus reiciendis repudiandae exercitationem non delectus.	2025-08-16	Earum dignissimos ad iste facere.	2025-07-20	16:30	3	pending	APT10610	\N
9612	449	7	2025-07-20 16:15:00	Back Pain	New	Tempore ad optio.	2025-06-26 22:30:08	2025-06-26 22:30:08	131/89	94	98.7	98	79	Ea quae optio molestias error.	Temporibus quis porro eos quia ipsam fuga.	2025-08-13	Ipsa laborum ad sequi corrupti iste tempora.	2025-07-20	16:15	3	pending	APT10611	\N
9613	16	6	2025-07-20 16:45:00	Diabetes Check	OPD	Beatae praesentium perferendis praesentium animi vel fuga dolorem.	2025-06-26 22:30:08	2025-06-26 22:30:08	100/89	81	99.7	96	72	Quis consequatur molestias mollitia at.	Suscipit provident quisquam fugiat distinctio.	2025-08-16	Aliquam labore suscipit distinctio exercitationem aliquam.	2025-07-20	16:45	3	pending	APT10612	\N
9614	152	6	2025-07-20 16:45:00	Fever	OPD	Sed porro beatae et.	2025-06-26 22:30:08	2025-06-26 22:30:08	116/66	67	99.1	95	85	Alias perferendis enim excepturi pariatur ducimus qui.	Illo unde modi est accusamus aliquid commodi accusamus magnam.	2025-08-05	Reiciendis veniam repudiandae.	2025-07-20	16:45	3	pending	APT10613	\N
9615	173	8	2025-07-20 15:15:00	High BP	New	Quo recusandae esse doloremque impedit ipsam.	2025-06-26 22:30:08	2025-06-26 22:30:08	100/70	91	97.8	95	58	Dolores alias eaque temporibus.	Quisquam ipsum sapiente minus quisquam perspiciatis.	2025-08-02	Voluptates a harum itaque ea.	2025-07-20	15:15	3	pending	APT10614	\N
9616	161	10	2025-07-20 16:45:00	Back Pain	New	Fugiat autem magni quis sunt dolor iste.	2025-06-26 22:30:08	2025-06-26 22:30:08	130/73	76	99.1	95	76	Maxime impedit totam voluptates.	Fuga eos quae laudantium vero ex.	2025-08-01	Culpa ipsam iusto iste excepturi facilis molestiae.	2025-07-20	16:45	3	pending	APT10615	\N
9617	392	9	2025-07-20 11:00:00	Diabetes Check	OPD	Saepe odit hic.	2025-06-26 22:30:08	2025-06-26 22:30:08	111/64	66	97.5	98	83	Ipsam eaque atque.	Quidem reiciendis alias assumenda nisi amet.	2025-08-11	Excepturi natus ullam fugiat odio.	2025-07-20	11:00	3	pending	APT10616	\N
9618	422	4	2025-07-20 16:45:00	Cough	Emergency	Sapiente molestiae esse tenetur expedita est ducimus nesciunt.	2025-06-26 22:30:08	2025-06-26 22:30:08	123/79	83	98.1	99	80	Incidunt inventore laboriosam vitae nostrum illo.	Iure accusantium enim excepturi hic doloremque magnam officia doloremque.	2025-08-16	Laborum numquam totam minima dolorum exercitationem tempora.	2025-07-20	16:45	3	pending	APT10617	\N
9619	3	10	2025-07-20 14:45:00	Back Pain	Emergency	Esse quam perferendis dolor esse minima dolore.	2025-06-26 22:30:08	2025-06-26 22:30:08	118/83	100	100.0	99	66	Doloribus voluptates cupiditate nostrum fugiat.	Maiores ducimus labore voluptatem voluptates odio.	2025-08-13	Ut illum quae.	2025-07-20	14:45	3	pending	APT10618	\N
9620	17	7	2025-07-20 12:15:00	Headache	Emergency	Et iste a laboriosam esse impedit ducimus est.	2025-06-26 22:30:08	2025-06-26 22:30:08	112/83	87	99.4	99	78	Hic hic vitae ab in eius. Natus iste molestiae occaecati.	Magni est error harum mollitia quibusdam molestias et nostrum molestias.	2025-07-31	Molestias soluta corporis delectus esse reprehenderit.	2025-07-20	12:15	3	pending	APT10619	\N
9621	443	10	2025-07-20 15:30:00	Cough	New	Aliquam amet deserunt sunt possimus fuga.	2025-06-26 22:30:08	2025-06-26 22:30:08	124/67	91	99.2	98	73	Autem itaque assumenda quo illo.	Ut vero magni ad labore maxime nobis in doloremque et.	2025-08-10	Aut fugit in nobis pariatur.	2025-07-20	15:30	3	pending	APT10620	\N
9622	182	10	2025-07-20 12:00:00	Diabetes Check	Emergency	Voluptatum beatae ab necessitatibus voluptate architecto.	2025-06-26 22:30:08	2025-06-26 22:30:08	125/88	84	100.1	95	62	Provident voluptatibus rem libero quas vero vero.	Libero non accusamus voluptatem ducimus aut autem dolorum praesentium.	2025-07-27	Explicabo culpa fuga tempore quo eos ipsum.	2025-07-20	12:00	3	pending	APT10621	\N
9623	185	7	2025-07-20 12:15:00	Back Pain	Follow-up	Repellendus laudantium nam placeat asperiores.	2025-06-26 22:30:08	2025-06-26 22:30:08	123/73	86	98.1	100	64	Nam ex quia vel sapiente minima ab vitae.	Natus laboriosam sed facilis dignissimos voluptates dignissimos perferendis.	2025-08-13	Quibusdam reprehenderit dolores quaerat laborum atque.	2025-07-20	12:15	3	pending	APT10622	\N
9624	468	6	2025-07-20 16:45:00	Headache	Emergency	Voluptates nostrum reiciendis et amet vel.	2025-06-26 22:30:08	2025-06-26 22:30:08	118/80	90	99.0	95	83	Cupiditate numquam facere est cumque.	Perferendis itaque fugit voluptas magnam.	2025-07-29	Molestiae cupiditate perspiciatis corporis.	2025-07-20	16:45	3	pending	APT10623	\N
9625	220	3	2025-07-20 11:45:00	Skin Rash	Follow-up	Tenetur a fuga laborum eos.	2025-06-26 22:30:08	2025-06-26 22:30:08	106/64	80	98.3	96	74	Nesciunt exercitationem aperiam.	Dolore sequi quisquam consequuntur quibusdam ab harum molestiae nesciunt incidunt.	2025-08-03	Nesciunt suscipit molestiae voluptates quod unde.	2025-07-20	11:45	3	pending	APT10624	\N
9626	349	7	2025-07-20 13:15:00	Back Pain	Emergency	Modi laboriosam occaecati dignissimos rerum accusantium.	2025-06-26 22:30:08	2025-06-26 22:30:08	110/61	81	97.6	97	68	Commodi illum quae ea impedit animi veritatis natus.	Explicabo aperiam porro molestias enim repellat laborum quo occaecati.	2025-08-01	Unde voluptate dicta aliquam corporis vitae delectus.	2025-07-20	13:15	3	pending	APT10625	\N
9627	11	7	2025-07-20 14:00:00	Skin Rash	OPD	Neque repellendus culpa cupiditate.	2025-06-26 22:30:08	2025-06-26 22:30:08	102/65	90	97.9	97	73	Modi quos corrupti distinctio autem error.	Natus mollitia similique sit molestias eius.	2025-07-29	Libero culpa facilis debitis.	2025-07-20	14:00	3	pending	APT10626	\N
9628	409	6	2025-07-20 16:30:00	Cough	Follow-up	Quam cumque molestiae.	2025-06-26 22:30:08	2025-06-26 22:30:08	112/71	85	98.0	99	70	Recusandae dolorum vitae fugit omnis. Ipsam eos iusto quae.	Cumque molestias repellat accusantium deserunt molestias commodi maxime alias maiores.	2025-07-28	Cum blanditiis ex voluptatum amet maxime atque.	2025-07-20	16:30	3	pending	APT10627	\N
9629	115	10	2025-07-20 13:15:00	Skin Rash	Follow-up	Temporibus similique vel labore debitis.	2025-06-26 22:30:08	2025-06-26 22:30:08	118/85	72	98.5	100	79	At error quidem dolores. Debitis laudantium vel possimus.	Distinctio ipsam eveniet qui maiores.	2025-07-27	Nesciunt perspiciatis consectetur blanditiis.	2025-07-20	13:15	3	pending	APT10628	\N
9630	492	3	2025-07-20 14:00:00	Back Pain	OPD	Autem necessitatibus ex iste sapiente repellendus consequuntur.	2025-06-26 22:30:08	2025-06-26 22:30:08	134/82	73	99.3	97	82	Dolor alias soluta voluptatem ab quisquam.	Nihil laboriosam odit dolorem delectus ut voluptas dolore minima quidem.	2025-08-18	Veritatis perspiciatis error qui sapiente eveniet.	2025-07-20	14:00	3	pending	APT10629	\N
9631	328	5	2025-07-20 13:30:00	Diabetes Check	Emergency	Exercitationem recusandae asperiores exercitationem ex.	2025-06-26 22:30:08	2025-06-26 22:30:08	124/60	97	97.8	98	56	Voluptatem a ut nam. Est qui veritatis ea.	Numquam provident molestiae repellat a soluta explicabo quam.	2025-07-30	Perferendis beatae facilis sequi.	2025-07-20	13:30	3	pending	APT10630	\N
9632	449	9	2025-07-20 16:30:00	Routine Checkup	Follow-up	Mollitia ad exercitationem porro quod ipsa.	2025-06-26 22:30:08	2025-06-26 22:30:08	107/76	72	98.0	100	83	Blanditiis tenetur quasi porro exercitationem sed neque.	Ratione a praesentium temporibus repellat nulla.	2025-08-16	Ipsum id eum possimus.	2025-07-20	16:30	3	pending	APT10631	\N
9633	212	4	2025-07-20 11:00:00	Back Pain	OPD	Eveniet labore ullam esse dolorem iste.	2025-06-26 22:30:08	2025-06-26 22:30:08	119/87	83	99.8	96	68	Laudantium autem aspernatur at.	Temporibus deleniti possimus asperiores assumenda maxime harum.	2025-07-30	Dignissimos eius reiciendis sit velit recusandae dolorum totam.	2025-07-20	11:00	3	pending	APT10632	\N
9634	176	3	2025-07-21 12:45:00	Headache	Follow-up	Ipsum placeat optio sint necessitatibus quae.	2025-06-26 22:30:08	2025-06-26 22:30:08	140/80	93	98.0	98	70	Eius libero expedita quam saepe eveniet earum.	Consectetur unde ipsam dolores pariatur blanditiis.	2025-08-15	Praesentium fuga magni enim quis id aperiam.	2025-07-21	12:45	3	pending	APT10633	\N
9635	365	7	2025-07-21 16:30:00	Routine Checkup	OPD	Ullam iste excepturi ipsa id.	2025-06-26 22:30:08	2025-06-26 22:30:08	109/68	99	99.6	100	68	Porro reiciendis aspernatur sed.	Suscipit inventore minus ullam eveniet doloribus error.	2025-07-29	Aliquam nemo fugiat dignissimos unde.	2025-07-21	16:30	3	pending	APT10634	\N
9636	151	10	2025-07-21 11:30:00	Fever	Emergency	Nostrum quaerat reiciendis voluptate doloremque nostrum eum.	2025-06-26 22:30:08	2025-06-26 22:30:08	104/63	96	97.9	95	58	In dicta animi nisi.	Dignissimos amet praesentium laborum illo doloremque maiores dolorem facere.	2025-07-31	Saepe vel sint voluptatibus sunt.	2025-07-21	11:30	3	pending	APT10635	\N
9637	169	9	2025-07-21 15:45:00	Routine Checkup	New	Veniam eum occaecati consectetur aliquam veritatis.	2025-06-26 22:30:08	2025-06-26 22:30:08	114/76	98	99.3	97	79	Quod ipsam dolorum corrupti ad.	Asperiores fugit est ab eaque architecto nemo culpa reiciendis.	2025-08-08	Nesciunt eaque dicta.	2025-07-21	15:45	3	pending	APT10636	\N
9638	261	10	2025-07-21 16:30:00	Routine Checkup	Emergency	Officiis quisquam ex eum.	2025-06-26 22:30:08	2025-06-26 22:30:08	139/81	74	100.0	98	58	Expedita sequi dignissimos sint ipsum ipsa delectus.	Praesentium est provident suscipit hic.	2025-08-18	Vitae eum expedita.	2025-07-21	16:30	3	pending	APT10637	\N
9639	65	4	2025-07-21 15:00:00	Skin Rash	OPD	Soluta consequatur voluptate nesciunt tenetur fuga.	2025-06-26 22:30:08	2025-06-26 22:30:08	127/85	88	100.1	95	65	Esse deleniti repellendus libero id maxime.	Quo omnis corporis minima.	2025-07-31	Porro earum facilis debitis.	2025-07-21	15:00	3	pending	APT10638	\N
9640	490	5	2025-07-21 13:15:00	Skin Rash	OPD	Velit ducimus laudantium vel nesciunt pariatur totam.	2025-06-26 22:30:08	2025-06-26 22:30:08	139/74	91	99.6	95	78	Vero error aspernatur. Possimus soluta maxime cum.	Hic quaerat consectetur modi quisquam a unde repudiandae.	2025-07-29	Eveniet laborum accusantium deleniti beatae voluptatem temporibus dicta.	2025-07-21	13:15	3	pending	APT10639	\N
9641	224	6	2025-07-21 13:15:00	Skin Rash	Emergency	Pariatur voluptate ipsa.	2025-06-26 22:30:08	2025-06-26 22:30:08	105/67	77	100.0	99	78	Tempora fugit harum quos nesciunt a.	Consectetur aliquid provident incidunt quia suscipit consectetur.	2025-08-06	Repudiandae alias vitae nemo unde.	2025-07-21	13:15	3	pending	APT10640	\N
9642	440	8	2025-07-21 16:00:00	Cough	Follow-up	Eligendi fuga blanditiis nemo dolorem ex.	2025-06-26 22:30:08	2025-06-26 22:30:08	129/61	87	100.1	98	55	Ullam iste ad eaque earum assumenda.	Voluptatibus quidem et eveniet consectetur deleniti modi omnis.	2025-08-11	Magnam accusantium at iure repellendus quia.	2025-07-21	16:00	3	pending	APT10641	\N
9643	41	9	2025-07-21 14:00:00	Cough	Emergency	Omnis laudantium modi reprehenderit numquam.	2025-06-26 22:30:08	2025-06-26 22:30:08	129/66	82	98.9	95	84	Quia nobis ipsum earum sint amet voluptatem.	Totam vitae expedita et natus maiores voluptatibus laborum ipsam.	2025-08-07	Dolorum laborum amet adipisci reiciendis.	2025-07-21	14:00	3	pending	APT10642	\N
9644	99	5	2025-07-21 11:00:00	Cough	New	Odit nam recusandae illo.	2025-06-26 22:30:08	2025-06-26 22:30:08	140/67	68	100.3	97	77	Nemo nisi corrupti similique. Facilis placeat ut.	Harum iste laborum culpa veritatis ea.	2025-08-11	Corrupti dolorum voluptatem saepe soluta.	2025-07-21	11:00	3	pending	APT10643	\N
9645	337	8	2025-07-21 14:15:00	Diabetes Check	Emergency	Veritatis unde perferendis corporis consectetur fugiat.	2025-06-26 22:30:08	2025-06-26 22:30:08	125/64	88	98.9	97	70	Dolores deserunt animi aspernatur facere.	Accusamus veritatis distinctio soluta error expedita minima nisi fuga.	2025-07-28	Hic repudiandae placeat iste.	2025-07-21	14:15	3	pending	APT10644	\N
9646	390	9	2025-07-21 15:00:00	High BP	Emergency	Harum ratione dolorum dolore.	2025-06-26 22:30:08	2025-06-26 22:30:08	111/72	75	99.9	95	85	Debitis repellendus eveniet laborum nulla iusto quibusdam.	Corrupti harum architecto illum eum laboriosam.	2025-08-20	Quo nisi consectetur.	2025-07-21	15:00	3	pending	APT10645	\N
9647	102	10	2025-07-21 14:00:00	High BP	Follow-up	Laboriosam itaque fuga voluptates sit animi.	2025-06-26 22:30:08	2025-06-26 22:30:08	134/74	89	98.1	95	84	Eum aperiam voluptas molestias quis neque.	Ipsa beatae pariatur officiis provident consequatur.	2025-08-07	Dolores provident sint enim in.	2025-07-21	14:00	3	pending	APT10646	\N
9648	279	5	2025-07-21 14:00:00	High BP	Emergency	Totam sit similique deserunt vel dolor.	2025-06-26 22:30:08	2025-06-26 22:30:08	114/75	81	97.7	96	71	Expedita accusantium at adipisci.	Quidem perspiciatis quam ad quia corrupti blanditiis repellat tempora unde.	2025-08-01	Odio impedit reprehenderit eius.	2025-07-21	14:00	3	pending	APT10647	\N
9649	166	6	2025-07-21 14:45:00	Fever	New	Dignissimos cumque et minus reprehenderit nobis iusto.	2025-06-26 22:30:08	2025-06-26 22:30:08	104/64	89	100.5	95	60	In adipisci aut assumenda.	Ipsam voluptas quasi maxime architecto laboriosam dicta mollitia nisi.	2025-08-14	Officiis aut reiciendis nisi totam ea maxime.	2025-07-21	14:45	3	pending	APT10648	\N
9650	128	9	2025-07-21 16:45:00	Back Pain	Follow-up	Similique eos minus fugit.	2025-06-26 22:30:08	2025-06-26 22:30:08	119/85	98	99.2	100	82	Delectus iure expedita atque provident.	Nemo eaque labore ea expedita corporis laudantium dolorem dolores.	2025-08-18	Provident officiis temporibus blanditiis ea.	2025-07-21	16:45	3	pending	APT10649	\N
9651	270	7	2025-07-21 12:15:00	Diabetes Check	New	Hic tempora sit corporis delectus atque quibusdam.	2025-06-26 22:30:08	2025-06-26 22:30:08	135/66	72	98.0	98	67	Adipisci explicabo eum dolore. Recusandae quidem inventore.	Occaecati nihil doloremque alias debitis iure non a iusto expedita.	2025-08-18	Eligendi modi quisquam.	2025-07-21	12:15	3	pending	APT10650	\N
9652	249	7	2025-07-21 12:15:00	Headache	New	Voluptatum repellat dolor quibusdam officia earum reprehenderit consequatur.	2025-06-26 22:30:08	2025-06-26 22:30:08	136/68	85	100.4	100	83	Temporibus ratione culpa.	Aliquam occaecati sint deserunt deserunt.	2025-07-30	Atque commodi ratione in unde placeat hic.	2025-07-21	12:15	3	pending	APT10651	\N
9653	219	5	2025-07-21 15:00:00	Skin Rash	New	Laborum reiciendis nemo eos quos explicabo cum facere.	2025-06-26 22:30:08	2025-06-26 22:30:08	116/75	83	99.0	99	78	Optio accusamus quas repellendus id reiciendis.	Placeat incidunt excepturi excepturi fuga quae reiciendis atque tenetur quibusdam.	2025-08-16	Reiciendis repellendus sed occaecati expedita nihil minus.	2025-07-21	15:00	3	pending	APT10652	\N
9654	127	8	2025-07-22 13:00:00	Skin Rash	Follow-up	Porro ipsum similique voluptatibus atque reiciendis suscipit.	2025-06-26 22:30:08	2025-06-26 22:30:08	119/61	99	98.4	100	64	Ex dolorum amet in aliquid.	Cupiditate excepturi voluptates error architecto quisquam at.	2025-08-21	Labore magni earum cumque nulla.	2025-07-22	13:00	3	pending	APT10653	\N
9655	160	5	2025-07-22 16:30:00	Routine Checkup	OPD	Labore cum nulla mollitia repellendus mollitia.	2025-06-26 22:30:08	2025-06-26 22:30:08	126/72	91	99.6	95	79	Fugiat nobis et cupiditate odit. Dignissimos pariatur hic.	Libero dolores ad voluptatem dicta.	2025-08-16	Est harum perspiciatis blanditiis recusandae.	2025-07-22	16:30	3	pending	APT10654	\N
9656	88	9	2025-07-22 11:00:00	Back Pain	Follow-up	Modi atque distinctio fugit autem architecto commodi dolores.	2025-06-26 22:30:08	2025-06-26 22:30:08	136/67	81	100.3	98	65	Unde non dolores alias.	Molestias distinctio modi adipisci fugiat veniam dolore quod cumque.	2025-08-06	Ducimus explicabo labore nihil iste quisquam temporibus.	2025-07-22	11:00	3	pending	APT10655	\N
9657	338	5	2025-07-22 15:30:00	Headache	Follow-up	Tenetur voluptas minima expedita nisi.	2025-06-26 22:30:08	2025-06-26 22:30:08	131/71	72	99.9	97	66	Nulla voluptatum sit totam dolores nulla a reprehenderit.	Quidem maxime dolorum quidem eligendi velit illo.	2025-08-10	Saepe voluptates nobis enim accusamus nam quisquam.	2025-07-22	15:30	3	pending	APT10656	\N
9658	479	7	2025-07-22 13:15:00	Diabetes Check	Emergency	Velit voluptatum molestiae fugiat.	2025-06-26 22:30:08	2025-06-26 22:30:08	110/85	99	100.2	99	68	Ullam maiores ea at hic odit.	Magni hic cum quae molestias officia sed.	2025-07-29	Unde adipisci dolore.	2025-07-22	13:15	3	pending	APT10657	\N
9659	5	10	2025-07-22 16:00:00	High BP	OPD	Neque quo quos officiis voluptatum pariatur natus officia.	2025-06-26 22:30:08	2025-06-26 22:30:08	134/83	70	98.2	98	65	Accusamus tenetur sunt.	Adipisci nam quos molestiae modi corporis temporibus architecto modi.	2025-08-17	Adipisci distinctio laboriosam.	2025-07-22	16:00	3	pending	APT10658	\N
9660	164	6	2025-07-22 11:30:00	Routine Checkup	Emergency	Qui eaque laborum molestias molestiae.	2025-06-26 22:30:08	2025-06-26 22:30:08	102/71	81	97.6	100	74	Sed culpa architecto animi.	Doloribus consequatur consequatur odio odio deleniti veritatis saepe id.	2025-07-29	Quibusdam quo dolor ipsum.	2025-07-22	11:30	3	pending	APT10659	\N
9661	252	10	2025-07-22 13:15:00	Routine Checkup	Emergency	Laudantium doloremque delectus mollitia asperiores excepturi provident sequi.	2025-06-26 22:30:08	2025-06-26 22:30:08	116/75	89	99.2	97	68	Officiis autem aperiam.	Optio reiciendis culpa alias atque.	2025-08-16	Sunt repudiandae sapiente est.	2025-07-22	13:15	3	pending	APT10660	\N
9662	129	4	2025-07-22 15:15:00	Skin Rash	New	Nihil cumque ullam adipisci soluta iste dolor nisi.	2025-06-26 22:30:08	2025-06-26 22:30:08	139/67	69	98.4	100	67	Illo ea quae corporis animi doloremque.	Impedit amet magnam cumque occaecati.	2025-08-04	Atque praesentium voluptatem dicta.	2025-07-22	15:15	3	pending	APT10661	\N
9663	253	6	2025-07-22 16:45:00	Back Pain	Follow-up	Dolor nam repellendus magni.	2025-06-26 22:30:08	2025-06-26 22:30:08	128/74	99	99.4	98	69	Commodi dolore illo odit ad earum officia.	Ipsa animi aspernatur libero adipisci eius est ullam ab.	2025-08-17	Molestiae suscipit optio voluptatem.	2025-07-22	16:45	3	pending	APT10662	\N
9664	37	7	2025-07-22 11:30:00	Cough	OPD	Dolor officiis consequatur in ad fuga ad.	2025-06-26 22:30:08	2025-06-26 22:30:08	107/81	65	97.8	98	63	Inventore eligendi quasi unde.	Quasi velit dolore velit placeat.	2025-08-01	Magnam sunt aut ullam atque occaecati suscipit.	2025-07-22	11:30	3	pending	APT10663	\N
9665	316	6	2025-07-22 11:45:00	Back Pain	Emergency	Quae incidunt ab delectus tempora corporis.	2025-06-26 22:30:08	2025-06-26 22:30:08	101/85	80	97.7	95	82	Corporis doloribus dicta labore distinctio nesciunt quia.	Ut praesentium at necessitatibus tempore pariatur impedit delectus vel.	2025-08-09	Est non voluptate inventore quidem quam amet temporibus.	2025-07-22	11:45	3	pending	APT10664	\N
9666	55	5	2025-07-22 16:00:00	High BP	Follow-up	Harum dolor deleniti dolorem quasi atque voluptatibus.	2025-06-26 22:30:08	2025-06-26 22:30:08	130/84	92	100.1	96	62	Commodi nihil voluptatem fugit. Consequatur itaque autem.	Quis aspernatur minima aspernatur incidunt tempore molestias.	2025-08-21	Numquam ducimus blanditiis amet tenetur corrupti adipisci.	2025-07-22	16:00	3	pending	APT10665	\N
9667	48	8	2025-07-22 11:45:00	Fever	Follow-up	Cumque provident inventore eligendi fuga.	2025-06-26 22:30:08	2025-06-26 22:30:08	128/73	99	97.8	96	68	At iure officia vitae tenetur laudantium molestias.	Praesentium quae quam quisquam atque odio suscipit qui expedita velit.	2025-08-19	Nulla vel repellat doloribus.	2025-07-22	11:45	3	pending	APT10666	\N
9668	101	5	2025-07-22 14:30:00	High BP	Emergency	Possimus qui animi nihil repudiandae nobis excepturi.	2025-06-26 22:30:08	2025-06-26 22:30:08	123/74	96	98.3	98	82	Eos itaque hic fugiat ipsam ipsam.	Dolor eaque commodi libero neque beatae totam.	2025-08-10	Tempora dolorum possimus voluptate repellat.	2025-07-22	14:30	3	pending	APT10667	\N
9669	362	7	2025-07-22 12:15:00	Diabetes Check	Follow-up	Voluptate suscipit beatae minima quo maiores voluptatum.	2025-06-26 22:30:08	2025-06-26 22:30:08	104/77	70	98.5	97	58	Eius perferendis accusamus facere assumenda voluptatibus.	Aperiam aspernatur architecto tempora maiores explicabo vitae itaque veritatis.	2025-08-02	Ducimus accusantium doloribus quibusdam omnis similique saepe.	2025-07-22	12:15	3	pending	APT10668	\N
9670	230	6	2025-07-22 16:45:00	Fever	OPD	Rerum dolore vel inventore facilis.	2025-06-26 22:30:08	2025-06-26 22:30:08	137/75	70	98.1	98	81	Rerum quia inventore earum inventore iusto.	Ullam voluptatum soluta tempora veniam quidem repellat sequi earum odit ipsa.	2025-08-17	Quae quidem aut alias.	2025-07-22	16:45	3	pending	APT10669	\N
9671	412	7	2025-07-22 15:00:00	Routine Checkup	Follow-up	Sint non sapiente cumque officiis optio aliquid distinctio.	2025-06-26 22:30:08	2025-06-26 22:30:08	126/60	98	98.4	100	77	Perferendis debitis atque libero ipsa magnam.	Sint ipsum consequuntur velit assumenda.	2025-08-15	Dolorem voluptatum similique nostrum.	2025-07-22	15:00	3	pending	APT10670	\N
9672	177	6	2025-07-22 14:00:00	Diabetes Check	New	Eaque cumque fuga reiciendis.	2025-06-26 22:30:08	2025-06-26 22:30:08	129/83	85	99.0	96	68	Veniam aliquam rem in repellat. In veniam eum minima magni.	Ipsum quidem laborum natus consectetur neque.	2025-08-16	Nisi natus sapiente commodi odio iure itaque.	2025-07-22	14:00	3	pending	APT10671	\N
9673	188	9	2025-07-22 16:15:00	High BP	Emergency	Natus eaque unde laborum.	2025-06-26 22:30:08	2025-06-26 22:30:08	113/84	94	99.6	95	84	Voluptate facilis placeat facere.	Architecto velit accusamus tempora fugit.	2025-08-11	Reiciendis consequatur exercitationem nobis quod eligendi.	2025-07-22	16:15	3	pending	APT10672	\N
9674	132	7	2025-07-22 12:15:00	High BP	OPD	Odit est incidunt perspiciatis tenetur maiores.	2025-06-26 22:30:08	2025-06-26 22:30:08	127/88	84	98.6	96	83	Eum ipsum culpa dolore numquam.	Ipsam sint expedita rem debitis ipsam quod tempore corporis molestiae officia.	2025-08-18	Similique reiciendis expedita deserunt nihil tempora.	2025-07-22	12:15	3	pending	APT10673	\N
9675	4	8	2025-07-22 14:45:00	Fever	OPD	Omnis doloremque placeat cum.	2025-06-26 22:30:08	2025-06-26 22:30:08	116/66	84	98.3	98	70	Modi optio corrupti quis nesciunt ipsa.	Placeat corporis expedita ea a veritatis distinctio beatae optio aperiam.	2025-08-20	Nobis maxime accusantium delectus voluptatibus.	2025-07-22	14:45	3	pending	APT10674	\N
9676	52	4	2025-07-22 14:00:00	High BP	Follow-up	Aliquid facere ex veritatis expedita ea quis.	2025-06-26 22:30:08	2025-06-26 22:30:08	136/67	78	98.7	97	59	Delectus enim ullam asperiores.	Ex eveniet optio libero accusantium.	2025-08-10	Dolore aperiam laudantium odit.	2025-07-22	14:00	3	pending	APT10675	\N
9677	271	8	2025-07-22 16:00:00	Back Pain	Follow-up	Nisi officiis consequuntur voluptatem.	2025-06-26 22:30:08	2025-06-26 22:30:08	137/67	84	98.1	100	70	Nemo neque voluptatem quis.	Eveniet harum soluta labore qui ducimus maiores eos pariatur dolorem.	2025-08-15	Praesentium saepe id.	2025-07-22	16:00	3	pending	APT10676	\N
9678	129	3	2025-07-22 14:15:00	Skin Rash	New	Eligendi dolorum enim praesentium iste.	2025-06-26 22:30:08	2025-06-26 22:30:08	120/82	79	98.5	96	69	Tenetur expedita at.	Consectetur cumque blanditiis reiciendis quidem.	2025-08-17	Pariatur labore ipsa atque ipsa pariatur nulla.	2025-07-22	14:15	3	pending	APT10677	\N
9679	131	8	2025-07-22 12:30:00	Diabetes Check	Follow-up	Inventore quod excepturi.	2025-06-26 22:30:08	2025-06-26 22:30:08	119/68	85	98.9	95	81	Esse deleniti tempore. Sit dolorem corporis unde id.	Sunt debitis nulla exercitationem nostrum excepturi tenetur consectetur vel.	2025-07-29	Mollitia laudantium corrupti fugiat perferendis hic architecto.	2025-07-22	12:30	3	pending	APT10678	\N
9680	409	6	2025-07-22 16:30:00	Cough	New	Fugit cumque unde eveniet aliquid.	2025-06-26 22:30:08	2025-06-26 22:30:08	134/65	89	100.0	97	69	Officia ullam veritatis dolore reiciendis ad eum.	Ut aut consequatur repudiandae blanditiis non cumque.	2025-08-15	Nam modi placeat dolorum odit.	2025-07-22	16:30	3	pending	APT10679	\N
9681	474	5	2025-07-22 14:30:00	Skin Rash	Emergency	Impedit eos voluptatum commodi.	2025-06-26 22:30:08	2025-06-26 22:30:08	103/77	72	99.3	98	65	Laudantium dolorum rerum.	Amet deleniti eius aliquam delectus rem eos illum debitis.	2025-07-30	Ducimus nesciunt ratione.	2025-07-22	14:30	3	pending	APT10680	\N
9682	358	3	2025-07-22 15:15:00	Diabetes Check	New	Non natus voluptatem.	2025-06-26 22:30:08	2025-06-26 22:30:08	131/83	71	99.8	96	77	Sapiente vel velit vero veritatis quam.	Id explicabo tempora iusto perferendis.	2025-08-18	Consequuntur suscipit sapiente iure minus ad.	2025-07-22	15:15	3	pending	APT10681	\N
9683	356	10	2025-07-22 14:30:00	Cough	New	Ducimus itaque dolorem aspernatur nam.	2025-06-26 22:30:08	2025-06-26 22:30:08	127/78	95	98.3	97	78	Numquam fuga ut ipsam velit inventore.	Alias officia est debitis totam iste amet hic.	2025-08-01	Incidunt iste quo iure molestiae corporis.	2025-07-22	14:30	3	pending	APT10682	\N
9684	227	8	2025-07-23 16:45:00	Fever	New	Cum inventore autem reprehenderit placeat.	2025-06-26 22:30:08	2025-06-26 22:30:08	126/62	94	97.6	97	65	Et dolorem ea quo sed distinctio eos.	Perferendis labore quia tempora nisi nostrum facere ratione illo libero.	2025-08-10	Iste eos ad voluptatem iste cumque.	2025-07-23	16:45	3	pending	APT10683	\N
9685	482	8	2025-07-23 11:00:00	Routine Checkup	New	Voluptatibus voluptatum magnam quaerat.	2025-06-26 22:30:08	2025-06-26 22:30:08	126/80	100	98.1	100	58	Blanditiis unde sunt. Iusto architecto repellat a.	Magnam dolorem at vel deserunt doloribus unde sunt ipsum.	2025-08-12	Optio impedit numquam beatae assumenda delectus accusamus.	2025-07-23	11:00	3	pending	APT10684	\N
9686	301	3	2025-07-23 12:45:00	Routine Checkup	New	Alias culpa fugiat omnis magnam omnis.	2025-06-26 22:30:08	2025-06-26 22:30:08	118/71	88	98.5	98	69	Ipsum iure provident occaecati. Alias ut cum.	Odio hic ipsa aliquid voluptate accusamus placeat cumque soluta aspernatur.	2025-08-02	Commodi provident voluptatem soluta ipsam.	2025-07-23	12:45	3	pending	APT10685	\N
9687	30	3	2025-07-23 12:30:00	Back Pain	Emergency	Doloribus velit corrupti corporis.	2025-06-26 22:30:08	2025-06-26 22:30:08	124/63	76	99.9	95	80	Quasi doloribus sit id repellendus vitae nihil.	Deserunt alias in eaque sit.	2025-08-06	Totam magnam vero nam delectus beatae ad exercitationem.	2025-07-23	12:30	3	pending	APT10686	\N
9688	176	5	2025-07-23 16:30:00	Routine Checkup	Emergency	Perferendis nihil laborum ut.	2025-06-26 22:30:08	2025-06-26 22:30:08	140/63	95	98.9	99	85	Adipisci at animi id modi molestiae facilis.	Nostrum architecto harum fuga minus ea eveniet fuga sit necessitatibus.	2025-08-12	Excepturi dolorem rerum ad iusto.	2025-07-23	16:30	3	pending	APT10687	\N
9689	392	3	2025-07-23 12:30:00	High BP	Emergency	At itaque consectetur sequi cum eligendi provident.	2025-06-26 22:30:08	2025-06-26 22:30:08	114/77	70	98.0	99	78	Doloremque repellat optio eligendi eligendi ad veniam.	Totam aperiam a nemo maxime qui adipisci eos.	2025-08-13	Repellendus non quaerat eveniet.	2025-07-23	12:30	3	pending	APT10688	\N
9690	255	5	2025-07-23 13:45:00	Fever	OPD	Unde dolorum quis illo nisi necessitatibus.	2025-06-26 22:30:08	2025-06-26 22:30:08	110/84	95	100.2	96	82	Sequi nihil fuga occaecati sed accusamus.	Dolores laudantium autem odio veniam fuga odit odio.	2025-08-11	Voluptate modi assumenda possimus ullam corporis.	2025-07-23	13:45	3	pending	APT10689	\N
9691	55	10	2025-07-23 14:15:00	Skin Rash	OPD	Tempora omnis suscipit maiores quibusdam reprehenderit voluptatum.	2025-06-26 22:30:08	2025-06-26 22:30:08	103/80	84	97.8	95	64	Maxime magni voluptas officia.	Maxime illum dolorum sunt veniam praesentium nobis.	2025-08-12	Ex doloribus est maiores.	2025-07-23	14:15	3	pending	APT10690	\N
9692	321	3	2025-07-23 16:30:00	Diabetes Check	New	Et animi nesciunt libero at sapiente tempore.	2025-06-26 22:30:08	2025-06-26 22:30:08	131/73	100	98.2	98	66	Repudiandae delectus qui veniam doloribus modi quam earum.	Iusto consectetur quasi doloribus ullam deleniti labore nihil illo exercitationem.	2025-08-09	Pariatur molestiae atque omnis architecto ut.	2025-07-23	16:30	3	pending	APT10691	\N
9693	375	7	2025-07-23 16:45:00	Skin Rash	New	Accusantium temporibus adipisci odit numquam libero.	2025-06-26 22:30:08	2025-06-26 22:30:08	110/70	94	99.3	98	66	Facere dolores iusto.	Temporibus consectetur asperiores earum ex magni est nesciunt eveniet animi.	2025-08-13	Consequatur distinctio nesciunt.	2025-07-23	16:45	3	pending	APT10692	\N
9694	371	4	2025-07-23 13:45:00	Fever	New	Illum placeat ratione numquam aperiam in nemo.	2025-06-26 22:30:08	2025-06-26 22:30:08	100/85	85	98.5	96	68	Facere molestiae laboriosam in doloremque eos.	Quo ducimus repudiandae ratione tempore sint excepturi nobis consequuntur repellat.	2025-08-17	Laborum quas eos quo deleniti facere harum.	2025-07-23	13:45	3	pending	APT10693	\N
9695	490	8	2025-07-23 13:30:00	Diabetes Check	Follow-up	Id veritatis nihil ex tenetur.	2025-06-26 22:30:08	2025-06-26 22:30:08	115/79	79	99.0	97	75	Expedita maiores quisquam corporis ut ab est ea.	Esse dolores nemo expedita maiores doloribus totam sequi eos.	2025-08-08	Doloribus illum quo dicta eum.	2025-07-23	13:30	3	pending	APT10694	\N
9696	372	8	2025-07-23 14:30:00	Routine Checkup	Emergency	Dignissimos assumenda fugit asperiores perferendis.	2025-06-26 22:30:08	2025-06-26 22:30:08	124/73	80	97.8	96	60	Iure accusamus ducimus vel.	Unde debitis delectus molestias ex nobis beatae hic.	2025-08-21	Saepe placeat suscipit et.	2025-07-23	14:30	3	pending	APT10695	\N
9697	493	6	2025-07-23 12:45:00	High BP	OPD	Sapiente nostrum ex molestias porro nam ex.	2025-06-26 22:30:08	2025-06-26 22:30:08	139/65	81	99.2	95	64	Aspernatur voluptatem ullam debitis libero rerum.	Cupiditate sunt sed aliquam culpa iure natus ipsam quam reprehenderit vero.	2025-08-02	Debitis fugiat similique.	2025-07-23	12:45	3	pending	APT10696	\N
9698	469	8	2025-07-23 11:30:00	Skin Rash	OPD	Blanditiis error aut alias non reiciendis.	2025-06-26 22:30:08	2025-06-26 22:30:08	137/69	69	100.3	97	79	Molestias ab culpa quis aperiam repudiandae voluptatibus.	Eaque nulla culpa minus omnis sed aut enim deserunt earum.	2025-08-02	Sit saepe a.	2025-07-23	11:30	3	pending	APT10697	\N
9699	281	8	2025-07-23 15:45:00	High BP	OPD	Laborum distinctio molestiae.	2025-06-26 22:30:08	2025-06-26 22:30:08	120/72	76	100.3	95	57	Est dignissimos itaque deleniti magni.	Accusamus natus omnis rem quam nam.	2025-08-07	Consectetur ipsa laborum.	2025-07-23	15:45	3	pending	APT10698	\N
9700	373	10	2025-07-23 16:15:00	Headache	New	Magni voluptate a nisi.	2025-06-26 22:30:08	2025-06-26 22:30:08	120/68	97	97.6	95	68	Et illo explicabo magni deleniti est numquam laborum.	Quae ex deleniti perferendis officia occaecati nihil eveniet exercitationem occaecati.	2025-08-19	Officia in id nihil nesciunt accusantium.	2025-07-23	16:15	3	pending	APT10699	\N
9701	499	5	2025-07-23 12:15:00	Diabetes Check	Follow-up	Repudiandae non ducimus atque.	2025-06-26 22:30:08	2025-06-26 22:30:08	105/66	75	100.0	100	58	Pariatur magnam est quidem deleniti quo.	Dolore ad nobis deleniti quaerat sed ipsam.	2025-08-06	Occaecati vitae quae placeat voluptas.	2025-07-23	12:15	3	pending	APT10700	\N
9702	469	4	2025-07-23 13:00:00	Back Pain	OPD	Ipsam ad quisquam temporibus minus quas.	2025-06-26 22:30:08	2025-06-26 22:30:08	117/65	94	99.0	97	79	Labore nulla illo quos officia labore nobis debitis.	Dolores non atque error nesciunt temporibus dolores quidem ea.	2025-08-05	Laborum cumque aliquam alias quas.	2025-07-23	13:00	3	pending	APT10701	\N
9703	484	4	2025-07-23 11:00:00	High BP	New	Saepe pariatur tempora soluta.	2025-06-26 22:30:08	2025-06-26 22:30:08	137/76	69	98.2	99	81	Fuga dolore sint excepturi eum.	Corporis cumque dolor laudantium tempore.	2025-08-04	Eum accusantium dolores rerum voluptatum alias aliquam.	2025-07-23	11:00	3	pending	APT10702	\N
9704	282	8	2025-07-23 15:15:00	High BP	Follow-up	Delectus possimus commodi excepturi impedit quidem amet.	2025-06-26 22:30:08	2025-06-26 22:30:08	130/78	78	98.6	98	72	Officiis quaerat repellendus in.	Deserunt veritatis praesentium tempore praesentium.	2025-08-01	Autem ab consectetur praesentium tempore vitae.	2025-07-23	15:15	3	pending	APT10703	\N
9705	258	5	2025-07-23 14:30:00	Skin Rash	New	Illo perferendis ab explicabo rerum.	2025-06-26 22:30:08	2025-06-26 22:30:08	105/70	98	99.5	99	85	Iure labore sit neque cumque possimus eligendi.	Cumque suscipit sunt numquam amet.	2025-08-20	Distinctio inventore blanditiis.	2025-07-23	14:30	3	pending	APT10704	\N
9706	463	9	2025-07-23 12:45:00	High BP	New	Aperiam excepturi nam ea tempora.	2025-06-26 22:30:08	2025-06-26 22:30:08	111/77	74	100.2	96	60	Laborum blanditiis quidem quia quas.	In possimus voluptatibus consectetur autem.	2025-08-07	Totam inventore enim beatae non.	2025-07-23	12:45	3	pending	APT10705	\N
9707	235	9	2025-07-23 14:15:00	Fever	New	Autem quasi porro alias.	2025-06-26 22:30:08	2025-06-26 22:30:08	134/62	99	99.3	96	64	Quae corrupti explicabo amet eveniet eius.	Libero consequuntur porro harum.	2025-08-02	Nulla non voluptatum molestias cum maiores.	2025-07-23	14:15	3	pending	APT10706	\N
9708	181	8	2025-07-24 11:30:00	Cough	New	Odit quasi maxime in consectetur.	2025-06-26 22:30:08	2025-06-26 22:30:08	116/64	65	99.0	99	69	Eligendi magnam neque voluptatem earum officiis.	Minima suscipit corporis autem quasi expedita sed repellat ad.	2025-08-13	Minima officiis quaerat omnis sapiente.	2025-07-24	11:30	3	pending	APT10707	\N
9709	253	9	2025-07-24 11:30:00	Skin Rash	Emergency	Quidem ad nobis culpa illum pariatur dignissimos.	2025-06-26 22:30:08	2025-06-26 22:30:08	119/89	74	98.9	96	79	Ab error pariatur at aliquam accusantium voluptate.	Incidunt quidem nam hic autem voluptates.	2025-08-04	Nihil molestiae fugit deleniti velit nostrum eos.	2025-07-24	11:30	3	pending	APT10708	\N
9710	131	5	2025-07-24 14:00:00	Skin Rash	New	Quam aperiam quod nemo rem tempore.	2025-06-26 22:30:08	2025-06-26 22:30:08	111/75	67	99.4	99	63	Sed harum dolore saepe nulla fugiat.	Sequi sequi ipsam et eligendi provident.	2025-08-21	Quidem aut magnam eos itaque maxime.	2025-07-24	14:00	3	pending	APT10709	\N
9711	440	9	2025-07-24 15:15:00	High BP	New	Pariatur recusandae numquam voluptatibus.	2025-06-26 22:30:08	2025-06-26 22:30:08	100/64	83	98.4	96	79	Esse accusamus deserunt quod similique.	Inventore molestias beatae omnis provident.	2025-08-10	Aspernatur debitis aut dolorem veniam nesciunt pariatur.	2025-07-24	15:15	3	pending	APT10710	\N
9712	389	3	2025-07-24 13:30:00	High BP	New	Maiores nemo aperiam minima cum.	2025-06-26 22:30:08	2025-06-26 22:30:08	136/61	89	99.9	96	84	Ad iure quas cumque ut officiis aliquid.	Assumenda atque soluta consequatur aperiam aut fugit impedit ab velit.	2025-08-12	Beatae similique saepe necessitatibus dolorem.	2025-07-24	13:30	3	pending	APT10711	\N
9713	447	4	2025-07-24 16:45:00	Diabetes Check	OPD	Nemo consequatur aliquam illum quibusdam sed nisi aliquid.	2025-06-26 22:30:08	2025-06-26 22:30:08	125/60	97	97.6	98	71	Veniam quod perferendis velit qui ratione velit ab.	Ipsam atque magni dolorum laudantium.	2025-08-19	Architecto delectus minima eos facilis.	2025-07-24	16:45	3	pending	APT10712	\N
9714	434	3	2025-07-24 16:30:00	Routine Checkup	Follow-up	Atque esse natus quis.	2025-06-26 22:30:08	2025-06-26 22:30:08	136/63	85	99.8	98	74	Explicabo fugit iste. Occaecati perspiciatis praesentium.	Nemo saepe maiores voluptate debitis sunt non quos sunt inventore.	2025-08-07	Cumque repellat alias unde enim reiciendis sapiente.	2025-07-24	16:30	3	pending	APT10713	\N
9715	396	4	2025-07-24 16:00:00	High BP	New	Ullam rem fuga eligendi totam.	2025-06-26 22:30:08	2025-06-26 22:30:08	110/81	74	97.8	99	59	Consectetur quo repellendus corrupti illum.	At exercitationem iste nam ullam nihil omnis explicabo ab quia.	2025-08-03	Deserunt sed dolorem dolorem.	2025-07-24	16:00	3	pending	APT10714	\N
9716	73	6	2025-07-24 16:00:00	Fever	OPD	Suscipit pariatur occaecati.	2025-06-26 22:30:08	2025-06-26 22:30:08	125/90	90	98.1	95	80	Natus harum consequatur quo quod reiciendis inventore.	Veritatis in tenetur expedita dicta cum minima.	2025-08-21	Velit nisi illum cupiditate tempora iure.	2025-07-24	16:00	3	pending	APT10715	\N
9717	250	8	2025-07-24 11:00:00	Skin Rash	New	Qui fuga libero sunt nesciunt.	2025-06-26 22:30:08	2025-06-26 22:30:08	119/67	95	97.8	100	78	Odio perspiciatis aliquam soluta sequi officiis.	Dicta est est ab repellat ab quas.	2025-08-17	Enim voluptatibus tenetur excepturi ducimus pariatur ea.	2025-07-24	11:00	3	pending	APT10716	\N
9718	239	10	2025-07-24 14:15:00	Headache	New	Cupiditate laborum natus aliquid delectus voluptatem.	2025-06-26 22:30:08	2025-06-26 22:30:08	105/77	89	97.6	95	60	Consequatur tempora deleniti nam quo.	Laudantium sunt repellendus ipsa sit qui ipsum ea porro libero facilis.	2025-08-17	Nobis sequi libero repudiandae laudantium.	2025-07-24	14:15	3	pending	APT10717	\N
9719	192	9	2025-07-24 15:45:00	Fever	OPD	Corrupti itaque possimus sapiente.	2025-06-26 22:30:08	2025-06-26 22:30:08	114/89	89	98.4	100	78	Deserunt quo libero dolores eligendi nam esse.	Maiores quidem corporis quis ad ex accusantium consequuntur.	2025-08-02	Quod consequatur cupiditate unde at.	2025-07-24	15:45	3	pending	APT10718	\N
9720	473	9	2025-07-24 16:00:00	High BP	OPD	Odio porro quia autem perspiciatis.	2025-06-26 22:30:08	2025-06-26 22:30:08	111/89	67	99.0	96	73	Inventore eveniet temporibus in sequi quos tenetur.	Deserunt neque nihil tempora fugiat excepturi aut dolorum placeat molestias.	2025-08-10	Necessitatibus iste cum placeat et dolorum.	2025-07-24	16:00	3	pending	APT10719	\N
9721	188	3	2025-07-24 16:45:00	Headache	Emergency	Sapiente nulla in numquam nam dolor.	2025-06-26 22:30:08	2025-06-26 22:30:08	131/84	74	100.1	99	80	Molestias aliquam quasi.	Aliquid sit iste nesciunt incidunt excepturi non magni.	2025-08-01	Sunt facere error reiciendis hic temporibus magnam.	2025-07-24	16:45	3	pending	APT10720	\N
9722	288	9	2025-07-24 13:15:00	Back Pain	New	Repellendus totam quod explicabo et ducimus dolorem non.	2025-06-26 22:30:08	2025-06-26 22:30:08	140/61	98	100.0	99	65	Sit placeat laboriosam nobis exercitationem cumque.	Culpa libero ipsam excepturi ad.	2025-08-18	Eum minima non quam.	2025-07-24	13:15	3	pending	APT10721	\N
9723	179	3	2025-07-24 16:45:00	Skin Rash	Follow-up	Qui distinctio veniam iure voluptatum dolor delectus.	2025-06-26 22:30:08	2025-06-26 22:30:08	116/85	77	99.3	100	81	Quaerat temporibus autem provident.	Vero recusandae repellendus eos tempora nulla sint laudantium alias.	2025-08-06	Itaque nisi nulla similique cum necessitatibus molestias.	2025-07-24	16:45	3	pending	APT10722	\N
9724	67	4	2025-07-24 11:30:00	Cough	OPD	Quia recusandae odio molestias ipsum cumque provident rem.	2025-06-26 22:30:08	2025-06-26 22:30:08	105/84	91	98.7	96	75	Dolor esse molestias labore culpa.	Reprehenderit nobis accusantium perferendis odit magnam ex rerum.	2025-08-11	Et unde officia at eveniet laudantium.	2025-07-24	11:30	3	pending	APT10723	\N
9725	211	8	2025-07-24 13:45:00	Headache	Follow-up	Eos cumque ipsum dolorum exercitationem aliquid.	2025-06-26 22:30:08	2025-06-26 22:30:08	111/81	99	99.3	98	60	Occaecati aliquid aperiam enim ex blanditiis quas.	Earum rem et incidunt eum nemo dolorem deserunt porro.	2025-08-04	Nihil dolorum explicabo a asperiores eveniet.	2025-07-24	13:45	3	pending	APT10724	\N
9726	432	8	2025-07-24 11:00:00	Cough	Emergency	Esse tempore perspiciatis eos recusandae culpa recusandae quas.	2025-06-26 22:30:08	2025-06-26 22:30:08	126/71	94	98.9	98	80	Minus temporibus reiciendis cum.	Earum veritatis perferendis error commodi explicabo.	2025-08-15	Aliquam quidem maxime saepe iste unde laudantium id.	2025-07-24	11:00	3	pending	APT10725	\N
9727	251	8	2025-07-24 16:30:00	Diabetes Check	OPD	Non quia iusto magnam.	2025-06-26 22:30:08	2025-06-26 22:30:08	138/86	96	99.1	97	56	Recusandae quasi iure esse omnis dolorem amet.	Minus maxime eveniet unde dolore inventore eaque.	2025-08-06	Ducimus vero aperiam amet.	2025-07-24	16:30	3	pending	APT10726	\N
9728	202	6	2025-07-24 15:15:00	Routine Checkup	Emergency	Quas quisquam debitis delectus quo sunt.	2025-06-26 22:30:08	2025-06-26 22:30:08	112/61	83	99.2	98	68	Fugiat ipsa dolorum officia.	Inventore deleniti odit quod nostrum quas hic explicabo ab.	2025-08-10	Deserunt quod voluptatibus.	2025-07-24	15:15	3	pending	APT10727	\N
9729	389	9	2025-07-24 16:15:00	Routine Checkup	New	Quae delectus at fugit recusandae voluptatibus amet.	2025-06-26 22:30:08	2025-06-26 22:30:08	138/82	76	99.6	100	70	Doloremque laboriosam iure fugit minus asperiores.	Nobis facilis quo voluptates magni magnam occaecati quam cupiditate.	2025-08-18	Quos commodi placeat.	2025-07-24	16:15	3	pending	APT10728	\N
9730	88	6	2025-07-24 12:15:00	Cough	Emergency	Inventore tempore optio illo.	2025-06-26 22:30:08	2025-06-26 22:30:08	106/67	88	98.1	100	73	Nihil quaerat facilis labore esse ducimus voluptates.	Eligendi quas praesentium et assumenda rem esse quis.	2025-08-07	Dolor molestias iste maxime ex laboriosam voluptate.	2025-07-24	12:15	3	pending	APT10729	\N
9731	417	5	2025-07-24 12:30:00	Routine Checkup	New	Veritatis possimus sed magni saepe.	2025-06-26 22:30:08	2025-06-26 22:30:08	138/83	84	98.4	97	85	Sed quasi earum.	Fuga sapiente adipisci quo dicta harum.	2025-08-07	Fuga aliquam vel.	2025-07-24	12:30	3	pending	APT10730	\N
9732	82	5	2025-07-24 13:30:00	Headache	OPD	Tempore dignissimos natus aspernatur.	2025-06-26 22:30:08	2025-06-26 22:30:08	121/90	92	98.0	99	77	Accusamus vel ipsam omnis eius.	Voluptas impedit dolorum unde modi expedita sunt excepturi deserunt esse.	2025-08-22	Quos consequatur nulla dolore.	2025-07-24	13:30	3	pending	APT10731	\N
9733	158	9	2025-07-25 11:00:00	Skin Rash	OPD	Eligendi expedita consectetur nisi.	2025-06-26 22:30:08	2025-06-26 22:30:08	105/60	86	97.8	99	81	Magni delectus quo iure sequi.	Rem ea fugit et commodi excepturi maxime alias sit.	2025-08-19	Molestias ducimus corporis.	2025-07-25	11:00	3	pending	APT10732	\N
9734	157	10	2025-07-25 16:00:00	Cough	New	Accusantium possimus repellendus cupiditate eveniet quas similique.	2025-06-26 22:30:08	2025-06-26 22:30:08	133/61	72	99.5	100	70	Ducimus aut aliquam provident eum.	Harum ipsa velit fugiat.	2025-08-06	Aut ratione voluptatem veniam iure iure earum delectus.	2025-07-25	16:00	3	pending	APT10733	\N
9735	118	3	2025-07-25 14:00:00	Cough	Emergency	Quidem nesciunt sequi iste sed corporis.	2025-06-26 22:30:08	2025-06-26 22:30:08	133/75	68	99.4	99	67	Optio dolor dicta dolorum aspernatur aspernatur ullam.	Numquam iste vel debitis libero necessitatibus quod doloremque.	2025-08-01	Animi odio sequi temporibus a.	2025-07-25	14:00	3	pending	APT10734	\N
9736	164	10	2025-07-25 14:00:00	Diabetes Check	OPD	Laudantium sint ipsa quisquam necessitatibus ad quia.	2025-06-26 22:30:08	2025-06-26 22:30:08	137/67	71	97.6	97	55	Odit dolorum natus ab. Ducimus suscipit deleniti vitae.	Dicta ullam modi ut saepe nemo sequi porro eius fugiat.	2025-08-04	Possimus sint distinctio natus.	2025-07-25	14:00	3	pending	APT10735	\N
9737	482	3	2025-07-25 15:45:00	Skin Rash	Follow-up	Quo iusto laboriosam sint eum.	2025-06-26 22:30:08	2025-06-26 22:30:08	110/85	92	98.2	98	67	Atque libero repellendus autem.	Quidem occaecati repellat sint repellat.	2025-08-03	Culpa reiciendis cum.	2025-07-25	15:45	3	pending	APT10736	\N
9738	291	6	2025-07-25 12:45:00	Diabetes Check	OPD	Sunt amet deleniti veritatis aperiam ullam minus.	2025-06-26 22:30:08	2025-06-26 22:30:08	108/81	95	97.9	97	68	Quisquam magni aut voluptatem tempora.	Debitis nulla aspernatur voluptate consectetur blanditiis.	2025-08-07	Dolorum iure recusandae dicta.	2025-07-25	12:45	3	pending	APT10737	\N
9739	105	7	2025-07-25 11:15:00	Cough	OPD	Blanditiis laborum quos tempora.	2025-06-26 22:30:08	2025-06-26 22:30:08	117/77	81	99.2	97	77	Accusamus officia sequi facere. Fugiat labore repellat.	Blanditiis ipsam blanditiis deserunt hic iste odio.	2025-08-07	Sint deleniti quasi laboriosam placeat error qui quos.	2025-07-25	11:15	3	pending	APT10738	\N
9740	169	5	2025-07-25 14:30:00	Cough	Emergency	Corporis quis praesentium excepturi ab doloribus.	2025-06-26 22:30:08	2025-06-26 22:30:08	130/65	88	98.1	96	64	Occaecati recusandae ullam laborum.	Non consectetur culpa corporis quas ad ab officia facere.	2025-08-13	Fuga recusandae odio error libero numquam.	2025-07-25	14:30	3	pending	APT10739	\N
9741	39	9	2025-07-25 16:15:00	Back Pain	New	Nisi rerum qui facere.	2025-06-26 22:30:08	2025-06-26 22:30:08	101/76	82	99.2	99	74	Quae mollitia consectetur.	Fugit repellat dolor delectus velit nostrum sed non eos.	2025-08-06	Consequatur asperiores explicabo illo eaque repellendus magni.	2025-07-25	16:15	3	pending	APT10740	\N
9742	248	3	2025-07-25 12:00:00	Back Pain	Emergency	Quam est harum eum exercitationem velit.	2025-06-26 22:30:08	2025-06-26 22:30:08	116/65	69	99.4	96	55	Iure facilis nisi unde.	Nulla illum quibusdam atque.	2025-08-12	Omnis tempora totam aliquam dolorem asperiores quidem.	2025-07-25	12:00	3	pending	APT10741	\N
9743	258	5	2025-07-25 15:15:00	Back Pain	OPD	Harum a officiis doloribus.	2025-06-26 22:30:08	2025-06-26 22:30:08	110/87	99	99.6	100	70	Velit esse dignissimos aliquid totam.	Alias rem corrupti voluptate reiciendis perspiciatis.	2025-08-17	Distinctio necessitatibus aperiam ut commodi.	2025-07-25	15:15	3	pending	APT10742	\N
9744	145	6	2025-07-25 11:45:00	Routine Checkup	Emergency	Quae reprehenderit maiores quasi voluptatem magnam.	2025-06-26 22:30:08	2025-06-26 22:30:08	128/85	97	100.1	98	77	Sunt recusandae deserunt a necessitatibus at voluptate.	Impedit perspiciatis impedit quibusdam quam nihil nisi.	2025-08-05	Aperiam labore in dignissimos quas.	2025-07-25	11:45	3	pending	APT10743	\N
9745	244	4	2025-07-25 13:45:00	Routine Checkup	Emergency	Blanditiis repellat in similique molestias illo.	2025-06-26 22:30:08	2025-06-26 22:30:08	131/69	71	99.3	100	59	Ratione earum recusandae minus dolor totam a.	Exercitationem pariatur corporis quidem amet ad magni harum.	2025-08-23	Sint occaecati ex doloribus error recusandae itaque.	2025-07-25	13:45	3	pending	APT10744	\N
9746	12	9	2025-07-25 14:30:00	Headache	OPD	Eligendi culpa facilis molestias.	2025-06-26 22:30:08	2025-06-26 22:30:08	139/72	80	99.3	97	68	Ut iure soluta voluptas cupiditate odio vitae.	Aliquid voluptatem inventore repellat esse sit.	2025-08-05	Possimus facere laborum.	2025-07-25	14:30	3	pending	APT10745	\N
9747	77	10	2025-07-25 12:45:00	Fever	Follow-up	Ipsa beatae in consequatur magnam.	2025-06-26 22:30:08	2025-06-26 22:30:08	104/61	95	98.0	99	83	Possimus aliquam qui blanditiis.	Dicta voluptates saepe ducimus ullam ea esse.	2025-08-07	Dolore sed qui amet repellat.	2025-07-25	12:45	3	pending	APT10746	\N
9748	291	9	2025-07-25 12:30:00	Fever	OPD	Tenetur nulla architecto.	2025-06-26 22:30:08	2025-06-26 22:30:08	105/87	97	100.4	97	76	Consequatur dolor sunt eius reiciendis neque.	Magnam a hic tempora ullam culpa sint.	2025-08-15	Accusamus esse accusantium.	2025-07-25	12:30	3	pending	APT10747	\N
9749	265	10	2025-07-25 12:45:00	Headache	Emergency	Minima id ab sit expedita hic.	2025-06-26 22:30:08	2025-06-26 22:30:08	123/83	78	97.6	100	76	Iure labore explicabo atque repellat.	Magni minus corrupti amet aperiam a.	2025-08-13	Ab velit quia vero ratione quis saepe.	2025-07-25	12:45	3	pending	APT10748	\N
9750	355	9	2025-07-25 14:15:00	Skin Rash	New	In ipsam dolores.	2025-06-26 22:30:08	2025-06-26 22:30:08	101/63	92	97.7	95	77	Ipsam veniam voluptas iusto eum totam in dignissimos.	Cum esse velit accusantium eveniet deserunt eveniet.	2025-08-07	Consequatur sed porro quaerat id esse aliquam unde.	2025-07-25	14:15	3	pending	APT10749	\N
9751	354	9	2025-07-25 16:30:00	Cough	OPD	Officiis quo rem molestiae odio consectetur illo repellendus.	2025-06-26 22:30:08	2025-06-26 22:30:08	119/71	81	99.9	100	85	Modi non at voluptatibus quasi facere eos.	Tempore odio odit exercitationem voluptate id.	2025-08-06	Iure blanditiis officia vel veniam deserunt.	2025-07-25	16:30	3	pending	APT10750	\N
9752	367	7	2025-07-25 13:15:00	Fever	New	Exercitationem voluptatibus sequi voluptates deleniti.	2025-06-26 22:30:08	2025-06-26 22:30:08	114/84	97	97.7	97	84	Impedit ipsa alias iure nesciunt voluptate iste.	Voluptate minima explicabo nostrum consequatur magni praesentium.	2025-08-04	Explicabo necessitatibus labore adipisci vitae.	2025-07-25	13:15	3	pending	APT10751	\N
9753	101	9	2025-07-25 12:15:00	Routine Checkup	Emergency	Quisquam odio itaque eius veniam incidunt ipsum.	2025-06-26 22:30:08	2025-06-26 22:30:08	112/71	75	97.6	96	72	Molestiae tempore facere expedita dicta aperiam.	Est minima voluptate dolor id.	2025-08-08	Qui veritatis deleniti ullam fugit.	2025-07-25	12:15	3	pending	APT10752	\N
9754	436	6	2025-07-25 11:30:00	Routine Checkup	Emergency	Eveniet ut pariatur atque quia.	2025-06-26 22:30:08	2025-06-26 22:30:08	112/80	94	100.5	98	80	Amet nulla adipisci quas adipisci hic nulla.	Ad blanditiis modi vel odit.	2025-08-14	Fuga et nostrum vel.	2025-07-25	11:30	3	pending	APT10753	\N
9755	48	9	2025-07-26 11:15:00	Routine Checkup	New	Impedit voluptatem animi pariatur a unde nobis.	2025-06-26 22:30:08	2025-06-26 22:30:08	116/80	69	98.4	98	78	Fugit laboriosam quibusdam.	Aut eaque blanditiis sapiente eaque.	2025-08-13	Consequuntur temporibus quas minima nam qui nihil.	2025-07-26	11:15	3	pending	APT10754	\N
9756	95	8	2025-07-26 12:45:00	Diabetes Check	Follow-up	Quis omnis voluptate aut commodi exercitationem facere.	2025-06-26 22:30:08	2025-06-26 22:30:08	109/74	79	98.0	99	56	Expedita aliquam quas.	Inventore vel accusantium unde impedit possimus quibusdam.	2025-08-23	At error temporibus molestias possimus in.	2025-07-26	12:45	3	pending	APT10755	\N
9757	93	5	2025-07-26 13:00:00	High BP	Emergency	Exercitationem rerum explicabo iure natus incidunt.	2025-06-26 22:30:08	2025-06-26 22:30:08	108/76	80	99.8	97	80	Quis repellendus et consequuntur vel cumque.	Consectetur repudiandae aut iure esse velit.	2025-08-11	Officiis sapiente pariatur ullam vero ad.	2025-07-26	13:00	3	pending	APT10756	\N
9758	309	8	2025-07-26 12:30:00	Routine Checkup	New	Nulla beatae nulla nisi voluptas eos aliquid dignissimos.	2025-06-26 22:30:08	2025-06-26 22:30:08	109/72	76	100.1	99	81	Ullam repellat ab eos cum.	Repellat rerum ut eius at nobis voluptatibus porro voluptatibus dolorum.	2025-08-12	Occaecati recusandae molestias error sequi.	2025-07-26	12:30	3	pending	APT10757	\N
9759	357	3	2025-07-26 12:30:00	Routine Checkup	Emergency	Occaecati ipsa magnam sint.	2025-06-26 22:30:08	2025-06-26 22:30:08	107/79	93	99.9	98	65	Numquam perspiciatis voluptates eos non hic architecto.	Ipsum illum officiis harum quibusdam numquam quas reprehenderit.	2025-08-20	Accusantium autem nobis eius temporibus saepe recusandae voluptatum.	2025-07-26	12:30	3	pending	APT10758	\N
9760	149	10	2025-07-26 14:00:00	Diabetes Check	OPD	Corporis sequi recusandae.	2025-06-26 22:30:08	2025-06-26 22:30:08	120/65	85	99.0	100	57	Aliquid debitis natus.	Quos necessitatibus laboriosam quos quasi cum quo.	2025-08-14	Beatae aspernatur fuga ea natus alias est.	2025-07-26	14:00	3	pending	APT10759	\N
9761	413	6	2025-07-26 11:30:00	High BP	New	Minima quisquam voluptates animi animi delectus.	2025-06-26 22:30:08	2025-06-26 22:30:08	127/67	100	98.4	95	59	Porro placeat cum placeat at.	Dolores beatae quae doloribus totam.	2025-08-22	Dolorem molestias eius expedita.	2025-07-26	11:30	3	pending	APT10760	\N
9762	203	3	2025-07-26 15:00:00	Cough	New	Nam tempore non corrupti doloremque optio.	2025-06-26 22:30:08	2025-06-26 22:30:08	121/69	71	99.9	97	73	Cumque quod optio eveniet vel sequi minus.	Repellat id modi non ea facilis ratione adipisci voluptates non.	2025-08-02	Ipsam nam quisquam velit nobis modi at.	2025-07-26	15:00	3	pending	APT10761	\N
9763	117	3	2025-07-26 16:45:00	Routine Checkup	New	Ipsa quidem nam aperiam id commodi.	2025-06-26 22:30:08	2025-06-26 22:30:08	140/73	70	99.7	98	63	Asperiores aut explicabo. Esse accusantium quis rem.	Voluptatibus facere minima consequuntur sequi illo ut repellat velit iste.	2025-08-14	Cumque molestiae eveniet rem dicta ullam iure.	2025-07-26	16:45	3	pending	APT10762	\N
9764	5	5	2025-07-26 11:15:00	Fever	OPD	Alias reiciendis nobis autem.	2025-06-26 22:30:08	2025-06-26 22:30:08	114/66	95	99.2	96	64	Eius impedit alias voluptatum quod corrupti placeat.	At voluptates quod tempora numquam cumque corrupti commodi dolorum ea quasi.	2025-08-04	Quasi minus nam mollitia.	2025-07-26	11:15	3	pending	APT10763	\N
9765	147	4	2025-07-26 15:15:00	High BP	OPD	Atque iure eos optio.	2025-06-26 22:30:08	2025-06-26 22:30:08	108/76	82	98.0	98	57	Ea accusantium provident asperiores soluta iure.	Optio distinctio labore incidunt odit laborum et sint aliquam dolor.	2025-08-07	Quibusdam cum excepturi eos similique odit.	2025-07-26	15:15	3	pending	APT10764	\N
9766	357	8	2025-07-26 14:00:00	Skin Rash	Emergency	Amet aut eum non minus.	2025-06-26 22:30:08	2025-06-26 22:30:08	102/74	100	99.7	97	85	Quos quibusdam neque earum nam officiis exercitationem cum.	Enim inventore ipsum ut culpa minus deserunt velit sint harum.	2025-08-04	Voluptatem accusamus a pariatur nam quo necessitatibus.	2025-07-26	14:00	3	pending	APT10765	\N
9767	493	8	2025-07-26 15:30:00	Skin Rash	OPD	Minus ut dolor commodi.	2025-06-26 22:30:08	2025-06-26 22:30:08	103/74	65	98.2	100	65	Veritatis accusantium eius ea culpa corrupti.	Ut exercitationem quibusdam sapiente atque commodi.	2025-08-05	Illo a maxime dolorum sequi aperiam rerum aliquid.	2025-07-26	15:30	3	pending	APT10766	\N
9768	142	6	2025-07-26 14:15:00	Skin Rash	OPD	Ea natus impedit officia laboriosam.	2025-06-26 22:30:08	2025-06-26 22:30:08	125/73	80	98.2	99	82	Odio odit doloribus molestiae aut architecto.	Beatae quisquam quod aperiam.	2025-08-18	Iusto veritatis necessitatibus perspiciatis quod iusto.	2025-07-26	14:15	3	pending	APT10767	\N
9769	352	8	2025-07-26 14:45:00	Routine Checkup	Emergency	Culpa consectetur labore debitis molestiae accusantium.	2025-06-26 22:30:08	2025-06-26 22:30:08	115/85	89	99.9	100	72	Quidem alias rem fugit.	Illo quia exercitationem iste itaque.	2025-08-04	Culpa ipsa tempore expedita harum exercitationem ab.	2025-07-26	14:45	3	pending	APT10768	\N
9770	364	8	2025-07-26 14:15:00	Headache	New	Molestias nobis nobis voluptate.	2025-06-26 22:30:08	2025-06-26 22:30:08	111/80	80	100.0	97	75	Sunt perspiciatis numquam sint deserunt nisi recusandae.	Consequuntur tempore minus ducimus enim aliquam non.	2025-08-24	Culpa voluptas pariatur possimus ad laudantium molestias.	2025-07-26	14:15	3	pending	APT10769	\N
9771	375	10	2025-07-26 15:30:00	Cough	Follow-up	Excepturi sunt officia rem tempora.	2025-06-26 22:30:08	2025-06-26 22:30:08	134/80	92	98.1	96	69	Eius mollitia ipsa nostrum doloremque.	Repudiandae aliquam laborum ut voluptates debitis molestiae.	2025-08-17	Consequuntur labore eum repellat cupiditate eos consequatur.	2025-07-26	15:30	3	pending	APT10770	\N
9772	369	10	2025-07-26 16:00:00	Cough	Emergency	Hic eveniet sint dolores fugit ratione soluta animi.	2025-06-26 22:30:08	2025-06-26 22:30:08	121/86	97	100.0	98	82	Incidunt voluptatem iste.	Maiores quia magni blanditiis sit voluptatem dolorum modi occaecati.	2025-08-02	Quidem aut illo ipsa eligendi.	2025-07-26	16:00	3	pending	APT10771	\N
9773	324	4	2025-07-26 12:30:00	Routine Checkup	Follow-up	Quod necessitatibus ipsam voluptatem debitis neque reiciendis.	2025-06-26 22:30:08	2025-06-26 22:30:08	116/83	66	99.7	100	78	Aut quibusdam quasi officiis reiciendis nobis.	Facere voluptas eveniet aspernatur cupiditate harum ratione iste maiores.	2025-08-13	Adipisci explicabo tempora optio accusantium enim ullam ratione.	2025-07-26	12:30	3	pending	APT10772	\N
9774	90	6	2025-07-26 11:00:00	Headache	New	Sunt atque fugit sunt sequi ipsam odio iusto.	2025-06-26 22:30:08	2025-06-26 22:30:08	118/79	68	99.5	100	85	Voluptatem labore hic assumenda.	Nihil et modi vitae laborum sunt.	2025-08-18	Dolorum nisi iure deleniti.	2025-07-26	11:00	3	pending	APT10773	\N
9775	148	10	2025-07-26 14:00:00	Diabetes Check	OPD	Ut est veniam animi.	2025-06-26 22:30:08	2025-06-26 22:30:08	100/87	76	97.9	97	80	Minus omnis laudantium voluptatum quasi.	Aperiam ex consequatur minus quasi eius error.	2025-08-11	Aspernatur minus dolor vero provident nisi consequuntur dolorum.	2025-07-26	14:00	3	pending	APT10774	\N
9776	430	5	2025-07-26 12:00:00	Diabetes Check	Follow-up	Delectus sed cumque ipsum doloremque molestiae.	2025-06-26 22:30:08	2025-06-26 22:30:08	124/80	87	99.4	100	82	Quod veritatis asperiores nostrum at.	Ad eum ex minima aut magnam optio dolorum dolorum quae.	2025-08-19	Suscipit ducimus porro culpa quaerat velit perferendis.	2025-07-26	12:00	3	pending	APT10775	\N
9777	252	9	2025-07-26 13:00:00	Skin Rash	Emergency	Error vel voluptate earum cum neque sit.	2025-06-26 22:30:08	2025-06-26 22:30:08	116/60	100	99.8	100	76	Ab dolorum maxime facere ipsa nisi quas.	Consectetur illum ab laborum dolorem quae amet distinctio dicta deleniti.	2025-08-03	Veniam dicta magni maiores animi dolorum reiciendis.	2025-07-26	13:00	3	pending	APT10776	\N
9778	68	6	2025-07-26 15:45:00	Cough	OPD	Enim occaecati facere consequatur neque ullam sed.	2025-06-26 22:30:08	2025-06-26 22:30:08	130/78	76	99.9	97	74	Accusantium ipsa reiciendis fugit.	Vero ducimus repellat tenetur ad voluptas quibusdam maiores quod.	2025-08-14	Rem illo voluptas vitae iure neque voluptatum consectetur.	2025-07-26	15:45	3	pending	APT10777	\N
9779	87	8	2025-07-26 11:15:00	Skin Rash	OPD	Placeat quaerat minus nobis suscipit aliquid.	2025-06-26 22:30:08	2025-06-26 22:30:08	116/62	89	99.2	99	63	Eaque inventore voluptatibus ipsam ex.	Incidunt ipsa voluptatem ipsa doloremque soluta vitae totam.	2025-08-21	Nisi minus animi earum laboriosam minima rerum.	2025-07-26	11:15	3	pending	APT10778	\N
9780	402	7	2025-07-26 13:30:00	Cough	New	Voluptas ipsam maxime ipsam facilis labore placeat.	2025-06-26 22:30:08	2025-06-26 22:30:08	139/62	100	97.9	98	75	Ab pariatur illum distinctio sed amet perspiciatis.	Reiciendis recusandae natus nam rerum tenetur voluptatibus.	2025-08-24	Repellat laboriosam officiis.	2025-07-26	13:30	3	pending	APT10779	\N
9781	173	5	2025-07-26 14:15:00	Cough	Follow-up	Voluptate ipsa sed natus.	2025-06-26 22:30:08	2025-06-26 22:30:08	119/67	82	99.0	95	66	Esse consequuntur voluptas optio sint nemo autem aliquid.	Quos voluptates itaque vero voluptatem provident assumenda dolore voluptas molestiae eligendi.	2025-08-23	Odit recusandae commodi voluptatem.	2025-07-26	14:15	3	pending	APT10780	\N
9782	240	7	2025-07-26 13:15:00	Fever	New	Maxime fuga illum sint ullam.	2025-06-26 22:30:08	2025-06-26 22:30:08	112/88	68	98.3	96	55	Repellat impedit quae dicta adipisci.	Rerum quibusdam accusantium praesentium non velit facilis consectetur vero.	2025-08-25	Culpa cum in consequuntur.	2025-07-26	13:15	3	pending	APT10781	\N
9783	155	4	2025-07-26 16:00:00	Skin Rash	New	Repellat reiciendis est et nesciunt et iusto.	2025-06-26 22:30:08	2025-06-26 22:30:08	103/80	86	99.3	99	82	Repellat iste alias.	Corporis quas accusantium quo modi laboriosam ea accusantium.	2025-08-22	Sit id modi ea cum necessitatibus sit sit.	2025-07-26	16:00	3	pending	APT10782	\N
9784	34	5	2025-07-26 14:00:00	Skin Rash	New	Perferendis maiores deleniti perferendis iusto architecto.	2025-06-26 22:30:08	2025-06-26 22:30:08	122/81	98	100.1	96	74	Eligendi dolorem natus asperiores ab atque culpa.	Nemo vel non ipsum nam nihil.	2025-08-11	Quas pariatur sit iste cupiditate.	2025-07-26	14:00	3	pending	APT10783	\N
9785	270	5	2025-07-27 11:00:00	Headache	Follow-up	Nemo nam animi.	2025-06-26 22:30:08	2025-06-26 22:30:08	129/79	81	99.9	99	69	Quos sapiente accusamus nisi velit hic enim.	Cum illo ipsam doloribus vero itaque ab blanditiis architecto quos.	2025-08-22	Ex cupiditate in impedit expedita temporibus.	2025-07-27	11:00	3	pending	APT10784	\N
9786	196	4	2025-07-27 16:00:00	Cough	Follow-up	Voluptatibus distinctio repudiandae magni voluptatem exercitationem.	2025-06-26 22:30:08	2025-06-26 22:30:08	116/89	76	100.4	99	57	Hic totam reprehenderit doloremque.	At impedit enim ratione temporibus quasi alias at aliquam vitae.	2025-08-05	Dignissimos rerum voluptates maiores odit praesentium porro.	2025-07-27	16:00	3	pending	APT10785	\N
9787	213	9	2025-07-27 15:00:00	Cough	New	Eligendi dolorum possimus nulla esse quasi.	2025-06-26 22:30:08	2025-06-26 22:30:08	139/67	93	100.0	97	78	Vero qui quam cupiditate a occaecati nesciunt.	Omnis debitis ullam dolores ipsum fuga.	2025-08-18	Dignissimos praesentium alias nostrum totam totam fugiat.	2025-07-27	15:00	3	pending	APT10786	\N
9788	421	9	2025-07-27 12:15:00	Back Pain	Emergency	Minus neque cumque voluptates alias.	2025-06-26 22:30:08	2025-06-26 22:30:08	111/88	70	98.3	97	75	Fugiat labore expedita molestiae.	Id porro maiores nulla deserunt atque debitis ratione laborum id porro.	2025-08-15	Eveniet accusamus maiores itaque culpa.	2025-07-27	12:15	3	pending	APT10787	\N
9789	444	9	2025-07-27 11:15:00	Back Pain	Follow-up	Amet laudantium saepe dolorum animi ut.	2025-06-26 22:30:08	2025-06-26 22:30:08	124/89	93	98.6	99	68	Tempora error repellendus quae vero ipsa eaque.	Corrupti accusamus dolorum beatae nam expedita earum unde ex dicta.	2025-08-06	Explicabo perspiciatis asperiores eum alias neque.	2025-07-27	11:15	3	pending	APT10788	\N
9790	387	3	2025-07-27 15:15:00	Fever	Emergency	Numquam cum quod dolores nobis architecto.	2025-06-26 22:30:08	2025-06-26 22:30:08	123/77	72	99.7	96	61	Et sequi ex minima tempora repellat ullam dolorem.	Alias facere labore ducimus facilis.	2025-08-13	Sed consequatur in soluta.	2025-07-27	15:15	3	pending	APT10789	\N
9791	257	7	2025-07-27 16:15:00	Back Pain	OPD	Quibusdam quas impedit hic.	2025-06-26 22:30:08	2025-06-26 22:30:08	107/90	77	97.8	97	81	Fugiat quas sed eligendi reiciendis asperiores quasi.	Magnam eum incidunt enim aliquam explicabo vitae magnam.	2025-08-14	Labore maxime itaque tenetur dolor ex ullam eaque.	2025-07-27	16:15	3	pending	APT10790	\N
9792	363	10	2025-07-27 11:45:00	Headache	OPD	Occaecati optio fugiat animi cupiditate error.	2025-06-26 22:30:08	2025-06-26 22:30:08	126/84	81	98.6	96	57	Ad quidem quae quod sit impedit.	Vero cumque labore exercitationem incidunt.	2025-08-17	Nesciunt libero quidem a.	2025-07-27	11:45	3	pending	APT10791	\N
9793	135	10	2025-07-27 12:30:00	Headache	Follow-up	Reprehenderit necessitatibus similique harum minus autem excepturi.	2025-06-26 22:30:08	2025-06-26 22:30:08	112/78	67	97.5	100	61	Dolor dolorem atque excepturi sint quis.	Soluta modi temporibus ut.	2025-08-26	Consequuntur quam necessitatibus facere veniam.	2025-07-27	12:30	3	pending	APT10792	\N
9794	411	6	2025-07-27 13:30:00	Back Pain	OPD	Atque eligendi maxime debitis.	2025-06-26 22:30:08	2025-06-26 22:30:08	136/71	96	100.3	97	76	Exercitationem dicta nihil deleniti explicabo rem.	Tempora debitis expedita quis animi incidunt delectus eum ex ratione.	2025-08-16	Labore repellat animi earum.	2025-07-27	13:30	3	pending	APT10793	\N
9795	500	8	2025-07-27 13:00:00	Headache	New	Provident consequatur tempora consequuntur aut.	2025-06-26 22:30:08	2025-06-26 22:30:08	123/85	97	99.4	97	71	Consequatur ut minus minus consectetur dicta.	Perspiciatis vero harum distinctio odio amet perspiciatis beatae repellendus aperiam.	2025-08-12	Voluptatum quidem rem aut.	2025-07-27	13:00	3	pending	APT10794	\N
9796	325	3	2025-07-27 12:30:00	Headache	OPD	Nesciunt aliquid ratione dolores sit labore.	2025-06-26 22:30:08	2025-06-26 22:30:08	106/87	73	97.9	100	57	Sapiente animi optio facilis facilis dicta neque sapiente.	Quo quae molestias quaerat libero sapiente quos.	2025-08-20	Sapiente voluptate laudantium vitae eaque recusandae dolore.	2025-07-27	12:30	3	pending	APT10795	\N
9797	113	3	2025-07-27 16:15:00	High BP	New	Fugiat error porro debitis numquam.	2025-06-26 22:30:08	2025-06-26 22:30:08	138/87	86	98.0	97	82	Totam autem ut.	Delectus minima tenetur laboriosam alias pariatur nihil incidunt eos aperiam.	2025-08-18	Incidunt commodi repudiandae natus.	2025-07-27	16:15	3	pending	APT10796	\N
9798	411	4	2025-07-27 11:30:00	High BP	New	Illum magnam dicta accusantium.	2025-06-26 22:30:08	2025-06-26 22:30:08	102/69	93	98.0	99	61	Aliquid porro sequi itaque asperiores.	Fuga itaque explicabo corrupti officia quam saepe ullam ipsa.	2025-08-16	Cumque ex vero.	2025-07-27	11:30	3	pending	APT10797	\N
9799	320	7	2025-07-27 16:45:00	High BP	Follow-up	Unde officia consequuntur.	2025-06-26 22:30:08	2025-06-26 22:30:08	109/75	68	97.9	100	77	Fugit asperiores similique explicabo optio enim.	Neque quasi vel in consectetur corrupti labore incidunt qui minima ipsa.	2025-08-21	Tempore minus nisi dolorum inventore cupiditate.	2025-07-27	16:45	3	pending	APT10798	\N
9800	102	4	2025-07-27 16:15:00	Diabetes Check	OPD	Dicta dolor a fuga natus reiciendis.	2025-06-26 22:30:08	2025-06-26 22:30:08	100/70	78	97.6	95	67	Maiores voluptatum debitis nihil atque.	Quibusdam illo saepe provident delectus velit minima eum.	2025-08-14	Modi sed rerum eligendi enim.	2025-07-27	16:15	3	pending	APT10799	\N
9801	351	4	2025-07-27 14:45:00	Fever	OPD	Facere sint id incidunt quidem quisquam aperiam.	2025-06-26 22:30:08	2025-06-26 22:30:08	122/66	81	98.7	99	65	Eius consequatur harum eligendi adipisci aut ab.	Illo excepturi soluta esse qui sapiente labore aspernatur tenetur.	2025-08-05	Dolores dolor repudiandae iste.	2025-07-27	14:45	3	pending	APT10800	\N
9802	26	10	2025-07-27 13:45:00	Headache	New	Dolore quos itaque minus eaque.	2025-06-26 22:30:08	2025-06-26 22:30:08	103/60	88	99.2	95	85	Illum maiores veniam itaque recusandae laborum voluptate.	Modi consequatur esse aspernatur voluptas praesentium iure facere.	2025-08-14	Nulla ad facere ut minus optio aspernatur.	2025-07-27	13:45	3	pending	APT10801	\N
9803	457	3	2025-07-27 12:15:00	Routine Checkup	Follow-up	Beatae reiciendis iste dolorem.	2025-06-26 22:30:08	2025-06-26 22:30:08	116/75	86	98.8	97	68	Aperiam nostrum vitae voluptas maiores.	Alias fuga exercitationem ea beatae voluptas repellat ut.	2025-08-23	Optio ad deserunt explicabo ea nihil.	2025-07-27	12:15	3	pending	APT10802	\N
9804	389	5	2025-07-27 13:00:00	Fever	New	Distinctio quas ab sequi.	2025-06-26 22:30:08	2025-06-26 22:30:08	108/87	79	98.2	97	66	Non molestiae reiciendis neque quasi cupiditate corporis.	Dolor totam sunt veniam.	2025-08-12	Exercitationem itaque corrupti mollitia libero fugit dicta nostrum.	2025-07-27	13:00	3	pending	APT10803	\N
9805	49	5	2025-07-27 13:00:00	Cough	Follow-up	Aliquam repellat dolorum corrupti doloribus.	2025-06-26 22:30:08	2025-06-26 22:30:08	129/73	87	99.9	99	66	Laborum veniam fugiat fuga.	Totam dolor similique adipisci ad.	2025-08-08	A tempore tenetur molestias tempore tempora eos.	2025-07-27	13:00	3	pending	APT10804	\N
9806	140	6	2025-07-27 13:45:00	Headache	Follow-up	At deserunt aliquid vitae distinctio autem ipsa.	2025-06-26 22:30:08	2025-06-26 22:30:08	136/73	96	99.5	98	71	Beatae ad asperiores natus. Ullam ab sit dolorum.	Error quae eos ullam est ad quia exercitationem hic accusantium.	2025-08-17	Voluptas distinctio autem eligendi itaque delectus dolorem.	2025-07-27	13:45	3	pending	APT10805	\N
9807	105	4	2025-07-27 15:15:00	Back Pain	Emergency	Nostrum aspernatur ipsum iusto eligendi.	2025-06-26 22:30:08	2025-06-26 22:30:08	106/82	67	99.4	95	61	Molestias ab ab illo provident mollitia iure.	Praesentium voluptate nostrum molestias at quae nesciunt hic.	2025-08-18	Maxime fuga mollitia veniam quibusdam sed officiis.	2025-07-27	15:15	3	pending	APT10806	\N
9808	344	7	2025-07-27 13:45:00	High BP	Follow-up	Deleniti consequatur reiciendis ipsam fugit ipsum fugiat.	2025-06-26 22:30:08	2025-06-26 22:30:08	135/70	79	98.9	98	84	Accusamus beatae animi necessitatibus. Animi maxime autem.	Officiis sit deleniti modi maiores a fugit aut.	2025-08-09	Tenetur aliquid porro odio.	2025-07-27	13:45	3	pending	APT10807	\N
9809	398	6	2025-07-27 16:00:00	Cough	Follow-up	Porro sequi aut culpa quibusdam ea quisquam.	2025-06-26 22:30:08	2025-06-26 22:30:08	103/90	86	100.0	97	59	Aperiam ea natus laudantium.	Tempore veniam rem accusamus harum quam totam similique.	2025-08-20	Aut nihil cum.	2025-07-27	16:00	3	pending	APT10808	\N
9810	130	3	2025-07-27 12:45:00	Headache	Follow-up	Molestiae ab hic commodi.	2025-06-26 22:30:08	2025-06-26 22:30:08	134/79	82	99.5	100	80	Repellendus consectetur provident dignissimos.	Tempore tempore esse inventore facilis.	2025-08-08	Quia eligendi corporis repellat voluptatibus necessitatibus dolore.	2025-07-27	12:45	3	pending	APT10809	\N
9811	444	6	2025-07-27 15:15:00	High BP	Follow-up	Incidunt qui consequatur.	2025-06-26 22:30:08	2025-06-26 22:30:08	129/80	81	97.8	100	67	Deserunt rerum accusamus iure recusandae.	Consequatur quod laboriosam officia dignissimos atque corrupti.	2025-08-22	Reiciendis ratione et odio.	2025-07-27	15:15	3	pending	APT10810	\N
9812	324	8	2025-07-28 14:15:00	Headache	New	Ut soluta vel nihil deserunt labore distinctio.	2025-06-26 22:30:08	2025-06-26 22:30:08	109/66	83	97.6	95	64	Amet et quam. Reprehenderit nisi labore dolores.	Libero ad fugit nostrum fuga.	2025-08-23	Necessitatibus quisquam ullam sequi.	2025-07-28	14:15	3	pending	APT10811	\N
9813	357	8	2025-07-28 11:15:00	Cough	OPD	Laudantium impedit maxime.	2025-06-26 22:30:08	2025-06-26 22:30:08	139/73	82	99.8	95	59	Ipsam odio dolores ullam cumque commodi eligendi.	Laborum ratione voluptates esse labore quas voluptatibus hic.	2025-08-25	Deserunt earum quis.	2025-07-28	11:15	3	pending	APT10812	\N
9814	464	5	2025-07-28 11:00:00	Diabetes Check	Follow-up	Voluptatem totam voluptatem aliquam quasi.	2025-06-26 22:30:08	2025-06-26 22:30:08	129/75	73	100.1	99	67	Repudiandae odit vel occaecati mollitia delectus aut.	At nam sequi facilis in ut autem quis.	2025-08-27	Eaque ullam eaque numquam iusto.	2025-07-28	11:00	3	pending	APT10813	\N
9815	147	6	2025-07-28 16:30:00	Diabetes Check	Follow-up	Eum enim quibusdam itaque saepe ex cupiditate cum.	2025-06-26 22:30:08	2025-06-26 22:30:08	112/68	71	100.1	99	60	Assumenda commodi eveniet excepturi distinctio culpa.	Dolores tempora nulla natus officia reiciendis perferendis quos est numquam.	2025-08-15	Recusandae sint minima.	2025-07-28	16:30	3	pending	APT10814	\N
9816	102	7	2025-07-28 16:00:00	Cough	OPD	Quae laborum ratione blanditiis.	2025-06-26 22:30:08	2025-06-26 22:30:08	120/66	73	100.2	98	59	Asperiores sint labore cum quis at a.	Dicta alias error rem perferendis.	2025-08-12	Delectus quam accusantium non.	2025-07-28	16:00	3	pending	APT10815	\N
9817	146	7	2025-07-28 11:45:00	Back Pain	Follow-up	Pariatur iste dolores in delectus quae incidunt.	2025-06-26 22:30:08	2025-06-26 22:30:08	122/60	75	99.3	98	71	Consequuntur dolorem illum dicta sit rem eum.	Sequi beatae error quisquam sed quod tempore.	2025-08-10	Laudantium vel accusantium similique.	2025-07-28	11:45	3	pending	APT10816	\N
9818	271	9	2025-07-28 15:15:00	High BP	New	Cumque ratione sit eaque reiciendis error.	2025-06-26 22:30:08	2025-06-26 22:30:08	108/74	86	99.3	100	59	Quia accusamus beatae deserunt. Est rerum in in.	Non molestiae tempora cum distinctio totam autem est voluptatum minima placeat.	2025-08-17	Omnis est deleniti totam velit eius rem.	2025-07-28	15:15	3	pending	APT10817	\N
9819	407	10	2025-07-28 16:15:00	Cough	Emergency	Rerum perspiciatis voluptatem deleniti.	2025-06-26 22:30:08	2025-06-26 22:30:08	134/77	70	99.5	100	79	Sint quidem mollitia eos eligendi dolorem.	Natus enim quod eveniet soluta autem minus praesentium.	2025-08-20	Voluptatem iusto error laudantium cum voluptatum placeat.	2025-07-28	16:15	3	pending	APT10818	\N
9820	487	7	2025-07-28 15:00:00	Back Pain	New	Velit et deleniti necessitatibus impedit soluta recusandae.	2025-06-26 22:30:08	2025-06-26 22:30:08	138/83	78	100.3	100	66	Ad maiores molestias porro corrupti.	Ducimus rerum necessitatibus voluptate placeat minima eius consequuntur officia officiis.	2025-08-09	Repudiandae eligendi quam doloremque quis voluptas.	2025-07-28	15:00	3	pending	APT10819	\N
9821	463	6	2025-07-28 12:45:00	Routine Checkup	New	Nobis occaecati eligendi ut eveniet harum numquam.	2025-06-26 22:30:08	2025-06-26 22:30:08	106/86	85	98.0	100	81	Odit earum nesciunt.	Ut dolorum veritatis accusamus a asperiores voluptates ab porro explicabo.	2025-08-26	Dicta modi aperiam optio hic explicabo autem.	2025-07-28	12:45	3	pending	APT10820	\N
9822	437	7	2025-07-28 15:15:00	High BP	Follow-up	Aspernatur asperiores odit odio.	2025-06-26 22:30:08	2025-06-26 22:30:08	103/88	90	98.7	95	55	Reprehenderit tempore dicta ipsum non iste velit.	Earum exercitationem totam dolore rem ab ipsum hic maxime reprehenderit.	2025-08-16	At soluta ipsum ullam illum.	2025-07-28	15:15	3	pending	APT10821	\N
9823	410	3	2025-07-28 13:15:00	Back Pain	Emergency	Nulla maiores dolores.	2025-06-26 22:30:08	2025-06-26 22:30:08	119/73	91	100.1	97	58	Atque illum quo.	Repellendus et possimus corrupti consequuntur minus sapiente illo.	2025-08-06	Facilis minus totam corrupti.	2025-07-28	13:15	3	pending	APT10822	\N
9824	266	9	2025-07-28 15:00:00	Routine Checkup	Follow-up	Reprehenderit repellendus tenetur saepe est cumque perferendis.	2025-06-26 22:30:08	2025-06-26 22:30:08	104/87	78	100.2	97	66	Voluptate animi repudiandae atque dolorem dicta cupiditate.	Officiis ad nostrum pariatur totam.	2025-08-08	Nulla nesciunt labore.	2025-07-28	15:00	3	pending	APT10823	\N
9825	113	3	2025-07-28 16:00:00	Back Pain	New	Error hic officiis quaerat.	2025-06-26 22:30:08	2025-06-26 22:30:08	103/87	100	98.5	99	61	Vel veritatis minima itaque esse sint exercitationem.	Fugit fugit et minima minima harum minus rem.	2025-08-15	Harum vel provident saepe.	2025-07-28	16:00	3	pending	APT10824	\N
9826	289	5	2025-07-28 12:45:00	Back Pain	Follow-up	Ducimus autem sint hic debitis debitis aliquid.	2025-06-26 22:30:08	2025-06-26 22:30:08	116/87	70	99.6	99	76	Beatae in iure pariatur quis aliquam neque.	Maxime adipisci rerum error consequatur corrupti itaque magni distinctio.	2025-08-19	Nam voluptatibus totam veritatis natus eius.	2025-07-28	12:45	3	pending	APT10825	\N
9827	357	5	2025-07-28 16:00:00	Fever	Follow-up	Aperiam omnis quisquam quidem.	2025-06-26 22:30:08	2025-06-26 22:30:08	108/76	65	97.8	100	65	Quisquam quas nesciunt molestiae quia repudiandae commodi.	Eveniet assumenda accusantium doloremque odit esse deleniti accusantium dolore numquam.	2025-08-12	Quisquam laudantium at exercitationem reiciendis omnis.	2025-07-28	16:00	3	pending	APT10826	\N
9828	243	6	2025-07-28 14:30:00	Routine Checkup	Follow-up	Dolore consectetur quisquam expedita.	2025-06-26 22:30:08	2025-06-26 22:30:08	131/78	71	99.1	96	78	Quidem vero id provident iusto magnam eos.	Eum neque odit blanditiis ipsa maiores.	2025-08-11	Cupiditate maxime eos error libero accusamus.	2025-07-28	14:30	3	pending	APT10827	\N
9829	234	9	2025-07-28 16:15:00	Diabetes Check	OPD	Quidem sunt voluptatum aperiam.	2025-06-26 22:30:08	2025-06-26 22:30:08	110/79	89	100.3	98	77	Vero ex maiores dolor. Veniam modi atque eaque.	Explicabo numquam perferendis ut nihil enim non id.	2025-08-23	Alias eum commodi quos dignissimos.	2025-07-28	16:15	3	pending	APT10828	\N
9830	297	5	2025-07-28 13:30:00	Routine Checkup	Follow-up	Repudiandae eaque dolorem.	2025-06-26 22:30:08	2025-06-26 22:30:08	140/60	89	97.9	96	82	Ex a soluta cupiditate eligendi ad blanditiis.	Aliquid repellat quae error nesciunt odio quod ad ut.	2025-08-21	Voluptates ducimus at cum.	2025-07-28	13:30	3	pending	APT10829	\N
9831	40	6	2025-07-28 14:00:00	High BP	Emergency	Optio id eos sit voluptas facilis.	2025-06-26 22:30:08	2025-06-26 22:30:08	104/76	96	99.9	98	66	Deserunt nesciunt magnam nulla libero inventore soluta.	Modi magnam natus neque mollitia voluptate fugit incidunt.	2025-08-24	Earum doloribus officia recusandae delectus cum eveniet.	2025-07-28	14:00	3	pending	APT10830	\N
9832	308	8	2025-07-28 14:15:00	Back Pain	New	Impedit sed est accusamus distinctio nihil omnis aliquam.	2025-06-26 22:30:08	2025-06-26 22:30:08	118/67	67	99.5	95	63	Esse et quod. Unde sint in error minus.	Exercitationem ex magnam possimus illo cum nihil nostrum fuga quam perspiciatis.	2025-08-18	Architecto rem ut earum dignissimos ea.	2025-07-28	14:15	3	pending	APT10831	\N
9833	271	6	2025-07-29 11:45:00	Fever	Follow-up	Eaque doloribus laboriosam.	2025-06-26 22:30:08	2025-06-26 22:30:08	105/64	92	97.6	95	81	Quos quasi ab cumque accusamus beatae.	Alias deserunt cupiditate rerum ex ex explicabo expedita necessitatibus libero.	2025-08-24	Harum animi quia cum vero laudantium.	2025-07-29	11:45	3	pending	APT10832	\N
9834	250	6	2025-07-29 11:45:00	High BP	Follow-up	Vero repellat ratione laudantium.	2025-06-26 22:30:08	2025-06-26 22:30:08	122/87	96	98.7	99	75	Provident natus a quidem dicta pariatur officiis excepturi.	Molestias id nobis voluptatibus modi aliquid soluta.	2025-08-09	Laudantium exercitationem fugit quisquam animi eius id.	2025-07-29	11:45	3	pending	APT10833	\N
9835	500	9	2025-07-29 15:15:00	Skin Rash	New	Amet sint a similique sint hic sunt.	2025-06-26 22:30:08	2025-06-26 22:30:08	107/64	98	99.8	100	79	Veritatis adipisci nam quia. Fugiat molestias quis omnis.	At tempora quidem cum voluptate quis.	2025-08-22	Amet voluptas architecto sit quibusdam sit.	2025-07-29	15:15	3	pending	APT10834	\N
9836	102	3	2025-07-29 13:00:00	Headache	OPD	Dicta saepe laborum quia ea voluptatibus quos.	2025-06-26 22:30:08	2025-06-26 22:30:08	124/83	86	97.9	99	63	Sapiente atque tenetur voluptatum.	Temporibus magnam error fugiat iste architecto sit hic.	2025-08-25	Quaerat qui sint illum at totam soluta.	2025-07-29	13:00	3	pending	APT10835	\N
9837	445	4	2025-07-29 13:00:00	Routine Checkup	OPD	Ipsum sit nihil.	2025-06-26 22:30:08	2025-06-26 22:30:08	107/90	69	97.9	100	63	Eos sapiente maiores iure alias.	Asperiores maiores minus commodi id odio reprehenderit officia.	2025-08-08	Cumque sapiente ab exercitationem eum sit.	2025-07-29	13:00	3	pending	APT10836	\N
9838	490	6	2025-07-29 12:00:00	Routine Checkup	OPD	Soluta modi consequuntur suscipit.	2025-06-26 22:30:08	2025-06-26 22:30:08	111/90	83	97.8	95	78	Velit saepe quod ipsam optio nemo.	Fugiat aliquid laudantium porro veritatis amet inventore fuga.	2025-08-19	Neque praesentium cum exercitationem.	2025-07-29	12:00	3	pending	APT10837	\N
9839	483	5	2025-07-29 12:00:00	Routine Checkup	New	Delectus dicta officia voluptates repellat.	2025-06-26 22:30:08	2025-06-26 22:30:08	107/75	87	99.0	100	77	Rem perspiciatis blanditiis.	Doloremque natus accusantium excepturi ad laborum facere tempore totam quaerat.	2025-08-07	Minima odio illo nesciunt in veniam fugiat.	2025-07-29	12:00	3	pending	APT10838	\N
9840	419	5	2025-07-29 13:45:00	Routine Checkup	Follow-up	Modi dolorum ullam.	2025-06-26 22:30:08	2025-06-26 22:30:08	126/81	95	99.8	95	60	Nisi corrupti distinctio ipsum nemo deleniti.	Hic odit nam ipsum natus maxime magni autem vero.	2025-08-26	Assumenda quam sed assumenda.	2025-07-29	13:45	3	pending	APT10839	\N
9841	501	10	2025-07-29 13:15:00	Diabetes Check	OPD	Reiciendis illo nisi ratione incidunt ab.	2025-06-26 22:30:08	2025-06-26 22:30:08	101/80	71	98.4	96	65	Illum aspernatur mollitia iusto. Ipsam minus neque.	Non magni fugiat pariatur nam atque.	2025-08-12	Excepturi magnam ad nemo.	2025-07-29	13:15	3	pending	APT10840	\N
9842	15	10	2025-07-29 11:15:00	Skin Rash	Emergency	Molestias itaque dolores repudiandae ea.	2025-06-26 22:30:08	2025-06-26 22:30:08	114/71	66	99.7	96	69	Ipsum harum dolorem ea laborum quidem. Vel nemo unde sint.	Velit doloribus rerum nihil aliquam repellendus assumenda.	2025-08-13	Porro sequi laudantium voluptate quaerat.	2025-07-29	11:15	3	pending	APT10841	\N
9843	49	5	2025-07-29 15:30:00	Fever	New	Quasi quis laborum eligendi nisi delectus animi.	2025-06-26 22:30:08	2025-06-26 22:30:08	124/72	67	99.3	99	70	Nemo qui voluptatibus omnis sed ut possimus.	Adipisci molestiae pariatur sed iure.	2025-08-15	Esse odit quos earum ducimus.	2025-07-29	15:30	3	pending	APT10842	\N
9844	458	3	2025-07-29 13:15:00	Cough	Emergency	Sed beatae temporibus dolore veniam fugiat.	2025-06-26 22:30:08	2025-06-26 22:30:08	118/76	68	99.5	96	67	Esse error temporibus. Perspiciatis quisquam odit ipsum.	Optio accusamus ullam nam a dolores minus ducimus molestias quaerat maxime.	2025-08-10	Dolores corporis quis officiis totam vitae aut.	2025-07-29	13:15	3	pending	APT10843	\N
9845	87	5	2025-07-29 14:00:00	Routine Checkup	Follow-up	Ab cum quisquam ad.	2025-06-26 22:30:08	2025-06-26 22:30:08	120/61	90	100.5	97	71	Incidunt maxime vel. Illum totam quod nobis.	Repudiandae recusandae quo ipsum animi enim.	2025-08-14	Sapiente debitis maxime consequatur.	2025-07-29	14:00	3	pending	APT10844	\N
9846	21	7	2025-07-29 15:30:00	Skin Rash	OPD	Laboriosam eius suscipit voluptate recusandae.	2025-06-26 22:30:08	2025-06-26 22:30:08	100/75	81	99.3	98	84	Illo tenetur consequuntur non nobis quidem.	Doloribus nesciunt vitae fuga hic dolorem.	2025-08-16	Quisquam facilis illo accusantium.	2025-07-29	15:30	3	pending	APT10845	\N
9847	233	5	2025-07-29 13:30:00	Back Pain	Emergency	Possimus cum facere magni provident.	2025-06-26 22:30:08	2025-06-26 22:30:08	105/67	75	97.8	96	71	Dolorum aperiam repellendus expedita itaque consectetur.	Voluptate provident repellendus laborum adipisci repellat cum accusantium atque minus.	2025-08-23	Quae in distinctio libero aperiam iste magni.	2025-07-29	13:30	3	pending	APT10846	\N
9848	500	10	2025-07-29 11:30:00	Routine Checkup	OPD	Nulla occaecati veniam enim neque iste exercitationem.	2025-06-26 22:30:08	2025-06-26 22:30:08	138/79	78	98.0	97	77	Excepturi qui labore iure.	Ex dolorem incidunt animi aliquam officiis dolores laboriosam aliquid.	2025-08-13	Eum eos facere sint aliquam.	2025-07-29	11:30	3	pending	APT10847	\N
9849	313	6	2025-07-29 13:30:00	Back Pain	Emergency	Placeat ipsam vel ullam repellendus commodi.	2025-06-26 22:30:08	2025-06-26 22:30:08	124/72	75	99.7	98	56	Quas culpa maiores. Totam corporis dicta.	Deserunt autem vero dolor possimus veniam autem perferendis iusto occaecati.	2025-08-21	Impedit voluptatem delectus provident facere praesentium numquam.	2025-07-29	13:30	3	pending	APT10848	\N
9850	297	5	2025-07-29 14:15:00	Skin Rash	OPD	Natus atque at rerum.	2025-06-26 22:30:08	2025-06-26 22:30:08	140/87	84	99.2	97	67	Libero quaerat at nulla consectetur sequi dolores.	Consequatur voluptatibus iste quidem.	2025-08-16	Error ab ullam culpa.	2025-07-29	14:15	3	pending	APT10849	\N
9851	419	4	2025-07-29 13:00:00	Cough	Emergency	Sint commodi qui suscipit unde.	2025-06-26 22:30:08	2025-06-26 22:30:08	129/75	82	100.5	98	59	Fugit autem iusto animi.	Dolorem at odit reiciendis.	2025-08-10	Beatae quae ipsum.	2025-07-29	13:00	3	pending	APT10850	\N
9852	98	4	2025-07-29 12:00:00	Headache	OPD	Voluptatum voluptatem ipsum neque.	2025-06-26 22:30:08	2025-06-26 22:30:08	117/61	98	98.6	95	55	Quidem amet quaerat.	Architecto dicta quibusdam iste molestias eos similique dignissimos eos minima.	2025-08-15	Rem aliquam nisi necessitatibus aliquam.	2025-07-29	12:00	3	pending	APT10851	\N
9853	28	9	2025-07-29 14:30:00	Diabetes Check	Follow-up	Cupiditate maiores velit beatae laudantium at tempora consectetur.	2025-06-26 22:30:08	2025-06-26 22:30:08	132/75	78	98.7	95	55	Quia voluptas delectus nobis aliquam.	Natus inventore quia aperiam quam aliquam quidem sequi dignissimos officia.	2025-08-13	Alias nostrum recusandae incidunt eos cum possimus nostrum.	2025-07-29	14:30	3	pending	APT10852	\N
9854	446	5	2025-07-29 14:30:00	Back Pain	OPD	Optio illo minus neque.	2025-06-26 22:30:08	2025-06-26 22:30:08	136/86	94	98.9	97	68	Sapiente incidunt voluptatibus. Eos omnis amet esse nisi.	Unde facilis quo corporis odio laborum.	2025-08-25	Nam saepe odit cum doloribus itaque.	2025-07-29	14:30	3	pending	APT10853	\N
9855	260	8	2025-07-29 15:15:00	Fever	Follow-up	Sit magnam repudiandae vitae aut.	2025-06-26 22:30:08	2025-06-26 22:30:08	131/69	100	98.8	96	73	Sapiente amet rerum molestiae autem non exercitationem.	Quibusdam reprehenderit officia inventore exercitationem.	2025-08-09	Cupiditate adipisci vel culpa quia asperiores a.	2025-07-29	15:15	3	pending	APT10854	\N
9856	437	8	2025-07-29 12:30:00	Cough	OPD	Saepe optio porro praesentium nostrum neque quisquam.	2025-06-26 22:30:08	2025-06-26 22:30:08	123/86	100	97.9	97	80	Consequuntur ipsa saepe reprehenderit quo.	Atque temporibus voluptates nemo fugit tenetur repudiandae amet.	2025-08-24	Esse vel provident blanditiis asperiores dolorum excepturi.	2025-07-29	12:30	3	pending	APT10855	\N
9857	262	10	2025-07-29 12:15:00	Back Pain	Emergency	Iusto sapiente architecto ipsum.	2025-06-26 22:30:08	2025-06-26 22:30:08	110/76	80	98.7	96	59	Sunt ipsa nemo dolore quas ut impedit. Vel eius facere.	Ratione eligendi animi hic blanditiis totam corrupti tenetur enim.	2025-08-07	Eius fugiat quas in quam.	2025-07-29	12:15	3	pending	APT10856	\N
9858	340	8	2025-07-29 11:30:00	Cough	Follow-up	Nostrum consequuntur minima repellat maxime itaque veritatis.	2025-06-26 22:30:08	2025-06-26 22:30:08	132/75	96	99.5	98	61	Accusantium delectus necessitatibus amet.	Nihil autem fugit natus hic nisi.	2025-08-24	Sit repellendus dolore enim harum.	2025-07-29	11:30	3	pending	APT10857	\N
9859	495	6	2025-07-29 13:15:00	Cough	Follow-up	Id possimus nostrum soluta recusandae quas.	2025-06-26 22:30:08	2025-06-26 22:30:08	118/70	80	100.2	100	57	Voluptas corrupti impedit illum sit iure.	At ducimus quisquam sapiente molestiae libero porro nostrum quis.	2025-08-23	Officiis exercitationem blanditiis ut nulla.	2025-07-29	13:15	3	pending	APT10858	\N
9860	14	6	2025-07-30 12:45:00	Headache	Follow-up	Aliquid ut ex omnis odio repudiandae deleniti.	2025-06-26 22:30:08	2025-06-26 22:30:08	102/67	66	98.6	99	69	Dolore quam nam provident cum.	Enim minus porro numquam consequatur.	2025-08-28	Esse provident vitae illum est autem.	2025-07-30	12:45	3	pending	APT10859	\N
9861	349	10	2025-07-30 11:15:00	Headache	Emergency	Quod laborum modi quod vitae.	2025-06-26 22:30:08	2025-06-26 22:30:08	112/69	68	97.5	98	74	Cupiditate qui id eveniet fuga.	Maiores aliquam deleniti unde deserunt.	2025-08-10	Expedita culpa quia quidem.	2025-07-30	11:15	3	pending	APT10860	\N
9862	110	8	2025-07-30 13:15:00	Routine Checkup	New	Nesciunt nisi id provident culpa rem.	2025-06-26 22:30:08	2025-06-26 22:30:08	121/85	66	98.7	100	59	Eius expedita nemo voluptates facilis laboriosam.	Blanditiis beatae eius quibusdam quis natus accusamus numquam.	2025-08-07	Magni esse eum hic ut.	2025-07-30	13:15	3	pending	APT10861	\N
9863	114	8	2025-07-30 16:45:00	High BP	Follow-up	At illum laborum molestiae maxime optio nostrum dolorem.	2025-06-26 22:30:08	2025-06-26 22:30:08	108/85	74	97.6	99	73	Repellat quia repudiandae sequi soluta.	Nisi incidunt ducimus quos tenetur.	2025-08-09	Temporibus dicta necessitatibus provident natus perspiciatis.	2025-07-30	16:45	3	pending	APT10862	\N
9864	118	5	2025-07-30 12:00:00	Diabetes Check	Follow-up	Quo architecto repudiandae magni cupiditate dolore.	2025-06-26 22:30:08	2025-06-26 22:30:08	133/79	72	98.2	95	75	Esse fugiat velit magni rem nostrum accusantium.	Fuga accusamus tempora natus itaque aliquam.	2025-08-15	Architecto quod odio quia eveniet non tenetur.	2025-07-30	12:00	3	pending	APT10863	\N
9865	235	6	2025-07-30 14:30:00	Fever	Emergency	Expedita accusantium dolores deleniti.	2025-06-26 22:30:08	2025-06-26 22:30:08	129/73	96	99.1	96	69	Hic dicta sequi ex cum rerum.	Distinctio itaque aliquam pariatur quisquam veritatis vitae id sunt nemo.	2025-08-14	Odit facilis expedita placeat quod veniam nesciunt in.	2025-07-30	14:30	3	pending	APT10864	\N
9866	72	9	2025-07-30 14:00:00	Routine Checkup	OPD	Exercitationem corporis corrupti blanditiis.	2025-06-26 22:30:08	2025-06-26 22:30:08	138/73	78	97.7	97	79	Sit vero dolor.	Aut cum odio delectus molestiae ut voluptatem vero dicta dolores.	2025-08-22	Nostrum aspernatur accusantium quaerat dolor.	2025-07-30	14:00	3	pending	APT10865	\N
9867	458	5	2025-07-30 11:15:00	High BP	OPD	Asperiores quis laudantium alias eaque.	2025-06-26 22:30:08	2025-06-26 22:30:08	117/61	94	99.4	100	55	Nostrum nisi itaque officia nobis eum omnis eum.	Nesciunt non sit laboriosam aperiam.	2025-08-10	Ad dolorem laboriosam aliquid.	2025-07-30	11:15	3	pending	APT10866	\N
9868	74	7	2025-07-30 11:00:00	Routine Checkup	OPD	Expedita et id doloremque aperiam quod incidunt iusto.	2025-06-26 22:30:08	2025-06-26 22:30:08	136/73	92	99.9	99	68	Nobis maiores perferendis ipsam.	Assumenda eveniet id possimus porro earum.	2025-08-14	Atque facere ullam harum.	2025-07-30	11:00	3	pending	APT10867	\N
9869	343	8	2025-07-30 16:30:00	Routine Checkup	Emergency	Neque repellendus perferendis explicabo.	2025-06-26 22:30:08	2025-06-26 22:30:08	114/82	74	97.9	99	65	Ab fugiat ut facilis expedita consectetur doloribus.	Reprehenderit mollitia alias voluptatum ullam ut corrupti.	2025-08-06	Blanditiis culpa dolores.	2025-07-30	16:30	3	pending	APT10868	\N
9870	188	8	2025-07-30 15:00:00	Cough	New	Nihil aliquam et aperiam a et.	2025-06-26 22:30:08	2025-06-26 22:30:08	122/73	70	99.2	95	69	Et fugiat totam. Nemo at corporis.	Aliquam hic quasi quaerat fugit.	2025-08-11	Quidem alias amet illum.	2025-07-30	15:00	3	pending	APT10869	\N
9871	5	6	2025-07-30 13:30:00	Cough	Emergency	Non voluptates laborum voluptatum eius laudantium.	2025-06-26 22:30:08	2025-06-26 22:30:08	116/67	86	98.6	99	64	Ratione occaecati cumque voluptatum. Hic alias aperiam ut.	Occaecati et temporibus quod sed sunt.	2025-08-19	Minima numquam aperiam natus sequi.	2025-07-30	13:30	3	pending	APT10870	\N
9872	409	10	2025-07-30 12:00:00	Fever	Follow-up	In possimus eius officiis harum doloremque minus.	2025-06-26 22:30:08	2025-06-26 22:30:08	101/86	86	98.5	98	56	Enim placeat dolore ea mollitia aspernatur.	Mollitia reprehenderit possimus rem delectus distinctio quo nulla.	2025-08-26	Cumque nam fugiat dolorem.	2025-07-30	12:00	3	pending	APT10871	\N
9873	247	5	2025-07-30 12:15:00	Headache	Follow-up	Itaque vel aut doloremque molestiae.	2025-06-26 22:30:08	2025-06-26 22:30:08	115/71	77	99.3	99	60	Nam ex dolores aspernatur omnis. Ducimus unde at illo.	Vel repellendus error blanditiis ea tenetur similique cumque eaque.	2025-08-27	Velit et dolore eveniet.	2025-07-30	12:15	3	pending	APT10872	\N
9874	328	7	2025-07-30 16:00:00	High BP	New	Odio at ipsum.	2025-06-26 22:30:08	2025-06-26 22:30:08	117/64	87	100.0	100	82	Voluptas voluptas minima aperiam pariatur sit porro.	Et magnam amet veritatis numquam fuga tenetur.	2025-08-20	Numquam dolorem iste consectetur quam id officiis.	2025-07-30	16:00	3	pending	APT10873	\N
9875	81	8	2025-07-30 15:45:00	High BP	Follow-up	Nihil eos voluptatum voluptatum illum deserunt quibusdam.	2025-06-26 22:30:08	2025-06-26 22:30:08	114/78	80	97.9	96	80	Et adipisci vel officia necessitatibus.	Officia perferendis officiis quod corporis.	2025-08-11	Atque quaerat nisi similique cumque inventore.	2025-07-30	15:45	3	pending	APT10874	\N
9876	238	5	2025-07-30 13:15:00	Cough	New	Assumenda facere facere expedita quod occaecati ut.	2025-06-26 22:30:08	2025-06-26 22:30:08	137/81	75	100.2	98	77	Dignissimos autem quidem ipsum.	Aliquam dolores occaecati exercitationem ea.	2025-08-27	Quas tempora praesentium totam.	2025-07-30	13:15	3	pending	APT10875	\N
9877	422	9	2025-07-30 15:30:00	Fever	Emergency	Cumque magnam in corrupti.	2025-06-26 22:30:08	2025-06-26 22:30:08	124/61	79	99.6	97	57	Inventore veniam consequuntur natus quis perferendis.	In ad explicabo labore aliquid dolorum molestias dolorum.	2025-08-06	Voluptates tenetur minus esse perspiciatis numquam.	2025-07-30	15:30	3	pending	APT10876	\N
9878	298	4	2025-07-30 16:45:00	Headache	New	Iusto harum tempora similique nisi dolores temporibus.	2025-06-26 22:30:08	2025-06-26 22:30:08	128/60	94	97.6	98	73	Molestiae perferendis esse rem fugit distinctio.	Iste veritatis rerum voluptate quia expedita.	2025-08-09	Maxime quam esse ea dolores assumenda voluptas.	2025-07-30	16:45	3	pending	APT10877	\N
9879	31	9	2025-07-30 15:15:00	Cough	Follow-up	Animi libero eum magni facilis quos.	2025-06-26 22:30:08	2025-06-26 22:30:08	121/90	78	99.4	95	55	Eveniet fugit nam consequatur hic.	Maxime cum ea adipisci sunt molestiae.	2025-08-26	Velit repellat neque repellendus commodi voluptatibus placeat.	2025-07-30	15:15	3	pending	APT10878	\N
9880	123	5	2025-07-30 12:00:00	High BP	OPD	Illum necessitatibus maxime dignissimos fugiat sapiente.	2025-06-26 22:30:08	2025-06-26 22:30:08	137/69	95	99.9	98	81	Hic animi itaque asperiores blanditiis quam tempora.	Laborum consectetur veniam nulla quas inventore tempore molestias.	2025-08-10	Optio fugit nostrum minima eveniet.	2025-07-30	12:00	3	pending	APT10879	\N
9881	233	4	2025-07-30 14:00:00	Fever	Follow-up	Distinctio accusamus repudiandae esse itaque.	2025-06-26 22:30:08	2025-06-26 22:30:08	125/66	96	100.5	95	81	Incidunt quos hic expedita laboriosam unde ut.	Enim temporibus ratione officiis doloribus asperiores praesentium.	2025-08-26	Beatae aperiam maxime quia illo.	2025-07-30	14:00	3	pending	APT10880	\N
9882	136	9	2025-07-31 13:00:00	Skin Rash	New	Fugit totam in.	2025-06-26 22:30:08	2025-06-26 22:30:08	106/64	100	98.1	98	72	Necessitatibus quibusdam placeat excepturi.	Eveniet explicabo quas qui molestias itaque repellendus dicta.	2025-08-22	Praesentium nihil cumque necessitatibus quaerat voluptates.	2025-07-31	13:00	3	pending	APT10881	\N
9883	410	3	2025-07-31 15:00:00	Routine Checkup	OPD	Magnam hic consequuntur sed quisquam soluta.	2025-06-26 22:30:08	2025-06-26 22:30:08	103/70	77	99.5	96	68	Culpa iusto recusandae facere dolorem eos voluptatum.	Iure dolore officiis placeat aliquid quos natus iusto repellat facilis.	2025-08-09	Aliquam incidunt eaque quos voluptatibus.	2025-07-31	15:00	3	pending	APT10882	\N
9884	128	7	2025-07-31 13:00:00	Back Pain	Follow-up	Nisi optio porro aut suscipit eveniet tempore.	2025-06-26 22:30:08	2025-06-26 22:30:08	125/73	73	98.4	95	65	Voluptate placeat eaque numquam. Veritatis hic non.	Quos nulla dolorum iure totam optio eaque voluptatem repellendus voluptatem.	2025-08-24	Quod incidunt repellendus necessitatibus hic.	2025-07-31	13:00	3	pending	APT10883	\N
9885	438	10	2025-07-31 16:15:00	Headache	New	Accusamus facere magnam dolores debitis porro quisquam.	2025-06-26 22:30:08	2025-06-26 22:30:08	108/68	69	98.3	99	55	Ex tenetur ducimus corporis tenetur distinctio.	Assumenda culpa amet ipsam consequatur in.	2025-08-28	Ducimus quas labore asperiores ex at.	2025-07-31	16:15	3	pending	APT10884	\N
9886	491	8	2025-07-31 13:00:00	Routine Checkup	New	Eaque aspernatur animi aut incidunt temporibus corporis.	2025-06-26 22:30:08	2025-06-26 22:30:08	100/72	90	100.5	99	64	Ullam earum maiores fuga dicta aperiam.	Doloremque ipsum quidem sapiente vel culpa.	2025-08-21	Modi nulla rem occaecati mollitia mollitia pariatur.	2025-07-31	13:00	3	pending	APT10885	\N
9887	364	9	2025-07-31 11:15:00	Back Pain	Emergency	Blanditiis ad aut nostrum cumque repellendus animi.	2025-06-26 22:30:08	2025-06-26 22:30:08	121/72	90	97.9	99	65	Quia fuga autem ipsa pariatur maxime sit.	Laboriosam nisi rem quaerat dignissimos eos.	2025-08-07	Totam inventore vel quasi voluptates.	2025-07-31	11:15	3	pending	APT10886	\N
9888	176	9	2025-07-31 11:30:00	Routine Checkup	Follow-up	Aliquam delectus quos optio animi fugit.	2025-06-26 22:30:08	2025-06-26 22:30:08	116/89	100	98.7	98	85	Enim deserunt repellendus debitis maxime.	Omnis unde nesciunt commodi voluptate libero voluptas nemo dolore.	2025-08-26	Occaecati animi labore ad distinctio.	2025-07-31	11:30	3	pending	APT10887	\N
9889	211	7	2025-07-31 12:45:00	Routine Checkup	New	Cumque voluptas eum nostrum molestias.	2025-06-26 22:30:08	2025-06-26 22:30:08	100/72	94	99.7	95	60	Consequuntur cumque fugiat provident dignissimos.	Voluptates est ullam odio nesciunt quaerat molestias.	2025-08-09	Veritatis non molestias voluptatibus quam exercitationem.	2025-07-31	12:45	3	pending	APT10888	\N
9890	5	10	2025-07-31 14:00:00	Diabetes Check	Follow-up	Illo eius molestias qui dolor.	2025-06-26 22:30:08	2025-06-26 22:30:08	117/68	83	99.4	97	85	Nihil adipisci blanditiis ipsum placeat dicta.	Distinctio iure corrupti nemo eveniet libero numquam asperiores.	2025-08-23	Repellendus quis molestias magni amet asperiores.	2025-07-31	14:00	3	pending	APT10889	\N
9891	370	7	2025-07-31 13:00:00	Routine Checkup	New	Deserunt repellendus incidunt sequi.	2025-06-26 22:30:08	2025-06-26 22:30:08	100/71	82	98.9	96	77	Accusamus cum perferendis quam iure repellendus sint.	Praesentium nam porro sunt totam eaque eos.	2025-08-26	Facilis odit animi saepe ab.	2025-07-31	13:00	3	pending	APT10890	\N
9892	493	7	2025-07-31 11:00:00	Routine Checkup	New	Laudantium provident eaque debitis.	2025-06-26 22:30:08	2025-06-26 22:30:08	120/74	66	98.7	100	67	Natus perspiciatis sit occaecati ad culpa.	Laboriosam quaerat velit repellat.	2025-08-24	Architecto fugiat consectetur labore neque amet maxime nisi.	2025-07-31	11:00	3	pending	APT10891	\N
9893	70	3	2025-07-31 14:45:00	Routine Checkup	New	Maiores voluptas modi in voluptate.	2025-06-26 22:30:08	2025-06-26 22:30:08	131/65	68	100.2	99	85	Incidunt dicta dignissimos praesentium sunt fugit alias.	Eaque quaerat est cum id quibusdam.	2025-08-22	Eos aperiam quam.	2025-07-31	14:45	3	pending	APT10892	\N
9894	275	4	2025-07-31 13:45:00	Skin Rash	Follow-up	Eveniet voluptatibus doloremque eligendi amet aperiam corrupti.	2025-06-26 22:30:08	2025-06-26 22:30:08	127/74	85	98.9	96	61	Cupiditate est eligendi quod.	Illum quidem similique neque expedita.	2025-08-20	Id quaerat culpa suscipit hic earum commodi hic.	2025-07-31	13:45	3	pending	APT10893	\N
9895	433	6	2025-07-31 15:30:00	Skin Rash	New	Beatae ad eos ducimus molestiae inventore consectetur.	2025-06-26 22:30:08	2025-06-26 22:30:08	135/60	88	99.1	100	65	Atque doloribus ipsum accusamus debitis.	Ipsum itaque error animi odio explicabo.	2025-08-21	Eius cum sint maiores blanditiis velit repellendus.	2025-07-31	15:30	3	pending	APT10894	\N
9896	104	6	2025-07-31 15:30:00	High BP	Follow-up	Possimus cumque assumenda officiis consequatur occaecati.	2025-06-26 22:30:08	2025-06-26 22:30:08	109/68	76	99.1	98	73	Autem quod saepe aliquam aspernatur. Modi facere rem.	Aliquam odit autem minus molestiae veniam.	2025-08-08	Rem non repellat sit.	2025-07-31	15:30	3	pending	APT10895	\N
9897	153	9	2025-07-31 15:00:00	Routine Checkup	OPD	Expedita occaecati sed ipsam voluptatum.	2025-06-26 22:30:08	2025-06-26 22:30:08	114/68	90	98.0	98	80	Necessitatibus eveniet soluta aliquam temporibus unde.	Expedita fuga pariatur provident officiis officia eligendi eius reprehenderit.	2025-08-23	Praesentium consequatur cum doloribus maxime laborum.	2025-07-31	15:00	3	pending	APT10896	\N
9898	84	6	2025-07-31 16:00:00	Fever	Emergency	Perspiciatis odit ipsum minima.	2025-06-26 22:30:08	2025-06-26 22:30:08	135/79	92	100.5	96	55	Placeat ea illo.	Alias qui voluptatum suscipit maxime quas.	2025-08-11	Minus debitis repellat aliquam voluptatum modi porro.	2025-07-31	16:00	3	pending	APT10897	\N
9899	456	3	2025-07-31 13:30:00	Cough	New	Natus corrupti assumenda a perspiciatis alias aperiam totam.	2025-06-26 22:30:08	2025-06-26 22:30:08	126/77	85	98.0	96	72	Doloribus rem fugit similique.	Itaque ipsum illo sint et necessitatibus nisi rerum modi culpa.	2025-08-22	Velit corrupti tempora et ipsum repellendus occaecati.	2025-07-31	13:30	3	pending	APT10898	\N
9900	118	10	2025-07-31 16:15:00	High BP	Follow-up	Maiores reiciendis laborum reiciendis.	2025-06-26 22:30:08	2025-06-26 22:30:08	129/77	83	100.3	99	56	Ad aliquam tempore minima nihil corporis dolor.	Rem tempore debitis earum nisi omnis similique ratione.	2025-08-16	Maxime esse ea sunt rerum inventore unde quo.	2025-07-31	16:15	3	pending	APT10899	\N
9901	325	3	2025-07-31 14:45:00	Back Pain	OPD	Tempore quas laborum nisi placeat eius quae.	2025-06-26 22:30:08	2025-06-26 22:30:08	139/67	75	100.0	96	56	Enim enim aut magni delectus. Nemo quasi perferendis.	Temporibus expedita tenetur minima mollitia distinctio.	2025-08-18	Neque sit numquam ea dolore reprehenderit.	2025-07-31	14:45	3	pending	APT10900	\N
9902	427	3	2025-07-31 16:00:00	Routine Checkup	Emergency	Eligendi optio necessitatibus eaque impedit.	2025-06-26 22:30:08	2025-06-26 22:30:08	127/87	91	100.3	99	85	Facere eveniet eum asperiores.	Harum neque consequatur quasi ullam.	2025-08-30	Accusantium at eum quis dolores.	2025-07-31	16:00	3	pending	APT10901	\N
9903	213	7	2025-07-31 16:45:00	Routine Checkup	Emergency	Nam quas provident aspernatur doloremque praesentium.	2025-06-26 22:30:08	2025-06-26 22:30:08	105/73	82	98.8	99	63	Repellendus rem magni consequatur molestias voluptatibus.	Laborum officiis quisquam architecto incidunt dolorem corrupti error aperiam molestias.	2025-08-09	Doloribus officiis consequuntur corporis ad vero facilis.	2025-07-31	16:45	3	pending	APT10902	\N
9904	370	9	2025-07-31 15:15:00	Cough	Emergency	Distinctio enim inventore sapiente.	2025-06-26 22:30:08	2025-06-26 22:30:08	130/90	81	97.9	97	58	Aut fugiat porro atque quam. Unde odit blanditiis expedita.	Maxime assumenda accusamus velit eius explicabo reiciendis recusandae cupiditate aliquam.	2025-08-10	Reprehenderit dolor iste deserunt.	2025-07-31	15:15	3	pending	APT10903	\N
9905	37	8	2025-07-31 13:15:00	Cough	Follow-up	Officia possimus sequi libero perspiciatis sapiente nesciunt nihil.	2025-06-26 22:30:08	2025-06-26 22:30:08	139/65	82	100.0	100	59	Vitae asperiores earum corporis corporis officia aut illum.	At maxime porro totam consequuntur in velit vel officiis rem.	2025-08-11	Neque sapiente sit consequuntur adipisci totam maiores.	2025-07-31	13:15	3	pending	APT10904	\N
9906	308	5	2025-07-31 12:45:00	High BP	Follow-up	Consectetur a facere dolor temporibus doloremque eius.	2025-06-26 22:30:08	2025-06-26 22:30:08	124/90	87	100.1	95	66	Eligendi harum inventore. Nulla alias suscipit delectus.	Hic a quia laboriosam similique nulla quia maxime ad illo saepe.	2025-08-07	Error nobis ut qui nemo eaque libero.	2025-07-31	12:45	3	pending	APT10905	\N
9907	443	10	2025-08-01 14:30:00	High BP	Follow-up	Consectetur laborum unde eligendi esse.	2025-06-26 22:30:08	2025-06-26 22:30:08	109/60	91	100.3	98	59	Occaecati consequatur laborum consectetur rem.	Veniam vitae nostrum iure culpa eius soluta deserunt.	2025-08-11	Voluptatem maxime quasi vero voluptatum.	2025-08-01	14:30	3	pending	APT10906	\N
9908	53	3	2025-08-01 12:30:00	Headache	New	Molestiae a asperiores earum nulla.	2025-06-26 22:30:08	2025-06-26 22:30:08	129/80	74	99.6	100	66	Vero officiis sint occaecati enim amet.	Deserunt exercitationem culpa placeat molestias nostrum.	2025-08-08	Ad tempore voluptatem.	2025-08-01	12:30	3	pending	APT10907	\N
9909	236	10	2025-08-01 14:00:00	Skin Rash	Follow-up	Necessitatibus facere eaque.	2025-06-26 22:30:08	2025-06-26 22:30:08	112/67	96	99.3	95	64	Deserunt iure maiores. Totam quam nihil iste dolorum.	Nesciunt veniam atque est aliquid beatae eaque sequi.	2025-08-19	Odio ad sapiente ipsam totam accusamus.	2025-08-01	14:00	3	pending	APT10908	\N
9910	191	3	2025-08-01 15:00:00	Fever	Emergency	Ipsam blanditiis quo a quos.	2025-06-26 22:30:08	2025-06-26 22:30:08	111/83	94	98.8	97	71	Officiis aut laudantium eveniet.	Harum libero cumque molestiae.	2025-08-11	Voluptatum eum nobis ea consequatur rerum distinctio.	2025-08-01	15:00	3	pending	APT10909	\N
9911	100	10	2025-08-01 14:30:00	Back Pain	Emergency	Tempora unde voluptate sapiente ea repellat sapiente.	2025-06-26 22:30:08	2025-06-26 22:30:08	110/78	67	98.6	98	58	Aspernatur delectus dolores saepe.	Sunt consectetur rem praesentium nihil harum.	2025-08-30	Amet tenetur enim.	2025-08-01	14:30	3	pending	APT10910	\N
9912	365	4	2025-08-01 11:15:00	Skin Rash	OPD	Quaerat maxime reiciendis ipsa inventore in consequuntur.	2025-06-26 22:30:08	2025-06-26 22:30:08	125/69	77	100.0	97	66	Nisi ipsam eius illo autem nulla.	Neque beatae quidem aliquam similique.	2025-08-30	Esse esse error minus asperiores commodi quas.	2025-08-01	11:15	3	pending	APT10911	\N
9913	117	10	2025-08-01 14:45:00	Fever	New	Deserunt dicta eveniet explicabo commodi nulla fugit.	2025-06-26 22:30:08	2025-06-26 22:30:08	128/73	80	97.6	97	81	Tempora mollitia totam blanditiis id nemo ad.	Voluptate vitae sint sequi doloribus nemo cumque hic.	2025-08-27	Cum sint accusamus.	2025-08-01	14:45	3	pending	APT10912	\N
9914	293	5	2025-08-01 12:00:00	Cough	Follow-up	Quam totam in.	2025-06-26 22:30:08	2025-06-26 22:30:08	105/78	99	99.4	95	79	Dolorum velit delectus.	Nobis laudantium quasi voluptas voluptatem hic repudiandae error reprehenderit.	2025-08-15	Est occaecati deserunt incidunt itaque excepturi nisi aliquam.	2025-08-01	12:00	3	pending	APT10913	\N
9915	450	5	2025-08-01 12:45:00	Skin Rash	OPD	Dolor odio ipsum dicta.	2025-06-26 22:30:08	2025-06-26 22:30:08	111/72	86	99.5	97	85	Perferendis a id quas. Et vero incidunt occaecati repellat.	Ipsum veritatis delectus recusandae sapiente.	2025-08-15	Corporis natus magni sunt sapiente.	2025-08-01	12:45	3	pending	APT10914	\N
9916	367	8	2025-08-01 11:15:00	Routine Checkup	Emergency	Dolor at libero perferendis soluta.	2025-06-26 22:30:08	2025-06-26 22:30:08	114/65	68	97.6	97	75	Quo sint in illum soluta velit ex.	Eius deleniti corrupti voluptates nesciunt.	2025-08-29	Minima aliquam et vero neque maiores.	2025-08-01	11:15	3	pending	APT10915	\N
9917	184	4	2025-08-01 16:15:00	Back Pain	New	Iure exercitationem molestiae.	2025-06-26 22:30:08	2025-06-26 22:30:08	138/81	81	97.6	95	71	Illo esse temporibus at earum. Quia quo sequi.	Voluptate earum maiores autem in.	2025-08-19	Laborum adipisci beatae suscipit praesentium est facere.	2025-08-01	16:15	3	pending	APT10916	\N
9918	471	5	2025-08-01 16:00:00	Diabetes Check	Emergency	Aliquam quaerat voluptatem libero.	2025-06-26 22:30:08	2025-06-26 22:30:08	119/74	89	99.9	96	71	Dicta ipsam eaque accusantium cum veritatis consequatur.	Quae hic dignissimos quo.	2025-08-22	Aliquid natus dolor beatae tenetur.	2025-08-01	16:00	3	pending	APT10917	\N
9919	126	7	2025-08-01 16:30:00	High BP	Follow-up	Ratione eum magni labore.	2025-06-26 22:30:08	2025-06-26 22:30:08	122/61	81	97.6	98	80	Doloremque at quo placeat est harum.	Ipsum neque reprehenderit alias modi vero officia officia accusantium natus.	2025-08-21	Totam fugit delectus doloremque nulla explicabo reprehenderit asperiores.	2025-08-01	16:30	3	pending	APT10918	\N
9920	360	7	2025-08-01 12:45:00	Back Pain	New	Nesciunt corrupti nobis reprehenderit.	2025-06-26 22:30:08	2025-06-26 22:30:08	132/86	91	97.8	98	82	Atque alias similique esse earum earum alias animi.	Deleniti pariatur ullam quo quaerat magnam unde.	2025-08-31	Illum cumque mollitia voluptatem eligendi natus harum.	2025-08-01	12:45	3	pending	APT10919	\N
9921	403	6	2025-08-01 15:30:00	High BP	Follow-up	Illo dolore asperiores consequatur doloribus.	2025-06-26 22:30:08	2025-06-26 22:30:08	103/61	89	99.0	100	75	Natus dolor voluptatibus.	Repellendus aperiam laborum ratione voluptate velit facilis eius quod laboriosam.	2025-08-26	Magnam reprehenderit beatae est officia eius non.	2025-08-01	15:30	3	pending	APT10920	\N
9922	424	9	2025-08-01 15:45:00	Diabetes Check	Follow-up	Reiciendis reprehenderit non maxime praesentium.	2025-06-26 22:30:08	2025-06-26 22:30:08	111/77	89	97.7	95	79	At quidem labore mollitia eos. Animi esse eaque veritatis.	Fugit reprehenderit iusto at praesentium deserunt vel dignissimos a.	2025-08-09	Rem commodi tempora aperiam nam.	2025-08-01	15:45	3	pending	APT10921	\N
9923	230	6	2025-08-01 14:45:00	Fever	OPD	Praesentium provident labore cum odio voluptatum debitis.	2025-06-26 22:30:08	2025-06-26 22:30:08	108/86	93	98.1	100	62	Nam blanditiis tempora id incidunt sunt.	Consequatur ratione placeat explicabo ipsam voluptates blanditiis explicabo.	2025-08-28	Sunt cumque illum non exercitationem veniam iure ducimus.	2025-08-01	14:45	3	pending	APT10922	\N
9924	471	10	2025-08-01 16:15:00	Routine Checkup	OPD	Minus asperiores eius quam accusamus consequuntur quisquam.	2025-06-26 22:30:08	2025-06-26 22:30:08	120/80	82	98.0	95	59	Architecto nostrum deleniti voluptatem mollitia assumenda.	Quidem doloribus cumque ex nihil corporis consectetur eveniet ullam aspernatur pariatur.	2025-08-24	Tempora similique iure.	2025-08-01	16:15	3	pending	APT10923	\N
9925	478	9	2025-08-01 16:45:00	Cough	Follow-up	Dolorum aspernatur dolorem eaque consequatur.	2025-06-26 22:30:08	2025-06-26 22:30:08	129/74	83	100.3	100	61	Esse excepturi dignissimos rem corrupti facere distinctio.	Aut natus in quo quasi non excepturi.	2025-08-11	Iusto maiores quibusdam tempora laborum maxime.	2025-08-01	16:45	3	pending	APT10924	\N
9926	467	3	2025-08-01 13:15:00	Cough	New	Eius tempore tempore saepe illo.	2025-06-26 22:30:08	2025-06-26 22:30:08	137/90	81	98.4	96	61	Reprehenderit facere nam optio sit possimus.	Iste tempore quae vel voluptas veritatis optio reprehenderit minus.	2025-08-30	Cumque ducimus quibusdam ipsa.	2025-08-01	13:15	3	pending	APT10925	\N
9927	65	6	2025-08-01 13:30:00	Routine Checkup	Emergency	Saepe explicabo optio occaecati quia incidunt neque cupiditate.	2025-06-26 22:30:08	2025-06-26 22:30:08	132/84	91	99.3	100	63	Modi rerum adipisci id incidunt dicta fugit.	Quisquam culpa voluptate sint sint iure laudantium voluptas.	2025-08-23	Ullam deserunt saepe repellendus officia suscipit.	2025-08-01	13:30	3	pending	APT10926	\N
9928	130	8	2025-08-01 12:30:00	Back Pain	Emergency	Voluptas eveniet praesentium eligendi.	2025-06-26 22:30:08	2025-06-26 22:30:08	122/79	70	99.8	97	82	Adipisci enim sint exercitationem voluptatum ratione nulla.	Quasi debitis magnam quae.	2025-08-29	Facilis expedita recusandae quis.	2025-08-01	12:30	3	pending	APT10927	\N
9929	441	5	2025-08-02 13:30:00	Routine Checkup	OPD	Quis est placeat eligendi reprehenderit accusantium.	2025-06-26 22:30:08	2025-06-26 22:30:08	115/68	96	100.2	95	81	Culpa similique suscipit itaque nisi.	Distinctio non blanditiis alias expedita commodi dignissimos eum corporis.	2025-08-27	Architecto ducimus fuga beatae eveniet.	2025-08-02	13:30	3	pending	APT10928	\N
9930	253	9	2025-08-02 12:45:00	High BP	Emergency	Exercitationem ut tempora impedit aliquid deserunt.	2025-06-26 22:30:08	2025-06-26 22:30:08	120/67	69	100.2	96	64	Voluptatem est optio a eveniet est ducimus.	Mollitia fuga labore laboriosam culpa atque sint ipsa sit.	2025-08-16	Corrupti quis eveniet voluptate ab fugit odio.	2025-08-02	12:45	3	pending	APT10929	\N
9931	493	5	2025-08-02 12:15:00	High BP	New	Esse quis placeat autem modi.	2025-06-26 22:30:08	2025-06-26 22:30:08	106/81	96	99.7	95	80	Ea similique voluptates est. Aperiam ipsa ad fugit.	Ab velit nostrum aliquam tempore.	2025-08-16	Vitae at qui quaerat quibusdam cumque ab.	2025-08-02	12:15	3	pending	APT10930	\N
9932	68	4	2025-08-02 13:30:00	Skin Rash	New	Accusantium ut saepe quas.	2025-06-26 22:30:08	2025-06-26 22:30:08	125/65	92	100.2	96	82	At corrupti voluptas tenetur.	Beatae deserunt iusto id minima distinctio.	2025-08-10	Non numquam nesciunt eos hic.	2025-08-02	13:30	3	pending	APT10931	\N
9933	36	3	2025-08-02 13:45:00	Skin Rash	Follow-up	Ad consectetur ab corrupti beatae.	2025-06-26 22:30:08	2025-06-26 22:30:08	111/66	85	99.5	100	67	Inventore labore fugiat.	Veritatis alias repellat vel sit repellendus.	2025-08-25	Deserunt iste eveniet.	2025-08-02	13:45	3	pending	APT10932	\N
9934	444	5	2025-08-02 16:15:00	Headache	Emergency	Earum recusandae autem porro repellendus.	2025-06-26 22:30:08	2025-06-26 22:30:08	107/65	85	99.4	95	81	Alias autem labore molestiae odit error autem autem.	Voluptatem et unde reprehenderit laboriosam.	2025-08-12	Sint deleniti iste.	2025-08-02	16:15	3	pending	APT10933	\N
9935	206	10	2025-08-02 14:30:00	High BP	Follow-up	Atque laborum sint amet.	2025-06-26 22:30:08	2025-06-26 22:30:08	122/72	80	99.6	98	57	Consequuntur nostrum pariatur nulla eos.	Voluptate harum veniam minus recusandae.	2025-08-10	Velit a libero nemo.	2025-08-02	14:30	3	pending	APT10934	\N
9936	349	5	2025-08-02 13:00:00	Diabetes Check	Emergency	Distinctio at amet id libero libero tempore.	2025-06-26 22:30:08	2025-06-26 22:30:08	114/73	99	99.5	96	58	Pariatur saepe et molestias qui.	Recusandae modi quam recusandae laudantium quisquam.	2025-08-09	Eveniet deleniti non iste tenetur unde repudiandae.	2025-08-02	13:00	3	pending	APT10935	\N
9937	118	3	2025-08-02 16:00:00	Skin Rash	OPD	At quam dolores modi.	2025-06-26 22:30:08	2025-06-26 22:30:08	124/62	77	100.0	96	66	Nostrum eum temporibus odit unde.	Dicta doloremque ipsum alias consectetur ipsum quia fuga quae.	2025-08-29	Nostrum quo perspiciatis.	2025-08-02	16:00	3	pending	APT10936	\N
9938	293	4	2025-08-02 14:15:00	Headache	New	Laudantium odit veritatis iusto qui quos aliquam.	2025-06-26 22:30:08	2025-06-26 22:30:08	134/65	100	100.3	95	63	Optio vitae voluptatem dolores. Aut magni cum.	Harum eos excepturi quasi blanditiis quia iusto tempora.	2025-08-25	Incidunt voluptatem assumenda voluptatem.	2025-08-02	14:15	3	pending	APT10937	\N
9939	33	9	2025-08-02 13:15:00	Diabetes Check	OPD	Libero dolorem ad a.	2025-06-26 22:30:08	2025-06-26 22:30:08	103/68	97	98.3	99	57	Esse quisquam sunt culpa quo ducimus quas.	Tenetur soluta corporis eveniet id quia voluptatum inventore vel expedita.	2025-08-16	Dolorum nemo ex.	2025-08-02	13:15	3	pending	APT10938	\N
9940	326	7	2025-08-02 14:00:00	Cough	Follow-up	Omnis aspernatur molestiae quaerat.	2025-06-26 22:30:08	2025-06-26 22:30:08	121/73	72	98.3	100	74	Eaque quis assumenda nobis.	Voluptatibus ea delectus aspernatur in expedita quaerat.	2025-08-27	Itaque beatae aliquam harum eius.	2025-08-02	14:00	3	pending	APT10939	\N
9941	345	4	2025-08-02 15:45:00	Back Pain	Emergency	Nemo ad rerum saepe dolores est inventore.	2025-06-26 22:30:08	2025-06-26 22:30:08	118/74	74	98.1	98	57	Ullam iusto dicta quod nesciunt.	Commodi ipsa exercitationem voluptatum cum deserunt corrupti placeat pariatur qui.	2025-09-01	Rerum ipsa a tenetur labore ea.	2025-08-02	15:45	3	pending	APT10940	\N
9942	439	3	2025-08-02 15:30:00	Routine Checkup	Emergency	Repellat quibusdam repellendus nisi cumque quae voluptatum.	2025-06-26 22:30:08	2025-06-26 22:30:08	134/66	76	100.2	98	83	Nihil commodi culpa deserunt eveniet.	Consectetur voluptas magnam minima laudantium porro quisquam consequuntur.	2025-08-26	Sed magni unde quia recusandae modi.	2025-08-02	15:30	3	pending	APT10941	\N
9943	91	9	2025-08-02 16:00:00	Routine Checkup	New	Perspiciatis ipsa quisquam magnam.	2025-06-26 22:30:08	2025-06-26 22:30:08	103/65	68	98.9	100	57	Vitae illum doloribus possimus quo sequi veritatis.	Laudantium facilis nostrum quibusdam aspernatur saepe doloribus excepturi mollitia.	2025-08-09	Molestiae officia sed reprehenderit necessitatibus at ea.	2025-08-02	16:00	3	pending	APT10942	\N
9944	407	8	2025-08-02 14:15:00	High BP	Follow-up	Fugit harum minima distinctio voluptates vel.	2025-06-26 22:30:08	2025-06-26 22:30:08	125/66	93	100.0	98	57	Optio amet numquam numquam aspernatur.	Temporibus repellat incidunt quas quis doloribus quam.	2025-08-15	Illo voluptate quibusdam libero rerum.	2025-08-02	14:15	3	pending	APT10943	\N
9945	41	6	2025-08-02 13:45:00	Headache	OPD	Doloribus a recusandae id ea eos architecto.	2025-06-26 22:30:08	2025-06-26 22:30:08	112/80	98	100.3	97	76	Adipisci iusto quo quisquam sint in reiciendis.	Ducimus excepturi illum accusamus quam qui incidunt.	2025-08-19	Delectus laudantium iusto rerum.	2025-08-02	13:45	3	pending	APT10944	\N
9946	438	10	2025-08-02 11:45:00	Cough	Follow-up	Natus doloremque odit animi.	2025-06-26 22:30:08	2025-06-26 22:30:08	116/73	78	98.2	98	68	Nam recusandae facilis quo illum. Delectus sed et officiis.	Iure fuga sapiente voluptates eveniet.	2025-08-18	Quaerat atque sed laborum.	2025-08-02	11:45	3	pending	APT10945	\N
9947	375	10	2025-08-02 15:15:00	Cough	OPD	Labore quo pariatur dolore rem maiores.	2025-06-26 22:30:08	2025-06-26 22:30:08	127/72	66	99.0	96	62	Labore dolores culpa commodi ex.	Sed placeat ut earum explicabo optio corrupti voluptates.	2025-08-19	Corporis asperiores occaecati architecto rerum unde qui.	2025-08-02	15:15	3	pending	APT10946	\N
9948	314	8	2025-08-02 15:00:00	Back Pain	New	Possimus necessitatibus a.	2025-06-26 22:30:08	2025-06-26 22:30:08	121/82	86	99.3	95	73	Quibusdam quasi deserunt recusandae neque.	Doloribus odio neque voluptatum inventore veniam magnam.	2025-08-11	Perspiciatis officia perferendis tenetur similique quas consectetur.	2025-08-02	15:00	3	pending	APT10947	\N
9949	10	5	2025-08-02 12:45:00	Back Pain	Follow-up	Dolores culpa suscipit rem non.	2025-06-26 22:30:08	2025-06-26 22:30:08	127/76	97	99.7	96	56	Quasi sit commodi mollitia atque nobis eaque.	Unde modi quos nisi ut eos reprehenderit quasi.	2025-09-01	Repudiandae provident fugit eveniet laboriosam laborum.	2025-08-02	12:45	3	pending	APT10948	\N
9950	458	8	2025-08-02 12:00:00	Skin Rash	Emergency	Expedita nam quis deleniti placeat dolor.	2025-06-26 22:30:08	2025-06-26 22:30:08	117/64	79	99.3	98	70	Cumque saepe eos quidem quisquam beatae corporis fugiat.	Explicabo beatae temporibus praesentium dignissimos nihil.	2025-08-14	Odit facere asperiores hic est.	2025-08-02	12:00	3	pending	APT10949	\N
9951	105	4	2025-08-03 15:30:00	Skin Rash	Follow-up	Labore voluptas officiis molestias fugiat quos.	2025-06-26 22:30:08	2025-06-26 22:30:08	140/84	69	99.7	98	60	Voluptatem ducimus beatae placeat aliquam quam tempora.	Natus ipsum rem iure totam laborum amet animi voluptatem quis.	2025-08-21	Natus dignissimos sunt dolor.	2025-08-03	15:30	3	pending	APT10950	\N
9952	70	10	2025-08-03 11:45:00	High BP	OPD	Cumque cum doloremque.	2025-06-26 22:30:08	2025-06-26 22:30:08	109/84	98	97.6	95	73	Dolores cupiditate animi porro.	Quia impedit harum quae.	2025-08-21	Enim maiores sequi optio.	2025-08-03	11:45	3	pending	APT10951	\N
9953	413	8	2025-08-03 12:15:00	Routine Checkup	New	Assumenda dolorum delectus totam modi tempore quod nisi.	2025-06-26 22:30:08	2025-06-26 22:30:08	102/79	66	98.6	95	76	Consectetur tempora dignissimos vel rem eius.	Libero veritatis vitae ad.	2025-08-29	Nesciunt quae nisi quasi libero.	2025-08-03	12:15	3	pending	APT10952	\N
9954	2	7	2025-08-03 12:15:00	Cough	Emergency	Error exercitationem vitae rerum recusandae.	2025-06-26 22:30:08	2025-06-26 22:30:08	116/63	74	98.1	97	72	Voluptate esse ipsum quas voluptate debitis doloribus.	Maxime qui mollitia ipsam eaque odio blanditiis dolorem provident iusto.	2025-08-29	Rem repudiandae occaecati.	2025-08-03	12:15	3	pending	APT10953	\N
9955	449	4	2025-08-03 13:45:00	Cough	Emergency	Quia debitis consequuntur.	2025-06-26 22:30:08	2025-06-26 22:30:08	132/78	76	98.1	100	57	Esse eum qui aliquid saepe ducimus non.	Ea odio laudantium saepe nihil non.	2025-08-31	Dicta aspernatur esse rerum tempore numquam expedita.	2025-08-03	13:45	3	pending	APT10954	\N
9956	397	10	2025-08-03 12:15:00	Back Pain	New	Sunt adipisci consequatur natus sit excepturi.	2025-06-26 22:30:08	2025-06-26 22:30:08	104/74	71	99.5	99	59	Hic itaque pariatur blanditiis.	Aliquid voluptates deleniti ad quasi fugit expedita velit.	2025-08-28	Repudiandae velit ex.	2025-08-03	12:15	3	pending	APT10955	\N
9957	433	3	2025-08-03 15:15:00	Skin Rash	OPD	Ullam natus nesciunt fuga doloribus a.	2025-06-26 22:30:08	2025-06-26 22:30:08	139/66	95	97.6	95	80	Possimus nostrum dolore debitis odit autem doloremque.	Unde distinctio dolorem omnis eius iure reprehenderit ad numquam fugit labore.	2025-08-12	Omnis dicta quo voluptate optio ipsa suscipit excepturi.	2025-08-03	15:15	3	pending	APT10956	\N
9958	106	10	2025-08-03 12:45:00	Cough	Emergency	Praesentium cupiditate dicta ullam ipsa porro placeat fugit.	2025-06-26 22:30:08	2025-06-26 22:30:08	126/77	89	98.1	95	67	Vel rerum aliquam.	Voluptate dolorem ipsum quia aliquid consequatur et aliquam ullam voluptate.	2025-08-22	Praesentium laudantium expedita dolores deserunt.	2025-08-03	12:45	3	pending	APT10957	\N
9959	193	5	2025-08-03 15:00:00	Skin Rash	New	Nam eligendi dignissimos maxime fugit modi.	2025-06-26 22:30:08	2025-06-26 22:30:08	104/85	98	98.3	96	67	Recusandae ex harum.	Perferendis sunt laudantium quas occaecati quidem eius.	2025-08-10	Delectus reprehenderit reiciendis perferendis perferendis.	2025-08-03	15:00	3	pending	APT10958	\N
9960	179	6	2025-08-03 13:30:00	High BP	New	Molestiae laboriosam explicabo veniam sint mollitia.	2025-06-26 22:30:08	2025-06-26 22:30:08	122/74	71	99.9	98	60	Dicta sit amet.	In occaecati quidem ab ex occaecati veritatis.	2025-08-10	Ut pariatur magni voluptatem laudantium.	2025-08-03	13:30	3	pending	APT10959	\N
9961	314	8	2025-08-03 14:45:00	Fever	Follow-up	Maiores error iste nam inventore.	2025-06-26 22:30:08	2025-06-26 22:30:08	112/64	86	100.0	96	69	Quos deserunt ad porro et tenetur illo.	Facere saepe reprehenderit blanditiis molestiae.	2025-08-15	Suscipit inventore laboriosam culpa.	2025-08-03	14:45	3	pending	APT10960	\N
9962	283	7	2025-08-03 13:45:00	Diabetes Check	OPD	Magnam libero maiores accusamus sunt dolorum quam nobis.	2025-06-26 22:30:08	2025-06-26 22:30:08	110/83	83	99.0	100	57	Optio explicabo ex nostrum. Placeat magni labore ad aut.	Dignissimos et necessitatibus sint autem magnam maxime quaerat necessitatibus aperiam.	2025-08-18	Necessitatibus molestiae tempore unde enim illum.	2025-08-03	13:45	3	pending	APT10961	\N
9963	374	4	2025-08-03 16:15:00	Headache	Emergency	Hic minus explicabo temporibus exercitationem placeat illo.	2025-06-26 22:30:08	2025-06-26 22:30:08	109/68	87	97.9	98	59	Delectus amet quis neque provident.	Quod est numquam adipisci eius quae necessitatibus rem.	2025-08-12	Facere blanditiis praesentium harum fuga earum aliquam quis.	2025-08-03	16:15	3	pending	APT10962	\N
9964	268	8	2025-08-03 15:15:00	Back Pain	Emergency	Doloremque doloremque maxime voluptatem.	2025-06-26 22:30:08	2025-06-26 22:30:08	134/62	100	98.9	97	84	Ut quam impedit vitae quo officia quibusdam.	Perspiciatis qui aperiam ducimus labore ullam possimus.	2025-08-13	Quae repellendus culpa.	2025-08-03	15:15	3	pending	APT10963	\N
9965	318	4	2025-08-03 12:45:00	Diabetes Check	OPD	Quos ullam iure.	2025-06-26 22:30:08	2025-06-26 22:30:08	125/85	91	98.3	99	61	Reiciendis reprehenderit excepturi id debitis suscipit.	Nostrum nulla debitis error dignissimos earum dicta cumque dolores.	2025-08-28	Accusantium eaque impedit dolorem vel consequuntur.	2025-08-03	12:45	3	pending	APT10964	\N
9966	283	4	2025-08-03 12:45:00	Routine Checkup	Follow-up	Aliquid delectus expedita ipsum deleniti.	2025-06-26 22:30:08	2025-06-26 22:30:08	102/80	93	97.9	99	56	Provident nobis enim quaerat.	Adipisci quod dicta quod dolorum est necessitatibus.	2025-08-30	Nesciunt ratione harum recusandae ut in hic.	2025-08-03	12:45	3	pending	APT10965	\N
9967	245	3	2025-08-03 16:30:00	Fever	Emergency	Quis laudantium soluta corrupti.	2025-06-26 22:30:08	2025-06-26 22:30:08	121/77	80	98.0	100	73	Quis facere a impedit quasi numquam.	Quisquam voluptates autem neque blanditiis sint nostrum dicta saepe velit.	2025-08-21	Occaecati reiciendis laboriosam alias doloribus.	2025-08-03	16:30	3	pending	APT10966	\N
9968	16	7	2025-08-03 14:00:00	Cough	Follow-up	Voluptas distinctio eligendi.	2025-06-26 22:30:08	2025-06-26 22:30:08	127/64	69	100.3	97	57	Nam veritatis corrupti ipsum excepturi.	Voluptas labore laboriosam ex.	2025-08-25	Exercitationem est similique nisi placeat et dolore aperiam.	2025-08-03	14:00	3	pending	APT10967	\N
9969	321	6	2025-08-03 16:45:00	Skin Rash	Emergency	Accusantium quo deleniti.	2025-06-26 22:30:08	2025-06-26 22:30:08	116/73	85	99.4	95	57	Omnis aliquam occaecati nobis.	Suscipit quae quaerat dolore nemo neque ut.	2025-08-19	Et perspiciatis eaque totam omnis blanditiis ea.	2025-08-03	16:45	3	pending	APT10968	\N
9970	137	10	2025-08-03 11:45:00	Diabetes Check	OPD	Tempora neque voluptatibus perspiciatis cumque eligendi.	2025-06-26 22:30:08	2025-06-26 22:30:08	116/70	72	99.8	96	69	Voluptatibus eos temporibus id.	Nostrum corporis incidunt fuga modi ut.	2025-09-02	Animi eos laborum adipisci vitae rerum accusantium.	2025-08-03	11:45	3	pending	APT10969	\N
9971	334	3	2025-08-03 15:45:00	Back Pain	New	Earum quidem unde voluptate laborum asperiores.	2025-06-26 22:30:08	2025-06-26 22:30:08	130/64	73	99.3	99	70	Molestias aliquam quasi unde. Fugit facilis a.	Eos ratione eum aliquam eius.	2025-08-29	Eius quod delectus officia velit nemo doloremque illo.	2025-08-03	15:45	3	pending	APT10970	\N
9972	347	4	2025-08-03 12:00:00	Routine Checkup	New	Assumenda hic explicabo quisquam neque consectetur recusandae.	2025-06-26 22:30:08	2025-06-26 22:30:08	124/71	87	97.6	96	80	Blanditiis ut ex amet nisi ut incidunt eos.	Placeat adipisci voluptatum dolorum.	2025-08-27	Ad perferendis similique eligendi accusantium occaecati.	2025-08-03	12:00	3	pending	APT10971	\N
9973	397	3	2025-08-03 13:00:00	Routine Checkup	OPD	Sit odio necessitatibus iure expedita quae provident dolores.	2025-06-26 22:30:08	2025-06-26 22:30:08	114/73	82	98.1	100	77	Delectus ut laboriosam velit fugit neque iusto sed.	Eveniet adipisci amet iure voluptatum magni magnam.	2025-08-26	Doloribus quos ipsam rerum quisquam ut vero.	2025-08-03	13:00	3	pending	APT10972	\N
9974	472	7	2025-08-03 12:00:00	Skin Rash	New	Doloribus dolore aspernatur minus aliquid modi.	2025-06-26 22:30:08	2025-06-26 22:30:08	125/79	87	100.0	97	67	Adipisci architecto magnam enim minima.	Voluptatem atque inventore doloremque sequi repellendus laborum.	2025-08-28	Sit numquam magnam odio praesentium quidem.	2025-08-03	12:00	3	pending	APT10973	\N
9975	217	6	2025-08-03 12:45:00	Diabetes Check	OPD	Delectus est doloremque neque repellendus.	2025-06-26 22:30:08	2025-06-26 22:30:08	139/87	81	97.8	100	61	Itaque officiis consequuntur officiis ea.	Doloribus totam blanditiis nam vitae aspernatur eum quibusdam accusantium repellat.	2025-08-23	Aut laboriosam corporis accusamus.	2025-08-03	12:45	3	pending	APT10974	\N
9976	189	9	2025-08-03 15:00:00	Diabetes Check	OPD	Numquam voluptates alias vitae.	2025-06-26 22:30:08	2025-06-26 22:30:08	113/90	76	97.7	95	65	Odio consequatur fugit accusamus est.	At impedit in voluptatem voluptatem magni inventore.	2025-08-30	Perspiciatis labore tempora aliquam natus doloribus fugiat.	2025-08-03	15:00	3	pending	APT10975	\N
9977	285	5	2025-08-03 15:15:00	Routine Checkup	New	Maxime autem illum aut.	2025-06-26 22:30:08	2025-06-26 22:30:08	127/75	87	100.1	95	68	Reprehenderit natus odio in consequatur facere.	Voluptatem voluptate tenetur ut accusamus tempore.	2025-08-24	Perspiciatis animi mollitia eius maxime magnam impedit.	2025-08-03	15:15	3	pending	APT10976	\N
9978	137	8	2025-08-03 13:45:00	Skin Rash	OPD	Reprehenderit ducimus doloribus labore possimus provident.	2025-06-26 22:30:08	2025-06-26 22:30:08	104/82	79	99.1	96	67	Sed ut accusamus dolor.	Nulla deserunt officiis ullam aliquid expedita laborum.	2025-08-24	Laborum ea molestiae totam repellendus.	2025-08-03	13:45	3	pending	APT10977	\N
9979	287	8	2025-08-03 14:15:00	Fever	Emergency	Nisi quaerat dicta.	2025-06-26 22:30:08	2025-06-26 22:30:08	128/66	98	98.3	100	58	Saepe a ducimus maxime.	Non nihil dolor amet voluptates ratione voluptate laboriosam veniam omnis.	2025-08-31	Suscipit odit molestias asperiores doloribus nihil.	2025-08-03	14:15	3	pending	APT10978	\N
9980	247	4	2025-08-04 13:30:00	Diabetes Check	Follow-up	Quam temporibus laborum iste placeat.	2025-06-26 22:30:08	2025-06-26 22:30:08	110/66	65	100.2	100	56	Et nesciunt inventore aspernatur ipsam.	Magnam ex accusantium minus illo.	2025-09-02	Odio non explicabo pariatur exercitationem.	2025-08-04	13:30	3	pending	APT10979	\N
9981	189	6	2025-08-04 11:00:00	Skin Rash	Emergency	Pariatur expedita vel odit ut.	2025-06-26 22:30:08	2025-06-26 22:30:08	135/60	90	99.2	96	78	Facilis soluta nulla.	Ratione incidunt porro natus quisquam.	2025-09-03	Aspernatur unde porro.	2025-08-04	11:00	3	pending	APT10980	\N
9982	448	6	2025-08-04 12:00:00	High BP	Follow-up	Exercitationem quos eligendi recusandae molestias.	2025-06-26 22:30:08	2025-06-26 22:30:08	110/64	100	100.1	96	80	Doloribus sequi nulla a quaerat veritatis fugiat fugit.	Modi laudantium nam ex ipsa beatae quae.	2025-08-25	Eaque provident ut quae explicabo ab culpa.	2025-08-04	12:00	3	pending	APT10981	\N
9983	426	5	2025-08-04 14:15:00	High BP	Emergency	Est quia minima nulla beatae vero eos.	2025-06-26 22:30:08	2025-06-26 22:30:08	129/65	83	99.7	96	56	Veniam dolorum eveniet exercitationem nulla.	Esse exercitationem fugit asperiores hic quibusdam alias veritatis.	2025-08-20	Ipsam pariatur nihil praesentium quibusdam odio natus.	2025-08-04	14:15	3	pending	APT10982	\N
9984	19	5	2025-08-04 14:15:00	High BP	OPD	Similique repudiandae delectus quae distinctio ullam quos.	2025-06-26 22:30:08	2025-06-26 22:30:08	118/75	88	100.2	99	72	Fugit veniam facere suscipit in animi.	Quae praesentium voluptatem enim temporibus dolore aliquid possimus voluptatem atque incidunt.	2025-08-24	Eaque excepturi similique.	2025-08-04	14:15	3	pending	APT10983	\N
9985	54	5	2025-08-04 11:45:00	Diabetes Check	Emergency	Dolores esse rem aliquid amet voluptate.	2025-06-26 22:30:08	2025-06-26 22:30:08	117/84	85	97.9	95	72	Quos modi rerum earum ratione architecto voluptate.	Pariatur ex cum eligendi accusamus nemo quia libero provident.	2025-08-28	Consequatur vel voluptate beatae voluptas repudiandae saepe.	2025-08-04	11:45	3	pending	APT10984	\N
9986	462	4	2025-08-04 14:00:00	Fever	Follow-up	Totam molestiae delectus dignissimos necessitatibus placeat.	2025-06-26 22:30:08	2025-06-26 22:30:08	119/90	67	98.7	98	67	Illum quos quisquam fugit id id debitis.	Harum dignissimos cum possimus commodi exercitationem harum.	2025-08-12	Consequuntur odio facere placeat omnis harum eaque.	2025-08-04	14:00	3	pending	APT10985	\N
9987	109	7	2025-08-04 11:15:00	Cough	OPD	Sequi omnis sunt.	2025-06-26 22:30:08	2025-06-26 22:30:08	100/72	77	99.1	98	58	Molestiae velit assumenda ducimus.	Aspernatur repellat odio modi aliquam quis doloribus.	2025-08-18	Perferendis reiciendis laudantium minima eaque repellendus ducimus aliquam.	2025-08-04	11:15	3	pending	APT10986	\N
9988	110	7	2025-08-04 13:00:00	Back Pain	Emergency	Ex dignissimos eveniet eius eligendi et.	2025-06-26 22:30:08	2025-06-26 22:30:08	140/89	99	100.2	100	63	Suscipit ut natus porro saepe sapiente.	Labore earum occaecati sint architecto maxime doloribus modi at provident eum.	2025-09-02	Iure voluptates quas molestiae voluptas eum iure.	2025-08-04	13:00	3	pending	APT10987	\N
9989	144	3	2025-08-04 16:00:00	Diabetes Check	OPD	Aliquid at dolores pariatur.	2025-06-26 22:30:08	2025-06-26 22:30:08	118/64	75	99.8	99	70	Aliquam in dignissimos error cupiditate.	Voluptatem laboriosam mollitia aperiam rerum maxime pariatur ab consequatur cumque ipsa.	2025-08-31	Culpa esse sequi exercitationem perferendis.	2025-08-04	16:00	3	pending	APT10988	\N
9990	421	4	2025-08-04 13:45:00	Routine Checkup	New	Saepe voluptatum maxime nulla dolor.	2025-06-26 22:30:08	2025-06-26 22:30:08	138/77	77	99.1	98	65	Ut facilis nihil doloribus.	Sit omnis ad id maxime nobis nulla dolore.	2025-08-27	Neque culpa facere a harum non odio.	2025-08-04	13:45	3	pending	APT10989	\N
9991	63	10	2025-08-04 13:45:00	Cough	Emergency	Placeat maiores voluptate.	2025-06-26 22:30:08	2025-06-26 22:30:08	112/71	98	97.6	97	72	Dolorum debitis voluptatum unde omnis iste.	Esse quas suscipit dolore neque commodi.	2025-08-17	Ullam veritatis tempore provident id architecto.	2025-08-04	13:45	3	pending	APT10990	\N
9992	112	5	2025-08-04 16:15:00	Diabetes Check	Emergency	Sed suscipit ipsum molestiae eligendi veniam dolor.	2025-06-26 22:30:08	2025-06-26 22:30:08	105/61	95	98.6	98	69	Eaque eaque deserunt est velit molestias.	Consectetur perferendis nobis quia corporis.	2025-08-26	Atque illum est dolorum.	2025-08-04	16:15	3	pending	APT10991	\N
9993	102	8	2025-08-04 12:00:00	Skin Rash	OPD	Quisquam illo explicabo.	2025-06-26 22:30:08	2025-06-26 22:30:08	133/88	90	100.4	95	73	Deserunt minus impedit nam quo quam eligendi.	Enim architecto iusto eveniet molestiae magnam quasi hic labore.	2025-08-31	Provident totam temporibus repudiandae assumenda impedit debitis ratione.	2025-08-04	12:00	3	pending	APT10992	\N
9994	430	6	2025-08-04 13:30:00	Diabetes Check	OPD	Autem quae earum a explicabo.	2025-06-26 22:30:08	2025-06-26 22:30:08	117/76	86	100.4	100	69	Sunt harum doloremque blanditiis blanditiis.	Id impedit ipsum quasi dolorum tempore quibusdam dolor.	2025-08-24	Pariatur dolorum qui.	2025-08-04	13:30	3	pending	APT10993	\N
9995	412	6	2025-08-04 12:45:00	Routine Checkup	OPD	Quod delectus nesciunt commodi beatae.	2025-06-26 22:30:08	2025-06-26 22:30:08	133/90	83	98.1	95	61	Numquam natus consequatur sequi expedita cupiditate unde.	Eaque ipsam quis quam culpa rem quae voluptatibus provident debitis.	2025-08-27	Fugiat necessitatibus iusto nobis ad.	2025-08-04	12:45	3	pending	APT10994	\N
9996	218	10	2025-08-04 15:00:00	Skin Rash	OPD	Nesciunt iste soluta voluptatem sit.	2025-06-26 22:30:08	2025-06-26 22:30:08	106/64	86	98.3	98	56	Facere consequatur soluta deserunt.	Molestiae id illo esse quaerat voluptas non dolorum nemo qui.	2025-08-23	Hic a assumenda quas.	2025-08-04	15:00	3	pending	APT10995	\N
9997	445	8	2025-08-04 16:45:00	Back Pain	Follow-up	Deserunt incidunt sunt modi.	2025-06-26 22:30:08	2025-06-26 22:30:08	112/83	70	99.7	97	77	Consectetur necessitatibus aliquam rem sint.	Incidunt eligendi officia beatae repellendus quisquam quos laboriosam fugit.	2025-08-16	Ad quidem dignissimos saepe.	2025-08-04	16:45	3	pending	APT10996	\N
9998	85	3	2025-08-04 13:45:00	High BP	New	Corporis nostrum nesciunt excepturi enim repellat voluptatibus vero.	2025-06-26 22:30:08	2025-06-26 22:30:08	107/88	87	97.6	96	62	Labore dolorem error quis fugiat.	Dignissimos voluptatibus voluptates nemo iusto quia necessitatibus exercitationem.	2025-08-12	Ipsum qui aliquid et veritatis nobis sint.	2025-08-04	13:45	3	pending	APT10997	\N
9999	345	4	2025-08-04 11:15:00	Diabetes Check	Follow-up	Autem maxime enim velit.	2025-06-26 22:30:08	2025-06-26 22:30:08	119/64	76	99.9	97	76	Earum rem aspernatur nihil cumque voluptatem id.	Inventore quo blanditiis omnis cumque laborum temporibus.	2025-08-12	Vero inventore architecto praesentium ut debitis recusandae.	2025-08-04	11:15	3	pending	APT10998	\N
10000	131	3	2025-08-04 11:45:00	Diabetes Check	Follow-up	Eveniet consectetur ipsum pariatur.	2025-06-26 22:30:08	2025-06-26 22:30:08	123/60	70	99.4	97	73	Doloremque autem aut et voluptas magnam excepturi.	Quisquam et molestiae magnam aliquid aspernatur odit.	2025-08-14	Dolore iure assumenda nemo.	2025-08-04	11:45	3	pending	APT10999	\N
10001	261	7	2025-08-04 11:15:00	Cough	New	Laboriosam harum quod.	2025-06-26 22:30:08	2025-06-26 22:30:08	129/78	73	100.2	96	61	Asperiores quod eos fugiat blanditiis a id quibusdam.	Ipsa laudantium qui earum magni.	2025-08-23	Similique voluptate cumque vitae unde saepe.	2025-08-04	11:15	3	pending	APT11000	\N
10002	111	10	2025-08-04 14:00:00	Fever	Follow-up	Eligendi praesentium ratione consectetur doloribus.	2025-06-26 22:30:08	2025-06-26 22:30:08	116/67	89	97.9	96	61	Natus voluptas accusantium ut quia error eligendi amet.	Harum ad eum ad sequi dolores.	2025-08-22	Recusandae iusto corporis porro impedit provident sed.	2025-08-04	14:00	3	pending	APT11001	\N
10003	356	4	2025-08-04 11:45:00	Diabetes Check	Emergency	Repellendus itaque tempore nihil.	2025-06-26 22:30:08	2025-06-26 22:30:08	138/68	68	99.9	96	68	Recusandae nulla ducimus inventore animi cumque.	Dolorem aperiam rem cum fugit quae.	2025-08-21	Vitae saepe ex dignissimos tenetur.	2025-08-04	11:45	3	pending	APT11002	\N
10004	281	5	2025-08-04 12:30:00	High BP	Follow-up	Ratione quisquam distinctio explicabo rerum maiores omnis.	2025-06-26 22:30:08	2025-06-26 22:30:08	101/65	92	99.6	98	57	Suscipit non consectetur cupiditate non assumenda illum.	Eligendi ad cumque in dolore sunt quo voluptate quidem.	2025-08-25	Fuga neque nemo eveniet debitis.	2025-08-04	12:30	3	pending	APT11003	\N
10005	410	7	2025-08-04 15:00:00	High BP	Emergency	Inventore suscipit ea nihil reiciendis ullam temporibus.	2025-06-26 22:30:08	2025-06-26 22:30:08	140/90	98	97.7	96	67	Reiciendis deserunt dolore labore.	Alias reiciendis adipisci repudiandae facere quis repellendus non ratione inventore.	2025-08-22	Eaque consectetur nostrum sit.	2025-08-04	15:00	3	pending	APT11004	\N
10006	492	6	2025-08-04 14:00:00	Headache	New	Dignissimos quibusdam sed labore molestiae debitis.	2025-06-26 22:30:08	2025-06-26 22:30:08	137/84	86	98.2	99	75	Accusantium accusantium deserunt iusto.	Nihil enim aut ut omnis totam dicta fugiat.	2025-08-13	Libero possimus ullam sint sed rem.	2025-08-04	14:00	3	pending	APT11005	\N
10007	481	5	2025-08-04 11:30:00	Routine Checkup	Follow-up	Animi aut praesentium exercitationem saepe laborum necessitatibus.	2025-06-26 22:30:08	2025-06-26 22:30:08	132/78	77	100.2	98	64	Nihil perspiciatis iure repellat itaque nostrum.	Cumque commodi eos laboriosam quam enim aliquam quae quas ipsa.	2025-09-03	Sint rem nihil similique doloremque ipsum.	2025-08-04	11:30	3	pending	APT11006	\N
10008	461	8	2025-08-04 11:45:00	Routine Checkup	Follow-up	Iusto quo alias.	2025-06-26 22:30:08	2025-06-26 22:30:08	126/79	69	98.0	98	73	Ratione molestiae repellendus omnis asperiores sapiente.	Sequi facilis nesciunt architecto nulla est molestias harum itaque delectus.	2025-08-22	Corporis vitae quidem officia eaque et unde odit.	2025-08-04	11:45	3	pending	APT11007	\N
10009	234	6	2025-08-05 16:00:00	Back Pain	Follow-up	Dicta quo maiores voluptates.	2025-06-26 22:30:08	2025-06-26 22:30:08	116/69	75	98.9	97	60	Quaerat aperiam accusamus inventore.	Repudiandae earum repudiandae accusantium laboriosam veniam dignissimos fugit quasi placeat.	2025-08-17	Commodi temporibus dolorum earum sapiente dolor.	2025-08-05	16:00	3	pending	APT11008	\N
10010	394	9	2025-08-05 14:00:00	Skin Rash	Emergency	Vel officiis quis quaerat quis officia at numquam.	2025-06-26 22:30:08	2025-06-26 22:30:08	133/63	95	97.7	96	55	Et inventore dicta consequatur saepe commodi delectus.	Exercitationem suscipit tempora earum error repellat illo cum.	2025-09-01	Pariatur aliquid aut dolorum.	2025-08-05	14:00	3	pending	APT11009	\N
10011	140	8	2025-08-05 15:00:00	High BP	Emergency	Veniam totam cumque.	2025-06-26 22:30:08	2025-06-26 22:30:08	132/89	86	98.3	100	82	Cupiditate eos iure assumenda corrupti quisquam sunt.	Excepturi inventore veniam in distinctio voluptate.	2025-08-30	Esse aliquam aut blanditiis culpa doloremque eaque.	2025-08-05	15:00	3	pending	APT11010	\N
10012	132	4	2025-08-05 15:45:00	Cough	Follow-up	Temporibus cumque dolorem commodi eligendi id fuga.	2025-06-26 22:30:08	2025-06-26 22:30:08	117/89	86	100.3	98	63	Excepturi perferendis perspiciatis officiis saepe.	Praesentium voluptatibus voluptatum amet perferendis.	2025-09-02	Saepe minus ipsam aliquam recusandae.	2025-08-05	15:45	3	pending	APT11011	\N
10013	113	8	2025-08-05 11:45:00	High BP	OPD	Dolore excepturi nihil totam.	2025-06-26 22:30:08	2025-06-26 22:30:08	117/79	87	99.1	99	73	Aperiam molestias dolor aliquid sapiente earum veritatis.	Repellat accusamus deserunt quia et numquam ipsa itaque mollitia tempore.	2025-08-24	Accusantium quos minima accusantium pariatur nobis voluptatem perferendis.	2025-08-05	11:45	3	pending	APT11012	\N
10014	105	6	2025-08-05 12:15:00	Routine Checkup	New	Maxime amet ipsum ipsa assumenda corrupti esse.	2025-06-26 22:30:08	2025-06-26 22:30:08	103/84	79	98.4	100	75	Ab nisi magni pariatur aut minus minima nulla.	Voluptatum tenetur veniam quas quae.	2025-08-20	Natus recusandae qui odit at dolor.	2025-08-05	12:15	3	pending	APT11013	\N
10015	52	4	2025-08-05 15:45:00	Headache	Follow-up	Reiciendis dicta deleniti a laudantium beatae dolorem.	2025-06-26 22:30:08	2025-06-26 22:30:08	138/72	84	99.4	99	57	Repudiandae voluptatem alias eum deleniti.	Voluptate blanditiis beatae deserunt vitae sit.	2025-08-16	Hic assumenda voluptas ratione laborum beatae fuga fugiat.	2025-08-05	15:45	3	pending	APT11014	\N
10016	481	7	2025-08-05 16:00:00	High BP	Emergency	Fugit ab velit quibusdam sequi provident.	2025-06-26 22:30:08	2025-06-26 22:30:08	116/88	82	97.9	95	71	Aliquam iusto a minus nostrum cum et quasi.	Enim facilis sed a similique unde aspernatur eius.	2025-08-12	Dolores aliquid ab cum earum.	2025-08-05	16:00	3	pending	APT11015	\N
10017	366	6	2025-08-05 11:15:00	Headache	OPD	Rerum dicta necessitatibus amet soluta hic cumque aut.	2025-06-26 22:30:08	2025-06-26 22:30:08	133/89	79	98.3	95	56	Quae ad iure reprehenderit cum ab quidem.	Deleniti nihil officiis minima harum sunt voluptates iste temporibus odio temporibus.	2025-08-19	Voluptatem quibusdam pariatur ratione.	2025-08-05	11:15	3	pending	APT11016	\N
10018	228	5	2025-08-05 16:45:00	Diabetes Check	Emergency	Nobis quis delectus excepturi.	2025-06-26 22:30:08	2025-06-26 22:30:08	117/71	88	98.0	98	61	Recusandae possimus odio vel eveniet perferendis error.	Vel tempore eius eveniet quae quibusdam tempora culpa voluptatum illum.	2025-09-03	Placeat voluptatibus id ex illo.	2025-08-05	16:45	3	pending	APT11017	\N
10019	204	6	2025-08-05 16:45:00	Routine Checkup	Emergency	Laboriosam ipsum hic aliquam totam nihil.	2025-06-26 22:30:08	2025-06-26 22:30:08	132/69	79	98.8	99	59	Dicta voluptatibus consequuntur nisi et accusamus.	Neque praesentium dolorum nihil fugiat eaque modi.	2025-08-26	Velit excepturi ducimus laudantium corporis amet.	2025-08-05	16:45	3	pending	APT11018	\N
10020	420	5	2025-08-05 11:30:00	Skin Rash	Follow-up	Consequatur dolorum exercitationem perspiciatis cupiditate itaque dignissimos.	2025-06-26 22:30:08	2025-06-26 22:30:08	106/86	93	100.1	100	63	Recusandae facere placeat aliquid accusantium beatae.	Aut facilis inventore atque consequuntur provident.	2025-08-17	Occaecati distinctio harum enim corrupti amet reprehenderit.	2025-08-05	11:30	3	pending	APT11019	\N
10021	434	9	2025-08-05 11:15:00	Back Pain	OPD	In molestiae cum consequatur quaerat delectus.	2025-06-26 22:30:08	2025-06-26 22:30:08	112/89	67	99.0	97	66	Repudiandae recusandae alias quas deleniti.	Culpa autem nihil necessitatibus similique.	2025-08-14	Dicta quia optio deleniti quaerat.	2025-08-05	11:15	3	pending	APT11020	\N
10022	257	6	2025-08-05 11:00:00	Skin Rash	Follow-up	Accusamus necessitatibus harum cupiditate.	2025-06-26 22:30:08	2025-06-26 22:30:08	138/66	71	100.4	99	77	Ea occaecati ipsam modi. In alias rerum.	Fuga ab blanditiis quae doloribus.	2025-08-15	Velit expedita quo dolore illum dicta vero.	2025-08-05	11:00	3	pending	APT11021	\N
10023	145	9	2025-08-05 12:45:00	Diabetes Check	New	Quas perspiciatis molestias sapiente aspernatur officia blanditiis.	2025-06-26 22:30:08	2025-06-26 22:30:08	139/67	86	100.4	99	70	Assumenda laboriosam id eaque deleniti eveniet nihil.	Odio dignissimos atque fuga nesciunt ab molestias aliquid temporibus officiis.	2025-08-20	Ratione nisi rem accusamus fugiat animi.	2025-08-05	12:45	3	pending	APT11022	\N
10024	49	9	2025-08-05 14:00:00	Fever	Follow-up	Dolores corrupti unde magnam harum blanditiis corporis adipisci.	2025-06-26 22:30:08	2025-06-26 22:30:08	125/80	74	100.2	99	85	Dicta enim sunt enim.	Exercitationem possimus minima odit nobis eaque eum nulla rerum vitae.	2025-08-28	Laudantium minus libero provident amet quam.	2025-08-05	14:00	3	pending	APT11023	\N
10025	484	9	2025-08-05 13:45:00	Diabetes Check	New	Vel quisquam asperiores earum iure quia pariatur.	2025-06-26 22:30:08	2025-06-26 22:30:08	125/90	98	98.7	97	64	A iure fugit molestias laudantium doloremque.	Et inventore nobis nihil commodi nostrum sunt soluta nulla ullam.	2025-09-01	Vel veritatis velit tempora autem.	2025-08-05	13:45	3	pending	APT11024	\N
10026	240	4	2025-08-05 14:30:00	Fever	OPD	Sint quae consectetur ex eveniet.	2025-06-26 22:30:08	2025-06-26 22:30:08	122/86	68	98.0	97	55	Voluptas enim magni assumenda vel quae illo.	Hic nam minima cumque in corporis quasi suscipit.	2025-09-04	Adipisci nemo praesentium facilis quae sapiente delectus.	2025-08-05	14:30	3	pending	APT11025	\N
10027	71	6	2025-08-05 12:15:00	Headache	OPD	Consectetur quaerat facilis accusamus quas debitis.	2025-06-26 22:30:08	2025-06-26 22:30:08	104/87	76	97.7	96	77	Quam ab animi expedita unde nulla debitis.	Quo ducimus temporibus sapiente magnam iusto laborum.	2025-09-04	Dolores provident fuga.	2025-08-05	12:15	3	pending	APT11026	\N
10028	44	7	2025-08-05 16:45:00	Skin Rash	Follow-up	Vel eligendi et nesciunt eaque officia dignissimos esse.	2025-06-26 22:30:08	2025-06-26 22:30:08	107/86	73	98.0	95	70	Optio corporis dignissimos corporis voluptatibus quo.	Harum nostrum inventore ab sapiente fugiat in nihil minus.	2025-08-16	Odit tempore reiciendis explicabo exercitationem.	2025-08-05	16:45	3	pending	APT11027	\N
10029	407	10	2025-08-05 16:00:00	Diabetes Check	New	Quos sed culpa quod.	2025-06-26 22:30:08	2025-06-26 22:30:08	136/76	82	98.5	98	63	Dolores quo corporis soluta dolore nesciunt.	Voluptatum harum totam illo maiores.	2025-08-12	Libero nisi possimus possimus voluptatum.	2025-08-05	16:00	3	pending	APT11028	\N
10030	386	6	2025-08-05 15:30:00	High BP	OPD	Nam officia corrupti repudiandae quidem laborum.	2025-06-26 22:30:08	2025-06-26 22:30:08	120/87	82	100.5	97	74	Dicta laudantium officia aliquid quam provident voluptas.	Expedita corporis sequi fugiat.	2025-08-24	Laboriosam necessitatibus ducimus quos repudiandae.	2025-08-05	15:30	3	pending	APT11029	\N
10031	434	10	2025-08-05 13:30:00	Cough	New	Sequi esse ea possimus.	2025-06-26 22:30:08	2025-06-26 22:30:08	134/79	98	99.2	100	68	Facere fugiat voluptas deleniti.	Delectus cumque ratione magni corporis esse earum laboriosam placeat.	2025-08-27	Ipsa veniam modi autem nulla doloremque incidunt.	2025-08-05	13:30	3	pending	APT11030	\N
10032	20	9	2025-08-05 12:15:00	Routine Checkup	Follow-up	Eligendi porro voluptate aliquid est quidem.	2025-06-26 22:30:08	2025-06-26 22:30:08	135/60	79	98.3	99	80	Nostrum ex voluptatibus labore porro minima.	Excepturi porro ipsum ducimus dolores.	2025-08-16	Voluptas quam officiis enim excepturi explicabo nam.	2025-08-05	12:15	3	pending	APT11031	\N
10033	361	3	2025-08-05 15:30:00	Diabetes Check	Follow-up	Nobis delectus autem at reiciendis similique.	2025-06-26 22:30:08	2025-06-26 22:30:08	117/76	85	100.5	100	80	Consequuntur dolore quae sequi illo.	Ea asperiores neque dolor eum quam error.	2025-08-30	Distinctio necessitatibus ex excepturi saepe.	2025-08-05	15:30	3	pending	APT11032	\N
10034	287	9	2025-08-05 16:30:00	Cough	New	Minus quae iure minus placeat at ullam.	2025-06-26 22:30:08	2025-06-26 22:30:08	113/62	71	98.2	95	83	Soluta recusandae eveniet.	Perspiciatis ipsum aliquid hic fugit voluptas ipsam amet iusto.	2025-09-04	Ipsa tenetur minus mollitia ullam in eum alias.	2025-08-05	16:30	3	pending	APT11033	\N
10035	348	3	2025-08-06 11:30:00	Back Pain	OPD	Temporibus praesentium voluptates facere illo perferendis.	2025-06-26 22:30:08	2025-06-26 22:30:08	127/71	84	98.9	96	61	Aliquam at dolorum id esse dolores quas et.	A quas sed fugit odit reiciendis.	2025-08-14	Sapiente consequatur perferendis illum.	2025-08-06	11:30	3	pending	APT11034	\N
10036	435	3	2025-08-06 14:45:00	Routine Checkup	New	Necessitatibus quos sequi accusantium eveniet aliquam.	2025-06-26 22:30:08	2025-06-26 22:30:08	111/73	86	99.3	100	69	Occaecati beatae possimus saepe quisquam labore.	Voluptate mollitia voluptatibus officiis.	2025-09-03	Debitis assumenda pariatur est unde.	2025-08-06	14:45	3	pending	APT11035	\N
10037	270	3	2025-08-06 15:00:00	Cough	Emergency	Pariatur iusto ratione in sint maiores sapiente blanditiis.	2025-06-26 22:30:08	2025-06-26 22:30:08	111/61	95	97.8	96	63	Molestiae in debitis possimus ullam.	Magni quis suscipit placeat amet neque itaque.	2025-08-24	Quasi ab atque omnis.	2025-08-06	15:00	3	pending	APT11036	\N
10038	249	10	2025-08-06 15:45:00	Cough	New	Consequuntur doloremque sed officiis architecto.	2025-06-26 22:30:08	2025-06-26 22:30:08	131/81	95	97.7	99	72	Excepturi omnis tempora magnam nobis.	Beatae voluptates eligendi qui voluptatibus nulla.	2025-08-16	Quasi nesciunt itaque suscipit recusandae.	2025-08-06	15:45	3	pending	APT11037	\N
10039	114	6	2025-08-06 13:15:00	High BP	New	Itaque sapiente provident suscipit facere.	2025-06-26 22:30:08	2025-06-26 22:30:08	113/72	71	98.1	100	84	Voluptatum numquam facilis voluptate.	Quae nisi sint iusto nesciunt sed voluptatibus mollitia omnis ad.	2025-08-27	Sequi quis nobis magni repellendus.	2025-08-06	13:15	3	pending	APT11038	\N
10040	42	8	2025-08-06 16:30:00	Headache	Follow-up	Ipsam aspernatur itaque voluptas dicta.	2025-06-26 22:30:08	2025-06-26 22:30:08	129/76	90	97.9	100	78	Recusandae minus dolores fugit id aut.	Voluptatibus molestias ipsa distinctio architecto exercitationem.	2025-09-04	Aperiam magnam alias explicabo illum.	2025-08-06	16:30	3	pending	APT11039	\N
10041	38	9	2025-08-06 12:15:00	Cough	OPD	Voluptate delectus quis saepe.	2025-06-26 22:30:08	2025-06-26 22:30:08	137/79	97	99.4	99	79	Provident magnam voluptates aperiam mollitia est modi.	Odio sequi culpa error.	2025-08-26	Mollitia aspernatur assumenda perferendis qui minus enim eum.	2025-08-06	12:15	3	pending	APT11040	\N
10042	70	7	2025-08-06 16:15:00	Cough	Emergency	Similique quia enim quod blanditiis.	2025-06-26 22:30:08	2025-06-26 22:30:08	133/63	67	98.8	97	85	Tempore culpa nostrum quasi dolore similique eveniet.	Dolore magnam similique earum minus repudiandae non voluptas veniam.	2025-09-01	Perferendis cupiditate repellendus ratione.	2025-08-06	16:15	3	pending	APT11041	\N
10043	361	8	2025-08-06 13:45:00	Fever	Follow-up	Laborum ab perspiciatis quos molestiae culpa.	2025-06-26 22:30:08	2025-06-26 22:30:08	137/82	94	97.9	100	83	Nesciunt illum ipsa consequatur fugit a dolores.	Amet asperiores ducimus odio animi quasi explicabo.	2025-08-23	Dolorum eius vitae culpa debitis totam.	2025-08-06	13:45	3	pending	APT11042	\N
10044	62	5	2025-08-06 12:15:00	Routine Checkup	Follow-up	Doloribus dignissimos natus minima placeat ab porro suscipit.	2025-06-26 22:30:08	2025-06-26 22:30:08	133/71	76	97.8	100	63	Numquam necessitatibus eum dicta cumque.	Ducimus tempora deleniti ea doloremque ab hic nisi at alias.	2025-09-01	Porro consequatur expedita autem.	2025-08-06	12:15	3	pending	APT11043	\N
10045	291	8	2025-08-06 16:00:00	Fever	Emergency	Et explicabo ipsam at earum.	2025-06-26 22:30:08	2025-06-26 22:30:08	101/79	65	100.2	95	70	Soluta possimus asperiores molestiae magnam itaque.	Corrupti deleniti in dolores possimus.	2025-08-20	Debitis fuga quasi reprehenderit velit vel quae.	2025-08-06	16:00	3	pending	APT11044	\N
10046	342	5	2025-08-06 16:30:00	High BP	Emergency	Necessitatibus quia expedita reiciendis deserunt ut incidunt.	2025-06-26 22:30:08	2025-06-26 22:30:08	104/78	76	98.2	97	65	Quisquam sequi dolore. Maxime vitae atque reprehenderit.	Voluptatum architecto voluptas culpa tempore quas alias.	2025-08-31	Sapiente quae aliquid consequuntur ullam qui.	2025-08-06	16:30	3	pending	APT11045	\N
10047	344	3	2025-08-06 13:45:00	Routine Checkup	OPD	Architecto veritatis quidem excepturi libero labore.	2025-06-26 22:30:08	2025-06-26 22:30:08	124/74	67	99.1	100	74	Sunt dolor modi ipsam qui accusantium laborum.	Nisi cumque iusto eaque quisquam tempore nemo eveniet.	2025-08-22	Soluta repudiandae a.	2025-08-06	13:45	3	pending	APT11046	\N
10048	143	5	2025-08-06 16:45:00	High BP	New	Ipsa alias id deserunt dolore inventore fugit.	2025-06-26 22:30:08	2025-06-26 22:30:08	139/78	88	98.6	99	56	Est eaque quaerat hic quod.	Maxime veniam ab occaecati doloribus commodi placeat delectus saepe.	2025-08-19	Velit officia officia ipsum inventore architecto.	2025-08-06	16:45	3	pending	APT11047	\N
10049	228	5	2025-08-06 13:00:00	High BP	New	Atque iste harum aut modi enim cupiditate.	2025-06-26 22:30:08	2025-06-26 22:30:08	107/71	66	100.0	98	63	Dolore quasi dignissimos suscipit.	Eaque nulla enim iste ducimus aut unde debitis repellat.	2025-08-26	Delectus eveniet excepturi debitis tenetur esse animi.	2025-08-06	13:00	3	pending	APT11048	\N
10050	204	10	2025-08-06 13:45:00	Diabetes Check	Follow-up	Aut magnam hic aperiam voluptate ipsam nulla consequatur.	2025-06-26 22:30:08	2025-06-26 22:30:08	115/73	93	98.6	100	69	Sed odit incidunt velit aliquam cum.	Quos nobis placeat eum qui rerum.	2025-08-18	Hic aliquam quis hic neque.	2025-08-06	13:45	3	pending	APT11049	\N
10051	79	5	2025-08-06 11:15:00	Cough	Emergency	Accusamus odio dolorum voluptatem unde voluptas.	2025-06-26 22:30:08	2025-06-26 22:30:08	138/62	77	99.5	98	59	Est temporibus mollitia possimus.	Mollitia maxime incidunt non facere.	2025-08-25	Rerum id quisquam pariatur officiis a.	2025-08-06	11:15	3	pending	APT11050	\N
10052	451	5	2025-08-06 16:15:00	High BP	New	Veniam maxime illo.	2025-06-26 22:30:08	2025-06-26 22:30:08	102/86	82	100.1	100	57	Ea excepturi quisquam unde cupiditate laborum ducimus.	Mollitia aperiam harum atque dolorum eius assumenda at.	2025-08-27	Quas odio reprehenderit quibusdam.	2025-08-06	16:15	3	pending	APT11051	\N
10053	5	7	2025-08-06 13:15:00	Skin Rash	Emergency	Dolores dolor inventore omnis cum.	2025-06-26 22:30:08	2025-06-26 22:30:08	104/81	99	99.2	96	60	Distinctio molestias nemo eligendi odit.	Voluptas dignissimos fuga reiciendis.	2025-08-22	Illum similique provident.	2025-08-06	13:15	3	pending	APT11052	\N
10054	233	3	2025-08-06 11:15:00	Headache	Follow-up	Repellendus rerum illo molestias voluptatum.	2025-06-26 22:30:08	2025-06-26 22:30:08	138/76	73	97.7	100	63	Veritatis temporibus repudiandae reiciendis.	Nulla ipsam alias repellat ab labore facere at natus.	2025-08-21	Accusamus nam tempora autem veritatis fugiat.	2025-08-06	11:15	3	pending	APT11053	\N
10055	347	5	2025-08-06 12:00:00	Routine Checkup	Follow-up	Exercitationem doloribus perferendis unde.	2025-06-26 22:30:08	2025-06-26 22:30:08	108/66	66	99.4	100	55	Aut sapiente laboriosam repellat omnis natus.	Hic animi earum porro vitae sequi voluptas.	2025-08-18	Voluptas quis inventore autem dicta.	2025-08-06	12:00	3	pending	APT11054	\N
10056	279	3	2025-08-06 16:45:00	Routine Checkup	OPD	Nihil voluptas explicabo quas ducimus.	2025-06-26 22:30:08	2025-06-26 22:30:08	104/81	78	97.6	98	60	Dolorem necessitatibus fugiat molestiae voluptatem.	Cupiditate similique molestias fugit laudantium unde sapiente fugit.	2025-08-23	Neque occaecati adipisci nobis quidem earum exercitationem.	2025-08-06	16:45	3	pending	APT11055	\N
10057	39	7	2025-08-07 12:00:00	Cough	Emergency	Accusantium quae aspernatur voluptate eaque quas deleniti.	2025-06-26 22:30:08	2025-06-26 22:30:08	129/74	91	99.9	95	84	Suscipit sunt culpa ea deserunt vel veritatis.	Fugiat nulla eligendi debitis id accusantium eligendi commodi ab.	2025-08-22	Dignissimos cupiditate assumenda quis maxime sunt voluptatem culpa.	2025-08-07	12:00	3	pending	APT11056	\N
10058	431	10	2025-08-07 15:45:00	Skin Rash	OPD	Quasi minus veritatis.	2025-06-26 22:30:08	2025-06-26 22:30:08	104/73	77	100.2	98	65	Ipsa illo ea et sed maiores iste.	Harum quia sunt necessitatibus deserunt.	2025-08-22	Quis omnis sit et quaerat molestiae.	2025-08-07	15:45	3	pending	APT11057	\N
10059	268	7	2025-08-07 13:00:00	Back Pain	Follow-up	Magni perspiciatis officiis iusto quis.	2025-06-26 22:30:08	2025-06-26 22:30:08	128/78	79	99.4	95	85	Atque a dignissimos molestias qui nisi.	Eaque sequi autem vitae nihil adipisci alias.	2025-09-02	Molestiae provident qui perspiciatis error accusamus corrupti.	2025-08-07	13:00	3	pending	APT11058	\N
10661	174	10	2025-09-01 11:15:00	Headache	OPD	Ex iste cum incidunt perferendis.	2025-06-26 22:30:08	2025-06-26 22:30:08	107/82	70	98.0	95	61	Repellat sequi a autem rerum laborum.	Quaerat minima unde modi illo in excepturi.	2025-09-22	Nostrum molestiae sunt quis numquam quaerat.	2025-09-01	11:15	3	pending	APT11660	\N
10060	329	7	2025-08-07 11:30:00	Headache	New	Aspernatur amet consequuntur molestiae atque.	2025-06-26 22:30:08	2025-06-26 22:30:08	130/73	69	99.1	97	68	Vero ipsam non quae nisi provident facere.	Numquam enim quas officia.	2025-08-26	Accusamus voluptatem facere nostrum laborum asperiores debitis.	2025-08-07	11:30	3	pending	APT11059	\N
10061	329	7	2025-08-07 11:15:00	Diabetes Check	Emergency	Eveniet perferendis reiciendis distinctio.	2025-06-26 22:30:08	2025-06-26 22:30:08	129/86	90	98.2	99	82	Eveniet voluptates magni esse quas.	Odio omnis porro eaque soluta quo quo quo veritatis sunt.	2025-08-20	Mollitia voluptatem porro nostrum rerum.	2025-08-07	11:15	3	pending	APT11060	\N
10062	340	6	2025-08-07 13:45:00	Diabetes Check	Emergency	Vero sed ratione esse nemo porro saepe.	2025-06-26 22:30:08	2025-06-26 22:30:08	116/70	82	100.3	95	75	Voluptatibus dolor incidunt ut.	Soluta molestiae nobis beatae pariatur optio incidunt.	2025-08-31	Nemo quae vitae fugiat provident.	2025-08-07	13:45	3	pending	APT11061	\N
10063	369	3	2025-08-07 14:15:00	Diabetes Check	Emergency	Voluptas quis quae laborum ut optio.	2025-06-26 22:30:08	2025-06-26 22:30:08	130/75	88	100.4	99	64	Enim saepe quod velit ab ea quas.	Nihil aut id explicabo reprehenderit quae id animi a dignissimos.	2025-08-21	Fugiat recusandae laboriosam sint animi eum.	2025-08-07	14:15	3	pending	APT11062	\N
10064	21	8	2025-08-07 12:15:00	Routine Checkup	Follow-up	At tempora sed similique fugiat tenetur quam adipisci.	2025-06-26 22:30:08	2025-06-26 22:30:08	123/68	81	97.6	99	64	Porro odio veniam incidunt dolores.	Rem ullam deserunt eaque dicta.	2025-09-04	Debitis sapiente eos nihil.	2025-08-07	12:15	3	pending	APT11063	\N
10065	74	10	2025-08-07 12:30:00	Skin Rash	Emergency	Expedita molestias facere quisquam.	2025-06-26 22:30:08	2025-06-26 22:30:08	127/80	73	99.5	97	78	Saepe illum ea nobis mollitia consequatur minima.	Laudantium rerum non iure deleniti delectus aspernatur dolorum.	2025-08-19	Alias iusto facere quis laborum.	2025-08-07	12:30	3	pending	APT11064	\N
10066	438	4	2025-08-07 15:15:00	Fever	Follow-up	Sequi ducimus provident molestias reiciendis.	2025-06-26 22:30:08	2025-06-26 22:30:08	114/60	92	99.4	99	63	Similique earum possimus nesciunt voluptatum ducimus in.	Beatae occaecati distinctio accusamus rem nostrum.	2025-09-02	Cum tempora nam sequi eum.	2025-08-07	15:15	3	pending	APT11065	\N
10067	77	8	2025-08-07 16:00:00	Skin Rash	New	Quae occaecati libero ex saepe voluptatem praesentium eum.	2025-06-26 22:30:08	2025-06-26 22:30:08	138/65	96	97.7	95	73	Voluptatem sequi reiciendis suscipit aliquam a et.	Voluptatem nulla delectus quo quod et eaque adipisci dicta.	2025-09-05	Harum sint facilis delectus.	2025-08-07	16:00	3	pending	APT11066	\N
10068	78	9	2025-08-07 13:00:00	Headache	OPD	Iusto quas eum numquam in sunt laborum.	2025-06-26 22:30:08	2025-06-26 22:30:08	104/87	84	99.2	100	74	Debitis quos omnis quae aliquam.	Unde saepe aliquam fugiat quas.	2025-08-23	Culpa suscipit voluptas cumque.	2025-08-07	13:00	3	pending	APT11067	\N
10069	464	3	2025-08-07 14:45:00	Headache	OPD	Saepe amet quae excepturi architecto aperiam laborum.	2025-06-26 22:30:08	2025-06-26 22:30:08	130/68	85	100.5	96	59	At corrupti vero consequatur ut explicabo culpa.	Esse non adipisci nemo eveniet consequuntur eos accusantium consequuntur labore.	2025-08-31	Exercitationem dolorum possimus cumque suscipit sint animi.	2025-08-07	14:45	3	pending	APT11068	\N
10070	144	5	2025-08-07 15:30:00	Fever	Follow-up	Aliquam fuga vel doloremque.	2025-06-26 22:30:08	2025-06-26 22:30:08	129/69	100	100.2	99	75	Deleniti nulla fugit error.	Dicta neque animi asperiores beatae iusto quos quas architecto sunt.	2025-09-05	Itaque voluptates praesentium necessitatibus aliquam.	2025-08-07	15:30	3	pending	APT11069	\N
10071	257	10	2025-08-07 15:00:00	Diabetes Check	New	Id nobis natus ex incidunt dolore deserunt.	2025-06-26 22:30:08	2025-06-26 22:30:08	137/68	69	98.6	96	81	Quisquam optio delectus sunt eos ea.	Reprehenderit quam aliquam fugit.	2025-09-05	Voluptate iure in rem.	2025-08-07	15:00	3	pending	APT11070	\N
10072	335	3	2025-08-07 14:30:00	Diabetes Check	Emergency	Nostrum voluptatum ab voluptas odit.	2025-06-26 22:30:08	2025-06-26 22:30:08	111/88	74	99.8	96	59	Occaecati sapiente harum unde.	Iste molestiae atque veritatis consequuntur quis nisi.	2025-09-04	Vitae necessitatibus omnis quidem.	2025-08-07	14:30	3	pending	APT11071	\N
10073	407	9	2025-08-07 14:30:00	Fever	OPD	Atque doloribus cum rerum ab.	2025-06-26 22:30:08	2025-06-26 22:30:08	109/85	76	100.4	95	77	Ut voluptate officia dolore.	Veritatis facilis iste corporis mollitia ipsum natus beatae libero dolorum.	2025-08-16	Quibusdam cupiditate nostrum impedit mollitia.	2025-08-07	14:30	3	pending	APT11072	\N
10074	197	8	2025-08-07 11:15:00	Headache	Follow-up	Iure laborum a optio.	2025-06-26 22:30:08	2025-06-26 22:30:08	136/72	71	98.9	95	58	Itaque similique omnis dolorem debitis qui ratione ullam.	Saepe iste voluptatum dolorum amet.	2025-08-14	Cupiditate blanditiis corporis eius officiis est.	2025-08-07	11:15	3	pending	APT11073	\N
10075	227	6	2025-08-07 16:45:00	Routine Checkup	Follow-up	Ipsum eos quae ea tempora maxime.	2025-06-26 22:30:08	2025-06-26 22:30:08	103/67	81	99.3	97	72	Illo omnis nemo repudiandae a.	Expedita nisi nostrum eligendi reiciendis odio animi blanditiis ipsum eos.	2025-08-27	Vero veritatis ipsam facilis.	2025-08-07	16:45	3	pending	APT11074	\N
10076	316	7	2025-08-07 13:15:00	Diabetes Check	New	A excepturi tempore reiciendis.	2025-06-26 22:30:08	2025-06-26 22:30:08	100/79	92	99.6	96	56	Deleniti voluptas facere dolores.	Molestias soluta ex corporis veritatis magni provident cumque deleniti.	2025-08-19	Consequatur ad iste error nemo.	2025-08-07	13:15	3	pending	APT11075	\N
10077	26	7	2025-08-08 14:00:00	High BP	Emergency	Minima sed similique et error repudiandae.	2025-06-26 22:30:08	2025-06-26 22:30:08	106/82	83	99.8	100	83	Hic error perferendis.	Alias fuga quia unde deserunt repellat harum ut delectus placeat.	2025-09-06	Beatae magni deleniti eos dolorem.	2025-08-08	14:00	3	pending	APT11076	\N
10078	474	4	2025-08-08 11:45:00	Cough	Emergency	Maxime commodi accusamus laborum voluptate ex repellat.	2025-06-26 22:30:08	2025-06-26 22:30:08	117/85	67	98.8	95	72	Voluptas quae repellendus reprehenderit laborum.	Consequatur distinctio ipsam quos totam error fuga iusto.	2025-08-27	Deserunt inventore aspernatur magnam voluptatem sunt nisi tempora.	2025-08-08	11:45	3	pending	APT11077	\N
10079	198	8	2025-08-08 13:30:00	Diabetes Check	Follow-up	Cum culpa earum ex iure ratione magnam.	2025-06-26 22:30:08	2025-06-26 22:30:08	126/61	77	98.4	97	85	Eaque doloremque quia quam deleniti.	Quis consectetur suscipit minima soluta ullam possimus.	2025-08-26	Fugit nesciunt ipsam velit fugiat.	2025-08-08	13:30	3	pending	APT11078	\N
10080	29	10	2025-08-08 11:45:00	High BP	OPD	Ex laborum vitae.	2025-06-26 22:30:08	2025-06-26 22:30:08	129/67	75	98.0	97	74	Debitis dicta pariatur iusto voluptatem repudiandae.	Dolorem autem occaecati quidem dolorem.	2025-08-29	Perspiciatis dolorum animi totam voluptates commodi.	2025-08-08	11:45	3	pending	APT11079	\N
10081	188	4	2025-08-08 16:15:00	High BP	OPD	Accusamus autem dolorum voluptatibus itaque.	2025-06-26 22:30:08	2025-06-26 22:30:08	112/69	88	99.6	100	72	Magni possimus nulla nisi impedit.	Aliquam dicta earum nihil adipisci praesentium quas nisi eveniet.	2025-08-31	Ullam ad vero beatae ut autem repellendus.	2025-08-08	16:15	3	pending	APT11080	\N
10082	180	8	2025-08-08 16:00:00	Routine Checkup	Follow-up	Vel sequi nesciunt perferendis a praesentium.	2025-06-26 22:30:08	2025-06-26 22:30:08	119/74	87	97.6	97	78	Totam doloremque libero totam officia dolores eveniet.	Voluptatem dolorem dolor fugiat magni.	2025-08-30	Debitis placeat incidunt mollitia.	2025-08-08	16:00	3	pending	APT11081	\N
10083	180	5	2025-08-08 15:30:00	Routine Checkup	Follow-up	Animi incidunt accusantium ullam reiciendis numquam.	2025-06-26 22:30:08	2025-06-26 22:30:08	114/87	71	99.4	98	62	Fuga reiciendis molestiae ratione. Odit voluptatem earum.	Temporibus sapiente repudiandae officiis eius modi laboriosam modi nesciunt.	2025-09-03	Eveniet occaecati iste ab ut.	2025-08-08	15:30	3	pending	APT11082	\N
10084	387	5	2025-08-08 15:45:00	High BP	Emergency	Consequuntur ratione consequatur rerum ut quod sit.	2025-06-26 22:30:08	2025-06-26 22:30:08	101/85	81	99.7	99	76	Sint exercitationem incidunt eius accusamus.	Fugiat sed occaecati deleniti quidem aliquid officiis.	2025-08-28	Repudiandae nulla voluptatum cum veritatis explicabo.	2025-08-08	15:45	3	pending	APT11083	\N
10085	79	7	2025-08-08 15:00:00	Skin Rash	OPD	Nemo necessitatibus dolorum adipisci quia commodi facere.	2025-06-26 22:30:08	2025-06-26 22:30:08	126/71	89	98.0	100	81	Optio adipisci veritatis praesentium.	Culpa excepturi fuga voluptas.	2025-08-28	Non esse eaque atque placeat corporis quo.	2025-08-08	15:00	3	pending	APT11084	\N
10086	456	8	2025-08-08 15:30:00	Routine Checkup	OPD	Nulla ut rem corrupti inventore cum.	2025-06-26 22:30:08	2025-06-26 22:30:08	137/63	70	98.2	100	63	Rem blanditiis cumque.	Sequi beatae pariatur magnam blanditiis vero.	2025-09-02	Nostrum non adipisci nesciunt.	2025-08-08	15:30	3	pending	APT11085	\N
10087	72	6	2025-08-08 14:00:00	Cough	Emergency	Cum blanditiis esse corporis aspernatur soluta.	2025-06-26 22:30:08	2025-06-26 22:30:08	102/89	79	99.6	97	74	Asperiores neque temporibus ex debitis.	Eligendi vel incidunt accusantium eligendi a nam culpa minus.	2025-09-02	Placeat odit fuga accusamus vitae qui at.	2025-08-08	14:00	3	pending	APT11086	\N
10088	180	4	2025-08-08 12:30:00	Skin Rash	New	Labore recusandae itaque ad minima est magni vel.	2025-06-26 22:30:08	2025-06-26 22:30:08	131/90	93	100.0	99	55	Commodi soluta consequuntur modi.	Reiciendis ex eius saepe quidem.	2025-09-02	Impedit beatae commodi adipisci fugit similique nulla.	2025-08-08	12:30	3	pending	APT11087	\N
10089	165	3	2025-08-08 12:15:00	Headache	OPD	Consequuntur dolorum minus quis.	2025-06-26 22:30:08	2025-06-26 22:30:08	101/80	71	99.0	95	66	Porro quam fugiat mollitia voluptas.	Commodi ipsum nulla eius accusamus.	2025-08-30	Occaecati ad animi odio.	2025-08-08	12:15	3	pending	APT11088	\N
10090	411	6	2025-08-08 15:30:00	Back Pain	Emergency	Consectetur magnam deserunt unde ad recusandae.	2025-06-26 22:30:08	2025-06-26 22:30:08	108/81	96	99.9	95	75	Voluptate occaecati dolore sed.	Iusto esse consequatur neque ea quo ullam nemo.	2025-08-31	Reprehenderit at quod mollitia dolore.	2025-08-08	15:30	3	pending	APT11089	\N
10091	292	10	2025-08-08 13:30:00	Routine Checkup	Emergency	In tempore ea ipsam incidunt quos.	2025-06-26 22:30:08	2025-06-26 22:30:08	100/90	81	99.4	100	62	Laudantium in consequuntur consequuntur quibusdam vero.	Natus libero sequi maxime reprehenderit ullam ex nam natus ea.	2025-08-30	Suscipit aspernatur numquam tempora.	2025-08-08	13:30	3	pending	APT11090	\N
10092	195	5	2025-08-08 12:00:00	Back Pain	Emergency	Distinctio nihil facere perferendis facilis.	2025-06-26 22:30:08	2025-06-26 22:30:08	110/80	75	99.3	96	59	Quam at quis aliquid placeat impedit.	Officiis debitis labore minus corporis.	2025-09-02	Explicabo iusto molestias debitis quae aliquam laboriosam.	2025-08-08	12:00	3	pending	APT11091	\N
10093	411	7	2025-08-08 15:15:00	Headache	Follow-up	Molestias vitae unde omnis repellendus iste vitae.	2025-06-26 22:30:08	2025-06-26 22:30:08	131/63	72	99.9	97	67	Exercitationem magni consectetur dignissimos porro.	Aperiam optio error dolorum cumque.	2025-09-01	Optio tempora facilis quae quae in officiis occaecati.	2025-08-08	15:15	3	pending	APT11092	\N
10094	20	6	2025-08-08 13:30:00	Diabetes Check	New	Vitae at quae reiciendis animi.	2025-06-26 22:30:08	2025-06-26 22:30:08	126/72	92	98.8	100	64	Aut illum harum aspernatur recusandae quasi culpa.	Impedit neque facilis illo.	2025-09-05	Quia ex quos numquam occaecati eius unde.	2025-08-08	13:30	3	pending	APT11093	\N
10095	331	3	2025-08-08 12:15:00	Skin Rash	New	Rem accusamus cum assumenda.	2025-06-26 22:30:08	2025-06-26 22:30:08	119/68	93	99.0	98	75	Voluptatum dolores incidunt aliquam.	Aperiam beatae excepturi magnam est molestiae voluptatum voluptatem ducimus dolor.	2025-08-31	Explicabo blanditiis explicabo distinctio.	2025-08-08	12:15	3	pending	APT11094	\N
10096	96	7	2025-08-08 12:30:00	Diabetes Check	OPD	Quis tempora nulla suscipit ipsum excepturi consequatur.	2025-06-26 22:30:08	2025-06-26 22:30:08	138/61	97	98.3	99	74	Officiis recusandae consequuntur pariatur vel totam.	Eligendi ullam fugit esse cumque modi.	2025-08-28	Praesentium dicta vero accusantium.	2025-08-08	12:30	3	pending	APT11095	\N
10097	357	6	2025-08-08 13:45:00	Fever	OPD	Vel nihil fugiat dolor asperiores.	2025-06-26 22:30:08	2025-06-26 22:30:08	103/78	86	98.6	97	67	Id iste quas maiores corrupti.	Optio aut excepturi architecto provident quae dolore.	2025-09-02	Est nesciunt fugit sed ipsum neque voluptatibus.	2025-08-08	13:45	3	pending	APT11096	\N
10098	185	3	2025-08-09 12:00:00	Headache	New	Dolor ea aliquid.	2025-06-26 22:30:08	2025-06-26 22:30:08	131/65	99	98.2	97	70	Explicabo atque a error. Cupiditate doloremque ullam odit.	Cupiditate mollitia neque quisquam eius aliquam officia ex ab.	2025-08-18	Unde temporibus soluta aut iusto.	2025-08-09	12:00	3	pending	APT11097	\N
10099	374	9	2025-08-09 12:45:00	High BP	New	Occaecati praesentium quia accusantium perspiciatis architecto.	2025-06-26 22:30:08	2025-06-26 22:30:08	107/71	100	99.7	99	78	Rerum unde odit ipsam incidunt omnis quas et.	Voluptatibus velit ab cupiditate expedita voluptatum ut.	2025-08-27	Facilis aliquid culpa cupiditate laboriosam dolorem deserunt illo.	2025-08-09	12:45	3	pending	APT11098	\N
10100	464	4	2025-08-09 11:15:00	High BP	Emergency	Possimus est expedita nulla eos molestias quis.	2025-06-26 22:30:08	2025-06-26 22:30:08	116/85	78	98.7	99	82	Deserunt numquam ea nostrum possimus magnam veritatis.	Ut expedita ipsam ad nihil nobis laboriosam deleniti qui magnam.	2025-08-29	Inventore et voluptas ratione.	2025-08-09	11:15	3	pending	APT11099	\N
10101	447	3	2025-08-09 16:45:00	Diabetes Check	New	Fugit quod commodi quia possimus.	2025-06-26 22:30:08	2025-06-26 22:30:08	132/74	94	97.8	100	78	Nostrum esse possimus maxime nulla.	Porro pariatur asperiores nobis nulla aperiam aut animi incidunt porro.	2025-08-30	Ullam voluptatum nulla rerum qui nulla.	2025-08-09	16:45	3	pending	APT11100	\N
10102	151	8	2025-08-09 14:45:00	Fever	OPD	Nisi veritatis nam sunt.	2025-06-26 22:30:08	2025-06-26 22:30:08	103/61	77	99.6	95	77	Incidunt voluptate molestiae quo.	Ad distinctio distinctio reprehenderit doloremque ex veritatis excepturi impedit.	2025-08-17	Repellendus libero similique omnis maxime consequatur fuga.	2025-08-09	14:45	3	pending	APT11101	\N
10103	60	10	2025-08-09 12:15:00	Headache	OPD	Quo rerum aut doloremque facilis accusantium molestiae.	2025-06-26 22:30:08	2025-06-26 22:30:08	104/76	99	99.7	98	85	Beatae sed minus nostrum nisi error.	Iure nihil quo ipsum impedit doloribus incidunt.	2025-08-25	Dicta quaerat ex deserunt dolorum neque.	2025-08-09	12:15	3	pending	APT11102	\N
10104	328	9	2025-08-09 15:15:00	Back Pain	Follow-up	Porro rerum maiores necessitatibus reprehenderit.	2025-06-26 22:30:08	2025-06-26 22:30:08	126/68	96	99.6	100	68	Aliquid cum earum id minima. Nesciunt consectetur dolor.	Nostrum ad earum odio.	2025-09-08	Praesentium iure facilis exercitationem quisquam autem minima harum.	2025-08-09	15:15	3	pending	APT11103	\N
10707	440	5	2025-09-03 14:00:00	High BP	New	Ratione provident dolorum.	2025-06-26 22:30:08	2025-06-26 22:30:08	139/78	92	99.6	96	81	Tenetur quibusdam ad eaque nostrum.	Atque laborum ut nihil soluta dolores.	2025-09-26	Suscipit voluptatem quaerat id facilis facere quisquam.	2025-09-03	14:00	3	pending	APT11706	\N
10105	169	9	2025-08-09 13:15:00	Skin Rash	New	Iste assumenda placeat autem.	2025-06-26 22:30:08	2025-06-26 22:30:08	119/74	89	99.8	100	58	Accusantium eaque amet quibusdam ut perferendis voluptas.	Earum suscipit nemo saepe saepe illum adipisci.	2025-09-07	Natus odio odit consequuntur dolore maxime architecto.	2025-08-09	13:15	3	pending	APT11104	\N
10106	439	6	2025-08-09 12:00:00	Diabetes Check	OPD	Tempore tenetur dolores unde recusandae.	2025-06-26 22:30:08	2025-06-26 22:30:08	120/84	84	98.5	95	77	Natus autem animi natus.	Officiis quibusdam neque doloribus veritatis modi autem dolores nisi magni.	2025-08-22	Occaecati dolor possimus harum itaque ex necessitatibus nisi.	2025-08-09	12:00	3	pending	APT11105	\N
10107	173	8	2025-08-09 11:15:00	Cough	Follow-up	Dolorum perferendis repudiandae asperiores dolorum.	2025-06-26 22:30:08	2025-06-26 22:30:08	104/89	86	98.6	99	72	Qui velit ipsa distinctio.	Explicabo voluptatibus accusantium officiis in voluptatibus aut maxime.	2025-09-07	Deleniti eos tempora natus natus.	2025-08-09	11:15	3	pending	APT11106	\N
10108	404	5	2025-08-09 12:30:00	Skin Rash	New	Doloribus nihil odit ab.	2025-06-26 22:30:08	2025-06-26 22:30:08	107/88	70	100.4	97	69	Laboriosam natus id. Quas quidem magnam sit cum blanditiis.	Debitis natus temporibus hic.	2025-09-03	Ullam ipsum maxime labore quos voluptate labore.	2025-08-09	12:30	3	pending	APT11107	\N
10109	45	5	2025-08-09 15:00:00	Diabetes Check	OPD	Libero exercitationem magnam ipsam perferendis laborum.	2025-06-26 22:30:08	2025-06-26 22:30:08	107/66	72	98.6	98	83	Neque ex placeat impedit beatae veritatis eveniet officiis.	Corrupti nisi ab ratione molestiae neque totam consequuntur itaque.	2025-08-24	Beatae quidem deserunt cupiditate.	2025-08-09	15:00	3	pending	APT11108	\N
10110	6	4	2025-08-09 14:45:00	Skin Rash	OPD	Consequuntur temporibus qui quis.	2025-06-26 22:30:08	2025-06-26 22:30:08	134/63	87	99.3	95	68	Numquam quasi itaque reprehenderit consequatur suscipit.	Eveniet sunt consequuntur error beatae adipisci.	2025-08-25	Pariatur dolores totam veniam officiis dolorem accusamus.	2025-08-09	14:45	3	pending	APT11109	\N
10111	403	9	2025-08-09 14:00:00	Fever	New	Nobis fuga ducimus quas harum voluptatem tempore.	2025-06-26 22:30:08	2025-06-26 22:30:08	128/68	100	98.6	96	62	Delectus quae ut voluptatem. At sint ducimus expedita.	Praesentium doloremque ut at deleniti voluptate eum quis voluptate voluptatem unde.	2025-08-27	Impedit cum corporis nisi quo explicabo.	2025-08-09	14:00	3	pending	APT11110	\N
10112	80	3	2025-08-09 16:30:00	Fever	OPD	Facilis vel enim repellendus eius.	2025-06-26 22:30:08	2025-06-26 22:30:08	102/74	100	100.1	95	59	Tempora maiores hic distinctio adipisci nemo dolor.	Laboriosam asperiores quae eos officiis aut temporibus odio sint.	2025-09-06	Soluta aliquam animi quae porro porro sint.	2025-08-09	16:30	3	pending	APT11111	\N
10113	74	10	2025-08-09 16:00:00	High BP	OPD	Soluta officia nesciunt esse consectetur delectus.	2025-06-26 22:30:08	2025-06-26 22:30:08	137/63	95	97.7	96	56	Ut rem odit esse ad vitae.	Cum doloremque fugiat deleniti temporibus ipsa.	2025-08-28	At sapiente quisquam assumenda.	2025-08-09	16:00	3	pending	APT11112	\N
10114	260	5	2025-08-09 13:15:00	Headache	Emergency	Possimus eligendi inventore ab.	2025-06-26 22:30:08	2025-06-26 22:30:08	120/65	92	99.9	100	71	Ratione nostrum fugit impedit quos.	Commodi commodi explicabo tenetur dolor molestiae illum expedita.	2025-08-26	Vitae nihil a similique fugiat adipisci.	2025-08-09	13:15	3	pending	APT11113	\N
10115	67	6	2025-08-09 16:30:00	Routine Checkup	Follow-up	Expedita illum voluptate fugit necessitatibus magnam tempore.	2025-06-26 22:30:08	2025-06-26 22:30:08	138/61	98	98.3	97	78	Repellendus ipsum similique consectetur.	Voluptatibus ut impedit voluptatem nesciunt repellendus beatae porro rem ab tenetur.	2025-09-02	Aspernatur porro reprehenderit fugit neque eaque.	2025-08-09	16:30	3	pending	APT11114	\N
10116	124	4	2025-08-09 15:15:00	High BP	Emergency	A voluptas quisquam dolores officia optio.	2025-06-26 22:30:08	2025-06-26 22:30:08	108/66	69	99.8	97	57	Iure minus ex accusamus incidunt qui.	Quibusdam id provident itaque modi ut iusto.	2025-09-06	Quis aperiam aut possimus tenetur ullam ducimus reprehenderit.	2025-08-09	15:15	3	pending	APT11115	\N
10117	482	3	2025-08-09 13:15:00	Back Pain	Emergency	Esse quasi illo labore.	2025-06-26 22:30:08	2025-06-26 22:30:08	137/90	95	100.2	100	84	Sed eum sunt sed dicta fuga quasi. Est error quam amet.	Nihil exercitationem inventore magni modi magni corrupti.	2025-08-26	Nihil ratione vel consequatur porro quas voluptatem odit.	2025-08-09	13:15	3	pending	APT11116	\N
10118	127	8	2025-08-09 12:30:00	Back Pain	New	Rem harum delectus nesciunt.	2025-06-26 22:30:08	2025-06-26 22:30:08	120/71	96	98.5	99	75	Sint nam vel itaque. Eaque omnis id iure delectus fugit.	Officia laboriosam accusantium libero aspernatur nobis exercitationem aut.	2025-09-02	Ipsum facilis ratione eligendi consequatur aspernatur perferendis voluptatum.	2025-08-09	12:30	3	pending	APT11117	\N
10119	273	4	2025-08-09 16:45:00	Headache	New	Repellat corrupti repellendus reiciendis debitis.	2025-06-26 22:30:08	2025-06-26 22:30:08	136/72	72	100.0	99	55	Dolorem asperiores doloremque libero quibusdam.	Odio eum modi vero.	2025-08-27	Officiis quaerat tempora distinctio rem alias sit suscipit.	2025-08-09	16:45	3	pending	APT11118	\N
10120	49	7	2025-08-09 13:30:00	Cough	OPD	Repellendus saepe quas impedit.	2025-06-26 22:30:08	2025-06-26 22:30:08	118/79	72	97.7	100	67	Eligendi sunt tenetur ut distinctio.	Earum a alias maxime accusamus nesciunt quibusdam voluptatibus sed quod.	2025-08-25	Provident molestias veniam facere.	2025-08-09	13:30	3	pending	APT11119	\N
10121	47	6	2025-08-09 16:30:00	High BP	Emergency	Ut quo quisquam maxime cupiditate ratione.	2025-06-26 22:30:08	2025-06-26 22:30:08	124/85	94	98.4	95	59	Sapiente ab quod eos dicta saepe.	Porro error alias deserunt corrupti itaque aspernatur.	2025-08-22	Architecto soluta ipsum laborum fugiat consequatur.	2025-08-09	16:30	3	pending	APT11120	\N
10122	246	10	2025-08-09 11:00:00	Headache	Emergency	Fugiat repudiandae eum.	2025-06-26 22:30:08	2025-06-26 22:30:08	136/84	72	98.2	100	68	Eius consequuntur sed. Id itaque veniam unde magnam.	Autem ea expedita nemo eveniet accusamus iusto.	2025-08-31	Nostrum fugit deleniti voluptas.	2025-08-09	11:00	3	pending	APT11121	\N
10123	380	7	2025-08-09 11:00:00	Diabetes Check	Follow-up	Earum id deleniti officiis praesentium fugiat.	2025-06-26 22:30:08	2025-06-26 22:30:08	120/76	90	99.4	100	68	Unde expedita praesentium. Quasi adipisci esse natus.	Corrupti possimus eum eum repellat deleniti totam sint.	2025-08-22	Tempora dolores possimus quis.	2025-08-09	11:00	3	pending	APT11122	\N
10124	18	8	2025-08-09 11:15:00	Diabetes Check	Emergency	Repellendus possimus ea enim minus aliquam consectetur.	2025-06-26 22:30:08	2025-06-26 22:30:08	123/62	79	97.6	97	61	Recusandae voluptatum corporis fugit laborum.	Explicabo dolor aspernatur error dolorem aut accusantium repellat.	2025-08-18	Minus nemo suscipit sit doloribus inventore id.	2025-08-09	11:15	3	pending	APT11123	\N
10125	3	5	2025-08-10 15:00:00	High BP	OPD	Architecto consequuntur facilis inventore ut.	2025-06-26 22:30:08	2025-06-26 22:30:08	101/77	68	98.8	98	79	Iste cumque recusandae similique nemo atque.	At nisi provident exercitationem ducimus ipsa numquam soluta quibusdam.	2025-09-04	Iusto sit dolorum eum dignissimos vel sequi.	2025-08-10	15:00	3	pending	APT11124	\N
10126	208	9	2025-08-10 14:45:00	Routine Checkup	OPD	Aspernatur repudiandae alias repudiandae autem.	2025-06-26 22:30:08	2025-06-26 22:30:08	138/80	100	99.6	95	63	Quas eaque eos illum incidunt expedita.	Doloribus culpa nisi hic animi.	2025-08-23	Ea quo dignissimos eveniet iure totam aliquid est.	2025-08-10	14:45	3	pending	APT11125	\N
10127	311	5	2025-08-10 15:15:00	Diabetes Check	New	Corrupti fugiat id ullam suscipit quos.	2025-06-26 22:30:08	2025-06-26 22:30:08	104/82	65	99.8	98	59	Repellendus nulla ullam odit rem earum doloribus ipsum.	Accusantium facilis nostrum totam rerum aspernatur eius alias facere.	2025-09-04	Cum iure blanditiis veniam accusantium impedit.	2025-08-10	15:15	3	pending	APT11126	\N
10128	349	6	2025-08-10 15:00:00	Diabetes Check	New	Aliquam quas ut ea eligendi eveniet perferendis possimus.	2025-06-26 22:30:08	2025-06-26 22:30:08	136/88	65	99.8	96	68	Molestias eaque voluptate unde ipsa dolorum.	Magnam quasi esse voluptates minus enim.	2025-08-31	Iure qui non tenetur provident ipsa saepe corporis.	2025-08-10	15:00	3	pending	APT11127	\N
10129	162	10	2025-08-10 12:45:00	Diabetes Check	OPD	Totam at occaecati occaecati tenetur dolore aperiam.	2025-06-26 22:30:08	2025-06-26 22:30:08	129/76	73	100.0	97	73	Doloribus quod quos laudantium dignissimos ut.	Iusto incidunt corporis consequuntur eveniet.	2025-09-02	Optio vitae praesentium expedita repudiandae.	2025-08-10	12:45	3	pending	APT11128	\N
10130	470	10	2025-08-10 12:15:00	Skin Rash	OPD	Excepturi ipsam ratione esse quo nulla.	2025-06-26 22:30:08	2025-06-26 22:30:08	101/82	94	98.1	97	66	Accusantium pariatur corrupti tenetur commodi.	Id adipisci molestiae laboriosam nam.	2025-08-29	Minima doloremque voluptatibus cum molestias perferendis ratione.	2025-08-10	12:15	3	pending	APT11129	\N
10131	468	10	2025-08-10 16:15:00	Skin Rash	Follow-up	Laboriosam sed accusamus tenetur eius ullam.	2025-06-26 22:30:08	2025-06-26 22:30:08	135/85	92	100.2	98	59	Optio reprehenderit placeat nam saepe.	Consequatur unde labore pariatur adipisci laborum omnis velit.	2025-08-17	Ea occaecati facilis.	2025-08-10	16:15	3	pending	APT11130	\N
10132	165	8	2025-08-10 13:15:00	Headache	OPD	Dolor accusamus aliquam enim aspernatur voluptas.	2025-06-26 22:30:08	2025-06-26 22:30:08	108/86	98	98.8	98	69	Nulla voluptatem error officia.	Veritatis quis blanditiis ratione saepe.	2025-09-03	Officiis pariatur facere laudantium cumque ducimus reiciendis error.	2025-08-10	13:15	3	pending	APT11131	\N
10133	392	6	2025-08-10 16:30:00	Cough	OPD	Molestiae cupiditate dolor a nostrum mollitia.	2025-06-26 22:30:08	2025-06-26 22:30:08	128/60	98	98.6	98	80	Eum praesentium iure quidem autem asperiores.	Voluptates libero dolorem officiis atque ratione nisi.	2025-09-07	Blanditiis incidunt veniam fugiat magnam alias ratione quia.	2025-08-10	16:30	3	pending	APT11132	\N
10134	186	6	2025-08-10 16:00:00	Skin Rash	OPD	Maiores dolor consequatur in aut.	2025-06-26 22:30:08	2025-06-26 22:30:08	121/73	80	98.9	95	63	Itaque officia molestiae quo minus consequatur porro.	Reprehenderit error quae exercitationem consequuntur voluptas deleniti consequuntur.	2025-09-06	Possimus facere optio aspernatur nihil excepturi.	2025-08-10	16:00	3	pending	APT11133	\N
10135	284	7	2025-08-10 15:15:00	Fever	OPD	Commodi exercitationem harum.	2025-06-26 22:30:08	2025-06-26 22:30:08	107/63	100	100.0	98	68	Ipsa aliquam quia. Ipsam cumque nesciunt a sed.	Architecto labore hic illum modi esse neque doloremque.	2025-08-21	Atque illo ea quibusdam similique vero placeat.	2025-08-10	15:15	3	pending	APT11134	\N
10136	130	5	2025-08-10 15:00:00	Cough	New	Cum officia vero delectus itaque alias.	2025-06-26 22:30:08	2025-06-26 22:30:08	125/86	96	98.3	96	56	Occaecati id reprehenderit est tempora fugiat vel.	Hic enim veniam ratione minus tenetur.	2025-08-30	Tempora eos debitis.	2025-08-10	15:00	3	pending	APT11135	\N
10137	488	9	2025-08-10 16:00:00	Headache	Emergency	Modi nemo sunt repudiandae consequuntur ab.	2025-06-26 22:30:08	2025-06-26 22:30:08	105/90	65	100.4	100	85	Itaque voluptatem assumenda dolorum provident.	Ea aliquid odit tempore voluptatum quae totam itaque facilis voluptates odit.	2025-08-19	Neque sed et harum alias.	2025-08-10	16:00	3	pending	APT11136	\N
10138	283	4	2025-08-10 15:00:00	Skin Rash	Emergency	Unde magnam voluptate.	2025-06-26 22:30:08	2025-06-26 22:30:08	111/83	74	98.7	97	70	Cum facere fugit consectetur.	Voluptate commodi reprehenderit beatae nostrum accusantium ducimus sunt reprehenderit ab.	2025-08-18	Reiciendis explicabo perferendis aliquid minus ipsam.	2025-08-10	15:00	3	pending	APT11137	\N
10139	320	3	2025-08-10 16:15:00	Diabetes Check	New	Voluptatibus numquam aliquid mollitia quis suscipit.	2025-06-26 22:30:08	2025-06-26 22:30:08	134/61	94	97.6	98	85	Nesciunt quasi dolor mollitia adipisci.	Natus delectus quo vel.	2025-08-20	Itaque odio ea perspiciatis hic nemo.	2025-08-10	16:15	3	pending	APT11138	\N
10140	483	7	2025-08-10 12:15:00	High BP	Emergency	Deleniti ea quidem reprehenderit voluptatem amet voluptas at.	2025-06-26 22:30:08	2025-06-26 22:30:08	111/70	91	97.5	97	64	Perspiciatis ab nesciunt aut nisi veritatis.	Aperiam corporis eos atque incidunt quod ullam cumque a aperiam provident.	2025-09-02	Rerum accusantium iste.	2025-08-10	12:15	3	pending	APT11139	\N
10141	373	10	2025-08-10 13:00:00	Skin Rash	OPD	Laudantium architecto modi culpa perspiciatis id sequi.	2025-06-26 22:30:08	2025-06-26 22:30:08	106/78	96	99.4	96	63	Neque saepe saepe odit. Sapiente reprehenderit soluta at.	Voluptatibus quia minus saepe laborum exercitationem.	2025-08-29	Assumenda non quasi enim corrupti.	2025-08-10	13:00	3	pending	APT11140	\N
10142	339	8	2025-08-10 16:45:00	Diabetes Check	Follow-up	Officiis vel nihil sunt.	2025-06-26 22:30:08	2025-06-26 22:30:08	113/79	73	97.7	97	60	Harum doloremque tempora culpa beatae earum doloribus.	Quisquam quod voluptatem inventore aperiam tempora quo nesciunt.	2025-09-02	Facere officiis at non ducimus.	2025-08-10	16:45	3	pending	APT11141	\N
10143	239	4	2025-08-10 13:45:00	Routine Checkup	Follow-up	Dolores atque impedit consequatur facilis veritatis.	2025-06-26 22:30:08	2025-06-26 22:30:08	104/70	97	100.1	98	79	Occaecati voluptatem labore occaecati nam.	Delectus repellat est quo nisi porro esse voluptas.	2025-08-30	Repellat expedita quasi rem dicta.	2025-08-10	13:45	3	pending	APT11142	\N
10144	340	7	2025-08-10 13:00:00	Cough	New	Ullam velit veritatis placeat.	2025-06-26 22:30:08	2025-06-26 22:30:08	129/86	96	98.4	99	69	Eius expedita doloribus dolore.	Quo tempora ut quos facere quas nobis voluptatibus alias sed.	2025-08-17	Architecto quia fuga nisi accusantium officia.	2025-08-10	13:00	3	pending	APT11143	\N
10145	72	7	2025-08-10 12:00:00	Skin Rash	New	Vero qui doloremque saepe.	2025-06-26 22:30:08	2025-06-26 22:30:08	140/87	96	99.4	96	76	Ipsam autem maxime dolor quos.	Eveniet itaque laudantium nam magnam tempora voluptate architecto in.	2025-09-04	Nemo facere expedita at aspernatur sint eius.	2025-08-10	12:00	3	pending	APT11144	\N
10146	340	7	2025-08-10 11:00:00	Routine Checkup	New	At temporibus non ea assumenda amet pariatur.	2025-06-26 22:30:08	2025-06-26 22:30:08	103/62	91	99.7	98	62	Adipisci veritatis tempore quas. Animi rem quas ad quasi.	Eaque hic repellendus laudantium provident eligendi blanditiis placeat officiis quis mollitia.	2025-09-04	Molestias atque natus nihil.	2025-08-10	11:00	3	pending	APT11145	\N
10147	105	4	2025-08-10 15:45:00	Fever	Follow-up	Debitis repellendus deleniti odit nesciunt voluptates eius.	2025-06-26 22:30:08	2025-06-26 22:30:08	106/80	92	98.5	97	75	Quos quaerat occaecati numquam officiis reiciendis saepe.	Consequatur in impedit ipsum dolores expedita alias.	2025-09-06	Laborum ipsum dolor totam debitis.	2025-08-10	15:45	3	pending	APT11146	\N
10148	107	8	2025-08-10 13:00:00	Skin Rash	Emergency	Porro veniam cumque nostrum.	2025-06-26 22:30:08	2025-06-26 22:30:08	103/74	89	98.6	96	57	Qui aliquid mollitia perferendis itaque.	Aperiam ipsum inventore optio veritatis quos voluptas.	2025-09-07	Labore repellendus tempore officiis.	2025-08-10	13:00	3	pending	APT11147	\N
10149	250	6	2025-08-10 12:30:00	Back Pain	New	Nostrum consectetur dolorem eaque.	2025-06-26 22:30:08	2025-06-26 22:30:08	100/83	87	98.6	99	84	Minima dolores magnam officiis.	Assumenda odio adipisci perferendis earum.	2025-09-05	Beatae corporis molestiae aperiam harum ipsam quisquam.	2025-08-10	12:30	3	pending	APT11148	\N
10150	122	3	2025-08-11 15:45:00	Fever	Follow-up	Consequatur iure velit velit ad possimus officia provident.	2025-06-26 22:30:08	2025-06-26 22:30:08	111/83	77	98.9	99	66	Tempora repellendus ex repudiandae consequuntur architecto.	Fugiat eos velit similique officia quae ipsam vero.	2025-08-30	Exercitationem recusandae nihil occaecati aut.	2025-08-11	15:45	3	pending	APT11149	\N
10151	425	7	2025-08-11 12:45:00	Fever	New	Ullam inventore esse unde laborum enim et.	2025-06-26 22:30:08	2025-06-26 22:30:08	113/64	89	99.3	99	85	Aperiam ad sequi qui architecto maiores officia.	Nemo non omnis iure veniam sequi officiis ipsum laboriosam rerum.	2025-09-01	Sit aperiam dolores fugiat maxime quaerat cum.	2025-08-11	12:45	3	pending	APT11150	\N
10152	476	8	2025-08-11 13:00:00	Back Pain	OPD	Ut magnam ipsam quia reprehenderit.	2025-06-26 22:30:08	2025-06-26 22:30:08	121/64	79	99.0	98	69	Cumque ratione porro placeat.	Sequi quam voluptatum officia odit totam id.	2025-08-20	Itaque velit corrupti deleniti explicabo vero.	2025-08-11	13:00	3	pending	APT11151	\N
10153	5	7	2025-08-11 11:45:00	Skin Rash	OPD	Ipsum molestias voluptatem dicta ratione nobis aliquid.	2025-06-26 22:30:08	2025-06-26 22:30:08	123/64	95	98.0	98	60	Tempore architecto sunt ut quisquam enim.	Error iste quia esse ut ex odio dolor corporis.	2025-08-27	Dolor eligendi aspernatur maxime soluta.	2025-08-11	11:45	3	pending	APT11152	\N
10154	297	7	2025-08-11 14:45:00	Fever	New	Suscipit nemo similique expedita repellendus facilis aliquam.	2025-06-26 22:30:08	2025-06-26 22:30:08	121/75	73	98.9	99	60	Veritatis deserunt ipsam doloribus culpa praesentium.	Ad tempore tenetur neque nesciunt blanditiis eius distinctio nihil eaque.	2025-08-28	Necessitatibus alias sint similique provident itaque.	2025-08-11	14:45	3	pending	APT11153	\N
10155	367	3	2025-08-11 11:30:00	Back Pain	OPD	Ullam mollitia voluptatibus suscipit perspiciatis ipsa.	2025-06-26 22:30:08	2025-06-26 22:30:08	120/62	71	99.8	99	55	Maxime incidunt vitae ipsa sed. Nisi iure expedita ducimus.	Porro sint exercitationem repudiandae tempora.	2025-09-10	Corrupti nesciunt quibusdam.	2025-08-11	11:30	3	pending	APT11154	\N
10156	136	6	2025-08-11 16:15:00	High BP	Follow-up	Repellendus quis minima totam perferendis qui dolor autem.	2025-06-26 22:30:08	2025-06-26 22:30:08	125/84	94	100.1	99	74	Consequatur eos nihil eveniet deserunt voluptates mollitia.	Quam quas temporibus voluptates atque labore ab similique exercitationem.	2025-08-22	Illo libero dicta adipisci recusandae.	2025-08-11	16:15	3	pending	APT11155	\N
10157	254	5	2025-08-11 14:30:00	Cough	Follow-up	Pariatur repellat odit doloremque.	2025-06-26 22:30:08	2025-06-26 22:30:08	111/63	73	99.6	95	69	Exercitationem quia incidunt cumque. Nam quam error minima.	Provident praesentium commodi harum vero quia aliquam dicta ut explicabo earum.	2025-08-27	Labore explicabo quisquam mollitia tempore quae ipsa.	2025-08-11	14:30	3	pending	APT11156	\N
10158	264	3	2025-08-11 16:45:00	High BP	New	Iste quisquam quas ipsam natus.	2025-06-26 22:30:08	2025-06-26 22:30:08	134/86	81	97.7	97	62	Illum consequuntur beatae deleniti totam.	Numquam tenetur quas voluptatum sint ea nesciunt maiores et officia.	2025-09-03	Quibusdam enim quam.	2025-08-11	16:45	3	pending	APT11157	\N
10159	113	3	2025-08-11 14:00:00	Diabetes Check	Emergency	Magni fuga quae aliquam animi atque.	2025-06-26 22:30:08	2025-06-26 22:30:08	101/90	96	100.3	99	71	Laudantium nisi cum. Nemo optio qui animi fugiat quia quas.	Saepe molestias inventore laborum eius eaque ex libero officia sit.	2025-09-02	Sit eligendi atque suscipit magnam error delectus.	2025-08-11	14:00	3	pending	APT11158	\N
10160	258	7	2025-08-11 11:45:00	High BP	New	Mollitia iusto repudiandae.	2025-06-26 22:30:08	2025-06-26 22:30:08	126/82	86	99.0	97	75	Esse quos quam ab quaerat. Officia enim natus dolorum.	Cumque ut quis ratione dolore assumenda mollitia.	2025-08-31	Quidem doloremque reiciendis perferendis nam.	2025-08-11	11:45	3	pending	APT11159	\N
10161	370	4	2025-08-11 12:45:00	Headache	Follow-up	Accusamus debitis fuga sequi quia consectetur optio.	2025-06-26 22:30:08	2025-06-26 22:30:08	136/62	80	98.6	97	78	Consequuntur alias maxime rerum nobis ea ab.	A quasi deserunt rerum architecto occaecati et nobis voluptatem.	2025-09-08	Debitis atque necessitatibus.	2025-08-11	12:45	3	pending	APT11160	\N
10162	419	3	2025-08-11 13:30:00	High BP	OPD	Culpa dignissimos dolorum voluptatum.	2025-06-26 22:30:08	2025-06-26 22:30:08	136/69	97	99.7	97	56	Nulla commodi temporibus esse alias.	Veritatis minus sed rerum accusantium ut voluptates quaerat dignissimos ipsam.	2025-08-28	Impedit tempora necessitatibus accusantium molestiae in.	2025-08-11	13:30	3	pending	APT11161	\N
10163	369	8	2025-08-11 12:30:00	High BP	Follow-up	Fuga quod id dignissimos ex accusantium.	2025-06-26 22:30:08	2025-06-26 22:30:08	110/80	93	97.7	100	63	Laudantium minima expedita unde.	Impedit adipisci maiores laboriosam aliquid temporibus deleniti porro ea ducimus.	2025-08-31	Hic ipsam nobis.	2025-08-11	12:30	3	pending	APT11162	\N
10164	364	9	2025-08-11 13:45:00	Routine Checkup	New	Perferendis repudiandae et assumenda.	2025-06-26 22:30:08	2025-06-26 22:30:08	127/85	97	99.7	95	75	Quisquam sequi tempore corporis.	Molestiae tenetur placeat voluptate eos officiis quas repellendus commodi natus consequuntur.	2025-09-08	Hic sequi tenetur incidunt sint architecto asperiores provident.	2025-08-11	13:45	3	pending	APT11163	\N
10165	70	7	2025-08-11 13:30:00	Diabetes Check	Emergency	Vel eligendi alias.	2025-06-26 22:30:08	2025-06-26 22:30:08	107/80	66	98.8	98	71	Minima vitae incidunt veritatis repellat.	A provident totam maiores tenetur dolor doloribus vitae.	2025-09-10	Odio corrupti nam.	2025-08-11	13:30	3	pending	APT11164	\N
10166	272	6	2025-08-11 12:30:00	Skin Rash	New	Modi voluptatum dolorem at molestias natus exercitationem debitis.	2025-06-26 22:30:08	2025-06-26 22:30:08	122/76	67	98.0	95	74	Deserunt magnam ad.	Voluptatem perferendis velit voluptatum tempore consequatur commodi exercitationem tenetur voluptas.	2025-08-31	Facere necessitatibus molestiae et aliquid.	2025-08-11	12:30	3	pending	APT11165	\N
10167	77	9	2025-08-11 14:45:00	Fever	Follow-up	Esse possimus nulla ullam.	2025-06-26 22:30:08	2025-06-26 22:30:08	118/75	66	99.4	97	60	Maxime autem eum quisquam consectetur.	Non quibusdam quasi exercitationem deserunt.	2025-08-29	Consequuntur consectetur cumque libero non provident maiores.	2025-08-11	14:45	3	pending	APT11166	\N
10168	120	3	2025-08-11 16:00:00	Back Pain	OPD	Sed quam quibusdam accusantium.	2025-06-26 22:30:08	2025-06-26 22:30:08	138/62	93	99.8	100	63	Velit excepturi facilis numquam ab quos suscipit dolore.	Deserunt temporibus quos est odit doloremque.	2025-09-04	Cupiditate vero adipisci ea sapiente mollitia perspiciatis.	2025-08-11	16:00	3	pending	APT11167	\N
10169	90	7	2025-08-11 15:15:00	Headache	New	Enim iusto dicta beatae similique velit.	2025-06-26 22:30:08	2025-06-26 22:30:08	132/82	83	98.4	97	60	Quibusdam repellat asperiores.	Autem vero fugiat delectus inventore minus voluptate ad laborum dolor.	2025-08-19	Quos nam impedit similique vitae velit.	2025-08-11	15:15	3	pending	APT11168	\N
10170	136	3	2025-08-11 14:00:00	Skin Rash	Emergency	Sed atque natus voluptates voluptates.	2025-06-26 22:30:08	2025-06-26 22:30:08	105/61	96	98.6	100	77	Neque deleniti incidunt odio porro nemo nam unde.	Dolore expedita distinctio recusandae amet ipsa reiciendis corrupti minus expedita.	2025-09-09	Illum officiis veritatis explicabo reprehenderit.	2025-08-11	14:00	3	pending	APT11169	\N
10171	482	4	2025-08-11 15:00:00	Back Pain	New	Quia omnis deleniti perspiciatis veritatis.	2025-06-26 22:30:08	2025-06-26 22:30:08	132/74	100	98.1	100	69	Occaecati accusamus laudantium culpa in quidem.	Cupiditate hic nam beatae nisi.	2025-09-04	Quam reiciendis et nostrum saepe.	2025-08-11	15:00	3	pending	APT11170	\N
10172	324	10	2025-08-12 16:30:00	Cough	New	In architecto consequuntur dolorem neque cum a.	2025-06-26 22:30:08	2025-06-26 22:30:08	140/72	87	98.7	97	75	Libero illo cum eaque blanditiis.	Officiis expedita consectetur dignissimos incidunt ipsum incidunt earum provident aperiam.	2025-08-22	Labore voluptatem sed error corrupti mollitia ipsum.	2025-08-12	16:30	3	pending	APT11171	\N
10173	415	6	2025-08-12 16:30:00	Skin Rash	Follow-up	Assumenda asperiores inventore sint aperiam ullam.	2025-06-26 22:30:08	2025-06-26 22:30:08	140/88	70	98.4	100	69	Nesciunt fuga eos quam saepe illum fuga.	Cum iste voluptatum aliquid tempora odit dicta assumenda ab quia.	2025-09-03	Labore libero cupiditate.	2025-08-12	16:30	3	pending	APT11172	\N
10174	402	3	2025-08-12 12:00:00	Diabetes Check	New	Maiores non voluptate ex.	2025-06-26 22:30:08	2025-06-26 22:30:08	113/80	65	98.5	98	83	Dolorum veniam dolorem vero.	Doloremque excepturi at pariatur optio.	2025-09-10	Illum labore dolores fugiat culpa.	2025-08-12	12:00	3	pending	APT11173	\N
10175	430	6	2025-08-12 14:30:00	Headache	Emergency	Eos qui consectetur delectus maiores ex omnis.	2025-06-26 22:30:08	2025-06-26 22:30:08	104/87	71	98.3	95	78	Nemo fugit molestiae et laboriosam.	Dignissimos iusto quisquam nulla minima neque similique suscipit expedita.	2025-09-01	Excepturi veritatis perferendis perspiciatis adipisci.	2025-08-12	14:30	3	pending	APT11174	\N
10176	372	10	2025-08-12 11:30:00	High BP	Follow-up	Dicta nihil voluptate.	2025-06-26 22:30:08	2025-06-26 22:30:08	112/78	91	99.1	98	74	Sunt adipisci similique amet.	Repellendus ullam dolore id deserunt.	2025-09-10	Ducimus voluptates quia aperiam nisi repudiandae optio.	2025-08-12	11:30	3	pending	APT11175	\N
10177	454	4	2025-08-12 14:00:00	Diabetes Check	OPD	Nisi maxime quam similique.	2025-06-26 22:30:08	2025-06-26 22:30:08	124/79	91	100.4	99	58	Vel explicabo recusandae adipisci cum facere.	Neque deserunt dolorum molestiae dolores dolore numquam cupiditate.	2025-08-20	Dicta unde ipsa omnis.	2025-08-12	14:00	3	pending	APT11176	\N
10178	359	4	2025-08-12 13:45:00	Skin Rash	OPD	Vel eum repellat architecto similique earum itaque.	2025-06-26 22:30:08	2025-06-26 22:30:08	112/70	67	98.1	98	64	Deserunt minus dolore sapiente neque debitis ab odit.	Animi exercitationem doloribus unde eum perspiciatis.	2025-09-11	Sapiente nostrum totam tempora esse natus.	2025-08-12	13:45	3	pending	APT11177	\N
10179	352	9	2025-08-12 13:00:00	Routine Checkup	Emergency	At iure esse minima quidem eius sed.	2025-06-26 22:30:08	2025-06-26 22:30:08	121/80	66	98.5	95	69	Esse dignissimos amet quasi ratione sequi.	Voluptatibus dignissimos nobis praesentium laboriosam eum excepturi accusantium voluptate tempora.	2025-08-20	Nam voluptatem animi veniam placeat nam.	2025-08-12	13:00	3	pending	APT11178	\N
10180	178	7	2025-08-12 16:30:00	Headache	OPD	Dolor dolorem modi expedita quis hic quisquam.	2025-06-26 22:30:08	2025-06-26 22:30:08	136/65	87	100.2	96	64	Vero porro deleniti quibusdam atque qui tenetur.	Eaque ab blanditiis sed quaerat fugit numquam perferendis rem esse.	2025-08-25	Necessitatibus odit corporis atque repellendus sint totam.	2025-08-12	16:30	3	pending	APT11179	\N
10181	247	3	2025-08-12 15:45:00	Diabetes Check	Follow-up	Perspiciatis fugiat laudantium placeat nostrum.	2025-06-26 22:30:08	2025-06-26 22:30:08	121/84	80	99.9	99	61	Vitae numquam reiciendis quidem esse maiores.	Deleniti dolore pariatur in earum.	2025-08-25	Saepe ea ipsam voluptates omnis.	2025-08-12	15:45	3	pending	APT11180	\N
10182	208	9	2025-08-12 13:15:00	Fever	OPD	Expedita officia qui iusto optio officiis.	2025-06-26 22:30:08	2025-06-26 22:30:08	100/61	97	100.0	96	66	Nostrum cupiditate dolore.	Modi ut incidunt et accusamus.	2025-08-31	Quibusdam ipsam aliquam quod sequi quam.	2025-08-12	13:15	3	pending	APT11181	\N
10183	90	9	2025-08-12 14:30:00	High BP	Follow-up	Ab dolorem rem temporibus.	2025-06-26 22:30:08	2025-06-26 22:30:08	129/61	84	98.0	100	85	Placeat quos nostrum nihil assumenda ex.	Placeat inventore aperiam magni consequatur minus asperiores corporis quibusdam iusto.	2025-09-11	Laudantium quisquam voluptas qui reprehenderit necessitatibus ducimus.	2025-08-12	14:30	3	pending	APT11182	\N
10184	224	3	2025-08-12 11:30:00	Cough	OPD	Voluptatem perferendis tenetur rem unde iste soluta.	2025-06-26 22:30:08	2025-06-26 22:30:08	110/82	91	98.1	100	64	Repellat alias unde illum molestiae nobis.	Commodi sequi fugit amet quam laboriosam beatae labore.	2025-08-29	Natus eos molestiae id voluptates laudantium.	2025-08-12	11:30	3	pending	APT11183	\N
10185	295	9	2025-08-12 16:15:00	Diabetes Check	Emergency	Soluta animi molestias magni et.	2025-06-26 22:30:08	2025-06-26 22:30:08	117/74	89	97.9	95	61	Pariatur mollitia culpa eum cum aliquid nisi.	Exercitationem in eius reprehenderit commodi exercitationem est.	2025-08-30	Amet voluptate beatae iste modi iste.	2025-08-12	16:15	3	pending	APT11184	\N
10186	450	4	2025-08-12 12:00:00	Diabetes Check	New	Ipsum facere dolores consequatur tempore.	2025-06-26 22:30:08	2025-06-26 22:30:08	138/70	96	100.5	96	83	Minus veritatis doloremque doloremque ipsam.	Eos aspernatur laborum sunt atque enim voluptatibus asperiores nisi eius.	2025-09-05	Veniam fugiat illum nihil est quasi quia aut.	2025-08-12	12:00	3	pending	APT11185	\N
10187	15	3	2025-08-12 15:30:00	Headache	New	Et quaerat pariatur nemo.	2025-06-26 22:30:08	2025-06-26 22:30:08	121/66	80	98.4	99	56	Itaque accusamus atque exercitationem consectetur eaque.	Deleniti esse esse commodi ab maiores cumque ratione culpa.	2025-08-23	Voluptates iste consequuntur corrupti iste.	2025-08-12	15:30	3	pending	APT11186	\N
10188	411	7	2025-08-12 14:00:00	Cough	OPD	Non aliquam fuga enim autem sunt reiciendis.	2025-06-26 22:30:08	2025-06-26 22:30:08	126/63	89	99.8	96	58	Error magnam mollitia repellat numquam eum dicta.	Saepe perspiciatis velit officiis inventore.	2025-09-01	Dicta autem repellat ipsum ipsum.	2025-08-12	14:00	3	pending	APT11187	\N
10189	425	5	2025-08-12 12:30:00	Skin Rash	New	Maxime perspiciatis est error.	2025-06-26 22:30:08	2025-06-26 22:30:08	125/84	93	99.2	96	78	Quasi veritatis asperiores quia quisquam occaecati maiores.	Voluptatum nam impedit mollitia reiciendis.	2025-09-05	Ipsum perferendis quibusdam modi odio repudiandae dolore.	2025-08-12	12:30	3	pending	APT11188	\N
10190	2	9	2025-08-12 11:00:00	Back Pain	New	Possimus sequi nobis autem quisquam aperiam.	2025-06-26 22:30:08	2025-06-26 22:30:08	127/77	85	99.7	96	62	Suscipit dignissimos possimus esse dolore itaque.	Ullam sed illum quos sapiente.	2025-08-25	Nostrum quae molestias maxime quam.	2025-08-12	11:00	3	pending	APT11189	\N
10191	322	6	2025-08-12 11:15:00	Fever	Follow-up	Ad accusantium consequatur sunt.	2025-06-26 22:30:08	2025-06-26 22:30:08	138/61	88	100.2	99	57	Pariatur quasi cum nulla tenetur iure est.	Ullam nemo accusantium aspernatur molestiae exercitationem repudiandae veniam cum debitis.	2025-09-08	Autem aperiam totam cumque unde architecto.	2025-08-12	11:15	3	pending	APT11190	\N
10192	91	7	2025-08-12 16:00:00	Headache	OPD	Ea unde nisi ullam officiis totam voluptates.	2025-06-26 22:30:08	2025-06-26 22:30:08	126/79	83	99.1	95	78	Laboriosam dolorum dolorum sit quae repellat.	Sunt ratione dolorem hic molestiae.	2025-08-30	Deleniti ex ipsa necessitatibus.	2025-08-12	16:00	3	pending	APT11191	\N
10193	355	6	2025-08-12 12:15:00	High BP	OPD	Voluptatibus consectetur dicta est adipisci.	2025-06-26 22:30:08	2025-06-26 22:30:08	102/80	80	98.0	96	65	Occaecati sit dolorum vel quam.	Rerum quae accusantium dolorem minus ab.	2025-08-21	Blanditiis sequi ex quas occaecati voluptate.	2025-08-12	12:15	3	pending	APT11192	\N
10194	54	4	2025-08-13 14:30:00	Back Pain	Emergency	Odit cupiditate dolores a necessitatibus provident fugiat.	2025-06-26 22:30:08	2025-06-26 22:30:08	103/84	72	99.1	98	62	Repellat vitae totam occaecati.	Qui culpa eum modi voluptas incidunt.	2025-09-03	Itaque tenetur expedita sit dolor quas cupiditate.	2025-08-13	14:30	3	pending	APT11193	\N
10195	143	5	2025-08-13 11:15:00	High BP	New	Officia ea aliquam consectetur.	2025-06-26 22:30:08	2025-06-26 22:30:08	115/85	71	99.3	95	80	Sit eos a id ab distinctio laudantium incidunt.	Eius natus perspiciatis numquam neque porro possimus.	2025-09-03	Voluptate at reprehenderit illo.	2025-08-13	11:15	3	pending	APT11194	\N
10196	319	4	2025-08-13 11:45:00	Cough	Follow-up	Quisquam impedit repellendus magni labore explicabo.	2025-06-26 22:30:08	2025-06-26 22:30:08	116/71	79	99.4	100	73	Veniam non laudantium quos hic iste quae optio.	Impedit aspernatur nemo vel qui nobis.	2025-09-04	Voluptatem cum amet in dignissimos.	2025-08-13	11:45	3	pending	APT11195	\N
10197	420	9	2025-08-13 11:00:00	High BP	New	Quibusdam id in sapiente vero.	2025-06-26 22:30:08	2025-06-26 22:30:08	128/89	78	99.9	95	75	Voluptatibus optio eos animi sed et ad.	Molestiae id facere mollitia.	2025-08-28	Accusamus quod dolore et.	2025-08-13	11:00	3	pending	APT11196	\N
10198	207	9	2025-08-13 11:00:00	Fever	New	Laboriosam sapiente aperiam veritatis soluta dolorum culpa.	2025-06-26 22:30:08	2025-06-26 22:30:08	127/69	84	99.8	95	82	Ea voluptatibus incidunt. Eveniet porro voluptatum.	Reprehenderit necessitatibus libero nihil sunt.	2025-08-24	Autem ducimus neque quam voluptatibus dolore fugiat.	2025-08-13	11:00	3	pending	APT11197	\N
10199	401	4	2025-08-13 15:45:00	Skin Rash	OPD	Odio amet doloribus blanditiis.	2025-06-26 22:30:08	2025-06-26 22:30:08	132/78	72	98.9	97	60	Animi aliquam velit nulla excepturi ullam eum.	Deleniti neque ab pariatur distinctio quis laborum.	2025-08-26	Laboriosam vero accusantium assumenda hic molestiae.	2025-08-13	15:45	3	pending	APT11198	\N
10200	116	4	2025-08-13 13:30:00	High BP	New	Molestiae cum maiores nam at.	2025-06-26 22:30:08	2025-06-26 22:30:08	114/61	92	98.7	99	56	Error corrupti molestiae possimus a.	Sint recusandae architecto eos laborum voluptatum nemo sed.	2025-09-09	Magni doloribus enim dicta porro.	2025-08-13	13:30	3	pending	APT11199	\N
10201	285	9	2025-08-13 12:15:00	Diabetes Check	Emergency	Corporis iste ducimus ducimus aliquid ad.	2025-06-26 22:30:08	2025-06-26 22:30:08	140/86	90	98.7	96	61	Perferendis non odio magni laborum officia.	Facilis praesentium ea saepe officiis at expedita.	2025-09-11	Similique suscipit veniam.	2025-08-13	12:15	3	pending	APT11200	\N
10202	31	3	2025-08-13 13:30:00	High BP	New	Numquam velit voluptatum laudantium.	2025-06-26 22:30:08	2025-06-26 22:30:08	136/61	89	98.5	96	65	Impedit explicabo veniam labore ad aliquid.	Ratione neque dicta natus cupiditate.	2025-09-10	Libero quisquam reprehenderit voluptas dignissimos corrupti consequuntur.	2025-08-13	13:30	3	pending	APT11201	\N
10203	149	4	2025-08-13 14:30:00	Fever	New	Sunt eveniet nostrum quibusdam tempore natus harum.	2025-06-26 22:30:08	2025-06-26 22:30:08	106/83	77	99.7	98	67	Facilis nemo earum perspiciatis quibusdam repudiandae.	Qui aspernatur enim iure recusandae vero reiciendis doloremque.	2025-09-04	Sunt inventore labore maxime ratione.	2025-08-13	14:30	3	pending	APT11202	\N
10204	362	5	2025-08-13 15:45:00	Skin Rash	Emergency	Molestias beatae tempore sint mollitia consequuntur quia quibusdam.	2025-06-26 22:30:08	2025-06-26 22:30:08	130/66	89	99.5	95	72	Sapiente culpa id quae velit eligendi sequi quibusdam.	Perspiciatis delectus eius tempora optio ducimus repellat similique labore.	2025-08-28	Accusamus iusto eveniet ullam at laborum possimus.	2025-08-13	15:45	3	pending	APT11203	\N
10205	486	7	2025-08-13 12:15:00	Cough	Emergency	Mollitia eligendi repellat culpa.	2025-06-26 22:30:08	2025-06-26 22:30:08	110/63	96	98.2	100	73	Qui fugiat sequi voluptatibus deleniti error itaque totam.	Voluptatum odio laboriosam dolore.	2025-08-28	Sapiente recusandae quia.	2025-08-13	12:15	3	pending	APT11204	\N
10206	456	5	2025-08-13 13:30:00	High BP	Emergency	Sit sint labore consequatur impedit dolorem maiores.	2025-06-26 22:30:08	2025-06-26 22:30:08	122/83	86	98.3	98	71	Distinctio iure sed.	Nesciunt numquam eligendi laudantium culpa.	2025-09-10	Dicta et quasi.	2025-08-13	13:30	3	pending	APT11205	\N
10207	330	4	2025-08-13 15:45:00	Headache	OPD	Dolore autem asperiores quos.	2025-06-26 22:30:08	2025-06-26 22:30:08	124/85	88	100.3	99	76	Assumenda voluptas eaque sit similique.	Tempore ad id quaerat necessitatibus eveniet possimus dolore.	2025-08-29	Commodi suscipit ipsa debitis et earum.	2025-08-13	15:45	3	pending	APT11206	\N
10208	180	3	2025-08-13 11:15:00	Back Pain	Follow-up	Dolores ab aliquam soluta laboriosam quidem quas.	2025-06-26 22:30:08	2025-06-26 22:30:08	114/62	72	97.9	95	80	Architecto aut atque quos magnam.	Atque repellendus totam labore aliquid.	2025-09-11	Veniam ipsam hic excepturi.	2025-08-13	11:15	3	pending	APT11207	\N
10209	399	7	2025-08-13 13:15:00	High BP	Emergency	Eaque quos minima corporis.	2025-06-26 22:30:08	2025-06-26 22:30:08	121/69	80	99.1	100	83	Praesentium sapiente corrupti nesciunt earum nam alias.	Magnam error reprehenderit possimus nulla eveniet dicta dolorum cum iusto.	2025-08-21	Officiis hic alias quod.	2025-08-13	13:15	3	pending	APT11208	\N
10210	285	8	2025-08-13 15:30:00	Skin Rash	OPD	Ab vel commodi numquam.	2025-06-26 22:30:08	2025-06-26 22:30:08	140/61	81	98.2	100	67	Ratione enim ducimus alias facilis ipsum natus.	Amet neque corrupti necessitatibus rem tempore molestias reprehenderit.	2025-09-07	Vitae sequi et error excepturi quibusdam.	2025-08-13	15:30	3	pending	APT11209	\N
10211	44	7	2025-08-13 11:00:00	Routine Checkup	OPD	Necessitatibus incidunt sapiente fuga.	2025-06-26 22:30:08	2025-06-26 22:30:08	125/72	73	99.6	99	56	Reprehenderit tempore culpa.	Excepturi cumque doloremque fuga nostrum libero nihil tenetur eaque ipsa maxime.	2025-08-26	Sint dolores blanditiis ex culpa optio.	2025-08-13	11:00	3	pending	APT11210	\N
10212	381	5	2025-08-13 16:15:00	High BP	New	Illum laboriosam eveniet dolore.	2025-06-26 22:30:08	2025-06-26 22:30:08	131/66	74	97.7	100	85	Officiis nihil dolore consequatur modi debitis sequi.	Quasi magni minima blanditiis ex quidem impedit voluptas ducimus quos.	2025-09-07	Quae sequi omnis atque rem soluta nisi ipsa.	2025-08-13	16:15	3	pending	APT11211	\N
10213	339	9	2025-08-13 13:45:00	Diabetes Check	Emergency	Et atque omnis ipsa incidunt.	2025-06-26 22:30:08	2025-06-26 22:30:08	107/70	90	99.9	96	81	Cumque odit quas culpa assumenda similique dicta.	Nobis blanditiis officiis ea eligendi.	2025-09-12	Pariatur inventore tempora labore nam dolore commodi ullam.	2025-08-13	13:45	3	pending	APT11212	\N
10214	406	7	2025-08-13 11:15:00	Cough	OPD	Cum quod doloremque possimus non dignissimos adipisci.	2025-06-26 22:30:08	2025-06-26 22:30:08	129/79	83	100.1	100	84	Ratione sunt aliquam velit atque vel placeat minima.	Commodi error sapiente error.	2025-08-23	Adipisci quo dolor doloribus sunt.	2025-08-13	11:15	3	pending	APT11213	\N
10215	75	5	2025-08-13 15:00:00	Diabetes Check	Emergency	Iusto et expedita reprehenderit perferendis.	2025-06-26 22:30:08	2025-06-26 22:30:08	114/76	98	99.1	99	79	Ratione officiis reiciendis beatae quas.	Assumenda eaque illo corporis suscipit possimus quibusdam quae ab.	2025-09-05	Esse perspiciatis qui soluta est hic hic.	2025-08-13	15:00	3	pending	APT11214	\N
10216	303	7	2025-08-13 16:15:00	High BP	New	Beatae dolorum quam quibusdam quidem ullam quae temporibus.	2025-06-26 22:30:08	2025-06-26 22:30:08	138/64	76	99.5	99	79	Reprehenderit a esse expedita neque.	Veritatis quaerat mollitia non necessitatibus placeat autem maxime.	2025-08-26	Distinctio commodi culpa velit assumenda.	2025-08-13	16:15	3	pending	APT11215	\N
10217	65	8	2025-08-13 16:00:00	Diabetes Check	Emergency	Numquam maiores eos tempore.	2025-06-26 22:30:08	2025-06-26 22:30:08	105/61	82	99.0	98	55	Ea inventore dolorum.	Voluptatum perspiciatis ratione magni perferendis vero.	2025-09-12	Vero ipsum iure.	2025-08-13	16:00	3	pending	APT11216	\N
10218	59	3	2025-08-13 16:00:00	Cough	New	Voluptas sunt quibusdam tempora laboriosam.	2025-06-26 22:30:08	2025-06-26 22:30:08	105/69	81	99.5	95	64	Et ullam eaque totam.	Suscipit reprehenderit porro enim nam.	2025-09-10	Odit repellendus autem dolorum ea aliquam in.	2025-08-13	16:00	3	pending	APT11217	\N
10219	356	4	2025-08-13 15:30:00	Headache	Emergency	Est vel fugiat neque sint dolores error.	2025-06-26 22:30:08	2025-06-26 22:30:08	138/87	96	97.8	100	62	Dolore unde id deserunt sint quia.	Tenetur quasi dolorem sunt aspernatur earum.	2025-09-08	Voluptatem porro vero provident.	2025-08-13	15:30	3	pending	APT11218	\N
10220	153	9	2025-08-13 11:30:00	Diabetes Check	New	Rerum ullam dicta sed corrupti.	2025-06-26 22:30:08	2025-06-26 22:30:08	107/72	86	100.5	99	76	Iure numquam nesciunt magni illum beatae sed.	Alias facilis eum ea quae eos beatae.	2025-09-09	Nisi eum inventore totam beatae placeat.	2025-08-13	11:30	3	pending	APT11219	\N
10221	323	4	2025-08-14 13:45:00	Diabetes Check	Follow-up	Dicta quae tempora laudantium sunt alias magni.	2025-06-26 22:30:08	2025-06-26 22:30:08	103/87	85	99.3	99	76	Atque non ipsum magnam nesciunt odit quasi.	Alias minus odit labore ipsam.	2025-08-24	Fugiat nisi commodi quibusdam laboriosam nisi.	2025-08-14	13:45	3	pending	APT11220	\N
10222	398	6	2025-08-14 16:30:00	Skin Rash	OPD	Voluptates suscipit enim fugit itaque.	2025-06-26 22:30:08	2025-06-26 22:30:08	136/72	75	97.6	96	64	Ratione cupiditate ducimus unde.	Ducimus ipsa nisi ab beatae consequatur sunt quibusdam culpa.	2025-08-30	Commodi reiciendis magni eius in.	2025-08-14	16:30	3	pending	APT11221	\N
10223	46	8	2025-08-14 12:30:00	Cough	Emergency	Labore rem in quia perferendis architecto nemo.	2025-06-26 22:30:08	2025-06-26 22:30:08	107/87	88	98.9	97	82	Minima porro eaque.	Non dignissimos repellat aliquam iure consequuntur.	2025-09-01	Quo velit officiis quisquam dignissimos assumenda ipsa aliquid.	2025-08-14	12:30	3	pending	APT11222	\N
10224	486	9	2025-08-14 12:15:00	Back Pain	Follow-up	Molestias similique ipsum voluptas dolorem excepturi itaque.	2025-06-26 22:30:08	2025-06-26 22:30:08	138/62	72	99.2	98	79	Magni soluta ab quod officia suscipit quaerat.	Eos deleniti voluptate consequuntur distinctio eos non voluptate.	2025-09-08	Eum id repellendus ut dolorum sint quae quam.	2025-08-14	12:15	3	pending	APT11223	\N
10225	191	6	2025-08-14 13:15:00	Diabetes Check	OPD	Ea unde doloribus cupiditate.	2025-06-26 22:30:08	2025-06-26 22:30:08	130/61	72	100.1	99	64	Et unde nihil autem exercitationem veniam.	Ex ut odio quas reprehenderit amet.	2025-08-26	Dignissimos sint est ullam earum.	2025-08-14	13:15	3	pending	APT11224	\N
10226	419	5	2025-08-14 16:30:00	Fever	Follow-up	Nemo sequi voluptatibus error dicta.	2025-06-26 22:30:08	2025-06-26 22:30:08	111/88	81	99.7	97	55	Ipsum tenetur quod veniam.	Tempora explicabo placeat hic eveniet nisi amet exercitationem dignissimos illum consectetur.	2025-08-30	Assumenda nemo praesentium sunt necessitatibus non.	2025-08-14	16:30	3	pending	APT11225	\N
10227	16	5	2025-08-14 15:15:00	Headache	Follow-up	Voluptas nesciunt ratione voluptatem magnam dicta ipsa.	2025-06-26 22:30:08	2025-06-26 22:30:08	138/61	95	98.2	100	61	Eligendi aliquam hic nisi. Harum minus harum repellat.	Dolorum accusamus corrupti velit rerum atque eligendi eaque.	2025-08-28	Deleniti dolore nobis vero quo.	2025-08-14	15:15	3	pending	APT11226	\N
10228	403	8	2025-08-14 12:15:00	Diabetes Check	Emergency	Atque earum itaque facilis.	2025-06-26 22:30:08	2025-06-26 22:30:08	116/65	87	100.2	95	80	Quis harum mollitia ipsam.	Voluptatem tenetur libero consequuntur non corporis quasi consequatur excepturi.	2025-09-11	Molestiae ea harum mollitia.	2025-08-14	12:15	3	pending	APT11227	\N
10229	140	10	2025-08-14 15:45:00	Headache	OPD	Quae repellat eum minima aut.	2025-06-26 22:30:08	2025-06-26 22:30:08	115/77	89	97.9	100	66	Aliquid in commodi quos dolores quae facilis.	Odio animi quisquam eveniet officiis pariatur commodi facilis adipisci temporibus.	2025-09-05	Quasi omnis recusandae atque nam.	2025-08-14	15:45	3	pending	APT11228	\N
10230	178	3	2025-08-14 13:15:00	Diabetes Check	Emergency	Ipsum pariatur laudantium repudiandae numquam.	2025-06-26 22:30:08	2025-06-26 22:30:08	104/87	83	99.8	99	71	Iste maxime atque ex veritatis inventore dolores.	Qui exercitationem voluptatum vero error minus optio possimus fugit veritatis quia.	2025-08-27	Sit molestiae sint eaque.	2025-08-14	13:15	3	pending	APT11229	\N
10231	116	3	2025-08-14 14:00:00	Routine Checkup	Emergency	Ipsum id tenetur eaque harum repudiandae.	2025-06-26 22:30:08	2025-06-26 22:30:08	126/76	81	97.8	100	81	Commodi cum fugit quisquam deleniti nihil.	Voluptate quia unde modi ut perspiciatis incidunt.	2025-08-26	Reprehenderit minus eveniet consequuntur.	2025-08-14	14:00	3	pending	APT11230	\N
10232	355	5	2025-08-14 11:00:00	Diabetes Check	New	Commodi nemo perferendis illo.	2025-06-26 22:30:08	2025-06-26 22:30:08	124/78	96	98.3	95	73	Recusandae perferendis deserunt odit illum.	At quam debitis reiciendis modi voluptas repellendus voluptate.	2025-09-09	Accusamus totam nobis quis sit eum distinctio.	2025-08-14	11:00	3	pending	APT11231	\N
10233	394	6	2025-08-14 13:45:00	Fever	Follow-up	Dolor cum sed harum.	2025-06-26 22:30:08	2025-06-26 22:30:08	102/69	94	99.6	99	70	Quae expedita nostrum dolor aliquam.	Atque corrupti quia sequi omnis in distinctio sint quo.	2025-09-13	Eius ipsam quae numquam voluptates eos autem.	2025-08-14	13:45	3	pending	APT11232	\N
10234	310	4	2025-08-14 16:30:00	Diabetes Check	Emergency	Debitis sapiente placeat exercitationem.	2025-06-26 22:30:08	2025-06-26 22:30:08	120/77	87	100.2	98	57	Aut a consequuntur minus itaque.	Officia voluptate distinctio alias pariatur iure reprehenderit.	2025-08-22	Aspernatur animi assumenda repellendus labore aperiam.	2025-08-14	16:30	3	pending	APT11233	\N
10235	141	10	2025-08-14 14:00:00	High BP	Emergency	Vitae aspernatur aspernatur ducimus tenetur quod neque.	2025-06-26 22:30:08	2025-06-26 22:30:08	136/76	84	98.9	96	82	Tempora ea tenetur eum.	Esse esse voluptatibus nostrum vitae corporis voluptate similique.	2025-09-06	Vitae asperiores corrupti sed corporis libero minima.	2025-08-14	14:00	3	pending	APT11234	\N
10236	35	4	2025-08-14 16:30:00	Cough	Follow-up	Beatae repudiandae culpa tempora.	2025-06-26 22:30:08	2025-06-26 22:30:08	101/72	93	99.9	97	62	Unde atque quasi in quia perspiciatis corporis.	Corrupti fugit saepe earum voluptatibus earum iste hic reiciendis.	2025-09-10	Consectetur quis aspernatur provident sequi.	2025-08-14	16:30	3	pending	APT11235	\N
10237	359	5	2025-08-14 15:15:00	Cough	New	A minus blanditiis ad possimus rerum dicta.	2025-06-26 22:30:08	2025-06-26 22:30:08	114/81	93	100.4	95	81	Earum impedit iusto quasi veritatis.	Omnis esse iure deleniti enim quos sequi molestias exercitationem expedita.	2025-09-11	Recusandae ut quo totam quidem animi corrupti.	2025-08-14	15:15	3	pending	APT11236	\N
10238	375	6	2025-08-14 13:45:00	Diabetes Check	New	Doloribus nesciunt accusantium fugiat quas cupiditate porro hic.	2025-06-26 22:30:08	2025-06-26 22:30:08	120/72	75	98.0	98	67	Fugiat consequuntur velit suscipit.	Quo nemo hic deleniti placeat sed.	2025-08-26	Quae ut officiis soluta.	2025-08-14	13:45	3	pending	APT11237	\N
10239	285	7	2025-08-14 16:45:00	Routine Checkup	OPD	Eos modi unde ipsum.	2025-06-26 22:30:08	2025-06-26 22:30:08	123/83	93	98.2	96	70	Unde quo aperiam deserunt assumenda vel.	Nesciunt dolore quasi quos magni facere veritatis nisi.	2025-08-21	Totam maiores nobis.	2025-08-14	16:45	3	pending	APT11238	\N
10240	391	7	2025-08-14 11:30:00	Headache	OPD	Tempora quibusdam nam neque recusandae laborum.	2025-06-26 22:30:08	2025-06-26 22:30:08	114/62	92	100.0	95	78	Quod et quo vel. Optio laborum eum.	Voluptatibus mollitia minima exercitationem sed nihil animi soluta omnis.	2025-09-07	Quidem deserunt commodi dolorum.	2025-08-14	11:30	3	pending	APT11239	\N
10241	154	3	2025-08-14 15:00:00	High BP	Follow-up	Eius esse omnis nam.	2025-06-26 22:30:08	2025-06-26 22:30:08	135/62	87	99.8	95	83	Labore exercitationem aliquam fuga eum.	Error minus vitae incidunt quod sit repudiandae beatae itaque.	2025-09-01	Autem vitae magni expedita.	2025-08-14	15:00	3	pending	APT11240	\N
10242	161	6	2025-08-14 15:00:00	Headache	OPD	Recusandae rem eligendi.	2025-06-26 22:30:08	2025-06-26 22:30:08	132/83	87	99.8	96	69	Nisi ut ducimus esse autem.	Incidunt voluptas aspernatur tempore nemo mollitia sed.	2025-09-07	Sunt animi molestiae nobis quo accusantium.	2025-08-14	15:00	3	pending	APT11241	\N
10243	37	5	2025-08-14 16:45:00	Routine Checkup	New	Eveniet porro natus nobis facere illum.	2025-06-26 22:30:08	2025-06-26 22:30:08	139/87	91	98.3	97	74	Neque incidunt rerum at quod.	Amet omnis est iste illum sapiente explicabo voluptatem.	2025-09-12	Quos debitis adipisci nesciunt.	2025-08-14	16:45	3	pending	APT11242	\N
10244	365	4	2025-08-14 12:30:00	Headache	Follow-up	Impedit a qui ex dolores neque inventore corrupti.	2025-06-26 22:30:08	2025-06-26 22:30:08	115/75	79	98.0	95	72	Repudiandae ullam quos.	Beatae corrupti temporibus ad vel quod animi temporibus aut animi quas.	2025-09-06	Eius incidunt in aliquid cum numquam nam.	2025-08-14	12:30	3	pending	APT11243	\N
10245	22	5	2025-08-14 15:30:00	Headache	Emergency	Minus atque eaque suscipit atque dolores laboriosam.	2025-06-26 22:30:08	2025-06-26 22:30:08	117/70	98	98.2	99	70	Quasi porro corporis fuga. Voluptate vero aut veniam et.	Rerum nam laboriosam sequi beatae explicabo quod voluptate ipsum ducimus laboriosam.	2025-08-26	Fuga minima enim eaque facilis excepturi.	2025-08-14	15:30	3	pending	APT11244	\N
10246	361	9	2025-08-15 14:00:00	Headache	Follow-up	Facere laboriosam cum magni dignissimos aliquam.	2025-06-26 22:30:08	2025-06-26 22:30:08	123/89	74	98.3	100	71	Sint accusamus occaecati exercitationem vel saepe hic.	Et eum quod sequi ducimus accusantium eaque exercitationem.	2025-09-07	Ea ab facere non.	2025-08-15	14:00	3	pending	APT11245	\N
10247	94	9	2025-08-15 12:00:00	Diabetes Check	New	Doloribus architecto incidunt voluptates itaque beatae nostrum.	2025-06-26 22:30:08	2025-06-26 22:30:08	114/73	83	98.1	96	78	Ab minima rerum earum distinctio ipsum.	Corporis facilis quidem ratione laborum maxime.	2025-09-14	Atque porro qui exercitationem nihil id porro.	2025-08-15	12:00	3	pending	APT11246	\N
10248	32	10	2025-08-15 15:00:00	Routine Checkup	Follow-up	Eos fugiat eligendi sapiente laborum harum quod.	2025-06-26 22:30:08	2025-06-26 22:30:08	127/63	78	100.4	97	63	Sed similique exercitationem facere excepturi ab suscipit.	Cumque illo sit non neque vel dolorum quam similique.	2025-08-24	Libero autem possimus dolor corporis voluptatibus.	2025-08-15	15:00	3	pending	APT11247	\N
10249	260	9	2025-08-15 15:15:00	Fever	Emergency	Nostrum harum sint similique labore necessitatibus.	2025-06-26 22:30:08	2025-06-26 22:30:08	105/79	76	97.6	100	65	Necessitatibus facere necessitatibus nemo.	Quasi deserunt quis excepturi a eum aliquid magni laudantium voluptas.	2025-09-03	Iste suscipit at ut quod.	2025-08-15	15:15	3	pending	APT11248	\N
10250	406	6	2025-08-15 14:30:00	Skin Rash	New	Eos soluta quia repudiandae asperiores ea.	2025-06-26 22:30:08	2025-06-26 22:30:08	115/69	78	97.9	97	64	Iste ex dolorem alias. Fugiat totam asperiores a est vel.	Tempora tempore placeat sed excepturi autem sit molestias libero.	2025-09-11	Cupiditate accusantium ipsam assumenda blanditiis.	2025-08-15	14:30	3	pending	APT11249	\N
10251	302	4	2025-08-15 13:15:00	Back Pain	OPD	Quam labore ratione dolores.	2025-06-26 22:30:08	2025-06-26 22:30:08	128/75	81	100.3	96	59	Mollitia dolor nulla incidunt deleniti delectus.	Saepe omnis ipsam ad occaecati vitae quasi laudantium.	2025-09-13	Fugit vitae facilis voluptate numquam odio quasi.	2025-08-15	13:15	3	pending	APT11250	\N
10252	153	10	2025-08-15 12:30:00	High BP	Follow-up	Aliquid iusto at quam alias illo fuga.	2025-06-26 22:30:08	2025-06-26 22:30:08	137/61	86	99.8	96	70	Nisi ullam vero dolor quia. Nisi nobis ipsum quaerat.	Rerum at placeat dolorem.	2025-09-06	Iure inventore repellat voluptas perspiciatis maiores consequatur.	2025-08-15	12:30	3	pending	APT11251	\N
10253	264	10	2025-08-15 11:45:00	Routine Checkup	OPD	Ex assumenda expedita aliquid incidunt officiis aliquid.	2025-06-26 22:30:08	2025-06-26 22:30:08	103/89	76	98.1	98	80	Maiores esse similique nobis architecto deleniti nobis.	Molestias necessitatibus fugiat itaque optio ullam id hic nemo.	2025-08-31	Aliquid non unde explicabo rerum illo corporis mollitia.	2025-08-15	11:45	3	pending	APT11252	\N
10254	24	10	2025-08-15 14:30:00	Headache	Follow-up	Inventore adipisci quibusdam veritatis voluptatibus nam laboriosam.	2025-06-26 22:30:08	2025-06-26 22:30:08	140/90	88	99.5	95	68	Voluptates perspiciatis omnis odit minima alias.	Eos sed repellat expedita quasi similique.	2025-08-25	Veniam ex sed aperiam.	2025-08-15	14:30	3	pending	APT11253	\N
10255	143	8	2025-08-15 12:45:00	Back Pain	OPD	Voluptatibus voluptatem quam ex sunt nulla ullam.	2025-06-26 22:30:08	2025-06-26 22:30:08	118/72	89	100.3	96	81	Iste est minima rerum cupiditate iste.	Voluptatibus unde necessitatibus dolorem reprehenderit.	2025-08-31	Enim totam doloremque eius esse a.	2025-08-15	12:45	3	pending	APT11254	\N
10256	103	4	2025-08-15 16:00:00	Diabetes Check	OPD	Hic debitis ex quae reprehenderit deserunt molestias.	2025-06-26 22:30:08	2025-06-26 22:30:08	118/65	78	98.5	98	61	Iusto deleniti corporis. Nesciunt libero tenetur dicta.	Hic quasi perferendis illum magni voluptatem velit itaque voluptatibus quo.	2025-09-07	Minima quis excepturi autem optio.	2025-08-15	16:00	3	pending	APT11255	\N
10257	142	9	2025-08-15 12:45:00	Skin Rash	Follow-up	Nam beatae vel impedit maxime quisquam beatae.	2025-06-26 22:30:08	2025-06-26 22:30:08	139/64	93	100.4	98	65	Minus ut iusto. Veniam consectetur earum.	Pariatur dignissimos cum voluptate exercitationem voluptates fuga labore eius possimus.	2025-08-22	Est porro blanditiis exercitationem quas eaque.	2025-08-15	12:45	3	pending	APT11256	\N
10258	232	10	2025-08-15 12:30:00	Cough	OPD	Reiciendis tenetur reprehenderit quidem odit.	2025-06-26 22:30:08	2025-06-26 22:30:08	111/61	86	99.5	95	78	Ad at neque recusandae maxime doloribus voluptatem.	Dolorem ullam ipsam praesentium modi.	2025-09-06	Quod eum architecto odio.	2025-08-15	12:30	3	pending	APT11257	\N
10259	130	5	2025-08-15 16:45:00	Back Pain	Emergency	Quibusdam fugiat quis alias.	2025-06-26 22:30:08	2025-06-26 22:30:08	117/72	69	98.3	100	65	Quo architecto saepe magni at.	Aut magni quam sint explicabo laboriosam rem.	2025-08-22	Quibusdam sunt et reiciendis reprehenderit.	2025-08-15	16:45	3	pending	APT11258	\N
10260	99	3	2025-08-15 15:00:00	High BP	Emergency	Vel nihil atque voluptatum autem.	2025-06-26 22:30:08	2025-06-26 22:30:08	126/73	73	99.1	95	82	Laudantium iste suscipit sapiente.	Molestias laudantium atque labore quia tenetur repudiandae nemo minus ipsa.	2025-09-14	Impedit asperiores similique magnam aut eaque facere.	2025-08-15	15:00	3	pending	APT11259	\N
10261	417	10	2025-08-15 16:30:00	Skin Rash	New	Accusamus excepturi cum natus doloribus.	2025-06-26 22:30:08	2025-06-26 22:30:08	111/84	82	98.1	99	73	Vero ex hic accusantium possimus vel ipsum.	Aspernatur dolorum sed odio ducimus.	2025-09-14	Rerum dolores accusamus.	2025-08-15	16:30	3	pending	APT11260	\N
10262	479	9	2025-08-15 12:00:00	Routine Checkup	Emergency	Eum facilis debitis cumque.	2025-06-26 22:30:08	2025-06-26 22:30:08	121/73	79	98.2	99	74	Ad ducimus sequi rem vel.	Nihil ea molestiae nulla deleniti.	2025-09-01	Velit distinctio tenetur nobis cupiditate.	2025-08-15	12:00	3	pending	APT11261	\N
10263	88	10	2025-08-15 11:45:00	Diabetes Check	New	Minima voluptas suscipit.	2025-06-26 22:30:08	2025-06-26 22:30:08	105/81	83	99.3	99	85	Dolore rem cum.	Ab incidunt vero neque recusandae ducimus illum fugiat laborum.	2025-08-31	Quos enim illo optio nemo sunt adipisci.	2025-08-15	11:45	3	pending	APT11262	\N
10264	451	4	2025-08-15 15:45:00	Fever	New	Ea maxime minima cumque laudantium.	2025-06-26 22:30:08	2025-06-26 22:30:08	131/82	92	99.9	96	71	Autem facere natus odit ullam enim.	Corrupti provident quibusdam autem sapiente cum.	2025-09-10	Temporibus magnam illo voluptates minus officiis officiis.	2025-08-15	15:45	3	pending	APT11263	\N
10265	216	3	2025-08-15 14:45:00	High BP	OPD	Dolorem voluptatibus fugit magnam sed.	2025-06-26 22:30:08	2025-06-26 22:30:08	127/89	67	97.8	98	77	Eaque modi perspiciatis dolore aliquam.	Sit quas corrupti itaque incidunt quos perspiciatis vero deleniti odit.	2025-08-28	Ratione neque quaerat neque ipsum doloremque quibusdam.	2025-08-15	14:45	3	pending	APT11264	\N
10266	306	4	2025-08-16 14:00:00	High BP	Follow-up	Blanditiis dolorem perferendis rem cupiditate temporibus atque dolorem.	2025-06-26 22:30:08	2025-06-26 22:30:08	107/73	82	100.4	98	74	Quia quisquam nobis voluptatem.	Temporibus architecto ad asperiores minus corporis eaque tempora odio.	2025-09-10	Sunt hic eveniet ea possimus.	2025-08-16	14:00	3	pending	APT11265	\N
10267	104	7	2025-08-16 14:15:00	Diabetes Check	Follow-up	Exercitationem quasi maxime est placeat necessitatibus.	2025-06-26 22:30:08	2025-06-26 22:30:08	108/90	96	98.4	95	85	Praesentium corporis qui consectetur odit.	Cumque ducimus necessitatibus eius placeat odit sunt nobis.	2025-08-31	Inventore corrupti dolore eius ducimus.	2025-08-16	14:15	3	pending	APT11266	\N
10268	320	4	2025-08-16 11:45:00	Back Pain	New	Dolor blanditiis aspernatur architecto laboriosam.	2025-06-26 22:30:08	2025-06-26 22:30:08	110/81	71	99.7	100	57	Molestias enim cum pariatur mollitia saepe.	Quisquam quos sunt explicabo consequuntur ad harum dolorum veritatis laboriosam.	2025-08-26	Saepe alias error in ipsum quam eveniet minus.	2025-08-16	11:45	3	pending	APT11267	\N
10269	323	5	2025-08-16 14:15:00	Fever	OPD	Quia perspiciatis harum minus.	2025-06-26 22:30:08	2025-06-26 22:30:08	114/64	96	97.8	100	57	Accusantium similique at minima.	Nulla commodi iusto praesentium eos vitae ut enim expedita.	2025-09-07	Aut at facilis id autem.	2025-08-16	14:15	3	pending	APT11268	\N
10270	312	9	2025-08-16 11:15:00	Skin Rash	New	Culpa dolor mollitia cum.	2025-06-26 22:30:08	2025-06-26 22:30:08	131/86	84	98.2	96	56	Qui recusandae nesciunt sit consequatur.	In tempore mollitia corporis nulla ab architecto magnam quae.	2025-09-13	Praesentium alias a nisi numquam quam.	2025-08-16	11:15	3	pending	APT11269	\N
10271	113	3	2025-08-16 11:30:00	Routine Checkup	New	Neque nostrum voluptatem necessitatibus vero veniam unde.	2025-06-26 22:30:08	2025-06-26 22:30:08	119/70	79	98.5	99	71	Commodi blanditiis voluptates repellendus.	Autem porro inventore totam occaecati voluptatibus illum accusamus nemo ullam.	2025-09-03	Aspernatur sed repellendus perspiciatis quod enim fuga.	2025-08-16	11:30	3	pending	APT11270	\N
10272	357	7	2025-08-16 13:45:00	Back Pain	Emergency	Quos sed architecto quae.	2025-06-26 22:30:08	2025-06-26 22:30:08	106/83	75	97.6	97	81	Harum ea vitae quibusdam quo odit.	Aut voluptas incidunt ut quaerat corporis quibusdam libero possimus enim.	2025-09-11	Repellat et quia dignissimos.	2025-08-16	13:45	3	pending	APT11271	\N
10273	312	7	2025-08-16 14:15:00	Routine Checkup	Emergency	Voluptatum voluptas excepturi praesentium corporis.	2025-06-26 22:30:08	2025-06-26 22:30:08	132/90	74	97.7	96	82	Ab quam quo quibusdam. Nisi facilis facilis quibusdam.	Reiciendis fugiat accusantium consequuntur nostrum provident repudiandae aliquam rerum voluptate.	2025-09-07	Enim nam eaque placeat eos magni quis.	2025-08-16	14:15	3	pending	APT11272	\N
10274	140	7	2025-08-16 15:30:00	High BP	OPD	Perspiciatis explicabo labore voluptate.	2025-06-26 22:30:08	2025-06-26 22:30:08	100/80	87	97.8	95	85	Velit quis similique fuga dolorem facilis eligendi esse.	Iste temporibus nam provident reprehenderit.	2025-08-27	Ratione delectus explicabo id quod odit voluptatem.	2025-08-16	15:30	3	pending	APT11273	\N
10275	440	5	2025-08-16 16:15:00	Fever	OPD	Officia voluptatem quam rem non.	2025-06-26 22:30:08	2025-06-26 22:30:08	125/90	81	100.3	96	63	Fugit corporis ipsa numquam iure ipsa.	Molestias commodi esse magni delectus repellendus corrupti tempore quo.	2025-09-11	Cupiditate consectetur dignissimos quos.	2025-08-16	16:15	3	pending	APT11274	\N
10276	490	7	2025-08-16 13:30:00	Back Pain	Follow-up	Commodi similique iste nobis magnam.	2025-06-26 22:30:08	2025-06-26 22:30:08	104/89	72	99.7	96	75	Tempora consequuntur alias praesentium in.	Temporibus dignissimos possimus consequatur eveniet.	2025-09-10	Minus repellat assumenda dolore molestiae.	2025-08-16	13:30	3	pending	APT11275	\N
10277	44	9	2025-08-16 14:15:00	Back Pain	New	Voluptatum praesentium esse tenetur.	2025-06-26 22:30:08	2025-06-26 22:30:08	110/80	92	99.9	96	56	Fugiat repellendus rerum.	Sapiente quod deleniti unde beatae placeat deleniti.	2025-09-12	Minus nostrum optio esse sed.	2025-08-16	14:15	3	pending	APT11276	\N
10278	72	3	2025-08-16 15:15:00	Routine Checkup	Follow-up	Illum accusantium magnam quam commodi consectetur.	2025-06-26 22:30:08	2025-06-26 22:30:08	121/83	73	100.5	96	55	Nemo vitae voluptatibus dignissimos maiores.	Molestias et tempore cum dicta.	2025-08-24	Quo ut itaque aspernatur molestiae magni debitis.	2025-08-16	15:15	3	pending	APT11277	\N
10279	424	4	2025-08-16 13:00:00	Fever	Follow-up	Pariatur amet amet ab atque doloremque.	2025-06-26 22:30:08	2025-06-26 22:30:08	126/62	79	97.7	99	68	Assumenda quos quasi voluptatem necessitatibus ipsam autem.	Quod inventore quo nihil explicabo.	2025-08-26	Laborum tempore illum aut.	2025-08-16	13:00	3	pending	APT11278	\N
10280	175	10	2025-08-16 16:00:00	Back Pain	New	Dolore nemo tempore vitae eius.	2025-06-26 22:30:08	2025-06-26 22:30:08	107/87	71	99.3	98	78	Iusto itaque ipsa assumenda.	Nihil reprehenderit omnis illo delectus.	2025-09-06	Rerum dolore et.	2025-08-16	16:00	3	pending	APT11279	\N
10281	281	5	2025-08-16 15:45:00	Routine Checkup	OPD	Beatae nobis magnam provident totam pariatur iure.	2025-06-26 22:30:08	2025-06-26 22:30:08	107/84	91	99.0	100	78	Aliquam aperiam nisi accusamus vitae saepe.	Nostrum perferendis dolores provident corrupti.	2025-09-01	Exercitationem aliquam aliquid corrupti.	2025-08-16	15:45	3	pending	APT11280	\N
10282	144	9	2025-08-16 14:45:00	High BP	Follow-up	Tempora quae est incidunt mollitia.	2025-06-26 22:30:08	2025-06-26 22:30:08	135/65	97	99.0	99	78	Ea in quasi cumque voluptatum excepturi alias.	Natus libero maxime iure reiciendis aut perferendis.	2025-09-10	Eaque soluta asperiores assumenda dolorum a aspernatur.	2025-08-16	14:45	3	pending	APT11281	\N
10283	197	5	2025-08-16 13:15:00	Back Pain	Follow-up	Consequuntur suscipit id reiciendis.	2025-06-26 22:30:08	2025-06-26 22:30:08	140/83	89	98.8	95	74	A totam voluptatibus dignissimos minima tempora dicta.	Necessitatibus iure saepe deserunt sed dolore porro architecto.	2025-08-23	Tenetur eos voluptate illo voluptatem temporibus.	2025-08-16	13:15	3	pending	APT11282	\N
10284	443	6	2025-08-16 15:45:00	Back Pain	New	Unde optio vero ratione cum quisquam sequi.	2025-06-26 22:30:08	2025-06-26 22:30:08	126/72	89	97.6	97	85	Quaerat inventore asperiores.	Asperiores accusamus eveniet dolorum doloribus ipsam illo suscipit odio.	2025-09-06	Culpa dolor possimus voluptatem sed debitis repellat inventore.	2025-08-16	15:45	3	pending	APT11283	\N
10285	257	9	2025-08-16 15:45:00	Skin Rash	New	Ex et dolore reiciendis.	2025-06-26 22:30:08	2025-06-26 22:30:08	108/68	96	99.6	96	79	Quisquam minus inventore vitae.	Distinctio cumque ducimus magnam atque atque.	2025-09-13	Quibusdam ut magnam quos quisquam.	2025-08-16	15:45	3	pending	APT11284	\N
10286	373	6	2025-08-16 15:15:00	Headache	OPD	Odio pariatur doloribus quidem pariatur ex sed.	2025-06-26 22:30:08	2025-06-26 22:30:08	105/78	98	100.1	98	73	Magni vel animi neque mollitia.	Veritatis rem reprehenderit et pariatur eaque nisi animi fugit.	2025-09-07	Sapiente ipsam id.	2025-08-16	15:15	3	pending	APT11285	\N
10287	345	6	2025-08-16 12:45:00	Fever	New	Illum aut animi alias.	2025-06-26 22:30:08	2025-06-26 22:30:08	134/90	94	98.2	95	70	Ad at consectetur. Sint vel nisi debitis.	Dignissimos dolorem ipsum doloremque at deserunt facilis.	2025-09-05	Ullam consequatur incidunt nostrum alias voluptatibus eligendi voluptate.	2025-08-16	12:45	3	pending	APT11286	\N
10288	74	9	2025-08-16 14:15:00	Diabetes Check	Emergency	Fugiat recusandae facere.	2025-06-26 22:30:08	2025-06-26 22:30:08	118/74	90	98.7	95	66	Blanditiis soluta sit non.	Asperiores ullam esse tempore deserunt ipsa accusamus.	2025-09-10	Neque recusandae similique aspernatur nemo ab nisi nihil.	2025-08-16	14:15	3	pending	APT11287	\N
10289	270	7	2025-08-16 13:15:00	Back Pain	OPD	Quos sunt quasi iste nisi inventore et.	2025-06-26 22:30:08	2025-06-26 22:30:08	130/88	81	100.3	95	84	Inventore explicabo odio iusto reiciendis.	Placeat ea neque vero quas fugit suscipit accusantium provident.	2025-08-26	Nihil fuga atque doloribus.	2025-08-16	13:15	3	pending	APT11288	\N
10290	384	7	2025-08-16 14:15:00	Diabetes Check	Follow-up	Cupiditate harum neque.	2025-06-26 22:30:08	2025-06-26 22:30:08	111/68	73	98.8	100	74	Voluptatem rerum unde dolores.	Reiciendis praesentium eum et nisi nam minima quia.	2025-08-29	Corrupti rerum excepturi provident suscipit tempora totam.	2025-08-16	14:15	3	pending	APT11289	\N
10291	189	8	2025-08-16 14:30:00	Routine Checkup	Emergency	Optio odio non veritatis eius.	2025-06-26 22:30:08	2025-06-26 22:30:08	101/60	92	99.0	97	56	Quasi cumque magni inventore sed sunt magnam.	Minus ut totam illum explicabo praesentium cupiditate quae neque.	2025-09-06	Debitis esse minus occaecati.	2025-08-16	14:30	3	pending	APT11290	\N
10292	278	10	2025-08-17 16:30:00	Diabetes Check	Emergency	Iure voluptas aut.	2025-06-26 22:30:08	2025-06-26 22:30:08	110/90	83	100.1	97	82	Minima eum impedit. Velit sit eum at.	Soluta placeat illo cum modi libero.	2025-09-08	Facere consequatur accusamus nisi quisquam laboriosam illum.	2025-08-17	16:30	3	pending	APT11291	\N
10293	153	6	2025-08-17 14:00:00	Cough	OPD	Illo perspiciatis commodi blanditiis dolor vero.	2025-06-26 22:30:08	2025-06-26 22:30:08	137/84	82	98.2	99	76	Facilis placeat vel molestias ratione laudantium odio.	Quas adipisci voluptates saepe dolores excepturi rerum.	2025-09-12	Quod pariatur expedita ea error harum praesentium.	2025-08-17	14:00	3	pending	APT11292	\N
10294	135	4	2025-08-17 15:45:00	Back Pain	OPD	Consectetur commodi sed beatae.	2025-06-26 22:30:08	2025-06-26 22:30:08	103/74	81	99.2	96	56	Molestias dignissimos ducimus quas animi vel.	Possimus quibusdam corporis eveniet eligendi suscipit.	2025-08-28	Commodi quae at dolorem consequuntur modi quas.	2025-08-17	15:45	3	pending	APT11293	\N
10295	222	10	2025-08-17 12:30:00	Fever	OPD	Earum aperiam officia nesciunt itaque magni aperiam.	2025-06-26 22:30:08	2025-06-26 22:30:08	111/62	75	99.6	97	69	Accusantium id iure occaecati reprehenderit blanditiis sit.	Laboriosam dolores sint dolore.	2025-09-12	Corporis culpa rerum dolore nobis.	2025-08-17	12:30	3	pending	APT11294	\N
10296	234	8	2025-08-17 11:15:00	High BP	OPD	Hic recusandae ducimus vero veritatis ipsam aliquam nobis.	2025-06-26 22:30:08	2025-06-26 22:30:08	103/80	93	99.2	98	80	Sapiente dolore porro excepturi suscipit vero.	Mollitia ipsam reprehenderit ipsam sunt deserunt illum nemo expedita distinctio nemo.	2025-08-25	Tempore quod tenetur repellendus error neque enim.	2025-08-17	11:15	3	pending	APT11295	\N
10297	143	5	2025-08-17 13:00:00	High BP	Emergency	Ducimus quis ratione.	2025-06-26 22:30:08	2025-06-26 22:30:08	101/82	76	100.4	96	64	Amet eos labore impedit ratione.	Dolorem dolorem quaerat molestias atque omnis non pariatur cupiditate doloribus.	2025-09-10	Repudiandae quis tempore enim laboriosam.	2025-08-17	13:00	3	pending	APT11296	\N
10298	435	6	2025-08-17 16:00:00	Diabetes Check	OPD	Quae explicabo non delectus natus dolorem.	2025-06-26 22:30:08	2025-06-26 22:30:08	102/72	83	97.7	100	67	Quam aut atque distinctio possimus.	Natus autem dolores quod iste tenetur dolore tempore neque qui.	2025-08-29	Esse hic repudiandae nisi voluptatem.	2025-08-17	16:00	3	pending	APT11297	\N
10299	45	4	2025-08-17 14:45:00	Routine Checkup	Follow-up	Voluptatibus consequuntur nihil repellendus sed fuga.	2025-06-26 22:30:08	2025-06-26 22:30:08	114/89	87	99.7	97	76	Maiores excepturi repellendus unde libero.	Nam libero animi ex mollitia.	2025-09-15	Repudiandae quis fuga vel facere dicta eveniet.	2025-08-17	14:45	3	pending	APT11298	\N
10300	14	9	2025-08-17 12:00:00	Back Pain	Follow-up	Harum ducimus itaque deleniti cupiditate.	2025-06-26 22:30:08	2025-06-26 22:30:08	112/82	97	98.3	98	69	Adipisci provident recusandae suscipit enim.	Possimus omnis doloremque sed at.	2025-08-26	Saepe fugiat excepturi accusamus eos debitis libero.	2025-08-17	12:00	3	pending	APT11299	\N
10301	295	10	2025-08-17 16:45:00	Diabetes Check	New	Ipsum aliquam aut repellendus voluptas asperiores molestias.	2025-06-26 22:30:08	2025-06-26 22:30:08	140/65	91	98.1	95	62	Illo tempore quibusdam tempore.	Quam iusto temporibus voluptas eligendi maiores veritatis minus.	2025-08-28	Perferendis vero deserunt id qui ratione.	2025-08-17	16:45	3	pending	APT11300	\N
10302	271	3	2025-08-17 11:15:00	Fever	Emergency	Placeat vero aut dolor delectus laudantium.	2025-06-26 22:30:08	2025-06-26 22:30:08	104/76	74	99.8	98	60	Aperiam at at quaerat cupiditate magnam.	Dolore repudiandae eveniet sunt sit id molestiae.	2025-09-10	Odio ab delectus occaecati voluptate.	2025-08-17	11:15	3	pending	APT11301	\N
10303	151	10	2025-08-17 15:00:00	Fever	OPD	Est consequatur dolorem culpa voluptate.	2025-06-26 22:30:08	2025-06-26 22:30:08	125/81	79	99.4	100	79	Ut suscipit libero eligendi.	Voluptatibus aperiam beatae ut laudantium impedit harum delectus.	2025-09-10	Tempore rem dolor nisi.	2025-08-17	15:00	3	pending	APT11302	\N
10304	88	8	2025-08-17 14:45:00	Routine Checkup	Follow-up	Perferendis sit assumenda eum modi iusto quo.	2025-06-26 22:30:08	2025-06-26 22:30:08	109/70	95	97.9	96	83	Unde unde molestias doloribus.	Tempore quis occaecati sequi quam animi nihil nesciunt.	2025-08-30	Possimus fugiat adipisci dolor sapiente recusandae veniam.	2025-08-17	14:45	3	pending	APT11303	\N
10955	225	5	2025-09-13 11:15:00	Skin Rash	Follow-up	Cum dolor qui.	2025-06-26 22:30:08	2025-06-26 22:30:08	114/90	81	98.6	96	73	A maiores quaerat aperiam.	Ex tenetur tenetur numquam aliquid dolor.	2025-09-27	Facilis labore quo libero similique repellendus.	2025-09-13	11:15	3	pending	APT11954	\N
10305	252	9	2025-08-17 16:15:00	Back Pain	OPD	Explicabo harum quos fugit dolorem.	2025-06-26 22:30:08	2025-06-26 22:30:08	123/69	89	100.3	100	68	Laudantium velit architecto libero fugit aut.	Porro possimus non perspiciatis nisi voluptas.	2025-09-09	Maiores vero molestias at natus numquam et.	2025-08-17	16:15	3	pending	APT11304	\N
10306	368	8	2025-08-17 11:15:00	Skin Rash	OPD	Doloremque dignissimos illum.	2025-06-26 22:30:08	2025-06-26 22:30:08	107/76	86	100.3	99	70	Dolorem impedit totam magnam harum.	Accusamus eum similique nisi cum.	2025-09-06	Ipsa doloribus rerum provident esse facere.	2025-08-17	11:15	3	pending	APT11305	\N
10307	166	9	2025-08-17 16:15:00	Skin Rash	Emergency	Temporibus facilis ea aperiam recusandae.	2025-06-26 22:30:08	2025-06-26 22:30:08	135/74	77	98.9	95	57	Illum quod non aliquam iure laborum.	Expedita illum possimus sint deleniti deserunt voluptate.	2025-09-03	Consequuntur nesciunt totam officiis eveniet porro.	2025-08-17	16:15	3	pending	APT11306	\N
10308	169	6	2025-08-17 11:30:00	Cough	OPD	Deleniti possimus aspernatur quasi sapiente.	2025-06-26 22:30:08	2025-06-26 22:30:08	110/87	67	100.0	100	61	Maiores voluptatem porro. Dicta beatae consectetur error.	Recusandae sapiente dolorem delectus debitis blanditiis.	2025-09-09	Harum unde eum possimus facere minus.	2025-08-17	11:30	3	pending	APT11307	\N
10309	244	3	2025-08-17 16:45:00	Cough	New	Voluptatum et dolor.	2025-06-26 22:30:08	2025-06-26 22:30:08	114/90	76	100.5	98	60	Voluptates repudiandae incidunt itaque.	Sequi sint suscipit dicta id autem rem.	2025-09-04	Totam consequatur tempore exercitationem.	2025-08-17	16:45	3	pending	APT11308	\N
10310	52	4	2025-08-17 11:15:00	Back Pain	Follow-up	Id perspiciatis expedita sunt.	2025-06-26 22:30:08	2025-06-26 22:30:08	117/86	73	98.0	99	80	Blanditiis tempora odit nemo voluptatibus occaecati atque.	Pariatur impedit iusto necessitatibus earum alias.	2025-09-16	Adipisci dolores sit tempore numquam repellendus velit.	2025-08-17	11:15	3	pending	APT11309	\N
10311	83	5	2025-08-17 12:00:00	Diabetes Check	OPD	Doloremque recusandae nisi expedita aut fugit.	2025-06-26 22:30:08	2025-06-26 22:30:08	135/65	79	97.7	97	56	Iusto commodi illo voluptatibus iure perspiciatis dolores.	Labore aliquam corrupti rem molestiae ut id laborum cumque dicta.	2025-09-15	Ipsa rerum incidunt ullam.	2025-08-17	12:00	3	pending	APT11310	\N
10312	41	5	2025-08-17 16:15:00	Skin Rash	Emergency	Optio similique voluptate necessitatibus doloremque.	2025-06-26 22:30:08	2025-06-26 22:30:08	112/76	77	97.8	98	82	Voluptatibus sunt nesciunt id eum.	A ducimus blanditiis non quis dolorem.	2025-09-14	Nam nihil fuga omnis nihil.	2025-08-17	16:15	3	pending	APT11311	\N
10313	39	7	2025-08-18 14:15:00	Fever	Emergency	Aliquam cumque quibusdam voluptate.	2025-06-26 22:30:08	2025-06-26 22:30:08	133/80	94	98.2	98	64	Excepturi voluptas quod quia enim quos.	Quisquam velit cupiditate vel animi deleniti voluptatibus fugiat odit repellat.	2025-09-14	Accusantium enim labore beatae ex explicabo.	2025-08-18	14:15	3	pending	APT11312	\N
10314	52	4	2025-08-18 14:45:00	Cough	Emergency	Unde dolores cupiditate laudantium voluptatem quae.	2025-06-26 22:30:08	2025-06-26 22:30:08	129/63	92	100.4	95	76	Voluptas tenetur laboriosam commodi repellat.	Veniam cupiditate aut dolores expedita inventore laudantium sint sint.	2025-09-14	Itaque corrupti numquam quos.	2025-08-18	14:45	3	pending	APT11313	\N
10315	210	9	2025-08-18 13:15:00	Headache	OPD	Nisi praesentium consequatur iure veniam quis a.	2025-06-26 22:30:08	2025-06-26 22:30:08	127/87	77	99.8	95	81	Nobis recusandae suscipit laborum ut nemo fuga aliquam.	Qui repudiandae repellat officia cupiditate odio aspernatur id accusantium impedit.	2025-08-27	Repellat nam cumque dolores quaerat.	2025-08-18	13:15	3	pending	APT11314	\N
10316	259	6	2025-08-18 14:00:00	High BP	Emergency	Dolorem quaerat in impedit earum.	2025-06-26 22:30:08	2025-06-26 22:30:08	114/64	95	99.4	98	81	Odit quos porro earum.	Numquam blanditiis tenetur tenetur alias officia deleniti quam.	2025-09-01	Pariatur reiciendis maxime dignissimos natus amet.	2025-08-18	14:00	3	pending	APT11315	\N
10317	327	10	2025-08-18 12:15:00	Back Pain	New	Omnis repellat delectus atque.	2025-06-26 22:30:08	2025-06-26 22:30:08	138/71	75	97.9	95	56	Nemo iusto atque quasi nulla vero quia dolore.	Repellendus quia libero aspernatur excepturi.	2025-08-29	Illo dolor facilis et alias placeat in.	2025-08-18	12:15	3	pending	APT11316	\N
10318	215	3	2025-08-18 16:15:00	Routine Checkup	New	Et perferendis occaecati culpa voluptates libero.	2025-06-26 22:30:08	2025-06-26 22:30:08	136/90	81	100.4	100	58	Est cupiditate expedita. Odio totam sint.	Omnis qui ea mollitia velit necessitatibus aspernatur unde provident magni.	2025-08-31	Aliquam libero deserunt asperiores accusamus facere.	2025-08-18	16:15	3	pending	APT11317	\N
10319	488	10	2025-08-18 12:15:00	Routine Checkup	Follow-up	Quaerat quidem similique sit dolorum.	2025-06-26 22:30:08	2025-06-26 22:30:08	136/73	86	99.4	100	78	Quisquam voluptates sint maxime impedit placeat.	Consequuntur ad explicabo nisi consequatur fuga omnis ducimus.	2025-09-15	Blanditiis dolore vero ipsam voluptatum consequuntur saepe.	2025-08-18	12:15	3	pending	APT11318	\N
10320	217	3	2025-08-18 16:15:00	Back Pain	Emergency	Explicabo quas dicta rerum adipisci atque voluptas.	2025-06-26 22:30:08	2025-06-26 22:30:08	110/69	87	100.5	95	74	Aspernatur eius quae consequatur laborum in beatae.	Fugiat neque nam est et optio.	2025-09-05	Et sapiente aspernatur sunt voluptas occaecati est necessitatibus.	2025-08-18	16:15	3	pending	APT11319	\N
10321	414	10	2025-08-18 15:45:00	Back Pain	Emergency	Illum molestiae exercitationem expedita vitae animi magnam.	2025-06-26 22:30:08	2025-06-26 22:30:08	109/73	74	99.0	95	78	Nihil omnis quisquam ipsum ea error.	Autem quo pariatur recusandae totam doloribus.	2025-09-12	Soluta ducimus corporis hic.	2025-08-18	15:45	3	pending	APT11320	\N
10322	417	7	2025-08-18 16:15:00	Diabetes Check	OPD	Adipisci at sequi.	2025-06-26 22:30:08	2025-06-26 22:30:08	121/65	67	99.9	95	84	Magnam quasi corrupti temporibus molestias culpa.	Aspernatur delectus hic laboriosam ad porro.	2025-09-05	Nam vero nisi explicabo.	2025-08-18	16:15	3	pending	APT11321	\N
10323	253	7	2025-08-18 16:15:00	Headache	Emergency	Eligendi repellendus excepturi aperiam.	2025-06-26 22:30:08	2025-06-26 22:30:08	117/68	87	98.5	100	79	Culpa amet assumenda ab itaque quaerat accusamus.	Eos modi quod expedita dolore illo mollitia qui.	2025-09-06	Voluptatum quos veniam deleniti recusandae corrupti soluta.	2025-08-18	16:15	3	pending	APT11322	\N
10324	158	7	2025-08-18 12:30:00	High BP	New	A suscipit vitae quis quibusdam harum.	2025-06-26 22:30:08	2025-06-26 22:30:08	139/82	97	99.3	100	71	Assumenda inventore officiis deleniti amet ex nulla.	Corporis quia non assumenda cumque dolor saepe.	2025-09-07	Nostrum officiis repellat pariatur.	2025-08-18	12:30	3	pending	APT11323	\N
10325	97	4	2025-08-18 15:30:00	Diabetes Check	Follow-up	Minima aut natus minima perspiciatis.	2025-06-26 22:30:08	2025-06-26 22:30:08	127/82	91	97.6	97	74	Quia sit earum magni dolores.	Dolore incidunt nulla similique harum voluptates cupiditate recusandae.	2025-09-12	Sed odit dolorum voluptate cumque id repudiandae.	2025-08-18	15:30	3	pending	APT11324	\N
10326	160	7	2025-08-18 14:15:00	Cough	OPD	Ducimus atque ab numquam non.	2025-06-26 22:30:08	2025-06-26 22:30:08	130/87	68	99.3	100	57	Cum fugiat distinctio molestias consectetur.	Illum commodi impedit eum nam voluptates est cum itaque neque perspiciatis.	2025-09-07	Tempore temporibus autem vitae quae quibusdam.	2025-08-18	14:15	3	pending	APT11325	\N
10327	17	5	2025-08-18 11:00:00	High BP	Emergency	Voluptatibus porro odit eius.	2025-06-26 22:30:08	2025-06-26 22:30:08	138/86	84	99.7	98	84	Mollitia laborum natus ab officiis ipsa.	Praesentium perspiciatis dolorum ab et cupiditate.	2025-09-06	Sint tempora reiciendis rem eius earum aspernatur.	2025-08-18	11:00	3	pending	APT11326	\N
10328	310	8	2025-08-18 12:45:00	Headache	OPD	Assumenda eius magni nemo vel aperiam temporibus.	2025-06-26 22:30:08	2025-06-26 22:30:08	116/68	80	98.5	99	55	Quisquam perferendis in labore animi voluptatibus.	Voluptatem corrupti tempora quidem doloremque maxime.	2025-09-16	Ad iure adipisci dignissimos facilis quas quia.	2025-08-18	12:45	3	pending	APT11327	\N
10329	311	6	2025-08-18 14:15:00	Cough	Emergency	Quidem esse aspernatur voluptate.	2025-06-26 22:30:08	2025-06-26 22:30:08	136/65	83	99.7	97	72	Debitis veniam eveniet doloremque cum ad.	Possimus architecto et explicabo nisi.	2025-09-14	Ipsum esse impedit ducimus occaecati quidem repellat.	2025-08-18	14:15	3	pending	APT11328	\N
10330	340	6	2025-08-18 15:00:00	Skin Rash	OPD	Adipisci quia officiis ducimus incidunt alias maxime placeat.	2025-06-26 22:30:08	2025-06-26 22:30:08	140/60	69	97.7	95	57	Ipsa qui adipisci delectus placeat.	Dignissimos placeat voluptatem cupiditate placeat voluptatum ipsum.	2025-09-14	Iste repellat praesentium quia.	2025-08-18	15:00	3	pending	APT11329	\N
10331	99	5	2025-08-18 16:45:00	Fever	Follow-up	Error odio repellat modi incidunt a.	2025-06-26 22:30:08	2025-06-26 22:30:08	130/82	82	99.7	99	78	Pariatur officiis maiores magni nisi amet a.	Nesciunt mollitia quo consequuntur nostrum officia ullam cumque.	2025-09-07	Eum ex officia aspernatur minima sunt.	2025-08-18	16:45	3	pending	APT11330	\N
10332	282	7	2025-08-18 11:00:00	Diabetes Check	Emergency	Eligendi recusandae architecto molestiae asperiores odit voluptatum ab.	2025-06-26 22:30:08	2025-06-26 22:30:08	122/79	67	100.1	98	79	Porro nulla cumque fugit exercitationem.	Animi totam maxime tempore recusandae asperiores totam molestiae tempore cupiditate.	2025-09-02	Doloremque facilis architecto.	2025-08-18	11:00	3	pending	APT11331	\N
10333	303	3	2025-08-18 14:15:00	Back Pain	New	Reiciendis illo voluptatem dolorum.	2025-06-26 22:30:08	2025-06-26 22:30:08	117/65	93	100.3	97	59	Rem pariatur maiores asperiores. Blanditiis modi ut.	Molestiae reprehenderit quisquam aliquid rem.	2025-09-03	Maiores nulla dolorum perferendis excepturi est eveniet.	2025-08-18	14:15	3	pending	APT11332	\N
10334	339	10	2025-08-18 12:15:00	Cough	Emergency	Facere deleniti doloribus recusandae non.	2025-06-26 22:30:08	2025-06-26 22:30:08	104/67	67	99.0	98	81	Quod odit assumenda corporis magni optio.	Quia maiores commodi quas delectus.	2025-08-29	Quis tempora assumenda eius modi pariatur quidem doloremque.	2025-08-18	12:15	3	pending	APT11333	\N
10335	460	7	2025-08-18 14:00:00	Routine Checkup	OPD	Iste suscipit placeat suscipit.	2025-06-26 22:30:08	2025-06-26 22:30:08	104/70	72	99.8	100	60	Eveniet consectetur repellat illum vero alias itaque culpa.	Labore laboriosam voluptas doloremque suscipit occaecati.	2025-09-07	Fugit consectetur consequatur nihil ducimus nostrum repudiandae.	2025-08-18	14:00	3	pending	APT11334	\N
10336	209	8	2025-08-18 15:45:00	High BP	Emergency	Repellendus repellendus praesentium esse.	2025-06-26 22:30:08	2025-06-26 22:30:08	105/81	93	98.4	96	76	Odit sapiente vitae odio nemo fugiat dolorum.	Ipsa ipsa saepe porro aliquid quo veniam nesciunt dignissimos in.	2025-09-04	Animi nesciunt error minima occaecati.	2025-08-18	15:45	3	pending	APT11335	\N
10337	396	6	2025-08-18 12:45:00	Fever	Emergency	Quod non et corporis aliquid blanditiis quod.	2025-06-26 22:30:08	2025-06-26 22:30:08	119/82	70	99.2	100	77	Animi aliquam laudantium voluptas sunt velit sit.	Incidunt perferendis temporibus et doloribus vero eos laboriosam quisquam labore.	2025-09-06	Doloribus enim inventore libero beatae eveniet.	2025-08-18	12:45	3	pending	APT11336	\N
10338	263	9	2025-08-18 15:15:00	Cough	Follow-up	A quisquam at repudiandae vel excepturi.	2025-06-26 22:30:08	2025-06-26 22:30:08	112/73	93	100.0	96	57	Quaerat dolorem voluptate asperiores molestiae amet.	Cupiditate molestiae ea voluptate debitis nisi ab placeat.	2025-09-05	Nihil repudiandae maxime distinctio eveniet.	2025-08-18	15:15	3	pending	APT11337	\N
10339	90	6	2025-08-18 11:15:00	Diabetes Check	Emergency	Iusto provident itaque earum et.	2025-06-26 22:30:08	2025-06-26 22:30:08	113/82	93	97.9	96	67	Excepturi reiciendis quibusdam aliquid voluptatibus.	Delectus pariatur praesentium quam cumque cumque.	2025-08-30	Omnis consectetur quam.	2025-08-18	11:15	3	pending	APT11338	\N
10340	431	9	2025-08-18 14:30:00	Back Pain	New	Explicabo veniam dignissimos non a doloribus.	2025-06-26 22:30:08	2025-06-26 22:30:08	121/86	67	99.2	99	61	Magnam delectus minus nam atque nobis cumque.	Exercitationem perferendis omnis voluptatum repellat deleniti odio quasi labore sint.	2025-08-29	Expedita illum cumque maiores.	2025-08-18	14:30	3	pending	APT11339	\N
10341	430	8	2025-08-18 11:30:00	Diabetes Check	Follow-up	Laborum eaque nisi maiores.	2025-06-26 22:30:08	2025-06-26 22:30:08	112/85	74	97.5	95	56	Deleniti sequi illo laudantium.	Minus nemo expedita sapiente accusantium nemo ipsa commodi aut.	2025-09-12	Autem minima vero maxime omnis vel commodi.	2025-08-18	11:30	3	pending	APT11340	\N
10342	212	4	2025-08-19 13:45:00	High BP	Emergency	Alias laudantium eveniet.	2025-06-26 22:30:08	2025-06-26 22:30:08	112/75	87	97.5	99	59	Corporis quas molestiae necessitatibus similique ducimus.	Accusantium rem animi atque laborum expedita voluptate soluta qui.	2025-09-18	Ipsam ullam commodi odio illo sint modi.	2025-08-19	13:45	3	pending	APT11341	\N
10343	234	7	2025-08-19 14:45:00	Cough	Follow-up	Eaque tempora fugiat.	2025-06-26 22:30:08	2025-06-26 22:30:08	136/73	90	98.9	95	63	Animi voluptas recusandae ad deleniti.	Eos assumenda laborum cumque omnis molestiae quisquam ipsum.	2025-08-30	Nihil officiis dolores aliquam tempora veritatis inventore quas.	2025-08-19	14:45	3	pending	APT11342	\N
10344	203	4	2025-08-19 13:15:00	High BP	New	Sit incidunt alias molestias magnam ex.	2025-06-26 22:30:08	2025-06-26 22:30:08	117/86	78	100.3	95	76	Optio a iure.	Recusandae vel ullam ea necessitatibus repellendus error labore.	2025-09-16	In iusto doloribus numquam eveniet voluptatibus.	2025-08-19	13:15	3	pending	APT11343	\N
10345	438	3	2025-08-19 12:45:00	Back Pain	OPD	Occaecati nobis a enim.	2025-06-26 22:30:08	2025-06-26 22:30:08	137/78	76	99.2	96	84	At quos id exercitationem temporibus hic ipsam id.	Beatae reprehenderit impedit nemo illo dolorem illum rem.	2025-09-15	Culpa quasi odio voluptates.	2025-08-19	12:45	3	pending	APT11344	\N
10346	176	9	2025-08-19 14:30:00	Headache	Follow-up	Laborum facere repellendus.	2025-06-26 22:30:08	2025-06-26 22:30:08	101/81	87	98.8	99	79	Ea ad magnam soluta possimus laboriosam.	Neque sunt quam doloremque similique voluptates.	2025-08-31	Soluta ad sint dignissimos explicabo sint vitae.	2025-08-19	14:30	3	pending	APT11345	\N
10347	233	8	2025-08-19 16:00:00	Back Pain	New	Modi neque eveniet necessitatibus.	2025-06-26 22:30:08	2025-06-26 22:30:08	124/76	92	100.0	100	72	Mollitia pariatur sit culpa rem. Quos quasi neque quos sit.	Nulla quae hic praesentium est nam necessitatibus deserunt asperiores ex.	2025-09-17	Perferendis voluptatem illum placeat dolorem cum.	2025-08-19	16:00	3	pending	APT11346	\N
10348	350	7	2025-08-19 11:00:00	Headache	Emergency	Voluptatibus placeat consequatur nulla numquam repellat nam qui.	2025-06-26 22:30:08	2025-06-26 22:30:08	100/83	70	99.8	95	79	Earum dignissimos ratione nihil quaerat.	Temporibus ea nihil iusto ducimus est sapiente dolor.	2025-09-04	Tempore voluptatibus similique.	2025-08-19	11:00	3	pending	APT11347	\N
10349	495	9	2025-08-19 14:15:00	Diabetes Check	Follow-up	Ex natus sunt possimus ad saepe tempore.	2025-06-26 22:30:08	2025-06-26 22:30:08	101/79	83	99.4	95	69	Sit eius quas voluptas iure recusandae iusto.	Aliquid quaerat natus reiciendis beatae nisi culpa magni nulla accusantium ad.	2025-09-09	Ipsam ducimus asperiores nobis.	2025-08-19	14:15	3	pending	APT11348	\N
10350	117	4	2025-08-19 13:30:00	Routine Checkup	OPD	Ut commodi dignissimos enim nulla nesciunt dolorem consectetur.	2025-06-26 22:30:08	2025-06-26 22:30:08	109/65	86	98.8	96	59	Aliquam quam tenetur sunt.	Fuga asperiores architecto officiis fugiat nisi facere.	2025-09-17	Totam officiis aspernatur quasi voluptates voluptas voluptatibus.	2025-08-19	13:30	3	pending	APT11349	\N
10351	294	8	2025-08-19 13:45:00	Fever	New	Eius cum fugit aspernatur accusantium iusto.	2025-06-26 22:30:08	2025-06-26 22:30:08	105/81	85	99.2	96	76	Voluptates quis dolores illum eum ut quae.	Hic dignissimos totam quo voluptates.	2025-09-14	Quos exercitationem beatae deserunt.	2025-08-19	13:45	3	pending	APT11350	\N
10352	189	5	2025-08-19 12:00:00	Cough	OPD	Repellat magni soluta cumque.	2025-06-26 22:30:08	2025-06-26 22:30:08	134/73	78	98.3	95	63	Aut asperiores repellat nulla.	Magni exercitationem eveniet quod sit ab in.	2025-09-12	Minima reiciendis impedit nemo.	2025-08-19	12:00	3	pending	APT11351	\N
10353	194	9	2025-08-19 15:30:00	High BP	New	Possimus quo nesciunt magnam soluta accusamus consequatur voluptatem.	2025-06-26 22:30:08	2025-06-26 22:30:08	135/71	84	99.1	99	63	Soluta adipisci eius eius.	Amet impedit explicabo cupiditate molestiae.	2025-08-29	Id asperiores iure fuga veritatis.	2025-08-19	15:30	3	pending	APT11352	\N
10354	478	9	2025-08-19 15:00:00	Skin Rash	Follow-up	Dolorum reprehenderit provident exercitationem ex consectetur excepturi facere.	2025-06-26 22:30:08	2025-06-26 22:30:08	101/85	88	97.6	95	55	Autem ipsum expedita neque.	Dolore autem magni porro repudiandae totam magni voluptates magni perferendis.	2025-08-26	Rerum deleniti esse soluta eos esse illum.	2025-08-19	15:00	3	pending	APT11353	\N
10355	310	8	2025-08-19 16:00:00	Headache	OPD	Labore sint et hic assumenda quis numquam.	2025-06-26 22:30:08	2025-06-26 22:30:08	132/67	84	99.4	97	79	Odit mollitia totam quisquam.	Accusamus est illo ad iure sint veniam excepturi laboriosam.	2025-09-06	Voluptas earum et quas vitae.	2025-08-19	16:00	3	pending	APT11354	\N
10356	245	4	2025-08-19 12:30:00	High BP	OPD	Quis illum vitae.	2025-06-26 22:30:08	2025-06-26 22:30:08	107/80	65	99.9	96	71	Tenetur quae totam optio magni amet doloribus.	Eligendi libero quasi illo magni commodi.	2025-09-08	Corrupti autem veniam suscipit earum aut.	2025-08-19	12:30	3	pending	APT11355	\N
10357	170	10	2025-08-19 13:45:00	Back Pain	OPD	Repellat odio mollitia officiis aliquid labore.	2025-06-26 22:30:08	2025-06-26 22:30:08	105/72	68	100.1	97	77	Dicta unde dicta reprehenderit quod quam.	Dolorum libero harum voluptas repellendus id.	2025-08-30	Vitae tempora maxime nostrum nostrum eos.	2025-08-19	13:45	3	pending	APT11356	\N
10358	405	10	2025-08-19 13:15:00	Headache	New	Debitis sequi porro nemo quia.	2025-06-26 22:30:08	2025-06-26 22:30:08	109/67	74	99.3	97	75	Sed earum fuga impedit rerum explicabo.	Fuga minima iusto sit laboriosam ullam.	2025-09-13	Facilis consequatur minima temporibus.	2025-08-19	13:15	3	pending	APT11357	\N
10359	452	7	2025-08-19 13:45:00	Back Pain	New	Autem saepe nisi nostrum dicta omnis.	2025-06-26 22:30:08	2025-06-26 22:30:08	137/83	82	98.6	100	60	Neque cum nulla officiis repellat deserunt.	Perspiciatis modi voluptate dicta quae earum tempore laboriosam distinctio cum dolores.	2025-09-11	Qui placeat soluta ab consequuntur.	2025-08-19	13:45	3	pending	APT11358	\N
10360	467	4	2025-08-19 16:30:00	Routine Checkup	New	Culpa tenetur dolorem facere facilis ullam.	2025-06-26 22:30:08	2025-06-26 22:30:08	110/83	75	97.6	95	57	Eum commodi cumque. Sint natus aperiam non veniam.	Repellendus magni nisi quaerat est dignissimos.	2025-08-26	Magni autem sapiente.	2025-08-19	16:30	3	pending	APT11359	\N
10361	25	8	2025-08-19 11:00:00	Routine Checkup	Follow-up	Doloremque ab assumenda ex aut.	2025-06-26 22:30:08	2025-06-26 22:30:08	112/70	96	99.3	98	85	Assumenda soluta occaecati dolorem veritatis.	Dolore itaque vel facilis quis laudantium delectus consequatur aliquid hic.	2025-09-14	Doloribus neque ex sapiente sapiente eligendi similique.	2025-08-19	11:00	3	pending	APT11360	\N
10362	270	7	2025-08-19 15:45:00	Routine Checkup	Follow-up	Molestiae ducimus placeat maiores facilis.	2025-06-26 22:30:08	2025-06-26 22:30:08	118/89	100	100.0	97	62	Quo porro ipsum libero ut quasi adipisci.	Quis eveniet culpa officiis possimus.	2025-08-30	Dicta consectetur ipsum quasi voluptatum dolore.	2025-08-19	15:45	3	pending	APT11361	\N
10363	359	4	2025-08-19 11:00:00	Routine Checkup	Emergency	Rem odio eligendi iste magnam.	2025-06-26 22:30:08	2025-06-26 22:30:08	101/83	70	97.9	99	79	Dolorum ex cum ad ut modi sit accusantium.	Quod nostrum quidem tempore quis repellat.	2025-08-28	Facilis quasi natus vel et eaque itaque commodi.	2025-08-19	11:00	3	pending	APT11362	\N
10364	13	7	2025-08-20 11:30:00	Skin Rash	New	Dicta autem aliquam quaerat.	2025-06-26 22:30:08	2025-06-26 22:30:08	135/72	76	98.1	100	67	Maiores enim unde molestiae natus quisquam.	Sint ab officiis officiis asperiores quibusdam atque eius.	2025-08-31	Architecto nisi aliquam ullam explicabo et minima.	2025-08-20	11:30	3	pending	APT11363	\N
10365	344	6	2025-08-20 14:00:00	Fever	Emergency	Tenetur debitis recusandae eius.	2025-06-26 22:30:08	2025-06-26 22:30:08	119/71	74	98.5	96	80	Consequatur voluptates ducimus excepturi perferendis.	Distinctio autem autem natus nisi quisquam explicabo.	2025-09-17	Officiis quod qui nam cupiditate illo.	2025-08-20	14:00	3	pending	APT11364	\N
10366	397	7	2025-08-20 14:45:00	High BP	Follow-up	Fugit autem labore.	2025-06-26 22:30:08	2025-06-26 22:30:08	138/86	70	99.5	96	75	Sed dicta ratione ducimus provident magnam.	Animi ducimus aliquid asperiores accusamus corrupti repellendus libero.	2025-09-16	Similique esse voluptatibus mollitia excepturi.	2025-08-20	14:45	3	pending	APT11365	\N
10367	310	7	2025-08-20 13:15:00	Cough	Follow-up	Veniam ipsa odio magnam adipisci.	2025-06-26 22:30:08	2025-06-26 22:30:08	121/82	65	98.1	96	56	Sunt nihil voluptatibus repellendus. Quam natus temporibus.	Officia id repellendus placeat facere nulla.	2025-09-01	Dolorem veniam delectus recusandae ullam non.	2025-08-20	13:15	3	pending	APT11366	\N
10368	31	4	2025-08-20 15:15:00	Routine Checkup	New	Nobis asperiores hic minus ipsam mollitia.	2025-06-26 22:30:08	2025-06-26 22:30:08	102/64	94	99.2	98	61	Accusamus delectus temporibus amet temporibus.	Quasi est est optio ducimus.	2025-08-31	Perspiciatis minima dolores laborum.	2025-08-20	15:15	3	pending	APT11367	\N
10369	448	10	2025-08-20 11:15:00	Back Pain	Emergency	Quis perferendis dolorum dicta quidem at voluptatem vero.	2025-06-26 22:30:08	2025-06-26 22:30:08	111/73	84	98.5	97	84	Dignissimos delectus temporibus sunt.	Officia odit animi impedit iusto adipisci.	2025-09-06	Eveniet molestiae aut explicabo culpa libero voluptatem.	2025-08-20	11:15	3	pending	APT11368	\N
10370	342	4	2025-08-20 14:00:00	Diabetes Check	OPD	Corporis totam molestiae repellat reiciendis.	2025-06-26 22:30:08	2025-06-26 22:30:08	118/84	76	98.7	98	78	Iure sint voluptate. Ullam dolore qui at.	Animi magnam recusandae voluptatem tempora quod animi.	2025-08-31	Temporibus veniam dignissimos.	2025-08-20	14:00	3	pending	APT11369	\N
10371	324	7	2025-08-20 13:15:00	Back Pain	Follow-up	Commodi temporibus corporis praesentium nesciunt placeat iusto.	2025-06-26 22:30:08	2025-06-26 22:30:08	120/66	99	98.1	96	69	Minima vero corrupti amet facilis numquam.	Nam maiores fuga expedita fugiat at.	2025-09-09	Officia nemo sequi eos quisquam molestias.	2025-08-20	13:15	3	pending	APT11370	\N
10372	226	10	2025-08-20 13:15:00	Diabetes Check	New	Sequi fuga quae officia consectetur in iusto.	2025-06-26 22:30:08	2025-06-26 22:30:08	111/64	67	100.1	100	60	Architecto blanditiis veniam magni quod consequuntur.	Consequatur nisi consectetur quo aut aliquam mollitia est.	2025-09-04	Cumque laboriosam exercitationem unde.	2025-08-20	13:15	3	pending	APT11371	\N
10373	402	8	2025-08-20 11:00:00	Cough	Emergency	Quisquam sequi culpa molestias recusandae iste maiores.	2025-06-26 22:30:08	2025-06-26 22:30:08	124/86	65	98.9	99	65	Voluptas dolorem quam molestias.	Asperiores corporis possimus debitis error esse temporibus laudantium nisi blanditiis.	2025-08-27	Veniam inventore excepturi quod ipsam itaque quis.	2025-08-20	11:00	3	pending	APT11372	\N
10374	501	9	2025-08-20 12:15:00	Cough	Follow-up	Aliquid dignissimos tenetur eveniet.	2025-06-26 22:30:08	2025-06-26 22:30:08	127/89	85	98.5	98	84	Commodi perspiciatis dolor impedit porro laudantium labore.	Qui neque animi aperiam alias laboriosam odio voluptates maiores libero.	2025-08-27	Distinctio facere incidunt.	2025-08-20	12:15	3	pending	APT11373	\N
10375	311	6	2025-08-20 14:00:00	Headache	OPD	Quaerat officiis necessitatibus incidunt ut beatae.	2025-06-26 22:30:08	2025-06-26 22:30:08	106/81	100	99.7	97	74	Sint veritatis est ab voluptate.	Numquam delectus officiis numquam harum enim dicta deleniti.	2025-09-04	Enim ad sapiente consequuntur sapiente adipisci enim.	2025-08-20	14:00	3	pending	APT11374	\N
10376	46	7	2025-08-20 16:00:00	Routine Checkup	New	Nam unde aspernatur sint ea iste a.	2025-06-26 22:30:08	2025-06-26 22:30:08	136/67	70	100.4	97	55	Quam numquam molestias aperiam. Rem deserunt optio cumque.	Dolore optio exercitationem beatae dicta quod dolor similique exercitationem.	2025-09-05	Pariatur voluptatibus assumenda labore fuga est dolore.	2025-08-20	16:00	3	pending	APT11375	\N
10377	203	9	2025-08-20 11:45:00	Back Pain	Emergency	Fugiat voluptatibus laboriosam ea quisquam molestias.	2025-06-26 22:30:08	2025-06-26 22:30:08	126/85	91	98.1	95	56	Deleniti quos qui dolores repellendus fugit doloribus.	Quo vitae at fuga.	2025-09-19	Illo ipsam architecto excepturi soluta nemo esse.	2025-08-20	11:45	3	pending	APT11376	\N
10378	174	4	2025-08-20 14:15:00	Routine Checkup	Follow-up	Sed dolorem neque laboriosam eveniet tempore adipisci facere.	2025-06-26 22:30:08	2025-06-26 22:30:08	124/78	79	99.2	99	72	Perspiciatis culpa reprehenderit error dolores mollitia.	Maiores ut iusto rem voluptate omnis sapiente.	2025-09-09	Quis qui atque vero distinctio reprehenderit sed.	2025-08-20	14:15	3	pending	APT11377	\N
10379	377	6	2025-08-20 16:45:00	High BP	Emergency	Excepturi dolorum illum quo labore consectetur possimus.	2025-06-26 22:30:08	2025-06-26 22:30:08	119/66	72	98.4	100	85	Dolor nemo architecto voluptatibus quis laboriosam.	Ex aspernatur ex praesentium aliquam deserunt recusandae voluptates vel facilis.	2025-09-12	Deserunt ad nostrum.	2025-08-20	16:45	3	pending	APT11378	\N
10380	287	3	2025-08-20 15:00:00	High BP	Emergency	Aliquid facere fuga dolorem.	2025-06-26 22:30:08	2025-06-26 22:30:08	111/70	93	98.6	95	76	Voluptates quos possimus eligendi laudantium quis.	Natus omnis sit quia neque quaerat exercitationem vitae alias.	2025-09-09	Assumenda voluptatibus porro aut magnam exercitationem vel.	2025-08-20	15:00	3	pending	APT11379	\N
10381	372	8	2025-08-20 15:45:00	Headache	Follow-up	Distinctio quo eum ea voluptas facilis eveniet.	2025-06-26 22:30:08	2025-06-26 22:30:08	114/69	86	98.1	97	57	Quasi eveniet placeat eius neque sed quod itaque.	Quis sapiente impedit veritatis voluptatum molestias hic natus dicta tempora.	2025-09-03	Doloribus officiis aperiam ab sapiente dolorum nobis.	2025-08-20	15:45	3	pending	APT11380	\N
10382	470	10	2025-08-20 16:30:00	Headache	New	Temporibus maiores vitae magnam esse mollitia corporis.	2025-06-26 22:30:08	2025-06-26 22:30:08	125/63	67	99.1	99	78	Ex repudiandae aliquam quis neque.	Et laborum minus corrupti sed ad dignissimos voluptates excepturi iure.	2025-09-05	Voluptatum eum quibusdam tempore molestiae.	2025-08-20	16:30	3	pending	APT11381	\N
10383	376	10	2025-08-20 16:00:00	Headache	OPD	Nihil culpa optio non temporibus aliquid quis molestias.	2025-06-26 22:30:08	2025-06-26 22:30:08	132/61	68	98.6	99	64	Illum omnis enim odit quidem minima.	Eos eos fugit ab magni deleniti temporibus dignissimos voluptatum.	2025-09-07	Nemo id ea libero officiis laudantium repellat.	2025-08-20	16:00	3	pending	APT11382	\N
10384	43	5	2025-08-20 13:45:00	Cough	New	Ad perspiciatis sit fuga ullam.	2025-06-26 22:30:08	2025-06-26 22:30:08	109/70	72	97.7	100	77	Iure laboriosam quisquam voluptate.	Cum pariatur quam deleniti voluptatem.	2025-09-10	Amet officia expedita cumque.	2025-08-20	13:45	3	pending	APT11383	\N
10385	252	10	2025-08-21 16:30:00	Headache	OPD	Dolore quae voluptate saepe autem ex.	2025-06-26 22:30:08	2025-06-26 22:30:08	101/86	98	100.0	95	75	Distinctio nihil sint quam repudiandae.	Facilis quo porro recusandae occaecati libero hic.	2025-09-08	Nam optio necessitatibus odit minus deleniti magni.	2025-08-21	16:30	3	pending	APT11384	\N
10386	282	9	2025-08-21 14:15:00	Skin Rash	OPD	Iure facilis et.	2025-06-26 22:30:08	2025-06-26 22:30:08	121/61	80	98.5	99	81	Perferendis blanditiis at totam cum eos dolorem.	Nihil incidunt facere unde dolore dolores rerum.	2025-09-16	Modi molestiae soluta dolores deleniti porro.	2025-08-21	14:15	3	pending	APT11385	\N
10387	402	8	2025-08-21 14:15:00	High BP	OPD	Deserunt ipsam voluptas amet.	2025-06-26 22:30:08	2025-06-26 22:30:08	139/79	94	97.8	96	72	Nam consectetur iste eius impedit nesciunt excepturi quis.	Ducimus reprehenderit eaque itaque dicta ut pariatur nulla.	2025-09-13	Hic doloribus vitae sit eum.	2025-08-21	14:15	3	pending	APT11386	\N
10388	483	9	2025-08-21 16:15:00	Cough	New	Consequuntur porro officia repudiandae.	2025-06-26 22:30:08	2025-06-26 22:30:08	100/73	71	99.1	100	59	Provident facere voluptatem ipsam mollitia provident.	Qui earum vitae assumenda ea quisquam vero maiores.	2025-09-11	Animi voluptatem alias cum nemo.	2025-08-21	16:15	3	pending	APT11387	\N
10389	33	6	2025-08-21 15:30:00	Cough	Emergency	Aperiam quis reiciendis repudiandae.	2025-06-26 22:30:08	2025-06-26 22:30:08	119/70	76	100.2	100	59	Quisquam dolore blanditiis porro.	Voluptates ut quaerat voluptatibus recusandae.	2025-09-09	Ratione provident sapiente inventore ut possimus cupiditate saepe.	2025-08-21	15:30	3	pending	APT11388	\N
10390	253	9	2025-08-21 15:15:00	Skin Rash	New	Aut labore aspernatur consequuntur repudiandae.	2025-06-26 22:30:08	2025-06-26 22:30:08	119/61	68	100.0	97	69	Magnam voluptatem quibusdam quasi expedita et itaque.	Reprehenderit aspernatur corporis porro accusantium fuga et nihil quia consequuntur.	2025-08-28	Maxime officia molestiae debitis doloribus mollitia dolorem culpa.	2025-08-21	15:15	3	pending	APT11389	\N
10391	197	7	2025-08-21 13:45:00	Diabetes Check	Follow-up	Ut sed et ad tempore necessitatibus blanditiis recusandae.	2025-06-26 22:30:08	2025-06-26 22:30:08	117/61	78	100.0	96	82	Mollitia impedit aspernatur sapiente odio distinctio.	Quisquam omnis repudiandae ut adipisci voluptate architecto quis explicabo numquam.	2025-09-16	Libero perferendis voluptatibus odio.	2025-08-21	13:45	3	pending	APT11390	\N
10392	63	8	2025-08-21 15:45:00	Headache	Emergency	Aliquid corrupti autem laboriosam facere voluptate.	2025-06-26 22:30:08	2025-06-26 22:30:08	134/89	99	98.3	98	74	Laboriosam tenetur fuga explicabo.	Hic amet assumenda at error vitae non suscipit corrupti.	2025-09-15	Vel aperiam dolores iste neque sit at nam.	2025-08-21	15:45	3	pending	APT11391	\N
10393	144	4	2025-08-21 13:45:00	Diabetes Check	Follow-up	Nostrum dolore similique aperiam quasi.	2025-06-26 22:30:08	2025-06-26 22:30:08	126/74	95	98.4	100	77	Voluptas nemo praesentium.	Possimus quos vitae soluta.	2025-09-02	Nostrum mollitia expedita minima ratione.	2025-08-21	13:45	3	pending	APT11392	\N
10394	499	5	2025-08-21 15:15:00	Fever	OPD	Omnis iusto consequatur velit quod mollitia.	2025-06-26 22:30:08	2025-06-26 22:30:08	126/75	85	98.2	95	72	Iusto est blanditiis placeat ipsam.	Reprehenderit aliquam iure alias vero rerum quasi rerum aliquam.	2025-09-10	Quos delectus sint illum eveniet assumenda nostrum.	2025-08-21	15:15	3	pending	APT11393	\N
10395	32	5	2025-08-21 13:15:00	Routine Checkup	OPD	Nemo expedita repellat.	2025-06-26 22:30:08	2025-06-26 22:30:08	125/85	85	99.2	100	60	Quae amet harum provident veniam.	Recusandae velit perferendis totam iste earum quos pariatur accusamus sed.	2025-09-20	Est neque commodi dicta laudantium ut.	2025-08-21	13:15	3	pending	APT11394	\N
10396	228	8	2025-08-21 16:15:00	Diabetes Check	New	Velit vel mollitia aliquid.	2025-06-26 22:30:08	2025-06-26 22:30:08	133/79	87	98.7	97	83	Voluptatum ipsam rerum corporis nam.	Eligendi ducimus eos laudantium in unde enim maxime blanditiis laudantium.	2025-08-31	Accusantium inventore in aut tempore ratione.	2025-08-21	16:15	3	pending	APT11395	\N
10397	261	9	2025-08-21 15:30:00	Cough	Emergency	Pariatur iusto repellat expedita ipsum velit.	2025-06-26 22:30:08	2025-06-26 22:30:08	117/84	86	98.5	95	55	At labore ex nesciunt animi animi quasi.	Nulla iusto aspernatur numquam mollitia id ipsam.	2025-09-09	Corporis itaque ipsa in quam.	2025-08-21	15:30	3	pending	APT11396	\N
10398	233	7	2025-08-21 15:30:00	High BP	New	Vel fugit corrupti vel cupiditate ad doloribus nemo.	2025-06-26 22:30:08	2025-06-26 22:30:08	140/71	74	98.4	97	62	Quidem voluptatum nobis et tenetur.	Autem voluptas magni voluptate deleniti numquam sapiente dolores repellat rem autem.	2025-09-02	Magnam laboriosam est officia ex eligendi.	2025-08-21	15:30	3	pending	APT11397	\N
10399	74	7	2025-08-21 11:30:00	Routine Checkup	OPD	Nobis cupiditate quod doloribus cum culpa.	2025-06-26 22:30:08	2025-06-26 22:30:08	119/77	69	100.2	99	65	Error libero dolor animi deleniti.	Nulla natus labore expedita ex ipsum.	2025-09-11	Temporibus assumenda ipsam provident.	2025-08-21	11:30	3	pending	APT11398	\N
10400	431	10	2025-08-21 14:30:00	Fever	OPD	Sint ullam deserunt amet recusandae nostrum.	2025-06-26 22:30:08	2025-06-26 22:30:08	102/90	77	100.4	97	56	Magni quasi officiis iusto magnam tempora doloribus.	Officia odit excepturi impedit eveniet tempora aut sed dolore.	2025-09-01	A id dolores commodi totam.	2025-08-21	14:30	3	pending	APT11399	\N
10401	380	9	2025-08-21 11:15:00	Routine Checkup	Emergency	Quas inventore accusantium molestiae consectetur nostrum.	2025-06-26 22:30:08	2025-06-26 22:30:08	114/62	77	99.0	97	60	Quae perferendis nisi odit quasi autem molestiae.	Perspiciatis tempore reprehenderit commodi harum tempore.	2025-08-31	Eveniet nisi ipsum enim quaerat sequi sed.	2025-08-21	11:15	3	pending	APT11400	\N
10402	483	6	2025-08-21 11:30:00	Back Pain	OPD	Sed nihil rem voluptatum praesentium pariatur magni.	2025-06-26 22:30:08	2025-06-26 22:30:08	117/90	91	99.2	97	69	Beatae corrupti itaque deserunt amet eos.	Animi saepe eveniet tempore voluptatum repudiandae quibusdam laboriosam.	2025-08-28	Iusto similique est assumenda nam quisquam recusandae.	2025-08-21	11:30	3	pending	APT11401	\N
10403	332	9	2025-08-21 15:15:00	Fever	Emergency	Velit voluptatum assumenda eum accusantium soluta consequuntur esse.	2025-06-26 22:30:08	2025-06-26 22:30:08	112/80	96	98.1	97	73	Reiciendis provident voluptate nihil incidunt officia.	Saepe velit eaque sed dolor est eos dolores ullam enim dolores.	2025-09-07	Dolores eum pariatur laudantium voluptas iure.	2025-08-21	15:15	3	pending	APT11402	\N
10404	145	6	2025-08-21 15:45:00	Routine Checkup	Follow-up	Cumque voluptatum totam itaque modi dolore.	2025-06-26 22:30:08	2025-06-26 22:30:08	135/86	92	99.7	97	81	Repellendus totam fugiat iusto tempore.	Animi reprehenderit ea rem blanditiis suscipit earum numquam earum.	2025-09-14	Vitae nihil tempora natus minima neque iusto.	2025-08-21	15:45	3	pending	APT11403	\N
10405	67	10	2025-08-21 12:30:00	Headache	Emergency	Optio vero eaque beatae facere.	2025-06-26 22:30:08	2025-06-26 22:30:08	132/68	78	97.7	96	68	Optio eligendi officia incidunt modi vel.	Repudiandae officiis velit vero optio aut libero quos fugiat.	2025-08-29	Sequi commodi reiciendis autem sed cumque qui.	2025-08-21	12:30	3	pending	APT11404	\N
10406	281	5	2025-08-21 13:30:00	Back Pain	New	Atque cumque consequatur minima nesciunt occaecati dignissimos eius.	2025-06-26 22:30:08	2025-06-26 22:30:08	135/79	92	97.6	99	77	Consequuntur sapiente impedit pariatur.	Modi recusandae magnam quam eveniet in quis saepe.	2025-09-20	Soluta quis totam libero facere facere dolor.	2025-08-21	13:30	3	pending	APT11405	\N
10407	426	6	2025-08-21 15:00:00	Cough	Follow-up	Aliquam ipsa sunt.	2025-06-26 22:30:08	2025-06-26 22:30:08	125/88	82	97.5	96	55	Porro non animi velit minima aspernatur sit.	Maiores optio tenetur est dolores est libero.	2025-09-08	Maxime reprehenderit rerum distinctio rem.	2025-08-21	15:00	3	pending	APT11406	\N
10408	176	10	2025-08-21 11:45:00	High BP	Emergency	Vel quam itaque quae amet aut.	2025-06-26 22:30:08	2025-06-26 22:30:08	107/80	96	97.9	95	83	Aliquid eligendi iure rerum libero.	Excepturi tempora assumenda modi odio.	2025-08-30	Quisquam excepturi eos.	2025-08-21	11:45	3	pending	APT11407	\N
10409	158	6	2025-08-21 14:15:00	Headache	Emergency	Cum inventore sit corporis aliquam assumenda molestias.	2025-06-26 22:30:08	2025-06-26 22:30:08	114/78	74	99.3	99	64	Animi id expedita tempore eos.	Quae quo sed hic deserunt sequi accusamus corporis voluptatum occaecati.	2025-09-15	Vel ducimus laudantium reiciendis.	2025-08-21	14:15	3	pending	APT11408	\N
10410	138	9	2025-08-21 15:15:00	Routine Checkup	New	Tenetur vitae quidem debitis.	2025-06-26 22:30:08	2025-06-26 22:30:08	106/87	76	99.5	98	85	Quod ipsa dolor praesentium.	Maxime expedita quo perspiciatis voluptates hic earum amet.	2025-09-06	Odit voluptas cumque.	2025-08-21	15:15	3	pending	APT11409	\N
10411	240	8	2025-08-21 12:45:00	Routine Checkup	OPD	Officiis reiciendis ipsum ut aspernatur libero.	2025-06-26 22:30:08	2025-06-26 22:30:08	135/60	73	97.8	100	85	Id debitis id adipisci. Quas tempora eaque dolores.	Dolore libero debitis cumque fugiat rerum.	2025-09-02	Molestiae iste dolorem nam.	2025-08-21	12:45	3	pending	APT11410	\N
10412	301	5	2025-08-21 15:00:00	Routine Checkup	Follow-up	Facere dolorem illum qui quos ex praesentium commodi.	2025-06-26 22:30:08	2025-06-26 22:30:08	131/83	96	98.4	97	59	Reprehenderit impedit minus nostrum.	Asperiores porro cum alias dignissimos corrupti ipsam velit.	2025-09-16	Ex est temporibus mollitia earum nihil fuga architecto.	2025-08-21	15:00	3	pending	APT11411	\N
10413	321	8	2025-08-21 16:15:00	High BP	New	Veniam repudiandae cupiditate optio veniam cum.	2025-06-26 22:30:08	2025-06-26 22:30:08	136/62	97	98.2	100	60	Quasi necessitatibus nisi veniam exercitationem dolorum.	Eos deserunt aut enim minima voluptas eum voluptatibus voluptas necessitatibus.	2025-09-17	Autem veniam in reprehenderit corrupti dolores.	2025-08-21	16:15	3	pending	APT11412	\N
10414	151	5	2025-08-22 12:15:00	Headache	Emergency	Eos eveniet commodi placeat error expedita animi.	2025-06-26 22:30:08	2025-06-26 22:30:08	118/63	68	98.7	100	60	Facilis maiores voluptatibus.	Quaerat ab dicta explicabo qui.	2025-09-21	Voluptas occaecati labore nulla ab quo.	2025-08-22	12:15	3	pending	APT11413	\N
10415	20	5	2025-08-22 16:15:00	Back Pain	New	Et rem accusamus facilis vitae expedita.	2025-06-26 22:30:08	2025-06-26 22:30:08	106/63	97	97.6	100	67	Sed architecto magni quibusdam ipsa sed corporis.	Ipsam provident eligendi facere iste iste quas accusamus quaerat.	2025-09-11	Illum nam quis similique ab itaque.	2025-08-22	16:15	3	pending	APT11414	\N
10416	381	10	2025-08-22 16:15:00	Back Pain	Follow-up	Iure ipsum expedita corporis.	2025-06-26 22:30:08	2025-06-26 22:30:08	103/88	96	98.0	98	74	Autem iure voluptate rerum nihil rem laborum perspiciatis.	Beatae provident vel occaecati ullam porro magni.	2025-09-06	Corporis officia voluptatem consectetur iste.	2025-08-22	16:15	3	pending	APT11415	\N
10417	343	10	2025-08-22 14:15:00	Cough	Emergency	Itaque quidem similique eaque iusto dignissimos quasi.	2025-06-26 22:30:08	2025-06-26 22:30:08	128/88	100	98.7	100	65	In ut alias. Iste dicta recusandae. Odit error eos iusto.	Nesciunt minus minus sint commodi non pariatur aut.	2025-09-08	Eos odit placeat maiores possimus.	2025-08-22	14:15	3	pending	APT11416	\N
10418	338	4	2025-08-22 13:00:00	Fever	New	Tempore voluptatibus modi nihil soluta.	2025-06-26 22:30:08	2025-06-26 22:30:08	107/70	80	100.1	100	66	Excepturi deserunt explicabo porro vel eligendi.	Illum sit error ad eius.	2025-09-19	Laudantium nostrum similique aut nostrum repudiandae.	2025-08-22	13:00	3	pending	APT11417	\N
10419	453	7	2025-08-22 16:45:00	Routine Checkup	New	Cupiditate facere temporibus autem soluta ab dignissimos.	2025-06-26 22:30:08	2025-06-26 22:30:08	137/65	74	98.2	95	83	Rerum mollitia explicabo alias.	Blanditiis eveniet provident eum ratione doloremque iusto sit.	2025-08-30	Minima quasi unde beatae ratione eligendi.	2025-08-22	16:45	3	pending	APT11418	\N
10420	476	10	2025-08-22 14:15:00	Fever	New	Quae illum dolorem accusamus officia commodi incidunt.	2025-06-26 22:30:08	2025-06-26 22:30:08	130/61	68	99.1	100	71	Eius repellat minus laborum nostrum perferendis.	Voluptates impedit modi optio dolor temporibus repellat.	2025-08-30	Voluptatibus doloremque architecto.	2025-08-22	14:15	3	pending	APT11419	\N
10421	473	7	2025-08-22 11:15:00	Routine Checkup	New	Quis excepturi id id.	2025-06-26 22:30:08	2025-06-26 22:30:08	140/82	79	99.8	98	81	Libero quibusdam rem labore architecto eum modi.	Delectus libero similique delectus dolorum cupiditate.	2025-09-20	Optio quaerat cupiditate nulla harum suscipit voluptate corrupti.	2025-08-22	11:15	3	pending	APT11420	\N
10422	228	4	2025-08-22 11:30:00	High BP	Emergency	Explicabo iste eligendi officia alias debitis quas culpa.	2025-06-26 22:30:08	2025-06-26 22:30:08	107/73	89	99.3	98	77	Quas ratione fuga veniam deleniti repellat. Ab vel nam.	Placeat quod sapiente maxime maiores vel quia omnis.	2025-08-30	Tempore optio consequuntur quisquam.	2025-08-22	11:30	3	pending	APT11421	\N
10423	318	5	2025-08-22 14:45:00	Diabetes Check	Follow-up	Molestias harum pariatur sed.	2025-06-26 22:30:08	2025-06-26 22:30:08	117/75	88	98.0	100	72	Ratione assumenda perferendis nobis numquam qui ipsum.	Nam quae voluptates dicta laboriosam.	2025-09-19	Nulla aperiam tempore ducimus voluptatem asperiores quaerat.	2025-08-22	14:45	3	pending	APT11422	\N
10424	477	10	2025-08-22 16:30:00	Back Pain	OPD	Placeat libero iusto.	2025-06-26 22:30:08	2025-06-26 22:30:08	136/64	67	98.5	100	58	Vero aliquam veritatis accusamus ea sunt.	Consequatur facere id odio possimus ad dolor delectus.	2025-09-11	Amet quo eos nostrum numquam officiis eos.	2025-08-22	16:30	3	pending	APT11423	\N
10425	440	4	2025-08-22 15:00:00	Skin Rash	OPD	Dicta ipsa nesciunt natus labore.	2025-06-26 22:30:08	2025-06-26 22:30:08	129/72	67	100.5	96	74	Unde quia nulla magnam dolore velit.	Itaque porro recusandae ipsa commodi sed quam sint rerum.	2025-09-05	Sequi enim possimus.	2025-08-22	15:00	3	pending	APT11424	\N
10426	431	6	2025-08-22 11:00:00	Routine Checkup	New	Inventore quibusdam officia totam nihil.	2025-06-26 22:30:08	2025-06-26 22:30:08	137/61	72	100.5	96	81	Animi itaque quasi officia. Esse numquam est id nostrum.	Cupiditate officia illo ex magni officiis occaecati.	2025-08-30	Quis earum ad culpa minima officiis quidem.	2025-08-22	11:00	3	pending	APT11425	\N
10427	355	5	2025-08-22 15:45:00	Diabetes Check	New	Accusamus consectetur enim cumque ea fuga.	2025-06-26 22:30:08	2025-06-26 22:30:08	113/86	91	100.0	99	71	Beatae enim vero sequi dignissimos distinctio.	A cum doloremque sequi ex.	2025-09-06	Quis natus fuga fuga laboriosam culpa.	2025-08-22	15:45	3	pending	APT11426	\N
10428	188	5	2025-08-22 15:15:00	Back Pain	OPD	Animi illo optio expedita impedit.	2025-06-26 22:30:08	2025-06-26 22:30:08	124/89	74	99.8	95	81	Sit assumenda minus laudantium.	Animi quos molestias porro hic.	2025-08-30	Rerum nulla totam cumque voluptatem a.	2025-08-22	15:15	3	pending	APT11427	\N
10429	45	6	2025-08-22 11:30:00	Cough	Follow-up	Molestias perspiciatis asperiores repellendus a iure ea.	2025-06-26 22:30:08	2025-06-26 22:30:08	102/76	90	98.4	95	69	Aspernatur quae voluptatem sunt saepe eum.	Quisquam labore ipsa reprehenderit natus temporibus unde excepturi sunt doloremque.	2025-09-06	Accusamus provident neque doloribus aspernatur.	2025-08-22	11:30	3	pending	APT11428	\N
10430	117	9	2025-08-22 16:45:00	Headache	OPD	Ratione quidem laboriosam totam inventore delectus ea.	2025-06-26 22:30:08	2025-06-26 22:30:08	128/87	76	99.0	100	73	Error eveniet a debitis iste temporibus quisquam non.	Accusamus fugiat tempora enim odio cumque necessitatibus quo ipsa incidunt.	2025-09-13	Alias dolore iusto sed neque.	2025-08-22	16:45	3	pending	APT11429	\N
10431	82	4	2025-08-22 12:45:00	Fever	OPD	Assumenda accusantium numquam animi excepturi quos.	2025-06-26 22:30:08	2025-06-26 22:30:08	119/82	93	99.7	97	57	Corrupti quibusdam rem nihil.	Ad modi assumenda nesciunt eum quis possimus doloribus eum neque consectetur.	2025-08-31	Accusantium esse esse facere excepturi hic.	2025-08-22	12:45	3	pending	APT11430	\N
10432	298	6	2025-08-22 12:45:00	Back Pain	Follow-up	Minima debitis sequi totam tempore nulla.	2025-06-26 22:30:08	2025-06-26 22:30:08	132/83	92	99.6	99	70	Iusto commodi vel architecto eos reiciendis explicabo.	Unde fugiat veritatis corporis iusto quod modi optio velit at.	2025-09-14	Error eaque sed laboriosam.	2025-08-22	12:45	3	pending	APT11431	\N
10433	115	9	2025-08-22 13:45:00	High BP	Emergency	Modi soluta nobis minima quibusdam.	2025-06-26 22:30:08	2025-06-26 22:30:08	102/60	85	97.7	96	83	Id error voluptatibus exercitationem commodi nisi sequi.	Id ullam aliquam quis pariatur explicabo.	2025-09-06	Cupiditate numquam earum hic minima dolore sequi.	2025-08-22	13:45	3	pending	APT11432	\N
10434	466	4	2025-08-22 15:45:00	Back Pain	OPD	Repellat animi quisquam esse accusamus quaerat.	2025-06-26 22:30:08	2025-06-26 22:30:08	138/75	98	100.4	95	65	Facilis saepe perferendis aliquid aliquid accusamus cumque.	Sequi rem velit ad perferendis laboriosam consequuntur.	2025-08-30	Officiis ex repudiandae rerum.	2025-08-22	15:45	3	pending	APT11433	\N
10435	308	8	2025-08-22 13:30:00	Diabetes Check	Follow-up	Quis reiciendis officiis neque tempora id.	2025-06-26 22:30:08	2025-06-26 22:30:08	111/65	92	99.3	96	69	Laborum voluptas nesciunt vitae ipsam.	Atque nihil harum porro odit.	2025-09-06	Rem fugit maxime culpa voluptate.	2025-08-22	13:30	3	pending	APT11434	\N
10436	77	10	2025-08-22 12:30:00	High BP	New	Consectetur minima inventore nostrum quod.	2025-06-26 22:30:08	2025-06-26 22:30:08	106/85	76	97.8	95	72	Dolore molestias libero atque praesentium aut.	Minima doloribus ea nobis mollitia amet illum.	2025-09-11	Maxime architecto suscipit.	2025-08-22	12:30	3	pending	APT11435	\N
10437	380	3	2025-08-22 16:15:00	Headache	OPD	Aliquam nemo rerum.	2025-06-26 22:30:08	2025-06-26 22:30:08	138/74	87	98.1	98	74	Itaque cupiditate saepe officia quas dolores.	Animi velit laudantium sint voluptates dolores voluptatum quae illum.	2025-08-31	Eligendi commodi velit.	2025-08-22	16:15	3	pending	APT11436	\N
10438	167	7	2025-08-22 13:30:00	Fever	OPD	Facere nostrum pariatur incidunt corporis eveniet.	2025-06-26 22:30:08	2025-06-26 22:30:08	124/89	81	99.9	100	76	Nobis accusantium animi officiis corporis.	Dolorem ex nobis labore laudantium laborum fuga quidem qui.	2025-09-01	Accusamus consequatur illo soluta eaque.	2025-08-22	13:30	3	pending	APT11437	\N
10439	447	9	2025-08-23 16:30:00	Headache	Follow-up	Ratione assumenda temporibus nulla dolore adipisci veritatis.	2025-06-26 22:30:08	2025-06-26 22:30:08	100/84	73	100.3	98	81	Hic iure enim. Eveniet ipsa assumenda dolorem sit.	Officia rerum ad explicabo quas velit.	2025-09-07	Eaque maiores harum magni cupiditate.	2025-08-23	16:30	3	pending	APT11438	\N
10440	361	6	2025-08-23 12:30:00	Skin Rash	Follow-up	Alias debitis dolores in quam alias quisquam.	2025-06-26 22:30:08	2025-06-26 22:30:08	100/73	88	97.5	98	84	Ab eveniet facilis optio unde autem minus deserunt.	Provident autem delectus magni exercitationem dolorem hic cumque alias.	2025-09-10	Optio saepe iste nostrum eum harum nisi.	2025-08-23	12:30	3	pending	APT11439	\N
10441	220	6	2025-08-23 15:00:00	Headache	OPD	Nihil minus omnis velit eum.	2025-06-26 22:30:08	2025-06-26 22:30:08	118/75	67	98.2	95	61	Temporibus repellendus harum dolore hic vero.	Earum fugit doloribus nostrum deleniti necessitatibus.	2025-09-04	Placeat odit illo assumenda impedit perspiciatis.	2025-08-23	15:00	3	pending	APT11440	\N
10442	457	9	2025-08-23 16:00:00	Back Pain	OPD	Fugiat laborum architecto quae nisi neque.	2025-06-26 22:30:08	2025-06-26 22:30:08	116/79	65	97.7	97	56	Cupiditate delectus veritatis alias unde dicta asperiores.	Odit ducimus impedit ex at ullam sint porro quasi aperiam.	2025-09-14	Nemo vero mollitia at id consequuntur.	2025-08-23	16:00	3	pending	APT11441	\N
10443	106	10	2025-08-23 16:15:00	Diabetes Check	Emergency	Voluptatum quas ad amet.	2025-06-26 22:30:08	2025-06-26 22:30:08	134/62	71	98.0	97	59	Quod atque cumque iste accusantium.	Excepturi dolores corrupti fugiat ratione nam beatae.	2025-09-19	Ab beatae doloribus reprehenderit maiores.	2025-08-23	16:15	3	pending	APT11442	\N
10444	79	5	2025-08-23 11:15:00	Routine Checkup	OPD	Repellendus illo temporibus.	2025-06-26 22:30:08	2025-06-26 22:30:08	117/76	66	98.6	100	85	Vitae ad ipsa assumenda non minus tempora.	Dolorum doloribus corrupti eius consequuntur voluptas officia numquam accusamus.	2025-09-18	Saepe amet nemo officiis.	2025-08-23	11:15	3	pending	APT11443	\N
10445	372	9	2025-08-23 15:15:00	Routine Checkup	New	Officiis earum accusamus.	2025-06-26 22:30:08	2025-06-26 22:30:08	119/84	71	97.6	97	83	Repellat enim hic deleniti.	Distinctio aliquam optio occaecati sapiente necessitatibus eius beatae illum nihil.	2025-09-04	Voluptates similique quidem quam.	2025-08-23	15:15	3	pending	APT11444	\N
10446	361	3	2025-08-23 11:30:00	Diabetes Check	OPD	Ea reprehenderit similique blanditiis natus tenetur facilis itaque.	2025-06-26 22:30:08	2025-06-26 22:30:08	115/61	72	99.3	96	76	Eius ipsam architecto placeat tempore.	Deserunt fugit porro ipsa dignissimos ad voluptatum minus.	2025-09-04	Earum placeat eligendi reiciendis quisquam.	2025-08-23	11:30	3	pending	APT11445	\N
10447	124	9	2025-08-23 11:15:00	Fever	Emergency	Blanditiis totam ea quam consequatur et autem.	2025-06-26 22:30:08	2025-06-26 22:30:08	117/81	73	97.9	100	60	Praesentium velit fuga ex.	Possimus cupiditate ea quia neque cupiditate atque dolor dicta distinctio exercitationem.	2025-09-09	Delectus dolorem asperiores pariatur ullam ipsa in.	2025-08-23	11:15	3	pending	APT11446	\N
10448	417	9	2025-08-23 13:30:00	Cough	Emergency	Facere culpa voluptate delectus suscipit.	2025-06-26 22:30:08	2025-06-26 22:30:08	122/79	67	99.0	96	85	Ex id temporibus sint magnam sunt quibusdam.	Voluptas dolores alias praesentium minus.	2025-09-15	Id neque laboriosam quaerat dolore.	2025-08-23	13:30	3	pending	APT11447	\N
10449	101	3	2025-08-23 15:00:00	Diabetes Check	New	Facilis voluptate perspiciatis placeat.	2025-06-26 22:30:08	2025-06-26 22:30:08	108/90	94	100.4	100	82	Ex voluptatum ex nobis quasi impedit.	Nihil vero rerum porro culpa labore iusto.	2025-09-10	Quasi quisquam voluptas a.	2025-08-23	15:00	3	pending	APT11448	\N
10450	482	3	2025-08-23 12:15:00	Back Pain	OPD	Nemo unde fugiat similique.	2025-06-26 22:30:08	2025-06-26 22:30:08	126/82	80	99.0	95	75	Assumenda consectetur veniam labore distinctio.	Saepe accusamus ex aliquid ex sint.	2025-09-17	Inventore incidunt quae voluptates praesentium laudantium iure dolore.	2025-08-23	12:15	3	pending	APT11449	\N
10451	484	9	2025-08-23 11:30:00	Skin Rash	OPD	Tenetur maxime impedit dolor.	2025-06-26 22:30:08	2025-06-26 22:30:08	127/77	69	97.9	99	72	Alias quae repellendus.	Delectus accusantium illum tenetur et officiis dignissimos recusandae necessitatibus vero.	2025-09-14	Doloribus consequuntur sequi rerum repellendus rerum inventore.	2025-08-23	11:30	3	pending	APT11450	\N
10452	155	9	2025-08-23 12:15:00	Skin Rash	New	Corrupti facere architecto dignissimos nulla consequatur laudantium neque.	2025-06-26 22:30:08	2025-06-26 22:30:08	109/73	99	97.7	99	59	Ipsam harum voluptas excepturi maxime nam.	Amet distinctio officiis doloribus repudiandae odit voluptates hic.	2025-09-22	Dolorem nisi voluptates asperiores quia illum suscipit.	2025-08-23	12:15	3	pending	APT11451	\N
10453	169	4	2025-08-23 14:45:00	Back Pain	OPD	Hic perspiciatis odit placeat necessitatibus itaque.	2025-06-26 22:30:08	2025-06-26 22:30:08	135/77	90	99.7	97	67	Cupiditate neque est laudantium.	Totam recusandae quae saepe quis at architecto.	2025-09-21	Minima aspernatur corporis omnis quas distinctio architecto quod.	2025-08-23	14:45	3	pending	APT11452	\N
10454	500	10	2025-08-23 15:15:00	Back Pain	OPD	Est at libero recusandae.	2025-06-26 22:30:08	2025-06-26 22:30:08	104/72	91	99.1	100	69	Quas debitis quibusdam officia.	Quod velit incidunt ab alias consectetur.	2025-09-21	Repellat earum laudantium dolorem.	2025-08-23	15:15	3	pending	APT11453	\N
10455	280	10	2025-08-23 14:00:00	Back Pain	Follow-up	Alias praesentium provident architecto.	2025-06-26 22:30:08	2025-06-26 22:30:08	114/87	94	99.7	98	64	Rem repellendus laudantium ab ex odio dignissimos libero.	Mollitia dignissimos aut cupiditate labore atque officia modi similique.	2025-09-03	Quibusdam possimus corporis pariatur vel quae repudiandae.	2025-08-23	14:00	3	pending	APT11454	\N
10456	422	8	2025-08-23 13:30:00	Back Pain	New	Nihil esse enim omnis.	2025-06-26 22:30:08	2025-06-26 22:30:08	124/77	78	99.6	98	70	Recusandae quam et at fugit odio.	Itaque corrupti optio nobis dolorum facere nulla ea possimus soluta.	2025-09-11	Cumque laudantium odit animi accusamus.	2025-08-23	13:30	3	pending	APT11455	\N
10457	282	7	2025-08-23 11:45:00	Skin Rash	Follow-up	Ea aspernatur facilis quidem animi aliquam fugit.	2025-06-26 22:30:08	2025-06-26 22:30:08	137/75	88	99.8	100	75	Est repellendus aperiam voluptatem.	Sequi velit porro nihil inventore eius nam dolores suscipit.	2025-09-14	In suscipit labore distinctio architecto.	2025-08-23	11:45	3	pending	APT11456	\N
10458	489	9	2025-08-23 11:15:00	Back Pain	New	Nesciunt temporibus provident corporis delectus.	2025-06-26 22:30:08	2025-06-26 22:30:08	112/60	77	99.3	95	80	Magnam placeat unde eos ipsum.	Repudiandae esse repellendus aperiam quae quam voluptas excepturi odio.	2025-09-09	Repudiandae dolor iusto quas.	2025-08-23	11:15	3	pending	APT11457	\N
10459	286	5	2025-08-23 16:00:00	Routine Checkup	Follow-up	Rem blanditiis illum aspernatur placeat.	2025-06-26 22:30:08	2025-06-26 22:30:08	103/90	99	99.4	96	69	Commodi modi sint temporibus enim optio vitae illum.	Voluptate illum aliquid earum nesciunt sit ea quis.	2025-09-20	Aperiam enim aspernatur similique laudantium deserunt.	2025-08-23	16:00	3	pending	APT11458	\N
10460	436	8	2025-08-24 14:00:00	Cough	Follow-up	Eveniet nostrum impedit iure tempora laudantium numquam.	2025-06-26 22:30:08	2025-06-26 22:30:08	137/66	87	99.3	96	77	Ullam eos dolore maxime fugiat earum reprehenderit.	Laboriosam voluptate adipisci nisi quae itaque.	2025-09-03	Omnis illo asperiores quasi maiores vero.	2025-08-24	14:00	3	pending	APT11459	\N
10461	264	10	2025-08-24 12:30:00	Fever	OPD	Nisi reprehenderit blanditiis veniam repudiandae tempore praesentium expedita.	2025-06-26 22:30:08	2025-06-26 22:30:08	112/61	69	99.2	99	62	Perferendis soluta provident quod excepturi.	Minima unde aperiam deserunt hic.	2025-09-12	Distinctio voluptas dicta velit nemo necessitatibus eligendi laborum.	2025-08-24	12:30	3	pending	APT11460	\N
10462	257	5	2025-08-24 14:15:00	Headache	New	Odit esse voluptates ipsum fugit architecto ex.	2025-06-26 22:30:08	2025-06-26 22:30:08	111/88	73	98.6	100	62	Deleniti animi facilis deserunt sit.	Velit officia nihil facere quia.	2025-09-14	Eius dignissimos dolores doloribus.	2025-08-24	14:15	3	pending	APT11461	\N
10463	259	8	2025-08-24 16:15:00	Back Pain	Follow-up	Sint vero expedita dolore nam iusto asperiores.	2025-06-26 22:30:08	2025-06-26 22:30:08	109/80	67	98.9	97	66	Facilis ipsam nemo itaque vero.	Placeat quibusdam quae dignissimos voluptatem veniam occaecati tenetur explicabo.	2025-09-21	Neque minima earum dicta earum incidunt vitae.	2025-08-24	16:15	3	pending	APT11462	\N
10464	214	5	2025-08-24 14:45:00	Fever	New	Eaque eius voluptatum atque.	2025-06-26 22:30:08	2025-06-26 22:30:08	129/70	96	98.2	95	63	Maiores perferendis placeat repellendus earum neque autem.	Autem adipisci doloremque vero rerum culpa.	2025-09-14	Facere vitae vero quidem.	2025-08-24	14:45	3	pending	APT11463	\N
10465	137	10	2025-08-24 15:15:00	Diabetes Check	New	Magnam sit neque est reiciendis voluptates quod.	2025-06-26 22:30:08	2025-06-26 22:30:08	136/66	92	99.7	99	63	Atque in earum qui eaque ab.	Et iusto labore dolor voluptatibus.	2025-09-20	Molestiae maxime et possimus.	2025-08-24	15:15	3	pending	APT11464	\N
10466	13	5	2025-08-24 14:00:00	Fever	OPD	Optio necessitatibus tempore occaecati vitae sit repellat explicabo.	2025-06-26 22:30:08	2025-06-26 22:30:08	138/65	82	98.3	97	57	Odio minima molestiae dolorum tempora excepturi doloribus.	Accusantium optio mollitia error excepturi.	2025-09-04	Minima labore velit magnam odit.	2025-08-24	14:00	3	pending	APT11465	\N
10467	316	4	2025-08-24 15:00:00	Skin Rash	OPD	Facere accusantium repellat perferendis.	2025-06-26 22:30:08	2025-06-26 22:30:08	137/85	86	98.5	98	82	Quos adipisci dolor ab quibusdam distinctio officiis.	Libero dolorum consequuntur quis repellendus animi dolorem nam fugit consequuntur architecto.	2025-09-21	Deleniti itaque reiciendis iste.	2025-08-24	15:00	3	pending	APT11466	\N
10468	39	6	2025-08-24 11:00:00	Routine Checkup	Follow-up	Debitis recusandae minima.	2025-06-26 22:30:08	2025-06-26 22:30:08	117/85	99	98.5	95	58	Repudiandae quos possimus id maiores dignissimos.	Ea eius inventore cupiditate eum voluptatem adipisci rem itaque similique.	2025-09-05	Inventore quas dolore exercitationem.	2025-08-24	11:00	3	pending	APT11467	\N
10469	153	4	2025-08-24 15:15:00	Fever	Emergency	Assumenda quod officia rem.	2025-06-26 22:30:08	2025-06-26 22:30:08	115/85	92	98.8	95	82	Corrupti iusto tempore corrupti rem. Et quos aliquid.	Accusamus nemo nesciunt natus fugiat velit incidunt consectetur.	2025-09-02	Odio culpa in nemo doloribus rerum.	2025-08-24	15:15	3	pending	APT11468	\N
10470	408	8	2025-08-24 14:30:00	Routine Checkup	Follow-up	Aspernatur voluptatem necessitatibus minus.	2025-06-26 22:30:08	2025-06-26 22:30:08	104/61	91	100.1	97	74	Voluptatum et soluta dicta.	Ab distinctio earum occaecati molestias suscipit adipisci consequuntur.	2025-09-18	Commodi nobis quia commodi dicta.	2025-08-24	14:30	3	pending	APT11469	\N
10471	98	9	2025-08-24 15:30:00	Diabetes Check	Emergency	Odit consequuntur maxime.	2025-06-26 22:30:08	2025-06-26 22:30:08	130/75	69	97.8	95	58	Saepe eum cum nisi deleniti ullam.	Recusandae temporibus eos ipsam perferendis.	2025-09-03	Illum atque maiores eos omnis sit nostrum.	2025-08-24	15:30	3	pending	APT11470	\N
10472	491	10	2025-08-24 12:00:00	Cough	OPD	Quasi quisquam repudiandae eos nihil maxime a doloremque.	2025-06-26 22:30:08	2025-06-26 22:30:08	106/74	99	99.1	100	65	Nihil eos eligendi reiciendis.	Placeat vel eligendi impedit illo aspernatur.	2025-09-22	Sit ratione dolorum perferendis.	2025-08-24	12:00	3	pending	APT11471	\N
10473	320	4	2025-08-24 16:00:00	Cough	Follow-up	Architecto alias eaque dolorum quibusdam.	2025-06-26 22:30:08	2025-06-26 22:30:08	120/70	84	99.2	100	58	Id voluptas enim.	Cum nesciunt harum dolore eveniet commodi eum fuga placeat fugiat.	2025-09-02	Corrupti eaque itaque fugiat incidunt deserunt sapiente.	2025-08-24	16:00	3	pending	APT11472	\N
10474	158	10	2025-08-24 16:15:00	Fever	New	Consequuntur numquam sapiente hic cupiditate ducimus corrupti.	2025-06-26 22:30:08	2025-06-26 22:30:08	103/61	68	100.4	98	83	Vel porro nulla laboriosam.	Eveniet magnam molestiae numquam nam.	2025-09-05	Blanditiis quas odio sit quasi laboriosam.	2025-08-24	16:15	3	pending	APT11473	\N
10475	101	10	2025-08-24 11:30:00	Routine Checkup	Follow-up	Provident architecto optio autem.	2025-06-26 22:30:08	2025-06-26 22:30:08	117/73	65	99.3	100	78	Necessitatibus ipsam placeat molestiae at.	A velit eaque quis voluptatibus earum placeat quis architecto.	2025-09-15	Rem perferendis ratione natus nisi dolore fugiat.	2025-08-24	11:30	3	pending	APT11474	\N
10476	285	8	2025-08-24 12:00:00	Cough	Follow-up	Enim molestiae nisi perferendis.	2025-06-26 22:30:08	2025-06-26 22:30:08	139/75	94	98.7	96	78	Nesciunt ut quasi. Facilis nam ab earum officiis debitis.	Reiciendis alias odio ipsa incidunt ullam.	2025-09-17	Beatae illum at harum ad itaque.	2025-08-24	12:00	3	pending	APT11475	\N
10477	103	5	2025-08-24 15:45:00	Back Pain	Follow-up	Laudantium natus nesciunt deserunt nostrum ex.	2025-06-26 22:30:08	2025-06-26 22:30:08	107/86	77	97.8	100	60	Repudiandae ipsam non nihil enim tempore.	Nostrum eius ut nihil eveniet id magni.	2025-09-23	Atque expedita vero consequatur beatae.	2025-08-24	15:45	3	pending	APT11476	\N
10478	243	8	2025-08-24 16:45:00	Headache	OPD	Illo labore autem commodi excepturi ea alias.	2025-06-26 22:30:08	2025-06-26 22:30:08	117/83	100	97.9	98	60	Iste autem culpa sint hic commodi dignissimos.	Laboriosam quae nemo ipsum repudiandae eligendi ut placeat excepturi.	2025-09-07	Laboriosam dolorum necessitatibus sequi a accusamus.	2025-08-24	16:45	3	pending	APT11477	\N
10479	448	10	2025-08-24 11:45:00	Headache	Emergency	Recusandae quia nulla laboriosam officia soluta quasi cumque.	2025-06-26 22:30:08	2025-06-26 22:30:08	111/78	68	98.9	99	62	Odio recusandae dolore eveniet.	Quibusdam consequuntur saepe quia ex.	2025-08-31	Ut harum delectus explicabo libero ut.	2025-08-24	11:45	3	pending	APT11478	\N
10480	255	9	2025-08-24 12:00:00	Cough	New	Doloremque perspiciatis laboriosam magni dolor.	2025-06-26 22:30:08	2025-06-26 22:30:08	101/70	89	98.0	95	68	Tempore accusamus odio cum odit nulla ullam.	Fugit porro delectus debitis voluptatem voluptas iure eos mollitia consequatur.	2025-09-18	Harum enim ducimus ratione dolorum quisquam omnis amet.	2025-08-24	12:00	3	pending	APT11479	\N
10481	47	3	2025-08-24 16:30:00	Headache	New	Quis illum aliquam dolorem dicta laudantium ducimus.	2025-06-26 22:30:08	2025-06-26 22:30:08	127/68	66	97.7	95	72	At animi ullam eaque a dicta est.	Non impedit quis tempore error hic repellendus recusandae exercitationem.	2025-09-06	Consequatur repellat accusamus harum exercitationem cumque.	2025-08-24	16:30	3	pending	APT11480	\N
10482	115	9	2025-08-25 14:00:00	Fever	Emergency	Libero et voluptatum voluptatum.	2025-06-26 22:30:08	2025-06-26 22:30:08	136/73	77	100.2	95	83	Quam perspiciatis exercitationem.	Cumque sed odio nostrum sapiente adipisci delectus.	2025-09-19	Aspernatur laudantium exercitationem laborum quos numquam doloremque.	2025-08-25	14:00	3	pending	APT11481	\N
10483	162	4	2025-08-25 11:15:00	Skin Rash	OPD	Officia voluptatum magni sapiente quis nesciunt.	2025-06-26 22:30:08	2025-06-26 22:30:08	103/75	76	98.7	100	61	Odio soluta fugit consequuntur autem ut.	Consequuntur culpa dolore sit quidem.	2025-09-02	Voluptatibus asperiores assumenda quo.	2025-08-25	11:15	3	pending	APT11482	\N
10484	375	3	2025-08-25 15:00:00	Diabetes Check	Emergency	In placeat distinctio excepturi a culpa praesentium.	2025-06-26 22:30:08	2025-06-26 22:30:08	108/78	68	98.6	96	83	Praesentium delectus laudantium omnis.	Perspiciatis odit dolorem saepe tempora quasi.	2025-09-14	Repellendus eaque temporibus distinctio.	2025-08-25	15:00	3	pending	APT11483	\N
10485	176	7	2025-08-25 16:15:00	Routine Checkup	OPD	Molestiae quod exercitationem dignissimos.	2025-06-26 22:30:08	2025-06-26 22:30:08	140/72	75	97.6	99	72	Soluta impedit sequi ipsam recusandae.	Consectetur ex unde tempore similique possimus saepe placeat.	2025-09-08	Sapiente provident quo officiis.	2025-08-25	16:15	3	pending	APT11484	\N
10486	72	6	2025-08-25 11:30:00	Cough	New	Eligendi quibusdam sed veniam.	2025-06-26 22:30:08	2025-06-26 22:30:08	120/66	93	98.5	95	80	Ipsum facere excepturi eum officiis magni.	Quis sed sed minima ducimus eveniet.	2025-09-21	Earum est numquam.	2025-08-25	11:30	3	pending	APT11485	\N
10487	238	8	2025-08-25 14:30:00	Skin Rash	New	At asperiores consequuntur deleniti consequatur perferendis.	2025-06-26 22:30:08	2025-06-26 22:30:08	123/71	96	98.0	100	62	Numquam reprehenderit repellat facere enim cumque in.	Repellendus fugit asperiores dolorem iste.	2025-09-06	Eius deleniti deleniti recusandae natus nam ipsa.	2025-08-25	14:30	3	pending	APT11486	\N
10488	136	3	2025-08-25 14:30:00	High BP	New	Quasi magnam quaerat nisi labore sint architecto.	2025-06-26 22:30:08	2025-06-26 22:30:08	131/65	90	97.8	98	70	Magnam eaque molestias unde deserunt repellat.	Ratione nihil in quidem temporibus.	2025-09-24	Accusantium itaque dolore unde eum reiciendis consequatur.	2025-08-25	14:30	3	pending	APT11487	\N
10489	493	8	2025-08-25 14:45:00	Routine Checkup	New	Laborum culpa quidem cum assumenda cum voluptatum fugit.	2025-06-26 22:30:08	2025-06-26 22:30:08	116/63	81	98.2	97	81	Esse numquam in quidem cumque saepe.	Odio esse odio est.	2025-09-01	Quos dolorum placeat.	2025-08-25	14:45	3	pending	APT11488	\N
10490	106	5	2025-08-25 12:45:00	Back Pain	OPD	Reprehenderit quia nemo corrupti aut dolor.	2025-06-26 22:30:08	2025-06-26 22:30:08	106/62	74	100.1	98	57	Ex consequatur veritatis dolor veritatis.	Esse magni deserunt nisi consequatur beatae ad nobis.	2025-09-06	Ipsa repellendus aspernatur fuga corrupti.	2025-08-25	12:45	3	pending	APT11489	\N
10491	21	10	2025-08-25 11:30:00	Fever	New	Vitae culpa ducimus iusto natus quis rerum hic.	2025-06-26 22:30:08	2025-06-26 22:30:08	126/77	73	98.5	95	55	Illo reiciendis magni libero sed rerum libero enim.	Explicabo architecto nesciunt consequuntur consequatur.	2025-09-16	Ex enim exercitationem laudantium magni.	2025-08-25	11:30	3	pending	APT11490	\N
10492	238	4	2025-08-25 11:15:00	High BP	Follow-up	Quasi eaque iusto a minima.	2025-06-26 22:30:08	2025-06-26 22:30:08	133/82	84	97.6	100	80	Sit sit quae mollitia possimus.	Sit corrupti ipsa laudantium nostrum necessitatibus molestias.	2025-09-14	Sit mollitia odit commodi fuga aliquam.	2025-08-25	11:15	3	pending	APT11491	\N
10493	166	4	2025-08-25 16:15:00	Headache	Emergency	Vero exercitationem quod assumenda.	2025-06-26 22:30:08	2025-06-26 22:30:08	127/80	85	99.3	97	62	A voluptate neque id totam consectetur inventore.	Voluptatem dignissimos quis accusantium libero natus natus ullam.	2025-09-14	Tenetur ducimus praesentium voluptatum porro ipsam.	2025-08-25	16:15	3	pending	APT11492	\N
10494	231	10	2025-08-25 15:00:00	Fever	New	At corrupti repellendus magni vero quidem numquam aliquam.	2025-06-26 22:30:08	2025-06-26 22:30:08	129/70	96	98.9	99	82	Quisquam porro ratione. Sed enim earum.	Dolor est doloremque accusantium sint temporibus sint quasi sequi.	2025-09-11	Consequatur voluptatem quaerat rerum fugit autem error.	2025-08-25	15:00	3	pending	APT11493	\N
10495	189	3	2025-08-25 12:45:00	Back Pain	OPD	Excepturi fugit architecto ratione harum.	2025-06-26 22:30:08	2025-06-26 22:30:08	108/83	93	99.9	100	61	Quas provident in consequuntur facere est aut voluptate.	Suscipit nam iste nemo praesentium sunt unde saepe dolorem animi.	2025-09-08	Deserunt quas voluptates ab voluptatem culpa.	2025-08-25	12:45	3	pending	APT11494	\N
10496	41	4	2025-08-25 14:15:00	Back Pain	Emergency	Accusamus doloribus assumenda amet quam id.	2025-06-26 22:30:08	2025-06-26 22:30:08	130/88	92	98.2	99	76	Assumenda nostrum quis neque.	Error commodi modi illo fugiat sunt saepe dicta.	2025-09-03	Dolorem quo quo excepturi.	2025-08-25	14:15	3	pending	APT11495	\N
10497	368	6	2025-08-25 11:30:00	Fever	Emergency	Impedit molestias porro magnam.	2025-06-26 22:30:08	2025-06-26 22:30:08	121/85	89	100.4	100	57	Quia similique aliquid eius. Dicta ducimus fugiat.	Aut illo perferendis officia delectus quis.	2025-09-21	Nesciunt voluptatibus deserunt sit impedit officiis itaque.	2025-08-25	11:30	3	pending	APT11496	\N
10498	370	7	2025-08-25 16:30:00	Routine Checkup	OPD	Quas quas necessitatibus corrupti tenetur dicta repudiandae.	2025-06-26 22:30:08	2025-06-26 22:30:08	139/88	83	99.6	97	69	Deserunt mollitia delectus numquam quis harum.	Tempora in voluptas ratione.	2025-09-01	Numquam eius blanditiis laborum labore necessitatibus perspiciatis quis.	2025-08-25	16:30	3	pending	APT11497	\N
10499	288	6	2025-08-25 15:30:00	Fever	OPD	Et odit perferendis id vitae.	2025-06-26 22:30:08	2025-06-26 22:30:08	112/89	75	97.9	100	67	Temporibus voluptate alias.	Adipisci animi doloribus recusandae est iste possimus temporibus praesentium.	2025-09-23	Quasi quos cumque omnis amet.	2025-08-25	15:30	3	pending	APT11498	\N
10500	356	9	2025-08-25 12:45:00	Cough	Emergency	Possimus perspiciatis rem dolor distinctio.	2025-06-26 22:30:08	2025-06-26 22:30:08	134/62	85	97.5	98	83	Neque quo culpa excepturi cum.	Sunt quibusdam repudiandae error.	2025-09-17	Aspernatur recusandae atque a ullam aliquam eum.	2025-08-25	12:45	3	pending	APT11499	\N
10501	386	7	2025-08-25 12:15:00	Routine Checkup	Follow-up	Deleniti excepturi est animi eaque in.	2025-06-26 22:30:08	2025-06-26 22:30:08	126/71	90	99.1	99	65	Deserunt quam fugiat atque sapiente recusandae occaecati.	Doloribus aliquam nobis corrupti cum quidem repellat aperiam.	2025-09-13	Adipisci modi laudantium ducimus.	2025-08-25	12:15	3	pending	APT11500	\N
10502	160	10	2025-08-26 16:00:00	Headache	Emergency	Voluptatibus recusandae debitis iusto voluptas.	2025-06-26 22:30:08	2025-06-26 22:30:08	109/88	86	98.3	95	68	Laudantium perferendis rerum deserunt odit autem.	Odio earum atque alias minus mollitia.	2025-09-05	Dolor cumque facere aliquam voluptas.	2025-08-26	16:00	3	pending	APT11501	\N
10503	260	10	2025-08-26 11:45:00	Fever	Emergency	Alias accusantium totam.	2025-06-26 22:30:08	2025-06-26 22:30:08	113/69	91	97.9	100	57	Saepe quo ipsa velit totam. Pariatur rem libero sunt quasi.	Architecto dolorum eos velit possimus.	2025-09-23	Quis iusto natus sit quae.	2025-08-26	11:45	3	pending	APT11502	\N
10504	295	7	2025-08-26 13:00:00	Headache	Follow-up	Quia reiciendis facilis modi.	2025-06-26 22:30:08	2025-06-26 22:30:08	104/88	75	100.4	99	70	Fugit quae atque cum.	Ipsam sequi rem molestias ad.	2025-09-07	Dignissimos ut similique labore molestias temporibus dolor sint.	2025-08-26	13:00	3	pending	APT11503	\N
10505	298	6	2025-08-26 14:30:00	Headache	Emergency	Reiciendis nulla nisi assumenda nihil mollitia quam.	2025-06-26 22:30:08	2025-06-26 22:30:08	132/79	100	97.9	97	77	Aspernatur deserunt ab labore eos mollitia ipsam.	Repellat perferendis sit inventore fugiat aperiam.	2025-09-07	Inventore officiis quo odio.	2025-08-26	14:30	3	pending	APT11504	\N
10506	432	3	2025-08-26 11:00:00	Fever	Follow-up	Rerum consequatur illum maiores suscipit.	2025-06-26 22:30:08	2025-06-26 22:30:08	138/87	84	97.5	99	69	Tempore nihil quis eligendi quam amet deserunt.	Aliquid voluptas odio at incidunt.	2025-09-13	Unde voluptas consectetur vero laboriosam.	2025-08-26	11:00	3	pending	APT11505	\N
10507	100	3	2025-08-26 16:15:00	Cough	Emergency	Quo consequuntur dicta quia.	2025-06-26 22:30:08	2025-06-26 22:30:08	131/86	74	98.3	97	62	Quos necessitatibus enim. Ex quisquam enim quidem.	Quidem nobis magni at laboriosam earum dolor est.	2025-09-02	Odio exercitationem nemo.	2025-08-26	16:15	3	pending	APT11506	\N
10508	120	6	2025-08-26 11:15:00	Headache	Emergency	Dolor ratione assumenda beatae commodi maxime fugiat.	2025-06-26 22:30:08	2025-06-26 22:30:08	135/60	73	99.7	96	65	Similique quidem ab. Doloremque veniam vel officia facere.	Et minima sequi inventore dolorum iusto saepe.	2025-09-04	Animi commodi minus esse explicabo doloribus suscipit.	2025-08-26	11:15	3	pending	APT11507	\N
10509	369	7	2025-08-26 16:45:00	Diabetes Check	Follow-up	Repellendus molestiae id ad.	2025-06-26 22:30:08	2025-06-26 22:30:08	137/74	91	98.6	100	84	Ratione soluta magni veritatis. Dicta alias asperiores.	Laudantium vitae tenetur tempore eligendi rerum sunt asperiores.	2025-09-15	Perferendis necessitatibus incidunt mollitia perspiciatis.	2025-08-26	16:45	3	pending	APT11508	\N
10510	178	9	2025-08-26 16:45:00	Back Pain	OPD	Perspiciatis autem nam consectetur unde.	2025-06-26 22:30:08	2025-06-26 22:30:08	107/68	81	98.5	95	78	Voluptates temporibus ex perspiciatis.	Ratione magnam cupiditate earum nulla provident nemo vitae nobis accusamus.	2025-09-10	Possimus occaecati quaerat optio.	2025-08-26	16:45	3	pending	APT11509	\N
10511	301	8	2025-08-26 16:15:00	Fever	Follow-up	Libero consequuntur velit inventore tenetur.	2025-06-26 22:30:08	2025-06-26 22:30:08	123/83	82	99.7	96	78	Labore officiis provident ullam ea molestias ducimus quod.	Distinctio illo aspernatur vero nesciunt eum nisi quisquam.	2025-09-19	Eligendi ratione minima.	2025-08-26	16:15	3	pending	APT11510	\N
10512	294	4	2025-08-26 14:30:00	Diabetes Check	Emergency	Officiis animi modi unde eos illum esse.	2025-06-26 22:30:08	2025-06-26 22:30:08	140/78	76	99.6	96	69	Repudiandae ab quasi soluta.	Repellat culpa error nihil officiis doloremque voluptatum error inventore consequatur.	2025-09-15	Atque optio deserunt qui voluptates ducimus.	2025-08-26	14:30	3	pending	APT11511	\N
10513	295	7	2025-08-26 16:45:00	Diabetes Check	Emergency	Perspiciatis saepe necessitatibus.	2025-06-26 22:30:08	2025-06-26 22:30:08	134/65	65	98.2	97	71	Eveniet omnis eligendi provident.	Odio libero corrupti quod molestias ullam atque soluta blanditiis perspiciatis.	2025-09-05	Excepturi neque deserunt necessitatibus.	2025-08-26	16:45	3	pending	APT11512	\N
10514	289	7	2025-08-26 13:15:00	Skin Rash	OPD	Quas porro iusto.	2025-06-26 22:30:08	2025-06-26 22:30:08	126/67	89	99.3	95	83	Tempora tempora temporibus a neque cupiditate occaecati.	Sit quia quos nulla maiores in vero.	2025-09-24	Aspernatur est quae omnis quia at.	2025-08-26	13:15	3	pending	APT11513	\N
10515	71	5	2025-08-26 16:30:00	Skin Rash	New	Ducimus nostrum aperiam voluptas quam.	2025-06-26 22:30:08	2025-06-26 22:30:08	125/86	65	99.2	97	61	Ipsa eum corporis ducimus eos.	Esse cupiditate doloribus eos deleniti sapiente doloribus aperiam corporis nulla.	2025-09-20	Voluptate rem necessitatibus culpa porro.	2025-08-26	16:30	3	pending	APT11514	\N
10516	112	10	2025-08-26 15:30:00	High BP	Follow-up	Ipsum modi deleniti culpa.	2025-06-26 22:30:08	2025-06-26 22:30:08	106/61	100	98.9	97	77	Consequatur quam impedit.	Quo blanditiis necessitatibus ullam occaecati earum perspiciatis.	2025-09-10	Temporibus magni delectus nihil voluptates.	2025-08-26	15:30	3	pending	APT11515	\N
10517	144	4	2025-08-26 14:30:00	High BP	Emergency	Libero sint porro neque quisquam.	2025-06-26 22:30:08	2025-06-26 22:30:08	101/74	68	99.6	99	80	Alias facere rem cupiditate et odit veritatis.	Unde labore maxime repellendus adipisci aut ut doloribus voluptas.	2025-09-24	Iusto adipisci molestiae aliquid inventore unde.	2025-08-26	14:30	3	pending	APT11516	\N
10518	68	9	2025-08-26 14:30:00	Routine Checkup	New	Aut assumenda voluptas saepe aspernatur modi.	2025-06-26 22:30:08	2025-06-26 22:30:08	122/69	88	98.0	100	75	Minus atque minima vel voluptates.	Delectus similique illum a sunt neque.	2025-09-07	Magnam sed cum error dolore fugit repellendus.	2025-08-26	14:30	3	pending	APT11517	\N
10519	194	9	2025-08-26 13:00:00	High BP	Emergency	Beatae error aperiam placeat quaerat quis.	2025-06-26 22:30:08	2025-06-26 22:30:08	130/78	74	99.2	95	67	Atque iste doloremque. Occaecati quia ab sed cumque.	Aperiam sint qui dolorum quis consectetur excepturi asperiores repudiandae placeat.	2025-09-21	Eum alias ad aliquam ipsum debitis.	2025-08-26	13:00	3	pending	APT11518	\N
10520	277	9	2025-08-26 12:15:00	Fever	OPD	Architecto aspernatur repudiandae ratione.	2025-06-26 22:30:08	2025-06-26 22:30:08	118/71	79	97.6	95	70	Odit maiores doloribus laborum ad. Sit sequi nostrum illo.	Consequatur cupiditate voluptatum possimus itaque corrupti vitae architecto libero.	2025-09-16	Voluptatum dicta dolor mollitia eum exercitationem ea.	2025-08-26	12:15	3	pending	APT11519	\N
10521	151	7	2025-08-26 15:45:00	Fever	OPD	Consequuntur officiis blanditiis facere quod ex similique alias.	2025-06-26 22:30:08	2025-06-26 22:30:08	139/62	86	100.0	97	81	Sunt assumenda accusamus quae inventore.	Officia molestiae debitis nisi libero facere sequi debitis.	2025-09-17	Dignissimos ipsa deserunt labore temporibus aut.	2025-08-26	15:45	3	pending	APT11520	\N
10522	291	7	2025-08-26 13:45:00	Routine Checkup	Follow-up	Voluptatum nam incidunt quia dicta ipsa vitae.	2025-06-26 22:30:08	2025-06-26 22:30:08	118/78	65	98.8	98	83	Voluptatem facere esse quis voluptate maxime.	Dignissimos distinctio corrupti repellendus sunt itaque distinctio ea maiores voluptate.	2025-09-23	Commodi sunt aspernatur hic.	2025-08-26	13:45	3	pending	APT11521	\N
10523	337	8	2025-08-27 12:15:00	Skin Rash	Emergency	Aspernatur in aliquam reiciendis incidunt deserunt reiciendis.	2025-06-26 22:30:08	2025-06-26 22:30:08	110/76	75	97.7	97	58	Quos ea nobis odit porro quia.	Placeat deleniti minima aliquid veritatis aliquid aliquid nemo quod et.	2025-09-08	Voluptas dolore eos iste deleniti.	2025-08-27	12:15	3	pending	APT11522	\N
10524	103	5	2025-08-27 15:30:00	Routine Checkup	New	Ex fugit voluptate nobis repudiandae et.	2025-06-26 22:30:08	2025-06-26 22:30:08	103/87	90	97.7	98	59	Laborum asperiores ipsa magnam deleniti at.	Accusantium iusto totam quis iste maiores.	2025-09-08	Laboriosam et ipsam voluptate optio facere laborum.	2025-08-27	15:30	3	pending	APT11523	\N
10525	277	7	2025-08-27 13:45:00	High BP	Follow-up	Alias nostrum praesentium repellendus iusto modi.	2025-06-26 22:30:08	2025-06-26 22:30:08	120/68	80	97.9	98	68	Eum earum ad suscipit tenetur.	Quam fugiat tempore repellendus repellat exercitationem facere.	2025-09-09	Corrupti esse aliquam architecto vel excepturi.	2025-08-27	13:45	3	pending	APT11524	\N
10526	378	8	2025-08-27 16:45:00	Fever	New	Adipisci saepe numquam.	2025-06-26 22:30:08	2025-06-26 22:30:08	117/64	73	98.6	99	74	Fugiat iure incidunt occaecati ipsa.	Dolores dolorum quod labore cupiditate perferendis quam.	2025-09-09	Inventore eaque numquam quis assumenda praesentium.	2025-08-27	16:45	3	pending	APT11525	\N
10527	354	3	2025-08-27 12:45:00	High BP	Emergency	Libero suscipit dolor tempora iure numquam illum.	2025-06-26 22:30:08	2025-06-26 22:30:08	132/61	68	98.7	97	58	Odit alias quibusdam laborum eveniet.	Facilis quos consequatur autem omnis aliquid nam doloribus doloremque perspiciatis dolor.	2025-09-13	In blanditiis unde iste.	2025-08-27	12:45	3	pending	APT11526	\N
10528	335	3	2025-08-27 12:30:00	High BP	Emergency	Porro impedit accusamus aspernatur.	2025-06-26 22:30:08	2025-06-26 22:30:08	109/80	77	99.3	96	65	Odio fugit omnis fugit aliquam nam vel.	Ut exercitationem odit dolorem delectus officia cum aliquam architecto architecto voluptatem.	2025-09-21	Nemo ipsam modi consequatur tempore nulla quam.	2025-08-27	12:30	3	pending	APT11527	\N
10529	24	8	2025-08-27 11:45:00	Fever	Follow-up	Similique maxime fugiat quas expedita facere ut.	2025-06-26 22:30:08	2025-06-26 22:30:08	119/79	84	99.5	97	71	Perspiciatis sint eum.	Beatae repudiandae nihil aspernatur.	2025-09-13	Quaerat nesciunt officiis sed dolore cumque.	2025-08-27	11:45	3	pending	APT11528	\N
10530	462	7	2025-08-27 15:15:00	Skin Rash	OPD	Eaque dicta culpa explicabo libero.	2025-06-26 22:30:08	2025-06-26 22:30:08	132/63	81	99.7	95	79	Maiores occaecati ab.	Quas minus dolorem nobis quam fuga animi quidem.	2025-09-10	Iste eum laboriosam tempore et architecto expedita.	2025-08-27	15:15	3	pending	APT11529	\N
10531	14	9	2025-08-27 14:30:00	Fever	Follow-up	Recusandae voluptatum reprehenderit necessitatibus.	2025-06-26 22:30:08	2025-06-26 22:30:08	107/67	72	98.9	96	85	Quidem beatae quo quo expedita.	Quis repellendus inventore magnam harum recusandae iusto.	2025-09-14	Similique quod quod inventore laboriosam placeat sunt sint.	2025-08-27	14:30	3	pending	APT11530	\N
10532	83	10	2025-08-27 14:45:00	Skin Rash	OPD	Enim modi culpa esse.	2025-06-26 22:30:08	2025-06-26 22:30:08	112/82	66	98.2	96	78	Vel assumenda nam consequatur. Fugit consequatur iusto ex.	Quia quos modi ut ipsa rerum accusamus quos soluta optio.	2025-09-07	Eum incidunt sit laboriosam.	2025-08-27	14:45	3	pending	APT11531	\N
10533	119	4	2025-08-27 15:00:00	Routine Checkup	Emergency	Eligendi vero ipsam illo a officiis ex.	2025-06-26 22:30:08	2025-06-26 22:30:08	134/70	82	99.0	99	77	Nisi tempore porro. Ad neque illo dolor.	Iste tempora incidunt praesentium libero.	2025-09-05	Delectus doloribus et id quod culpa.	2025-08-27	15:00	3	pending	APT11532	\N
10534	357	8	2025-08-27 16:00:00	Cough	New	Sit id quibusdam inventore debitis.	2025-06-26 22:30:08	2025-06-26 22:30:08	126/75	80	99.5	100	59	Enim amet quaerat error. Ipsum doloribus officia in et.	Consequatur tempore officia quam sequi cum vitae illum reprehenderit libero.	2025-09-09	Dolores corporis molestias placeat ex.	2025-08-27	16:00	3	pending	APT11533	\N
10535	64	5	2025-08-27 16:15:00	Headache	Emergency	Dolorum ad perferendis quod nostrum odit.	2025-06-26 22:30:08	2025-06-26 22:30:08	133/88	99	98.9	100	74	Praesentium ratione modi cupiditate hic.	Veniam asperiores magnam dolorem a exercitationem.	2025-09-07	Vel repellendus quaerat quasi similique.	2025-08-27	16:15	3	pending	APT11534	\N
10536	219	3	2025-08-27 15:00:00	Back Pain	OPD	Soluta distinctio suscipit veritatis itaque maiores quisquam illo.	2025-06-26 22:30:08	2025-06-26 22:30:08	103/87	75	98.3	100	73	Id sequi quod neque ullam sint inventore.	Alias architecto asperiores odit eos eveniet alias laborum.	2025-09-25	Ab fugit consequatur accusamus tempora repudiandae voluptatibus.	2025-08-27	15:00	3	pending	APT11535	\N
10537	211	8	2025-08-27 15:45:00	Fever	Emergency	Assumenda hic magni id velit eius voluptates autem.	2025-06-26 22:30:08	2025-06-26 22:30:08	126/83	69	97.8	99	84	Ipsa doloremque nam quia odio quas.	Dolore eos id eos voluptatum et fugiat voluptatem.	2025-09-12	Voluptatem quo autem tempora voluptate nobis provident voluptatem.	2025-08-27	15:45	3	pending	APT11536	\N
10538	8	8	2025-08-27 11:00:00	Diabetes Check	Emergency	Autem repellat exercitationem nostrum corporis dolor.	2025-06-26 22:30:08	2025-06-26 22:30:08	130/90	73	99.8	98	85	Tenetur qui ullam itaque amet.	Eius quos facilis omnis vitae illo aliquid eius quasi.	2025-09-03	Eveniet occaecati veritatis nisi quo.	2025-08-27	11:00	3	pending	APT11537	\N
10539	201	6	2025-08-27 15:45:00	Fever	New	Eveniet odit vitae commodi tenetur.	2025-06-26 22:30:08	2025-06-26 22:30:08	138/64	90	100.1	97	82	Amet necessitatibus in laborum at esse sequi.	Quisquam deserunt veniam consequatur praesentium nihil.	2025-09-14	Voluptatibus dolorem laboriosam reprehenderit voluptate repellat distinctio.	2025-08-27	15:45	3	pending	APT11538	\N
10540	192	4	2025-08-27 11:00:00	Fever	OPD	Voluptatum delectus expedita.	2025-06-26 22:30:08	2025-06-26 22:30:08	138/72	98	98.7	100	61	Nobis rem ea autem velit ullam laboriosam.	Nobis quod consequatur consequuntur nobis voluptatem.	2025-09-07	Ab ipsa sed ipsam iure odio expedita.	2025-08-27	11:00	3	pending	APT11539	\N
10541	499	3	2025-08-27 16:00:00	Skin Rash	Follow-up	Sit provident occaecati alias alias.	2025-06-26 22:30:08	2025-06-26 22:30:08	127/86	80	99.6	95	72	Neque dolor omnis repellat sint repellat consectetur.	Facere numquam odit omnis autem accusantium a temporibus libero.	2025-09-16	Distinctio eveniet error.	2025-08-27	16:00	3	pending	APT11540	\N
10542	315	5	2025-08-27 16:00:00	Fever	New	Sequi magnam reiciendis eos.	2025-06-26 22:30:08	2025-06-26 22:30:08	136/90	77	97.9	98	69	Aliquid eveniet molestias excepturi.	Hic consequatur officia quam architecto porro temporibus ipsa fuga.	2025-09-04	Eligendi officiis aspernatur voluptate.	2025-08-27	16:00	3	pending	APT11541	\N
10543	44	8	2025-08-28 14:00:00	Back Pain	Follow-up	Sint provident beatae.	2025-06-26 22:30:08	2025-06-26 22:30:08	120/74	99	97.9	98	78	Quam veniam facere enim sequi.	Assumenda ut fuga provident nulla quo nisi placeat magnam.	2025-09-14	Sapiente consectetur assumenda nobis.	2025-08-28	14:00	3	pending	APT11542	\N
10544	341	8	2025-08-28 14:45:00	Back Pain	Follow-up	Molestiae vero laudantium reprehenderit corrupti voluptates quaerat esse.	2025-06-26 22:30:08	2025-06-26 22:30:08	121/86	82	100.4	95	80	Maiores odio pariatur accusantium repellendus ipsum.	Quae totam voluptatum qui iste cupiditate enim in soluta occaecati enim.	2025-09-23	Ratione illum aperiam minima enim.	2025-08-28	14:45	3	pending	APT11543	\N
10545	307	4	2025-08-28 15:00:00	Routine Checkup	OPD	Hic illo ipsam laboriosam incidunt.	2025-06-26 22:30:08	2025-06-26 22:30:08	134/69	69	100.4	100	80	Exercitationem vel laborum.	Delectus eum nam dolore doloribus nam quis non cum.	2025-09-19	Aliquam laudantium iure cupiditate.	2025-08-28	15:00	3	pending	APT11544	\N
10546	347	10	2025-08-28 13:15:00	Diabetes Check	OPD	Beatae officiis impedit sequi.	2025-06-26 22:30:08	2025-06-26 22:30:08	106/79	89	98.2	98	85	Officia dolorum repellat est.	Iste fugit excepturi suscipit.	2025-09-07	Autem ea impedit vero reprehenderit.	2025-08-28	13:15	3	pending	APT11545	\N
10547	464	9	2025-08-28 15:30:00	Fever	New	Voluptatum nisi et officia occaecati.	2025-06-26 22:30:08	2025-06-26 22:30:08	121/79	69	99.9	97	73	Quo possimus laboriosam similique voluptates.	Consectetur qui ab adipisci porro deserunt corporis unde.	2025-09-12	Dignissimos soluta adipisci iste dolor optio aliquam.	2025-08-28	15:30	3	pending	APT11546	\N
10548	250	5	2025-08-28 11:00:00	Routine Checkup	Follow-up	Odit ipsa laudantium repudiandae autem impedit temporibus.	2025-06-26 22:30:08	2025-06-26 22:30:08	111/82	99	100.1	99	57	Ipsum rem autem animi necessitatibus iste dicta explicabo.	Impedit possimus accusamus repellat id aperiam.	2025-09-12	Autem placeat possimus.	2025-08-28	11:00	3	pending	APT11547	\N
10549	302	8	2025-08-28 15:45:00	High BP	Follow-up	Sed blanditiis enim eaque fugiat nam optio animi.	2025-06-26 22:30:08	2025-06-26 22:30:08	127/86	98	97.7	98	59	Illum tempore quo quisquam voluptatem eligendi.	Sit architecto ab praesentium doloremque.	2025-09-19	Tempora hic dicta inventore.	2025-08-28	15:45	3	pending	APT11548	\N
10550	378	4	2025-08-28 14:00:00	Back Pain	New	Saepe fuga expedita est temporibus et.	2025-06-26 22:30:08	2025-06-26 22:30:08	138/74	91	99.1	100	63	Corrupti suscipit neque totam nisi doloremque quasi nisi.	Quae accusantium enim reprehenderit suscipit nesciunt assumenda quibusdam aliquam quo.	2025-09-23	In esse minus.	2025-08-28	14:00	3	pending	APT11549	\N
10551	5	10	2025-08-28 15:45:00	High BP	New	Magnam ea dicta et iusto officia.	2025-06-26 22:30:08	2025-06-26 22:30:08	124/88	65	98.2	99	66	Quam ducimus debitis quo minima dolorem exercitationem.	Cum expedita placeat autem deserunt quidem sequi mollitia cumque distinctio.	2025-09-18	Accusamus dignissimos ullam ducimus illum.	2025-08-28	15:45	3	pending	APT11550	\N
10552	318	8	2025-08-28 12:15:00	Skin Rash	Emergency	Maxime debitis tempore inventore cumque voluptatibus odit.	2025-06-26 22:30:08	2025-06-26 22:30:08	114/62	73	99.9	98	65	Dolores deserunt fugiat dolorum. In hic neque.	Amet deserunt animi sunt vero eius tempore illum illum.	2025-09-14	Nam molestias vel iste repellat.	2025-08-28	12:15	3	pending	APT11551	\N
10553	199	7	2025-08-28 14:45:00	Routine Checkup	New	Impedit illum reprehenderit porro ipsa.	2025-06-26 22:30:08	2025-06-26 22:30:08	137/80	73	97.9	100	79	Animi unde aliquid.	Quasi illum neque culpa dolore illum mollitia mollitia.	2025-09-14	Optio voluptate consectetur ipsum quas.	2025-08-28	14:45	3	pending	APT11552	\N
10554	440	8	2025-08-28 12:30:00	Back Pain	OPD	Ipsam consectetur reprehenderit blanditiis recusandae voluptatibus.	2025-06-26 22:30:08	2025-06-26 22:30:08	111/72	98	99.9	97	66	Dolores commodi aliquid sequi ipsa suscipit aliquam quidem.	Doloremque animi error totam numquam eligendi.	2025-09-10	Esse doloribus adipisci incidunt doloremque quidem similique.	2025-08-28	12:30	3	pending	APT11553	\N
10555	93	6	2025-08-28 11:15:00	Fever	Follow-up	Velit ut velit incidunt nesciunt alias nesciunt.	2025-06-26 22:30:08	2025-06-26 22:30:08	126/73	84	99.0	97	64	Suscipit at perferendis dolore.	Vel in animi occaecati ex.	2025-09-26	Quibusdam maiores quae ipsum.	2025-08-28	11:15	3	pending	APT11554	\N
10556	298	6	2025-08-28 13:00:00	Cough	Emergency	Sed nostrum laboriosam ab.	2025-06-26 22:30:08	2025-06-26 22:30:08	128/69	82	99.1	98	71	Voluptatum fuga molestiae porro eveniet magni.	Porro error autem dolorum cumque.	2025-09-20	Eveniet ullam aut possimus dolor.	2025-08-28	13:00	3	pending	APT11555	\N
10557	334	10	2025-08-28 12:45:00	Skin Rash	New	Voluptatum laborum odit vero ea.	2025-06-26 22:30:08	2025-06-26 22:30:08	106/74	89	99.1	98	56	Odit saepe vel provident sed. Eum possimus officia eum.	Culpa omnis est soluta voluptatum alias quaerat.	2025-09-08	Dolorum adipisci fuga debitis corrupti.	2025-08-28	12:45	3	pending	APT11556	\N
10558	45	6	2025-08-28 11:30:00	Skin Rash	OPD	Non vitae quaerat adipisci ratione qui.	2025-06-26 22:30:08	2025-06-26 22:30:08	122/60	99	98.2	98	74	Voluptates accusantium consectetur reprehenderit id.	Tempora saepe blanditiis laborum quam sint expedita ex voluptatem exercitationem at.	2025-09-25	Ullam porro nemo.	2025-08-28	11:30	3	pending	APT11557	\N
10559	216	8	2025-08-28 16:15:00	Skin Rash	OPD	Dolores esse facere temporibus architecto ipsa est cupiditate.	2025-06-26 22:30:08	2025-06-26 22:30:08	138/86	73	98.8	95	72	Doloribus commodi nostrum dignissimos quasi.	Asperiores nam earum repudiandae odio libero consequuntur natus ab.	2025-09-17	Architecto neque autem amet cupiditate assumenda.	2025-08-28	16:15	3	pending	APT11558	\N
10560	177	5	2025-08-28 13:45:00	High BP	Emergency	Doloribus consequatur eius.	2025-06-26 22:30:08	2025-06-26 22:30:08	113/75	97	100.3	100	58	Facere velit aliquid animi.	Possimus repellat eos quo quam commodi error fuga.	2025-09-07	Est minima quas rerum.	2025-08-28	13:45	3	pending	APT11559	\N
10561	443	3	2025-08-28 14:45:00	Routine Checkup	OPD	Suscipit veniam similique aut mollitia officiis tempore molestias.	2025-06-26 22:30:08	2025-06-26 22:30:08	139/73	82	98.1	95	58	Quam error hic labore repellat ad.	Sequi iure hic magnam quo voluptatem pariatur.	2025-09-27	Vero repudiandae accusantium perspiciatis.	2025-08-28	14:45	3	pending	APT11560	\N
10562	344	5	2025-08-28 12:45:00	Cough	Follow-up	Commodi laboriosam dicta neque placeat illum.	2025-06-26 22:30:08	2025-06-26 22:30:08	129/84	70	98.3	98	81	Amet nam labore odit. Neque consectetur dignissimos.	A nam corrupti saepe error labore enim reprehenderit sunt.	2025-09-26	Nobis culpa aspernatur fugit rem.	2025-08-28	12:45	3	pending	APT11561	\N
10563	31	8	2025-08-28 15:15:00	Cough	OPD	Quasi repellendus incidunt.	2025-06-26 22:30:08	2025-06-26 22:30:08	109/71	74	99.0	98	58	Consequatur odit voluptatum corporis animi.	A accusantium magni necessitatibus quis praesentium id.	2025-09-16	Animi autem placeat rerum magnam vitae iste.	2025-08-28	15:15	3	pending	APT11562	\N
10564	411	8	2025-08-28 14:15:00	Headache	Emergency	Non dolor dolorum quibusdam nemo.	2025-06-26 22:30:08	2025-06-26 22:30:08	130/60	94	98.3	99	63	Dolorum molestiae magni repellendus.	Est at eius dolor earum repellat ipsa illo voluptate.	2025-09-04	Voluptatibus dolore consequuntur maiores voluptatum.	2025-08-28	14:15	3	pending	APT11563	\N
10565	20	6	2025-08-28 16:15:00	Diabetes Check	OPD	Voluptate dolorum quae beatae saepe illum.	2025-06-26 22:30:08	2025-06-26 22:30:08	114/85	67	99.4	97	60	Culpa possimus vitae ipsam in ea.	Illum et ab labore molestias ab.	2025-09-16	Veritatis et atque vero quas rerum.	2025-08-28	16:15	3	pending	APT11564	\N
10566	489	10	2025-08-29 14:00:00	Skin Rash	Follow-up	Ullam id perspiciatis soluta reiciendis.	2025-06-26 22:30:08	2025-06-26 22:30:08	116/82	89	98.7	96	64	Facere repellendus quidem.	Rerum non velit quisquam id et.	2025-09-06	Hic voluptas placeat vero in.	2025-08-29	14:00	3	pending	APT11565	\N
10567	465	4	2025-08-29 16:00:00	Back Pain	New	Autem voluptatum eveniet ea voluptatum eius.	2025-06-26 22:30:08	2025-06-26 22:30:08	129/69	71	99.1	100	69	Fuga id natus ipsam voluptatum possimus.	In incidunt corrupti fugit rem iure perferendis quisquam.	2025-09-23	Nesciunt eius ipsa tenetur eius ab necessitatibus perspiciatis.	2025-08-29	16:00	3	pending	APT11566	\N
10568	436	6	2025-08-29 13:15:00	Skin Rash	Follow-up	Voluptatem mollitia animi ad.	2025-06-26 22:30:08	2025-06-26 22:30:08	106/69	76	99.8	99	84	Adipisci animi dicta commodi. Mollitia quaerat sit neque.	Similique quaerat amet id quis odio.	2025-09-12	Assumenda nam facilis.	2025-08-29	13:15	3	pending	APT11567	\N
10569	398	5	2025-08-29 12:00:00	Skin Rash	Emergency	Suscipit sed repellendus laboriosam eius voluptate cupiditate.	2025-06-26 22:30:08	2025-06-26 22:30:08	117/79	87	100.1	100	75	Hic facilis corporis eos autem laborum.	Quidem exercitationem fuga tempora provident sunt.	2025-09-26	Fugit sunt a.	2025-08-29	12:00	3	pending	APT11568	\N
10570	259	10	2025-08-29 11:15:00	Diabetes Check	Follow-up	Libero tempore modi reiciendis rem culpa.	2025-06-26 22:30:08	2025-06-26 22:30:08	123/80	66	97.9	99	74	Sint quia maxime necessitatibus commodi vitae quod.	Reiciendis veritatis quam eum beatae.	2025-09-23	Magnam ducimus ducimus explicabo.	2025-08-29	11:15	3	pending	APT11569	\N
10571	253	3	2025-08-29 13:30:00	Routine Checkup	New	Fuga distinctio neque quod eos.	2025-06-26 22:30:08	2025-06-26 22:30:08	127/66	78	99.6	99	59	Sequi eum id itaque. Possimus autem voluptates amet.	Earum maiores qui eius eius quis veritatis aut nulla quam.	2025-09-13	Eos doloremque repudiandae tempora veritatis odio magni.	2025-08-29	13:30	3	pending	APT11570	\N
10572	83	5	2025-08-29 11:45:00	Cough	Follow-up	Modi aspernatur facere.	2025-06-26 22:30:08	2025-06-26 22:30:08	121/86	95	99.7	98	70	Similique tempore quis temporibus laudantium neque.	Officiis molestias accusamus amet vero.	2025-09-16	Ab eos omnis consequatur corrupti officiis.	2025-08-29	11:45	3	pending	APT11571	\N
10573	68	4	2025-08-29 15:45:00	Fever	Follow-up	Eaque deleniti aliquid voluptas iusto placeat quasi maiores.	2025-06-26 22:30:08	2025-06-26 22:30:08	132/87	91	100.3	95	61	Suscipit maxime sapiente ipsum voluptatum excepturi.	Et commodi reprehenderit ipsam impedit quaerat non.	2025-09-09	Iste omnis voluptatem natus quam at.	2025-08-29	15:45	3	pending	APT11572	\N
10574	25	10	2025-08-29 16:15:00	Fever	New	Repudiandae eligendi quisquam laudantium.	2025-06-26 22:30:08	2025-06-26 22:30:08	137/85	99	98.6	98	78	Molestias occaecati omnis.	Voluptatibus nisi similique inventore expedita laborum officiis qui eius eveniet.	2025-09-27	Impedit vel facilis dolore omnis numquam delectus.	2025-08-29	16:15	3	pending	APT11573	\N
10575	55	9	2025-08-29 11:30:00	Back Pain	OPD	Voluptas dolorem nihil aspernatur soluta.	2025-06-26 22:30:08	2025-06-26 22:30:08	132/72	91	97.7	100	69	Atque earum earum similique impedit aliquid iure.	Fuga dolores iusto eveniet sit voluptatum velit eligendi architecto voluptas.	2025-09-24	Doloribus aliquam ratione odio.	2025-08-29	11:30	3	pending	APT11574	\N
10576	313	6	2025-08-29 15:15:00	Back Pain	OPD	Voluptatem magnam ratione provident labore quis non.	2025-06-26 22:30:08	2025-06-26 22:30:08	101/62	77	98.1	96	73	Nostrum voluptates eaque distinctio adipisci quas soluta.	Blanditiis illo alias tenetur tenetur commodi praesentium soluta iste similique.	2025-09-22	Tempore doloribus earum quas at ipsa repellendus.	2025-08-29	15:15	3	pending	APT11575	\N
10577	354	4	2025-08-29 13:15:00	Routine Checkup	OPD	Qui odit quas eaque impedit at.	2025-06-26 22:30:08	2025-06-26 22:30:08	103/78	80	97.5	96	83	Aut modi nihil est deleniti blanditiis asperiores.	Mollitia autem quia vero veritatis hic voluptas quis voluptatem fugit corporis.	2025-09-23	Provident eveniet quidem minus quaerat rem.	2025-08-29	13:15	3	pending	APT11576	\N
10578	486	10	2025-08-29 14:00:00	Fever	Follow-up	Molestias eos cum ex harum accusantium commodi.	2025-06-26 22:30:08	2025-06-26 22:30:08	127/77	85	98.1	98	59	Distinctio sapiente nisi voluptas. Id atque quas quas.	Corporis deleniti doloribus praesentium libero distinctio.	2025-09-09	Consequuntur nisi quibusdam et praesentium quo.	2025-08-29	14:00	3	pending	APT11577	\N
10579	300	6	2025-08-29 11:45:00	Routine Checkup	Emergency	Quis mollitia fugiat ratione hic.	2025-06-26 22:30:08	2025-06-26 22:30:08	113/76	98	98.8	100	60	Accusantium officiis voluptatum doloribus.	A excepturi laboriosam culpa.	2025-09-19	Dolores quasi aut officiis rerum alias.	2025-08-29	11:45	3	pending	APT11578	\N
10580	159	3	2025-08-29 15:00:00	Headache	Emergency	Blanditiis repellat fuga.	2025-06-26 22:30:08	2025-06-26 22:30:08	111/70	84	99.0	99	83	Iusto hic labore distinctio.	Minima voluptates autem quibusdam temporibus iste nobis maiores recusandae distinctio.	2025-09-08	Id maxime ipsum expedita nihil.	2025-08-29	15:00	3	pending	APT11579	\N
10581	287	9	2025-08-29 14:00:00	Fever	OPD	Autem nobis vitae eos distinctio corporis.	2025-06-26 22:30:08	2025-06-26 22:30:08	121/84	67	97.7	98	66	Quidem debitis reiciendis inventore tenetur nemo velit.	Aliquid distinctio eveniet commodi expedita animi velit minus ab cupiditate.	2025-09-09	Laboriosam veritatis facilis quaerat similique aliquam.	2025-08-29	14:00	3	pending	APT11580	\N
10582	77	7	2025-08-29 14:15:00	High BP	New	Blanditiis nemo pariatur veniam rem laborum assumenda eligendi.	2025-06-26 22:30:08	2025-06-26 22:30:08	135/83	78	99.4	97	60	Dolore sint ipsa iusto voluptate.	Corrupti dignissimos expedita ipsa sit recusandae soluta.	2025-09-22	Eius id mollitia veniam nihil inventore velit.	2025-08-29	14:15	3	pending	APT11581	\N
10583	4	7	2025-08-29 12:15:00	High BP	OPD	Delectus asperiores aliquid nulla saepe ex culpa.	2025-06-26 22:30:08	2025-06-26 22:30:08	111/70	98	98.6	95	66	Impedit atque esse officiis ut eveniet nemo.	Blanditiis nobis reprehenderit odit aliquam.	2025-09-23	Deserunt dolorem iure rem atque suscipit.	2025-08-29	12:15	3	pending	APT11582	\N
10584	286	9	2025-08-29 14:30:00	Back Pain	New	Porro maiores est.	2025-06-26 22:30:08	2025-06-26 22:30:08	115/85	73	99.6	99	78	Corrupti praesentium tempora quam iure distinctio error.	Maiores neque veritatis neque doloremque nulla ipsum natus nobis magni.	2025-09-15	Asperiores sequi labore distinctio deleniti voluptate dicta.	2025-08-29	14:30	3	pending	APT11583	\N
10585	459	7	2025-08-29 14:15:00	Skin Rash	OPD	Ab quas suscipit quaerat quia.	2025-06-26 22:30:08	2025-06-26 22:30:08	113/82	73	97.6	99	80	Aspernatur iusto optio non reprehenderit commodi.	Similique eius facilis perspiciatis fugit possimus.	2025-09-27	Voluptas quam rem maiores harum.	2025-08-29	14:15	3	pending	APT11584	\N
10586	132	10	2025-08-29 14:30:00	Routine Checkup	OPD	Fugit dolorum culpa iure repellat accusantium.	2025-06-26 22:30:08	2025-06-26 22:30:08	130/87	100	98.6	99	60	Dicta quasi repudiandae voluptatum repellendus.	Odio nostrum aliquam quaerat.	2025-09-19	Qui cum laborum culpa soluta hic dolores.	2025-08-29	14:30	3	pending	APT11585	\N
10587	499	4	2025-08-29 11:30:00	Cough	Emergency	Incidunt voluptas fuga vitae sint consequuntur.	2025-06-26 22:30:08	2025-06-26 22:30:08	120/61	65	98.4	95	63	Unde incidunt quaerat placeat dignissimos dolor atque.	Culpa architecto facere officia consequuntur laudantium eos error aliquam mollitia.	2025-09-27	Error labore fugiat nemo commodi quisquam.	2025-08-29	11:30	3	pending	APT11586	\N
10588	210	5	2025-08-29 16:00:00	Diabetes Check	Emergency	Suscipit minima voluptatum mollitia quibusdam.	2025-06-26 22:30:08	2025-06-26 22:30:08	112/79	65	100.2	98	75	Quod a voluptates maiores cum mollitia.	Qui voluptatem iste sapiente ad debitis.	2025-09-13	Recusandae magnam fugiat assumenda totam saepe sed.	2025-08-29	16:00	3	pending	APT11587	\N
10589	143	9	2025-08-29 16:00:00	Fever	Emergency	Reprehenderit ab eveniet recusandae fugiat impedit minus.	2025-06-26 22:30:08	2025-06-26 22:30:08	136/81	96	97.5	96	83	Aspernatur eius vel labore veniam qui necessitatibus.	Quisquam laboriosam itaque incidunt maiores.	2025-09-25	Molestiae nam ex non impedit.	2025-08-29	16:00	3	pending	APT11588	\N
10590	283	7	2025-08-29 16:00:00	Diabetes Check	Follow-up	Aliquam eius provident quisquam.	2025-06-26 22:30:08	2025-06-26 22:30:08	117/72	86	97.5	98	75	Ea inventore molestias sapiente quisquam occaecati.	Neque officia voluptatum veritatis blanditiis magni quis quaerat quibusdam voluptatem.	2025-09-21	Modi aut quae.	2025-08-29	16:00	3	pending	APT11589	\N
10591	177	4	2025-08-29 14:00:00	Fever	Follow-up	Nam consectetur odio quis doloremque tempore.	2025-06-26 22:30:08	2025-06-26 22:30:08	130/78	76	100.4	98	70	Tenetur voluptatem fuga necessitatibus commodi explicabo.	Consequatur commodi eum rerum laboriosam voluptas tenetur.	2025-09-14	At quis deleniti error dolores qui.	2025-08-29	14:00	3	pending	APT11590	\N
10592	390	6	2025-08-30 12:15:00	Skin Rash	Follow-up	Ut laborum magnam.	2025-06-26 22:30:08	2025-06-26 22:30:08	134/87	98	97.9	98	74	Nostrum eligendi vero beatae tenetur asperiores.	Molestiae eos nostrum voluptatibus at architecto.	2025-09-28	Deleniti eaque quas sapiente facere alias rem.	2025-08-30	12:15	3	pending	APT11591	\N
10593	208	3	2025-08-30 12:45:00	Skin Rash	Follow-up	Quam inventore eum quidem debitis.	2025-06-26 22:30:08	2025-06-26 22:30:08	135/66	91	99.4	100	66	Occaecati doloribus maiores earum optio.	Voluptatibus est eum architecto modi molestiae.	2025-09-15	Rerum iure ullam doloribus placeat.	2025-08-30	12:45	3	pending	APT11592	\N
10594	231	8	2025-08-30 13:00:00	Back Pain	Emergency	Incidunt ex labore aliquam molestiae delectus atque.	2025-06-26 22:30:08	2025-06-26 22:30:08	131/90	92	98.8	98	71	Itaque veniam laborum architecto debitis explicabo fugiat.	Repellat sequi rerum magnam sequi voluptas voluptates.	2025-09-18	Ad esse consequatur.	2025-08-30	13:00	3	pending	APT11593	\N
10595	204	10	2025-08-30 12:00:00	Fever	New	Quaerat doloribus aliquid delectus itaque facere impedit.	2025-06-26 22:30:08	2025-06-26 22:30:08	134/86	95	98.2	95	75	Quas laudantium itaque quae error dolor.	Expedita fugiat deleniti nesciunt exercitationem optio at nam inventore.	2025-09-11	Cumque quis omnis esse perferendis explicabo laboriosam.	2025-08-30	12:00	3	pending	APT11594	\N
10596	371	5	2025-08-30 15:30:00	Back Pain	New	Facere vero neque ea exercitationem distinctio suscipit.	2025-06-26 22:30:08	2025-06-26 22:30:08	108/63	65	97.6	97	62	Ipsam magnam iusto dicta adipisci repellendus tempora amet.	Ullam consectetur sunt quia voluptatum hic ab.	2025-09-18	Suscipit amet suscipit incidunt.	2025-08-30	15:30	3	pending	APT11595	\N
10597	299	5	2025-08-30 11:15:00	Skin Rash	Follow-up	Magni ullam magni ullam alias.	2025-06-26 22:30:08	2025-06-26 22:30:08	114/83	78	97.7	96	57	Excepturi fuga aliquid fugiat.	Corporis officiis itaque accusantium aspernatur molestiae dolores magni.	2025-09-20	Impedit vitae animi quidem praesentium commodi quod.	2025-08-30	11:15	3	pending	APT11596	\N
10598	232	3	2025-08-30 12:45:00	Headache	Emergency	Sequi aspernatur voluptatum adipisci.	2025-06-26 22:30:08	2025-06-26 22:30:08	115/69	78	100.2	99	70	Nulla non aliquid. Repudiandae inventore repudiandae esse.	Dolorem recusandae dolore voluptatibus culpa aliquid.	2025-09-12	Odit tempora provident itaque saepe.	2025-08-30	12:45	3	pending	APT11597	\N
10599	306	10	2025-08-30 12:00:00	Back Pain	OPD	Animi numquam qui sequi.	2025-06-26 22:30:08	2025-06-26 22:30:08	104/77	69	97.8	98	57	Quae magnam animi quo adipisci perferendis id aliquid.	Non minima maxime incidunt fuga hic.	2025-09-10	Cum explicabo ea omnis asperiores.	2025-08-30	12:00	3	pending	APT11598	\N
10600	298	4	2025-08-30 12:15:00	Diabetes Check	OPD	Earum ea nobis quo excepturi.	2025-06-26 22:30:08	2025-06-26 22:30:08	116/82	90	99.4	96	65	Similique nihil veniam. Nostrum ex sapiente nemo qui.	Distinctio voluptates porro hic dignissimos rem ducimus natus corporis aperiam.	2025-09-17	Dolores fugiat eum est eaque similique veritatis.	2025-08-30	12:15	3	pending	APT11599	\N
10601	273	10	2025-08-30 16:00:00	Fever	New	Laborum sit ratione ullam.	2025-06-26 22:30:08	2025-06-26 22:30:08	113/79	69	98.6	98	85	Odit eligendi aliquam qui sequi dolor.	Nemo voluptate quaerat suscipit deserunt voluptatibus repellat.	2025-09-27	Labore quidem reiciendis eum.	2025-08-30	16:00	3	pending	APT11600	\N
10602	171	8	2025-08-30 13:15:00	Cough	Emergency	Quisquam possimus illum tempora mollitia accusamus tenetur.	2025-06-26 22:30:08	2025-06-26 22:30:08	119/72	92	97.9	95	63	Quia vel dolor. Dolores sequi repellendus aliquid sit.	Corporis quos a molestiae dolores aperiam nulla voluptatum excepturi.	2025-09-29	Amet at quos sit ratione iste molestiae.	2025-08-30	13:15	3	pending	APT11601	\N
10603	396	8	2025-08-30 11:30:00	Skin Rash	Follow-up	Minima iste ipsam.	2025-06-26 22:30:08	2025-06-26 22:30:08	107/88	78	99.6	97	72	Autem molestias exercitationem quidem quos.	Perferendis fugiat itaque beatae pariatur eos facere optio nam commodi amet.	2025-09-22	Asperiores explicabo aspernatur.	2025-08-30	11:30	3	pending	APT11602	\N
10604	303	6	2025-08-30 15:00:00	Fever	Follow-up	Omnis porro hic laborum ad.	2025-06-26 22:30:08	2025-06-26 22:30:08	120/84	89	98.3	95	65	Maxime temporibus autem vero laborum.	Nesciunt autem fuga facilis ducimus veritatis asperiores minima.	2025-09-16	Similique consectetur iusto minus quod.	2025-08-30	15:00	3	pending	APT11603	\N
10605	134	3	2025-08-30 15:30:00	Routine Checkup	OPD	Error dolorem tenetur saepe sequi itaque dolor.	2025-06-26 22:30:08	2025-06-26 22:30:08	123/72	70	99.1	95	67	Sunt consequatur dolore deserunt a.	Aperiam illo quo molestiae veritatis voluptatem nulla maiores cum dignissimos.	2025-09-14	Inventore corrupti recusandae velit.	2025-08-30	15:30	3	pending	APT11604	\N
10606	46	3	2025-08-30 11:45:00	Routine Checkup	Emergency	Accusantium et in vitae.	2025-06-26 22:30:08	2025-06-26 22:30:08	103/79	94	100.5	98	77	Quidem vitae harum praesentium eius aliquam.	Veniam a ipsa eaque est debitis similique in officia.	2025-09-13	Excepturi at id enim laborum.	2025-08-30	11:45	3	pending	APT11605	\N
10607	245	6	2025-08-30 12:30:00	High BP	OPD	Voluptas eaque odio.	2025-06-26 22:30:08	2025-06-26 22:30:08	134/87	77	98.5	99	65	Eaque labore illo quidem.	Magnam architecto nisi quia in aspernatur ad suscipit dolorum.	2025-09-12	Asperiores cum modi natus a reiciendis quam.	2025-08-30	12:30	3	pending	APT11606	\N
10608	312	6	2025-08-30 16:30:00	Diabetes Check	New	Est eum sint deleniti illo placeat aperiam.	2025-06-26 22:30:08	2025-06-26 22:30:08	108/68	77	98.9	97	71	Similique dolores voluptates at debitis.	Voluptatibus quas quam pariatur expedita expedita temporibus deleniti deserunt fuga dolorum.	2025-09-18	Sed ipsa commodi animi maxime laborum veritatis.	2025-08-30	16:30	3	pending	APT11607	\N
10609	436	4	2025-08-30 16:00:00	High BP	OPD	Facilis pariatur temporibus ipsa provident delectus doloribus.	2025-06-26 22:30:08	2025-06-26 22:30:08	111/67	74	97.6	98	84	Dolore quisquam est perferendis expedita culpa ducimus.	Cupiditate sapiente tempore expedita molestiae iusto facere incidunt.	2025-09-10	Omnis consectetur necessitatibus a explicabo tenetur.	2025-08-30	16:00	3	pending	APT11608	\N
10610	326	8	2025-08-30 11:15:00	High BP	Follow-up	Architecto possimus doloremque aspernatur dolor quos.	2025-06-26 22:30:08	2025-06-26 22:30:08	125/89	98	99.6	97	68	Voluptate quia sed unde natus.	Quod beatae eum nesciunt omnis quis.	2025-09-19	Quidem asperiores consequuntur a inventore modi.	2025-08-30	11:15	3	pending	APT11609	\N
10611	13	8	2025-08-30 12:00:00	Routine Checkup	New	Cum quos magni enim dolorum.	2025-06-26 22:30:08	2025-06-26 22:30:08	100/74	96	99.4	98	56	Fugiat consectetur enim nostrum cum.	Culpa eligendi perspiciatis ratione hic voluptate.	2025-09-27	Nihil tempora doloremque consectetur voluptatum in dolor.	2025-08-30	12:00	3	pending	APT11610	\N
10612	356	8	2025-08-30 13:00:00	Cough	OPD	Hic natus nulla laborum voluptas necessitatibus aut.	2025-06-26 22:30:08	2025-06-26 22:30:08	111/72	77	97.7	96	56	Similique debitis pariatur recusandae odit aperiam.	Magni facilis voluptate fugiat nulla necessitatibus.	2025-09-12	Laboriosam porro dolores sed nemo occaecati laudantium dolore.	2025-08-30	13:00	3	pending	APT11611	\N
10613	410	3	2025-08-30 13:45:00	High BP	Emergency	Necessitatibus iste placeat incidunt odio nesciunt.	2025-06-26 22:30:08	2025-06-26 22:30:08	111/89	90	100.0	99	58	Excepturi porro tenetur minima nam fugit.	Iusto hic atque officiis architecto tempore itaque voluptatibus earum omnis.	2025-09-20	Exercitationem molestias necessitatibus repudiandae voluptates magnam rerum.	2025-08-30	13:45	3	pending	APT11612	\N
10614	376	9	2025-08-30 12:45:00	High BP	New	Est autem nesciunt mollitia porro.	2025-06-26 22:30:08	2025-06-26 22:30:08	121/76	100	97.6	100	85	Dolore omnis iusto distinctio mollitia.	Quae sequi nemo iste error atque temporibus laudantium qui laudantium.	2025-09-20	Nobis suscipit nam temporibus similique adipisci accusamus.	2025-08-30	12:45	3	pending	APT11613	\N
10615	171	9	2025-08-30 15:30:00	Headache	Emergency	Ex sequi porro corporis.	2025-06-26 22:30:08	2025-06-26 22:30:08	112/82	96	100.5	97	56	Quam aliquid sint officia in qui.	Nam qui alias ipsam accusamus suscipit.	2025-09-23	Corporis suscipit ex excepturi mollitia corporis.	2025-08-30	15:30	3	pending	APT11614	\N
10616	415	5	2025-08-30 13:45:00	Headache	New	Eos repellat facilis vero culpa.	2025-06-26 22:30:08	2025-06-26 22:30:08	136/87	73	100.3	97	60	Quia quasi quis asperiores in at architecto enim.	Itaque esse cupiditate veniam optio eos voluptatibus.	2025-09-13	Vitae delectus quaerat amet.	2025-08-30	13:45	3	pending	APT11615	\N
10617	439	6	2025-08-30 11:45:00	Fever	Emergency	Minus illo alias beatae.	2025-06-26 22:30:08	2025-06-26 22:30:08	107/62	89	99.0	95	69	Temporibus nulla libero nesciunt.	Repellendus illo ut tempora dolore et repellendus.	2025-09-21	Doloribus molestias ex doloremque libero.	2025-08-30	11:45	3	pending	APT11616	\N
10618	28	10	2025-08-30 15:30:00	Headache	Follow-up	Laboriosam iure sed repudiandae possimus impedit quo.	2025-06-26 22:30:08	2025-06-26 22:30:08	103/65	91	100.5	98	66	Mollitia natus temporibus ex.	Assumenda magnam quae deserunt tenetur minus accusantium sapiente atque.	2025-09-21	Cum nesciunt iure perspiciatis.	2025-08-30	15:30	3	pending	APT11617	\N
10619	173	3	2025-08-31 11:15:00	Routine Checkup	Follow-up	Rem dolorum quo perspiciatis beatae quia aperiam distinctio.	2025-06-26 22:30:08	2025-06-26 22:30:08	105/65	82	97.8	95	71	Ab repellendus consequatur officiis.	Fugit maiores maiores commodi cupiditate repellendus eum vel consectetur in.	2025-09-08	Fugit dicta non unde officia magnam.	2025-08-31	11:15	3	pending	APT11618	\N
10620	245	5	2025-08-31 12:30:00	Cough	New	Cumque consectetur consectetur sapiente.	2025-06-26 22:30:08	2025-06-26 22:30:08	129/62	76	99.3	95	80	Reprehenderit optio aliquid repudiandae distinctio.	Non necessitatibus quibusdam commodi earum repellat cupiditate.	2025-09-21	Asperiores accusamus deleniti non.	2025-08-31	12:30	3	pending	APT11619	\N
10621	437	8	2025-08-31 14:15:00	Fever	OPD	Itaque ea itaque illum.	2025-06-26 22:30:08	2025-06-26 22:30:08	118/64	80	99.0	96	56	Iste corrupti veniam corrupti. Porro nesciunt explicabo.	Expedita consectetur nisi sunt dolor doloribus optio.	2025-09-17	Architecto velit tempore dignissimos sapiente ea.	2025-08-31	14:15	3	pending	APT11620	\N
10622	192	4	2025-08-31 12:15:00	Diabetes Check	New	Ducimus consectetur expedita.	2025-06-26 22:30:08	2025-06-26 22:30:08	123/89	70	98.4	97	56	Nemo quaerat consequuntur quisquam molestiae ad minus.	Dolores dolorem nihil unde omnis amet fugiat nobis numquam perspiciatis.	2025-09-18	Ducimus id tempore.	2025-08-31	12:15	3	pending	APT11621	\N
10623	401	9	2025-08-31 16:15:00	Cough	Emergency	Similique vero maxime est aliquam dignissimos et.	2025-06-26 22:30:08	2025-06-26 22:30:08	111/85	81	100.3	95	57	Laudantium aliquid hic ipsum nobis porro at.	Non natus excepturi commodi exercitationem quia inventore.	2025-09-07	Eligendi nostrum amet laudantium iure nulla cum.	2025-08-31	16:15	3	pending	APT11622	\N
10624	260	6	2025-08-31 13:30:00	Fever	OPD	Excepturi dicta voluptatum hic porro sapiente.	2025-06-26 22:30:08	2025-06-26 22:30:08	104/66	90	98.8	97	82	Pariatur itaque dolorem veniam quod illo a.	Nostrum commodi odio sapiente at doloribus magnam iusto laudantium autem.	2025-09-08	Temporibus officiis placeat eum recusandae harum doloremque.	2025-08-31	13:30	3	pending	APT11623	\N
10625	431	9	2025-08-31 16:45:00	High BP	OPD	Perferendis sequi fugit vel.	2025-06-26 22:30:08	2025-06-26 22:30:08	134/72	86	99.1	96	75	Cumque beatae culpa tenetur voluptatum.	Excepturi quidem magnam sit quaerat cupiditate laudantium.	2025-09-08	Beatae alias illo odio natus totam eius cupiditate.	2025-08-31	16:45	3	pending	APT11624	\N
10626	411	4	2025-08-31 16:45:00	High BP	OPD	Minus mollitia sed tenetur a omnis.	2025-06-26 22:30:08	2025-06-26 22:30:08	106/65	89	98.0	100	80	Vitae commodi dicta reiciendis impedit.	Eum quasi saepe facere illum voluptatum fugiat praesentium sapiente.	2025-09-12	Inventore totam esse exercitationem.	2025-08-31	16:45	3	pending	APT11625	\N
10627	501	8	2025-08-31 15:00:00	Diabetes Check	Emergency	Sint quas ab.	2025-06-26 22:30:08	2025-06-26 22:30:08	132/61	67	100.4	98	85	Impedit nostrum nam autem repellendus iste officia.	Quidem architecto corporis culpa accusantium quaerat illo asperiores similique.	2025-09-08	Odio laboriosam impedit cumque.	2025-08-31	15:00	3	pending	APT11626	\N
10628	40	5	2025-08-31 14:30:00	High BP	Emergency	Sunt nisi veritatis a possimus quas.	2025-06-26 22:30:08	2025-06-26 22:30:08	100/62	87	97.8	95	69	Minima suscipit iste dolorum. Quod neque ea a.	Odit labore animi ut eaque minus et minima impedit.	2025-09-13	Natus ad adipisci consequatur fugit blanditiis.	2025-08-31	14:30	3	pending	APT11627	\N
10629	471	9	2025-08-31 13:45:00	Routine Checkup	New	Reiciendis quaerat debitis error libero.	2025-06-26 22:30:08	2025-06-26 22:30:08	105/73	71	100.4	98	60	Autem magni omnis illum similique quae.	Optio error nulla illum error.	2025-09-26	A eius iusto nulla est tempora.	2025-08-31	13:45	3	pending	APT11628	\N
10630	206	7	2025-08-31 16:30:00	Cough	New	Suscipit porro fugit doloremque.	2025-06-26 22:30:08	2025-06-26 22:30:08	100/73	71	98.5	98	81	Esse similique quod.	Dicta iure delectus iusto sed quis suscipit numquam.	2025-09-07	Deleniti reprehenderit aspernatur adipisci minima.	2025-08-31	16:30	3	pending	APT11629	\N
10631	127	6	2025-08-31 15:15:00	Cough	Emergency	Molestias error fugit iure ratione.	2025-06-26 22:30:08	2025-06-26 22:30:08	100/79	90	100.5	97	82	Harum praesentium impedit ut. In unde tenetur alias.	Vero amet dolorem sunt adipisci tempore maiores.	2025-09-22	Iusto numquam similique quidem magnam.	2025-08-31	15:15	3	pending	APT11630	\N
10632	406	7	2025-08-31 13:45:00	Routine Checkup	OPD	Pariatur et accusamus explicabo.	2025-06-26 22:30:08	2025-06-26 22:30:08	134/64	97	100.1	98	73	Distinctio veritatis ducimus dolore consectetur mollitia.	Voluptatibus possimus voluptatem veritatis incidunt minus laudantium rem.	2025-09-21	Aspernatur fuga sed eos.	2025-08-31	13:45	3	pending	APT11631	\N
10633	158	3	2025-08-31 13:45:00	Back Pain	Follow-up	Officiis assumenda consequuntur occaecati nesciunt cumque mollitia.	2025-06-26 22:30:08	2025-06-26 22:30:08	113/66	78	97.6	96	80	Magni totam consectetur quidem.	Earum exercitationem quo suscipit voluptatibus esse autem quae ipsum.	2025-09-11	Blanditiis magnam nisi tenetur odit cupiditate provident.	2025-08-31	13:45	3	pending	APT11632	\N
10634	169	5	2025-08-31 15:30:00	Routine Checkup	Follow-up	Suscipit exercitationem iure ipsum quos nemo.	2025-06-26 22:30:08	2025-06-26 22:30:08	127/73	78	97.6	100	73	Possimus magni iusto.	Dolor saepe dolor repudiandae aspernatur eius laborum qui quis.	2025-09-20	Odio similique quos nobis commodi vero.	2025-08-31	15:30	3	pending	APT11633	\N
10635	291	4	2025-08-31 11:45:00	Routine Checkup	Follow-up	Eius culpa omnis explicabo omnis.	2025-06-26 22:30:08	2025-06-26 22:30:08	104/88	77	97.9	97	59	Numquam quaerat totam consequuntur aut sequi deleniti.	Rerum ullam aliquid excepturi suscipit cumque officia laborum dolorem placeat maxime.	2025-09-14	Corporis numquam commodi tempore cumque.	2025-08-31	11:45	3	pending	APT11634	\N
10636	281	8	2025-08-31 14:45:00	Diabetes Check	Follow-up	Sunt animi incidunt ex porro inventore.	2025-06-26 22:30:08	2025-06-26 22:30:08	139/66	66	98.7	99	83	Sunt tempora similique molestias suscipit quod.	Repellat rem quia et assumenda blanditiis eveniet cumque totam.	2025-09-22	Cum temporibus eligendi nostrum dignissimos maiores nisi.	2025-08-31	14:45	3	pending	APT11635	\N
10637	64	3	2025-08-31 12:00:00	Routine Checkup	Emergency	Nostrum placeat minus culpa quo dolorum quam.	2025-06-26 22:30:08	2025-06-26 22:30:08	131/65	87	97.6	97	63	Iure omnis cumque ratione labore adipisci mollitia enim.	Velit consequuntur occaecati eaque ratione fugit.	2025-09-24	Quisquam quaerat accusantium exercitationem autem odit dolore vitae.	2025-08-31	12:00	3	pending	APT11636	\N
10638	465	9	2025-08-31 16:30:00	Diabetes Check	New	Quos maxime eligendi pariatur.	2025-06-26 22:30:08	2025-06-26 22:30:08	115/65	65	99.0	96	60	Atque rem repellat officiis.	Voluptatum iure occaecati quo voluptatibus fugiat nemo praesentium facere nulla.	2025-09-14	Ea quo ipsam fugit numquam.	2025-08-31	16:30	3	pending	APT11637	\N
10639	212	9	2025-08-31 12:00:00	Fever	OPD	Vel deleniti dolor numquam ducimus tempore.	2025-06-26 22:30:08	2025-06-26 22:30:08	136/76	86	97.9	98	71	Quo voluptatem blanditiis quidem magnam veritatis.	Inventore et officiis necessitatibus odio quis beatae deserunt vero.	2025-09-22	A autem ullam.	2025-08-31	12:00	3	pending	APT11638	\N
10640	122	7	2025-08-31 14:00:00	Skin Rash	Follow-up	Excepturi dicta quidem quod ut inventore.	2025-06-26 22:30:08	2025-06-26 22:30:08	105/87	85	98.2	96	56	Quia beatae labore cum earum maxime.	Placeat nesciunt maiores eveniet facilis magni nemo.	2025-09-09	Beatae mollitia sunt id earum officia reiciendis.	2025-08-31	14:00	3	pending	APT11639	\N
10641	462	4	2025-08-31 14:15:00	Routine Checkup	New	Veniam itaque adipisci dolore doloribus voluptatibus adipisci.	2025-06-26 22:30:08	2025-06-26 22:30:08	116/67	90	99.9	100	75	Amet laudantium reiciendis consequuntur.	Maxime voluptatem velit expedita iste doloremque dicta.	2025-09-27	Tempora itaque eius totam.	2025-08-31	14:15	3	pending	APT11640	\N
10642	462	10	2025-08-31 11:15:00	Cough	Follow-up	Inventore tenetur sequi nam magnam.	2025-06-26 22:30:08	2025-06-26 22:30:08	119/65	82	99.8	99	70	Consequatur quia dicta. Pariatur dicta qui quibusdam.	Voluptatem nam autem nihil.	2025-09-12	Id officia pariatur nostrum quasi similique tenetur.	2025-08-31	11:15	3	pending	APT11641	\N
10643	79	10	2025-08-31 16:45:00	High BP	New	Eveniet similique ducimus vitae recusandae.	2025-06-26 22:30:08	2025-06-26 22:30:08	112/78	85	99.1	100	64	Eaque provident nam. Minima magni illum excepturi.	Labore dolorem eos dolorum beatae eos excepturi sapiente quaerat.	2025-09-24	Minima in tenetur nemo ab.	2025-08-31	16:45	3	pending	APT11642	\N
10644	73	3	2025-08-31 12:00:00	Skin Rash	Follow-up	Dolorum dolorum aliquid praesentium.	2025-06-26 22:30:08	2025-06-26 22:30:08	120/84	88	98.6	99	57	Laudantium sapiente rem reprehenderit molestiae aut in.	Illum reprehenderit aliquam earum quibusdam similique facilis cum sequi.	2025-09-18	Perferendis rerum laboriosam.	2025-08-31	12:00	3	pending	APT11643	\N
10645	179	9	2025-08-31 13:00:00	Fever	Emergency	Eligendi in vel.	2025-06-26 22:30:08	2025-06-26 22:30:08	139/86	87	99.8	96	80	Ratione laborum accusantium voluptatibus.	Architecto cum molestias dignissimos.	2025-09-23	Nisi perspiciatis quisquam inventore.	2025-08-31	13:00	3	pending	APT11644	\N
10646	413	8	2025-08-31 16:15:00	Diabetes Check	New	Repudiandae numquam nesciunt enim officia ullam harum.	2025-06-26 22:30:08	2025-06-26 22:30:08	102/85	76	100.0	98	78	Autem omnis dignissimos dolor rerum facere tempora.	Eos perferendis architecto consequuntur quisquam dolore provident.	2025-09-17	Reiciendis iusto in reiciendis provident eveniet.	2025-08-31	16:15	3	pending	APT11645	\N
10647	334	7	2025-08-31 16:15:00	Cough	Follow-up	Excepturi unde atque facere architecto aperiam rem.	2025-06-26 22:30:08	2025-06-26 22:30:08	125/72	69	100.3	99	69	Voluptatum repudiandae vitae.	Possimus quos repudiandae ab sequi laboriosam commodi suscipit beatae vero.	2025-09-30	Eveniet sapiente et veniam cupiditate.	2025-08-31	16:15	3	pending	APT11646	\N
10648	44	6	2025-09-01 12:00:00	Skin Rash	New	Unde aperiam deleniti occaecati aut.	2025-06-26 22:30:08	2025-06-26 22:30:08	118/69	92	100.0	99	85	Magnam dolores enim reiciendis.	Ducimus magnam nobis mollitia accusantium ipsa fugit commodi porro.	2025-10-01	Assumenda qui dolore rerum quas.	2025-09-01	12:00	3	pending	APT11647	\N
10649	221	4	2025-09-01 16:00:00	Cough	Emergency	Itaque esse facere.	2025-06-26 22:30:08	2025-06-26 22:30:08	138/70	97	99.8	98	62	Voluptatum velit iusto facere officiis officia iure.	Officia occaecati aliquid laborum fugiat rem fugit id tempora.	2025-09-20	Illum quasi sunt in illum eveniet vero.	2025-09-01	16:00	3	pending	APT11648	\N
10650	257	9	2025-09-01 16:45:00	High BP	Emergency	Sequi ipsam placeat nemo tenetur.	2025-06-26 22:30:08	2025-06-26 22:30:08	102/69	77	100.3	95	66	Dolor hic inventore necessitatibus fuga nihil.	Voluptas maxime totam explicabo distinctio ex sint odio.	2025-09-27	Adipisci rem fugit temporibus.	2025-09-01	16:45	3	pending	APT11649	\N
10651	447	7	2025-09-01 12:00:00	Diabetes Check	Emergency	Libero quasi rem assumenda.	2025-06-26 22:30:08	2025-06-26 22:30:08	124/78	66	99.0	97	78	Quam ipsam numquam.	Perferendis maiores dolore recusandae sunt in soluta ipsam inventore eligendi.	2025-09-15	Consectetur similique quibusdam impedit cupiditate.	2025-09-01	12:00	3	pending	APT11650	\N
10652	52	10	2025-09-01 12:30:00	Back Pain	Emergency	Natus vel repellat magni nulla reiciendis quasi.	2025-06-26 22:30:08	2025-06-26 22:30:08	112/79	98	100.4	98	56	Ipsa quidem sint quis iste.	Ratione ut minus dicta quod a rerum.	2025-10-01	Earum incidunt maiores similique qui possimus.	2025-09-01	12:30	3	pending	APT11651	\N
10653	476	10	2025-09-01 15:30:00	High BP	Follow-up	Vero quam saepe nisi iste ex excepturi odio.	2025-06-26 22:30:08	2025-06-26 22:30:08	135/87	71	98.6	100	64	Quis molestiae soluta laudantium natus labore.	Explicabo dignissimos deleniti ea eligendi tempora quis nostrum.	2025-09-24	Dicta libero facere quis dolores iure perspiciatis.	2025-09-01	15:30	3	pending	APT11652	\N
10654	476	8	2025-09-01 11:30:00	Cough	OPD	Est doloribus cumque id sequi.	2025-06-26 22:30:08	2025-06-26 22:30:08	116/82	71	99.5	100	78	Repellat magnam maxime iusto reiciendis.	Quaerat blanditiis quis ab atque laborum laboriosam.	2025-09-13	Cumque perspiciatis porro iste itaque ipsa nihil.	2025-09-01	11:30	3	pending	APT11653	\N
10655	383	6	2025-09-01 16:15:00	Fever	New	Nihil esse commodi ab.	2025-06-26 22:30:08	2025-06-26 22:30:08	123/60	84	99.8	95	57	Dignissimos maiores sit quas vitae.	Fugit voluptates rem dolorum nulla iure laborum ipsum.	2025-09-25	Ab illo porro accusamus.	2025-09-01	16:15	3	pending	APT11654	\N
10656	199	6	2025-09-01 12:00:00	High BP	OPD	Ad libero fuga minus.	2025-06-26 22:30:08	2025-06-26 22:30:08	114/64	66	98.7	97	61	Debitis libero ipsum veritatis vel.	Cumque vitae doloremque voluptates alias ad.	2025-09-19	Itaque similique blanditiis dicta modi.	2025-09-01	12:00	3	pending	APT11655	\N
10657	109	3	2025-09-01 14:45:00	Routine Checkup	Emergency	Vel laudantium animi consequuntur error.	2025-06-26 22:30:08	2025-06-26 22:30:08	122/66	73	98.2	100	79	Dolorum harum excepturi molestiae sequi accusamus illo.	Sed esse nulla sapiente repellat exercitationem consequatur natus possimus.	2025-09-24	Quam minima similique corporis architecto.	2025-09-01	14:45	3	pending	APT11656	\N
10658	133	6	2025-09-01 15:30:00	Headache	New	Voluptatum eum deserunt voluptates illo.	2025-06-26 22:30:08	2025-06-26 22:30:08	122/75	69	98.9	99	74	Laudantium veniam est culpa maiores recusandae.	Laudantium iure error excepturi tempore qui nihil optio inventore adipisci.	2025-09-27	Maiores dolores veritatis magnam neque possimus.	2025-09-01	15:30	3	pending	APT11657	\N
10659	37	10	2025-09-01 15:00:00	High BP	New	Fugiat illum quis.	2025-06-26 22:30:08	2025-06-26 22:30:08	109/77	69	99.8	97	63	Culpa magni culpa animi distinctio iusto molestiae vel.	Amet quis pariatur atque delectus nisi accusantium.	2025-09-08	Temporibus quam sint veritatis tempore perferendis totam.	2025-09-01	15:00	3	pending	APT11658	\N
10660	289	5	2025-09-01 11:15:00	Routine Checkup	Emergency	Cupiditate earum eum vitae assumenda sapiente ab id.	2025-06-26 22:30:08	2025-06-26 22:30:08	104/85	66	97.6	100	69	Suscipit error molestiae officiis magnam.	Perferendis hic repudiandae eligendi tempore.	2025-09-16	Nostrum adipisci illo autem occaecati dolores.	2025-09-01	11:15	3	pending	APT11659	\N
10662	212	3	2025-09-01 14:00:00	High BP	Emergency	Deleniti voluptatum placeat.	2025-06-26 22:30:08	2025-06-26 22:30:08	111/66	96	100.3	96	56	Porro possimus ullam ab.	Tempora deserunt doloribus saepe commodi quos vel sapiente quasi commodi.	2025-09-22	Aliquam atque pariatur ullam.	2025-09-01	14:00	3	pending	APT11661	\N
10663	399	4	2025-09-01 15:45:00	Routine Checkup	Emergency	Veniam iste fuga ut culpa.	2025-06-26 22:30:08	2025-06-26 22:30:08	123/72	87	98.1	100	71	Excepturi officiis inventore consequuntur.	Molestiae incidunt facilis atque animi sed eum pariatur explicabo.	2025-09-22	Doloribus architecto sint possimus.	2025-09-01	15:45	3	pending	APT11662	\N
10664	272	9	2025-09-01 14:30:00	Fever	Follow-up	Vitae atque vel autem culpa.	2025-06-26 22:30:08	2025-06-26 22:30:08	119/76	69	100.4	97	60	Sunt qui veniam rem. Eos incidunt atque.	Corrupti cum laborum enim quis nemo aliquid quia.	2025-09-23	Repellendus eos labore alias.	2025-09-01	14:30	3	pending	APT11663	\N
10665	463	5	2025-09-01 15:00:00	Back Pain	Emergency	Qui fuga soluta porro est.	2025-06-26 22:30:08	2025-06-26 22:30:08	108/63	100	98.7	98	83	Harum quia eveniet et veritatis ab enim.	Itaque asperiores quam iusto harum.	2025-09-20	Nam iusto magnam tempore doloribus ut.	2025-09-01	15:00	3	pending	APT11664	\N
10666	178	4	2025-09-01 14:45:00	High BP	Follow-up	Odio modi alias.	2025-06-26 22:30:08	2025-06-26 22:30:08	131/64	97	99.6	95	57	Commodi ratione atque natus enim. Id id id esse tempore.	Esse hic nobis quo itaque facere at assumenda temporibus voluptatibus.	2025-09-25	Quibusdam iure rerum voluptatum soluta aliquid.	2025-09-01	14:45	3	pending	APT11665	\N
10667	252	3	2025-09-01 13:15:00	Skin Rash	Emergency	Debitis magnam omnis quod.	2025-06-26 22:30:08	2025-06-26 22:30:08	102/76	77	98.5	96	70	Error iste praesentium debitis. Assumenda quia rem earum.	Maxime mollitia incidunt et quisquam.	2025-10-01	Cum consequatur ea.	2025-09-01	13:15	3	pending	APT11666	\N
10668	398	8	2025-09-01 14:45:00	High BP	Emergency	Quos alias id magni.	2025-06-26 22:30:08	2025-06-26 22:30:08	132/66	70	99.6	100	59	Adipisci sunt ipsa.	Accusantium dolorum veritatis cum sequi error autem ipsam at quibusdam.	2025-09-21	Magnam unde ipsam quasi.	2025-09-01	14:45	3	pending	APT11667	\N
10669	481	5	2025-09-01 11:45:00	Cough	New	Cum expedita rem ullam id blanditiis facere quam.	2025-06-26 22:30:08	2025-06-26 22:30:08	135/67	85	100.3	95	61	Exercitationem minima corporis accusamus deleniti.	Tempora corporis totam hic recusandae quidem velit iure aliquid.	2025-09-09	Sequi blanditiis minima animi asperiores ipsum.	2025-09-01	11:45	3	pending	APT11668	\N
10670	304	3	2025-09-01 15:15:00	Routine Checkup	Follow-up	Quia delectus assumenda ratione dicta dolorum saepe.	2025-06-26 22:30:08	2025-06-26 22:30:08	116/65	84	100.4	98	68	Ea earum soluta totam molestiae.	Rerum impedit maxime ducimus tenetur doloremque vel possimus id.	2025-09-13	Iste quis veritatis alias illum inventore.	2025-09-01	15:15	3	pending	APT11669	\N
10671	188	7	2025-09-01 11:45:00	Diabetes Check	OPD	Deleniti corporis neque dolor excepturi atque.	2025-06-26 22:30:08	2025-06-26 22:30:08	131/65	74	99.1	100	75	Adipisci fuga quasi dolorum.	Nihil aperiam nesciunt quisquam ratione quas ea.	2025-09-25	Temporibus at reprehenderit quo reprehenderit.	2025-09-01	11:45	3	pending	APT11670	\N
10672	122	6	2025-09-01 16:45:00	Headache	Follow-up	Numquam excepturi impedit est sapiente molestias quibusdam.	2025-06-26 22:30:08	2025-06-26 22:30:08	121/72	91	97.8	95	62	Repellat totam dicta laborum.	Aliquam aspernatur nisi quam quia doloremque.	2025-09-26	Laborum reiciendis autem expedita voluptatum odit.	2025-09-01	16:45	3	pending	APT11671	\N
10673	425	10	2025-09-01 14:15:00	Cough	Emergency	Modi iusto cupiditate deserunt.	2025-06-26 22:30:08	2025-06-26 22:30:08	107/89	93	99.9	99	59	Quisquam sapiente odio consectetur atque.	Quae aut soluta nam aliquid praesentium odit eum qui reprehenderit.	2025-09-26	Sint accusantium assumenda molestiae ex.	2025-09-01	14:15	3	pending	APT11672	\N
10674	284	10	2025-09-02 16:15:00	Back Pain	Follow-up	Quasi magnam nam placeat maxime.	2025-06-26 22:30:08	2025-06-26 22:30:08	123/77	70	99.8	96	77	Possimus esse veniam autem reprehenderit.	Magni minus ab officia dolores et hic dolor fugiat magni.	2025-10-02	Quas reiciendis porro.	2025-09-02	16:15	3	pending	APT11673	\N
10675	450	3	2025-09-02 16:00:00	Diabetes Check	Follow-up	Vel sequi totam.	2025-06-26 22:30:08	2025-06-26 22:30:08	114/79	71	100.2	95	61	Assumenda harum amet quia et voluptate vero.	Est voluptate vitae non reiciendis perferendis.	2025-09-10	Esse quo sint.	2025-09-02	16:00	3	pending	APT11674	\N
10676	279	9	2025-09-02 13:45:00	Routine Checkup	Follow-up	Praesentium quisquam voluptates tenetur.	2025-06-26 22:30:08	2025-06-26 22:30:08	136/89	73	99.6	99	62	Aut neque eaque nesciunt. Sint blanditiis quas eaque.	Iste commodi libero non amet maxime.	2025-09-25	Deleniti laboriosam fuga iste reiciendis labore nulla.	2025-09-02	13:45	3	pending	APT11675	\N
10677	191	3	2025-09-02 12:30:00	High BP	Emergency	Quo nisi illum fugit sapiente architecto.	2025-06-26 22:30:08	2025-06-26 22:30:08	123/82	76	100.5	99	58	Placeat iste porro.	Id repellat velit quasi quod.	2025-10-01	Laborum at id esse facere quis assumenda.	2025-09-02	12:30	3	pending	APT11676	\N
10678	196	7	2025-09-02 15:15:00	Routine Checkup	Emergency	Consectetur nemo earum omnis odio labore veritatis.	2025-06-26 22:30:08	2025-06-26 22:30:08	109/72	82	98.2	95	64	Corrupti tenetur explicabo optio.	Repellendus ad repellat hic debitis animi.	2025-09-29	Tenetur labore accusantium laborum a.	2025-09-02	15:15	3	pending	APT11677	\N
10679	267	8	2025-09-02 13:15:00	Routine Checkup	OPD	Sint reprehenderit tenetur.	2025-06-26 22:30:08	2025-06-26 22:30:08	138/76	100	100.5	95	57	Ipsam officia molestias voluptatem. Facere quo ullam.	Ad corporis rerum saepe id.	2025-09-09	Labore minima asperiores ea labore.	2025-09-02	13:15	3	pending	APT11678	\N
10680	436	4	2025-09-02 13:00:00	Routine Checkup	Follow-up	Aperiam dolor doloremque minus.	2025-06-26 22:30:08	2025-06-26 22:30:08	139/85	85	97.5	97	84	Minima omnis commodi ut esse asperiores.	Aperiam ut provident aut inventore sapiente ea corrupti atque.	2025-09-28	At porro accusamus.	2025-09-02	13:00	3	pending	APT11679	\N
10681	391	6	2025-09-02 12:30:00	Skin Rash	Emergency	Dicta recusandae pariatur delectus eius eos ea itaque.	2025-06-26 22:30:08	2025-06-26 22:30:08	125/72	75	98.0	95	73	Animi quia officiis illum.	Porro numquam placeat ipsa tempora voluptatem iste itaque.	2025-09-13	Error ullam unde reiciendis at.	2025-09-02	12:30	3	pending	APT11680	\N
10682	4	4	2025-09-02 15:00:00	High BP	Emergency	Necessitatibus eum autem esse.	2025-06-26 22:30:08	2025-06-26 22:30:08	118/60	87	100.1	95	71	Doloremque qui deleniti impedit nostrum autem tempora.	Ipsum ad deserunt inventore accusamus vel sint.	2025-09-25	Commodi accusamus ratione laboriosam explicabo fugit autem.	2025-09-02	15:00	3	pending	APT11681	\N
10683	133	6	2025-09-02 16:45:00	Headache	New	Distinctio iste commodi dolores nemo magnam consequuntur.	2025-06-26 22:30:08	2025-06-26 22:30:08	135/84	85	98.2	99	69	Deleniti et sequi consequatur minus.	Minus earum cupiditate eius cumque expedita ratione libero rerum.	2025-09-28	Excepturi et at quas.	2025-09-02	16:45	3	pending	APT11682	\N
10684	310	7	2025-09-02 14:30:00	Headache	OPD	Debitis dolore totam vero dicta consequuntur tempora.	2025-06-26 22:30:08	2025-06-26 22:30:08	125/89	68	98.6	99	79	Eos deserunt labore repellat numquam.	Enim sit enim corrupti dolorem dolore laudantium quos at necessitatibus.	2025-09-23	Minus maxime velit blanditiis necessitatibus occaecati.	2025-09-02	14:30	3	pending	APT11683	\N
10685	337	5	2025-09-02 13:30:00	High BP	New	Consequuntur beatae minus sit distinctio.	2025-06-26 22:30:08	2025-06-26 22:30:08	136/75	100	98.8	96	65	Harum impedit a neque. Earum nemo exercitationem deleniti.	At quod necessitatibus impedit qui minus nostrum quod nemo.	2025-09-13	Aperiam necessitatibus ut quia molestiae consectetur.	2025-09-02	13:30	3	pending	APT11684	\N
10686	415	10	2025-09-02 14:00:00	Cough	Follow-up	Qui inventore cupiditate deleniti fuga voluptates.	2025-06-26 22:30:08	2025-06-26 22:30:08	109/71	88	99.9	95	68	Autem at qui alias eligendi.	Libero distinctio vero minus vel ipsam sapiente.	2025-10-01	Nisi aperiam debitis ab harum in vel.	2025-09-02	14:00	3	pending	APT11685	\N
10687	146	3	2025-09-02 16:30:00	High BP	New	Quos voluptatum ratione commodi cupiditate quae asperiores fuga.	2025-06-26 22:30:08	2025-06-26 22:30:08	112/85	73	97.6	95	69	Libero iste voluptatem soluta fuga.	Rerum porro voluptas inventore voluptate.	2025-09-17	Commodi reiciendis debitis dolorem.	2025-09-02	16:30	3	pending	APT11686	\N
10688	441	6	2025-09-02 15:30:00	Routine Checkup	Follow-up	Illum similique earum iure.	2025-06-26 22:30:08	2025-06-26 22:30:08	111/67	85	99.6	95	62	Aliquam incidunt nulla labore dolores non vero aspernatur.	Perspiciatis consequatur laboriosam in totam fugit odit exercitationem omnis.	2025-09-22	Architecto repudiandae voluptatum qui laudantium.	2025-09-02	15:30	3	pending	APT11687	\N
10689	440	10	2025-09-02 14:00:00	Headache	Emergency	Quas quia corporis vel nulla.	2025-06-26 22:30:08	2025-06-26 22:30:08	112/68	95	98.7	99	64	Nulla minus quis provident quis.	Delectus modi perferendis ipsum aspernatur repellendus aliquam minus accusamus velit.	2025-09-22	Iste molestias excepturi doloremque similique.	2025-09-02	14:00	3	pending	APT11688	\N
10690	162	4	2025-09-02 16:00:00	Skin Rash	Emergency	Fuga similique blanditiis mollitia animi consequatur.	2025-06-26 22:30:08	2025-06-26 22:30:08	124/68	75	98.3	97	72	Ab porro asperiores quasi alias.	Amet voluptatibus iusto soluta eaque libero.	2025-09-20	Voluptas soluta unde illum laboriosam.	2025-09-02	16:00	3	pending	APT11689	\N
10691	177	3	2025-09-02 14:00:00	Fever	Emergency	Perspiciatis numquam libero aliquam fugiat ex.	2025-06-26 22:30:08	2025-06-26 22:30:08	127/73	91	98.4	96	65	Repellendus earum quis culpa reprehenderit.	Itaque voluptas odit provident eos earum dolorum aperiam animi at.	2025-09-30	Magnam ipsa iusto corrupti deserunt mollitia.	2025-09-02	14:00	3	pending	APT11690	\N
10692	217	6	2025-09-02 16:30:00	High BP	OPD	Odit officiis officiis in.	2025-06-26 22:30:08	2025-06-26 22:30:08	118/79	81	99.1	96	74	Assumenda iusto officiis nam ullam.	Doloremque alias perferendis voluptatem quae expedita mollitia libero impedit beatae.	2025-09-21	Exercitationem officia harum deleniti.	2025-09-02	16:30	3	pending	APT11691	\N
10693	170	8	2025-09-02 12:15:00	Diabetes Check	OPD	Temporibus repellendus molestias labore veritatis tempora dicta quia.	2025-06-26 22:30:08	2025-06-26 22:30:08	117/89	79	100.3	98	66	Fugit quis quisquam molestias est sit tempora.	Delectus rem culpa ipsum natus porro quia laborum accusantium.	2025-09-12	Minima explicabo mollitia magnam eligendi.	2025-09-02	12:15	3	pending	APT11692	\N
10694	308	3	2025-09-02 11:00:00	High BP	New	Ratione expedita deleniti earum quibusdam.	2025-06-26 22:30:08	2025-06-26 22:30:08	120/61	72	100.1	97	75	Dicta eveniet minima iste alias facere.	Dolorum repellendus quos repellendus pariatur recusandae ad tempore.	2025-09-19	Eligendi voluptatibus incidunt exercitationem quia unde.	2025-09-02	11:00	3	pending	APT11693	\N
10695	391	8	2025-09-02 13:00:00	High BP	New	Consequatur ut atque sed repellat.	2025-06-26 22:30:08	2025-06-26 22:30:08	137/68	77	99.8	98	55	Recusandae sed recusandae omnis minus nulla occaecati.	Facilis unde velit accusantium unde mollitia.	2025-09-28	Architecto molestiae facilis eaque.	2025-09-02	13:00	3	pending	APT11694	\N
10696	201	7	2025-09-02 11:45:00	High BP	Emergency	Sed distinctio expedita.	2025-06-26 22:30:08	2025-06-26 22:30:08	118/84	75	99.1	100	57	Dolor maiores optio recusandae quod provident.	Consectetur aperiam cum officia asperiores odio dolores mollitia assumenda veritatis.	2025-09-13	Distinctio officia repellat dignissimos fugiat sapiente.	2025-09-02	11:45	3	pending	APT11695	\N
10697	166	6	2025-09-02 13:15:00	Headache	Emergency	Esse quibusdam similique ipsum.	2025-06-26 22:30:08	2025-06-26 22:30:08	134/73	82	98.6	99	82	Sunt magni ratione distinctio nam odio.	Enim doloremque autem consequatur ipsum corrupti quis quia.	2025-09-25	Ut laboriosam et dolores.	2025-09-02	13:15	3	pending	APT11696	\N
10698	163	8	2025-09-02 13:30:00	Diabetes Check	OPD	Non quo fugiat quis.	2025-06-26 22:30:08	2025-06-26 22:30:08	137/84	70	98.6	100	79	Necessitatibus eaque ratione molestiae rem doloribus amet.	Suscipit quae at aliquid sed minus necessitatibus officiis eius exercitationem.	2025-09-28	Nihil accusamus officia expedita consectetur quam deserunt.	2025-09-02	13:30	3	pending	APT11697	\N
10699	253	8	2025-09-02 16:30:00	High BP	New	Quae ab nemo iste.	2025-06-26 22:30:08	2025-06-26 22:30:08	140/75	75	98.6	95	64	Adipisci dolorem voluptas aperiam sequi quis ducimus.	Totam ut nam quis omnis id.	2025-09-25	Mollitia quam vitae reprehenderit culpa.	2025-09-02	16:30	3	pending	APT11698	\N
10700	372	6	2025-09-02 15:00:00	Diabetes Check	OPD	Explicabo quam iste.	2025-06-26 22:30:08	2025-06-26 22:30:08	109/84	88	97.9	96	65	Atque nihil sapiente explicabo asperiores tempore.	Ipsam facere nesciunt deleniti esse doloremque assumenda doloremque.	2025-10-01	Praesentium aspernatur ipsam alias.	2025-09-02	15:00	3	pending	APT11699	\N
10701	388	6	2025-09-03 12:00:00	Headache	OPD	Iure occaecati quasi laboriosam.	2025-06-26 22:30:08	2025-06-26 22:30:08	127/77	73	97.7	95	58	Incidunt pariatur ab molestiae ab quisquam rerum ipsam.	Commodi libero neque perferendis corrupti numquam.	2025-09-22	Eum pariatur fugit odio quisquam consequatur quod ullam.	2025-09-03	12:00	3	pending	APT11700	\N
10702	302	4	2025-09-03 16:15:00	Cough	Follow-up	Incidunt incidunt nulla explicabo ipsum quia.	2025-06-26 22:30:08	2025-06-26 22:30:08	123/64	73	98.7	99	58	Illo officia nesciunt fugiat eos.	Temporibus reiciendis necessitatibus minima quo vel perspiciatis.	2025-09-15	Earum occaecati corrupti odit labore eum asperiores nobis.	2025-09-03	16:15	3	pending	APT11701	\N
10703	167	3	2025-09-03 12:15:00	Headache	New	In mollitia amet ad ea nihil.	2025-06-26 22:30:08	2025-06-26 22:30:08	120/83	80	97.9	96	59	Nesciunt omnis quod natus hic sint.	Vitae quidem fugit numquam optio laboriosam doloremque illum illum nihil.	2025-09-15	Quas corporis dolore deleniti nulla.	2025-09-03	12:15	3	pending	APT11702	\N
10704	13	5	2025-09-03 15:30:00	Back Pain	New	Ducimus fugiat autem.	2025-06-26 22:30:08	2025-06-26 22:30:08	100/77	100	98.8	96	80	Repellendus itaque mollitia sint.	Unde odit earum debitis cupiditate enim incidunt dolor voluptatem.	2025-09-11	Hic veritatis omnis cum beatae.	2025-09-03	15:30	3	pending	APT11703	\N
10705	473	3	2025-09-03 14:45:00	High BP	Follow-up	Cum mollitia inventore.	2025-06-26 22:30:08	2025-06-26 22:30:08	109/65	67	99.1	97	63	Corporis accusantium nostrum deserunt quod sapiente quod.	Esse alias quasi dolorem placeat modi.	2025-09-20	Aut modi molestias eius amet.	2025-09-03	14:45	3	pending	APT11704	\N
10706	359	9	2025-09-03 15:00:00	Headache	Emergency	Officiis vero asperiores iure accusamus quidem.	2025-06-26 22:30:08	2025-06-26 22:30:08	122/86	80	99.0	98	55	Aperiam at ea ipsam consequatur. Vero incidunt cumque.	Voluptates iure aliquam excepturi quidem cumque excepturi impedit.	2025-09-12	Nesciunt laboriosam eligendi incidunt ipsum perferendis.	2025-09-03	15:00	3	pending	APT11705	\N
10708	107	7	2025-09-03 12:00:00	Headache	OPD	Dolor nisi totam architecto nostrum maxime sint.	2025-06-26 22:30:08	2025-06-26 22:30:08	121/61	72	99.4	96	59	Facere quisquam voluptate facere aut commodi minus.	Dignissimos ducimus eos tempore error beatae quae voluptatem voluptatum perferendis.	2025-09-15	Nemo illo blanditiis impedit odio dicta.	2025-09-03	12:00	3	pending	APT11707	\N
10709	32	4	2025-09-03 15:30:00	Routine Checkup	Follow-up	Repellendus saepe iure vel nisi accusantium excepturi.	2025-06-26 22:30:08	2025-06-26 22:30:08	119/63	78	97.6	98	60	Nam voluptatem amet iure quod deleniti nemo.	Architecto adipisci repudiandae ad natus pariatur doloremque quo mollitia enim.	2025-09-12	Maiores fugit delectus vel vitae.	2025-09-03	15:30	3	pending	APT11708	\N
10710	383	4	2025-09-03 11:00:00	High BP	New	Iste veritatis soluta magni corporis quod.	2025-06-26 22:30:08	2025-06-26 22:30:08	130/68	90	100.3	95	59	Perferendis odit repudiandae harum voluptates iusto quidem.	Consequuntur neque laborum eum facere.	2025-09-16	Rem minima sunt molestias dolor inventore.	2025-09-03	11:00	3	pending	APT11709	\N
10711	295	4	2025-09-03 14:30:00	Cough	Follow-up	Adipisci in inventore libero ex tenetur.	2025-06-26 22:30:08	2025-06-26 22:30:08	100/60	80	97.8	95	62	Cumque repellat delectus voluptatum nihil ratione maxime.	Illum saepe autem illo dolorum magnam aperiam officia iusto esse.	2025-09-18	Totam alias labore sed doloremque.	2025-09-03	14:30	3	pending	APT11710	\N
10712	245	10	2025-09-03 13:30:00	High BP	New	Et quia laudantium fugit.	2025-06-26 22:30:08	2025-06-26 22:30:08	140/77	71	100.1	98	62	Sunt ab totam eos dicta rerum nulla.	Eos veritatis error itaque sunt reiciendis totam aliquam tempora optio.	2025-09-20	Quaerat autem magnam cum delectus ea commodi.	2025-09-03	13:30	3	pending	APT11711	\N
10713	285	8	2025-09-03 15:30:00	Routine Checkup	OPD	Omnis maxime nulla deserunt quos exercitationem quos officiis.	2025-06-26 22:30:08	2025-06-26 22:30:08	119/85	77	99.9	100	83	Voluptate quia provident hic.	Nemo hic similique accusantium quia fuga.	2025-09-22	Facilis odit saepe at.	2025-09-03	15:30	3	pending	APT11712	\N
10714	354	5	2025-09-03 12:30:00	Back Pain	Emergency	Dicta cupiditate repellat officiis sequi maxime similique expedita.	2025-06-26 22:30:08	2025-06-26 22:30:08	138/84	89	98.9	98	78	Corrupti laborum mollitia provident beatae sint.	Repellendus odit vel vel voluptatibus officiis sit ratione dolor dolore.	2025-09-30	Culpa earum iste ab.	2025-09-03	12:30	3	pending	APT11713	\N
10715	348	4	2025-09-03 11:15:00	Cough	New	Cum recusandae cum ipsa.	2025-06-26 22:30:08	2025-06-26 22:30:08	116/77	86	98.3	95	60	Ab modi eum. Sit sit accusamus.	Quidem qui architecto nam ab vitae error.	2025-09-11	Exercitationem necessitatibus praesentium sit libero ipsum unde sint.	2025-09-03	11:15	3	pending	APT11714	\N
10716	78	8	2025-09-03 12:15:00	Back Pain	OPD	Minima accusamus corporis fuga blanditiis similique.	2025-06-26 22:30:08	2025-06-26 22:30:08	122/65	95	98.1	99	82	Sequi beatae veniam nemo accusantium quisquam.	Sit sit porro at illo exercitationem porro.	2025-09-12	Magni dolores nemo quidem.	2025-09-03	12:15	3	pending	APT11715	\N
10717	134	9	2025-09-03 15:00:00	Routine Checkup	OPD	Maiores mollitia eveniet ex consequuntur.	2025-06-26 22:30:08	2025-06-26 22:30:08	111/85	73	99.8	100	83	Illo voluptas dolorem reiciendis ullam illum.	Deserunt itaque ipsum eaque tenetur impedit fuga quidem nihil ipsum.	2025-09-17	Omnis totam sequi.	2025-09-03	15:00	3	pending	APT11716	\N
10718	358	4	2025-09-03 13:45:00	Fever	OPD	Tempore unde deleniti eveniet perferendis laudantium.	2025-06-26 22:30:08	2025-06-26 22:30:08	101/67	84	99.1	100	73	Itaque odio deserunt eveniet quibusdam delectus.	Doloribus culpa accusantium dolor minima praesentium quasi quas.	2025-09-11	Voluptatibus deserunt deleniti ut consectetur aut amet.	2025-09-03	13:45	3	pending	APT11717	\N
10719	179	3	2025-09-03 15:45:00	Cough	New	Assumenda ipsum voluptate sapiente magnam eos.	2025-06-26 22:30:08	2025-06-26 22:30:08	124/66	69	99.6	97	73	Laboriosam officia explicabo. Vero aperiam totam aut.	Mollitia quibusdam quaerat hic dicta.	2025-09-24	Iste omnis dolorem suscipit at.	2025-09-03	15:45	3	pending	APT11718	\N
10720	162	7	2025-09-03 11:15:00	Skin Rash	Follow-up	Et dolorum autem sit ab quibusdam nostrum.	2025-06-26 22:30:08	2025-06-26 22:30:08	102/73	67	98.6	97	55	Libero illo in aspernatur atque quia.	Suscipit quae iure optio esse ad adipisci commodi officia dolores.	2025-09-23	Illum molestias fugiat doloremque esse doloremque saepe quas.	2025-09-03	11:15	3	pending	APT11719	\N
10721	297	6	2025-09-03 14:30:00	Diabetes Check	Emergency	Quisquam ea nihil in molestiae adipisci.	2025-06-26 22:30:08	2025-06-26 22:30:08	130/70	72	98.7	100	55	Iure expedita cumque dolore.	Vero voluptas sunt molestias molestias voluptatum voluptatibus.	2025-09-10	Doloribus magni odit doloribus aliquid natus.	2025-09-03	14:30	3	pending	APT11720	\N
10722	338	6	2025-09-03 14:45:00	High BP	OPD	Dolore ipsa velit voluptatibus error alias nulla.	2025-06-26 22:30:08	2025-06-26 22:30:08	132/61	67	100.0	100	83	Neque eveniet debitis aut consectetur quas accusantium.	Tempore impedit neque deserunt iste.	2025-09-12	Doloremque excepturi at ducimus excepturi esse non est.	2025-09-03	14:45	3	pending	APT11721	\N
10723	212	6	2025-09-03 13:30:00	Routine Checkup	Emergency	Odit hic consequatur recusandae.	2025-06-26 22:30:08	2025-06-26 22:30:08	134/88	87	98.4	97	67	Illo maiores laborum magnam.	Blanditiis autem cupiditate consequatur in excepturi veritatis eveniet.	2025-09-17	Molestiae magni optio dicta cumque.	2025-09-03	13:30	3	pending	APT11722	\N
10724	192	5	2025-09-03 16:00:00	Cough	New	Adipisci veniam quaerat ea et earum.	2025-06-26 22:30:08	2025-06-26 22:30:08	133/61	70	100.2	99	57	Veniam ad ab voluptatum.	Laudantium eveniet fugiat alias animi.	2025-09-13	Et at omnis doloremque ea dolor error.	2025-09-03	16:00	3	pending	APT11723	\N
10725	409	8	2025-09-03 16:30:00	Routine Checkup	New	Ratione culpa cum.	2025-06-26 22:30:08	2025-06-26 22:30:08	137/82	88	99.1	97	60	Doloremque rerum nulla sapiente dolorum.	Impedit animi labore dolore consequuntur architecto blanditiis quis.	2025-09-29	Saepe optio natus maiores quae accusamus ducimus.	2025-09-03	16:30	3	pending	APT11724	\N
10726	99	9	2025-09-03 12:00:00	High BP	Follow-up	Voluptatem id debitis et minima magni fugit recusandae.	2025-06-26 22:30:08	2025-06-26 22:30:08	126/63	85	97.9	98	80	Blanditiis laudantium nostrum porro quia.	Occaecati quae deserunt magni voluptatum voluptatibus.	2025-09-11	Reiciendis labore dolorum sequi voluptates impedit illo.	2025-09-03	12:00	3	pending	APT11725	\N
10727	300	8	2025-09-04 15:00:00	Back Pain	Emergency	Optio doloremque quas molestiae aspernatur consequuntur cupiditate.	2025-06-26 22:30:08	2025-06-26 22:30:08	123/87	96	99.1	97	85	Maxime repellendus assumenda quasi officiis reiciendis.	Enim consectetur quos labore ratione laudantium est iusto.	2025-09-24	Expedita illum recusandae totam quod minus.	2025-09-04	15:00	3	pending	APT11726	\N
10728	326	6	2025-09-04 15:15:00	Back Pain	OPD	Reiciendis impedit delectus dolores.	2025-06-26 22:30:08	2025-06-26 22:30:08	119/71	91	98.7	100	79	Laborum expedita nam.	Unde reiciendis deleniti quibusdam facere ut a culpa.	2025-09-16	Aspernatur magni veritatis.	2025-09-04	15:15	3	pending	APT11727	\N
10729	403	4	2025-09-04 11:30:00	Headache	Emergency	Reiciendis ab nesciunt quas deserunt.	2025-06-26 22:30:08	2025-06-26 22:30:08	135/83	100	100.4	97	55	Ducimus eligendi inventore omnis.	Iure veniam at ipsam sunt.	2025-09-28	Quos dolorum excepturi iure cum maiores.	2025-09-04	11:30	3	pending	APT11728	\N
10730	431	10	2025-09-04 15:15:00	Back Pain	New	Nisi dolorum explicabo ut.	2025-06-26 22:30:08	2025-06-26 22:30:08	110/81	69	98.5	99	68	Dignissimos praesentium autem sint est suscipit cumque.	Quidem impedit corporis velit autem ex fugiat perferendis.	2025-09-13	Labore in officiis.	2025-09-04	15:15	3	pending	APT11729	\N
10731	432	9	2025-09-04 12:30:00	Back Pain	Follow-up	Quis quisquam error.	2025-06-26 22:30:08	2025-06-26 22:30:08	104/64	66	99.3	100	83	Laborum itaque fugiat doloremque.	Repellat veniam voluptas possimus.	2025-09-19	Sequi aut modi cupiditate ipsa dicta placeat numquam.	2025-09-04	12:30	3	pending	APT11730	\N
10732	62	8	2025-09-04 16:00:00	Fever	New	Voluptatibus omnis odit.	2025-06-26 22:30:08	2025-06-26 22:30:08	113/86	95	99.7	99	65	Quis eum nam excepturi optio.	Quibusdam aliquid reiciendis expedita quia repellat praesentium ab et.	2025-09-12	Voluptates quisquam quidem sint aspernatur eos at earum.	2025-09-04	16:00	3	pending	APT11731	\N
10733	350	10	2025-09-04 14:45:00	Routine Checkup	Emergency	Magni dignissimos quo.	2025-06-26 22:30:08	2025-06-26 22:30:08	135/64	70	98.7	97	75	Facere unde rerum. Explicabo aliquid rerum facere velit.	Accusantium hic aliquam nostrum pariatur.	2025-09-18	Soluta fuga similique voluptatibus ipsam aliquam quis labore.	2025-09-04	14:45	3	pending	APT11732	\N
10734	426	6	2025-09-04 14:30:00	Skin Rash	OPD	Iste dicta eveniet harum beatae hic ea.	2025-06-26 22:30:08	2025-06-26 22:30:08	132/66	76	97.8	97	81	Soluta nobis eum consectetur ipsa officia repellat nostrum.	Occaecati quod recusandae nulla voluptas placeat.	2025-09-27	Cum voluptas odit eius eligendi sint quaerat.	2025-09-04	14:30	3	pending	APT11733	\N
10735	155	3	2025-09-04 13:45:00	Cough	OPD	Dolor illo expedita vel totam.	2025-06-26 22:30:08	2025-06-26 22:30:08	107/77	77	99.8	100	55	Nesciunt odit rem omnis eveniet officiis.	Ullam laborum rerum repudiandae fuga suscipit a.	2025-09-17	Delectus odio accusantium velit.	2025-09-04	13:45	3	pending	APT11734	\N
10736	377	7	2025-09-04 13:45:00	Routine Checkup	OPD	Odio iste ea iure nobis totam.	2025-06-26 22:30:08	2025-06-26 22:30:08	118/84	93	100.4	97	70	Pariatur et repellendus molestias dolores ullam iure.	Quibusdam voluptate vero amet eligendi.	2025-09-11	Eveniet eligendi ipsum sunt.	2025-09-04	13:45	3	pending	APT11735	\N
10737	212	3	2025-09-04 11:15:00	Diabetes Check	Follow-up	Minima dicta doloribus.	2025-06-26 22:30:08	2025-06-26 22:30:08	122/78	79	100.4	100	71	Recusandae pariatur corrupti eligendi inventore commodi.	Cumque facere sunt aperiam inventore architecto incidunt.	2025-09-26	Officia quod consectetur quibusdam quisquam excepturi.	2025-09-04	11:15	3	pending	APT11736	\N
10738	228	3	2025-09-04 14:30:00	Fever	New	Facilis enim quidem ex omnis.	2025-06-26 22:30:08	2025-06-26 22:30:08	131/73	81	98.3	97	67	Dolorum eveniet sunt error neque numquam corporis.	Velit quo occaecati explicabo molestias optio.	2025-10-01	Nisi consectetur libero dignissimos cumque.	2025-09-04	14:30	3	pending	APT11737	\N
10739	443	7	2025-09-04 12:45:00	Back Pain	OPD	Dicta esse sit deleniti libero labore nam esse.	2025-06-26 22:30:08	2025-06-26 22:30:08	136/63	92	99.2	99	64	Quam perferendis quasi qui temporibus sequi ipsa placeat.	Cumque repellendus a impedit sunt quae.	2025-09-16	At itaque dolor amet.	2025-09-04	12:45	3	pending	APT11738	\N
10740	124	9	2025-09-04 13:00:00	Back Pain	OPD	Fuga eveniet at quia alias consectetur at.	2025-06-26 22:30:08	2025-06-26 22:30:08	136/72	65	100.0	95	57	Tempora sint dolor dolorum quae voluptates.	Officiis dignissimos blanditiis corrupti aliquam nisi temporibus fugiat.	2025-10-04	Doloremque molestiae fuga neque ratione.	2025-09-04	13:00	3	pending	APT11739	\N
10741	257	10	2025-09-04 16:30:00	Headache	Emergency	Veritatis sit ab deleniti.	2025-06-26 22:30:08	2025-06-26 22:30:08	103/87	74	99.3	97	62	Saepe illo doloremque est et suscipit porro.	Voluptas consectetur non sunt quod.	2025-09-11	Cumque rerum perferendis totam.	2025-09-04	16:30	3	pending	APT11740	\N
10742	214	5	2025-09-04 15:30:00	High BP	OPD	Sed nesciunt tempora blanditiis.	2025-06-26 22:30:08	2025-06-26 22:30:08	132/64	92	97.9	99	72	Dolorum aut fugit nihil hic nulla quas.	Necessitatibus maxime laboriosam consequuntur porro labore.	2025-09-17	Dolorum modi debitis.	2025-09-04	15:30	3	pending	APT11741	\N
10743	361	5	2025-09-04 11:15:00	Skin Rash	Emergency	Natus distinctio sapiente voluptate quos ex deleniti.	2025-06-26 22:30:08	2025-06-26 22:30:08	111/62	99	99.3	96	83	Et neque commodi animi quibusdam eligendi aut.	Quaerat pariatur officiis nulla nulla et.	2025-09-28	Dolor sunt eaque.	2025-09-04	11:15	3	pending	APT11742	\N
10744	409	5	2025-09-04 14:45:00	Diabetes Check	Follow-up	Non blanditiis laudantium fugiat enim magni eius.	2025-06-26 22:30:08	2025-06-26 22:30:08	126/73	66	99.1	96	76	Quasi error esse voluptates repellendus ipsum provident.	Alias dolore illum cum ipsa pariatur quod.	2025-09-19	Corporis sequi minima nesciunt.	2025-09-04	14:45	3	pending	APT11743	\N
10745	262	5	2025-09-04 14:00:00	Headache	New	Itaque necessitatibus laborum magni enim necessitatibus.	2025-06-26 22:30:08	2025-06-26 22:30:08	106/86	91	100.4	100	80	Voluptatem adipisci voluptatem esse quo.	Vero adipisci quis porro laborum tempora.	2025-10-04	Eum iure nisi dolor odio vitae corrupti.	2025-09-04	14:00	3	pending	APT11744	\N
10746	459	5	2025-09-04 11:00:00	Cough	Follow-up	Eveniet voluptatem beatae perferendis.	2025-06-26 22:30:08	2025-06-26 22:30:08	104/64	67	99.3	99	60	Delectus nemo voluptatum dolorum.	Explicabo nisi nemo officia perspiciatis itaque.	2025-09-22	Voluptatibus suscipit ipsa a dignissimos possimus.	2025-09-04	11:00	3	pending	APT11745	\N
10747	200	4	2025-09-04 13:45:00	Back Pain	OPD	Placeat magnam ad.	2025-06-26 22:30:08	2025-06-26 22:30:08	105/81	72	98.4	96	65	Doloremque odio eos ut facere nobis dolorum doloremque.	Praesentium hic culpa dolore aut maiores.	2025-09-11	Rem esse possimus perspiciatis doloremque quisquam commodi repudiandae.	2025-09-04	13:45	3	pending	APT11746	\N
10748	425	5	2025-09-04 15:15:00	High BP	Emergency	Iusto eos autem voluptas a expedita dolores magni.	2025-06-26 22:30:08	2025-06-26 22:30:08	136/66	100	99.5	97	63	Quas optio numquam repellendus. Dolore totam error.	At veniam dolore dolorem reiciendis minima unde aspernatur veniam.	2025-09-23	Quod dolorem voluptates nisi vitae nisi.	2025-09-04	15:15	3	pending	APT11747	\N
10749	4	9	2025-09-04 15:15:00	Cough	New	Natus vel veniam nobis saepe.	2025-06-26 22:30:08	2025-06-26 22:30:08	118/60	92	99.0	99	78	Eius ab architecto illum nam occaecati numquam.	Praesentium tempora ipsum esse repudiandae molestias modi enim.	2025-09-30	Nesciunt minima hic dolore laborum a repellat.	2025-09-04	15:15	3	pending	APT11748	\N
10750	218	7	2025-09-04 15:00:00	Cough	New	Unde natus dolor.	2025-06-26 22:30:08	2025-06-26 22:30:08	119/61	96	97.9	100	80	Fugit vel ad saepe possimus illo veniam magni.	Nemo voluptas neque beatae.	2025-09-15	Libero nesciunt veniam laboriosam iste.	2025-09-04	15:00	3	pending	APT11749	\N
10751	108	8	2025-09-04 12:30:00	Back Pain	Emergency	Iste deserunt quod tempore.	2025-06-26 22:30:08	2025-06-26 22:30:08	125/76	78	99.8	96	60	Natus ipsam deleniti quam sapiente hic.	Pariatur quibusdam quam aliquid numquam iusto nostrum.	2025-09-20	Quasi quas modi vel fugiat.	2025-09-04	12:30	3	pending	APT11750	\N
10752	490	6	2025-09-05 16:15:00	Headache	Follow-up	Deleniti consequuntur cum facere cupiditate tempora.	2025-06-26 22:30:08	2025-06-26 22:30:08	135/89	66	97.5	96	64	Blanditiis ea excepturi asperiores autem molestiae.	Debitis veniam omnis voluptatibus modi voluptates porro.	2025-09-28	Cumque odit occaecati maxime.	2025-09-05	16:15	3	pending	APT11751	\N
10753	33	10	2025-09-05 13:00:00	Cough	New	Dolore repellat sint officia numquam similique.	2025-06-26 22:30:08	2025-06-26 22:30:08	124/66	89	98.4	100	81	Iste sit quasi voluptas fuga quam dolorem.	Sed molestiae nobis ullam molestiae consequatur qui expedita.	2025-10-03	Minus laborum ipsum consequatur et eaque quia voluptas.	2025-09-05	13:00	3	pending	APT11752	\N
10754	436	9	2025-09-05 11:30:00	Cough	OPD	Mollitia expedita laborum magnam aspernatur eligendi.	2025-06-26 22:30:08	2025-06-26 22:30:08	131/71	69	99.4	95	70	Nemo perferendis corporis rem iusto exercitationem.	Nulla repudiandae eveniet odit fugiat odio officiis adipisci aspernatur minus.	2025-09-21	Autem vitae dolores quidem eaque nihil facere.	2025-09-05	11:30	3	pending	APT11753	\N
10755	48	10	2025-09-05 11:30:00	Cough	Follow-up	Molestiae minima eos laboriosam ipsam minus laboriosam.	2025-06-26 22:30:08	2025-06-26 22:30:08	109/76	96	98.4	95	57	Culpa perferendis iusto est ipsa earum.	Ex sit consectetur eum nobis necessitatibus corrupti beatae consequuntur doloribus.	2025-09-28	Doloribus laboriosam delectus quae explicabo.	2025-09-05	11:30	3	pending	APT11754	\N
10756	490	9	2025-09-05 14:00:00	Cough	New	Temporibus inventore nostrum vero consequatur.	2025-06-26 22:30:08	2025-06-26 22:30:08	101/78	88	99.9	96	79	Deleniti voluptate ab ducimus. Eum quas id qui nulla.	Maxime doloremque aut voluptates pariatur deleniti esse similique consectetur suscipit.	2025-10-05	Reprehenderit maiores animi aspernatur adipisci maiores.	2025-09-05	14:00	3	pending	APT11755	\N
10757	90	8	2025-09-05 12:15:00	Headache	New	Reprehenderit tempora ducimus placeat possimus error quaerat.	2025-06-26 22:30:08	2025-06-26 22:30:08	103/62	84	98.7	95	84	Corrupti eos dolores officiis impedit ad.	Architecto fugit saepe officia error aliquam dolorum suscipit.	2025-09-15	Voluptates qui eum dolorem recusandae.	2025-09-05	12:15	3	pending	APT11756	\N
10758	406	9	2025-09-05 11:30:00	Back Pain	New	Mollitia occaecati iure facere nulla.	2025-06-26 22:30:08	2025-06-26 22:30:08	128/79	85	98.2	100	66	Asperiores optio saepe qui laboriosam voluptate ratione.	Voluptatibus quidem aut temporibus quia odit possimus.	2025-09-27	Voluptatibus nisi esse cum.	2025-09-05	11:30	3	pending	APT11757	\N
10759	491	8	2025-09-05 11:00:00	Headache	New	Eaque sapiente ipsa sequi ullam aspernatur.	2025-06-26 22:30:08	2025-06-26 22:30:08	115/69	100	100.2	98	79	Impedit recusandae repudiandae laborum.	Numquam totam aperiam facere atque illo modi.	2025-10-02	Voluptatem labore corrupti esse impedit.	2025-09-05	11:00	3	pending	APT11758	\N
10760	45	5	2025-09-05 11:30:00	Fever	Emergency	Deserunt dolorum ab deleniti.	2025-06-26 22:30:08	2025-06-26 22:30:08	100/67	79	97.7	99	81	Minus et voluptates cum. Perferendis veritatis eius.	Esse quidem atque temporibus ab pariatur magni exercitationem.	2025-09-27	Officiis iure quis cum.	2025-09-05	11:30	3	pending	APT11759	\N
10761	88	5	2025-09-05 11:00:00	Headache	Emergency	Cumque quasi beatae fuga quos excepturi.	2025-06-26 22:30:08	2025-06-26 22:30:08	112/73	65	99.5	95	77	Magni repellendus excepturi ipsa quisquam.	Porro at tempora nemo error.	2025-10-05	Incidunt odio exercitationem excepturi quo dolorem.	2025-09-05	11:00	3	pending	APT11760	\N
10762	245	10	2025-09-05 14:15:00	Fever	Emergency	Labore minima delectus vitae eaque.	2025-06-26 22:30:08	2025-06-26 22:30:08	134/78	100	98.3	100	84	Debitis quisquam ratione dolorem occaecati rerum.	Esse autem cupiditate commodi fugit culpa expedita iste tempore facere sit.	2025-09-12	Odit dolore magni architecto sed numquam magni.	2025-09-05	14:15	3	pending	APT11761	\N
10763	435	10	2025-09-05 12:30:00	Fever	Emergency	Aliquam illo quidem nam quisquam quas recusandae.	2025-06-26 22:30:08	2025-06-26 22:30:08	139/68	77	98.7	96	85	Unde laudantium excepturi odio temporibus sequi odit.	Rerum voluptatem asperiores occaecati fugit rem nobis minus.	2025-09-21	Itaque ut quae.	2025-09-05	12:30	3	pending	APT11762	\N
10764	368	7	2025-09-05 11:30:00	High BP	Follow-up	Ipsum repellendus natus.	2025-06-26 22:30:08	2025-06-26 22:30:08	109/87	86	98.1	95	73	Voluptate placeat aliquid.	Culpa ex porro magni repellendus blanditiis porro quos necessitatibus similique.	2025-10-04	Voluptatum id repudiandae nam accusamus ab est.	2025-09-05	11:30	3	pending	APT11763	\N
10765	375	6	2025-09-05 12:45:00	Headache	Emergency	Sint suscipit odit quod.	2025-06-26 22:30:08	2025-06-26 22:30:08	140/89	100	100.3	97	68	Repellat eligendi ipsam magnam est nihil velit.	Odio itaque est culpa veritatis repellendus mollitia est saepe ut aut.	2025-09-22	Qui repellat maxime delectus maiores qui.	2025-09-05	12:45	3	pending	APT11764	\N
10766	300	5	2025-09-05 12:00:00	Diabetes Check	Emergency	Optio corrupti iure ipsa quia.	2025-06-26 22:30:08	2025-06-26 22:30:08	103/61	81	99.4	99	58	Beatae eaque error facilis laboriosam.	Quos necessitatibus nisi assumenda alias necessitatibus.	2025-09-23	Ut alias alias enim.	2025-09-05	12:00	3	pending	APT11765	\N
10767	438	9	2025-09-05 16:15:00	Fever	New	Quam exercitationem quisquam consequuntur odio velit eos suscipit.	2025-06-26 22:30:08	2025-06-26 22:30:08	101/79	90	99.3	96	66	Non mollitia fugiat blanditiis blanditiis maxime esse.	Reiciendis possimus voluptatibus corporis eum.	2025-10-03	Harum laudantium autem ea commodi.	2025-09-05	16:15	3	pending	APT11766	\N
10768	65	10	2025-09-05 13:45:00	Fever	Follow-up	Sunt facere nostrum molestiae quae ad quo.	2025-06-26 22:30:08	2025-06-26 22:30:08	138/82	86	99.3	100	68	Magni cupiditate voluptatem ipsa eligendi.	Earum eaque quisquam iste modi non adipisci.	2025-09-13	Non reiciendis maxime delectus enim id placeat accusamus.	2025-09-05	13:45	3	pending	APT11767	\N
10769	152	7	2025-09-05 13:30:00	Back Pain	Follow-up	Vitae magnam deleniti voluptas.	2025-06-26 22:30:08	2025-06-26 22:30:08	128/78	66	99.5	96	58	Tempore magnam ab quaerat molestiae.	Reiciendis ab sint nam animi.	2025-09-22	Ab sunt perferendis quas vel.	2025-09-05	13:30	3	pending	APT11768	\N
10770	282	7	2025-09-05 11:00:00	High BP	Emergency	Possimus rerum repellat optio placeat non expedita sit.	2025-06-26 22:30:08	2025-06-26 22:30:08	100/87	82	100.2	98	78	Necessitatibus nobis dignissimos ut cumque.	Minima dolorem vitae quasi sint.	2025-09-20	Labore officiis commodi asperiores voluptatum quasi in.	2025-09-05	11:00	3	pending	APT11769	\N
10771	30	6	2025-09-05 16:30:00	Routine Checkup	Emergency	Dicta atque pariatur.	2025-06-26 22:30:08	2025-06-26 22:30:08	101/88	91	99.8	100	69	Occaecati laudantium aut iure aut praesentium placeat.	Voluptate dolore inventore recusandae ratione eum.	2025-09-22	Aut sapiente reprehenderit labore iste hic animi magnam.	2025-09-05	16:30	3	pending	APT11770	\N
10772	376	5	2025-09-05 13:15:00	Diabetes Check	New	Tenetur perferendis at facere consequatur quibusdam autem.	2025-06-26 22:30:08	2025-06-26 22:30:08	138/88	74	100.5	98	57	Quisquam cupiditate maxime dicta fuga quis ea.	Labore ab voluptas reprehenderit illum facere.	2025-09-23	Fugiat molestias assumenda.	2025-09-05	13:15	3	pending	APT11771	\N
10773	406	6	2025-09-05 12:30:00	Skin Rash	Emergency	Modi error neque neque.	2025-06-26 22:30:08	2025-06-26 22:30:08	121/76	72	98.5	100	56	Numquam voluptate numquam minima laudantium.	Quaerat libero aspernatur laborum quia.	2025-09-18	Cupiditate minima sapiente dignissimos cum iste laboriosam.	2025-09-05	12:30	3	pending	APT11772	\N
10774	466	4	2025-09-05 13:45:00	Back Pain	New	Hic quidem repellendus in voluptatum provident natus.	2025-06-26 22:30:08	2025-06-26 22:30:08	115/72	82	98.8	97	70	Excepturi fuga blanditiis inventore officiis blanditiis.	Animi maxime veniam autem.	2025-10-03	Facere dolor amet.	2025-09-05	13:45	3	pending	APT11773	\N
10775	241	8	2025-09-05 11:00:00	Back Pain	Follow-up	Enim officiis vel nobis eligendi.	2025-06-26 22:30:08	2025-06-26 22:30:08	137/66	73	97.9	96	83	Esse assumenda iure vero vitae adipisci iste praesentium.	Fuga suscipit vero expedita ducimus architecto nostrum.	2025-09-21	Repellendus eum architecto eaque eligendi blanditiis veniam.	2025-09-05	11:00	3	pending	APT11774	\N
10776	403	9	2025-09-05 16:15:00	High BP	New	Magni fugit eveniet vero illum doloremque.	2025-06-26 22:30:08	2025-06-26 22:30:08	104/73	82	98.3	96	63	Cumque impedit alias eveniet nostrum.	Eligendi voluptates tempore delectus necessitatibus fugiat provident quae.	2025-09-14	Quod nisi neque explicabo incidunt error.	2025-09-05	16:15	3	pending	APT11775	\N
10777	438	6	2025-09-05 11:30:00	Diabetes Check	Emergency	Nisi dolorem doloribus.	2025-06-26 22:30:08	2025-06-26 22:30:08	109/60	78	98.5	98	70	Minima dicta quam voluptatem ipsam.	Fugiat illum officia cumque praesentium sint harum nobis neque.	2025-09-19	Ipsa magnam perspiciatis ea harum sit repudiandae.	2025-09-05	11:30	3	pending	APT11776	\N
10778	261	4	2025-09-05 12:00:00	Cough	Emergency	Corporis neque aspernatur fugit.	2025-06-26 22:30:08	2025-06-26 22:30:08	125/77	99	98.6	96	68	Hic occaecati dolor nobis.	Ut neque et autem reprehenderit culpa commodi rerum quo earum.	2025-09-15	Fuga ullam ipsa earum deserunt voluptates.	2025-09-05	12:00	3	pending	APT11777	\N
10779	418	4	2025-09-06 14:30:00	Headache	Follow-up	Nesciunt eum atque rerum corporis.	2025-06-26 22:30:08	2025-06-26 22:30:08	121/64	75	97.5	99	68	Quos neque autem deleniti veniam praesentium.	Aperiam tenetur officia voluptas eius fuga quia harum fuga.	2025-09-29	Voluptatem sit esse magnam.	2025-09-06	14:30	3	pending	APT11778	\N
10780	220	3	2025-09-06 14:45:00	Cough	Emergency	Incidunt beatae harum pariatur.	2025-06-26 22:30:08	2025-06-26 22:30:08	127/83	77	97.9	96	58	Iste cupiditate sequi fuga ipsa consectetur quo.	Placeat accusamus error maxime blanditiis nam maxime iste officia aliquid.	2025-09-25	Harum similique molestias aliquid nobis.	2025-09-06	14:45	3	pending	APT11779	\N
10781	219	8	2025-09-06 11:45:00	Skin Rash	New	Quod alias deserunt velit labore.	2025-06-26 22:30:08	2025-06-26 22:30:08	105/74	95	98.8	96	64	Esse ipsum beatae doloremque ea. Enim error accusamus.	Maiores voluptatum rerum accusantium aut quo assumenda molestias.	2025-09-19	Illo error vel assumenda expedita quod.	2025-09-06	11:45	3	pending	APT11780	\N
10782	281	3	2025-09-06 16:30:00	Back Pain	New	Quia tempora quo iure eos.	2025-06-26 22:30:08	2025-06-26 22:30:08	111/77	84	97.6	96	65	Fugit quam ratione error. Magni accusamus molestias.	Voluptatum distinctio similique voluptatem rerum.	2025-09-14	Aliquid commodi sunt inventore dolore ad.	2025-09-06	16:30	3	pending	APT11781	\N
10783	268	3	2025-09-06 15:15:00	Headache	Follow-up	Beatae accusantium sequi placeat neque fugit sapiente.	2025-06-26 22:30:08	2025-06-26 22:30:08	125/90	84	98.1	95	82	Odio sunt beatae nobis illum nisi.	Impedit alias non dolore ex laborum.	2025-09-16	Reiciendis repellat officiis.	2025-09-06	15:15	3	pending	APT11782	\N
10784	498	10	2025-09-06 14:15:00	Cough	Emergency	Quam sapiente unde ipsa voluptate magni.	2025-06-26 22:30:08	2025-06-26 22:30:08	117/60	91	99.8	96	85	Nisi quae cum expedita a. Consectetur quas expedita in.	Ea sit alias dolorum consequatur.	2025-10-01	Nesciunt dolorum distinctio labore.	2025-09-06	14:15	3	pending	APT11783	\N
10785	239	5	2025-09-06 16:00:00	Fever	New	Quibusdam assumenda corrupti quo dolorem iure voluptate.	2025-06-26 22:30:08	2025-06-26 22:30:08	138/85	99	98.7	98	69	Maiores excepturi excepturi dolorum.	Cumque amet nam inventore dignissimos nihil expedita incidunt.	2025-09-18	Consequuntur culpa quidem debitis.	2025-09-06	16:00	3	pending	APT11784	\N
10786	397	7	2025-09-06 14:45:00	Back Pain	Emergency	Nemo nihil asperiores soluta repellat provident sunt magnam.	2025-06-26 22:30:08	2025-06-26 22:30:08	136/60	78	99.5	95	74	Eum voluptas error deleniti sapiente.	Doloribus culpa blanditiis voluptate.	2025-10-06	Quas deleniti in saepe id maiores deserunt.	2025-09-06	14:45	3	pending	APT11785	\N
10787	453	7	2025-09-06 12:00:00	Routine Checkup	New	Saepe ipsum omnis dignissimos aliquid itaque magnam.	2025-06-26 22:30:08	2025-06-26 22:30:08	118/90	100	99.3	95	77	Fugiat maxime ratione impedit facere suscipit deleniti.	Enim sequi rem odio laborum quasi.	2025-09-18	Temporibus reprehenderit id culpa.	2025-09-06	12:00	3	pending	APT11786	\N
10788	312	8	2025-09-06 11:45:00	Routine Checkup	Follow-up	Repudiandae provident ut repellendus molestias.	2025-06-26 22:30:08	2025-06-26 22:30:08	101/70	76	98.4	96	81	Consequuntur autem quo dolor.	Voluptatum tenetur amet exercitationem recusandae adipisci quam iusto.	2025-09-15	Doloremque tempora maiores expedita eveniet.	2025-09-06	11:45	3	pending	APT11787	\N
10789	499	5	2025-09-06 13:45:00	Back Pain	New	Qui a architecto incidunt distinctio.	2025-06-26 22:30:08	2025-06-26 22:30:08	140/74	88	98.4	96	66	At veritatis officia praesentium impedit.	Quia aspernatur inventore eos ullam aliquam laudantium a ipsam mollitia.	2025-09-15	Officiis repudiandae aperiam repudiandae.	2025-09-06	13:45	3	pending	APT11788	\N
10790	280	9	2025-09-06 13:15:00	Fever	OPD	Facilis veniam laborum eligendi totam sequi hic consequatur.	2025-06-26 22:30:08	2025-06-26 22:30:08	112/79	65	99.3	95	72	Enim sed officia.	Exercitationem fugiat asperiores fugiat commodi soluta at rerum temporibus saepe.	2025-10-02	Nisi debitis inventore.	2025-09-06	13:15	3	pending	APT11789	\N
10791	171	10	2025-09-06 16:45:00	Back Pain	OPD	Hic fugit eius sapiente.	2025-06-26 22:30:08	2025-06-26 22:30:08	132/82	84	99.0	100	65	Quod culpa autem quod veniam deserunt quo.	Dolore aperiam tempore ipsam nam eos accusamus ut rerum.	2025-09-14	Laborum minus saepe repudiandae.	2025-09-06	16:45	3	pending	APT11790	\N
10792	167	8	2025-09-06 16:00:00	Skin Rash	New	Ducimus minus quibusdam odit et illo molestias.	2025-06-26 22:30:08	2025-06-26 22:30:08	132/81	76	98.2	98	79	Labore maxime excepturi voluptatum.	Excepturi rerum repellat libero accusamus officia laborum.	2025-09-15	Modi laborum molestiae.	2025-09-06	16:00	3	pending	APT11791	\N
10793	39	4	2025-09-06 16:15:00	High BP	New	Odio cum temporibus alias eos exercitationem.	2025-06-26 22:30:08	2025-06-26 22:30:08	105/88	68	98.3	98	57	Modi inventore quidem consequuntur temporibus.	Rerum reiciendis praesentium voluptatum numquam sequi.	2025-09-16	Atque similique recusandae repellendus exercitationem.	2025-09-06	16:15	3	pending	APT11792	\N
10794	40	10	2025-09-06 11:15:00	Back Pain	Emergency	Sed cum sapiente explicabo.	2025-06-26 22:30:08	2025-06-26 22:30:08	128/61	99	97.7	95	63	Commodi tenetur sunt.	Fugit laboriosam illum libero nulla fuga ex.	2025-09-24	Magnam ea quaerat.	2025-09-06	11:15	3	pending	APT11793	\N
10795	60	4	2025-09-06 14:45:00	Routine Checkup	OPD	Quis aut iure in consequatur architecto.	2025-06-26 22:30:08	2025-06-26 22:30:08	136/66	87	98.5	97	55	Optio ducimus itaque delectus.	Ratione excepturi harum beatae vero nemo debitis.	2025-09-28	Nulla consequatur minus sequi ipsum voluptate.	2025-09-06	14:45	3	pending	APT11794	\N
10796	396	3	2025-09-06 14:15:00	Headache	OPD	Asperiores vitae quam iste quo.	2025-06-26 22:30:08	2025-06-26 22:30:08	100/90	98	97.8	99	71	Quidem animi ipsa. Ut a quas error optio nihil ab.	Odio alias aspernatur cum sunt quas minus beatae.	2025-09-14	Quasi necessitatibus culpa ipsa repellat distinctio optio.	2025-09-06	14:15	3	pending	APT11795	\N
10797	24	4	2025-09-06 14:15:00	Skin Rash	Follow-up	Eligendi blanditiis perspiciatis consectetur assumenda corrupti libero unde.	2025-06-26 22:30:08	2025-06-26 22:30:08	133/80	93	98.7	100	81	Eius itaque deserunt culpa.	Magni ullam deleniti quod explicabo nulla.	2025-10-05	Ab architecto non.	2025-09-06	14:15	3	pending	APT11796	\N
10798	165	6	2025-09-06 13:45:00	Routine Checkup	New	Dolores quibusdam consequatur ad.	2025-06-26 22:30:08	2025-06-26 22:30:08	114/68	92	100.2	100	83	Vel optio sequi fugit nostrum nemo adipisci.	Quas esse odit tenetur unde consectetur eum saepe.	2025-09-14	Quos perspiciatis omnis eveniet debitis eligendi at ipsam.	2025-09-06	13:45	3	pending	APT11797	\N
10799	61	6	2025-09-06 12:30:00	Headache	Follow-up	Qui sed dolores voluptate recusandae repudiandae laboriosam.	2025-06-26 22:30:08	2025-06-26 22:30:08	101/90	76	100.4	99	84	Eaque nisi sunt eligendi similique tempora error.	Sed hic corrupti ullam vel harum quia explicabo vel.	2025-09-22	Soluta excepturi earum voluptate cupiditate.	2025-09-06	12:30	3	pending	APT11798	\N
10800	258	6	2025-09-06 14:45:00	Back Pain	Emergency	Debitis ex vel corporis sunt.	2025-06-26 22:30:08	2025-06-26 22:30:08	120/62	82	98.9	95	68	Vel repellat dicta debitis nesciunt.	Perferendis vel provident facere blanditiis ratione.	2025-09-13	Ratione ducimus neque iusto iure.	2025-09-06	14:45	3	pending	APT11799	\N
10801	497	9	2025-09-06 12:45:00	Routine Checkup	OPD	Corporis eius cum pariatur commodi voluptate.	2025-06-26 22:30:08	2025-06-26 22:30:08	128/72	65	98.3	99	84	Qui consequuntur vel.	Architecto amet doloribus delectus tempore tempore incidunt iusto.	2025-09-19	Quas recusandae esse culpa odio.	2025-09-06	12:45	3	pending	APT11800	\N
10802	391	4	2025-09-06 16:00:00	Headache	New	Natus rerum officia vel deserunt facere.	2025-06-26 22:30:08	2025-06-26 22:30:08	107/79	71	99.5	97	63	Quisquam architecto soluta ipsum fugit aperiam quo.	Assumenda ea totam voluptatem velit veniam.	2025-09-30	Consequuntur repellendus nobis neque qui deserunt.	2025-09-06	16:00	3	pending	APT11801	\N
10803	105	10	2025-09-06 13:15:00	Routine Checkup	Follow-up	Repellendus odit delectus cumque laudantium in.	2025-06-26 22:30:08	2025-06-26 22:30:08	113/61	98	99.7	99	73	Voluptatibus quam ad.	Autem hic eum nostrum ullam quibusdam nostrum modi voluptates.	2025-09-15	Veniam numquam ex.	2025-09-06	13:15	3	pending	APT11802	\N
10804	396	3	2025-09-06 13:30:00	Fever	Follow-up	Vitae vel harum facere.	2025-06-26 22:30:08	2025-06-26 22:30:08	101/83	99	98.9	99	81	Eligendi quasi officia eos.	Ipsam doloremque modi tenetur nihil porro sed alias laboriosam.	2025-09-15	Ratione provident porro.	2025-09-06	13:30	3	pending	APT11803	\N
10805	37	6	2025-09-06 13:30:00	Cough	New	Provident nulla ea rerum quasi consequuntur.	2025-06-26 22:30:08	2025-06-26 22:30:08	115/67	80	100.3	97	57	Alias magnam sequi nam earum.	Animi perferendis reiciendis laborum tempore repellat.	2025-09-30	Perspiciatis blanditiis qui officiis dolorum.	2025-09-06	13:30	3	pending	APT11804	\N
10806	304	8	2025-09-06 14:45:00	Cough	Emergency	Quibusdam quis itaque nisi sit laboriosam voluptatem in.	2025-06-26 22:30:08	2025-06-26 22:30:08	119/60	78	99.1	96	58	Iusto incidunt ipsum harum dolores.	Odit voluptate eveniet harum quis soluta tenetur saepe maiores ut.	2025-09-16	Totam quae vero earum sunt.	2025-09-06	14:45	3	pending	APT11805	\N
10807	350	6	2025-09-06 14:00:00	Skin Rash	Emergency	Incidunt molestias quae fugit aut nemo suscipit.	2025-06-26 22:30:08	2025-06-26 22:30:08	133/64	73	98.0	100	74	Praesentium at quam maiores culpa quia.	Unde magnam inventore iure ex veniam et totam vero illo.	2025-09-30	Atque culpa deleniti occaecati illo.	2025-09-06	14:00	3	pending	APT11806	\N
10808	205	4	2025-09-07 12:15:00	Back Pain	OPD	Consectetur deleniti nemo qui qui exercitationem ullam aliquid.	2025-06-26 22:30:08	2025-06-26 22:30:08	110/86	77	99.4	97	67	Hic esse ab aspernatur.	Temporibus cupiditate maxime velit unde.	2025-09-22	Deserunt iusto iusto porro rem laudantium ut doloremque.	2025-09-07	12:15	3	pending	APT11807	\N
10809	172	6	2025-09-07 16:15:00	Routine Checkup	Follow-up	Nostrum minima iure.	2025-06-26 22:30:08	2025-06-26 22:30:08	122/82	83	100.1	98	76	Repudiandae amet ab repellat quidem magni similique.	Doloremque corporis recusandae dolor totam ratione asperiores.	2025-09-30	Officiis nobis magnam consequatur doloremque molestiae repellat.	2025-09-07	16:15	3	pending	APT11808	\N
10810	275	9	2025-09-07 15:30:00	High BP	Follow-up	Qui saepe reprehenderit dolorum.	2025-06-26 22:30:08	2025-06-26 22:30:08	130/67	90	100.0	96	64	Possimus delectus est facilis doloremque ex doloribus.	Odit facere deserunt sit natus.	2025-09-26	Dignissimos hic officiis illo.	2025-09-07	15:30	3	pending	APT11809	\N
10811	454	6	2025-09-07 13:00:00	High BP	OPD	Dolorem sequi voluptatem corrupti.	2025-06-26 22:30:08	2025-06-26 22:30:08	102/71	77	98.4	99	80	Itaque rerum consequatur omnis quasi.	Iure praesentium asperiores officiis sed consequatur voluptas veritatis enim.	2025-09-20	Maxime sequi placeat soluta expedita commodi quo sint.	2025-09-07	13:00	3	pending	APT11810	\N
10812	6	4	2025-09-07 13:45:00	Fever	Emergency	Rem est suscipit minus est et quidem.	2025-06-26 22:30:08	2025-06-26 22:30:08	108/85	79	99.5	96	56	Pariatur accusantium eum.	Ad ex voluptatum alias soluta voluptas fugiat tempore.	2025-09-17	Aspernatur nobis amet unde vel voluptatem.	2025-09-07	13:45	3	pending	APT11811	\N
10813	297	3	2025-09-07 16:30:00	High BP	Follow-up	Alias illo deleniti earum.	2025-06-26 22:30:08	2025-06-26 22:30:08	114/87	66	99.7	95	79	Harum excepturi eaque porro quidem occaecati.	Incidunt error itaque earum corporis quibusdam quidem.	2025-09-23	Fugit eligendi explicabo repellat.	2025-09-07	16:30	3	pending	APT11812	\N
10814	50	10	2025-09-07 13:30:00	Cough	Emergency	Illum quas veritatis reiciendis.	2025-06-26 22:30:08	2025-06-26 22:30:08	127/73	86	99.6	98	73	Laudantium quas distinctio earum ad reiciendis architecto.	Officia deserunt amet consectetur ea.	2025-09-18	Suscipit nisi iste distinctio.	2025-09-07	13:30	3	pending	APT11813	\N
10815	132	6	2025-09-07 13:15:00	Headache	New	Nemo fugit et harum occaecati tenetur nemo alias.	2025-06-26 22:30:08	2025-06-26 22:30:08	138/79	74	97.5	96	84	Porro minima voluptate assumenda quos.	Sed dolor eius voluptate soluta iure facere repellat nostrum.	2025-09-28	Quibusdam molestiae minus cum animi.	2025-09-07	13:15	3	pending	APT11814	\N
10816	223	8	2025-09-07 16:00:00	Routine Checkup	New	Nulla pariatur nisi autem cum iusto odit ab.	2025-06-26 22:30:08	2025-06-26 22:30:08	132/65	67	98.7	100	83	Praesentium sequi repellendus repellat ut.	Voluptatem impedit veniam possimus ipsum facilis quaerat.	2025-10-03	Nam delectus eligendi reiciendis provident officia corporis.	2025-09-07	16:00	3	pending	APT11815	\N
10817	218	7	2025-09-07 11:15:00	Cough	Emergency	Fugit numquam eos cum corporis.	2025-06-26 22:30:08	2025-06-26 22:30:08	116/76	84	99.4	96	69	Eius quae nesciunt molestiae eveniet reprehenderit.	Dolorum illo ducimus inventore necessitatibus eos sed cumque.	2025-09-22	Natus eos consequatur dicta doloribus reprehenderit.	2025-09-07	11:15	3	pending	APT11816	\N
10818	270	8	2025-09-07 16:15:00	High BP	New	Eligendi ea eius quod suscipit esse.	2025-06-26 22:30:08	2025-06-26 22:30:08	138/68	67	99.3	95	64	Quas enim aut aliquid. Non dicta soluta.	Excepturi commodi sint saepe dolorum id.	2025-09-25	Maxime illo quisquam beatae voluptates voluptatum excepturi.	2025-09-07	16:15	3	pending	APT11817	\N
10819	353	8	2025-09-07 14:30:00	Routine Checkup	New	Pariatur vel error cupiditate temporibus fugiat.	2025-06-26 22:30:08	2025-06-26 22:30:08	105/76	100	99.6	100	56	Occaecati veniam illo beatae.	Incidunt earum consequuntur adipisci ut sapiente delectus voluptates.	2025-09-25	Ipsam provident iste doloremque rerum itaque deserunt.	2025-09-07	14:30	3	pending	APT11818	\N
10820	487	4	2025-09-07 13:45:00	Skin Rash	Emergency	Necessitatibus qui consequuntur maiores sapiente recusandae.	2025-06-26 22:30:08	2025-06-26 22:30:08	119/63	90	100.4	98	63	Illum excepturi odit commodi optio provident.	Inventore quis doloribus nulla excepturi voluptates doloremque autem qui facere.	2025-09-30	Eum fuga aspernatur.	2025-09-07	13:45	3	pending	APT11819	\N
10821	369	5	2025-09-07 12:45:00	Diabetes Check	Emergency	Officia nam voluptate eum.	2025-06-26 22:30:08	2025-06-26 22:30:08	136/64	83	97.8	97	83	Magni iure quasi.	Maxime accusamus atque ipsam autem aliquam nostrum rerum corrupti veniam molestiae.	2025-09-24	Maxime perferendis blanditiis facilis doloremque cum.	2025-09-07	12:45	3	pending	APT11820	\N
10822	268	5	2025-09-07 16:30:00	High BP	OPD	Corporis dicta esse fuga praesentium aliquid.	2025-06-26 22:30:08	2025-06-26 22:30:08	132/71	89	98.7	95	84	Blanditiis debitis sit ipsa odit veritatis.	Cum nesciunt quisquam eos dicta earum tenetur.	2025-10-04	Est beatae iusto molestiae eaque.	2025-09-07	16:30	3	pending	APT11821	\N
10823	453	10	2025-09-07 11:00:00	Headache	OPD	Odit dolor nobis facilis ut.	2025-06-26 22:30:08	2025-06-26 22:30:08	115/85	75	98.9	96	64	Officiis culpa impedit excepturi facilis.	Reiciendis blanditiis quis voluptates quibusdam.	2025-09-24	Minus dolorum tempore in.	2025-09-07	11:00	3	pending	APT11822	\N
10824	83	5	2025-09-07 16:30:00	Routine Checkup	Emergency	Quas dicta ipsa rem assumenda iste inventore.	2025-06-26 22:30:08	2025-06-26 22:30:08	117/76	65	99.3	96	75	Odio architecto recusandae unde atque.	Culpa saepe quis nulla eligendi eius.	2025-10-03	Explicabo nesciunt repellat quod.	2025-09-07	16:30	3	pending	APT11823	\N
10825	12	5	2025-09-07 15:15:00	High BP	OPD	Placeat quisquam est sit eligendi beatae.	2025-06-26 22:30:08	2025-06-26 22:30:08	113/64	87	98.5	98	74	Placeat occaecati dignissimos quaerat adipisci porro ex.	Commodi corrupti quam saepe voluptatibus quam soluta at quod ducimus fuga.	2025-09-16	Aspernatur quod blanditiis modi velit nemo doloremque.	2025-09-07	15:15	3	pending	APT11824	\N
10826	117	10	2025-09-07 16:15:00	Headache	New	Id necessitatibus at quasi animi eligendi minima nulla.	2025-06-26 22:30:08	2025-06-26 22:30:08	116/61	78	97.7	95	58	Quidem repudiandae porro vero expedita.	In facilis nam corporis consectetur quasi.	2025-09-29	Eum a culpa porro tempore nesciunt et corporis.	2025-09-07	16:15	3	pending	APT11825	\N
10827	323	7	2025-09-07 11:30:00	Routine Checkup	New	Corporis eveniet doloremque exercitationem laudantium iste.	2025-06-26 22:30:08	2025-06-26 22:30:08	140/63	77	98.1	100	80	At repudiandae sunt labore ipsa.	Consectetur distinctio reiciendis illo perferendis dolores atque est impedit dicta officia.	2025-10-01	Vitae iure totam nostrum ipsam vitae voluptatibus.	2025-09-07	11:30	3	pending	APT11826	\N
10828	24	6	2025-09-07 14:15:00	Routine Checkup	OPD	Atque aperiam accusamus deleniti.	2025-06-26 22:30:08	2025-06-26 22:30:08	116/77	85	98.2	98	63	Porro dolores adipisci eius porro nisi.	Ut impedit unde deserunt rerum laudantium explicabo libero iste blanditiis.	2025-09-18	Quos quae voluptates ad officiis aspernatur.	2025-09-07	14:15	3	pending	APT11827	\N
10829	320	4	2025-09-08 14:00:00	Diabetes Check	Follow-up	Voluptatibus commodi maxime nisi fuga ipsam quasi officiis.	2025-06-26 22:30:08	2025-06-26 22:30:08	128/74	84	98.3	100	75	Nisi tenetur laudantium illo quae sint quaerat.	Cum soluta ad minima omnis.	2025-10-04	Id commodi delectus temporibus ad.	2025-09-08	14:00	3	pending	APT11828	\N
10830	203	4	2025-09-08 11:30:00	Cough	Emergency	Quo eius reiciendis natus eaque quaerat accusantium labore.	2025-06-26 22:30:08	2025-06-26 22:30:08	136/67	93	100.4	95	72	Aliquid est nulla enim consequatur laborum quidem vitae.	Repellendus quos fugit id commodi.	2025-09-29	Expedita repellendus itaque corrupti ratione.	2025-09-08	11:30	3	pending	APT11829	\N
10831	149	4	2025-09-08 13:00:00	Cough	New	Error quidem ratione veniam.	2025-06-26 22:30:08	2025-06-26 22:30:08	109/86	68	98.6	97	64	Maiores placeat nemo ex unde mollitia voluptatem.	Nihil molestias facilis maiores eaque aliquid architecto rerum rem laboriosam.	2025-09-21	Doloribus fugit in repudiandae vitae ducimus mollitia debitis.	2025-09-08	13:00	3	pending	APT11830	\N
10832	227	4	2025-09-08 13:15:00	Skin Rash	OPD	Occaecati neque laudantium rerum.	2025-06-26 22:30:08	2025-06-26 22:30:08	126/71	76	99.0	97	65	Harum quisquam maxime nisi modi.	Explicabo velit quasi iure deleniti vero nihil animi.	2025-09-23	Animi cupiditate nobis cumque expedita.	2025-09-08	13:15	3	pending	APT11831	\N
10833	9	5	2025-09-08 15:15:00	Routine Checkup	Emergency	Provident ad deserunt quibusdam similique.	2025-06-26 22:30:08	2025-06-26 22:30:08	118/84	86	99.8	97	66	Natus excepturi non aliquid.	Amet quam esse quidem magni maxime doloremque ut vitae.	2025-09-25	Praesentium ipsa eligendi voluptatem.	2025-09-08	15:15	3	pending	APT11832	\N
10834	439	10	2025-09-08 13:30:00	Back Pain	New	Repellendus sunt excepturi neque dolorum voluptates.	2025-06-26 22:30:08	2025-06-26 22:30:08	125/70	95	97.9	99	63	Officiis voluptatem nam.	Suscipit tenetur eligendi fugiat ducimus saepe minima sunt.	2025-10-04	Provident doloribus adipisci ipsam suscipit corrupti.	2025-09-08	13:30	3	pending	APT11833	\N
10835	200	6	2025-09-08 16:00:00	Diabetes Check	Emergency	Magni autem excepturi eligendi tenetur inventore facere ipsum.	2025-06-26 22:30:08	2025-06-26 22:30:08	123/65	74	98.6	98	72	Dolorem aspernatur facere quod.	Dolores non commodi laudantium repellendus accusamus ipsa.	2025-09-30	Quam ea fugit accusantium porro.	2025-09-08	16:00	3	pending	APT11834	\N
10836	51	7	2025-09-08 11:00:00	Skin Rash	New	Illo quis nam maiores.	2025-06-26 22:30:08	2025-06-26 22:30:08	118/77	87	100.2	99	76	Officia assumenda similique reprehenderit.	Vel illum eaque autem amet hic.	2025-09-27	Possimus eos porro officia error.	2025-09-08	11:00	3	pending	APT11835	\N
10837	147	5	2025-09-08 13:30:00	Headache	OPD	Mollitia perferendis nam magnam earum voluptatem.	2025-06-26 22:30:08	2025-06-26 22:30:08	139/60	99	98.8	97	85	Delectus asperiores autem id alias.	Dolores voluptatem soluta nisi vel aliquam omnis.	2025-10-08	Voluptates voluptatem placeat voluptatum labore.	2025-09-08	13:30	3	pending	APT11836	\N
10838	359	7	2025-09-08 12:30:00	High BP	Follow-up	Distinctio sit dolores voluptas saepe aut exercitationem aliquam.	2025-06-26 22:30:08	2025-06-26 22:30:08	124/85	67	98.5	96	78	Et nesciunt voluptates aperiam.	Iste iste explicabo aliquam molestias cupiditate voluptatum in.	2025-09-25	Sed aut facilis mollitia nisi soluta voluptatem.	2025-09-08	12:30	3	pending	APT11837	\N
10839	92	7	2025-09-08 12:30:00	Headache	OPD	Perspiciatis reprehenderit atque corporis fuga dolore doloremque.	2025-06-26 22:30:08	2025-06-26 22:30:08	116/80	98	98.1	100	63	Officia tempore corporis.	Laudantium magni quaerat iste libero quibusdam exercitationem harum cupiditate.	2025-09-16	Quae deleniti excepturi magnam molestias iste atque sint.	2025-09-08	12:30	3	pending	APT11838	\N
10840	290	9	2025-09-08 11:15:00	Cough	OPD	Adipisci eveniet unde tempore pariatur.	2025-06-26 22:30:08	2025-06-26 22:30:08	126/80	100	98.9	100	58	Vel corrupti a cum.	Fugiat vel suscipit nulla quidem eveniet tempora.	2025-09-21	Voluptatem veritatis illo ea sint illo.	2025-09-08	11:15	3	pending	APT11839	\N
10841	499	6	2025-09-08 11:30:00	Diabetes Check	Follow-up	Voluptate error aliquam esse ipsum.	2025-06-26 22:30:08	2025-06-26 22:30:08	101/75	82	99.6	99	63	Molestiae reiciendis ea. Libero quasi deleniti.	Nesciunt inventore officia quaerat iste maiores assumenda animi repellendus pariatur libero.	2025-09-17	Unde veniam aliquid qui tempore.	2025-09-08	11:30	3	pending	APT11840	\N
10842	104	10	2025-09-08 13:00:00	Back Pain	Emergency	Libero unde porro laborum neque ipsum autem.	2025-06-26 22:30:08	2025-06-26 22:30:08	111/67	83	98.9	96	66	Nobis doloribus sequi.	Temporibus fugiat quidem odio iste facilis explicabo explicabo.	2025-10-04	Quibusdam iure quibusdam rem qui.	2025-09-08	13:00	3	pending	APT11841	\N
10843	20	8	2025-09-08 15:45:00	Routine Checkup	New	Pariatur voluptatum sapiente esse.	2025-06-26 22:30:08	2025-06-26 22:30:08	109/89	67	99.3	96	77	Itaque aut modi sint optio hic nihil.	Earum repellat sit culpa libero cum eveniet in.	2025-09-19	Odio corrupti voluptates tempore quo voluptatibus.	2025-09-08	15:45	3	pending	APT11842	\N
10844	24	6	2025-09-08 13:30:00	Routine Checkup	OPD	Harum omnis pariatur laborum.	2025-06-26 22:30:08	2025-06-26 22:30:08	102/69	74	99.2	96	81	Rerum ab consectetur dignissimos eveniet velit.	Mollitia illum exercitationem sapiente debitis hic accusantium.	2025-09-28	Totam officiis ipsa totam quidem quibusdam.	2025-09-08	13:30	3	pending	APT11843	\N
10845	162	4	2025-09-08 16:30:00	Headache	New	Ipsum culpa eius ea quae nemo.	2025-06-26 22:30:08	2025-06-26 22:30:08	138/83	94	98.6	96	76	Dolore nulla sed tempore cum.	Amet beatae dignissimos quis tenetur error.	2025-10-07	Asperiores a quae animi.	2025-09-08	16:30	3	pending	APT11844	\N
10846	436	3	2025-09-08 15:00:00	Diabetes Check	Follow-up	Explicabo mollitia laudantium eum sint.	2025-06-26 22:30:08	2025-06-26 22:30:08	101/80	98	99.2	97	75	Eius molestias illum commodi sed dolorum minima.	Nulla exercitationem nobis non quae neque ab quas.	2025-09-30	Doloribus officiis molestiae necessitatibus inventore est eum.	2025-09-08	15:00	3	pending	APT11845	\N
10847	326	5	2025-09-08 12:15:00	High BP	New	Facilis molestias amet quos.	2025-06-26 22:30:08	2025-06-26 22:30:08	137/87	87	100.1	98	60	Dolorum optio quae sunt saepe nihil in.	Soluta alias temporibus voluptatem excepturi quia dolores ad.	2025-09-18	Ea quo est id ipsum et odio.	2025-09-08	12:15	3	pending	APT11846	\N
10848	448	7	2025-09-08 13:45:00	Diabetes Check	New	Dolorem porro neque aperiam quo fuga.	2025-06-26 22:30:08	2025-06-26 22:30:08	122/86	81	99.5	98	58	Porro tempore illo numquam blanditiis corrupti.	Possimus temporibus voluptas debitis exercitationem rerum dolor accusamus ratione mollitia.	2025-10-05	Quidem voluptatem provident laudantium dolor rerum ducimus.	2025-09-08	13:45	3	pending	APT11847	\N
10849	455	3	2025-09-08 12:30:00	Headache	OPD	Minima officiis laborum est asperiores.	2025-06-26 22:30:08	2025-06-26 22:30:08	117/68	87	99.3	98	76	Adipisci blanditiis tenetur sed doloribus.	Alias beatae quibusdam ducimus exercitationem quidem iure sequi iusto reprehenderit placeat.	2025-09-20	Molestiae veritatis distinctio veniam.	2025-09-08	12:30	3	pending	APT11848	\N
10850	230	10	2025-09-09 16:45:00	High BP	New	Est odit debitis explicabo quae modi consequuntur.	2025-06-26 22:30:08	2025-06-26 22:30:08	128/71	79	99.0	100	59	Est laudantium doloribus illo provident.	Delectus similique repellat earum ex unde.	2025-10-08	Voluptate eos neque eius a.	2025-09-09	16:45	3	pending	APT11849	\N
10851	395	8	2025-09-09 12:45:00	Headache	Emergency	Accusamus magni quaerat eaque.	2025-06-26 22:30:08	2025-06-26 22:30:08	126/86	85	100.1	97	84	Deserunt veritatis quo nesciunt nesciunt.	Eaque aliquam quia quos distinctio occaecati culpa.	2025-09-23	Voluptatum ea qui.	2025-09-09	12:45	3	pending	APT11850	\N
10852	208	3	2025-09-09 13:00:00	High BP	Emergency	Quo officiis perferendis est beatae mollitia.	2025-06-26 22:30:08	2025-06-26 22:30:08	120/72	88	98.5	99	72	Inventore quos vero provident modi molestiae.	Facilis culpa optio doloremque autem aliquam aliquam repudiandae nam.	2025-09-17	Voluptate laborum nesciunt.	2025-09-09	13:00	3	pending	APT11851	\N
10853	389	5	2025-09-09 12:15:00	Diabetes Check	Follow-up	Suscipit nisi voluptates nisi iusto et pariatur.	2025-06-26 22:30:08	2025-06-26 22:30:08	125/83	83	99.8	98	81	Cum ipsam rem consequatur aspernatur aperiam voluptate.	Consequatur hic ipsam distinctio facilis nihil quasi nobis animi suscipit.	2025-09-28	Eveniet id exercitationem iure rem eos quod numquam.	2025-09-09	12:15	3	pending	APT11852	\N
10854	325	5	2025-09-09 13:45:00	Routine Checkup	Emergency	Earum repellendus reiciendis occaecati dolore repellat recusandae voluptas.	2025-06-26 22:30:08	2025-06-26 22:30:08	120/74	76	99.0	98	75	Beatae placeat mollitia veritatis natus officiis.	Dolore repellat hic aut.	2025-09-29	Corporis deserunt hic quae reiciendis vitae quam.	2025-09-09	13:45	3	pending	APT11853	\N
10855	374	9	2025-09-09 11:15:00	Skin Rash	Emergency	Iure totam voluptatibus iusto voluptatibus nemo assumenda.	2025-06-26 22:30:08	2025-06-26 22:30:08	110/75	89	98.1	97	67	Repudiandae error mollitia iusto suscipit.	Magni ad dolore aliquid aut deserunt.	2025-09-23	Facere quod at alias.	2025-09-09	11:15	3	pending	APT11854	\N
10856	493	7	2025-09-09 13:00:00	Diabetes Check	OPD	Doloremque quidem ipsum tempora dolores aperiam accusantium labore.	2025-06-26 22:30:08	2025-06-26 22:30:08	106/63	98	98.0	95	69	Magni fugiat aliquam at. Beatae sapiente animi et.	Ipsam iure ad quidem commodi.	2025-09-27	Ipsam quos nemo.	2025-09-09	13:00	3	pending	APT11855	\N
10857	263	6	2025-09-09 11:30:00	Back Pain	Emergency	Laborum unde eum dolor.	2025-06-26 22:30:08	2025-06-26 22:30:08	132/81	92	100.2	100	77	Blanditiis eum aut odio mollitia cupiditate porro.	Perferendis eos ullam corporis nobis cupiditate nostrum fugiat.	2025-09-27	Minima dignissimos ex voluptas quis laborum.	2025-09-09	11:30	3	pending	APT11856	\N
10858	374	9	2025-09-09 15:00:00	Headache	Emergency	Eius libero quia ipsum.	2025-06-26 22:30:08	2025-06-26 22:30:08	107/63	82	99.7	96	73	Quis occaecati quia fugit.	Ipsa iste labore distinctio necessitatibus incidunt vitae soluta tempore officia.	2025-10-09	Explicabo sed laborum corporis ipsa perferendis consequatur dolores.	2025-09-09	15:00	3	pending	APT11857	\N
10859	477	10	2025-09-09 16:00:00	Back Pain	New	Cum cumque aspernatur ullam accusantium occaecati repellendus.	2025-06-26 22:30:08	2025-06-26 22:30:08	120/64	100	99.9	97	55	Autem nisi dolores sit tempore.	Delectus reiciendis natus aut vero facere in eveniet consectetur sed.	2025-09-30	Cumque iusto placeat laudantium eveniet.	2025-09-09	16:00	3	pending	APT11858	\N
10860	266	6	2025-09-09 11:45:00	Fever	Emergency	Quidem ad deleniti incidunt est laboriosam nisi debitis.	2025-06-26 22:30:08	2025-06-26 22:30:08	107/62	95	97.8	95	74	Blanditiis cupiditate molestiae atque molestias.	Libero vero eveniet debitis fuga quaerat omnis.	2025-10-07	Provident ea ipsam laboriosam incidunt enim voluptatibus ullam.	2025-09-09	11:45	3	pending	APT11859	\N
10861	13	9	2025-09-09 15:45:00	Skin Rash	Follow-up	Maxime accusamus neque asperiores fugiat impedit.	2025-06-26 22:30:08	2025-06-26 22:30:08	119/71	97	98.4	95	85	Nam fuga dolore similique ducimus debitis id neque.	Expedita officia harum sint eligendi similique illo in beatae.	2025-09-22	Repellat voluptates quod corrupti corporis odit.	2025-09-09	15:45	3	pending	APT11860	\N
10862	314	5	2025-09-09 15:45:00	Cough	Emergency	Quibusdam dicta dolor consectetur nesciunt mollitia iure earum.	2025-06-26 22:30:08	2025-06-26 22:30:08	101/80	92	99.1	95	63	Accusamus quam sequi aut in deleniti cumque.	Ipsam nobis voluptas repellendus rem adipisci qui ullam.	2025-10-03	Alias blanditiis eligendi aperiam dolorem.	2025-09-09	15:45	3	pending	APT11861	\N
10863	242	6	2025-09-09 15:45:00	Back Pain	Follow-up	Dolores occaecati ipsum et fuga doloremque veniam.	2025-06-26 22:30:08	2025-06-26 22:30:08	128/64	91	99.2	99	59	Eius vero placeat qui error mollitia exercitationem veniam.	Vel assumenda quis repudiandae unde iure alias quos.	2025-09-28	Deserunt itaque optio ab pariatur ducimus.	2025-09-09	15:45	3	pending	APT11862	\N
10864	109	3	2025-09-09 11:45:00	Headache	New	Dolor enim vero rerum consequatur nulla quam.	2025-06-26 22:30:08	2025-06-26 22:30:08	113/63	88	98.1	96	84	Perferendis harum quasi eveniet.	Ratione doloremque praesentium magni non in hic.	2025-10-01	Aliquam totam repellat quia.	2025-09-09	11:45	3	pending	APT11863	\N
10865	268	3	2025-09-09 15:00:00	Cough	Follow-up	Minima dolorum qui distinctio.	2025-06-26 22:30:08	2025-06-26 22:30:08	119/79	71	98.5	100	60	Esse sint odit magnam. Ea amet odit. Quia molestiae atque.	Magni totam modi deserunt culpa maiores.	2025-10-03	Vitae beatae repellat porro inventore dolorem earum.	2025-09-09	15:00	3	pending	APT11864	\N
10866	129	4	2025-09-09 14:00:00	Routine Checkup	Emergency	Recusandae provident cumque velit deserunt.	2025-06-26 22:30:08	2025-06-26 22:30:08	132/82	71	98.2	96	65	At recusandae reiciendis eveniet officia harum in.	Voluptatem suscipit numquam accusamus laboriosam aperiam nobis.	2025-09-26	Asperiores aut officiis praesentium consequuntur.	2025-09-09	14:00	3	pending	APT11865	\N
10867	259	3	2025-09-09 16:45:00	Cough	Emergency	Magnam qui repellendus vitae modi fugiat commodi neque.	2025-06-26 22:30:08	2025-06-26 22:30:08	138/69	75	98.2	98	74	Quisquam ducimus omnis dolor impedit libero.	Repudiandae fuga placeat eius reiciendis cupiditate cupiditate at.	2025-09-18	Voluptatum iste neque accusamus.	2025-09-09	16:45	3	pending	APT11866	\N
10868	350	4	2025-09-09 13:30:00	Fever	OPD	Odit repellat consectetur nostrum exercitationem distinctio laboriosam.	2025-06-26 22:30:08	2025-06-26 22:30:08	136/78	66	98.4	96	61	Ipsam quis hic suscipit tempore fugiat hic.	Assumenda voluptatibus nostrum nemo quia dolores.	2025-09-30	Possimus nisi eum cum ab.	2025-09-09	13:30	3	pending	APT11867	\N
10869	327	9	2025-09-09 13:30:00	Cough	New	Suscipit alias placeat quod sequi.	2025-06-26 22:30:08	2025-06-26 22:30:08	111/78	93	98.8	100	72	Iusto earum suscipit. Nemo ipsa facere.	Molestias eum asperiores aliquid.	2025-10-06	Alias nostrum iste aliquam fuga aspernatur laborum voluptatibus.	2025-09-09	13:30	3	pending	APT11868	\N
10870	488	9	2025-09-09 13:15:00	Fever	OPD	Fuga quam deserunt corporis ea corporis quibusdam.	2025-06-26 22:30:08	2025-06-26 22:30:08	140/88	89	100.0	98	62	Nobis molestiae repudiandae asperiores.	Vero iusto earum ex iste.	2025-09-21	Hic laboriosam dicta dignissimos eaque.	2025-09-09	13:15	3	pending	APT11869	\N
10871	102	7	2025-09-09 16:00:00	Fever	Follow-up	Odit dolores placeat neque.	2025-06-26 22:30:08	2025-06-26 22:30:08	117/71	80	98.0	99	55	Error dolorem animi enim asperiores quas ipsum delectus.	Sapiente sequi animi laborum cupiditate aspernatur iste id voluptatum minima ipsa.	2025-10-03	Numquam et vel.	2025-09-09	16:00	3	pending	APT11870	\N
10872	58	8	2025-09-09 14:15:00	Fever	Follow-up	Voluptatum neque voluptas quibusdam corrupti deserunt.	2025-06-26 22:30:08	2025-06-26 22:30:08	110/85	78	98.3	96	66	Consequatur iste tenetur.	Non voluptate laborum provident beatae quam aliquam quaerat.	2025-09-28	Explicabo laborum perspiciatis voluptatem.	2025-09-09	14:15	3	pending	APT11871	\N
10873	171	8	2025-09-09 13:00:00	Fever	New	Velit eaque totam alias quaerat eum ipsa ipsum.	2025-06-26 22:30:08	2025-06-26 22:30:08	132/77	66	97.9	95	85	Nihil a quo magni nulla error ad accusamus.	Autem reiciendis et animi sed unde incidunt.	2025-10-01	Incidunt porro quae eaque animi.	2025-09-09	13:00	3	pending	APT11872	\N
10874	435	5	2025-09-09 11:30:00	High BP	New	Tempore eius adipisci aliquam inventore iure veniam.	2025-06-26 22:30:08	2025-06-26 22:30:08	134/84	65	98.7	99	79	Corporis recusandae eveniet ex laudantium facere.	Dolorum dolor magni quas reprehenderit distinctio similique harum laboriosam.	2025-10-09	Maxime necessitatibus necessitatibus ipsam.	2025-09-09	11:30	3	pending	APT11873	\N
10875	355	3	2025-09-10 13:45:00	Diabetes Check	Emergency	Maiores tempore eius repudiandae.	2025-06-26 22:30:08	2025-06-26 22:30:08	124/77	75	97.7	95	73	Neque culpa expedita impedit corporis cumque eius eaque.	Quia vitae earum suscipit similique impedit autem doloremque neque est adipisci.	2025-09-19	Quaerat quaerat nisi quod unde possimus unde.	2025-09-10	13:45	3	pending	APT11874	\N
10876	467	8	2025-09-10 11:30:00	Fever	OPD	Nobis tenetur cumque at.	2025-06-26 22:30:08	2025-06-26 22:30:08	137/73	66	100.3	95	73	Corrupti alias aperiam reiciendis deleniti.	Aut culpa ad nam laboriosam.	2025-09-21	Adipisci sapiente necessitatibus laboriosam.	2025-09-10	11:30	3	pending	APT11875	\N
10877	227	8	2025-09-10 11:00:00	Cough	Emergency	Laborum molestias ipsa tenetur quo pariatur.	2025-06-26 22:30:08	2025-06-26 22:30:08	129/87	92	98.3	100	76	Sed unde laudantium suscipit modi.	Esse voluptate consequuntur alias ducimus pariatur.	2025-09-27	Libero ab vitae quis repudiandae odio.	2025-09-10	11:00	3	pending	APT11876	\N
10878	291	8	2025-09-10 13:45:00	Fever	OPD	Aut voluptatibus iure voluptate recusandae asperiores.	2025-06-26 22:30:08	2025-06-26 22:30:08	115/76	65	98.8	99	63	Numquam cumque dignissimos eaque consequatur.	Ipsa velit quia eveniet libero deserunt aperiam natus.	2025-09-19	Dolorem iusto tenetur sint nostrum.	2025-09-10	13:45	3	pending	APT11877	\N
10879	159	8	2025-09-10 12:30:00	High BP	New	Optio ad ipsa excepturi possimus quis error.	2025-06-26 22:30:08	2025-06-26 22:30:08	102/62	75	99.1	99	66	Quia perspiciatis repellat et eligendi deserunt.	Tempora inventore dolore laudantium est.	2025-10-02	Fugit dolorem vero aut impedit.	2025-09-10	12:30	3	pending	APT11878	\N
10880	313	10	2025-09-10 13:15:00	Diabetes Check	Follow-up	Veritatis possimus vitae soluta labore.	2025-06-26 22:30:08	2025-06-26 22:30:08	125/88	94	100.2	99	71	Dolores veniam ullam molestias. Aut sit dolor.	Dignissimos possimus assumenda quod voluptas sint illo nobis culpa laborum.	2025-09-26	Id voluptas tempora nisi temporibus molestias dolor.	2025-09-10	13:15	3	pending	APT11879	\N
10881	500	3	2025-09-10 12:15:00	Cough	Follow-up	Asperiores officia itaque temporibus esse sed.	2025-06-26 22:30:08	2025-06-26 22:30:08	131/71	75	100.1	99	79	Molestias sint mollitia at vitae.	Maiores deserunt occaecati quaerat cumque eius magni sit.	2025-09-18	Laborum expedita vitae vero facere odit recusandae eaque.	2025-09-10	12:15	3	pending	APT11880	\N
10882	443	8	2025-09-10 12:30:00	Back Pain	Emergency	Aliquam pariatur beatae.	2025-06-26 22:30:08	2025-06-26 22:30:08	102/69	77	99.1	98	74	Nemo esse porro doloremque.	Adipisci tempore in occaecati vero.	2025-09-25	Magnam repellendus autem enim mollitia.	2025-09-10	12:30	3	pending	APT11881	\N
10883	190	7	2025-09-10 16:00:00	Fever	New	Aperiam corporis provident sunt deserunt laudantium.	2025-06-26 22:30:08	2025-06-26 22:30:08	113/72	69	98.9	97	70	Id sed unde excepturi nemo.	Illo consequatur nisi velit ut a reprehenderit ipsa.	2025-09-30	Corporis perferendis cumque veniam nemo repellat harum.	2025-09-10	16:00	3	pending	APT11882	\N
10884	176	10	2025-09-10 14:30:00	Back Pain	Emergency	Dolore ut iusto.	2025-06-26 22:30:08	2025-06-26 22:30:08	128/90	98	99.1	99	62	Quas cum harum possimus doloribus.	Libero recusandae facilis voluptatem debitis ad mollitia veniam.	2025-09-30	Cupiditate atque rerum itaque aliquid amet animi autem.	2025-09-10	14:30	3	pending	APT11883	\N
10885	494	3	2025-09-10 13:00:00	Skin Rash	Follow-up	Perspiciatis minus commodi provident.	2025-06-26 22:30:08	2025-06-26 22:30:08	138/72	65	99.5	97	62	Fuga consequuntur excepturi natus.	Reprehenderit ullam aperiam voluptatibus laudantium cumque cupiditate.	2025-09-20	Vero harum aspernatur similique doloribus.	2025-09-10	13:00	3	pending	APT11884	\N
10886	329	4	2025-09-10 16:15:00	Skin Rash	New	Fugit dolorum ab at ex quae possimus.	2025-06-26 22:30:08	2025-06-26 22:30:08	128/75	89	99.5	99	73	Cumque est aliquid repellendus numquam sint.	Labore fugit rem molestiae possimus blanditiis laboriosam vel.	2025-10-09	Deleniti maiores iure ratione.	2025-09-10	16:15	3	pending	APT11885	\N
10887	117	8	2025-09-10 11:45:00	Headache	New	Itaque harum et eligendi aut expedita optio.	2025-06-26 22:30:08	2025-06-26 22:30:08	120/60	97	97.6	100	63	Corporis nulla at temporibus.	Ex totam culpa eligendi et totam ad dolorum qui delectus asperiores.	2025-09-23	Labore corrupti odit quidem harum ea nesciunt doloremque.	2025-09-10	11:45	3	pending	APT11886	\N
10888	389	3	2025-09-10 15:30:00	Skin Rash	Emergency	Cumque delectus itaque.	2025-06-26 22:30:08	2025-06-26 22:30:08	105/83	88	97.8	97	71	Quo illo hic odit.	Facilis totam autem neque doloribus odit.	2025-10-02	Delectus quasi autem.	2025-09-10	15:30	3	pending	APT11887	\N
10889	214	6	2025-09-10 13:30:00	High BP	Emergency	Corporis iure dolorem illo nostrum sequi dolorem.	2025-06-26 22:30:08	2025-06-26 22:30:08	107/82	94	98.3	100	67	Consequuntur sint perferendis libero maxime harum.	Quaerat delectus recusandae voluptatibus architecto molestias atque distinctio.	2025-09-25	Ratione ipsam cum iste consequatur.	2025-09-10	13:30	3	pending	APT11888	\N
10890	29	9	2025-09-10 11:45:00	Headache	Follow-up	Veritatis culpa animi quidem reprehenderit repellat.	2025-06-26 22:30:08	2025-06-26 22:30:08	104/77	98	99.8	97	57	Libero blanditiis non consectetur.	Rerum qui eum voluptate accusantium quod saepe officiis dolores distinctio saepe.	2025-10-01	Et a voluptatem odio consectetur officia earum.	2025-09-10	11:45	3	pending	APT11889	\N
10891	16	9	2025-09-10 16:30:00	Fever	New	Accusamus accusamus beatae suscipit corporis dolorum molestiae.	2025-06-26 22:30:08	2025-06-26 22:30:08	108/66	99	99.2	97	78	Nihil nulla labore doloremque.	Ad tempore mollitia vel dignissimos at saepe maxime libero dolore.	2025-10-08	Vel eum necessitatibus rem modi ducimus.	2025-09-10	16:30	3	pending	APT11890	\N
10892	436	6	2025-09-10 12:15:00	Fever	Follow-up	Distinctio labore error possimus architecto exercitationem.	2025-06-26 22:30:08	2025-06-26 22:30:08	127/79	73	99.7	95	81	Hic quisquam nulla voluptas vel placeat voluptates.	Tempora accusamus illo qui quod.	2025-09-28	Omnis quisquam delectus.	2025-09-10	12:15	3	pending	APT11891	\N
10893	156	9	2025-09-10 12:00:00	Routine Checkup	Emergency	Illum commodi quaerat.	2025-06-26 22:30:08	2025-06-26 22:30:08	111/76	69	98.4	96	60	Repellat magnam deleniti soluta commodi non at.	Quo incidunt soluta impedit repellat.	2025-09-26	Ratione dicta maiores nisi modi commodi.	2025-09-10	12:00	3	pending	APT11892	\N
10894	485	9	2025-09-10 12:45:00	High BP	OPD	Illo exercitationem mollitia maiores eveniet.	2025-06-26 22:30:08	2025-06-26 22:30:08	103/64	81	99.5	98	58	Perferendis mollitia ea.	Ipsam harum eveniet at asperiores doloremque.	2025-09-18	Fugit dolore earum repellendus iste dolorem quia.	2025-09-10	12:45	3	pending	APT11893	\N
10895	315	3	2025-09-10 13:15:00	Fever	New	Aperiam dignissimos distinctio architecto deleniti.	2025-06-26 22:30:08	2025-06-26 22:30:08	101/60	100	98.0	95	57	Molestias explicabo ipsum dicta.	Illum ipsum quam sunt.	2025-10-10	Nostrum maxime nihil dolorum dolor.	2025-09-10	13:15	3	pending	APT11894	\N
10896	64	9	2025-09-10 14:15:00	Diabetes Check	Follow-up	Asperiores ratione quod modi optio delectus.	2025-06-26 22:30:08	2025-06-26 22:30:08	128/85	100	100.2	98	62	Quod ipsum culpa quos aliquam molestias ducimus.	Corporis voluptatem doloribus harum delectus nam autem.	2025-09-22	Omnis in inventore est.	2025-09-10	14:15	3	pending	APT11895	\N
10897	198	7	2025-09-10 12:15:00	Skin Rash	OPD	Error aliquam doloribus error quasi.	2025-06-26 22:30:08	2025-06-26 22:30:08	136/81	78	99.0	95	77	Accusantium dolore incidunt labore eius est quod.	Nihil laborum modi eligendi ea harum odio eius.	2025-10-10	Voluptatum similique nam eum deserunt.	2025-09-10	12:15	3	pending	APT11896	\N
10898	159	4	2025-09-10 13:15:00	Back Pain	Follow-up	Delectus inventore quasi explicabo id iusto.	2025-06-26 22:30:08	2025-06-26 22:30:08	108/64	91	99.5	97	64	Dicta doloremque non qui eaque in ducimus.	Possimus eum praesentium eaque reiciendis.	2025-10-01	Aliquam officiis perspiciatis laudantium eaque.	2025-09-10	13:15	3	pending	APT11897	\N
10899	113	8	2025-09-10 13:15:00	Cough	OPD	Error quo fugit quisquam doloremque.	2025-06-26 22:30:08	2025-06-26 22:30:08	120/88	72	97.6	97	63	Dolore id tenetur error maiores enim sapiente.	Aliquam fuga delectus pariatur eum repellat iusto.	2025-09-18	Voluptate nemo perferendis placeat est.	2025-09-10	13:15	3	pending	APT11898	\N
10900	151	4	2025-09-10 15:00:00	Headache	OPD	Fuga nulla aspernatur officiis tenetur.	2025-06-26 22:30:08	2025-06-26 22:30:08	101/74	84	98.5	95	77	Qui aut ipsa ab alias voluptate assumenda ducimus.	Dignissimos deleniti neque deserunt iusto quibusdam accusantium fugit.	2025-09-26	Nobis laborum exercitationem voluptate iure modi inventore.	2025-09-10	15:00	3	pending	APT11899	\N
10901	474	6	2025-09-11 16:45:00	Cough	New	Voluptates id recusandae.	2025-06-26 22:30:08	2025-06-26 22:30:08	139/88	98	100.2	96	83	Vitae reiciendis eos adipisci consequatur corrupti nostrum.	Adipisci dolore officiis repudiandae.	2025-10-03	Culpa quisquam natus repudiandae quas dolorum.	2025-09-11	16:45	3	pending	APT11900	\N
10902	147	5	2025-09-11 14:00:00	Back Pain	Emergency	Nostrum atque minima praesentium ad nihil odio quo.	2025-06-26 22:30:08	2025-06-26 22:30:08	127/77	80	100.1	96	79	Fuga aliquid perspiciatis quia.	Eos sint consequatur omnis magni maiores vero cupiditate.	2025-10-06	Sint facilis quia molestiae eaque harum esse aut.	2025-09-11	14:00	3	pending	APT11901	\N
10903	100	6	2025-09-11 16:15:00	Cough	New	Fugit dolorem porro voluptatem reprehenderit.	2025-06-26 22:30:08	2025-06-26 22:30:08	120/65	81	97.9	97	82	Tempora odit harum impedit excepturi fugit.	Sapiente reiciendis enim sit vitae vel fugiat ratione.	2025-10-02	Voluptate nostrum sunt quod.	2025-09-11	16:15	3	pending	APT11902	\N
10904	39	3	2025-09-11 13:45:00	Diabetes Check	Follow-up	Ratione distinctio optio.	2025-06-26 22:30:08	2025-06-26 22:30:08	105/67	91	97.9	99	75	Distinctio ad animi velit laboriosam dignissimos sint.	Voluptate tempore doloribus earum officia dicta sequi vero.	2025-09-20	Iusto omnis quia voluptatem eum.	2025-09-11	13:45	3	pending	APT11903	\N
10905	222	7	2025-09-11 11:30:00	Fever	Emergency	Magni totam nemo voluptatem.	2025-06-26 22:30:08	2025-06-26 22:30:08	111/65	93	99.3	97	68	Dignissimos vero officiis nulla corrupti fuga soluta quia.	Odio cumque quos facere aliquam facilis enim voluptas ut non.	2025-09-26	Reiciendis recusandae illo iure.	2025-09-11	11:30	3	pending	APT11904	\N
10906	199	5	2025-09-11 14:45:00	High BP	Follow-up	Beatae molestiae voluptas officia perspiciatis ex.	2025-06-26 22:30:08	2025-06-26 22:30:08	104/79	88	97.7	95	83	Consequatur culpa quos ducimus veritatis eum quidem.	Doloribus nostrum est nam necessitatibus saepe eaque corrupti consectetur unde.	2025-10-01	Minima necessitatibus adipisci esse hic.	2025-09-11	14:45	3	pending	APT11905	\N
10907	486	5	2025-09-11 16:15:00	Cough	OPD	Voluptas beatae animi.	2025-06-26 22:30:08	2025-06-26 22:30:08	114/79	84	99.4	100	55	Inventore numquam harum rerum commodi magnam.	Error ducimus temporibus deserunt adipisci excepturi illum magni.	2025-09-26	Eaque velit rem.	2025-09-11	16:15	3	pending	APT11906	\N
10908	300	5	2025-09-11 12:00:00	Routine Checkup	Emergency	Dolor necessitatibus aliquid adipisci dolorem ut.	2025-06-26 22:30:08	2025-06-26 22:30:08	122/76	95	98.7	100	80	Modi aperiam neque earum voluptatem aut alias.	Esse rerum veritatis veniam doloremque optio eaque expedita dolorum.	2025-10-07	Voluptatem quia porro at.	2025-09-11	12:00	3	pending	APT11907	\N
10909	399	8	2025-09-11 11:00:00	Skin Rash	OPD	Recusandae laudantium ipsa natus.	2025-06-26 22:30:08	2025-06-26 22:30:08	103/76	98	98.2	99	83	Beatae dolor tempore commodi.	Autem perferendis explicabo minus incidunt esse alias voluptatum similique.	2025-09-22	Sapiente blanditiis fugiat sint voluptates quod tenetur blanditiis.	2025-09-11	11:00	3	pending	APT11908	\N
10910	150	5	2025-09-11 12:00:00	Routine Checkup	New	Sapiente hic rem temporibus quod.	2025-06-26 22:30:08	2025-06-26 22:30:08	127/66	74	97.6	99	70	Eum eligendi autem adipisci amet iusto.	Natus atque natus at corporis.	2025-09-22	Magni accusantium provident magni est cupiditate.	2025-09-11	12:00	3	pending	APT11909	\N
10911	404	8	2025-09-11 14:00:00	Headache	Follow-up	Ducimus dolore animi non.	2025-06-26 22:30:08	2025-06-26 22:30:08	124/70	92	100.5	96	75	Odio atque nesciunt quibusdam deserunt voluptatibus ea.	Ad ratione a doloremque perspiciatis.	2025-10-01	Voluptatem quo repellendus beatae veritatis.	2025-09-11	14:00	3	pending	APT11910	\N
10912	428	10	2025-09-11 12:15:00	Back Pain	OPD	Modi in sit dicta saepe.	2025-06-26 22:30:08	2025-06-26 22:30:08	131/60	83	98.5	98	77	Ab ratione veritatis rem quasi necessitatibus.	Provident at animi aut quae vitae iste quis.	2025-09-20	Inventore enim laborum magnam provident nulla reiciendis.	2025-09-11	12:15	3	pending	APT11911	\N
10913	486	6	2025-09-11 14:45:00	Headache	Follow-up	Eos maxime aliquid at asperiores repudiandae.	2025-06-26 22:30:08	2025-06-26 22:30:08	106/63	72	98.4	98	61	Nemo dolores quod quod quibusdam nisi neque.	Aut itaque maxime vitae distinctio laudantium voluptatem quaerat asperiores recusandae.	2025-09-18	Deserunt eveniet qui deserunt incidunt voluptate architecto excepturi.	2025-09-11	14:45	3	pending	APT11912	\N
10914	309	4	2025-09-11 15:45:00	Headache	New	Molestiae perspiciatis ea odit aut sint.	2025-06-26 22:30:08	2025-06-26 22:30:08	139/79	100	100.0	99	63	Itaque mollitia placeat nemo laudantium dicta nemo illum.	Voluptatibus ipsum nemo sed debitis provident quasi.	2025-09-29	Aliquam dolorem vitae repellendus officiis ratione.	2025-09-11	15:45	3	pending	APT11913	\N
10915	48	3	2025-09-11 16:45:00	Skin Rash	Follow-up	Ducimus minima deserunt accusantium saepe vitae.	2025-06-26 22:30:08	2025-06-26 22:30:08	133/77	86	100.1	96	83	Aliquam et sunt repudiandae nobis.	Odio atque maiores sed consectetur pariatur magnam quisquam doloribus eveniet impedit.	2025-10-07	Sunt nam amet eius.	2025-09-11	16:45	3	pending	APT11914	\N
10916	428	10	2025-09-11 13:45:00	Diabetes Check	Follow-up	Vero beatae assumenda nobis repellat fugiat ipsa in.	2025-06-26 22:30:08	2025-06-26 22:30:08	124/82	81	100.1	98	76	Debitis temporibus officiis consectetur ex inventore.	Accusamus officiis soluta labore tempore ab tenetur reiciendis odio neque.	2025-09-24	Sed error libero animi eum qui autem.	2025-09-11	13:45	3	pending	APT11915	\N
10917	31	5	2025-09-11 15:15:00	Skin Rash	Follow-up	Nostrum voluptatem pariatur cumque inventore molestias.	2025-06-26 22:30:08	2025-06-26 22:30:08	107/70	98	100.4	96	60	Modi accusamus doloremque ullam alias sapiente maiores.	Sunt esse suscipit commodi totam sapiente et eaque.	2025-09-25	Qui dolorem impedit tempora tenetur.	2025-09-11	15:15	3	pending	APT11916	\N
10918	54	9	2025-09-11 12:00:00	Fever	New	Ipsam quia possimus laboriosam tenetur.	2025-06-26 22:30:08	2025-06-26 22:30:08	116/77	69	98.0	99	82	Quisquam ipsam consequatur. Sit et reiciendis quasi.	Provident quae autem dicta.	2025-09-29	Esse rem voluptate excepturi facilis autem dicta eum.	2025-09-11	12:00	3	pending	APT11917	\N
10919	92	8	2025-09-11 16:45:00	Back Pain	OPD	Ea harum dicta impedit.	2025-06-26 22:30:08	2025-06-26 22:30:08	139/83	90	99.5	97	69	Quasi placeat ad autem laudantium repudiandae minus.	Aliquam occaecati fuga porro necessitatibus quam facilis.	2025-10-10	Iure perferendis mollitia inventore illum officiis.	2025-09-11	16:45	3	pending	APT11918	\N
10920	496	6	2025-09-11 11:00:00	High BP	New	Optio delectus repellat.	2025-06-26 22:30:08	2025-06-26 22:30:08	113/90	92	99.7	99	78	Ex nam beatae. Alias sit non rem rerum.	Harum numquam illo accusamus rem.	2025-10-07	Quam ullam impedit alias repudiandae sit.	2025-09-11	11:00	3	pending	APT11919	\N
10921	436	3	2025-09-12 15:45:00	Diabetes Check	Follow-up	Totam veniam consequuntur illo quae omnis fuga aspernatur.	2025-06-26 22:30:08	2025-06-26 22:30:08	127/78	96	100.2	98	84	Quasi quia fuga doloremque.	Omnis corporis assumenda quidem harum accusantium rem deleniti.	2025-09-21	Architecto eius maxime quod possimus.	2025-09-12	15:45	3	pending	APT11920	\N
10922	202	5	2025-09-12 11:45:00	Headache	Emergency	Possimus sit distinctio aspernatur sequi totam.	2025-06-26 22:30:08	2025-06-26 22:30:08	128/72	77	98.4	96	78	Officiis odit unde aliquid ducimus.	Nisi dolore error consectetur sunt tempore illum facilis nobis.	2025-09-30	Quis laboriosam esse incidunt provident molestias.	2025-09-12	11:45	3	pending	APT11921	\N
10923	315	9	2025-09-12 16:00:00	Fever	New	Ex numquam earum rerum accusamus libero.	2025-06-26 22:30:08	2025-06-26 22:30:08	139/79	89	98.8	97	71	Veritatis possimus ducimus nihil quas quibusdam.	Debitis temporibus veniam at molestias consequuntur porro.	2025-09-19	Explicabo eius quos quisquam quis.	2025-09-12	16:00	3	pending	APT11922	\N
10924	168	6	2025-09-12 13:30:00	Cough	New	Nemo architecto facilis nam sed earum.	2025-06-26 22:30:08	2025-06-26 22:30:08	103/89	87	100.4	95	79	Consequatur tenetur illo voluptates vel.	Eaque quae totam voluptatem ducimus animi officia.	2025-09-21	Ducimus officia vel beatae.	2025-09-12	13:30	3	pending	APT11923	\N
10925	26	9	2025-09-12 13:15:00	Cough	New	Facere ratione in inventore repellat.	2025-06-26 22:30:08	2025-06-26 22:30:08	130/70	85	98.9	97	84	Maxime in distinctio necessitatibus asperiores dolorem aut.	Nemo quae maxime voluptates odio vero corporis officia laboriosam.	2025-10-08	Blanditiis modi repellat vel animi ducimus.	2025-09-12	13:15	3	pending	APT11924	\N
10926	326	6	2025-09-12 12:15:00	High BP	New	Dolor reprehenderit dolorem.	2025-06-26 22:30:08	2025-06-26 22:30:08	120/64	91	99.9	97	72	Dicta nulla possimus.	Architecto labore porro ipsum reiciendis totam doloribus.	2025-09-28	Dolorem sequi iure numquam id.	2025-09-12	12:15	3	pending	APT11925	\N
10927	438	3	2025-09-12 16:45:00	High BP	New	Recusandae earum nobis assumenda non.	2025-06-26 22:30:08	2025-06-26 22:30:08	111/76	99	98.3	97	76	Nihil illo consectetur id mollitia libero cumque.	Impedit hic odio ea provident ab impedit.	2025-09-28	Praesentium sunt fugit repellendus adipisci aut nihil quod.	2025-09-12	16:45	3	pending	APT11926	\N
10928	162	8	2025-09-12 15:45:00	Cough	New	Tenetur beatae veniam tempore.	2025-06-26 22:30:08	2025-06-26 22:30:08	120/79	97	99.0	96	57	Adipisci totam dolorum ab sequi incidunt magni magnam.	Quaerat culpa tempore accusamus odit soluta.	2025-09-21	Ab hic voluptates quisquam quo voluptatem.	2025-09-12	15:45	3	pending	APT11927	\N
10929	374	8	2025-09-12 13:00:00	Fever	Emergency	Deserunt cupiditate cumque nisi labore.	2025-06-26 22:30:08	2025-06-26 22:30:08	117/66	85	97.9	96	67	Eos et unde. Numquam dolor quasi autem totam.	Qui ducimus sapiente cum ab deserunt iste velit enim.	2025-10-03	Doloremque cupiditate mollitia optio unde ea dolorem minus.	2025-09-12	13:00	3	pending	APT11928	\N
10930	44	3	2025-09-12 12:15:00	Diabetes Check	New	Excepturi eligendi esse autem labore.	2025-06-26 22:30:08	2025-06-26 22:30:08	128/88	93	98.5	100	79	Ad accusantium ipsum neque asperiores ipsam.	Eaque et neque itaque quidem.	2025-10-04	Cupiditate porro deserunt cupiditate autem.	2025-09-12	12:15	3	pending	APT11929	\N
10931	8	6	2025-09-12 16:30:00	Headache	OPD	Expedita velit possimus occaecati inventore.	2025-06-26 22:30:08	2025-06-26 22:30:08	121/77	83	99.6	96	58	Veniam harum impedit distinctio quas labore.	Facilis repellat rerum fugiat debitis incidunt tempora.	2025-10-05	Excepturi eveniet eligendi.	2025-09-12	16:30	3	pending	APT11930	\N
10932	381	5	2025-09-12 14:00:00	High BP	OPD	Qui numquam necessitatibus eaque sunt dignissimos.	2025-06-26 22:30:08	2025-06-26 22:30:08	126/76	83	98.6	96	56	Sequi pariatur explicabo molestiae quo.	Quas fugit magni minus tempora nostrum repellat quasi culpa.	2025-09-23	Quod soluta reprehenderit temporibus tempora nostrum nihil.	2025-09-12	14:00	3	pending	APT11931	\N
10933	284	7	2025-09-12 13:15:00	High BP	New	Ducimus error numquam sed provident ab voluptatem.	2025-06-26 22:30:08	2025-06-26 22:30:08	138/80	96	97.6	96	60	Dolorum ea laborum quaerat vero praesentium.	Nostrum consequuntur illum sapiente quidem excepturi quia iusto.	2025-09-21	Commodi id a accusamus laboriosam itaque velit.	2025-09-12	13:15	3	pending	APT11932	\N
10934	361	7	2025-09-12 12:15:00	Cough	Follow-up	Natus illum quod.	2025-06-26 22:30:08	2025-06-26 22:30:08	109/64	82	100.0	99	69	Corporis ullam hic beatae aliquam fugiat optio.	Possimus optio sapiente consectetur repudiandae illum sed nulla.	2025-10-09	Reprehenderit a dignissimos.	2025-09-12	12:15	3	pending	APT11933	\N
10935	34	4	2025-09-12 11:15:00	Fever	Follow-up	Dolorem amet labore molestiae labore delectus.	2025-06-26 22:30:08	2025-06-26 22:30:08	118/64	94	98.5	97	85	Reprehenderit accusantium ullam dignissimos.	Sint accusamus laudantium necessitatibus enim.	2025-09-29	At quod porro maiores.	2025-09-12	11:15	3	pending	APT11934	\N
10936	409	7	2025-09-12 15:45:00	Diabetes Check	Emergency	Sint temporibus quisquam commodi quod unde.	2025-06-26 22:30:08	2025-06-26 22:30:08	136/77	82	97.8	98	68	Sed ducimus voluptate optio.	Cum nostrum sapiente ad ullam corporis modi.	2025-09-26	Nemo sit voluptas modi voluptates.	2025-09-12	15:45	3	pending	APT11935	\N
10937	189	9	2025-09-12 14:30:00	Back Pain	Follow-up	Porro sunt illum laudantium nam architecto laborum.	2025-06-26 22:30:08	2025-06-26 22:30:08	109/67	74	99.0	99	85	Ratione consequatur molestiae fuga.	Rerum eaque velit dolor nam perferendis velit est tempore.	2025-10-09	Similique mollitia dolorem.	2025-09-12	14:30	3	pending	APT11936	\N
10938	105	8	2025-09-12 16:15:00	Cough	OPD	Sed numquam ea nam.	2025-06-26 22:30:08	2025-06-26 22:30:08	136/75	71	100.1	96	75	Officiis error quis incidunt quam eos distinctio.	Harum facilis corrupti aliquid consequuntur.	2025-09-25	Expedita voluptatum hic.	2025-09-12	16:15	3	pending	APT11937	\N
10939	62	4	2025-09-12 14:45:00	Headache	New	Placeat doloremque veritatis porro quidem.	2025-06-26 22:30:08	2025-06-26 22:30:08	122/79	72	100.0	97	80	Unde aliquid libero mollitia reprehenderit labore.	Ea rem incidunt iste.	2025-10-02	Deleniti dolore rerum harum libero deserunt corrupti.	2025-09-12	14:45	3	pending	APT11938	\N
10940	285	9	2025-09-12 14:45:00	High BP	Emergency	Non dicta consequuntur expedita sunt dolore.	2025-06-26 22:30:08	2025-06-26 22:30:08	135/86	77	99.6	95	65	Eaque sunt ullam eligendi quia quaerat distinctio fugiat.	Reiciendis saepe culpa voluptatibus sequi.	2025-10-05	Porro neque temporibus reiciendis.	2025-09-12	14:45	3	pending	APT11939	\N
10941	382	7	2025-09-12 15:30:00	Back Pain	Emergency	Sint sequi id possimus aliquam unde.	2025-06-26 22:30:08	2025-06-26 22:30:08	128/77	73	98.3	99	82	Maiores corporis aspernatur delectus nihil ex.	Quibusdam itaque debitis magnam doloribus eos provident quam.	2025-10-02	Vel odio sed mollitia error animi beatae.	2025-09-12	15:30	3	pending	APT11940	\N
10942	454	4	2025-09-12 16:00:00	High BP	New	Omnis sapiente voluptatibus vero a amet itaque.	2025-06-26 22:30:08	2025-06-26 22:30:08	120/87	67	99.4	95	61	Suscipit at quisquam repudiandae libero voluptate autem.	Non est assumenda dolore delectus tenetur quidem odio.	2025-09-26	Non est minima voluptatem.	2025-09-12	16:00	3	pending	APT11941	\N
10943	205	6	2025-09-13 15:45:00	High BP	Follow-up	Dolore ea esse quam.	2025-06-26 22:30:08	2025-06-26 22:30:08	107/61	93	98.2	100	59	Fugit deserunt fugiat dolore.	Sed dignissimos sapiente deserunt mollitia sit nihil.	2025-09-25	Numquam pariatur perferendis.	2025-09-13	15:45	3	pending	APT11942	\N
10944	303	7	2025-09-13 13:00:00	High BP	Emergency	Harum eligendi velit iure.	2025-06-26 22:30:08	2025-06-26 22:30:08	116/72	97	97.9	96	85	Illo eaque dolorum ipsam.	Aut sapiente deserunt mollitia neque.	2025-10-05	Reprehenderit consequatur quibusdam iure veniam incidunt non.	2025-09-13	13:00	3	pending	APT11943	\N
10945	422	8	2025-09-13 12:15:00	Fever	OPD	Est vitae atque tempora corrupti.	2025-06-26 22:30:08	2025-06-26 22:30:08	113/79	78	99.6	96	76	Dignissimos perferendis similique eaque dolore ut.	Suscipit distinctio pariatur culpa porro nihil reiciendis labore fuga.	2025-10-02	Nemo doloremque mollitia nesciunt expedita maiores earum.	2025-09-13	12:15	3	pending	APT11944	\N
10946	324	3	2025-09-13 12:15:00	Fever	Emergency	Non excepturi corrupti maxime minus corporis explicabo.	2025-06-26 22:30:08	2025-06-26 22:30:08	138/74	78	98.2	100	70	Sit ipsam quasi ipsa perferendis iure commodi.	Natus atque dicta quam iure voluptate molestiae labore aut.	2025-09-23	Quia quaerat asperiores et sit.	2025-09-13	12:15	3	pending	APT11945	\N
10947	431	7	2025-09-13 13:00:00	Fever	OPD	Voluptatem quia placeat ipsam libero doloremque fuga.	2025-06-26 22:30:08	2025-06-26 22:30:08	106/72	79	99.4	97	82	Occaecati vitae iusto quia ut.	Tempora reiciendis tenetur incidunt veritatis modi nostrum blanditiis veniam eum.	2025-09-20	In quasi ut distinctio reiciendis dolorum iste.	2025-09-13	13:00	3	pending	APT11946	\N
10948	493	8	2025-09-13 13:45:00	Back Pain	Emergency	Velit architecto dicta qui.	2025-06-26 22:30:08	2025-06-26 22:30:08	137/76	65	99.8	100	62	Quia provident et sunt. Beatae dolore qui saepe.	Eaque eum earum asperiores nesciunt fugiat.	2025-10-04	Ab quas error officia.	2025-09-13	13:45	3	pending	APT11947	\N
10949	376	8	2025-09-13 13:45:00	High BP	Emergency	Laborum tempore facilis.	2025-06-26 22:30:08	2025-06-26 22:30:08	117/81	98	99.5	97	65	Est nostrum modi iure.	Praesentium architecto ea odit.	2025-09-25	Numquam recusandae aperiam harum.	2025-09-13	13:45	3	pending	APT11948	\N
10950	294	7	2025-09-13 16:15:00	Fever	New	Molestias sunt architecto reprehenderit.	2025-06-26 22:30:08	2025-06-26 22:30:08	107/87	95	98.5	99	82	Illo eveniet in velit assumenda a quas omnis.	Hic blanditiis quaerat ut occaecati ratione.	2025-09-27	Cupiditate quo veniam enim explicabo at qui.	2025-09-13	16:15	3	pending	APT11949	\N
10951	152	3	2025-09-13 11:15:00	Headache	Follow-up	Iste sit optio placeat magni.	2025-06-26 22:30:08	2025-06-26 22:30:08	109/89	76	100.1	98	82	Iste officiis doloremque tempore hic aspernatur temporibus.	Possimus quasi qui commodi optio aperiam repellat.	2025-10-10	Enim numquam nam temporibus possimus facere eveniet.	2025-09-13	11:15	3	pending	APT11950	\N
10952	57	5	2025-09-13 13:00:00	Headache	OPD	Facilis molestias suscipit minima.	2025-06-26 22:30:08	2025-06-26 22:30:08	128/67	79	99.3	98	70	Commodi blanditiis eius id.	Incidunt neque illum id soluta minima esse.	2025-09-21	Asperiores sit amet id pariatur velit officiis.	2025-09-13	13:00	3	pending	APT11951	\N
10953	151	6	2025-09-13 16:00:00	Fever	Emergency	Aut earum veritatis veritatis.	2025-06-26 22:30:08	2025-06-26 22:30:08	101/61	77	99.9	98	78	Maxime dolorem ut necessitatibus cupiditate illo.	Deleniti id maiores reprehenderit odit ratione sunt.	2025-10-07	Fuga odit enim excepturi.	2025-09-13	16:00	3	pending	APT11952	\N
10954	371	10	2025-09-13 11:45:00	Cough	New	Quasi nisi exercitationem sunt odio dicta soluta eius.	2025-06-26 22:30:08	2025-06-26 22:30:08	102/60	86	100.4	100	68	Placeat aut qui voluptatum laboriosam quasi sed.	Impedit totam minus modi facere veritatis nemo omnis beatae.	2025-09-28	Consectetur praesentium repudiandae in sed culpa.	2025-09-13	11:45	3	pending	APT11953	\N
10956	247	5	2025-09-13 15:15:00	Routine Checkup	OPD	Cumque cupiditate ullam soluta impedit quasi odio.	2025-06-26 22:30:08	2025-06-26 22:30:08	134/73	76	99.9	98	60	Totam consequuntur culpa quibusdam maiores quas.	Laudantium nesciunt minima necessitatibus magnam numquam dolorem architecto dignissimos tempore.	2025-09-21	Doloremque reiciendis vel repellat beatae fugit.	2025-09-13	15:15	3	pending	APT11955	\N
10957	132	4	2025-09-13 15:00:00	Routine Checkup	OPD	Aliquam labore odio quia.	2025-06-26 22:30:08	2025-06-26 22:30:08	122/89	75	98.8	100	64	Omnis veniam dolor dolorum.	Occaecati vitae nulla ducimus nemo ut.	2025-09-23	Rerum pariatur et ratione inventore dolorem laborum.	2025-09-13	15:00	3	pending	APT11956	\N
10958	45	3	2025-09-13 16:45:00	Headache	New	Aspernatur totam maiores sequi.	2025-06-26 22:30:08	2025-06-26 22:30:08	106/89	68	98.1	99	82	Non aliquam rem doloribus tempora dolorum omnis.	Nostrum dolorum ea reiciendis cupiditate dolorum dolores libero.	2025-10-08	Deleniti repellat architecto animi in voluptatum ullam.	2025-09-13	16:45	3	pending	APT11957	\N
10959	87	10	2025-09-13 14:15:00	Headache	Follow-up	Nam dolorem magni doloremque architecto.	2025-06-26 22:30:08	2025-06-26 22:30:08	110/77	94	100.3	96	76	Omnis aut deserunt facere cum dolores. Sed veritatis hic.	Explicabo autem deserunt fuga expedita perferendis.	2025-10-10	Maxime placeat vero.	2025-09-13	14:15	3	pending	APT11958	\N
10960	385	10	2025-09-13 16:00:00	Diabetes Check	Follow-up	In facilis laboriosam repudiandae iure quis nulla.	2025-06-26 22:30:08	2025-06-26 22:30:08	139/66	95	98.1	96	55	Autem excepturi doloremque.	Laborum architecto repudiandae assumenda non ipsa.	2025-10-02	Eum illo eum quaerat qui.	2025-09-13	16:00	3	pending	APT11959	\N
10961	115	8	2025-09-13 14:15:00	Headache	Follow-up	Officia porro minus occaecati eum.	2025-06-26 22:30:08	2025-06-26 22:30:08	128/83	98	99.5	100	70	Excepturi vel amet ratione magni laboriosam.	Harum recusandae nostrum corporis nobis.	2025-09-24	Consectetur repellendus blanditiis odio quod.	2025-09-13	14:15	3	pending	APT11960	\N
10962	212	7	2025-09-13 13:00:00	Cough	New	Odio alias numquam eligendi modi cupiditate.	2025-06-26 22:30:08	2025-06-26 22:30:08	132/72	97	99.9	98	70	Laudantium corrupti itaque fugit mollitia soluta quo.	Assumenda distinctio maxime dolorum officiis quia temporibus.	2025-09-27	Magni quia suscipit eius totam fugit.	2025-09-13	13:00	3	pending	APT11961	\N
10963	281	5	2025-09-13 16:15:00	Skin Rash	New	Sunt unde ducimus ipsam temporibus delectus dolorum doloribus.	2025-06-26 22:30:08	2025-06-26 22:30:08	131/75	89	100.0	99	62	Voluptatibus quidem ipsa. A vel similique occaecati.	Aliquam expedita mollitia excepturi doloremque provident odio.	2025-10-04	Officia neque cumque numquam dicta fugiat numquam.	2025-09-13	16:15	3	pending	APT11962	\N
10964	187	6	2025-09-13 12:30:00	Fever	Follow-up	Soluta quos explicabo ipsa.	2025-06-26 22:30:08	2025-06-26 22:30:08	116/79	76	100.3	98	64	Odit enim sequi cum aspernatur minima labore provident.	Nemo eligendi voluptatem illum ad occaecati sint quo.	2025-10-10	Qui corporis saepe exercitationem.	2025-09-13	12:30	3	pending	APT11963	\N
10965	284	3	2025-09-13 15:00:00	Cough	New	Autem consectetur possimus voluptatem dolorum deleniti ab placeat.	2025-06-26 22:30:08	2025-06-26 22:30:08	115/62	88	100.2	100	59	Dolore voluptates eaque culpa dolore fuga doloribus.	Accusantium ducimus eum quod quae culpa maiores quod quis ea.	2025-09-28	Dignissimos minima officia voluptatibus cumque.	2025-09-13	15:00	3	pending	APT11964	\N
10966	11	6	2025-09-13 16:15:00	Diabetes Check	New	Deserunt sapiente porro nam consequatur perspiciatis.	2025-06-26 22:30:08	2025-06-26 22:30:08	112/77	84	100.1	96	82	Natus non officia facilis voluptatibus voluptate.	Quia a perspiciatis est perspiciatis porro ut deserunt.	2025-09-28	Dicta nemo illum blanditiis.	2025-09-13	16:15	3	pending	APT11965	\N
10967	494	3	2025-09-14 13:45:00	Cough	Follow-up	Aliquid asperiores aliquam ea beatae.	2025-06-26 22:30:08	2025-06-26 22:30:08	104/85	94	98.8	97	80	Occaecati inventore explicabo. Optio voluptatem ipsum.	Iste consectetur voluptatibus voluptas tenetur repellendus.	2025-09-25	Laudantium corporis eveniet veniam.	2025-09-14	13:45	3	pending	APT11966	\N
10968	125	6	2025-09-14 11:30:00	Fever	OPD	Dignissimos recusandae minima neque molestiae odio enim cupiditate.	2025-06-26 22:30:08	2025-06-26 22:30:08	108/65	90	97.6	100	83	Repellat officiis autem eius ipsum.	Sed officiis quibusdam itaque ipsam dicta facilis amet architecto.	2025-10-04	Rem vel exercitationem labore modi.	2025-09-14	11:30	3	pending	APT11967	\N
10969	396	7	2025-09-14 14:30:00	High BP	New	Porro ipsum sed natus exercitationem voluptate dicta.	2025-06-26 22:30:08	2025-06-26 22:30:08	122/62	75	98.4	99	73	Fuga odio magnam tempore vitae asperiores quis.	Explicabo pariatur dolore nobis commodi tenetur vero.	2025-10-07	Ut asperiores at eveniet.	2025-09-14	14:30	3	pending	APT11968	\N
10970	280	5	2025-09-14 13:30:00	Routine Checkup	Follow-up	Excepturi voluptatibus deleniti rem voluptates ab earum.	2025-06-26 22:30:08	2025-06-26 22:30:08	121/64	84	97.9	99	71	Aliquid rerum quaerat rerum officiis recusandae.	Mollitia voluptate odit quia molestias eos voluptate eius.	2025-09-30	Iste porro quibusdam libero doloribus est amet.	2025-09-14	13:30	3	pending	APT11969	\N
10971	306	3	2025-09-14 16:15:00	Routine Checkup	New	Saepe ea nobis ratione veritatis possimus quidem magni.	2025-06-26 22:30:08	2025-06-26 22:30:08	129/76	88	99.7	97	68	Deserunt expedita quos assumenda nobis veritatis labore.	Officia accusamus natus autem eligendi repellat.	2025-10-02	Laboriosam enim ratione assumenda.	2025-09-14	16:15	3	pending	APT11970	\N
10972	118	9	2025-09-14 14:45:00	Fever	Emergency	Repellat autem esse fugiat sed.	2025-06-26 22:30:08	2025-06-26 22:30:08	123/64	80	98.8	100	62	Et impedit aut eveniet.	Quod omnis ex pariatur esse molestias distinctio occaecati.	2025-09-30	Esse sapiente illo adipisci quis omnis quos.	2025-09-14	14:45	3	pending	APT11971	\N
10973	266	3	2025-09-14 14:15:00	Cough	Emergency	Similique cumque totam.	2025-06-26 22:30:08	2025-06-26 22:30:08	101/82	71	100.3	99	77	Accusamus libero optio ab impedit architecto.	Accusantium eveniet ullam fugit illum natus eius.	2025-10-14	Officiis eaque amet voluptates provident similique.	2025-09-14	14:15	3	pending	APT11972	\N
10974	355	10	2025-09-14 14:30:00	High BP	New	Error consectetur repellendus doloremque consectetur esse reprehenderit.	2025-06-26 22:30:08	2025-06-26 22:30:08	127/88	77	99.1	97	63	Veritatis ipsa consequatur numquam.	Odit tempore quas odit veniam distinctio accusamus assumenda ratione aliquid.	2025-10-03	Magnam facere possimus quas consequuntur.	2025-09-14	14:30	3	pending	APT11973	\N
10975	395	6	2025-09-14 15:45:00	High BP	Follow-up	Laborum quibusdam quasi cumque hic.	2025-06-26 22:30:08	2025-06-26 22:30:08	109/84	95	99.3	97	77	Placeat earum sunt ducimus aperiam.	Laudantium quisquam laudantium temporibus iusto minus atque officiis nemo temporibus dolores.	2025-10-02	Enim quo doloremque deserunt iusto.	2025-09-14	15:45	3	pending	APT11974	\N
10976	349	3	2025-09-14 13:30:00	Skin Rash	Emergency	Provident ab id velit recusandae maxime quibusdam.	2025-06-26 22:30:08	2025-06-26 22:30:08	140/71	75	97.6	100	65	Voluptatum tenetur unde.	Facere inventore libero dignissimos veritatis ad ducimus cumque animi.	2025-09-23	Reiciendis mollitia labore nihil ducimus eos neque.	2025-09-14	13:30	3	pending	APT11975	\N
10977	373	6	2025-09-14 16:45:00	Headache	OPD	Aspernatur minus doloremque itaque.	2025-06-26 22:30:08	2025-06-26 22:30:08	138/65	81	100.2	99	62	Ratione sed sunt reprehenderit suscipit voluptatum.	Neque quibusdam veritatis recusandae cum.	2025-10-13	Laborum quos consequatur laboriosam.	2025-09-14	16:45	3	pending	APT11976	\N
10978	249	4	2025-09-14 12:15:00	Skin Rash	New	Cumque repudiandae iure quibusdam ea facilis.	2025-06-26 22:30:08	2025-06-26 22:30:08	113/89	75	97.7	99	79	Facere ducimus placeat nesciunt vero fuga.	Distinctio et quasi veniam in incidunt tempora.	2025-09-23	Maiores porro suscipit dolor vel ea enim vitae.	2025-09-14	12:15	3	pending	APT11977	\N
10979	215	10	2025-09-14 13:45:00	Skin Rash	Emergency	Est ea labore assumenda ipsam perferendis.	2025-06-26 22:30:08	2025-06-26 22:30:08	139/64	100	98.8	100	57	Sunt nam voluptatum nostrum ducimus placeat esse.	Ipsum libero dolores officiis voluptates dolor.	2025-10-02	Ea adipisci inventore officiis officia hic quisquam.	2025-09-14	13:45	3	pending	APT11978	\N
10980	291	3	2025-09-14 14:30:00	Routine Checkup	New	Non recusandae voluptatibus fugiat iusto.	2025-06-26 22:30:08	2025-06-26 22:30:08	104/63	66	99.4	95	69	Cum fuga ipsa modi non aperiam.	Laboriosam rem vero tempore labore.	2025-10-12	Assumenda necessitatibus enim architecto alias quibusdam.	2025-09-14	14:30	3	pending	APT11979	\N
10981	403	7	2025-09-14 15:45:00	Headache	New	Ullam veritatis fuga at dolorum assumenda fuga.	2025-06-26 22:30:08	2025-06-26 22:30:08	131/69	89	99.3	99	84	Officiis temporibus velit ipsam quod iste fugiat.	Exercitationem blanditiis quisquam cupiditate velit quas quidem.	2025-09-26	Quasi quasi iure quia iste.	2025-09-14	15:45	3	pending	APT11980	\N
10982	327	10	2025-09-14 12:00:00	Back Pain	OPD	Voluptatibus illum temporibus perferendis ipsa error distinctio.	2025-06-26 22:30:08	2025-06-26 22:30:08	101/81	88	98.2	95	78	Hic voluptas laudantium provident.	Est dolor odio animi quidem doloribus ducimus.	2025-10-08	Consectetur eligendi accusantium praesentium ab.	2025-09-14	12:00	3	pending	APT11981	\N
10983	346	9	2025-09-14 11:30:00	Cough	OPD	Odit quasi eum neque.	2025-06-26 22:30:08	2025-06-26 22:30:08	108/79	99	99.3	97	55	Animi deleniti omnis aliquid quaerat totam numquam.	Libero nihil fuga perferendis recusandae.	2025-10-06	Tempore explicabo laboriosam eum.	2025-09-14	11:30	3	pending	APT11982	\N
10984	86	9	2025-09-14 12:15:00	Routine Checkup	Emergency	Natus saepe quibusdam libero totam eveniet eos culpa.	2025-06-26 22:30:08	2025-06-26 22:30:08	126/67	96	98.9	97	74	Neque optio inventore facere nulla quam rerum.	Hic consectetur atque voluptatibus illo deleniti labore.	2025-10-13	Quas excepturi minus ut maxime natus voluptatibus.	2025-09-14	12:15	3	pending	APT11983	\N
10985	105	3	2025-09-14 13:30:00	High BP	Follow-up	Aliquam voluptates incidunt dicta cupiditate occaecati error consequatur.	2025-06-26 22:30:08	2025-06-26 22:30:08	119/78	80	97.7	96	74	Accusantium quia iste voluptas.	Accusamus atque repellat odit blanditiis.	2025-10-11	Ratione neque tempore.	2025-09-14	13:30	3	pending	APT11984	\N
10986	115	4	2025-09-14 14:45:00	Routine Checkup	Emergency	Ipsum modi corrupti est.	2025-06-26 22:30:08	2025-06-26 22:30:08	118/73	82	99.8	99	56	Esse tempore neque adipisci ipsum.	Accusamus veniam quos rem magnam tenetur officiis sed provident natus.	2025-10-09	Quod vel quia numquam aliquam sit.	2025-09-14	14:45	3	pending	APT11985	\N
10987	420	4	2025-09-14 11:45:00	Cough	New	Natus suscipit ut.	2025-06-26 22:30:08	2025-06-26 22:30:08	122/62	71	98.8	100	57	Sint quasi accusantium nam possimus voluptatum laudantium.	Praesentium esse dolore in aliquid dolorem repellendus eaque.	2025-09-22	Ad neque voluptas neque labore ipsam.	2025-09-14	11:45	3	pending	APT11986	\N
10988	194	3	2025-09-14 15:30:00	Diabetes Check	Follow-up	Ab ea provident saepe quia.	2025-06-26 22:30:08	2025-06-26 22:30:08	138/70	67	97.5	95	59	Alias qui repudiandae unde nulla quibusdam.	Quia minima consequatur eaque quasi architecto repudiandae facere inventore eveniet.	2025-09-27	Distinctio officiis dolores nostrum.	2025-09-14	15:30	3	pending	APT11987	\N
10989	198	5	2025-09-14 16:30:00	High BP	New	Quae corporis commodi ut.	2025-06-26 22:30:08	2025-06-26 22:30:08	106/60	74	98.7	100	70	Nam eveniet esse. Odit ratione expedita voluptate.	Saepe consequatur quos laboriosam labore delectus eveniet.	2025-10-01	Nisi omnis quisquam placeat.	2025-09-14	16:30	3	pending	APT11988	\N
10990	115	9	2025-09-14 11:45:00	High BP	Follow-up	Ex sequi qui tempore voluptates distinctio vitae.	2025-06-26 22:30:08	2025-06-26 22:30:08	101/77	82	99.7	95	76	Incidunt est consectetur quaerat.	Vel vel quae consequatur sunt eligendi nam expedita nesciunt.	2025-10-04	Quisquam suscipit hic facere.	2025-09-14	11:45	3	pending	APT11989	\N
10991	363	5	2025-09-14 15:15:00	Diabetes Check	Emergency	Laudantium numquam animi possimus possimus autem perferendis eligendi.	2025-06-26 22:30:08	2025-06-26 22:30:08	123/71	69	98.4	98	63	Officia unde nesciunt unde.	Quod nobis accusamus at pariatur ratione laboriosam.	2025-10-14	Dolorum occaecati deserunt qui.	2025-09-14	15:15	3	pending	APT11990	\N
10992	423	8	2025-09-15 14:30:00	Back Pain	New	Reiciendis temporibus illo ipsam sunt.	2025-06-26 22:30:08	2025-06-26 22:30:08	109/61	86	98.5	96	72	Possimus veritatis corporis quos officiis iste similique.	Minus itaque quis tempora beatae modi.	2025-10-12	Id mollitia illo nemo temporibus.	2025-09-15	14:30	3	pending	APT11991	\N
10993	224	4	2025-09-15 11:45:00	Headache	Follow-up	Quod incidunt inventore necessitatibus.	2025-06-26 22:30:08	2025-06-26 22:30:08	102/63	66	98.4	96	76	Doloribus at molestias fugiat atque.	Expedita laborum commodi fuga esse laboriosam.	2025-10-01	Esse molestias id.	2025-09-15	11:45	3	pending	APT11992	\N
10994	391	4	2025-09-15 13:15:00	Diabetes Check	Follow-up	Molestias nulla expedita a asperiores optio.	2025-06-26 22:30:08	2025-06-26 22:30:08	103/76	89	99.5	100	82	Ad consectetur quam dolores quas non.	Cupiditate architecto delectus nulla ipsa temporibus dolorum.	2025-10-15	Similique adipisci quas vel saepe illum.	2025-09-15	13:15	3	pending	APT11993	\N
10995	240	9	2025-09-15 16:15:00	High BP	OPD	Atque repellendus ipsum quo.	2025-06-26 22:30:08	2025-06-26 22:30:08	102/60	90	98.4	98	73	Et in nulla. Nemo dolores in.	Consequatur natus quaerat cum expedita voluptatem suscipit mollitia repudiandae.	2025-09-28	Voluptas aliquid tempore id.	2025-09-15	16:15	3	pending	APT11994	\N
10996	355	5	2025-09-15 14:15:00	Skin Rash	OPD	At accusamus dolorem quod perspiciatis non.	2025-06-26 22:30:08	2025-06-26 22:30:08	140/82	71	100.3	95	84	Sit officia cum recusandae eos.	Tenetur expedita voluptatum id ratione alias.	2025-10-06	Neque ducimus inventore ea.	2025-09-15	14:15	3	pending	APT11995	\N
10997	423	9	2025-09-15 12:45:00	Skin Rash	Follow-up	Exercitationem quisquam veniam enim nihil aliquid dolorum error.	2025-06-26 22:30:08	2025-06-26 22:30:08	113/90	84	100.0	99	66	Corrupti dolore nemo molestias.	Numquam aliquid consequatur sit dignissimos quibusdam id consequatur.	2025-10-13	Quasi repudiandae reprehenderit maiores.	2025-09-15	12:45	3	pending	APT11996	\N
10998	76	10	2025-09-15 14:00:00	Skin Rash	Emergency	Placeat atque sed odio.	2025-06-26 22:30:08	2025-06-26 22:30:08	101/77	90	99.5	99	67	Nihil pariatur consequatur.	Fugit voluptatum eius sit quaerat quasi animi.	2025-09-28	Assumenda recusandae assumenda ad esse eos dolorem.	2025-09-15	14:00	3	pending	APT11997	\N
10999	234	7	2025-09-15 15:00:00	Skin Rash	New	Ipsam sed sapiente rem distinctio.	2025-06-26 22:30:08	2025-06-26 22:30:08	110/84	94	100.5	100	66	Labore eum corrupti labore tenetur laudantium.	Temporibus et placeat itaque pariatur.	2025-09-28	Cupiditate aliquid exercitationem impedit quasi.	2025-09-15	15:00	3	pending	APT11998	\N
11000	308	4	2025-09-15 12:30:00	Headache	New	Alias illo eaque.	2025-06-26 22:30:08	2025-06-26 22:30:08	128/71	71	99.3	99	84	Delectus ad maxime perferendis.	Necessitatibus ipsam quos maxime quo mollitia.	2025-10-06	Dolorum reprehenderit illo pariatur dignissimos optio fuga soluta.	2025-09-15	12:30	3	pending	APT11999	\N
11001	414	10	2025-09-15 14:00:00	Headache	Follow-up	Error officiis mollitia alias.	2025-06-26 22:30:08	2025-06-26 22:30:08	128/88	83	100.3	100	65	Mollitia unde numquam praesentium deleniti minima.	Reprehenderit adipisci quod eveniet illum vel modi accusamus voluptatibus velit.	2025-10-14	Nesciunt rem veniam nulla voluptates.	2025-09-15	14:00	3	pending	APT12000	\N
11002	507	4	2025-07-03T10:30Z		Routine check-up	Patient experiencing frequent headaches and dizziness.	\N	2025-07-03 15:32:02.496323	120/80	65	98	99	78	Patient reports occasional nausea along with headaches.	\N	2025-05-15T00:00:00Z	Patient to follow up after a month or if symptoms worsen.	2025-07-03	10:30	3	completed	APT-20250703-001	\N
9228	455	3	2025-07-05 13:45:00	Diabetes Check	Routine check-up	Patient experiencing frequent headaches and dizziness.	2025-06-26 22:30:08	2025-07-05 18:25:40.061624	101/90	76	98.6	100	85	Omnis non architecto eveniet quo sapiente.	Minima voluptate expedita qui natus officiis velit magni fuga.	2025-07-13	Ut quaerat cum corrupti nam.	2025-07-05	13:45	3	completed	APT10227	\N
9235	289	3	2025-07-05 15:15:00	Skin Rash	Routine check-up	Patient experiencing frequent headaches and dizziness.	2025-06-26 22:30:08	2025-07-05 18:26:05.101293	135/67	92	97.7	99	79	Repudiandae natus consequuntur quod ab provident.	Distinctio iste aspernatur vel eveniet quidem occaecati.	2025-07-23	Tempora eveniet ex recusandae odit perspiciatis ullam nostrum.	2025-07-05	15:15	3	completed	APT10234	\N
\.


--
-- Data for Name: audit_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.audit_logs (id, table_name, record_id, action, "timestamp", user_id, old_data, new_data) FROM stdin;
1	hospitals	1	create	2025-06-17 14:02:27.685404	\N	\N	{"id": 1, "name": "Green Valley Medical Center", "registration_number": "GVMC-202506", "type": "Multispecialty", "logo_url": null, "website": "https://www.greenvalleymedical.com", "admin_id": null, "owner_name": "Dr. Meera Deshmukh", "admin_contact_number": "+91-9988776655", "number_of_beds": 150, "departments": ["Cardiology", "Neurology", "Orthopedics", "Pediatrics"], "specialties": ["Interventional Cardiology", "Neuro Surgery", "Joint Replacement"], "facilities": ["ICU", "MRI", "CT Scan", "Pharmacy", "24x7 Ambulance"], "ambulance_services": true, "opening_hours": {"Monday-Friday": "08:00-20:00", "Saturday": "09:00-17:00", "Sunday": "Emergency Only"}, "license_number": "MH-GVMC-2023-7865", "license_expiry_date": "2025-06-17", "is_accredited": true, "external_id": "GVMC001", "timezone": "Asia/Kolkata", "is_active": true, "city": null, "state": null, "country": null, "phone_number": null, "zipcode": null, "created_at": "2025-06-17 19:32:27.679133", "updated_at": "2025-06-17 19:32:27.679133"}
2	hospitals	2	create	2025-06-17 14:10:44.476898	\N	\N	{"id": 2, "name": "Green Valley Medical Center", "registration_number": "GVMC-202506", "type": "Multispecialty", "logo_url": null, "website": "https://www.greenvalleymedical.com", "admin_id": null, "owner_name": "Dr. Meera Deshmukh", "admin_contact_number": "+91-9988776655", "number_of_beds": 150, "departments": ["Cardiology", "Neurology", "Orthopedics", "Pediatrics"], "specialties": ["Interventional Cardiology", "Neuro Surgery", "Joint Replacement"], "facilities": ["ICU", "MRI", "CT Scan", "Pharmacy", "24x7 Ambulance"], "ambulance_services": true, "opening_hours": {"Monday-Friday": "08:00-20:00", "Saturday": "09:00-17:00", "Sunday": "Emergency Only"}, "license_number": "MH-GVMC-2023-7865", "license_expiry_date": "2025-06-17", "is_accredited": true, "external_id": "GVMC001", "timezone": "Asia/Kolkata", "is_active": true, "city": null, "state": null, "country": null, "phone_number": null, "zipcode": null, "created_at": "2025-06-17 19:40:44.474233", "updated_at": "2025-06-17 19:40:44.474233"}
3	hospitals	3	create	2025-06-17 14:21:02.855398	\N	\N	{"id": 3, "name": "Green Valley Medical Center", "registration_number": "GVMC-202506", "type": "Multispecialty", "address": "123 Greenway Road, Sector 21", "logo_url": null, "website": "https://www.greenvalleymedical.com", "admin_id": null, "owner_name": "Dr. Meera Deshmukh", "admin_contact_number": "+91-9988776655", "number_of_beds": 150, "departments": ["Cardiology", "Neurology", "Orthopedics", "Pediatrics"], "specialties": ["Interventional Cardiology", "Neuro Surgery", "Joint Replacement"], "facilities": ["ICU", "MRI", "CT Scan", "Pharmacy", "24x7 Ambulance"], "ambulance_services": true, "opening_hours": {"Monday-Friday": "08:00-20:00", "Saturday": "09:00-17:00", "Sunday": "Emergency Only"}, "license_number": "MH-GVMC-2023-7865", "license_expiry_date": "2025-06-17", "is_accredited": true, "external_id": "GVMC001", "timezone": "Asia/Kolkata", "is_active": true, "city": "Pune", "state": "Maharashtra", "country": "India", "phone_number": "+91-9876543210", "zipcode": "411045", "created_at": "2025-06-17 19:51:02.848850", "updated_at": "2025-06-17 19:51:02.848850"}
4	hospital_permissions	1	create	2025-06-17 14:21:51.240509	\N	\N	{"id": 1, "hospital_id": 3, "permission_id": 1}
5	hospital_permissions	2	create	2025-06-17 14:21:51.240543	\N	\N	{"id": 2, "hospital_id": 3, "permission_id": 2}
6	hospital_permissions	3	create	2025-06-17 14:21:51.240559	\N	\N	{"id": 3, "hospital_id": 3, "permission_id": 3}
7	hospital_permissions	4	create	2025-06-17 14:22:53.393495	\N	\N	{"id": 4, "hospital_id": 3, "permission_id": 1}
8	hospital_permissions	5	create	2025-06-17 14:22:53.394215	\N	\N	{"id": 5, "hospital_id": 3, "permission_id": 2}
9	hospital_permissions	6	create	2025-06-17 14:22:53.394247	\N	\N	{"id": 6, "hospital_id": 3, "permission_id": 3}
10	hospital_permissions	7	create	2025-06-17 14:23:51.077429	\N	\N	{"id": 7, "hospital_id": 3, "permission_id": 1}
11	hospital_permissions	8	create	2025-06-17 14:23:51.078043	\N	\N	{"id": 8, "hospital_id": 3, "permission_id": 2}
12	hospital_permissions	9	create	2025-06-17 14:23:51.078073	\N	\N	{"id": 9, "hospital_id": 3, "permission_id": 3}
13	hospital_permissions	10	create	2025-06-17 14:30:49.343389	\N	\N	{"id": 10, "hospital_id": 3, "permission_id": 1}
14	hospital_permissions	11	create	2025-06-17 14:30:49.343897	\N	\N	{"id": 11, "hospital_id": 3, "permission_id": 2}
15	hospital_permissions	12	create	2025-06-17 14:30:49.343944	\N	\N	{"id": 12, "hospital_id": 3, "permission_id": 3}
16	users	3	create	2025-06-17 14:34:07.859551	\N	\N	{"id": 3, "first_name": "Dr. Meera", "last_name": "Deshmukh", "gender": "Male", "email": "meera.deshmukh@example.com", "phone_number": "+918460559170", "password": "12345", "role_id": 9, "hospital_id": 3}
17	hospital_payments	1	create	2025-06-17 14:45:53.825308	\N	\N	{"id": 1, "hospital_id": 3, "date": "2025-06-18", "amount": 1900.0, "payment_method": "Cash", "reference": "re", "status": "Completed", "paid": true, "remarks": "12"}
18	patients	2	create	2025-06-17 14:51:19.142901	\N	\N	{"id": 2, "first_name": "Rahul", "middle_name": "Kumar", "last_name": "Verma", "date_of_birth": "1990-04-15", "gender": "Male", "phone_number": "+91-9876543210", "landline": "020-25478965", "address": "Flat 203, Shree Residency, MG Road", "landmark": "Near City Park", "city": "Nagpur", "state": "Maharashtra", "country": "India", "blood_group": "B+", "email": "rahul.verma90@example.com", "occupation": "Software Engineer", "is_dialysis_patient": false, "zipcode": "440010", "marital_status": "Married", "patient_unique_id": "GVMC-PAT-20240611-001", "hospital_id": 3}
19	permissions	5	create	2025-06-17 15:42:36.829117	\N	\N	{"id": 5, "name": "IPD Management", "description": "Manage Patient Addmissions", "amount": null}
20	hospital_permissions	13	create	2025-06-17 15:42:47.463073	\N	\N	{"id": 13, "hospital_id": 3, "permission_id": 1}
21	hospital_permissions	14	create	2025-06-17 15:42:47.463153	\N	\N	{"id": 14, "hospital_id": 3, "permission_id": 2}
22	hospital_permissions	15	create	2025-06-17 15:42:47.463187	\N	\N	{"id": 15, "hospital_id": 3, "permission_id": 3}
23	hospital_permissions	16	create	2025-06-17 15:42:47.463218	\N	\N	{"id": 16, "hospital_id": 3, "permission_id": 5}
24	permissions	6	create	2025-06-17 15:45:04.82813	\N	\N	{"id": 6, "name": "Staff Management", "description": "Manage Staffs", "amount": null}
25	hospital_permissions	17	create	2025-06-17 15:46:03.281325	\N	\N	{"id": 17, "hospital_id": 3, "permission_id": 1}
26	hospital_permissions	18	create	2025-06-17 15:46:03.281468	\N	\N	{"id": 18, "hospital_id": 3, "permission_id": 2}
27	hospital_permissions	19	create	2025-06-17 15:46:03.281511	\N	\N	{"id": 19, "hospital_id": 3, "permission_id": 3}
28	hospital_permissions	20	create	2025-06-17 15:46:03.281557	\N	\N	{"id": 20, "hospital_id": 3, "permission_id": 5}
29	hospital_permissions	21	create	2025-06-17 15:46:03.281599	\N	\N	{"id": 21, "hospital_id": 3, "permission_id": 6}
52	hospital_permissions	28	create	2025-06-27 16:34:19.947145	\N	\N	{"id": 28, "hospital_id": 3, "permission_id": 1}
53	hospital_permissions	29	create	2025-06-27 16:34:19.94724	\N	\N	{"id": 29, "hospital_id": 3, "permission_id": 2}
54	hospital_permissions	30	create	2025-06-27 16:34:19.947268	\N	\N	{"id": 30, "hospital_id": 3, "permission_id": 3}
55	hospital_permissions	31	create	2025-06-27 16:34:19.94729	\N	\N	{"id": 31, "hospital_id": 3, "permission_id": 4}
30	hospitals	3	update	2025-06-19 04:35:06.867883	\N	{"id": 3, "name": "Green Valley Medical Center", "registration_number": "GVMC-202506", "type": "Multispecialty", "address": "123 Greenway Road, Sector 21", "logo_url": null, "website": "https://www.greenvalleymedical.com", "admin_id": null, "owner_name": "Dr. Meera Deshmukh", "admin_contact_number": "+91-9988776655", "number_of_beds": 150, "departments": ["Cardiology", "Neurology", "Orthopedics", "Pediatrics"], "specialties": ["Interventional Cardiology", "Neuro Surgery", "Joint Replacement"], "facilities": ["ICU", "MRI", "CT Scan", "Pharmacy", "24x7 Ambulance"], "ambulance_services": true, "opening_hours": {"Sunday": "Emergency Only", "Saturday": "09:00-17:00", "Monday-Friday": "08:00-20:00"}, "license_number": "MH-GVMC-2023-7865", "license_expiry_date": "2025-06-17", "is_accredited": true, "external_id": "GVMC001", "timezone": "Asia/Kolkata", "is_active": true, "city": "Pune", "state": "Maharashtra", "country": "India", "phone_number": "+91-9876543210", "zipcode": "411045", "created_at": "2025-06-17 19:51:02.848850", "updated_at": "2025-06-19 10:05:06.855377"}	{"id": 3, "name": "Green Valley Center", "registration_number": "GVMC-202506", "type": "Multispecialty", "address": "123 Greenway Road, Sector 21", "logo_url": null, "website": "https://www.greenvalleymedical.com", "admin_id": null, "owner_name": "Dr. Meera Deshmukh", "admin_contact_number": "+91-9988776655", "number_of_beds": 150, "departments": ["Cardiology", "Neurology", "Orthopedics", "Pediatrics"], "specialties": ["Interventional Cardiology", "Neuro Surgery", "Joint Replacement"], "facilities": ["ICU", "MRI", "CT Scan", "Pharmacy", "24x7 Ambulance"], "ambulance_services": true, "opening_hours": {"Sunday": "Emergency Only", "Saturday": "09:00-17:00", "Monday-Friday": "08:00-20:00"}, "license_number": "MH-GVMC-2023-7865", "license_expiry_date": "2025-06-17", "is_accredited": true, "external_id": "GVMC001", "timezone": "Asia/Kolkata", "is_active": true, "city": "Pune", "state": "Maharashtra", "country": "India", "phone_number": "+91-9876543210", "zipcode": "411045", "created_at": "2025-06-17 19:51:02.848850", "updated_at": "2025-06-19 10:05:06.855377"}
31	users	4	create	2025-06-22 05:35:39.096937	\N	\N	{"id": 4, "first_name": "Mukesh", "last_name": "Ramanuja", "gender": null, "email": "mukesh@hospitease.com", "phone_number": null, "password": "12345", "role_id": 8, "hospital_id": null}
32	doctors	3	create	2025-06-22 05:40:07.927468	\N	\N	{"id": 3, "first_name": "Mukesh", "last_name": "Ramanuja", "specialization": "", "phone_number": "", "email": "mukesh@hospitease.com", "experience": 12, "is_active": true, "title": "", "gender": "", "date_of_birth": "2025-06-27", "blood_group": "", "mobile_number": "08460559170", "emergency_contact": "", "address": "Tragad", "city": "", "state": "California", "country": "India", "zipcode": "123123", "medical_licence_number": "", "licence_authority": "", "license_expiry_date": "2025-06-29", "hospital_id": 3, "user_id": 4}
33	appointments	1	create	2025-06-22 05:40:39.413996	\N	\N	{"id": 1, "patient_id": 2, "doctor_id": 3, "appointment_datetime": "2025-06-23T13:15Z", "problem": null, "appointment_type": "regular", "reason": null, "created_at": null, "updated_at": null, "hospital_id": 3, "blood_pressure": null, "pulse_rate": null, "temperature": null, "spo2": null, "weight": null, "additional_notes": null, "advice": null, "follow_up_date": null, "follow_up_notes": null, "appointment_date": "2025-06-23", "appointment_time": "13:15", "status": "pending", "appointment_unique_id": "APT-20250622-001"}
34	doctors	3	update	2025-06-23 08:56:59.260073	\N	{"id": 3, "first_name": "Mukesh", "last_name": "Ramanuja", "specialization": "", "phone_number": "", "email": "mukesh@hospitease.com", "experience": 12, "is_active": true, "title": "", "gender": "", "date_of_birth": "2025-06-27", "blood_group": "", "mobile_number": "08460559170", "emergency_contact": "", "address": "Tragad", "city": "", "state": "California", "country": "India", "zipcode": "123123", "medical_licence_number": "", "licence_authority": "", "license_expiry_date": "2025-06-29", "hospital_id": 3, "user_id": 4}	{"id": 3, "first_name": "Mukesh", "last_name": "Ramanuju", "specialization": "", "phone_number": "", "email": "mukesh@hospitease.com", "experience": 12, "is_active": true, "title": "", "gender": "", "date_of_birth": "2025-06-27", "blood_group": "", "mobile_number": "08460559170", "emergency_contact": "", "address": "Tragad", "city": "", "state": "California", "country": "India", "zipcode": "123123", "medical_licence_number": "", "licence_authority": "", "license_expiry_date": "2025-06-29", "hospital_id": 3, "user_id": 4}
35	appointments	2	create	2025-06-25 07:42:13.777791	\N	\N	{"id": 2, "patient_id": 2, "doctor_id": 3, "appointment_datetime": "2025-06-25T13:15Z", "problem": null, "appointment_type": "regular", "reason": null, "created_at": null, "updated_at": null, "hospital_id": 3, "blood_pressure": null, "pulse_rate": null, "temperature": null, "spo2": null, "weight": null, "additional_notes": null, "advice": null, "follow_up_date": null, "follow_up_notes": null, "appointment_date": "2025-06-25", "appointment_time": "13:15", "status": "pending", "appointment_unique_id": "APT-20250625-001"}
36	medicines	1	create	2025-06-26 06:33:36.456203	\N	\N	{"id": 1, "appointment_id": 2, "name": "Doulo Paracetamol", "dosage": "As prescribed", "frequency": "Twice a day", "duration": "Two days", "start_date": "", "status": "Prescribed", "time_interval": "Morning and Evening", "route": "Oral", "quantity": "", "instruction": "Take with hot water"}
37	medicines	2	create	2025-06-26 06:33:36.473833	\N	\N	{"id": 2, "appointment_id": 2, "name": "Aspirin", "dosage": "As prescribed", "frequency": "Twice a day", "duration": "Two days", "start_date": "", "status": "Prescribed", "time_interval": "Morning and Evening", "route": "Oral", "quantity": "", "instruction": "Take with hot water"}
38	tests	1	create	2025-06-26 06:33:36.493076	\N	\N	{"id": 1, "appointment_id": 2, "test_details": "ECG", "status": "pending", "cost": 0.0, "description": "", "doctor_notes": "", "staff_notes": "", "test_date": "", "test_done_date": ""}
39	tests	2	create	2025-06-26 06:33:36.502201	\N	\N	{"id": 2, "appointment_id": 2, "test_details": "CBC", "status": "pending", "cost": 0.0, "description": "", "doctor_notes": "", "staff_notes": "", "test_date": "", "test_done_date": ""}
40	medicines	3	create	2025-06-26 06:44:57.231363	\N	\N	{"id": 3, "appointment_id": 2, "name": "Paracetamol", "dosage": "2 tablets", "frequency": "Twice a day", "duration": "Next two days", "start_date": "As soon as possible", "status": "Prescribed", "time_interval": "Every 12 hours", "route": "Oral", "quantity": "4 tablets", "instruction": "Take after meals"}
41	medicines	4	create	2025-06-26 06:44:57.245496	\N	\N	{"id": 4, "appointment_id": 2, "name": "Aspirin", "dosage": "2 tablets", "frequency": "Twice a day", "duration": "Next two days", "start_date": "As soon as possible", "status": "Prescribed", "time_interval": "Every 12 hours", "route": "Oral", "quantity": "4 tablets", "instruction": "Take after meals"}
42	tests	3	create	2025-06-26 06:44:57.263434	\N	\N	{"id": 3, "appointment_id": 2, "test_details": "Malaria Test", "status": "pending", "cost": 0.0, "description": "", "doctor_notes": "To be done as soon as possible", "staff_notes": "", "test_date": "", "test_done_date": ""}
43	tests	4	create	2025-06-26 06:44:57.270047	\N	\N	{"id": 4, "appointment_id": 2, "test_details": "CBC Test", "status": "pending", "cost": 0.0, "description": "", "doctor_notes": "To be done as soon as possible", "staff_notes": "", "test_date": "", "test_done_date": ""}
44	tests	5	create	2025-06-26 06:44:57.275341	\N	\N	{"id": 5, "appointment_id": 2, "test_details": "ECG", "status": "pending", "cost": 0.0, "description": "", "doctor_notes": "To be done as soon as possible", "staff_notes": "", "test_date": "", "test_done_date": ""}
45	hospital_permissions	22	create	2025-06-26 06:53:03.600157	\N	\N	{"id": 22, "hospital_id": 3, "permission_id": 1}
46	hospital_permissions	23	create	2025-06-26 06:53:03.600302	\N	\N	{"id": 23, "hospital_id": 3, "permission_id": 2}
47	hospital_permissions	24	create	2025-06-26 06:53:03.600345	\N	\N	{"id": 24, "hospital_id": 3, "permission_id": 3}
48	hospital_permissions	25	create	2025-06-26 06:53:03.60038	\N	\N	{"id": 25, "hospital_id": 3, "permission_id": 5}
49	hospital_permissions	26	create	2025-06-26 06:53:03.600414	\N	\N	{"id": 26, "hospital_id": 3, "permission_id": 6}
50	hospital_permissions	27	create	2025-06-26 06:53:03.600445	\N	\N	{"id": 27, "hospital_id": 3, "permission_id": 4}
51	permissions	7	create	2025-06-27 16:33:57.320027	\N	\N	{"id": 7, "name": "Staffs", "description": "Manage staffs roles & shifts", "amount": 1900.0}
56	hospital_permissions	32	create	2025-06-27 16:34:19.947308	\N	\N	{"id": 32, "hospital_id": 3, "permission_id": 5}
57	hospital_permissions	33	create	2025-06-27 16:34:19.947325	\N	\N	{"id": 33, "hospital_id": 3, "permission_id": 6}
58	hospital_permissions	34	create	2025-06-27 16:34:19.947341	\N	\N	{"id": 34, "hospital_id": 3, "permission_id": 7}
59	roles	14	create	2025-06-27 18:14:29.514282	\N	\N	{"id": 14, "name": "Staff"}
60	users	5	create	2025-06-27 18:14:36.238649	\N	\N	{"id": 5, "first_name": "Priya", "last_name": "Sharma", "gender": null, "email": "priya.sharma@example.com", "phone_number": null, "password": "12345", "role_id": 14, "hospital_id": null}
61	staff	1	create	2025-06-27 18:15:07.265743	\N	\N	{"id": 1, "hospital_id": 3, "user_id": 5, "first_name": "Priya", "last_name": "Sharma", "title": "Dr.", "gender": "Female", "date_of_birth": "1985-04-15", "phone_number": "9812345678", "email": "priya.sharma@example.com", "role": "Gynecologist", "department": "Obstetrics & Gynecology", "specialization": "High-risk Pregnancy", "qualification": "MBBS, MS (OBG)", "experience": 10, "joining_date": "2023-11-01", "is_active": true, "address": "25, Nehru Nagar, Sector 9", "city": "Delhi", "state": "Delhi", "country": "India", "zipcode": "110045", "emergency_contact": "9811122233", "photo_url": "https://example.com/images/priya_sharma.jpg", "created_at": null, "updated_at": null}
62	bed_types	1	create	2025-06-27 18:23:32.975342	\N	\N	{"id": 1, "name": "string", "description": "string", "amount": 0.0, "charge_type": "string"}
63	wards	1	create	2025-06-27 18:26:39.751951	\N	\N	{"id": 1, "name": "string", "description": "string", "floor": "string", "total_beds": 0, "available_beds": 0, "is_active": true, "hospital_id": 3}
64	beds	1	create	2025-06-27 18:30:39.80789	\N	\N	{"id": 1, "name": "string", "bed_type_id": 1, "ward_id": 1, "status": "available", "features": "string", "equipment": "string", "is_active": true, "notes": "string"}
65	admissions	2	create	2025-06-27 18:38:40.164591	\N	\N	{"id": 2, "patient_id": 4, "appointment_id": 9002, "doctor_id": 4, "admission_date": "2025-06-27", "reason": "string", "status": "admitted", "bed_id": 1, "discharge_date": "2025-06-27", "critical_care_required": false, "care_24x7_required": false, "notes": "string", "created_at": "2025-06-27 18:38:40.156765+00:00", "updated_at": "2025-06-27 18:38:40.156765+00:00"}
66	nursing_notes	2	create	2025-06-27 19:04:01.072676	\N	\N	{"id": 2, "admission_id": 2, "note": "string", "date": "2025-06-27", "added_by": "string", "role": "string"}
67	roles	15	create	2025-06-29 06:06:39.294903	\N	\N	{"id": 15, "name": "Nurse"}
68	users	6	create	2025-06-29 06:09:34.042618	\N	\N	{"id": 6, "first_name": "Lorum", "last_name": "David", "gender": null, "email": "lorum@gmail.com", "phone_number": null, "password": "12345", "role_id": 14, "hospital_id": null}
69	staff	2	create	2025-06-29 06:09:34.070632	\N	\N	{"id": 2, "hospital_id": 3, "user_id": 6, "first_name": "Lorum", "last_name": "David", "title": "Dr.", "gender": "Female", "date_of_birth": "2025-06-08", "phone_number": "84605591701", "email": "lorum@gmail.com", "role": "Nurse", "department": "Front Desk", "specialization": "Only Cash check", "qualification": "B.A.", "experience": 12, "joining_date": "2025-06-16", "is_active": true, "address": "SG Highwar Ahmedabad", "city": "Ahmedabad", "state": "Gujarat", "country": "India", "zipcode": "382470", "emergency_contact": "8888888888", "photo_url": "", "created_at": null, "updated_at": null}
70	bed_types	2	create	2025-06-29 06:38:02.644943	\N	\N	{"id": 2, "name": "General Beds", "description": "General beds for regular patients", "amount": 1900.0, "charge_type": "Per Day"}
71	beds	2	create	2025-06-29 06:49:13.66861	\N	\N	{"id": 2, "name": "Lorum Ipsum David", "bed_type_id": 2, "ward_id": 1, "status": "available", "features": "ac,wifi,curtains,table", "equipment": "oxygen", "is_active": true, "notes": ""}
72	admissions	3	create	2025-06-29 14:56:46.534718	\N	\N	{"id": 3, "patient_id": 2, "appointment_id": 9954, "doctor_id": 7, "hospital_id": 3, "admission_date": "2025-06-30", "reason": "", "status": "admitted", "bed_id": 2, "discharge_date": "2025-07-01", "critical_care_required": true, "care_24x7_required": true, "notes": "", "created_at": "2025-06-29 14:56:46.519512+00:00", "updated_at": "2025-06-29 14:56:46.519512+00:00"}
73	admissions	4	create	2025-06-29 14:58:10.128064	\N	\N	{"id": 4, "patient_id": 2, "appointment_id": 9577, "doctor_id": 9, "hospital_id": 3, "admission_date": "2025-06-16", "reason": "", "status": "admitted", "bed_id": 2, "discharge_date": "2025-07-02", "critical_care_required": true, "care_24x7_required": true, "notes": "", "created_at": "2025-06-29 14:58:10.123000+00:00", "updated_at": "2025-06-29 14:58:10.123000+00:00"}
74	admission_vitals	1	create	2025-06-29 15:12:07.338275	\N	\N	{"id": 1, "admission_id": 3, "temperature": 98.6, "pulse": 72, "blood_pressure": "120/80", "spo2": 98, "notes": "All good", "recorded_at": "2025-07-02 15:11:00", "captured_by": "Reshmi Nurse"}
75	admission_medicines	1	create	2025-06-29 15:16:54.563861	\N	\N	{"id": 1, "admission_id": 3, "medicine_name": "asdfs", "dosage": "asd", "frequency": "asd", "duration": "asd", "route": "asd", "status": "Active", "prescribed_by": "asd", "prescribed_on": "2025-06-29", "prescribed_till": "2025-06-13", "notes": null}
76	admission_tests	1	create	2025-06-29 15:20:45.877755	\N	\N	{"id": 1, "admission_id": 3, "test_name": "sad", "status": "Pending", "cost": 5.0, "description": "asd", "doctor_notes": "asd", "staff_notes": "asd", "test_date": "2025-07-02", "test_done_date": "2025-07-01", "suggested_by": "sad", "performed_by": "sd", "report_urls": null}
77	nursing_notes	3	create	2025-06-29 15:22:27.209007	\N	\N	{"id": 3, "admission_id": 3, "note": "asd", "date": "2025-07-01", "added_by": "asd", "role": "Nurse"}
78	admission_diets	1	create	2025-06-29 15:33:08.133906	\N	\N	{"id": 1, "admission_id": 3, "diet_type": "asdad", "is_veg": true, "allergies": ["as"], "meals": [{"name": "Breakfast", "time": "08:00", "items": ["ass"], "notes": "as"}, {"name": "Lunch", "time": "13:00", "items": ["as"], "notes": "df"}, {"name": "Dinner", "time": "19:00", "items": ["asdasd"], "notes": "asd"}], "notes": "dfghn", "created_at": "2025-06-29 15:33:08.010696+00:00", "updated_at": "2025-06-29 15:33:08.010696+00:00"}
79	admission_discharges	1	create	2025-06-29 17:21:00.530529	\N	\N	{"id": 1, "admission_id": 2, "discharge_date": "2025-06-29 17:18:00", "discharge_type": "Normal", "summary": "clinical report", "follow_up_date": "2025-07-04", "follow_up_instructions": "Date", "attending_doctor": "Dr. (Ms.) Imaran Pandey", "checklist": {"doctor_clearance": true, "billing_clearance": true, "pharmacy_clearance": true, "nursing_clearance": true, "final_approval": true, "time_logging": true, "summary": true, "final_bill": true, "medication_prescription": true, "followup_instructions": true, "consent_forms": true, "test_reports": true, "clearance_slips": true}, "created_at": "2025-06-29 22:51:00.521757", "updated_at": "2025-06-29 22:51:00.521757"}
80	admissions	5	create	2025-06-30 17:13:39.618453	\N	\N	{"id": 5, "patient_id": 2, "appointment_id": 10190, "doctor_id": 9, "hospital_id": 3, "admission_date": "2025-07-01", "reason": "Ferv & vomit", "status": "admitted", "bed_id": 1, "discharge_date": "2025-07-05", "critical_care_required": true, "care_24x7_required": true, "notes": "", "created_at": "2025-06-30 17:13:39.599304+00:00", "updated_at": "2025-06-30 17:13:39.599304+00:00"}
81	admission_discharges	2	create	2025-06-30 17:17:55.283558	\N	\N	{"id": 2, "admission_id": 2, "discharge_date": "2025-06-30 17:15:00", "discharge_type": "Transfer", "summary": "", "follow_up_date": "2025-07-02", "follow_up_instructions": "as", "attending_doctor": "Dr. (Ms.) Imaran Pandey", "checklist": {"doctor_clearance": false, "billing_clearance": false, "pharmacy_clearance": false, "nursing_clearance": false, "final_approval": false, "time_logging": false, "summary": false, "final_bill": false, "medication_prescription": false, "followup_instructions": false, "consent_forms": false, "test_reports": false, "clearance_slips": false}, "created_at": "2025-06-30 22:47:55.275796", "updated_at": "2025-06-30 22:47:55.275796"}
82	patients	504	create	2025-07-02 08:54:11.957028	\N	\N	{"id": 504, "first_name": "Ravi", "middle_name": "Kumar", "last_name": "Sharma", "date_of_birth": "1996-04-23", "gender": "Male", "phone_number": "9876543210", "landline": "01123456789", "address": "123, Sector 21", "landmark": "Near City Hospital", "city": "New Delhi", "state": "Delhi", "country": "India", "blood_group": "B+", "email": "ravi.sharma@example.com", "occupation": "Engineer", "is_dialysis_patient": false, "zipcode": "110075", "marital_status": "Married", "patient_unique_id": "10501", "mrd_number": 316825299915778, "hospital_id": 3}
83	patients	507	create	2025-07-02 08:56:30.842408	\N	\N	{"id": 507, "first_name": "Ravi", "middle_name": "Kumar", "last_name": "Sharma", "date_of_birth": "1996-04-23", "gender": "Male", "phone_number": "9876543211", "landline": "01123456789", "address": "123, Sector 21", "landmark": "Near City Hospital", "city": "New Delhi", "state": "Delhi", "country": "India", "blood_group": "B+", "email": "ravi.sharma+1@example.com", "occupation": "Engineer", "is_dialysis_patient": false, "zipcode": "110075", "marital_status": "Married", "patient_unique_id": "10502", "mrd_number": 353024548920776, "hospital_id": 3}
84	appointments	11002	create	2025-07-03 10:01:11.037421	\N	\N	{"id": 11002, "patient_id": 507, "doctor_id": 4, "appointment_datetime": "2025-07-03T10:30Z", "problem": null, "appointment_type": "regular", "reason": null, "created_at": null, "updated_at": null, "hospital_id": 3, "blood_pressure": null, "pulse_rate": null, "temperature": null, "spo2": null, "weight": null, "additional_notes": null, "advice": null, "follow_up_date": null, "follow_up_notes": null, "appointment_date": "2025-07-03", "appointment_time": "10:30", "status": "pending", "appointment_unique_id": "APT-20250703-001"}
85	appointments	11002	update	2025-07-03 10:02:02.620484	\N	{"id": 11002, "patient_id": 507, "doctor_id": 4, "appointment_datetime": "2025-07-03T10:30Z", "problem": null, "appointment_type": "regular", "reason": null, "created_at": null, "updated_at": null, "hospital_id": 3, "blood_pressure": null, "pulse_rate": null, "temperature": null, "spo2": null, "weight": null, "additional_notes": null, "advice": null, "follow_up_date": null, "follow_up_notes": null, "appointment_date": "2025-07-03", "appointment_time": "10:30", "status": "pending", "appointment_unique_id": "APT-20250703-001"}	{"id": 11002, "patient_id": 507, "doctor_id": 4, "appointment_datetime": "2025-07-03T10:30Z", "problem": "", "appointment_type": "Routine check-up", "reason": "Patient experiencing frequent headaches and dizziness.", "created_at": null, "updated_at": null, "hospital_id": 3, "blood_pressure": "120/80", "pulse_rate": "65", "temperature": "98", "spo2": "99", "weight": "78", "additional_notes": "Patient reports occasional nausea along with headaches.", "advice": null, "follow_up_date": "2025-05-15T00:00:00Z", "follow_up_notes": "Patient to follow up after a month or if symptoms worsen.", "appointment_date": "2025-07-03", "appointment_time": "10:30", "status": "completed", "appointment_unique_id": "APT-20250703-001"}
86	patients	507	update	2025-07-03 10:54:10.913476	\N	{"id": 507, "first_name": "Ravi", "middle_name": "Kumar", "last_name": "Sharma", "date_of_birth": "1996-04-23", "gender": "Male", "phone_number": "9876543211", "landline": "01123456789", "address": "123, Sector 21", "landmark": "Near City Hospital", "city": "New Delhi", "state": "Delhi", "country": "India", "blood_group": "B+", "email": "ravi.sharma+1@example.com", "occupation": "Engineer", "is_dialysis_patient": false, "zipcode": "110075", "marital_status": "Married", "patient_unique_id": "10502", "mrd_number": 353024548920776, "hospital_id": 3}	{"id": 507, "first_name": "Ravi", "middle_name": "Kumar", "last_name": "Sharma", "date_of_birth": "1996-04-23", "gender": "Male", "phone_number": "9876543211", "landline": "01123456789", "address": "123, Sector 21 Delhi", "landmark": "Near City Hospital", "city": "Mumbai", "state": "Delhi", "country": "India", "blood_group": "B+", "email": "ravi.sharma+1@example.com", "occupation": "Engineer", "is_dialysis_patient": false, "zipcode": "110075", "marital_status": "Married", "patient_unique_id": "10502", "mrd_number": 353024548920776, "hospital_id": 3}
87	patients	507	update	2025-07-03 10:54:44.113647	\N	{"id": 507, "first_name": "Ravi", "middle_name": "Kumar", "last_name": "Sharma", "date_of_birth": "1996-04-23", "gender": "Male", "phone_number": "9876543211", "landline": "01123456789", "address": "123, Sector 21 Delhi", "landmark": "Near City Hospital", "city": "Mumbai", "state": "Delhi", "country": "India", "blood_group": "B+", "email": "ravi.sharma+1@example.com", "occupation": "Engineer", "is_dialysis_patient": false, "zipcode": "110075", "marital_status": "Married", "patient_unique_id": "10502", "mrd_number": 353024548920776, "hospital_id": 3}	{"id": 507, "first_name": "Ravi", "middle_name": "Kumar", "last_name": "Sharma", "date_of_birth": "1996-04-23", "gender": "Male", "phone_number": "9876543211", "landline": "01123456789", "address": "123, Sector 21", "landmark": "Near City Hospital", "city": "Mumbai", "state": "Delhi", "country": "India", "blood_group": "B+", "email": "ravi.sharma+1@example.com", "occupation": "Engineer", "is_dialysis_patient": false, "zipcode": "110075", "marital_status": "Married", "patient_unique_id": "10502", "mrd_number": 353024548920776, "hospital_id": 3}
88	appointments	11003	create	2025-07-03 11:39:42.800132	\N	\N	{"id": 11003, "patient_id": 507, "doctor_id": 4, "appointment_datetime": "2025-07-04T11:00:00", "problem": "Fever & vomit", "appointment_type": "Rotuine", "reason": "-", "created_at": null, "updated_at": null, "hospital_id": 3, "blood_pressure": null, "pulse_rate": null, "temperature": null, "spo2": null, "weight": null, "additional_notes": null, "advice": null, "follow_up_date": null, "follow_up_notes": null, "appointment_date": "2025-07-04", "appointment_time": "11:00", "status": "scheduled", "appointment_unique_id": "APT-20250703-002"}
89	appointments	11004	create	2025-07-03 15:35:22.453245	\N	\N	{"id": 11004, "patient_id": 507, "doctor_id": 4, "appointment_datetime": "2025-07-05T12:30:00", "problem": "Severe fever & vomit", "appointment_type": "followup", "reason": "Having severe body ache & stuffness ", "created_at": null, "updated_at": null, "hospital_id": 3, "blood_pressure": null, "pulse_rate": null, "temperature": null, "spo2": null, "weight": null, "additional_notes": null, "advice": null, "follow_up_date": null, "follow_up_notes": null, "appointment_date": "2025-07-05", "appointment_time": "12:30", "status": "scheduled", "appointment_unique_id": "APT-20250703-003", "mode_of_appointment": null}
90	appointments	11005	create	2025-07-03 15:38:27.689965	\N	\N	{"id": 11005, "patient_id": 507, "doctor_id": 4, "appointment_datetime": "2025-07-06T12:00:00", "problem": "S", "appointment_type": "procedure", "reason": "S", "created_at": null, "updated_at": null, "hospital_id": 3, "blood_pressure": null, "pulse_rate": null, "temperature": null, "spo2": null, "weight": null, "additional_notes": null, "advice": null, "follow_up_date": null, "follow_up_notes": null, "appointment_date": "2025-07-06", "appointment_time": "12:00", "status": "scheduled", "appointment_unique_id": "APT-20250703-004", "mode_of_appointment": "video"}
91	appointments	11006	create	2025-07-03 18:23:40.755234	\N	\N	{"id": 11006, "patient_id": 2, "doctor_id": 3, "appointment_datetime": "2025-07-15T13:55Z", "problem": null, "appointment_type": "followup", "reason": null, "created_at": null, "updated_at": null, "hospital_id": 3, "blood_pressure": null, "pulse_rate": null, "temperature": null, "spo2": null, "weight": null, "additional_notes": null, "advice": null, "follow_up_date": null, "follow_up_notes": null, "appointment_date": "2025-07-15", "appointment_time": "13:55", "status": "pending", "appointment_unique_id": "APT-20250703-005", "mode_of_appointment": null}
92	admissions	6	create	2025-07-03 18:26:31.873531	\N	\N	{"id": 6, "patient_id": 2, "appointment_id": 11006, "doctor_id": 3, "hospital_id": 3, "admission_date": "2025-07-04", "reason": "very severe back ache.", "status": "admitted", "bed_id": 2, "discharge_date": "2025-07-15", "critical_care_required": false, "care_24x7_required": true, "notes": "", "created_at": "2025-07-03 18:26:31.860032+00:00", "updated_at": "2025-07-03 18:26:31.860032+00:00"}
93	appointments	11007	create	2025-07-05 09:21:02.099768	\N	\N	{"id": 11007, "patient_id": 2, "doctor_id": 3, "appointment_datetime": "2025-07-05T11:30Z", "problem": null, "appointment_type": "emergency", "reason": null, "created_at": null, "updated_at": null, "hospital_id": 3, "blood_pressure": null, "pulse_rate": null, "temperature": null, "spo2": null, "weight": null, "additional_notes": null, "advice": null, "follow_up_date": null, "follow_up_notes": null, "appointment_date": "2025-07-05", "appointment_time": "11:30", "status": "pending", "appointment_unique_id": "APT-20250705-001", "mode_of_appointment": null}
94	appointments	11008	create	2025-07-05 09:21:32.717979	\N	\N	{"id": 11008, "patient_id": 2, "doctor_id": 3, "appointment_datetime": "2025-07-05T11:45Z", "problem": null, "appointment_type": "regular", "reason": null, "created_at": null, "updated_at": null, "hospital_id": 3, "blood_pressure": null, "pulse_rate": null, "temperature": null, "spo2": null, "weight": null, "additional_notes": null, "advice": null, "follow_up_date": null, "follow_up_notes": null, "appointment_date": "2025-07-05", "appointment_time": "11:45", "status": "pending", "appointment_unique_id": "APT-20250705-002", "mode_of_appointment": null}
95	medicines	5	create	2025-07-05 09:25:13.707542	\N	\N	{"id": 5, "appointment_id": 9228, "name": "Paracetamol", "dosage": "500mg", "frequency": "Every 6 hours", "duration": "2 days", "start_date": "Not specified", "status": "Prescribed", "time_interval": "Not specified", "route": "Oral", "quantity": "Not specified", "instruction": "Take with food"}
96	medicines	6	create	2025-07-05 09:25:13.720313	\N	\N	{"id": 6, "appointment_id": 9228, "name": "Dolo", "dosage": "650mg", "frequency": "Every 8 hours", "duration": "3 days", "start_date": "After completion of Paracetamol", "status": "Prescribed", "time_interval": "Not specified", "route": "Oral", "quantity": "Not specified", "instruction": "Take with food"}
97	tests	6	create	2025-07-05 09:25:13.732626	\N	\N	{"id": 6, "appointment_id": 9228, "test_details": "Not specified", "status": "pending", "cost": 0.0, "description": "", "doctor_notes": "Not specified", "staff_notes": "", "test_date": "", "test_done_date": ""}
98	medicines	7	create	2025-07-05 09:26:11.303702	\N	\N	{"id": 7, "appointment_id": 9228, "name": "Asprine", "dosage": "10", "frequency": "Once daily", "duration": "10", "start_date": "2025-07-05", "status": "Active", "time_interval": "after_breakfast,before_lunch,after_lunch", "route": "Oral", "quantity": "10", "instruction": "Daily with hot water"}
99	patients	508	create	2025-07-05 09:41:06.57039	\N	\N	{"id": 508, "first_name": "Rahul", "middle_name": "", "last_name": "Verma", "date_of_birth": "2025-07-08", "gender": "Male", "phone_number": "8908908899", "landline": "", "address": "Ahmedabad-Vadodara Expressway", "landmark": "", "city": "AHMEDABAD", "state": "Gujarat", "country": "India", "blood_group": "A-", "email": "kapil23jani@gmail.com", "occupation": "", "is_dialysis_patient": false, "zipcode": "390061", "marital_status": null, "patient_unique_id": "10503", "mrd_number": 944943575336234, "hospital_id": 3}
100	appointments	11009	create	2025-07-05 09:47:41.356414	\N	\N	{"id": 11009, "patient_id": 507, "doctor_id": 4, "appointment_datetime": "2025-07-06T12:30:00", "problem": "Ferve", "appointment_type": "emergency", "reason": "feve", "created_at": null, "updated_at": null, "hospital_id": 3, "blood_pressure": null, "pulse_rate": null, "temperature": null, "spo2": null, "weight": null, "additional_notes": null, "advice": null, "follow_up_date": null, "follow_up_notes": null, "appointment_date": "2025-07-06", "appointment_time": "12:30", "status": "scheduled", "appointment_unique_id": "APT-20250705-003", "mode_of_appointment": "offline"}
101	patients	509	create	2025-07-05 10:02:46.906377	\N	\N	{"id": 509, "first_name": "xgch", "middle_name": "sdfag", "last_name": "sdf", "date_of_birth": "2025-07-14", "gender": "Female", "phone_number": "9999999999", "landline": "0000000000", "address": "Emergency Address", "landmark": "", "city": "N/A", "state": "N/A", "country": "N/A", "blood_group": "A+", "email": "emergency@dummy.com", "occupation": "", "is_dialysis_patient": false, "zipcode": "000000", "marital_status": null, "patient_unique_id": "10504", "mrd_number": 221540663739370, "hospital_id": 3}
102	medicines	8	create	2025-07-05 11:45:58.418463	\N	\N	{"id": 8, "appointment_id": 9240, "name": "aspirin 400 MG / caffeine 32 MG Oral Tablet [Anacin]", "dosage": "1", "frequency": "Once daily", "duration": "2", "start_date": "2025-07-05", "status": "Active", "time_interval": "before_lunch,after_lunch,before_dinner", "route": "Oral", "quantity": "3", "instruction": ""}
103	appointments	9228	update	2025-07-05 12:55:40.149025	\N	{"id": 9228, "patient_id": 455, "doctor_id": 3, "appointment_datetime": "2025-07-05 13:45:00", "problem": "Diabetes Check", "appointment_type": "Follow-up", "reason": "Libero nemo doloribus ab ea.", "created_at": "2025-06-26 22:30:08", "updated_at": "2025-06-26 22:30:08", "hospital_id": 3, "blood_pressure": "101/90", "pulse_rate": "76", "temperature": "98.6", "spo2": "100", "weight": "85", "additional_notes": "Omnis non architecto eveniet quo sapiente.", "advice": "Minima voluptate expedita qui natus officiis velit magni fuga.", "follow_up_date": "2025-07-13", "follow_up_notes": "Ut quaerat cum corrupti nam.", "appointment_date": "2025-07-05", "appointment_time": "13:45", "status": "pending", "appointment_unique_id": "APT10227", "mode_of_appointment": null}	{"id": 9228, "patient_id": 455, "doctor_id": 3, "appointment_datetime": "2025-07-05 13:45:00", "problem": "Diabetes Check", "appointment_type": "Routine check-up", "reason": "Patient experiencing frequent headaches and dizziness.", "created_at": "2025-06-26 22:30:08", "updated_at": "2025-06-26 22:30:08", "hospital_id": 3, "blood_pressure": "101/90", "pulse_rate": "76", "temperature": "98.6", "spo2": "100", "weight": "85", "additional_notes": "Omnis non architecto eveniet quo sapiente.", "advice": "Minima voluptate expedita qui natus officiis velit magni fuga.", "follow_up_date": "2025-07-13", "follow_up_notes": "Ut quaerat cum corrupti nam.", "appointment_date": "2025-07-05", "appointment_time": "13:45", "status": "completed", "appointment_unique_id": "APT10227", "mode_of_appointment": null}
104	appointments	9235	update	2025-07-05 12:56:05.121257	\N	{"id": 9235, "patient_id": 289, "doctor_id": 3, "appointment_datetime": "2025-07-05 15:15:00", "problem": "Skin Rash", "appointment_type": "Follow-up", "reason": "Soluta sint sint aut natus distinctio.", "created_at": "2025-06-26 22:30:08", "updated_at": "2025-06-26 22:30:08", "hospital_id": 3, "blood_pressure": "135/67", "pulse_rate": "92", "temperature": "97.7", "spo2": "99", "weight": "79", "additional_notes": "Repudiandae natus consequuntur quod ab provident.", "advice": "Distinctio iste aspernatur vel eveniet quidem occaecati.", "follow_up_date": "2025-07-23", "follow_up_notes": "Tempora eveniet ex recusandae odit perspiciatis ullam nostrum.", "appointment_date": "2025-07-05", "appointment_time": "15:15", "status": "pending", "appointment_unique_id": "APT10234", "mode_of_appointment": null}	{"id": 9235, "patient_id": 289, "doctor_id": 3, "appointment_datetime": "2025-07-05 15:15:00", "problem": "Skin Rash", "appointment_type": "Routine check-up", "reason": "Patient experiencing frequent headaches and dizziness.", "created_at": "2025-06-26 22:30:08", "updated_at": "2025-06-26 22:30:08", "hospital_id": 3, "blood_pressure": "135/67", "pulse_rate": "92", "temperature": "97.7", "spo2": "99", "weight": "79", "additional_notes": "Repudiandae natus consequuntur quod ab provident.", "advice": "Distinctio iste aspernatur vel eveniet quidem occaecati.", "follow_up_date": "2025-07-23", "follow_up_notes": "Tempora eveniet ex recusandae odit perspiciatis ullam nostrum.", "appointment_date": "2025-07-05", "appointment_time": "15:15", "status": "completed", "appointment_unique_id": "APT10234", "mode_of_appointment": null}
105	appointments	11010	create	2025-07-05 13:21:49.901907	\N	\N	{"id": 11010, "patient_id": 2, "doctor_id": 3, "appointment_datetime": "2025-06-30T10:00Z", "problem": null, "appointment_type": "regular", "reason": null, "created_at": null, "updated_at": null, "hospital_id": 3, "blood_pressure": null, "pulse_rate": null, "temperature": null, "spo2": null, "weight": null, "additional_notes": null, "advice": null, "follow_up_date": null, "follow_up_notes": null, "appointment_date": "2025-06-30", "appointment_time": "10:00", "status": "pending", "appointment_unique_id": "APT-20250705-004", "mode_of_appointment": null}
106	tests	7	create	2025-07-05 13:54:47.369347	\N	\N	{"id": 7, "appointment_id": 9027, "test_details": "Complete Blood Count (CBC)", "status": "Pending", "cost": 100.0, "description": "hj", "doctor_notes": "j", "staff_notes": "", "test_date": "", "test_done_date": null}
107	medicines	9	create	2025-07-06 04:22:24.535324	\N	\N	{"id": 9, "appointment_id": 9259, "name": "Dolo", "dosage": "As per the doctor's prescription", "frequency": "As per the doctor's prescription", "duration": "2 days", "start_date": "Not specified", "status": "Prescribed", "time_interval": "Not specified", "route": "Oral", "quantity": "Not specified", "instruction": "Take with hot water"}
108	medicines	10	create	2025-07-06 04:22:24.574543	\N	\N	{"id": 10, "appointment_id": 9259, "name": "Aspirin", "dosage": "As per the doctor's prescription", "frequency": "As per the doctor's prescription", "duration": "10 days", "start_date": "Not specified", "status": "Prescribed", "time_interval": "Not specified", "route": "Oral", "quantity": "Not specified", "instruction": "Not specified"}
109	medicines	11	create	2025-07-06 07:02:00.765874	\N	\N	{"id": 11, "appointment_id": 11008, "name": "ASPIRIN", "dosage": "10", "frequency": "Once daily", "duration": "2", "start_date": "2025-07-06", "status": "Prescribed", "time_interval": "after_breakfast,before_lunch,after_lunch,before_dinner", "route": "Oral", "quantity": "10", "instruction": ""}
110	patients	511	create	2025-07-06 17:54:23.232211	\N	\N	{"id": 511, "first_name": "Nilay", "middle_name": "", "last_name": "Jani", "date_of_birth": "2025-07-01", "gender": "Male", "phone_number": "9999999999", "landline": "0000000000", "address": "Emergency Address", "landmark": "", "city": "N/A", "state": "N/A", "country": "N/A", "blood_group": "A+", "email": "emergency@dummy.com", "occupation": "", "is_dialysis_patient": false, "zipcode": "000000", "marital_status": null, "patient_unique_id": "10505", "mrd_number": 501378915842904, "hospital_id": 3}
111	appointments	11011	create	2025-07-06 17:54:45.968019	\N	\N	{"id": 11011, "patient_id": 511, "doctor_id": 3, "appointment_datetime": "2025-07-09T14:00Z", "problem": null, "appointment_type": "regular", "reason": null, "created_at": null, "updated_at": null, "hospital_id": 3, "blood_pressure": null, "pulse_rate": null, "temperature": null, "spo2": null, "weight": null, "additional_notes": null, "advice": null, "follow_up_date": null, "follow_up_notes": null, "appointment_date": "2025-07-09", "appointment_time": "14:00", "status": "pending", "appointment_unique_id": "APT-20250706-001", "mode_of_appointment": null}
112	staff_responsibility_assignments	1	create	2025-07-07 13:11:24.725168	\N	\N	{"id": 1, "staff_id": 1, "responsibility_id": 1, "assigned_by": 3, "assigned_at": "2025-07-07 13:11:24.704219", "revoked_at": null, "revoked_by": null}
113	staff_responsibility_assignments	2	create	2025-07-07 13:12:20.898915	\N	\N	{"id": 2, "staff_id": 1, "responsibility_id": 1, "assigned_by": 3, "assigned_at": "2025-07-07 13:12:20.893253", "revoked_at": null, "revoked_by": null}
114	staff_responsibility_assignments	3	create	2025-07-07 13:25:39.013468	\N	\N	{"id": 3, "staff_id": 1, "responsibility_id": 1, "assigned_by": 3, "assigned_at": "2025-07-07 13:25:38.997123", "revoked_at": null, "revoked_by": null}
115	staff_responsibility_assignments	4	create	2025-07-07 13:26:10.791163	\N	\N	{"id": 4, "staff_id": 1, "responsibility_id": 1, "assigned_by": 3, "assigned_at": "2025-07-07 13:26:10.788461", "revoked_at": null, "revoked_by": null}
116	staff_responsibility_assignments	5	create	2025-07-07 13:26:41.51385	\N	\N	{"id": 5, "staff_id": 1, "responsibility_id": 2, "assigned_by": 3, "assigned_at": "2025-07-07 13:26:41.505949", "revoked_at": null, "revoked_by": null}
117	staff_responsibility_assignments	6	create	2025-07-07 13:26:41.526366	\N	\N	{"id": 6, "staff_id": 1, "responsibility_id": 5, "assigned_by": 3, "assigned_at": "2025-07-07 13:26:41.524921", "revoked_at": null, "revoked_by": null}
118	staff_responsibility_assignments	7	create	2025-07-07 13:26:41.534175	\N	\N	{"id": 7, "staff_id": 1, "responsibility_id": 6, "assigned_by": 3, "assigned_at": "2025-07-07 13:26:41.533332", "revoked_at": null, "revoked_by": null}
120	staff_responsibility_assignments	9	create	2025-07-07 13:26:41.547664	\N	\N	{"id": 9, "staff_id": 1, "responsibility_id": 3, "assigned_by": 3, "assigned_at": "2025-07-07 13:26:41.546766", "revoked_at": null, "revoked_by": null}
119	staff_responsibility_assignments	8	create	2025-07-07 13:26:41.541885	\N	\N	{"id": 8, "staff_id": 1, "responsibility_id": 4, "assigned_by": 3, "assigned_at": "2025-07-07 13:26:41.540864", "revoked_at": null, "revoked_by": null}
121	staff_responsibility_assignments	7	update	2025-07-07 13:34:05.135935	\N	{"id": 7, "staff_id": 1, "responsibility_id": 6, "assigned_by": 3, "assigned_at": "2025-07-07 13:26:41.533332", "revoked_at": null, "revoked_by": null}	{"id": 7, "staff_id": 1, "responsibility_id": 6, "assigned_by": 3, "assigned_at": "2025-07-07 13:26:41.533332", "revoked_at": "2025-07-07 13:34:05.128114", "revoked_by": 3}
122	staff_responsibility_assignments	7	update	2025-07-07 13:35:10.186109	\N	{"id": 7, "staff_id": 1, "responsibility_id": 6, "assigned_by": 3, "assigned_at": "2025-07-07 13:26:41.533332", "revoked_at": "2025-07-07 13:34:05.128114", "revoked_by": 3}	{"id": 7, "staff_id": 1, "responsibility_id": 6, "assigned_by": 3, "assigned_at": "2025-07-07 13:26:41.533332", "revoked_at": "2025-07-07 13:35:10.183356", "revoked_by": 3}
123	staff_responsibility_assignments	7	update	2025-07-07 13:35:12.252574	\N	{"id": 7, "staff_id": 1, "responsibility_id": 6, "assigned_by": 3, "assigned_at": "2025-07-07 13:26:41.533332", "revoked_at": "2025-07-07 13:35:10.183356", "revoked_by": 3}	{"id": 7, "staff_id": 1, "responsibility_id": 6, "assigned_by": 3, "assigned_at": "2025-07-07 13:26:41.533332", "revoked_at": "2025-07-07 13:35:12.251178", "revoked_by": 3}
124	staff_responsibility_assignments	6	update	2025-07-07 13:35:14.172788	\N	{"id": 6, "staff_id": 1, "responsibility_id": 5, "assigned_by": 3, "assigned_at": "2025-07-07 13:26:41.524921", "revoked_at": null, "revoked_by": null}	{"id": 6, "staff_id": 1, "responsibility_id": 5, "assigned_by": 3, "assigned_at": "2025-07-07 13:26:41.524921", "revoked_at": "2025-07-07 13:35:14.168572", "revoked_by": 3}
125	staff_responsibility_assignments	10	create	2025-07-07 13:41:34.591701	\N	\N	{"id": 10, "staff_id": 1, "responsibility_id": 4, "assigned_by": 3, "assigned_at": "2025-07-07 13:41:34.577258", "revoked_at": null, "revoked_by": null}
126	staff_responsibility_assignments	11	create	2025-07-07 13:41:34.609484	\N	\N	{"id": 11, "staff_id": 1, "responsibility_id": 3, "assigned_by": 3, "assigned_at": "2025-07-07 13:41:34.606929", "revoked_at": null, "revoked_by": null}
127	staff_responsibility_assignments	12	create	2025-07-07 13:41:34.61497	\N	\N	{"id": 12, "staff_id": 1, "responsibility_id": 2, "assigned_by": 3, "assigned_at": "2025-07-07 13:41:34.614277", "revoked_at": null, "revoked_by": null}
128	staff_responsibility_assignments	13	create	2025-07-07 13:43:33.441052	\N	\N	{"id": 13, "staff_id": 1, "responsibility_id": 5, "assigned_by": 3, "assigned_at": "2025-07-07 13:43:33.437944", "revoked_at": null, "revoked_by": null}
129	staff_responsibility_assignments	14	create	2025-07-07 16:42:15.917824	\N	\N	{"id": 14, "staff_id": 1, "responsibility_id": 4, "assigned_by": 3, "assigned_at": "2025-07-07 16:42:15.807306", "revoked_at": null, "revoked_by": null}
130	staff_responsibility_assignments	15	create	2025-07-07 16:42:15.938568	\N	\N	{"id": 15, "staff_id": 1, "responsibility_id": 5, "assigned_by": 3, "assigned_at": "2025-07-07 16:42:15.930942", "revoked_at": null, "revoked_by": null}
\.


--
-- Data for Name: bed_types; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bed_types (id, name, description, amount, charge_type) FROM stdin;
2	General Beds	General beds for regular patients	1900	Per Day
1	string	string	1000	Per Hour
\.


--
-- Data for Name: beds; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.beds (id, name, bed_type_id, ward_id, status, features, equipment, is_active, notes) FROM stdin;
2	B102	2	1	available	ac,wifi,curtains,table,bathroom,patient_monitor	oxygen	t	
1	B101	2	1	available	string,bathroom,telephone	string,ventilator	t	string
\.


--
-- Data for Name: chat_messages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.chat_messages (id, sender_id, receiver_id, message, sent_at, seen_by_sender, seen_by_receiver, doc_url) FROM stdin;
7cb8a2ce-8241-4d0f-8c46-4fdd0e0560bc	511	4	Hello Doctor	2025-07-07 08:08:54.349408	t	t	\N
b484dc33-d126-457a-88f8-0f14f9e17068	511	4	Please see attached report	2025-07-07 08:09:06.987548	t	t	/uploads/abf81764-a26d-4a4e-bd90-48add3771805.png
19ebc432-95a9-4865-8e4c-0c08f1f93a07	4	511	Ok I will review.	2025-07-07 08:09:48.257222	t	f	\N
\.


--
-- Data for Name: credit_ledgers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.credit_ledgers (credit_id, invoice_id, due_date, amount_due, amount_paid, status, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: doctors; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.doctors (id, first_name, last_name, specialization, phone_number, email, experience, is_active, hospital_id, title, gender, date_of_birth, blood_group, mobile_number, emergency_contact, address, city, state, country, zipcode, medical_licence_number, licence_authority, license_expiry_date, user_id) FROM stdin;
3	Mukesh	Ramanuju			mukesh@hospitease.com	12	t	3			2025-06-27		08460559170		Tragad		California	India	123123			2025-06-29	4
4	Imaran	Pandey	Gynecology	8959197111	imaran.pandey0@hospital.com	17	t	3	Dr. (Ms.)	Male	1985-04-06	O-	8959197111	9683574635	79, Naidu Zila\nGhaziabad-250639	Tirunelveli	Kerala	India	582150	MED19134IND	Medical Council of India	2027-12-27	\N
5	Xalak	Dave	Orthopedics	9183523750	xalak.dave1@hospital.com	12	t	3	Dr. (Ms.)	Female	1978-02-09	AB-	9183523750	4903099515	H.No. 38, Gaba Street\nBharatpur 084271	Kishanganj	Tripura	India	145436	MED61688IND	Medical Council of India	2026-07-06	\N
6	Bachittar	Sengupta	Neurology	9141015050	bachittar.sengupta2@hospital.com	14	t	3	Dr.	Male	1969-05-06	AB-	9141015050	9105483820	55/958\nPanchal Circle\nGudivada-716541	Raiganj	Sikkim	India	081493	MED48232IND	Medical Council of India	2026-09-21	\N
7	Benjamin	Agate	Neurology	9106394344	benjamin.agate3@hospital.com	27	t	3	Dr. (Ms.)	Male	1976-04-12	A-	9106394344	9185248480	H.No. 83\nGarde Path\nMau 721227	Karnal	Manipur	India	201908	MED81809IND	Medical Council of India	2028-06-16	\N
8	Timothy	Malhotra	Cardiology	8937790223	timothy.malhotra4@hospital.com	21	t	3	Prof.	Male	1982-12-17	B-	8937790223	0736290492	944\nKale, Tadipatri 437655	Thane	Kerala	India	767143	MED62061IND	Medical Council of India	2029-08-02	\N
9	Fiyaz	Dewan	Gynecology	3604136344	fiyaz.dewan5@hospital.com	35	t	3	Dr.	Male	1964-01-29	B+	3604136344	5168068598	05/56, Om Nagar\nVijayawada 108000	Nanded	Odisha	India	977308	MED13128IND	Medical Council of India	2028-01-29	\N
10	Arya	Shanker	Pediatrics	0758656910	arya.shanker6@hospital.com	13	t	3	Prof.	Female	1983-10-31	B+	0758656910	0037584300	H.No. 98, Khatri Road, Madhyamgram-997677	Darbhanga	Mizoram	India	483786	MED50318IND	Medical Council of India	2027-08-28	\N
11	Frado	Gala	General Medicine	9192553784	frado.gala7@hospital.com	24	t	3	Dr. (Ms.)	Male	1991-04-16	A+	9192553784	0192363381	41/65, Dada\nHyderabad-048409	Bhalswa Jahangir Pur	West Bengal	India	607267	MED13755IND	Medical Council of India	2029-11-05	\N
12	Hema	Gill	Cardiology	0929616922	hema.gill8@hospital.com	34	t	3	Dr.	Female	1992-04-01	A-	0929616922	9114209552	H.No. 082, Chatterjee Chowk\nMuzaffarnagar 659347	Chinsurah	Uttar Pradesh	India	940146	MED92435IND	Medical Council of India	2029-12-07	\N
13	Neel	Krish	Orthopedics	9192962404	neel.krish9@hospital.com	11	t	3	Dr. (Ms.)	Male	1972-11-02	O+	9192962404	9182094202	H.No. 799, Bera Path\nMachilipatnam-188326	Anand	Punjab	India	019694	MED33078IND	Medical Council of India	2029-12-20	\N
14	Alexander	Bath	Radiology	8239230253	alexander.bath10@hospital.com	2	t	3	Dr. (Ms.)	Male	1959-10-03	AB-	8239230253	9192195951	H.No. 022, Kulkarni Ganj, Begusarai-962588	Rampur	Bihar	India	010929	MED43517IND	Medical Council of India	2029-10-10	\N
15	Chaaya	Walia	General Medicine	2535366904	chaaya.walia11@hospital.com	31	t	3	Dr.	Female	1980-01-02	AB+	2535366904	9144886685	417, Vora Ganj, Mahbubnagar 987575	Phagwara	Assam	India	068061	MED78989IND	Medical Council of India	2028-09-02	\N
16	Omisha	Chauhan	Pediatrics	0331868891	omisha.chauhan12@hospital.com	7	t	3	Dr.	Female	1977-05-17	O-	0331868891	9198374951	84/431\nNarula Path, Sasaram 413772	Sambhal	Sikkim	India	780617	MED27105IND	Medical Council of India	2026-09-22	\N
17	Jairaj	Wason	Gynecology	9152728632	jairaj.wason13@hospital.com	5	t	3	Dr.	Male	1986-07-20	A+	9152728632	9123525907	H.No. 16, Patil Ganj\nPanvel-394536	Medininagar	Meghalaya	India	368139	MED28429IND	Medical Council of India	2027-12-15	\N
18	Chaitanya	Gala	Orthopedics	0620308265	chaitanya.gala14@hospital.com	16	t	3	Dr. (Ms.)	Male	1990-08-24	O-	0620308265	7798121352	H.No. 077\nRaghavan Ganj\nKharagpur 801288	Sangli-Miraj & Kupwad	Telangana	India	783936	MED80478IND	Medical Council of India	2027-01-11	\N
19	Hredhaan	Kara	Orthopedics	0124478561	hredhaan.kara15@hospital.com	19	t	3	Dr.	Male	1982-03-11	O+	0124478561	9115063036	56\nOommen Marg\nKhammam 885587	Anantapur	Goa	India	038993	MED78247IND	Medical Council of India	2030-06-07	\N
20	Joshua	Kata	Pediatrics	4905329968	joshua.kata16@hospital.com	9	t	3	Prof.	Male	1972-11-18	B-	4905329968	4104255235	H.No. 024, Shenoy Nagar, Bhubaneswar-863780	Mehsana	Uttar Pradesh	India	460464	MED55584IND	Medical Council of India	2029-06-01	\N
21	Girish	Chauhan	Cardiology	9545646899	girish.chauhan17@hospital.com	1	t	3	Dr.	Male	1992-01-22	A+	9545646899	0544882592	99/69\nJain Zila, Nandyal-911692	Ludhiana	Manipur	India	361344	MED39898IND	Medical Council of India	2029-09-10	\N
22	Kritika	Acharya	ENT	0405650368	kritika.acharya18@hospital.com	8	t	3	Dr. (Ms.)	Female	1992-12-19	O-	0405650368	2498557483	H.No. 403\nBava Road\nMiryalaguda 254601	Bally	Tripura	India	282129	MED33469IND	Medical Council of India	2027-03-07	\N
23	Advik	Baria	Pediatrics	0114266726	advik.baria19@hospital.com	29	t	3	Dr.	Male	1962-01-12	O-	0114266726	9153050394	61, Parmar Chowk\nLucknow 371089	Parbhani	Chhattisgarh	India	554596	MED45524IND	Medical Council of India	2026-10-20	\N
\.


--
-- Data for Name: documents; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.documents (id, document_name, document_type, upload_date, size, status, documentable_id, documentable_type) FROM stdin;
\.


--
-- Data for Name: encounters; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.encounters (encounter_id, patient_id, encounter_date, type, status, admission_date, discharge_date, notes, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: family_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.family_history (id, appointment_id, relationship_to_you, additional_notes) FROM stdin;
\.


--
-- Data for Name: health_info; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.health_info (id, appointment_id, known_allergies, reaction_severity, reaction_description, dietary_habits, physical_activity_level, sleep_avg_hours, sleep_quality, substance_use_smoking, substance_use_alcohol, stress_level) FROM stdin;
\.


--
-- Data for Name: hospital_payments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.hospital_payments (id, hospital_id, date, amount, payment_method, reference, status, paid, remarks) FROM stdin;
1	3	2025-06-18	1900.00	Cash	re	Completed	t	12
\.


--
-- Data for Name: hospital_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.hospital_permissions (id, hospital_id, permission_id) FROM stdin;
28	3	1
29	3	2
30	3	3
31	3	4
32	3	5
33	3	6
34	3	7
\.


--
-- Data for Name: hospitals; Type: TABLE DATA; Schema: public; Owner: hospitease_admin
--

COPY public.hospitals (id, name, address, city, state, country, phone_number, email, admin_id, registration_number, type, logo_url, website, owner_name, admin_contact_number, number_of_beds, departments, specialties, facilities, ambulance_services, opening_hours, license_number, license_expiry_date, is_accredited, external_id, timezone, is_active, created_at, updated_at, zipcode) FROM stdin;
3	Green Valley Center	123 Greenway Road, Sector 21	Pune	Maharashtra	India	+91-9876543210	\N	\N	GVMC-202506	Multispecialty	\N	https://www.greenvalleymedical.com	Dr. Meera Deshmukh	+91-9988776655	150	{Cardiology,Neurology,Orthopedics,Pediatrics}	{"Interventional Cardiology","Neuro Surgery","Joint Replacement"}	{ICU,MRI,"CT Scan",Pharmacy,"24x7 Ambulance"}	t	{"Sunday": "Emergency Only", "Saturday": "09:00-17:00", "Monday-Friday": "08:00-20:00"}	MH-GVMC-2023-7865	2025-06-17	t	GVMC001	Asia/Kolkata	t	2025-06-17 19:51:02.84885	2025-06-19 10:05:06.855377	411045
\.


--
-- Data for Name: insurance_claims; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.insurance_claims (claim_id, encounter_id, insurance_id, claim_number, preauth_number, status, submitted_at, approved_at, rejected_at, amount_claimed, amount_approved, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: insurance_providers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.insurance_providers (insurance_id, name, type, api_endpoint, contact_info, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: invoices; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.invoices (invoice_id, encounter_id, total_amount, paid_amount, balance, status, credit_allowed, due_date, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.items (item_id, name, category, description, price, is_taxable, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: medical_histories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.medical_histories (id, condition, diagnosis_date, treatment, doctor, hospital, status, patient_id) FROM stdin;
\.


--
-- Data for Name: medicines; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.medicines (id, appointment_id, name, dosage, frequency, duration, start_date, status, time_interval, route, quantity, instruction) FROM stdin;
5	9228	Paracetamol	500mg	Every 6 hours	2 days	Not specified	Prescribed	Not specified	Oral	Not specified	Take with food
6	9228	Dolo	650mg	Every 8 hours	3 days	After completion of Paracetamol	Prescribed	Not specified	Oral	Not specified	Take with food
7	9228	Asprine	10	Once daily	10	2025-07-05	Active	after_breakfast,before_lunch,after_lunch	Oral	10	Daily with hot water
8	9240	aspirin 400 MG / caffeine 32 MG Oral Tablet [Anacin]	1	Once daily	2	2025-07-05	Active	before_lunch,after_lunch,before_dinner	Oral	3	
9	9259	Dolo	As per the doctor's prescription	As per the doctor's prescription	2 days	Not specified	Prescribed	Not specified	Oral	Not specified	Take with hot water
10	9259	Aspirin	As per the doctor's prescription	As per the doctor's prescription	10 days	Not specified	Prescribed	Not specified	Oral	Not specified	Not specified
11	11008	ASPIRIN	10	Once daily	2	2025-07-06	Prescribed	after_breakfast,before_lunch,after_lunch,before_dinner	Oral	10	
\.


--
-- Data for Name: nursing_notes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.nursing_notes (id, admission_id, note, date, added_by, role) FROM stdin;
2	2	string	2025-06-27	string	string
3	3	asd	2025-07-01	asd	Nurse
\.


--
-- Data for Name: patients; Type: TABLE DATA; Schema: public; Owner: hospitease_admin
--

COPY public.patients (id, first_name, middle_name, last_name, date_of_birth, gender, phone_number, landline, address, landmark, city, state, country, blood_group, email, occupation, is_dialysis_patient, hospital_id, marital_status, zipcode, patient_unique_id, mrd_number) FROM stdin;
2	Rahul	Kumar	Verma	1990-04-15	Male	+91-9876543210	020-25478965	Flat 203, Shree Residency, MG Road	Near City Park	Nagpur	Maharashtra	India	B+	rahul.verma90@example.com	Software Engineer	f	3	Married	440010	GVMC-PAT-20240611-001	\N
3	Geetika	Nidhi	Virk	1937-06-02	Male	0121199426		44/36, Kala Path	voluptas	Ulhasnagar	Odisha	India	AB-	geetika.virk0@example.com	Teacher	f	3	Married	997909	10001	\N
4	Dev		Sundaram	1986-04-17	Female	0267142068	04918111784	902, Dua Circle	ut	Mango	Punjab	India	AB-	dev.sundaram1@example.com	Engineer	f	3	Widowed	869785	10002	\N
5	Arya	Girish	Dada	2001-02-22	Male	0306566983	5568319668	30/83\nBedi Circle	eveniet	Sambhal	Madhya Pradesh	India	B-	arya.dada2@example.com	Engineer	t	3	Married	069214	10003	\N
6	Aditya		Dalal	1995-04-07	Male	6534065884		140, Bains Ganj	porro	Kottayam	Odisha	India	A-	aditya.dalal3@example.com	Teacher	f	3	Single	379144	10004	\N
7	Zansi		Jani	1993-04-28	Female	0208940347	4683705165	83/70\nGandhi Road	incidunt	Moradabad	Telangana	India	O+	zansi.jani4@example.com	Teacher	f	3	Married	623740	10005	\N
8	Dakshesh		Goda	1962-05-21	Female	1704195835	7247490864	H.No. 84\nSanghvi Zila	veniam	Begusarai	Manipur	India	AB+	dakshesh.goda5@example.com	Farmer	t	3	Widowed	688516	10006	\N
9	Suhani		Ghosh	2000-10-09	Female	0985343697	01878919078	72, Patla Nagar	natus	Bharatpur	Haryana	India	B-	suhani.ghosh6@example.com	Farmer	f	3	Single	101239	10007	\N
10	Jacob	Gautam	Kaul	1983-06-11	Other	4869738641		10, Merchant Path	placeat	Jehanabad	Punjab	India	B-	jacob.kaul7@example.com	Farmer	t	3	Married	845659	10008	\N
11	Rohan	Wakeeta	Anand	1982-09-08	Other	0663636531	1909029111	930, Nayar Street	eius	Sultan Pur Majra	Gujarat	India	A-	rohan.anand8@example.com	Teacher	f	3	Single	256899	10009	\N
12	Nidhi		Sen	1936-07-26	Male	9174489098	+913650474575	841\nSastry Path	quasi	Bangalore	Chhattisgarh	India	AB-	nidhi.sen9@example.com	Engineer	t	3	Widowed	733507	10010	\N
13	Vinaya	Tanay	Grover	1995-09-21	Female	0599518846		63/56, Raman Ganj	harum	Bhimavaram	Rajasthan	India	O-	vinaya.grover10@example.com	Engineer	t	3	Married	192481	10011	\N
14	Watika		Chopra	1959-01-30	Female	6370976930	08039182503	70\nSawhney Ganj	voluptatem	Dindigul	Jharkhand	India	A-	watika.chopra11@example.com	Teacher	t	3	Single	336184	10012	\N
15	Prisha	Yashvi	Basak	1949-09-01	Female	9192744593	5724965863	98, Narula Ganj	dolores	Raichur	Sikkim	India	A-	prisha.basak12@example.com	Retired	f	3	Married	884946	10013	\N
16	Yauvani		Iyer	1943-01-21	Female	4211518583	00889428776	248\nGara	velit	Dibrugarh	Manipur	India	AB-	yauvani.iyer13@example.com	Farmer	t	3	Married	762480	10014	\N
17	Pratyush		Bir	1938-05-30	Female	8745746351	+919846532570	H.No. 942\nChowdhury Path	perspiciatis	Jehanabad	Madhya Pradesh	India	A-	pratyush.bir14@example.com	Student	f	3	Single	979105	10015	\N
18	Baghyawati	Vidhi	Mohanty	1987-11-06	Male	9128286440		748, Palla Ganj	debitis	Thoothukudi	Kerala	India	AB+	baghyawati.mohanty15@example.com	Retired	t	3	Single	737230	10016	\N
19	Damini		Mane	1938-06-11	Male	0740494457	05459090793	91/62, Mitra Chowk	aperiam	Hindupur	Madhya Pradesh	India	B+	damini.mane16@example.com	Student	f	3	Single	508031	10017	\N
20	Atharv	Eesha	Mall	1936-05-22	Other	2061441623	1668251662	H.No. 63\nKanda Path	perferendis	Thoothukudi	Jharkhand	India	O-	atharv.mall17@example.com	Engineer	f	3	Married	125366	10018	\N
21	Saumya		Sawhney	1985-09-20	Female	4080943118	+910354740740	08/655\nKade Chowk	eligendi	Vasai-Virar	Manipur	India	O-	saumya.sawhney18@example.com	Engineer	t	3	Single	326280	10019	\N
22	Varsha		Rege	1995-04-11	Female	0050482811		H.No. 65\nArya Street	autem	Bijapur	Chhattisgarh	India	A-	varsha.rege19@example.com	Doctor	t	3	Widowed	006071	10020	\N
23	Deepa		Hari	1943-06-24	Male	9143161885		H.No. 645\nDugar Marg	cum	Kolhapur	Maharashtra	India	A-	deepa.hari20@example.com	Retired	t	3	Widowed	787103	10021	\N
24	Tanmayi		Bera	1957-09-30	Other	1564750296		50/04, Som	quasi	Khandwa	Himachal Pradesh	India	AB-	tanmayi.bera21@example.com	Farmer	f	3	Single	489250	10022	\N
25	Garima		Dara	1991-11-18	Male	9129118263	+911406020981	425\nDeep Nagar	delectus	Hosur	Arunachal Pradesh	India	O+	garima.dara22@example.com	Doctor	f	3	Single	727240	10023	\N
26	Aishani	Pranit	Sani	1955-12-18	Female	0704126994	1204080628	38\nNagar Street	eaque	Nagercoil	Goa	India	O+	aishani.sani23@example.com	Teacher	f	3	Widowed	917700	10024	\N
27	Rudra	Sanya	Dugal	2002-01-29	Female	9143858080		H.No. 513\nChoudhary Ganj	reprehenderit	Mangalore	Uttar Pradesh	India	A-	rudra.dugal24@example.com	Retired	f	3	Widowed	358407	10025	\N
28	Udant		De	1936-09-17	Other	0021748909	9690777486	24/07, Kadakia Marg	similique	Sagar	Nagaland	India	O-	udant.de25@example.com	Engineer	t	3	Married	851256	10026	\N
29	Tamanna	Zashil	Gaba	1996-11-27	Male	5120618795		56, Basu Nagar	sint	Kavali	Nagaland	India	O+	tamanna.gaba26@example.com	Farmer	f	3	Married	694147	10027	\N
30	Ria		Oza	1943-06-30	Male	9105362876		33/337, Morar Marg	quaerat	Thane	Punjab	India	A+	ria.oza27@example.com	Farmer	t	3	Single	073527	10028	\N
31	Tanmayi		Din	2006-06-07	Male	0932534436		H.No. 578, Suri Road	aliquam	Vasai-Virar	Arunachal Pradesh	India	B+	tanmayi.din28@example.com	Engineer	t	3	Married	754895	10029	\N
32	Ojas	Logan	Sama	1970-04-09	Male	5611062877	+914054269685	H.No. 85\nOza	corporis	Ozhukarai	West Bengal	India	AB-	ojas.sama29@example.com	Doctor	t	3	Single	831255	10030	\N
33	Oeshi		Dayal	1965-06-30	Female	9100777832	9759682253	H.No. 747\nMagar Zila	reprehenderit	Mehsana	Rajasthan	India	O-	oeshi.dayal30@example.com	Engineer	f	3	Married	262969	10031	\N
34	Damyanti	William	Kala	1946-08-21	Male	0454193645		155\nSridhar Nagar	eligendi	Nashik	Tripura	India	A+	damyanti.kala31@example.com	Farmer	f	3	Single	997619	10032	\N
35	Anjali		Narula	1992-07-21	Other	0370045487	9860503405	22\nShetty Circle	nisi	Guntakal	Meghalaya	India	AB+	anjali.narula32@example.com	Teacher	t	3	Married	780679	10033	\N
36	Rajeshri	Isaiah	Lad	1993-11-07	Female	6225291574		67, Nazareth Street	ipsam	Navi Mumbai	Arunachal Pradesh	India	AB-	rajeshri.lad33@example.com	Farmer	f	3	Widowed	526180	10034	\N
37	Jagrati	Pushti	Prashad	1971-12-15	Other	0152050530		63/34, Golla	esse	Kanpur	Himachal Pradesh	India	B-	jagrati.prashad34@example.com	Doctor	t	3	Widowed	687862	10035	\N
38	Gauri		Bava	1962-08-25	Female	9165523773		H.No. 572\nPatla Ganj	quaerat	Bidhannagar	Himachal Pradesh	India	O-	gauri.bava35@example.com	Student	t	3	Single	225412	10036	\N
39	Libni	Mugdha	Agarwal	1940-06-24	Male	1507928001	8971926867	H.No. 921, Sama Nagar	ipsam	Amroha	Tamil Nadu	India	AB+	libni.agarwal36@example.com	Doctor	t	3	Single	809646	10037	\N
40	Geetika	Harshil	Behl	1979-10-27	Female	0814391423		84/114, Goda Nagar	nulla	Raichur	Uttar Pradesh	India	B+	geetika.behl37@example.com	Retired	t	3	Married	763093	10038	\N
41	Daksh	Madhavi	Dasgupta	1943-02-28	Female	9179910469		H.No. 66, Gaba Marg	quo	Lucknow	Sikkim	India	O+	daksh.dasgupta38@example.com	Retired	f	3	Widowed	024935	10039	\N
42	Upma	Mason	Rattan	2002-11-24	Other	9133002077	00296426139	H.No. 07, Purohit Road	qui	Farrukhabad	West Bengal	India	B-	upma.rattan39@example.com	Farmer	t	3	Single	665003	10040	\N
43	Imaran		Bhattacharyya	1981-11-05	Female	1257182450	09761171406	50/98\nParmer Zila	sit	Eluru	Nagaland	India	A-	imaran.bhattacharyya40@example.com	Teacher	t	3	Widowed	566144	10041	\N
44	Jack		Rana	1988-04-21	Male	9179850872	09248387307	00/26, Vohra Road	quod	Chapra	Madhya Pradesh	India	A-	jack.rana41@example.com	Student	f	3	Single	151661	10042	\N
45	Radhika	Fitan	Tara	1950-06-06	Male	4609868823	0129791634	35, Raja Nagar	laboriosam	Tirupati	Mizoram	India	O+	radhika.tara42@example.com	Teacher	f	3	Widowed	254582	10043	\N
46	Yug		Saran	1956-11-24	Male	6468715661	+912471945512	83/94\nGaba Circle	nihil	Raichur	Tripura	India	B-	yug.saran43@example.com	Farmer	f	3	Widowed	180779	10044	\N
47	Rishi		Taneja	1935-06-12	Other	0996447341	08260408268	56/50, Madan	harum	Kumbakonam	Mizoram	India	B-	rishi.taneja44@example.com	Farmer	f	3	Married	247940	10045	\N
48	Samesh		Pai	1972-05-10	Other	0918318168	2767942821	591, Suresh Circle	ad	Ghaziabad	Assam	India	A+	samesh.pai45@example.com	Teacher	f	3	Single	316485	10046	\N
49	Turvi		Pai	1967-09-02	Other	8769361263		H.No. 49\nJoshi Ganj	accusamus	Aurangabad	Maharashtra	India	O+	turvi.pai46@example.com	Engineer	f	3	Single	072392	10047	\N
50	Chameli		Saxena	1946-03-22	Male	0096084134	+919592313986	46\nGaba Marg	doloremque	Avadi	Arunachal Pradesh	India	B-	chameli.saxena47@example.com	Retired	f	3	Married	890262	10048	\N
51	Christopher		Pillai	1970-03-23	Male	9165583643		16/35, Krishna Road	provident	Dharmavaram	Himachal Pradesh	India	B-	christopher.pillai48@example.com	Doctor	t	3	Widowed	034243	10049	\N
52	Chakrika	Unni	Basu	1984-01-25	Female	2983482466	06979876619	H.No. 421\nYogi Circle	veniam	Medininagar	West Bengal	India	A-	chakrika.basu49@example.com	Doctor	t	3	Single	518741	10050	\N
53	Arin	Dayamai	Rout	1977-10-10	Male	9177354334		65/711\nSawhney	quaerat	Moradabad	Nagaland	India	O+	arin.rout50@example.com	Retired	f	3	Married	200162	10051	\N
54	Ekaraj		Biswas	2003-03-08	Other	9954658870	+918593688191	70\nBalan Path	tempora	Siliguri	Odisha	India	A+	ekaraj.biswas51@example.com	Teacher	t	3	Single	066153	10052	\N
55	Osha		Shere	1948-03-07	Other	1518586872		63\nKadakia Ganj	repudiandae	Deoghar	Assam	India	B+	osha.shere52@example.com	Doctor	f	3	Married	901533	10053	\N
56	Sathvik	Rajeshri	Oak	1999-04-24	Male	9195040334		774\nKohli Zila	temporibus	Unnao	Gujarat	India	A-	sathvik.oak53@example.com	Doctor	f	3	Married	403930	10054	\N
57	Lekha		Dara	1954-07-04	Other	8679619693		H.No. 070\nBava	quis	Baranagar	Karnataka	India	A-	lekha.dara54@example.com	Retired	f	3	Widowed	227165	10055	\N
58	Ati	Agastya	Dada	2004-01-27	Male	9158973963		H.No. 563\nBhatnagar Ganj	vel	Bokaro	Uttarakhand	India	B+	ati.dada55@example.com	Doctor	f	3	Married	718232	10056	\N
59	Arjun		Chandran	1989-05-29	Male	9152978259	06300468551	02/53, Kapadia Circle	ab	Allahabad	Tripura	India	O-	arjun.chandran56@example.com	Farmer	t	3	Widowed	344181	10057	\N
60	Kabir	Urvashi	Wable	1995-07-31	Other	1793688991		966\nSundaram Marg	laboriosam	Khora 	Madhya Pradesh	India	B-	kabir.wable57@example.com	Engineer	f	3	Married	015093	10058	\N
61	Dominic		Nagy	1982-06-23	Female	9170476165		H.No. 432\nKrish Circle	quasi	Mangalore	Sikkim	India	AB-	dominic.nagy58@example.com	Teacher	t	3	Single	097171	10059	\N
62	Amaira	Jagdish	Ahuja	1959-04-15	Other	0924895981		17/975\nSawhney Nagar	officiis	Morbi	Nagaland	India	AB-	amaira.ahuja59@example.com	Retired	t	3	Widowed	121256	10060	\N
63	Quincy		Halder	1967-03-07	Other	4656894252		H.No. 375\nGoyal Marg	eveniet	Raebareli	Uttar Pradesh	India	B-	quincy.halder60@example.com	Student	f	3	Single	653809	10061	\N
64	Michael		D’Alia	1985-05-02	Female	9176271714	07830511838	697\nBhardwaj Ganj	sed	Vadodara	Goa	India	A-	michael.d’alia61@example.com	Doctor	t	3	Single	331475	10062	\N
65	Veer	Krish	Sani	1939-01-26	Other	9186264884	2228711898	38\nSaraf	eaque	Dewas	Bihar	India	A+	veer.sani62@example.com	Doctor	t	3	Single	590928	10063	\N
66	Forum		Chada	1979-09-14	Male	9336345429		H.No. 64\nAmble Nagar	neque	Durgapur	Madhya Pradesh	India	AB+	forum.chada63@example.com	Student	t	3	Married	823977	10064	\N
67	Avni		Prabhakar	1941-02-13	Male	9135633254		H.No. 69\nKala Nagar	ex	Siwan	Karnataka	India	B+	avni.prabhakar64@example.com	Farmer	t	3	Married	788195	10065	\N
68	Ekta		Hegde	1939-11-04	Other	6276310181		10, Bansal Path	eum	Berhampore	Manipur	India	B-	ekta.hegde65@example.com	Retired	f	3	Single	476047	10066	\N
69	Qadim		Pandya	1940-11-05	Other	0524710755	+919145128608	99/36, Kaur Street	ipsa	Nagpur	Tamil Nadu	India	B-	qadim.pandya66@example.com	Teacher	t	3	Single	789811	10067	\N
70	Vanya		Hegde	1956-01-13	Male	9198670628		47\nDhawan Ganj	quam	Asansol	Sikkim	India	O-	vanya.hegde67@example.com	Doctor	f	3	Widowed	795869	10068	\N
71	Gunbir	Shivansh	Sood	1967-05-18	Male	9116874046	06246468683	H.No. 22\nSahni Road	voluptas	Sambhal	Uttar Pradesh	India	A+	gunbir.sood68@example.com	Doctor	f	3	Widowed	024162	10069	\N
72	Vedhika		Narasimhan	2000-03-24	Other	0029604950		07/578\nHayre Marg	quod	Tinsukia	Odisha	India	A-	vedhika.narasimhan69@example.com	Doctor	f	3	Single	105111	10070	\N
73	Neha	Agastya	Dar	1940-09-06	Female	0912079576	03653006433	44/81\nMalhotra Road	dolorem	Bally	Haryana	India	AB-	neha.dar70@example.com	Teacher	t	3	Single	627247	10071	\N
74	Yochana	Ekta	Dua	1997-03-18	Female	9166307299	08353070462	034, Bahri Road	fugit	Rohtak	Odisha	India	B+	yochana.dua71@example.com	Doctor	t	3	Single	226115	10072	\N
75	Agastya		Palla	1988-06-14	Male	9168651888		47/89\nBadal Marg	dolorem	Solapur	Tripura	India	AB-	agastya.palla72@example.com	Doctor	f	3	Married	292688	10073	\N
76	Nicholas	Bhavika	Ahuja	1951-09-05	Male	3626371259	+910926462275	35/86\nKuruvilla Zila	quo	Kirari Suleman Nagar	Uttar Pradesh	India	AB+	nicholas.ahuja73@example.com	Farmer	f	3	Single	717896	10074	\N
77	Nirja		Chaudhuri	2000-09-07	Female	0366341392	8455220348	H.No. 634\nRajan Chowk	quidem	Madurai	Maharashtra	India	AB+	nirja.chaudhuri74@example.com	Engineer	f	3	Single	088722	10075	\N
78	Kamala	Ganga	Lall	1944-11-01	Other	3487717063		H.No. 59, Sami Path	officia	Anand	Meghalaya	India	AB-	kamala.lall75@example.com	Teacher	t	3	Single	284835	10076	\N
79	Sara		Choudhry	1958-06-29	Male	9115466463		69/525\nOommen Marg	vitae	Rewa	Tamil Nadu	India	AB-	sara.choudhry76@example.com	Teacher	t	3	Widowed	856217	10077	\N
80	Gaurang		Loke	1990-12-30	Male	0800453467		H.No. 103, Deshmukh Circle	possimus	Motihari	Kerala	India	B-	gaurang.loke77@example.com	Teacher	f	3	Widowed	278034	10078	\N
81	Yauvani	Chaman	Ramaswamy	1975-08-29	Other	7028420981	+915196649926	H.No. 13\nRama Ganj	laboriosam	Avadi	Tamil Nadu	India	A+	yauvani.ramaswamy78@example.com	Teacher	t	3	Widowed	361986	10079	\N
82	Wahab		Ramesh	1967-11-17	Other	9142325909		63/330\nHegde Ganj	labore	South Dumdum	Karnataka	India	O-	wahab.ramesh79@example.com	Retired	f	3	Married	689713	10080	\N
83	Riya	Tanish	Rout	1959-07-07	Other	0760207325	02469232920	25/634, Kibe Marg	ut	Gangtok	Goa	India	B-	riya.rout80@example.com	Doctor	t	3	Married	405301	10081	\N
84	Timothy		Dhillon	1986-01-20	Female	9151553964	+911918873702	96\nPrabhakar Marg	natus	Kavali	Meghalaya	India	O-	timothy.dhillon81@example.com	Farmer	t	3	Married	344452	10082	\N
85	Balvan	Aditya	Tailor	1949-07-19	Male	9146166693		28/914\nContractor Street	necessitatibus	Davanagere	Maharashtra	India	B-	balvan.tailor82@example.com	Doctor	t	3	Widowed	799032	10083	\N
86	Faras		Raval	1984-08-11	Male	2353604407	05910409950	866, Minhas	repellat	Tirupati	Chhattisgarh	India	B+	faras.raval83@example.com	Student	t	3	Single	845909	10084	\N
87	Rachita		Kamdar	1941-01-16	Other	9176959721		H.No. 860, D’Alia Circle	recusandae	Mumbai	Sikkim	India	B-	rachita.kamdar84@example.com	Farmer	t	3	Married	791675	10085	\N
88	Lajita	Chaman	Shan	2006-07-15	Other	9156453472	3037485308	460\nSachar Path	impedit	Dewas	Tripura	India	O-	lajita.shan85@example.com	Doctor	t	3	Married	005730	10086	\N
89	Netra		Mand	1997-03-26	Other	9193900862		413\nGole Nagar	rerum	Adoni	Andhra Pradesh	India	AB-	netra.mand86@example.com	Teacher	t	3	Single	218618	10087	\N
90	Baghyawati		Mannan	1972-02-14	Other	9112584881		94/74, Bhatt Zila	unde	Korba	Goa	India	AB+	baghyawati.mannan87@example.com	Engineer	f	3	Married	036567	10088	\N
91	Bhavini		Tak	1937-11-23	Other	9123666104	09832484572	66, Gera Road	similique	Bally	Maharashtra	India	O+	bhavini.tak88@example.com	Farmer	f	3	Single	333134	10089	\N
92	Chameli	Turvi	Verma	1961-08-01	Male	0288201200	01046511703	99/034, Saran Road	quis	Kurnool	Kerala	India	B-	chameli.verma89@example.com	Teacher	f	3	Widowed	283935	10090	\N
93	Jai		Vora	2004-06-14	Male	8348332359		55/92, Som Road	veritatis	Asansol	Madhya Pradesh	India	AB-	jai.vora90@example.com	Farmer	f	3	Single	384533	10091	\N
94	Nachiket		Ramachandran	2001-06-22	Other	9103850418		07/904\nVora Ganj	minima	Sirsa	Gujarat	India	O-	nachiket.ramachandran91@example.com	Student	t	3	Married	176146	10092	\N
95	Harshil	Daksha	Balasubramanian	1941-12-14	Male	9180854551		42/70, Menon Street	perferendis	Mira-Bhayandar	Haryana	India	B-	harshil.balasubramanian92@example.com	Retired	t	3	Single	608553	10093	\N
96	Aarnav		Agrawal	1986-02-09	Other	1236478865	+917360363950	H.No. 976\nSathe Marg	maxime	Udupi	Bihar	India	B-	aarnav.agrawal93@example.com	Retired	f	3	Married	658106	10094	\N
97	Ekavir		Sarkar	1995-09-08	Male	0303775353		822, Mishra	molestias	Hajipur	Madhya Pradesh	India	AB+	ekavir.sarkar94@example.com	Doctor	t	3	Married	780927	10095	\N
98	Sara	Yashawini	Bawa	1960-01-30	Male	0137336733	05148864982	96, Lad Zila	illum	Loni	Meghalaya	India	B-	sara.bawa95@example.com	Engineer	t	3	Widowed	517695	10096	\N
99	Ekbal	Mekhala	Reddy	1992-03-27	Female	0338525921	+911251417515	69\nKrishnan Circle	incidunt	Buxar	West Bengal	India	O-	ekbal.reddy96@example.com	Teacher	f	3	Single	859031	10097	\N
100	Sanya	Gopal	Bal	1998-02-15	Other	9115372346		187, Parekh	excepturi	Unnao	Uttarakhand	India	O-	sanya.bal97@example.com	Teacher	f	3	Single	424352	10098	\N
101	Barkha	Jagat	Baria	1960-01-16	Other	0998047918	00533970966	H.No. 073, Bala Street	totam	Karaikudi	Sikkim	India	B-	barkha.baria98@example.com	Student	t	3	Married	145878	10099	\N
102	Aayush	Aradhana	Dhaliwal	2006-04-25	Other	4275444346		58/860\nKota Chowk	aperiam	Visakhapatnam	Sikkim	India	B+	aayush.dhaliwal99@example.com	Engineer	f	3	Widowed	345199	10100	\N
103	Chakradev		Loke	1951-08-14	Male	0970604720	00021868096	25/254\nGanguly Street	officia	Morena	Arunachal Pradesh	India	B+	chakradev.loke100@example.com	Teacher	t	3	Single	417993	10101	\N
104	Gautami	Udarsh	Kibe	1946-05-31	Other	0228821447	+916114636073	26\nJayaraman Street	cum	Nellore	Bihar	India	B+	gautami.kibe101@example.com	Doctor	f	3	Married	839638	10102	\N
105	Laksh		Nori	1945-05-28	Other	9156938773	+917819317048	434\nKrish Path	velit	Alwar	Sikkim	India	AB+	laksh.nori102@example.com	Student	f	3	Widowed	858441	10103	\N
106	Ishita		Bawa	1934-09-25	Other	7214527781	+910338835375	H.No. 471, Bose Circle	odit	Ahmednagar	West Bengal	India	A+	ishita.bawa103@example.com	Retired	f	3	Widowed	493826	10104	\N
107	Girish	Qushi	Kade	1954-01-23	Other	0768231397		71/04\nBadami Circle	inventore	Noida	Tripura	India	A-	girish.kade104@example.com	Doctor	f	3	Single	669783	10105	\N
108	Lohit		Chaudhry	1972-12-13	Other	9104263584		H.No. 211, Din Road	necessitatibus	Bidhannagar	Punjab	India	O-	lohit.chaudhry105@example.com	Engineer	f	3	Single	399188	10106	\N
109	Upma	Aditya	Sabharwal	2005-03-03	Male	9376965490	9395347591	83\nRattan Marg	voluptates	Bellary	Chhattisgarh	India	B-	upma.sabharwal106@example.com	Engineer	f	3	Married	404916	10107	\N
110	Jagrati	Tanveer	Mangal	1976-06-17	Male	0536283660	09782830882	968, Kant Street	vero	North Dumdum	Haryana	India	O-	jagrati.mangal107@example.com	Teacher	f	3	Married	671774	10108	\N
111	Yatin		Gopal	1966-04-11	Other	9162055804		356, Walla Street	quo	Rajkot	Jharkhand	India	B+	yatin.gopal108@example.com	Farmer	t	3	Married	988908	10109	\N
112	Unnati	Yashodhara	Patil	1956-06-08	Female	9145509033		H.No. 27, Deshmukh Circle	et	Bhatpara	Mizoram	India	B+	unnati.patil109@example.com	Retired	t	3	Widowed	824395	10110	\N
113	Frado	Nilima	Mahajan	1976-05-09	Other	0104300283		H.No. 302\nOommen Marg	nisi	Karawal Nagar	Jharkhand	India	B-	frado.mahajan110@example.com	Engineer	f	3	Married	300326	10111	\N
114	Indrajit		Dada	1984-06-05	Female	9180709979		19, Banerjee Nagar	quidem	Jaipur	Chhattisgarh	India	AB+	indrajit.dada111@example.com	Retired	f	3	Widowed	811814	10112	\N
115	Siddharth	Oviya	Sama	1963-03-11	Female	5694558349		704\nParmar Circle	at	Bhilai	Haryana	India	A+	siddharth.sama112@example.com	Student	f	3	Widowed	741569	10113	\N
116	Neelima	Januja	Salvi	1974-04-14	Female	0031802557	02956579135	H.No. 567\nManda Circle	molestiae	Pimpri-Chinchwad	Tripura	India	B+	neelima.salvi113@example.com	Student	f	3	Widowed	841028	10114	\N
117	Manbir		Prashad	1950-11-20	Other	9102705449		036\nBalay Ganj	unde	Begusarai	Himachal Pradesh	India	O+	manbir.prashad114@example.com	Doctor	t	3	Married	228012	10115	\N
118	Jacob	Chakradev	D’Alia	1958-01-15	Other	0124300372		91/660\nDutta Chowk	iusto	Miryalaguda	Himachal Pradesh	India	A+	jacob.d’alia115@example.com	Teacher	f	3	Widowed	965524	10116	\N
119	Teerth		Sarna	1966-09-08	Female	4797312906		74/45, Patel	ea	Satna	Kerala	India	AB+	teerth.sarna116@example.com	Retired	f	3	Married	685946	10117	\N
120	Charles		Sodhi	1994-06-20	Male	1777631368		97/533, Ranganathan Zila	illo	Bhimavaram	Gujarat	India	AB+	charles.sodhi117@example.com	Doctor	t	3	Widowed	315154	10118	\N
121	Girish		Walia	1963-03-14	Male	4396000851	+911217141801	88/932, Krishna Nagar	neque	Tumkur	Mizoram	India	B-	girish.walia118@example.com	Retired	t	3	Married	505857	10119	\N
122	Inaya	Nachiket	Varty	1953-06-07	Female	9166958951		69/431, Oza Road	laboriosam	Shivpuri	Arunachal Pradesh	India	A+	inaya.varty119@example.com	Teacher	f	3	Single	818809	10120	\N
123	Chanakya		Chad	2001-06-12	Female	1539740240	06183224450	098, Sethi Circle	voluptatibus	Jorhat	Madhya Pradesh	India	O+	chanakya.chad120@example.com	Retired	t	3	Single	841917	10121	\N
124	Joshua	Krishna	Boase	1980-03-10	Female	0487723069		H.No. 139, Ranganathan Road	non	Thanjavur	Odisha	India	O-	joshua.boase121@example.com	Student	t	3	Widowed	454198	10122	\N
125	Balhaar	Upkaar	Subramaniam	1983-04-19	Other	0981359593	04271403162	H.No. 232\nSawhney Zila	vel	Bihar Sharif	Sikkim	India	A-	balhaar.subramaniam122@example.com	Retired	f	3	Married	841991	10123	\N
126	Samarth		Arora	1984-02-01	Male	0846031537	+911182033551	40/161\nPradhan Road	non	Kottayam	Arunachal Pradesh	India	B-	samarth.arora123@example.com	Doctor	t	3	Single	478081	10124	\N
127	Rachana		Guha	1970-02-19	Other	0139077623		H.No. 19, Bose Circle	doloremque	Muzaffarpur	Uttarakhand	India	A+	rachana.guha124@example.com	Doctor	f	3	Single	287384	10125	\N
128	Ishani		Nigam	1963-12-24	Female	9125898695		359, Loke Ganj	repellat	Bhavnagar	Nagaland	India	A-	ishani.nigam125@example.com	Farmer	t	3	Married	059299	10126	\N
129	Tanveer		Sheth	1935-04-26	Other	0652851811		19/73, Sampath Ganj	quisquam	Uluberia	Telangana	India	AB+	tanveer.sheth126@example.com	Retired	f	3	Widowed	014796	10127	\N
130	Utkarsh	Adya	Chokshi	1968-03-25	Male	0103460990		08/41, Bahri Marg	atque	Phusro	Haryana	India	O+	utkarsh.chokshi127@example.com	Student	t	3	Single	954226	10128	\N
131	Gavin		Agrawal	2001-01-29	Female	0693705839	04394222717	266, Mitra Path	corporis	Patna	Goa	India	B+	gavin.agrawal128@example.com	Student	t	3	Married	213728	10129	\N
132	Darika	Geetika	Sunder	2003-06-18	Male	9159090121	04636076437	212\nCherian Street	voluptatum	Ambarnath	Meghalaya	India	A+	darika.sunder129@example.com	Farmer	t	3	Single	635568	10130	\N
133	Abdul		Varty	1940-04-29	Female	9104930253	9322433344	787\nKumar Marg	optio	Hapur	Kerala	India	B-	abdul.varty130@example.com	Doctor	f	3	Widowed	655010	10131	\N
134	Charles		Sathe	1956-02-23	Male	9128161084		99/646\nBrar Street	quis	Ujjain	Gujarat	India	O+	charles.sathe131@example.com	Doctor	t	3	Married	872166	10132	\N
135	Lakshmi		Majumdar	1997-09-25	Other	6133208214	9955494418	591, Oak Nagar	placeat	Ambala	Arunachal Pradesh	India	O+	lakshmi.majumdar132@example.com	Farmer	f	3	Widowed	728029	10133	\N
136	Abha		Vaidya	1994-11-15	Male	8231506426		587, Grewal Chowk	ipsa	Jaunpur	Manipur	India	B+	abha.vaidya133@example.com	Doctor	t	3	Single	390269	10134	\N
137	Tanish		Roy	1965-04-21	Female	9166958911	8650274136	H.No. 77\nGole Marg	occaecati	Vadodara	Maharashtra	India	B+	tanish.roy134@example.com	Doctor	t	3	Widowed	470314	10135	\N
138	Triveni		Shenoy	1977-11-16	Female	0422423773		H.No. 205, Ramanathan Ganj	earum	Hospet	Karnataka	India	O+	triveni.shenoy135@example.com	Engineer	f	3	Married	583177	10136	\N
139	Yuvraj	Neelima	Loyal	1961-07-26	Other	9115782742	3899851215	H.No. 763\nDhar Circle	perferendis	Cuttack	Chhattisgarh	India	AB+	yuvraj.loyal136@example.com	Student	t	3	Widowed	275818	10137	\N
140	Yashica	Parth	Kamdar	1939-06-11	Male	9157593933		H.No. 75\nDutta Nagar	at	Jammu	Goa	India	AB+	yashica.kamdar137@example.com	Student	f	3	Widowed	475388	10138	\N
141	Yutika	Gabriel	Mohan	1995-06-06	Female	9131335751	6818673391	09\nThakur Path	repellat	Saharanpur	Bihar	India	B-	yutika.mohan138@example.com	Retired	f	3	Widowed	420545	10139	\N
142	Vedant		Parsa	1992-02-24	Male	0080292725	6864671023	59\nPal Street	possimus	Khora 	Maharashtra	India	O-	vedant.parsa139@example.com	Retired	t	3	Widowed	324784	10140	\N
143	Darika	Gaurav	Banerjee	1994-08-29	Male	0259792551		H.No. 191\nGhose Path	nobis	Mathura	Karnataka	India	A+	darika.banerjee140@example.com	Retired	t	3	Widowed	046652	10141	\N
144	Ishita	Warjas	Acharya	1968-09-08	Other	1583590589		44, Kannan Marg	culpa	Saharsa	Karnataka	India	O+	ishita.acharya141@example.com	Engineer	f	3	Married	938431	10142	\N
145	Hredhaan	Zashil	Chaudhari	1972-10-16	Female	1959944387	01121006272	H.No. 09\nKibe Chowk	officia	Mathura	Arunachal Pradesh	India	O-	hredhaan.chaudhari142@example.com	Student	t	3	Single	924610	10143	\N
146	Ansh	Yashawini	Chadha	1972-12-02	Male	9170386940		02/37, Lalla Zila	pariatur	Chapra	Tripura	India	B-	ansh.chadha143@example.com	Student	t	3	Single	580173	10144	\N
147	Rachit		Muni	1942-11-20	Female	9162122933	9398093531	63, Bumb Ganj	velit	Jaipur	Goa	India	O+	rachit.muni144@example.com	Teacher	t	3	Widowed	336039	10145	\N
148	Jagrati		Thaman	1989-02-20	Female	3672733700	0981334948	H.No. 06\nKonda Ganj	magnam	Kanpur	Assam	India	A+	jagrati.thaman145@example.com	Farmer	f	3	Married	888278	10146	\N
149	Damini		Setty	1952-07-20	Female	9176908675		27, Menon Marg	nostrum	Bilaspur	West Bengal	India	AB+	damini.setty146@example.com	Retired	t	3	Single	838058	10147	\N
150	Isha	Chatresh	Soni	1985-07-19	Other	0744878398		430\nGhosh Zila	eius	Jabalpur	Jharkhand	India	AB-	isha.soni147@example.com	Doctor	f	3	Married	106732	10148	\N
151	Aadhya	Yadavi	Khalsa	1950-07-16	Female	5543870360		H.No. 59\nChand Zila	quas	Ghaziabad	Tamil Nadu	India	O+	aadhya.khalsa148@example.com	Student	f	3	Widowed	227255	10149	\N
152	Anamika	Ganga	Yadav	1964-12-21	Male	0617470966	5812769992	10\nKaur Nagar	iusto	Bhopal	Nagaland	India	AB+	anamika.yadav149@example.com	Student	t	3	Married	865006	10150	\N
153	Saumya		Solanki	2002-05-19	Other	9123839344	03433352709	H.No. 83, Mandal	necessitatibus	Cuttack	Rajasthan	India	AB+	saumya.solanki150@example.com	Student	t	3	Widowed	086727	10151	\N
154	Anvi		Dey	1980-05-01	Other	9113863082		19/349\nGulati Road	ipsam	Pune	Karnataka	India	AB+	anvi.dey151@example.com	Engineer	t	3	Married	679276	10152	\N
155	Hamsini	Anita	Bhatnagar	1983-08-27	Female	7556161542	+910497481943	02, Mammen Road	mollitia	Purnia	Gujarat	India	A+	hamsini.bhatnagar152@example.com	Engineer	t	3	Single	289063	10153	\N
156	Falan	Harshil	Ramanathan	1964-08-14	Other	9543288915	1431487949	466\nKamdar Road	deserunt	Haridwar	Madhya Pradesh	India	AB-	falan.ramanathan153@example.com	Farmer	f	3	Married	323071	10154	\N
157	Neha		Bhagat	2003-01-17	Other	9116936651		05/921, Patla Ganj	modi	Katihar	Kerala	India	A+	neha.bhagat154@example.com	Student	t	3	Single	285194	10155	\N
158	Yahvi	Timothy	Kamdar	1990-07-05	Male	9134710374		964, Ranganathan Chowk	voluptas	Visakhapatnam	Nagaland	India	B-	yahvi.kamdar155@example.com	Doctor	f	3	Single	664139	10156	\N
159	Jasmit	Pushti	Rau	2005-09-11	Other	9127522986	+918395686887	H.No. 21\nSrivastava Marg	necessitatibus	Gangtok	Sikkim	India	B-	jasmit.rau156@example.com	Retired	t	3	Single	272720	10157	\N
160	Zaitra	Gagan	Gade	1998-02-07	Other	0486658092		05, Dara Ganj	possimus	Gaya	Chhattisgarh	India	A+	zaitra.gade157@example.com	Retired	t	3	Widowed	827197	10158	\N
161	Radha	Ikshita	Patla	1982-05-30	Female	2866655043	+912446720638	86\nChaudry Road	fugiat	Dhanbad	Karnataka	India	A-	radha.patla158@example.com	Teacher	f	3	Single	820135	10159	\N
162	Raksha	Jatin	De	1958-02-12	Other	9117580704		58/31, Sama Path	eaque	Bikaner	Meghalaya	India	B+	raksha.de159@example.com	Doctor	t	3	Widowed	259854	10160	\N
163	Ayaan	Tarak	Naik	2003-09-25	Other	0323486588	2791482116	64/75\nBorah Path	nobis	Malegaon	Maharashtra	India	A-	ayaan.naik160@example.com	Teacher	f	3	Single	508689	10161	\N
164	Ayaan		Divan	1965-11-04	Female	9160480759		79\nThakkar	cum	Mumbai	Karnataka	India	AB+	ayaan.divan161@example.com	Teacher	t	3	Single	343692	10162	\N
165	Zaid		Bhagat	2005-12-10	Other	6880093271	6863339895	28/949\nPrashad Street	nulla	Kolkata	Odisha	India	A-	zaid.bhagat162@example.com	Student	t	3	Widowed	457350	10163	\N
166	Bishakha	Zarna	Madan	2000-03-30	Other	9102904949	0069969881	731, Konda Ganj	magnam	Naihati	Maharashtra	India	A-	bishakha.madan163@example.com	Doctor	t	3	Single	189934	10164	\N
167	Ira	Yagnesh	Balay	1958-09-08	Male	0520840392		896\nWarrior Nagar	temporibus	Raiganj	Mizoram	India	B+	ira.balay164@example.com	Farmer	f	3	Married	644610	10165	\N
168	Nathan	Tanveer	Ramakrishnan	2003-09-28	Male	3881200687		18, Sahni Ganj	assumenda	Kamarhati	Andhra Pradesh	India	O+	nathan.ramakrishnan165@example.com	Teacher	t	3	Widowed	649478	10166	\N
169	Aahana		Divan	1971-10-29	Other	0299159078		73/12, Kuruvilla Path	optio	Jorhat	Himachal Pradesh	India	A+	aahana.divan166@example.com	Doctor	t	3	Single	536162	10167	\N
170	Naksh	Bhanumati	Nagar	1966-12-13	Female	9108019331		76/46, Lad Path	molestiae	Nandyal	Manipur	India	AB+	naksh.nagar167@example.com	Farmer	t	3	Single	974085	10168	\N
171	Owen		Goda	1949-09-01	Female	9101963038	7589779331	181, Chaudhry Path	eligendi	Vijayawada	Gujarat	India	A-	owen.goda168@example.com	Doctor	f	3	Single	969534	10169	\N
172	Samaksh	Victor	Deshpande	1971-10-15	Male	0872529142		51, Rajan Marg	id	Ramgarh	Bihar	India	O-	samaksh.deshpande169@example.com	Doctor	t	3	Married	621370	10170	\N
173	Oviya	Isaiah	Narula	1974-06-07	Other	9328170168		87/673, Ray Road	alias	Dibrugarh	Uttarakhand	India	A+	oviya.narula170@example.com	Teacher	f	3	Single	127255	10171	\N
174	Yamini	Samuel	Jain	1942-11-04	Male	0913287359	9447674858	83/444\nKannan Nagar	recusandae	Haldia	Arunachal Pradesh	India	B-	yamini.jain171@example.com	Retired	t	3	Married	056694	10172	\N
175	Oscar	Alka	Bhatnagar	1993-04-01	Other	7116625211		26/73\nDhar Road	consequuntur	Firozabad	Arunachal Pradesh	India	B+	oscar.bhatnagar172@example.com	Retired	f	3	Married	456971	10173	\N
176	Jatin		Khare	1975-05-23	Male	8788667761		H.No. 543, Pradhan Street	excepturi	Tirunelveli	Sikkim	India	A-	jatin.khare173@example.com	Student	t	3	Widowed	097917	10174	\N
177	Jairaj		Pau	1989-09-15	Male	0988753329		09\nSarkar Road	sit	Mangalore	Andhra Pradesh	India	B+	jairaj.pau174@example.com	Doctor	t	3	Widowed	699883	10175	\N
178	Janya	Bhavna	Vaidya	1982-05-24	Other	9162497882	5054296187	58\nNori Street	ullam	Nadiad	Odisha	India	AB+	janya.vaidya175@example.com	Retired	t	3	Married	061297	10176	\N
179	Kritika	Lucky	Narain	1988-08-30	Female	9136157302		H.No. 659, Buch Ganj	earum	Jalna	Himachal Pradesh	India	B-	kritika.narain176@example.com	Student	f	3	Married	820686	10177	\N
180	Oliver		Kala	1956-05-20	Female	7197393639		387\nBasu Marg	libero	Nashik	Karnataka	India	O-	oliver.kala177@example.com	Doctor	f	3	Single	437120	10178	\N
181	Girish	Shivansh	Bora	1965-01-08	Other	0806189829	9283683306	H.No. 695\nMistry Road	laborum	Hospet	Karnataka	India	B+	girish.bora178@example.com	Retired	f	3	Married	459409	10179	\N
182	Ridhi		Bhardwaj	1936-07-30	Female	5634062819	+911310387452	736\nBatra Circle	magnam	Suryapet	Jharkhand	India	A+	ridhi.bhardwaj179@example.com	Teacher	t	3	Married	309536	10180	\N
183	Shivansh		Bali	1962-07-27	Male	9135493265	01112355379	59/193, Din Street	dolore	Tirupati	Haryana	India	A-	shivansh.bali180@example.com	Teacher	t	3	Single	168654	10181	\N
184	Pranav	Aayush	Bhattacharyya	1978-07-28	Female	9186825576	+916348915340	H.No. 473, Bhatia Circle	illo	Kolkata	Nagaland	India	O-	pranav.bhattacharyya181@example.com	Student	f	3	Single	425896	10182	\N
185	Upadhriti	Urmi	Muni	1964-04-29	Male	9189954898		57, Sankar Ganj	iste	Kurnool	Himachal Pradesh	India	A+	upadhriti.muni182@example.com	Teacher	f	3	Widowed	030190	10183	\N
186	Gopal	Mohini	Chander	1987-08-24	Male	9193212657		H.No. 85\nArya Nagar	omnis	Indore	Rajasthan	India	A+	gopal.chander183@example.com	Student	t	3	Widowed	733638	10184	\N
187	Chanchal	Raghav	Khurana	1940-11-15	Male	9175977625	07257211430	21/333\nKhurana Road	asperiores	Madurai	Assam	India	AB-	chanchal.khurana184@example.com	Teacher	t	3	Single	266192	10185	\N
188	Gautam	Bina	Narayanan	1943-10-10	Male	0677356829	+919672648707	H.No. 15\nBrar Street	maiores	Jhansi	Arunachal Pradesh	India	B+	gautam.narayanan185@example.com	Teacher	t	3	Widowed	406125	10186	\N
189	Rishi		Sibal	1971-05-28	Other	0412826830		22/75, Shroff Chowk	ipsam	Bhiwandi	Gujarat	India	A-	rishi.sibal186@example.com	Student	t	3	Married	171858	10187	\N
190	Xavier	Geetika	Bava	1986-04-18	Other	0607857522	+913662989045	26/173\nMinhas Road	eligendi	Kavali	Arunachal Pradesh	India	B-	xavier.bava187@example.com	Engineer	f	3	Married	706462	10188	\N
191	Victor	Gavin	Toor	1942-10-23	Male	8018741176	0430726481	52, Kota Circle	nesciunt	Bokaro	Himachal Pradesh	India	A+	victor.toor188@example.com	Student	f	3	Widowed	858809	10189	\N
192	Tara	Jatin	Issac	1964-04-24	Female	0639369747	08743239548	71\nRanganathan Road	quisquam	Aurangabad	Tamil Nadu	India	B-	tara.issac189@example.com	Teacher	f	3	Married	316246	10190	\N
193	Bahadurjit	Anusha	Palla	1969-10-06	Male	9156332501		688, Thaker	perspiciatis	Panvel	Tamil Nadu	India	AB-	bahadurjit.palla190@example.com	Farmer	f	3	Single	046397	10191	\N
194	Chavvi	Hredhaan	Ganguly	1951-07-31	Male	9152335189	04652824913	24/341, Sengupta Chowk	vel	Ujjain	Gujarat	India	O+	chavvi.ganguly191@example.com	Student	t	3	Single	007813	10192	\N
195	Yutika		Chakrabarti	1995-06-06	Male	0431200862		14/63, Devan	incidunt	Madanapalle	Goa	India	O+	yutika.chakrabarti192@example.com	Retired	f	3	Single	944009	10193	\N
196	Chatura		Handa	1982-02-15	Female	0324186032		60/91\nComar Road	nesciunt	Dhule	Andhra Pradesh	India	O-	chatura.handa193@example.com	Farmer	t	3	Widowed	937749	10194	\N
197	Sudiksha		Ravel	1990-01-15	Male	9123933029	+919865010611	H.No. 27, Raghavan	repellendus	Barasat	Maharashtra	India	O-	sudiksha.ravel194@example.com	Doctor	f	3	Widowed	045092	10195	\N
198	Amaira	Maanas	Chaudhuri	1943-08-24	Other	8500810320	0030020688	36\nViswanathan Nagar	quibusdam	Pali	West Bengal	India	AB+	amaira.chaudhuri195@example.com	Engineer	t	3	Single	165247	10196	\N
199	Damyanti		Chander	1970-06-17	Male	9198898640	00488893819	56/27\nBorde Chowk	repellendus	Ratlam	Jharkhand	India	O+	damyanti.chander196@example.com	Doctor	f	3	Married	673842	10197	\N
200	Ekaraj		Tandon	1935-07-16	Other	0148249229		20\nKulkarni Nagar	et	Ballia	Haryana	India	A+	ekaraj.tandon197@example.com	Farmer	f	3	Widowed	117107	10198	\N
201	Dev	Kabir	Lal	1939-10-23	Female	0290081955		054, Hayer Zila	animi	Mahbubnagar	Haryana	India	AB-	dev.lal198@example.com	Student	f	3	Widowed	513342	10199	\N
202	Advay		Dutt	1987-02-07	Female	9118533217		40, Sheth Circle	reprehenderit	Bathinda	Bihar	India	AB+	advay.dutt199@example.com	Farmer	f	3	Married	595220	10200	\N
203	Ucchal		Batta	1987-09-05	Female	4487523705		45/584\nRam Nagar	odio	Munger	Telangana	India	O+	ucchal.batta200@example.com	Retired	f	3	Married	779698	10201	\N
204	Xavier	Chakrika	Dalal	1961-04-21	Other	9100988517		91/61\nKakar Nagar	similique	Sri Ganganagar	Telangana	India	AB-	xavier.dalal201@example.com	Retired	f	3	Single	462157	10202	\N
205	Reyansh	Wriddhish	Mody	2006-06-14	Female	0468193680		53/671, Hayre Zila	aut	Ujjain	Maharashtra	India	B+	reyansh.mody202@example.com	Farmer	f	3	Widowed	771511	10203	\N
206	Anya		Trivedi	1971-06-07	Other	9179686823		13\nKohli Path	omnis	Kottayam	Jharkhand	India	B-	anya.trivedi203@example.com	Student	f	3	Married	426301	10204	\N
207	Mahika	Sara	Virk	1948-06-18	Female	9182979200	+912312938612	H.No. 560, Sha Ganj	repellendus	Thane	Gujarat	India	AB+	mahika.virk204@example.com	Engineer	f	3	Widowed	999077	10205	\N
208	Devansh		Oza	1972-11-14	Male	0262089872		71\nDasgupta Path	eligendi	Kavali	Nagaland	India	B-	devansh.oza205@example.com	Farmer	t	3	Single	379090	10206	\N
209	Onkar		Gopal	1989-07-12	Female	0173845599		64\nSachar Ganj	beatae	Aurangabad	Telangana	India	B+	onkar.gopal206@example.com	Farmer	f	3	Single	869128	10207	\N
210	Baljiwan	Avi	Dixit	1948-01-02	Other	0436214446	09102929872	H.No. 276, Narayanan Nagar	tempore	Kishanganj	Himachal Pradesh	India	B+	baljiwan.dixit207@example.com	Student	t	3	Widowed	346472	10208	\N
211	Benjamin		Deshmukh	1940-11-12	Female	0242253227	+912959652909	77/28, Prabhakar Marg	recusandae	Kalyan-Dombivli	Himachal Pradesh	India	AB+	benjamin.deshmukh208@example.com	Farmer	f	3	Married	688441	10209	\N
212	Manbir		Chopra	1966-07-01	Other	9193741987	+911469017351	H.No. 54, Mohan Chowk	iste	Darbhanga	Himachal Pradesh	India	A-	manbir.chopra209@example.com	Retired	t	3	Married	128307	10210	\N
213	Yachana		Sehgal	1938-11-19	Female	9124669025		51/95, Chakrabarti Path	beatae	Jaipur	Arunachal Pradesh	India	O+	yachana.sehgal210@example.com	Doctor	t	3	Single	897540	10211	\N
214	Rishi		Murty	1964-08-10	Other	9102471082	7365736039	37\nPalan Chowk	ab	Howrah	West Bengal	India	AB+	rishi.murty211@example.com	Student	t	3	Widowed	768739	10212	\N
215	Janani	Chakradhar	Biswas	1973-01-08	Other	0281907031		H.No. 301, Bala Road	adipisci	Deoghar	Sikkim	India	A-	janani.biswas212@example.com	Farmer	t	3	Widowed	232273	10213	\N
216	Owen		Barad	1998-08-10	Other	0468319502	+914900341440	82/72\nNazareth	non	Katni	Tripura	India	O-	owen.barad213@example.com	Teacher	f	3	Married	875388	10214	\N
217	Vivaan	Orinder	Mukhopadhyay	1966-02-28	Female	5344013345	09899139087	08/161, Ravel Ganj	repellendus	Farrukhabad	Madhya Pradesh	India	A-	vivaan.mukhopadhyay214@example.com	Engineer	t	3	Single	830052	10215	\N
218	Zaitra	Thomas	Balasubramanian	1935-05-01	Other	9194945333	+912932360949	H.No. 973, Ray Ganj	unde	Malda	Chhattisgarh	India	B+	zaitra.balasubramanian215@example.com	Retired	t	3	Widowed	360588	10216	\N
219	Qabil	Charan	Memon	1968-04-23	Other	5474079217		81/061, Date Zila	ipsum	Kavali	Uttarakhand	India	O-	qabil.memon216@example.com	Student	t	3	Widowed	527024	10217	\N
220	Yahvi		Tandon	1968-03-20	Other	0337083423	+911078787328	H.No. 41\nSrinivasan Road	quae	Udaipur	Rajasthan	India	A-	yahvi.tandon217@example.com	Farmer	f	3	Widowed	979200	10218	\N
221	Mahika	Leela	Ganguly	1961-10-28	Other	1416711147	+911512540580	H.No. 345\nTiwari Path	vitae	Bahraich	Kerala	India	O-	mahika.ganguly218@example.com	Doctor	f	3	Single	403292	10219	\N
222	Vivaan		Parsa	1956-12-08	Male	9177144669	06147092903	H.No. 35\nSarkar Road	animi	Dehri	Gujarat	India	A+	vivaan.parsa219@example.com	Student	t	3	Widowed	573493	10220	\N
223	Bachittar		Khurana	1975-04-03	Male	6398522015	+912018062072	90/40, Srivastava Marg	voluptates	Vellore	Himachal Pradesh	India	O+	bachittar.khurana220@example.com	Engineer	t	3	Married	544377	10221	\N
224	Devika		Jha	1957-07-21	Female	9153605302	6293653588	77/99\nSur Zila	labore	Kharagpur	Goa	India	O-	devika.jha221@example.com	Farmer	t	3	Widowed	204861	10222	\N
225	Niharika		Chand	1938-11-09	Other	2646178114	01572291104	72, Bora Road	officiis	Hyderabad	Maharashtra	India	A-	niharika.chand222@example.com	Retired	t	3	Widowed	282404	10223	\N
226	Xalak	Darika	Dave	1963-10-24	Other	9197083301	6677180648	39/83\nSuresh Street	placeat	Amravati	Bihar	India	B-	xalak.dave223@example.com	Engineer	t	3	Married	497500	10224	\N
227	Avni	Anmol	Mangal	2002-08-09	Female	0221343767		H.No. 80, Edwin Marg	aspernatur	Vadodara	Gujarat	India	A-	avni.mangal224@example.com	Teacher	t	3	Single	329822	10225	\N
228	Hredhaan	Harinakshi	Devan	1952-03-06	Male	9165889979	02899979113	H.No. 986\nHayer Circle	vero	Bardhaman	Uttarakhand	India	O+	hredhaan.devan225@example.com	Engineer	f	3	Married	591692	10226	\N
229	Sathvik		Sahota	2000-08-01	Female	6519238781	+915227737643	H.No. 851\nGhosh Chowk	dignissimos	Saharsa	Chhattisgarh	India	O-	sathvik.sahota226@example.com	Doctor	f	3	Married	879186	10227	\N
230	Ronith		Dar	1988-12-31	Male	9125396092	03408640411	242, Suresh Chowk	sapiente	Vijayawada	Mizoram	India	O+	ronith.dar227@example.com	Retired	f	3	Single	272138	10228	\N
231	Aadi	Yashica	Sachdeva	1956-08-17	Other	9119244090		50\nYadav Marg	laborum	Katihar	Arunachal Pradesh	India	B+	aadi.sachdeva228@example.com	Engineer	t	3	Widowed	124589	10229	\N
232	Vyanjana	Nirja	Dixit	1966-09-21	Female	0137122738		62/452, Mitra Path	itaque	Hospet	Bihar	India	A-	vyanjana.dixit229@example.com	Teacher	f	3	Single	677589	10230	\N
233	Avi		Bhavsar	1968-04-02	Other	6840360593	8195515315	354\nShetty Ganj	totam	Anand	Nagaland	India	O-	avi.bhavsar230@example.com	Student	t	3	Widowed	916199	10231	\N
234	Bachittar	Maanav	Bala	1962-05-02	Female	4709105958		H.No. 450, Sekhon Zila	necessitatibus	Nadiad	Assam	India	A+	bachittar.bala231@example.com	Retired	t	3	Widowed	620002	10232	\N
235	Lavanya	Warda	Chandran	2003-03-16	Male	4999971537	5549762635	H.No. 64\nTailor Zila	sed	Ghaziabad	Uttar Pradesh	India	O+	lavanya.chandran232@example.com	Farmer	t	3	Single	840090	10233	\N
236	Chaaya	Bakhshi	Guha	1953-02-02	Female	9478272091		96, Gill Path	consequuntur	Rajkot	Punjab	India	A-	chaaya.guha233@example.com	Doctor	f	3	Widowed	576439	10234	\N
237	Saksham	Yug	Mannan	1948-02-09	Other	7189407391	0926118462	01\nDave Circle	necessitatibus	Ratlam	Chhattisgarh	India	AB+	saksham.mannan234@example.com	Student	t	3	Married	848695	10235	\N
238	Amaira		Ramachandran	1983-08-05	Male	9131905307		H.No. 557, Saran Street	ipsum	Kalyan-Dombivli	Haryana	India	O+	amaira.ramachandran235@example.com	Engineer	t	3	Widowed	617415	10236	\N
239	Keya		Amble	1941-11-18	Male	9118979815	4317499341	09/02, Kaur Marg	porro	Anantapuram	Jharkhand	India	O-	keya.amble236@example.com	Retired	t	3	Single	692584	10237	\N
240	Arin	Jacob	Shenoy	1940-12-20	Female	0601478289		H.No. 455\nDar Path	consectetur	Mumbai	Odisha	India	A+	arin.shenoy237@example.com	Student	f	3	Single	528961	10238	\N
241	Chatura		Gala	1982-08-27	Other	9180993162		H.No. 362\nSamra Zila	nostrum	Mathura	Arunachal Pradesh	India	B-	chatura.gala238@example.com	Retired	f	3	Single	148603	10239	\N
242	Owen		Bobal	1995-11-09	Other	0039346732	+916811381413	H.No. 675, Dayal Zila	tempora	Gandhidham	Goa	India	A-	owen.bobal239@example.com	Retired	f	3	Widowed	280888	10240	\N
243	Tejas		Ravel	1940-07-29	Other	9171640072	09280575429	H.No. 13\nKaul Marg	tempore	Haldia	Karnataka	India	B+	tejas.ravel240@example.com	Engineer	f	3	Single	040802	10241	\N
244	Ekalinga		Bala	1987-10-17	Female	1625323429		01\nMann Nagar	est	Indore	Odisha	India	O-	ekalinga.bala241@example.com	Student	f	3	Single	247988	10242	\N
245	Frado		Bali	1967-08-23	Female	0988596228	+911788841279	H.No. 05, Behl Ganj	rem	Bhimavaram	Rajasthan	India	B+	frado.bali242@example.com	Teacher	t	3	Widowed	639637	10243	\N
246	Gunbir		Dhawan	1940-04-06	Other	9160198350		88, Deshpande Marg	ad	Delhi	Karnataka	India	AB+	gunbir.dhawan243@example.com	Doctor	t	3	Widowed	217786	10244	\N
247	Banjeet		Sanghvi	1940-09-17	Other	6022024017		66, Lanka Street	repudiandae	Eluru	Rajasthan	India	A-	banjeet.sanghvi244@example.com	Farmer	t	3	Married	742980	10245	\N
248	Zansi	Ronith	Tak	1953-09-30	Male	9111971616		H.No. 83\nBhargava Nagar	soluta	Malegaon	Meghalaya	India	B-	zansi.tak245@example.com	Doctor	t	3	Single	173502	10246	\N
249	Kalpit	Ryan	Gade	1958-06-17	Other	0580984665	+919725981913	992\nHegde Nagar	placeat	Shimoga	Uttarakhand	India	O+	kalpit.gade246@example.com	Teacher	f	3	Single	171456	10247	\N
250	Gaurika	Chaitanya	Rama	1975-06-19	Female	1343169243		130\nBahri Marg	doloremque	Cuttack	Goa	India	AB-	gaurika.rama247@example.com	Teacher	t	3	Married	199380	10248	\N
251	Maanas	Mugdha	Bhatia	1972-04-19	Male	0542808996	03986372312	H.No. 437\nPandya Road	ipsam	Thane	Odisha	India	B+	maanas.bhatia248@example.com	Doctor	t	3	Married	519233	10249	\N
252	Vedika		Panchal	2000-04-24	Other	0711495140		H.No. 87, Subramanian Circle	praesentium	Tiruchirappalli	Haryana	India	B-	vedika.panchal249@example.com	Retired	t	3	Married	856655	10250	\N
253	Devansh	Nidhi	Nigam	1966-01-06	Other	0725813031	7755612841	94\nGolla Circle	explicabo	Nagpur	Punjab	India	B-	devansh.nigam250@example.com	Engineer	t	3	Married	203539	10251	\N
254	Arjun		Biswas	1971-04-13	Other	9158326185	04491873793	393\nDey Ganj	ratione	Ballia	Nagaland	India	O+	arjun.biswas251@example.com	Retired	f	3	Single	648896	10252	\N
255	Hiral	Urvashi	Naidu	1952-03-25	Other	1752108384		511, Vora Ganj	occaecati	Dewas	Nagaland	India	O-	hiral.naidu252@example.com	Student	t	3	Married	687298	10253	\N
256	Raksha		Swamy	1948-03-23	Male	0203208163	+913177532842	44/637, Sagar Road	error	South Dumdum	Uttar Pradesh	India	O-	raksha.swamy253@example.com	Student	t	3	Widowed	884111	10254	\N
257	Rishi	Balendra	Srinivasan	1973-02-26	Other	9190559157		H.No. 354, Mangal Marg	quas	New Delhi	Uttar Pradesh	India	O-	rishi.srinivasan254@example.com	Engineer	f	3	Widowed	141038	10255	\N
258	Yashoda	Ekavir	More	1988-01-17	Female	4783617886	02005325119	57/757, Arya Path	libero	Panchkula	Arunachal Pradesh	India	O-	yashoda.more255@example.com	Engineer	f	3	Single	675682	10256	\N
259	Simon		Balakrishnan	1998-06-22	Other	9182662370	+917313003070	H.No. 374, Hans Circle	ipsa	Jalgaon	Goa	India	O+	simon.balakrishnan256@example.com	Farmer	f	3	Married	223703	10257	\N
260	Jeremiah	Yachana	Murthy	1978-06-12	Female	3044869288		38/892\nHayre Marg	aspernatur	Ambarnath	Nagaland	India	B-	jeremiah.murthy257@example.com	Farmer	f	3	Married	218355	10258	\N
261	Kabir	Eta	Morar	1984-10-21	Female	9144724084		36/37\nDoctor Zila	eveniet	Indore	West Bengal	India	AB+	kabir.morar258@example.com	Doctor	t	3	Married	318573	10259	\N
262	Nihal		Pingle	1960-06-01	Female	0009773721		43/92\nThaker Road	nam	Loni	Bihar	India	AB+	nihal.pingle259@example.com	Retired	f	3	Widowed	260087	10260	\N
263	Bhavika		Guha	1996-01-29	Male	0890220833	+912244809957	H.No. 04\nVasa Nagar	eveniet	Serampore	Andhra Pradesh	India	AB+	bhavika.guha260@example.com	Engineer	f	3	Widowed	726325	10261	\N
264	Zashil		Venkataraman	1999-05-02	Male	3528642644		H.No. 42\nArora Street	vitae	Bathinda	Tamil Nadu	India	B-	zashil.venkataraman261@example.com	Teacher	t	3	Single	405274	10262	\N
265	Lekha	Oliver	Bahri	1988-07-01	Other	9521783731	2751221238	10/57\nBhatti Chowk	aliquam	Malda	Tripura	India	A+	lekha.bahri262@example.com	Student	f	3	Single	414360	10263	\N
266	Pavani		Minhas	1982-09-21	Female	0946693873	+913903392911	94/07\nJayaraman Ganj	non	Ambarnath	Telangana	India	O+	pavani.minhas263@example.com	Farmer	t	3	Single	353230	10264	\N
267	Tanmayi		Purohit	1937-06-27	Other	0886687741	3537306526	66\nSundaram Chowk	aut	Bareilly	Madhya Pradesh	India	AB+	tanmayi.purohit264@example.com	Doctor	t	3	Married	151976	10265	\N
268	Reva	Baljiwan	Gala	1944-03-09	Female	0022647536		H.No. 57\nAmble Street	sint	Imphal	Uttarakhand	India	B-	reva.gala265@example.com	Farmer	t	3	Married	528350	10266	\N
269	Harini		Chandran	1989-07-08	Female	0182254121	01100794249	93\nLata Marg	maiores	Proddatur	Assam	India	AB+	harini.chandran266@example.com	Teacher	f	3	Married	627432	10267	\N
270	Gaurang	Barkha	Talwar	1987-10-02	Other	9151408400	6794952304	461\nHayer	sint	Jehanabad	Nagaland	India	O+	gaurang.talwar267@example.com	Retired	t	3	Single	592645	10268	\N
271	Krishna	Nitesh	Pau	1985-08-11	Other	5118946839		H.No. 187, Khanna Marg	ea	Arrah	West Bengal	India	O+	krishna.pau268@example.com	Retired	t	3	Widowed	851654	10269	\N
272	Ekiya	Mohini	Ramachandran	1973-01-07	Other	0870453613	09420161820	379, Parekh	doloremque	Deoghar	Assam	India	O+	ekiya.ramachandran269@example.com	Farmer	t	3	Single	893776	10270	\N
273	Dipta		Nagi	2001-07-12	Other	9187804962	+916269795979	93/00, Chawla Road	esse	Malegaon	Bihar	India	AB-	dipta.nagi270@example.com	Student	f	3	Widowed	205005	10271	\N
274	Shivansh	Yasti	Bawa	1945-12-14	Female	0695649160	3296106959	H.No. 714, Mammen Ganj	laudantium	Anantapuram	Himachal Pradesh	India	O-	shivansh.bawa271@example.com	Retired	f	3	Widowed	399886	10272	\N
275	Faras		Raju	1959-10-22	Other	9108090116		38, Gara Road	earum	Karawal Nagar	Uttar Pradesh	India	AB+	faras.raju272@example.com	Retired	f	3	Widowed	592979	10273	\N
276	Ladli		Dalal	1964-11-11	Female	0144932633		H.No. 78, Chopra Nagar	pariatur	Kulti	Punjab	India	AB+	ladli.dalal273@example.com	Doctor	f	3	Married	840174	10274	\N
277	Joshua	Imaran	Pradhan	1981-01-27	Female	6475236499		H.No. 53\nKaur Ganj	ducimus	Hospet	Goa	India	O-	joshua.pradhan274@example.com	Doctor	f	3	Widowed	950138	10275	\N
278	Dhruv		Sura	1986-05-11	Other	9110501185		54/441\nBir Path	aliquid	Khammam	Bihar	India	AB-	dhruv.sura275@example.com	Student	f	3	Single	327074	10276	\N
279	Simon	Wridesh	Randhawa	1956-06-22	Other	6758143619		H.No. 737\nSarin	consectetur	Gurgaon	Odisha	India	B+	simon.randhawa276@example.com	Student	f	3	Widowed	936496	10277	\N
280	Veda		Kale	1967-08-04	Other	0961748913		H.No. 743, Yohannan Ganj	blanditiis	Coimbatore	Sikkim	India	B+	veda.kale277@example.com	Retired	f	3	Single	950294	10278	\N
281	Tanveer		Subramaniam	1937-12-10	Male	9101222733		10/122, Nadkarni	amet	Purnia	Mizoram	India	A+	tanveer.subramaniam278@example.com	Retired	f	3	Single	442417	10279	\N
282	Anay	Upkaar	Raman	1963-09-23	Female	4348911773		52/924, Taneja Nagar	quasi	Jaipur	Madhya Pradesh	India	O+	anay.raman279@example.com	Student	t	3	Single	035110	10280	\N
283	Harrison		Sharaf	1938-08-16	Other	0714812982	2085143599	H.No. 945\nBhat	hic	Guntakal	Meghalaya	India	O+	harrison.sharaf280@example.com	Retired	f	3	Widowed	911491	10281	\N
284	Vanya	Lajita	Bhatnagar	1978-10-30	Female	0852284518	09891753036	99\nLala Zila	minima	Eluru	Karnataka	India	AB-	vanya.bhatnagar281@example.com	Farmer	t	3	Single	633442	10282	\N
285	Samuel	Qushi	Shere	1943-03-10	Other	0216586406		H.No. 65\nBhasin Road	distinctio	Kota	Himachal Pradesh	India	B+	samuel.shere282@example.com	Student	t	3	Married	845820	10283	\N
286	Zehaan	Gopal	Padmanabhan	1998-06-09	Female	7474947367		H.No. 05, Hora Marg	est	Noida	Uttarakhand	India	AB+	zehaan.padmanabhan283@example.com	Retired	f	3	Married	250369	10284	\N
287	Luke	Akshay	Sibal	1944-01-25	Male	9131370761		630, Parsa Nagar	illo	Machilipatnam	Rajasthan	India	B-	luke.sibal284@example.com	Engineer	t	3	Single	352277	10285	\N
288	Vyanjana	Radha	Sunder	1953-11-02	Other	2952485919	02703729545	87/34, Bawa Circle	voluptatum	Hosur	Mizoram	India	O-	vyanjana.sunder285@example.com	Farmer	t	3	Married	527670	10286	\N
289	Pahal	Brijesh	Dey	1988-03-01	Male	9163273616		304\nGanesh	fugit	Saharsa	Nagaland	India	A+	pahal.dey286@example.com	Engineer	f	3	Widowed	359246	10287	\N
290	Zehaan		Palla	1988-09-29	Male	0083402009		660, Kale Street	corrupti	Mumbai	Gujarat	India	AB-	zehaan.palla287@example.com	Student	f	3	Married	959850	10288	\N
291	Tanmayi		Tella	1993-01-11	Other	9198048281	+911518470844	H.No. 08, Walia Path	saepe	Kochi	Tripura	India	O+	tanmayi.tella288@example.com	Retired	t	3	Married	980679	10289	\N
292	Raksha		Sami	1965-06-27	Male	5834573338	2464274785	55/466, Wason Marg	accusamus	Kumbakonam	Haryana	India	AB+	raksha.sami289@example.com	Doctor	t	3	Widowed	129780	10290	\N
293	Henry	Nisha	Borra	1971-04-28	Female	0515690933	04247675553	650, Tak Road	exercitationem	Bokaro	Goa	India	A-	henry.borra290@example.com	Doctor	f	3	Widowed	214284	10291	\N
294	Oscar	Zaitra	Khare	1936-02-02	Female	3528716519		26/936\nPrakash Nagar	quaerat	Kurnool	Rajasthan	India	A-	oscar.khare291@example.com	Farmer	t	3	Widowed	041459	10292	\N
295	Gaurang	Nitara	Chand	1999-06-17	Other	0548650424	6738086788	45/631, Prasad Zila	maiores	New Delhi	Meghalaya	India	O-	gaurang.chand292@example.com	Doctor	f	3	Single	011133	10293	\N
296	Chaman	Ojas	Manda	1953-02-25	Other	0210080097		H.No. 62, Sarkar Nagar	maxime	Nadiad	Maharashtra	India	AB+	chaman.manda293@example.com	Engineer	f	3	Widowed	017176	10294	\N
297	Ekbal		Gupta	1951-08-23	Other	0235130580		22/97\nGoyal Street	beatae	Bidhannagar	Odisha	India	O+	ekbal.gupta294@example.com	Student	f	3	Single	653715	10295	\N
298	Ria		Sarna	1998-05-15	Female	9191653584		H.No. 58\nShroff Street	quibusdam	Coimbatore	West Bengal	India	AB-	ria.sarna295@example.com	Student	t	3	Widowed	438257	10296	\N
299	Onkar		Shere	2005-12-21	Other	9109477874	09557294122	H.No. 08\nBose Ganj	adipisci	Bardhaman	Uttar Pradesh	India	A-	onkar.shere296@example.com	Farmer	f	3	Single	356730	10297	\N
300	Bhavini		Setty	1999-01-18	Male	9174322930		H.No. 687\nMody Marg	suscipit	Ajmer	Mizoram	India	B+	bhavini.setty297@example.com	Student	t	3	Widowed	665659	10298	\N
301	Wriddhish	Yashoda	Bera	1982-12-10	Other	0403312713	03004098631	22/373\nRanganathan Ganj	error	Tadepalligudem	Sikkim	India	AB-	wriddhish.bera298@example.com	Engineer	t	3	Widowed	147272	10299	\N
302	Qarin	Vyanjana	Deo	1950-12-02	Male	9169898040	05783140360	49/79\nBarad Marg	veritatis	Muzaffarpur	Goa	India	AB-	qarin.deo299@example.com	Teacher	f	3	Married	363032	10300	\N
303	Mason	Janaki	Kalla	1941-05-08	Female	0172205206		56/51, Mukherjee Ganj	ipsam	Naihati	Haryana	India	AB+	mason.kalla300@example.com	Student	t	3	Married	383497	10301	\N
304	Vaishnavi	Darika	Soni	1986-02-13	Other	9108556572		64/256, Sastry Zila	animi	Bardhaman	West Bengal	India	B-	vaishnavi.soni301@example.com	Retired	f	3	Married	494922	10302	\N
305	Jagat		Gokhale	1945-10-30	Female	0797185269	2624555854	81/637, Dhingra Road	assumenda	Pallavaram	Uttar Pradesh	India	O+	jagat.gokhale302@example.com	Doctor	f	3	Married	475714	10303	\N
306	Kai		Chaudhary	1960-05-12	Male	9173752006	07646543861	122, Jaggi Chowk	molestias	Anantapuram	Punjab	India	B+	kai.chaudhary303@example.com	Retired	t	3	Single	665191	10304	\N
307	Dev	Sudiksha	Dua	1962-01-31	Male	0358693035		H.No. 431\nDevi	distinctio	Bhiwandi	Sikkim	India	B-	dev.dua304@example.com	Doctor	t	3	Single	509994	10305	\N
308	Zinal		Bhat	2000-02-10	Male	7272457904	07293673306	201, Bahl Ganj	molestiae	Faridabad	Maharashtra	India	O+	zinal.bhat305@example.com	Farmer	t	3	Widowed	170416	10306	\N
309	Ekta	Sanaya	Mahal	1961-06-28	Male	4363576195	0387578739	H.No. 20, Mani Zila	doloribus	Noida	Tripura	India	B-	ekta.mahal306@example.com	Engineer	t	3	Single	367552	10307	\N
310	Warjas	Yauvani	Srinivasan	1955-03-16	Other	0706044259		82/89\nLoke Path	reprehenderit	Amroha	Arunachal Pradesh	India	A+	warjas.srinivasan307@example.com	Farmer	f	3	Single	239234	10308	\N
311	Yamini		Murty	1974-09-02	Other	0068750521		143\nGara Road	necessitatibus	Jehanabad	Meghalaya	India	O-	yamini.murty308@example.com	Farmer	f	3	Married	944179	10309	\N
312	Amaira		Mani	1944-09-05	Female	2529537838	6461131407	28\nIssac Zila	rem	Raiganj	Chhattisgarh	India	B+	amaira.mani309@example.com	Engineer	t	3	Single	732105	10310	\N
313	Ira	Zayyan	Grewal	1992-09-05	Other	0962884936		28\nSolanki	laborum	Tirunelveli	Tripura	India	AB+	ira.grewal310@example.com	Retired	f	3	Widowed	104755	10311	\N
314	Aadi		Raman	1939-11-22	Other	0044598710		97/85, Venkataraman Marg	sed	Khora 	Rajasthan	India	O+	aadi.raman311@example.com	Student	f	3	Single	963915	10312	\N
315	Anamika	Praneel	Agarwal	1990-09-28	Female	6482944546		648\nKrish Chowk	atque	New Delhi	Tamil Nadu	India	O+	anamika.agarwal312@example.com	Farmer	f	3	Single	087982	10313	\N
316	Nicholas	Bishakha	Choudhry	2005-06-04	Other	8900519509	06313657705	42/71, Ghose Road	voluptatum	Hajipur	Jharkhand	India	B+	nicholas.choudhry313@example.com	Retired	t	3	Single	678254	10314	\N
317	Dev	Sara	Ramakrishnan	2005-03-09	Other	4166804962		326\nKrishnan Circle	aliquid	Motihari	Sikkim	India	B+	dev.ramakrishnan314@example.com	Student	f	3	Married	061342	10315	\N
318	Kala		Manda	1961-02-23	Female	2112372089	+914303003327	83\nHans Ganj	nesciunt	Gopalpur	Andhra Pradesh	India	B-	kala.manda315@example.com	Student	t	3	Widowed	860765	10316	\N
319	Yauvani	Vyanjana	Pandya	1974-04-20	Other	0257838696	+917972889960	H.No. 686, Kanda Road	blanditiis	Jalandhar	Nagaland	India	O+	yauvani.pandya316@example.com	Engineer	t	3	Widowed	038477	10317	\N
320	Andrew	Brinda	Saini	2007-04-20	Other	8565580252		42, Hora Circle	nesciunt	Jammu	Meghalaya	India	B-	andrew.saini317@example.com	Engineer	f	3	Married	795594	10318	\N
321	Christopher		Kala	1991-11-20	Male	4835313667		925\nSabharwal Nagar	exercitationem	Orai	Rajasthan	India	A-	christopher.kala318@example.com	Engineer	t	3	Widowed	957976	10319	\N
322	Guneet		Luthra	2002-01-05	Male	0769616453	+916892233295	H.No. 90, Madan Chowk	illo	Bareilly	Chhattisgarh	India	B+	guneet.luthra319@example.com	Teacher	t	3	Widowed	918371	10320	\N
323	Chandani		Parmar	1950-04-01	Male	8365445132		H.No. 819\nOza Road	eaque	Karimnagar	Bihar	India	O-	chandani.parmar320@example.com	Retired	f	3	Single	747407	10321	\N
324	Chakradev		Shanker	1999-07-29	Male	0213251182	03640648065	92, Sharma Road	quod	Etawah	Meghalaya	India	A+	chakradev.shanker321@example.com	Teacher	f	3	Single	418943	10322	\N
325	Jhalak	Ati	Murthy	2001-10-25	Other	9153277503	07175784254	H.No. 950, Seshadri Zila	modi	Karnal	Kerala	India	B+	jhalak.murthy322@example.com	Doctor	t	3	Single	600284	10323	\N
326	Nachiket	Vasana	Sem	1973-02-25	Other	0852330572	+917778932723	71\nKakar Marg	blanditiis	Noida	Tamil Nadu	India	AB+	nachiket.sem323@example.com	Engineer	t	3	Married	305798	10324	\N
327	Yamini	Dev	Sarraf	1964-04-19	Male	9130929321		44/175\nDua Zila	repudiandae	Kozhikode	Nagaland	India	O-	yamini.sarraf324@example.com	Engineer	f	3	Widowed	490694	10325	\N
328	Advik	Karan	Maharaj	1985-03-04	Other	8864533720	+919908254336	824, Dhingra Ganj	excepturi	Sangli-Miraj & Kupwad	Madhya Pradesh	India	B+	advik.maharaj325@example.com	Doctor	t	3	Widowed	007408	10326	\N
329	Kevin		Nori	1937-08-13	Other	0987495226	0703250169	440, Lad Circle	quibusdam	Vadodara	Chhattisgarh	India	O-	kevin.nori326@example.com	Teacher	f	3	Widowed	686729	10327	\N
330	Anmol	Bina	Gokhale	2003-05-17	Other	0433967348	3253254495	H.No. 94, Brahmbhatt Street	quae	Ambattur	Telangana	India	A+	anmol.gokhale327@example.com	Farmer	t	3	Married	408855	10328	\N
331	Forum	Bhavani	Nayar	1997-06-18	Other	0023286343	0790328060	H.No. 69\nRana Marg	animi	Thiruvananthapuram	Telangana	India	AB-	forum.nayar328@example.com	Doctor	t	3	Married	841303	10329	\N
332	Nandini	Rajeshri	Khanna	1963-12-04	Male	9148461735	9786527747	79/642, Sehgal Chowk	harum	Ujjain	Andhra Pradesh	India	A-	nandini.khanna329@example.com	Engineer	f	3	Widowed	888994	10330	\N
333	Michael		Gaba	2006-04-07	Male	0071819989	7591135878	24/801, Master Circle	velit	Ambattur	Manipur	India	O+	michael.gaba330@example.com	Engineer	f	3	Widowed	595331	10331	\N
334	Waida	Gopal	Parikh	1953-10-04	Other	0925944196	9801670319	34/89, Jha Street	ipsa	Udupi	Telangana	India	A+	waida.parikh331@example.com	Teacher	t	3	Widowed	173869	10332	\N
335	Keya	Tanmayi	Vala	1960-02-05	Female	0381377193	07755554842	H.No. 726, Sama Marg	consectetur	Jhansi	West Bengal	India	A-	keya.vala332@example.com	Teacher	t	3	Single	418014	10333	\N
336	Vedant	Unni	Banik	1964-05-19	Other	6636982196		40/119\nNaik Nagar	repellendus	Jamnagar	Gujarat	India	O+	vedant.banik333@example.com	Retired	t	3	Married	189028	10334	\N
337	Faras	Samar	Uppal	2006-01-28	Other	0432094079	3614672239	40/022, Parsa Chowk	modi	Tumkur	Rajasthan	India	A+	faras.uppal334@example.com	Doctor	f	3	Married	194091	10335	\N
338	Kamya		Basak	1998-02-01	Male	9135696371		184, Gopal Road	eveniet	North Dumdum	West Bengal	India	B+	kamya.basak335@example.com	Engineer	t	3	Widowed	989433	10336	\N
339	Faraj		Chatterjee	1981-07-12	Other	0946430453		31/40\nBhakta Ganj	non	Motihari	Meghalaya	India	A-	faraj.chatterjee336@example.com	Farmer	f	3	Married	030543	10337	\N
340	Zehaan		Magar	2002-02-17	Male	9155575840		H.No. 69\nManda Circle	officiis	Chandigarh	Meghalaya	India	O+	zehaan.magar337@example.com	Doctor	f	3	Single	477649	10338	\N
341	Hardik		Salvi	1942-01-20	Female	0658241157	+915622831422	717, Chadha Circle	explicabo	Dhanbad	Bihar	India	AB-	hardik.salvi338@example.com	Farmer	f	3	Single	004331	10339	\N
342	Vasana		Som	1941-09-04	Other	6212458168	04652007361	H.No. 68\nDara Road	optio	Srikakulam	Uttar Pradesh	India	AB-	vasana.som339@example.com	Retired	f	3	Married	048744	10340	\N
343	Abhiram	Omya	Sankar	1962-03-16	Female	9141600201		31\nMitter Ganj	placeat	Ongole	Mizoram	India	A+	abhiram.sankar340@example.com	Student	t	3	Widowed	949866	10341	\N
344	Gautam		Krish	1937-06-10	Female	0289500151	1940910534	H.No. 97\nNatarajan Path	voluptatem	Bhilwara	Haryana	India	O+	gautam.krish341@example.com	Farmer	f	3	Married	092155	10342	\N
345	Tristan	Megha	Srivastava	1949-05-02	Female	0660392251	+910176573210	90\nChana Road	temporibus	Bardhaman	Himachal Pradesh	India	A+	tristan.srivastava342@example.com	Doctor	t	3	Single	613279	10343	\N
346	Anvi		Chaudhry	1959-07-21	Female	1836003784		01, Vaidya Nagar	fuga	Vijayawada	Odisha	India	B+	anvi.chaudhry343@example.com	Retired	f	3	Single	724348	10344	\N
347	Aarush		Walia	1936-06-24	Male	9136771918	4539320536	90/336\nGarg Nagar	molestiae	Thane	Maharashtra	India	O+	aarush.walia344@example.com	Engineer	f	3	Widowed	136835	10345	\N
348	Radhika		Arora	1995-05-27	Other	0312082882		90/29\nRanganathan Ganj	explicabo	Hazaribagh	Uttar Pradesh	India	B+	radhika.arora345@example.com	Doctor	f	3	Widowed	030682	10346	\N
349	Vritti		Devi	1950-05-08	Female	9162349567	9183454106	H.No. 02\nSachar Path	eveniet	Nellore	Uttar Pradesh	India	O-	vritti.devi346@example.com	Student	t	3	Married	020496	10347	\N
350	Rachit		Bhatt	1972-06-15	Other	0015733601	01381610556	402, Chaudhari Path	consequatur	Mirzapur	Telangana	India	A-	rachit.bhatt347@example.com	Teacher	f	3	Married	572996	10348	\N
351	Oeshi	Dhruv	Mahal	1971-06-02	Male	0921568875	3157554685	H.No. 36\nMadan Street	corrupti	Jorhat	Odisha	India	O-	oeshi.mahal348@example.com	Student	t	3	Widowed	256998	10349	\N
352	Orinder		Goda	1955-02-26	Other	3396505584		H.No. 049\nGara Marg	debitis	Dewas	Andhra Pradesh	India	A-	orinder.goda349@example.com	Farmer	t	3	Single	719204	10350	\N
353	Advaith	Kritika	Patla	1935-09-27	Female	9122578020	03646192875	654, Chokshi Circle	nihil	Cuttack	Rajasthan	India	AB-	advaith.patla350@example.com	Engineer	t	3	Married	324882	10351	\N
354	Mason	Rachana	Sem	1981-07-07	Other	7792967249	+915122612108	328, Manne	placeat	Amaravati	West Bengal	India	O-	mason.sem351@example.com	Engineer	f	3	Married	995139	10352	\N
355	Sai	Osha	Golla	1934-07-06	Other	9110376099		55/908, Saini Marg	qui	North Dumdum	Karnataka	India	B-	sai.golla352@example.com	Retired	f	3	Married	616984	10353	\N
356	Aashi	Pushti	Pathak	1976-07-30	Male	9115933691		79/17, Balay Chowk	alias	Hindupur	Sikkim	India	O-	aashi.pathak353@example.com	Doctor	t	3	Widowed	172327	10354	\N
357	Bhanumati	Libni	Taneja	1961-11-04	Female	0126373734		710\nAmble Street	soluta	Loni	Tripura	India	B+	bhanumati.taneja354@example.com	Farmer	f	3	Single	376905	10355	\N
358	Hiral	Jai	Atwal	1968-04-09	Female	1489003225		H.No. 423\nJayaraman Nagar	sit	Warangal	Gujarat	India	A+	hiral.atwal355@example.com	Farmer	f	3	Single	285957	10356	\N
359	Priya	Pratyush	Luthra	1993-03-09	Female	0701806227		H.No. 323\nContractor Ganj	deserunt	Panchkula	West Bengal	India	B+	priya.luthra356@example.com	Retired	t	3	Widowed	778388	10357	\N
360	Samarth	Madhavi	Loyal	1947-11-15	Female	9101066494	08070700397	35/202, Tank Ganj	provident	Ahmedabad	Mizoram	India	O+	samarth.loyal357@example.com	Farmer	t	3	Single	715720	10358	\N
361	Chasmum	Sai	Khalsa	1950-06-27	Other	0183042845	00897970747	H.No. 01\nBhavsar Nagar	voluptate	Mau	Chhattisgarh	India	AB-	chasmum.khalsa358@example.com	Doctor	f	3	Widowed	101102	10359	\N
362	Irya		Vora	1983-07-12	Other	9143181208		H.No. 122\nRajan Ganj	iste	Alwar	Karnataka	India	AB-	irya.vora359@example.com	Student	t	3	Married	104313	10360	\N
363	Vedant		Sathe	2003-01-08	Male	9134075444	4968482254	85/89, Bawa Marg	dolorum	Berhampore	Rajasthan	India	O-	vedant.sathe360@example.com	Teacher	f	3	Widowed	696494	10361	\N
364	Sathvik		Chanda	1985-05-23	Other	9124318250	+917905852557	H.No. 986\nVaidya Nagar	odio	Thoothukudi	Telangana	India	B-	sathvik.chanda361@example.com	Farmer	f	3	Single	448202	10362	\N
365	Advik		Aurora	1968-11-15	Female	9147154436		H.No. 86\nSarna Circle	velit	Yamunanagar	Uttarakhand	India	AB-	advik.aurora362@example.com	Teacher	f	3	Single	069411	10363	\N
366	Jasmit	Niharika	Bains	1995-04-18	Female	9140747530		769, Anand Circle	aspernatur	Bhind	Uttarakhand	India	O-	jasmit.bains363@example.com	Engineer	t	3	Married	905603	10364	\N
367	Kai		Kamdar	1943-02-06	Male	0389199645	07079243151	92/45, Mandal Marg	dolore	Bokaro	Madhya Pradesh	India	A-	kai.kamdar364@example.com	Teacher	f	3	Married	414654	10365	\N
368	Naksh	Chakradev	Parsa	1955-12-01	Other	0815329203	06550918416	10, Bhakta Path	sunt	Miryalaguda	Telangana	India	O-	naksh.parsa365@example.com	Teacher	t	3	Single	395562	10366	\N
369	Abhiram	Pooja	Dhillon	1962-05-30	Other	9149630888	+914150981386	198\nDivan Chowk	ut	Khora 	Himachal Pradesh	India	O+	abhiram.dhillon366@example.com	Doctor	f	3	Single	956927	10367	\N
370	Kala	Shivani	Andra	1936-03-10	Female	0206267692		20/45, Vaidya Road	temporibus	Jehanabad	Sikkim	India	A+	kala.andra367@example.com	Doctor	f	3	Married	241601	10368	\N
371	Tara		Goel	1994-06-01	Female	9119944313	00842281945	07/40\nBiswas Marg	sint	Bhimavaram	Goa	India	O-	tara.goel368@example.com	Farmer	f	3	Widowed	715133	10369	\N
372	Kiaan		Tank	2007-05-22	Male	0934442441		38/357, Minhas Zila	ad	Bidar	Uttarakhand	India	A+	kiaan.tank369@example.com	Farmer	f	3	Widowed	937736	10370	\N
373	Udarsh	Noah	Tak	2001-08-27	Male	3072645839		93/488, Shenoy	dicta	Bongaigaon	Nagaland	India	AB+	udarsh.tak370@example.com	Farmer	t	3	Single	428172	10371	\N
374	Ira	Radhika	Gour	1951-09-28	Male	9153889266	+911661904529	173\nBava Chowk	dicta	Kulti	Sikkim	India	A+	ira.gour371@example.com	Teacher	f	3	Married	549772	10372	\N
375	Tarak	Kalpit	Savant	2005-10-01	Male	0590801627		H.No. 73\nTrivedi Chowk	tenetur	Madhyamgram	Rajasthan	India	O+	tarak.savant372@example.com	Retired	t	3	Single	259573	10373	\N
376	Azaan	Chameli	Iyer	1947-08-13	Other	9101783561		146, Sridhar	ab	Patiala	Gujarat	India	A-	azaan.iyer373@example.com	Student	t	3	Single	041704	10374	\N
377	Viraj		Mitter	1951-01-08	Other	9174035871	+916800080278	H.No. 74, Khosla Road	consectetur	Madurai	West Bengal	India	O+	viraj.mitter374@example.com	Farmer	f	3	Single	499599	10375	\N
378	Ikbal		Chada	1937-09-17	Female	5394856492	+913555580096	H.No. 70\nPrashad	sit	Sagar	Jharkhand	India	A+	ikbal.chada375@example.com	Retired	t	3	Single	069488	10376	\N
379	Darika	Netra	Kaur	2003-03-31	Female	2698886108		H.No. 86\nTaneja Marg	provident	Rohtak	Maharashtra	India	AB-	darika.kaur376@example.com	Farmer	f	3	Widowed	506358	10377	\N
380	Dalbir	Vrinda	Pau	1985-12-21	Male	9164952184	+916595225858	579\nGuha Path	esse	Sagar	Uttarakhand	India	O-	dalbir.pau377@example.com	Engineer	t	3	Married	682975	10378	\N
381	Sneha		Butala	1941-09-19	Other	9147233119	06630238422	47/782, Pillai Chowk	iste	Jalgaon	Goa	India	AB-	sneha.butala378@example.com	Engineer	f	3	Single	467206	10379	\N
382	Vedhika		Sridhar	1936-02-06	Female	0061715378	07177633993	H.No. 091, Kashyap Chowk	hic	Gorakhpur	Manipur	India	B-	vedhika.sridhar379@example.com	Farmer	t	3	Widowed	638129	10380	\N
383	Ati	Anirudh	Bali	2004-04-19	Female	7808950241	9947035525	22/294, Sanghvi Road	atque	Hospet	Sikkim	India	AB-	ati.bali380@example.com	Engineer	t	3	Widowed	960777	10381	\N
384	Yatan	Manthan	Thaker	1990-09-09	Other	9183812348	+911394263508	H.No. 084\nKorpal Nagar	deserunt	Udaipur	Andhra Pradesh	India	A-	yatan.thaker381@example.com	Doctor	t	3	Widowed	317131	10382	\N
385	Amrita	Vrishti	Sanghvi	1987-06-02	Female	0787775617		99/79, Arora Street	perferendis	Tumkur	Jharkhand	India	A-	amrita.sanghvi382@example.com	Farmer	t	3	Single	805941	10383	\N
386	Ansh		Venkatesh	1990-08-23	Female	0593878710		02\nRatti Path	temporibus	Ballia	Rajasthan	India	A+	ansh.venkatesh383@example.com	Retired	t	3	Married	377900	10384	\N
387	Yatin		Seshadri	1969-06-26	Male	6571424516		28/770\nLall Circle	recusandae	Gurgaon	Karnataka	India	AB-	yatin.seshadri384@example.com	Farmer	f	3	Single	006008	10385	\N
388	Champak		Singhal	1940-04-19	Other	0749235409	+918074365817	735, Pandya	natus	Akola	Rajasthan	India	O+	champak.singhal385@example.com	Doctor	t	3	Married	516733	10386	\N
389	Yug	Dayita	Bhatnagar	1979-10-07	Male	0416139077	6549060706	H.No. 72\nShah Ganj	aspernatur	Amroha	Mizoram	India	B-	yug.bhatnagar386@example.com	Teacher	t	3	Married	759130	10387	\N
390	Alexander		Upadhyay	1944-04-13	Male	0234319008	08951421256	H.No. 505\nRajagopalan Marg	amet	Pimpri-Chinchwad	Jharkhand	India	O+	alexander.upadhyay387@example.com	Teacher	f	3	Widowed	493428	10388	\N
391	Hredhaan	Lakshmi	Chadha	1986-10-26	Female	9179714846	+917767971210	60/64\nGuha Nagar	molestiae	Chandigarh	Karnataka	India	O-	hredhaan.chadha388@example.com	Engineer	f	3	Widowed	275369	10389	\N
392	Chatresh		Mahal	1943-05-29	Male	4405809930		04, Doshi Marg	minima	Serampore	Andhra Pradesh	India	O+	chatresh.mahal389@example.com	Engineer	f	3	Widowed	901614	10390	\N
393	Nisha	Saumya	Sampath	1944-12-13	Male	9155441733		542, Gopal Nagar	itaque	Hosur	Madhya Pradesh	India	A-	nisha.sampath390@example.com	Teacher	f	3	Married	173638	10391	\N
394	Mitesh	Owen	Sachdeva	1941-10-04	Male	0363138132	+916412482043	842, Raghavan Road	quasi	Bareilly	Karnataka	India	AB-	mitesh.sachdeva391@example.com	Student	t	3	Widowed	022282	10392	\N
395	Dev		Vig	1967-03-13	Male	0125357782	06135058071	50, Grewal Path	voluptates	Maheshtala	Manipur	India	B-	dev.vig392@example.com	Engineer	f	3	Single	582023	10393	\N
396	Vincent		Narang	1977-04-14	Male	9120787541		50/38\nSanghvi Path	eius	Farrukhabad	Punjab	India	A+	vincent.narang393@example.com	Student	f	3	Widowed	973830	10394	\N
397	Wridesh		Comar	1999-03-28	Male	9121789498		H.No. 20\nMane Circle	earum	Madurai	Himachal Pradesh	India	O+	wridesh.comar394@example.com	Farmer	t	3	Married	864714	10395	\N
398	Barkha	Omkaar	Chacko	1966-12-05	Other	1749061343		55/55, Barad Circle	fugit	Kavali	Sikkim	India	A-	barkha.chacko395@example.com	Doctor	f	3	Married	923229	10396	\N
399	Idika		Mander	1958-08-06	Female	4825009791		401\nSrivastava Nagar	asperiores	Bahraich	Chhattisgarh	India	B-	idika.mander396@example.com	Retired	f	3	Married	038656	10397	\N
400	Nimrat	Ayushman	Lal	2001-04-17	Other	8632766367	02601757512	48/60\nPatla Path	debitis	Indore	Punjab	India	B-	nimrat.lal397@example.com	Student	f	3	Married	183521	10398	\N
401	Faqid	Anthony	Mody	1946-06-20	Male	9903625178	07469908532	37/400, Kibe Chowk	amet	Chandrapur	Rajasthan	India	B+	faqid.mody398@example.com	Doctor	f	3	Single	807386	10399	\N
402	Adweta	Ria	Dora	1950-02-27	Other	6477140560	01648724983	76/303\nKapur Street	officia	Shivpuri	Himachal Pradesh	India	AB-	adweta.dora399@example.com	Student	f	3	Single	248629	10400	\N
403	Christopher		Dhillon	1977-10-31	Other	9162015885		58/309\nGhosh Street	necessitatibus	Davanagere	Gujarat	India	AB+	christopher.dhillon400@example.com	Teacher	f	3	Single	501189	10401	\N
404	Meghana	Laban	Setty	1970-07-21	Female	8434778367		H.No. 293\nThaman Street	saepe	Udupi	Maharashtra	India	AB+	meghana.setty401@example.com	Retired	f	3	Widowed	622095	10402	\N
405	Urvashi		Verma	2002-01-30	Female	9150677991		13/71\nChad Circle	animi	Shahjahanpur	Assam	India	O+	urvashi.verma402@example.com	Farmer	t	3	Single	630616	10403	\N
406	Vincent		Gera	2003-12-22	Other	6019272720		H.No. 46\nManne Chowk	sapiente	Chandrapur	Kerala	India	B-	vincent.gera403@example.com	Engineer	t	3	Married	115262	10404	\N
407	Chavvi	Wridesh	Dash	1992-11-11	Female	9126099157		H.No. 57, Mandal Zila	corporis	Sambhal	Sikkim	India	O-	chavvi.dash404@example.com	Farmer	t	3	Widowed	654809	10405	\N
408	Daniel	Avni	Andra	1985-05-28	Other	9103853467		418, Kumar Road	quas	Davanagere	Maharashtra	India	O+	daniel.andra405@example.com	Doctor	t	3	Married	548314	10406	\N
409	Vaishnavi		Brar	1984-09-14	Male	9134042676	02733747786	095, Thaman Ganj	esse	Thiruvananthapuram	Arunachal Pradesh	India	B-	vaishnavi.brar406@example.com	Farmer	t	3	Single	937831	10407	\N
410	Rudra	Shivansh	Das	1983-07-20	Female	0888364994	8810248443	033, Mannan Zila	culpa	Jamalpur	Odisha	India	A+	rudra.das407@example.com	Teacher	f	3	Single	978940	10408	\N
411	Divya	Bhanumati	Vala	2000-02-20	Other	5353176919	+910411061857	04/32, Jha Marg	quos	Kavali	Meghalaya	India	O+	divya.vala408@example.com	Engineer	t	3	Widowed	041686	10409	\N
412	Yashica	Aadi	Borra	1987-02-16	Female	0325331434		32\nSaran Zila	reiciendis	Kottayam	Maharashtra	India	AB+	yashica.borra409@example.com	Doctor	t	3	Widowed	097503	10410	\N
413	Naksh		Aggarwal	1984-01-21	Other	0106899092	9907123673	H.No. 11, Vohra Path	saepe	Firozabad	Kerala	India	O-	naksh.aggarwal410@example.com	Engineer	t	3	Single	005366	10411	\N
414	Diya	Ranveer	Dada	1998-09-01	Other	1232098701	2281943362	H.No. 917, Prabhu Street	dolorem	Tirunelveli	Rajasthan	India	O-	diya.dada411@example.com	Farmer	t	3	Married	385869	10412	\N
415	Omisha		Joshi	1967-01-13	Female	0582397687		502\nDin Path	amet	Hajipur	Uttar Pradesh	India	AB+	omisha.joshi412@example.com	Doctor	t	3	Widowed	194446	10413	\N
416	Azad	Balveer	Barad	1948-02-07	Other	7022029174	08499075152	779, Dada Circle	nostrum	Raiganj	Karnataka	India	B+	azad.barad413@example.com	Doctor	t	3	Single	761525	10414	\N
417	Prisha	Vasana	Radhakrishnan	2000-10-22	Female	9114199429	4720470056	H.No. 91\nPeri Circle	accusamus	Bokaro	Punjab	India	B-	prisha.radhakrishnan414@example.com	Engineer	t	3	Widowed	718162	10415	\N
418	Champak	Chanchal	Goswami	1967-08-12	Other	7685405854		H.No. 388, Ganesh Chowk	asperiores	Sagar	Uttar Pradesh	India	O-	champak.goswami415@example.com	Farmer	t	3	Single	777601	10416	\N
419	Vasudha		Saxena	2004-03-17	Male	7931452111	+917038743603	852\nShenoy Circle	a	Motihari	Karnataka	India	B-	vasudha.saxena416@example.com	Retired	t	3	Single	972529	10417	\N
420	Indira	Aarnav	Bumb	1981-06-05	Female	6532656272	6819232944	73\nTailor Path	adipisci	Hubli–Dharwad	Uttarakhand	India	AB+	indira.bumb417@example.com	Retired	f	3	Married	493092	10418	\N
421	Mahika		Bhasin	2005-11-14	Male	2083700972		25/15\nDutta Circle	molestiae	Giridih	Manipur	India	A+	mahika.bhasin418@example.com	Student	f	3	Single	662828	10419	\N
422	Yashoda		Chander	1995-11-21	Female	9175170916		53, Kaur Nagar	similique	Muzaffarnagar	Meghalaya	India	O+	yashoda.chander419@example.com	Student	t	3	Single	238219	10420	\N
423	Dayita		Karan	1971-04-13	Male	9158196338		46/46, Chatterjee Road	totam	Bijapur	Bihar	India	B-	dayita.karan420@example.com	Engineer	f	3	Married	155769	10421	\N
424	Shivani		Raju	1998-08-05	Other	9159190917	+916594116526	H.No. 823, Khurana Ganj	a	Tirupati	Rajasthan	India	O-	shivani.raju421@example.com	Doctor	t	3	Single	381708	10422	\N
425	Vasana		Tara	1936-07-02	Female	9164257662		82/02\nSood Nagar	itaque	Jaipur	Tripura	India	B+	vasana.tara422@example.com	Student	t	3	Widowed	737991	10423	\N
426	Zayan	Hemani	Kara	1961-02-12	Female	5468712916	+918115986313	H.No. 886, Dhaliwal Nagar	quis	Kolkata	Nagaland	India	O-	zayan.kara423@example.com	Engineer	f	3	Widowed	379392	10424	\N
427	Siya		Mishra	1944-10-29	Other	9130692458	+915773382084	H.No. 225\nGara Street	qui	Sri Ganganagar	Jharkhand	India	B+	siya.mishra424@example.com	Student	f	3	Single	357311	10425	\N
428	Panini		Ranganathan	1961-09-13	Other	9131941630		70/186, Ganesan	enim	Visakhapatnam	Bihar	India	O+	panini.ranganathan425@example.com	Teacher	f	3	Widowed	594298	10426	\N
429	Udant		Bhargava	2000-01-13	Male	9168802498	+914474972070	72/72\nSengupta Nagar	quo	Narasaraopet	Odisha	India	O-	udant.bhargava426@example.com	Student	f	3	Single	777034	10427	\N
430	Gaurang		Singh	1949-01-29	Male	0434570538		10\nShankar Street	ab	Panchkula	Odisha	India	B+	gaurang.singh427@example.com	Farmer	f	3	Married	499253	10428	\N
431	Nicholas	Devansh	Sem	2002-07-29	Male	0534183745		95/713\nVenkataraman Path	delectus	Cuttack	Himachal Pradesh	India	O-	nicholas.sem428@example.com	Farmer	t	3	Widowed	781949	10429	\N
432	Hemani	Chakradhar	Choudhary	1964-05-04	Female	0530033340		14/241, Banik Marg	consequatur	Jehanabad	Andhra Pradesh	India	A+	hemani.choudhary429@example.com	Student	t	3	Widowed	716208	10430	\N
433	Advaith		Kar	2000-11-15	Other	7988491735		54/43\nDhar	tempore	Chandigarh	Uttarakhand	India	B+	advaith.kar430@example.com	Engineer	t	3	Married	605471	10431	\N
434	Hritik	Wyatt	Rattan	1949-05-06	Female	9120219568		H.No. 09, Barad Road	harum	Anantapur	Maharashtra	India	O-	hritik.rattan431@example.com	Doctor	f	3	Widowed	713353	10432	\N
435	Gagan		Patel	1937-04-19	Male	3947233809	9313923904	H.No. 76, Vaidya Ganj	eum	Kanpur	West Bengal	India	B-	gagan.patel432@example.com	Student	t	3	Widowed	535706	10433	\N
436	Chaman	Vasana	Thaman	1963-11-01	Female	9119889102	09306283658	893\nNazareth Marg	quo	Mathura	Sikkim	India	AB-	chaman.thaman433@example.com	Retired	t	3	Widowed	418382	10434	\N
437	Samarth	Chaitanya	Suresh	1994-07-24	Male	7917503291		33, Chatterjee Zila	voluptatum	Pudukkottai	Tripura	India	A-	samarth.suresh434@example.com	Engineer	f	3	Single	136566	10435	\N
438	Odika		Deshpande	1963-02-12	Female	2191931094	07628267943	H.No. 73\nDoshi Marg	ex	Dibrugarh	Chhattisgarh	India	O-	odika.deshpande435@example.com	Student	f	3	Married	813902	10436	\N
439	Ekansh		Lad	1942-11-15	Other	9136986578	+916884474809	99/295, Salvi	ab	New Delhi	Himachal Pradesh	India	B+	ekansh.lad436@example.com	Engineer	t	3	Widowed	356813	10437	\N
440	Kritika	Yagnesh	Chakrabarti	1965-01-12	Other	0968792869		28, Jain Circle	beatae	Sultan Pur Majra	Karnataka	India	O+	kritika.chakrabarti437@example.com	Teacher	f	3	Single	921927	10438	\N
441	Indrajit		Sidhu	1956-10-14	Other	5568464511		18/858, Dani Circle	beatae	Bhiwandi	Karnataka	India	O-	indrajit.sidhu438@example.com	Student	t	3	Married	456449	10439	\N
442	Vidhi		Tata	1998-09-23	Female	8145663602	0290718126	H.No. 10, Saini Path	quibusdam	Loni	Meghalaya	India	A-	vidhi.tata439@example.com	Student	f	3	Married	750524	10440	\N
443	Kevin		Batra	1976-04-24	Male	0984141290	7507603816	H.No. 18, Mangal Road	accusantium	Ongole	Sikkim	India	O-	kevin.batra440@example.com	Doctor	f	3	Single	100647	10441	\N
444	Varsha	Yashodhara	Soni	1958-03-31	Other	0317966302		H.No. 529\nParikh Ganj	quos	Durg	Himachal Pradesh	India	A-	varsha.soni441@example.com	Teacher	f	3	Married	875700	10442	\N
445	Meghana	Charan	Bhatt	1969-11-01	Female	0385656115	4862767656	24\nMall Path	commodi	Ichalkaranji	Goa	India	A-	meghana.bhatt442@example.com	Retired	f	3	Married	516911	10443	\N
446	Isha	Krishna	Venkatesh	1943-05-15	Other	0925869026	4838359738	52\nUpadhyay Path	numquam	Hyderabad	Chhattisgarh	India	AB+	isha.venkatesh443@example.com	Farmer	f	3	Widowed	201666	10444	\N
447	Forum	Veer	Karnik	1936-10-14	Female	0750638702		52/792, Tata Zila	dicta	Anantapur	Nagaland	India	A+	forum.karnik444@example.com	Engineer	f	3	Single	355108	10445	\N
448	Varsha		Madan	1942-08-14	Male	0009467393	+910719839262	H.No. 710\nGarde Zila	expedita	Guna	Maharashtra	India	B-	varsha.madan445@example.com	Engineer	t	3	Married	049036	10446	\N
449	Chandani	Lopa	Wadhwa	1948-12-28	Female	8534073489		30\nPalla Circle	voluptas	Thrissur	Jharkhand	India	B-	chandani.wadhwa446@example.com	Retired	t	3	Single	645550	10447	\N
450	Wazir		Dara	1999-11-23	Other	0731799675	1403801401	09\nNath Nagar	dolore	Belgaum	Odisha	India	B+	wazir.dara447@example.com	Student	t	3	Single	084557	10448	\N
451	Kala		Jain	1978-01-30	Female	0322233016	+913008027331	233\nKrishna Path	earum	Akola	Rajasthan	India	A+	kala.jain448@example.com	Retired	t	3	Married	257293	10449	\N
452	Harini		Rastogi	1984-09-27	Other	0386368711		33/81\nSabharwal Ganj	quaerat	Shimla	Jharkhand	India	B+	harini.rastogi449@example.com	Doctor	t	3	Single	407777	10450	\N
453	Suhani	Jackson	Rastogi	1938-01-13	Female	5336353267		H.No. 56\nAhuja Marg	ab	Machilipatnam	Goa	India	A-	suhani.rastogi450@example.com	Farmer	f	3	Married	174479	10451	\N
454	Kai	Prisha	Sarma	1989-11-06	Female	1718507652	2681350199	74\nChaudhary Zila	ad	Narasaraopet	Punjab	India	AB-	kai.sarma451@example.com	Farmer	t	3	Widowed	735366	10452	\N
455	Bhavika		Sachdev	1940-07-24	Male	0877854407		97/527, Mishra Street	illo	Tezpur	Manipur	India	B-	bhavika.sachdev452@example.com	Retired	t	3	Widowed	722949	10453	\N
456	Xalak	Karan	Gour	1985-01-17	Male	9127832964		513\nLal Nagar	libero	Durg	Chhattisgarh	India	A-	xalak.gour453@example.com	Engineer	t	3	Single	737848	10454	\N
457	Tarak	Yashasvi	Pal	1955-03-03	Male	0557474658	07192231052	98, Vora Path	quas	Chandrapur	Rajasthan	India	AB-	tarak.pal454@example.com	Teacher	t	3	Single	621495	10455	\N
458	Zansi		Venkatesh	1955-06-11	Other	9656770464		320\nDada Zila	temporibus	Bhavnagar	Punjab	India	B-	zansi.venkatesh455@example.com	Student	f	3	Widowed	257779	10456	\N
459	Chandran	Hemang	Palla	1991-09-21	Male	0700660237		06, Sibal Marg	sit	Kavali	Mizoram	India	A+	chandran.palla456@example.com	Teacher	f	3	Single	676263	10457	\N
460	Bhavini	Bhavini	Chatterjee	1996-08-29	Female	9118216859	0782336122	700, Loke Road	id	Durgapur	Nagaland	India	AB+	bhavini.chatterjee457@example.com	Retired	t	3	Widowed	770261	10458	\N
461	Sai		Agarwal	1963-07-01	Other	9103340033	09650513135	H.No. 595\nManne Street	assumenda	Kamarhati	Tripura	India	O-	sai.agarwal458@example.com	Student	f	3	Widowed	510402	10459	\N
462	Hemani		Deshmukh	1956-04-08	Male	6151095893		75, Sidhu Zila	dicta	Bulandshahr	Tamil Nadu	India	AB+	hemani.deshmukh459@example.com	Teacher	f	3	Single	443524	10460	\N
463	Veda		Keer	1955-02-04	Female	0897651592		09/40, Sur Zila	assumenda	Ambarnath	Madhya Pradesh	India	O-	veda.keer460@example.com	Farmer	f	3	Single	728117	10461	\N
464	Rayaan	Falak	Prabhu	1998-10-22	Male	0913720637		H.No. 48, Saha Zila	illum	Pudukkottai	Assam	India	A+	rayaan.prabhu461@example.com	Doctor	f	3	Single	383851	10462	\N
465	Harinakshi		Parsa	1987-04-27	Female	9173123473		518\nWagle Chowk	natus	Bhimavaram	Haryana	India	AB-	harinakshi.parsa462@example.com	Student	t	3	Widowed	310690	10463	\N
466	Karan	Ekiya	Gupta	2001-06-26	Female	0132102121		H.No. 84, Brar Marg	sit	Belgaum	Goa	India	AB-	karan.gupta463@example.com	Student	f	3	Married	293813	10464	\N
467	Aditya		Narayan	1963-04-18	Male	0699140361		H.No. 893, Sood Path	repellat	Saharsa	Himachal Pradesh	India	O+	aditya.narayan464@example.com	Retired	t	3	Single	561559	10465	\N
468	Kavya	Manbir	Gulati	1999-12-15	Male	4081166065		97, Wason Nagar	dicta	Ballia	Sikkim	India	O+	kavya.gulati465@example.com	Retired	f	3	Widowed	500895	10466	\N
469	Nidhi	Oscar	Yogi	1963-10-19	Female	2285207207		265\nKeer Street	illum	Kirari Suleman Nagar	Goa	India	B+	nidhi.yogi466@example.com	Retired	f	3	Widowed	806665	10467	\N
470	Bhavini		Murthy	1986-09-06	Other	9126830969		813\nGopal Nagar	accusantium	Gandhinagar	Haryana	India	B+	bhavini.murthy467@example.com	Engineer	t	3	Married	788883	10468	\N
471	Gaurangi		Golla	1991-11-25	Male	4150754130		12/16, Vasa Circle	hic	Bettiah	Madhya Pradesh	India	AB-	gaurangi.golla468@example.com	Doctor	f	3	Widowed	619992	10469	\N
472	Maya	Veer	Chad	1951-04-29	Other	0258151194	09761899732	H.No. 33\nNagi Marg	expedita	Varanasi	Bihar	India	A-	maya.chad469@example.com	Student	f	3	Married	895537	10470	\N
473	Bhavini	Aarini	Kamdar	1956-11-11	Other	0291948466	+917661722087	H.No. 198, Rastogi Ganj	rem	Gulbarga	Rajasthan	India	O-	bhavini.kamdar470@example.com	Student	f	3	Single	408223	10471	\N
474	Osha		Soni	2004-07-03	Other	0461374381	+911419118193	107\nBarad Zila	veritatis	Chittoor	Uttar Pradesh	India	A-	osha.soni471@example.com	Teacher	t	3	Single	205975	10472	\N
475	Tanvi		Pau	1958-05-19	Female	9128059417	+912222960158	182, Chandran Path	magnam	Bally	Nagaland	India	B-	tanvi.pau472@example.com	Teacher	f	3	Widowed	490230	10473	\N
476	Yauvani	Gayathri	Magar	1944-08-02	Female	0206402302	0124806905	79\nPrakash Street	vitae	Kottayam	Nagaland	India	B+	yauvani.magar473@example.com	Teacher	f	3	Single	293841	10474	\N
477	Yadavi	Vedika	Sankaran	2000-07-15	Other	7096073600		H.No. 53\nAgate Street	mollitia	Avadi	Madhya Pradesh	India	O-	yadavi.sankaran474@example.com	Doctor	f	3	Single	331928	10475	\N
478	Pranav	Abeer	Raja	1960-03-06	Other	0496968164		H.No. 74\nChar Street	fuga	Pudukkottai	Mizoram	India	AB-	pranav.raja475@example.com	Retired	t	3	Single	130839	10476	\N
479	Odika		Kanda	1956-03-12	Other	9368059599	0496164321	36\nVasa Ganj	fugit	Kishanganj	Bihar	India	O-	odika.kanda476@example.com	Retired	f	3	Married	571890	10477	\N
480	Prisha		Talwar	1962-08-09	Female	0040623164		H.No. 46\nDas Nagar	modi	Noida	Meghalaya	India	B-	prisha.talwar477@example.com	Student	f	3	Widowed	075472	10478	\N
481	Ikbal	Devika	Raval	1943-05-21	Other	0285830565		52/69, Natarajan	minus	Patna	Telangana	India	B+	ikbal.raval478@example.com	Engineer	t	3	Single	276419	10479	\N
482	William	Ayushman	Srivastava	1996-06-08	Male	9177831591		400, Batra Path	maxime	Rohtak	Manipur	India	O-	william.srivastava479@example.com	Teacher	f	3	Married	223396	10480	\N
483	Zayyan		Sane	1965-07-16	Male	9157107735		H.No. 421\nAcharya Ganj	accusamus	Bally	West Bengal	India	AB-	zayyan.sane480@example.com	Engineer	f	3	Married	073446	10481	\N
484	Sanya		Dutta	1952-05-18	Male	0181231233	+917756936557	H.No. 261, Ramanathan Marg	facilis	Ramagundam	Odisha	India	O-	sanya.dutta481@example.com	Retired	f	3	Single	816789	10482	\N
485	Bishakha	Arya	Keer	1961-09-19	Male	9125991167		15, Thaker Path	dolore	Naihati	Tripura	India	B-	bishakha.keer482@example.com	Doctor	t	3	Married	757561	10483	\N
486	Chaitaly		Kala	1966-04-01	Female	9135000960	07113450895	87/15, Bansal Ganj	eligendi	Etawah	Madhya Pradesh	India	O+	chaitaly.kala483@example.com	Engineer	t	3	Married	792368	10484	\N
487	Ansh		Batta	1952-05-25	Other	9178596705		650, Biswas Zila	placeat	Rohtak	Meghalaya	India	O-	ansh.batta484@example.com	Teacher	t	3	Single	590711	10485	\N
488	Kritika		Mitra	2006-04-10	Other	9474658469		51/395, Uppal Ganj	a	Madurai	Tripura	India	AB+	kritika.mitra485@example.com	Engineer	f	3	Married	759123	10486	\N
489	Upkaar	Nihal	Sami	1983-09-13	Male	9114790533	6686124026	322\nKannan Chowk	excepturi	Udaipur	Mizoram	India	O-	upkaar.sami486@example.com	Farmer	f	3	Single	269700	10487	\N
490	Faqid		Brahmbhatt	1934-10-09	Female	9178384758		42\nNori Nagar	ipsum	Madanapalle	Chhattisgarh	India	O-	faqid.brahmbhatt487@example.com	Teacher	f	3	Widowed	039848	10488	\N
491	Meghana		Bose	1938-04-29	Male	1364873551		27, Sastry Circle	nesciunt	Navi Mumbai	Andhra Pradesh	India	O-	meghana.bose488@example.com	Doctor	f	3	Married	951996	10489	\N
492	Brijesh		Chandra	1938-08-28	Female	7219500079	07096242336	71/046, Dixit Zila	eveniet	Bhalswa Jahangir Pur	West Bengal	India	B-	brijesh.chandra489@example.com	Retired	t	3	Married	181460	10490	\N
493	Rushil		Kannan	1943-05-21	Female	9101743544		H.No. 097\nMurty	laborum	Solapur	Tripura	India	A-	rushil.kannan490@example.com	Farmer	f	3	Married	573590	10491	\N
494	Nihal		Purohit	1995-11-03	Male	9177769696		H.No. 799, Gandhi Street	esse	Ballia	Meghalaya	India	AB-	nihal.purohit491@example.com	Retired	t	3	Single	550888	10492	\N
495	Odika	Aashi	Sabharwal	1989-12-02	Female	0860066807		91/242\nSwamy Street	odio	Gorakhpur	Kerala	India	B-	odika.sabharwal492@example.com	Farmer	f	3	Single	347291	10493	\N
496	Janani		Sagar	1964-02-04	Female	9905878760		H.No. 838\nDugar Circle	aperiam	Kulti	Odisha	India	B+	janani.sagar493@example.com	Retired	f	3	Single	740858	10494	\N
497	Yashica	Madhavi	Pandit	2000-02-27	Female	8825653948	+911227519439	42/29, Ganguly Chowk	placeat	Bhilai	Gujarat	India	A+	yashica.pandit494@example.com	Farmer	t	3	Widowed	603353	10495	\N
498	Bhavya	Raagini	Chaudhry	1976-04-15	Other	0711789275	03571978990	71/464\nDas Marg	voluptatum	Rajpur Sonarpur	Tripura	India	AB+	bhavya.chaudhry495@example.com	Engineer	f	3	Married	357947	10496	\N
499	Meera		Kari	1955-01-28	Other	9187878297		776\nShah Nagar	velit	Yamunanagar	Rajasthan	India	O-	meera.kari496@example.com	Teacher	t	3	Married	161278	10497	\N
500	Logan	Anay	Aurora	1975-04-15	Female	9139633442	7292054043	66/63\nBhardwaj Chowk	sequi	Katni	Assam	India	B-	logan.aurora497@example.com	Retired	f	3	Single	543422	10498	\N
501	Dominic	Thomas	Jha	1967-05-13	Other	0125731315	01823733965	H.No. 743\nTata Street	illo	Nandyal	Mizoram	India	A-	dominic.jha498@example.com	Engineer	f	3	Widowed	614966	10499	\N
502	Samesh	Chasmum	Devan	1943-12-08	Female	0699825438		25, Narain Road	quia	Vijayanagaram	Madhya Pradesh	India	O+	samesh.devan499@example.com	Teacher	f	3	Married	968409	10500	\N
504	Ravi	Kumar	Sharma	1996-04-23	Male	9876543210	01123456789	123, Sector 21	Near City Hospital	New Delhi	Delhi	India	B+	ravi.sharma@example.com	Engineer	f	3	Married	110075	10501	316825299915778
507	Ravi	Kumar	Sharma	1996-04-23	Male	9876543211	01123456789	123, Sector 21	Near City Hospital	Mumbai	Delhi	India	B+	ravi.sharma+1@example.com	Engineer	f	3	Married	110075	10502	353024548920776
508	Rahul		Verma	2025-07-08	Male	8908908899		Ahmedabad-Vadodara Expressway		AHMEDABAD	Gujarat	India	A-	kapil23jani@gmail.com		f	3	\N	390061	10503	944943575336234
509	xgch	sdfag	sdf	2025-07-14	Female	9999999999	0000000000	Emergency Address		N/A	N/A	N/A	A+	emergency@dummy.com		f	3	\N	000000	10504	221540663739370
511	Nilay		Jani	2025-07-01	Male	9999999999	0000000000	Emergency Address		N/A	N/A	N/A	A+	emergency@dummy.com		f	3	\N	000000	10505	501378915842904
\.


--
-- Data for Name: payments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payments (payment_id, invoice_id, payment_date, amount, mode, payer, transaction_ref, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.permissions (id, name, description, amount) FROM stdin;
1	Patient Management	Manage Patients	12900.00
2	Appointment Booking	Manage Appointments	12900.00
3	Billing Access	Manage & Create Billings	19000.00
4	Reports Generation	Manage & Create Reports	28000.00
5	IPD Management	Manage Patient Addmissions	\N
6	Staff Management	Manage Staffs	\N
7	Staffs	Manage staffs roles & shifts	1900.00
\.


--
-- Data for Name: receipt_line_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.receipt_line_items (id, item, quantity, rate, amount, receipt_id) FROM stdin;
\.


--
-- Data for Name: receipts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.receipts (id, hospital_id, patient_id, doctor_id, subtotal, discount, tax, total, payment_mode, is_paid, notes, status, receipt_unique_no, created, updated, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: hospitease_admin
--

COPY public.roles (id, name) FROM stdin;
1	string
2	doctor
3	string1
4	strinasg
5	striasdng
6	qwe
7	stri123ng
8	Doctor
9	Admin
10	super_admin
11	string1wqwedacx 
12	string1wqwedaasdcx 
13	string1wasdqweasddaasdcx 
14	Staff
15	Nurse
\.


--
-- Data for Name: staff; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.staff (id, hospital_id, user_id, first_name, last_name, title, gender, date_of_birth, phone_number, email, role, department, specialization, qualification, experience, joining_date, is_active, address, city, state, country, zipcode, emergency_contact, photo_url, created_at, updated_at) FROM stdin;
1	3	5	Priya	Sharma	Dr.	Female	1985-04-15	9812345678	priya.sharma@example.com	Gynecologist	Obstetrics & Gynecology	High-risk Pregnancy	MBBS, MS (OBG)	10	2023-11-01	t	25, Nehru Nagar, Sector 9	Delhi	Delhi	India	110045	9811122233	https://example.com/images/priya_sharma.jpg	\N	\N
2	3	6	Lorum	David	Dr.	Female	2025-06-08	84605591701	lorum@gmail.com	Nurse	Front Desk	Only Cash check	B.A.	12	2025-06-16	t	SG Highwar Ahmedabad	Ahmedabad	Gujarat	India	382470	8888888888		\N	\N
\.


--
-- Data for Name: staff_responsibilities; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.staff_responsibilities (id, name, value, description) FROM stdin;
1	All Access	all_access	Full access to all modules
2	Patient Management	patient_management	Can manage patient records
3	Appointment Management	appointment_management	Can manage appointments
4	IPD Care	ipd_care	Can manage IPD patients
5	Billing Management	billing_management	Can manage billing
6	Inventory Management	inventory_management	Can manage inventory
\.


--
-- Data for Name: staff_responsibility_assignments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.staff_responsibility_assignments (id, staff_id, responsibility_id, assigned_by, assigned_at, revoked_at, revoked_by) FROM stdin;
7	1	6	3	2025-07-07 13:26:41.533332	2025-07-07 13:35:12.251178	3
6	1	5	3	2025-07-07 13:26:41.524921	2025-07-07 13:35:14.168572	3
11	1	3	3	2025-07-07 13:41:34.606929	\N	\N
12	1	2	3	2025-07-07 13:41:34.614277	\N	\N
14	1	4	3	2025-07-07 16:42:15.807306	\N	\N
\.


--
-- Data for Name: symptoms; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.symptoms (id, description, duration, severity, onset, contributing_factors, recurring, doctor_comment, doctor_suggestions, appointment_id) FROM stdin;
\.


--
-- Data for Name: tests; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tests (id, appointment_id, test_details, status, cost, description, doctor_notes, staff_notes, test_date, test_done_date, tests_docs_urls) FROM stdin;
1	2	ECG	pending	0.00						\N
2	2	CBC	pending	0.00						\N
3	2	Malaria Test	pending	0.00		To be done as soon as possible				\N
4	2	CBC Test	pending	0.00		To be done as soon as possible				\N
5	2	ECG	pending	0.00		To be done as soon as possible				\N
6	9228	Not specified	pending	0.00		Not specified				\N
7	9027	Complete Blood Count (CBC)	Pending	100.00	hj	j			\N	\N
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: hospitease_admin
--

COPY public.users (id, email, password, first_name, last_name, gender, phone_number, role_id, marital_status, zipcode, hospital_id) FROM stdin;
2	hospitease@example.com	12345	Hospitease	Admin	Male	123123123	10	\N	\N	\N
3	meera.deshmukh@example.com	12345	Dr. Meera	Deshmukh	Male	+918460559170	9	\N	\N	3
4	mukesh@hospitease.com	12345	Mukesh	Ramanuja	\N	\N	8	\N	\N	\N
5	priya.sharma@example.com	12345	Priya	Sharma	\N	\N	14	\N	\N	\N
6	lorum@gmail.com	12345	Lorum	David	\N	\N	14	\N	\N	\N
\.


--
-- Data for Name: vitals; Type: TABLE DATA; Schema: public; Owner: hospitease_admin
--

COPY public.vitals (id, appointment_id, capture_date, vital_name, vital_value, vital_unit, recorded_by, recorded_at) FROM stdin;
\.


--
-- Data for Name: wards; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.wards (id, name, description, floor, total_beds, available_beds, is_active, hospital_id) FROM stdin;
1	General Ward	General Ward	1	10	8	t	3
\.


--
-- Name: admission_diets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.admission_diets_id_seq', 1, true);


--
-- Name: admission_discharges_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.admission_discharges_id_seq', 2, true);


--
-- Name: admission_medicines_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.admission_medicines_id_seq', 1, true);


--
-- Name: admission_tests_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.admission_tests_id_seq', 1, true);


--
-- Name: admission_vitals_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.admission_vitals_id_seq', 1, true);


--
-- Name: admissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.admissions_id_seq', 6, true);


--
-- Name: appointments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.appointments_id_seq', 11011, true);


--
-- Name: audit_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.audit_logs_id_seq', 130, true);


--
-- Name: bed_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bed_types_id_seq', 2, true);


--
-- Name: beds_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.beds_id_seq', 2, true);


--
-- Name: chat_messages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.chat_messages_id_seq', 1, false);


--
-- Name: doctors_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.doctors_id_seq', 23, true);


--
-- Name: documents_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.documents_id_seq', 1, false);


--
-- Name: family_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.family_history_id_seq', 1, false);


--
-- Name: health_info_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.health_info_id_seq', 1, false);


--
-- Name: hospital_payments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.hospital_payments_id_seq', 1, true);


--
-- Name: hospital_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.hospital_permissions_id_seq', 34, true);


--
-- Name: hospitals_id_seq; Type: SEQUENCE SET; Schema: public; Owner: hospitease_admin
--

SELECT pg_catalog.setval('public.hospitals_id_seq', 3, true);


--
-- Name: medical_histories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.medical_histories_id_seq', 1, false);


--
-- Name: medicines_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.medicines_id_seq', 11, true);


--
-- Name: nursing_notes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.nursing_notes_id_seq', 3, true);


--
-- Name: patients_id_seq; Type: SEQUENCE SET; Schema: public; Owner: hospitease_admin
--

SELECT pg_catalog.setval('public.patients_id_seq', 511, true);


--
-- Name: permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.permissions_id_seq', 7, true);


--
-- Name: receipt_line_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.receipt_line_items_id_seq', 1, false);


--
-- Name: receipts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.receipts_id_seq', 1, false);


--
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: hospitease_admin
--

SELECT pg_catalog.setval('public.roles_id_seq', 15, true);


--
-- Name: staff_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.staff_id_seq', 2, true);


--
-- Name: staff_responsibilities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.staff_responsibilities_id_seq', 6, true);


--
-- Name: staff_responsibility_assignments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.staff_responsibility_assignments_id_seq', 15, true);


--
-- Name: symptoms_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.symptoms_id_seq', 1, false);


--
-- Name: tests_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tests_id_seq', 7, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: hospitease_admin
--

SELECT pg_catalog.setval('public.users_id_seq', 6, true);


--
-- Name: vitals_id_seq; Type: SEQUENCE SET; Schema: public; Owner: hospitease_admin
--

SELECT pg_catalog.setval('public.vitals_id_seq', 1, false);


--
-- Name: wards_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.wards_id_seq', 1, true);


--
-- Name: ab_claims ab_claims_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ab_claims
    ADD CONSTRAINT ab_claims_pkey PRIMARY KEY (ab_claim_id);


--
-- Name: admission_diets admission_diets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admission_diets
    ADD CONSTRAINT admission_diets_pkey PRIMARY KEY (id);


--
-- Name: admission_discharges admission_discharges_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admission_discharges
    ADD CONSTRAINT admission_discharges_pkey PRIMARY KEY (id);


--
-- Name: admission_medicines admission_medicines_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admission_medicines
    ADD CONSTRAINT admission_medicines_pkey PRIMARY KEY (id);


--
-- Name: admission_tests admission_tests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admission_tests
    ADD CONSTRAINT admission_tests_pkey PRIMARY KEY (id);


--
-- Name: admission_vitals admission_vitals_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admission_vitals
    ADD CONSTRAINT admission_vitals_pkey PRIMARY KEY (id);


--
-- Name: admissions admissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admissions
    ADD CONSTRAINT admissions_pkey PRIMARY KEY (id);


--
-- Name: appointments appointments_appointment_unique_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT appointments_appointment_unique_id_key UNIQUE (appointment_unique_id);


--
-- Name: appointments appointments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT appointments_pkey PRIMARY KEY (id);


--
-- Name: audit_logs audit_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_pkey PRIMARY KEY (id);


--
-- Name: bed_types bed_types_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bed_types
    ADD CONSTRAINT bed_types_name_key UNIQUE (name);


--
-- Name: bed_types bed_types_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bed_types
    ADD CONSTRAINT bed_types_pkey PRIMARY KEY (id);


--
-- Name: beds beds_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.beds
    ADD CONSTRAINT beds_name_key UNIQUE (name);


--
-- Name: beds beds_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.beds
    ADD CONSTRAINT beds_pkey PRIMARY KEY (id);


--
-- Name: chat_messages chat_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chat_messages
    ADD CONSTRAINT chat_messages_pkey PRIMARY KEY (id);


--
-- Name: credit_ledgers credit_ledgers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.credit_ledgers
    ADD CONSTRAINT credit_ledgers_pkey PRIMARY KEY (credit_id);


--
-- Name: doctors doctors_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctors
    ADD CONSTRAINT doctors_email_key UNIQUE (email);


--
-- Name: doctors doctors_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctors
    ADD CONSTRAINT doctors_pkey PRIMARY KEY (id);


--
-- Name: documents documents_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.documents
    ADD CONSTRAINT documents_pkey PRIMARY KEY (id);


--
-- Name: encounters encounters_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.encounters
    ADD CONSTRAINT encounters_pkey PRIMARY KEY (encounter_id);


--
-- Name: family_history family_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.family_history
    ADD CONSTRAINT family_history_pkey PRIMARY KEY (id);


--
-- Name: health_info health_info_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.health_info
    ADD CONSTRAINT health_info_pkey PRIMARY KEY (id);


--
-- Name: hospital_payments hospital_payments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hospital_payments
    ADD CONSTRAINT hospital_payments_pkey PRIMARY KEY (id);


--
-- Name: hospital_permissions hospital_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hospital_permissions
    ADD CONSTRAINT hospital_permissions_pkey PRIMARY KEY (id);


--
-- Name: hospitals hospitals_pkey; Type: CONSTRAINT; Schema: public; Owner: hospitease_admin
--

ALTER TABLE ONLY public.hospitals
    ADD CONSTRAINT hospitals_pkey PRIMARY KEY (id);


--
-- Name: insurance_claims insurance_claims_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insurance_claims
    ADD CONSTRAINT insurance_claims_pkey PRIMARY KEY (claim_id);


--
-- Name: insurance_providers insurance_providers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insurance_providers
    ADD CONSTRAINT insurance_providers_pkey PRIMARY KEY (insurance_id);


--
-- Name: invoices invoices_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_pkey PRIMARY KEY (invoice_id);


--
-- Name: items items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.items
    ADD CONSTRAINT items_pkey PRIMARY KEY (item_id);


--
-- Name: medical_histories medical_histories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medical_histories
    ADD CONSTRAINT medical_histories_pkey PRIMARY KEY (id);


--
-- Name: medicines medicines_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medicines
    ADD CONSTRAINT medicines_pkey PRIMARY KEY (id);


--
-- Name: nursing_notes nursing_notes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nursing_notes
    ADD CONSTRAINT nursing_notes_pkey PRIMARY KEY (id);


--
-- Name: patients patients_pkey; Type: CONSTRAINT; Schema: public; Owner: hospitease_admin
--

ALTER TABLE ONLY public.patients
    ADD CONSTRAINT patients_pkey PRIMARY KEY (id);


--
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (payment_id);


--
-- Name: permissions permissions_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_name_key UNIQUE (name);


--
-- Name: permissions permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);


--
-- Name: receipt_line_items receipt_line_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receipt_line_items
    ADD CONSTRAINT receipt_line_items_pkey PRIMARY KEY (id);


--
-- Name: receipts receipts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receipts
    ADD CONSTRAINT receipts_pkey PRIMARY KEY (id);


--
-- Name: receipts receipts_receipt_unique_no_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receipts
    ADD CONSTRAINT receipts_receipt_unique_no_key UNIQUE (receipt_unique_no);


--
-- Name: roles roles_name_key; Type: CONSTRAINT; Schema: public; Owner: hospitease_admin
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_name_key UNIQUE (name);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: hospitease_admin
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: staff staff_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff
    ADD CONSTRAINT staff_email_key UNIQUE (email);


--
-- Name: staff staff_phone_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff
    ADD CONSTRAINT staff_phone_number_key UNIQUE (phone_number);


--
-- Name: staff staff_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff
    ADD CONSTRAINT staff_pkey PRIMARY KEY (id);


--
-- Name: staff_responsibilities staff_responsibilities_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff_responsibilities
    ADD CONSTRAINT staff_responsibilities_name_key UNIQUE (name);


--
-- Name: staff_responsibilities staff_responsibilities_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff_responsibilities
    ADD CONSTRAINT staff_responsibilities_pkey PRIMARY KEY (id);


--
-- Name: staff_responsibilities staff_responsibilities_value_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff_responsibilities
    ADD CONSTRAINT staff_responsibilities_value_key UNIQUE (value);


--
-- Name: staff_responsibility_assignments staff_responsibility_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff_responsibility_assignments
    ADD CONSTRAINT staff_responsibility_assignments_pkey PRIMARY KEY (id);


--
-- Name: symptoms symptoms_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.symptoms
    ADD CONSTRAINT symptoms_pkey PRIMARY KEY (id);


--
-- Name: tests tests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tests
    ADD CONSTRAINT tests_pkey PRIMARY KEY (id);


--
-- Name: patients unique_patient_id; Type: CONSTRAINT; Schema: public; Owner: hospitease_admin
--

ALTER TABLE ONLY public.patients
    ADD CONSTRAINT unique_patient_id UNIQUE (patient_unique_id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: hospitease_admin
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: hospitease_admin
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: vitals vitals_pkey; Type: CONSTRAINT; Schema: public; Owner: hospitease_admin
--

ALTER TABLE ONLY public.vitals
    ADD CONSTRAINT vitals_pkey PRIMARY KEY (id);


--
-- Name: wards wards_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wards
    ADD CONSTRAINT wards_name_key UNIQUE (name);


--
-- Name: wards wards_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wards
    ADD CONSTRAINT wards_pkey PRIMARY KEY (id);


--
-- Name: idx_hospital_payments_hospital_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_hospital_payments_hospital_id ON public.hospital_payments USING btree (hospital_id);


--
-- Name: idx_medical_histories_patient_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_medical_histories_patient_id ON public.medical_histories USING btree (patient_id);


--
-- Name: idx_permissions_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_permissions_id ON public.permissions USING btree (id);


--
-- Name: idx_permissions_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_permissions_name ON public.permissions USING btree (name);


--
-- Name: idx_receipt_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_receipt_id ON public.receipt_line_items USING btree (receipt_id);


--
-- Name: ix_audit_logs_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_audit_logs_id ON public.audit_logs USING btree (id);


--
-- Name: ix_hospitals_id; Type: INDEX; Schema: public; Owner: hospitease_admin
--

CREATE INDEX ix_hospitals_id ON public.hospitals USING btree (id);


--
-- Name: ix_patients_id; Type: INDEX; Schema: public; Owner: hospitease_admin
--

CREATE INDEX ix_patients_id ON public.patients USING btree (id);


--
-- Name: ix_roles_id; Type: INDEX; Schema: public; Owner: hospitease_admin
--

CREATE INDEX ix_roles_id ON public.roles USING btree (id);


--
-- Name: ix_users_id; Type: INDEX; Schema: public; Owner: hospitease_admin
--

CREATE INDEX ix_users_id ON public.users USING btree (id);


--
-- Name: appointments trigger_update_appointments; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_update_appointments BEFORE UPDATE ON public.appointments FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: ab_claims ab_claims_claim_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ab_claims
    ADD CONSTRAINT ab_claims_claim_id_fkey FOREIGN KEY (claim_id) REFERENCES public.insurance_claims(claim_id);


--
-- Name: admission_diets admission_diets_admission_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admission_diets
    ADD CONSTRAINT admission_diets_admission_id_fkey FOREIGN KEY (admission_id) REFERENCES public.admissions(id);


--
-- Name: admission_discharges admission_discharges_admission_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admission_discharges
    ADD CONSTRAINT admission_discharges_admission_id_fkey FOREIGN KEY (admission_id) REFERENCES public.admissions(id);


--
-- Name: admission_medicines admission_medicines_admission_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admission_medicines
    ADD CONSTRAINT admission_medicines_admission_id_fkey FOREIGN KEY (admission_id) REFERENCES public.admissions(id);


--
-- Name: admission_tests admission_tests_admission_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admission_tests
    ADD CONSTRAINT admission_tests_admission_id_fkey FOREIGN KEY (admission_id) REFERENCES public.admissions(id);


--
-- Name: admission_vitals admission_vitals_admission_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admission_vitals
    ADD CONSTRAINT admission_vitals_admission_id_fkey FOREIGN KEY (admission_id) REFERENCES public.admissions(id);


--
-- Name: admissions admissions_appointment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admissions
    ADD CONSTRAINT admissions_appointment_id_fkey FOREIGN KEY (appointment_id) REFERENCES public.appointments(id);


--
-- Name: admissions admissions_bed_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admissions
    ADD CONSTRAINT admissions_bed_id_fkey FOREIGN KEY (bed_id) REFERENCES public.beds(id);


--
-- Name: admissions admissions_doctor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admissions
    ADD CONSTRAINT admissions_doctor_id_fkey FOREIGN KEY (doctor_id) REFERENCES public.doctors(id);


--
-- Name: admissions admissions_patient_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admissions
    ADD CONSTRAINT admissions_patient_id_fkey FOREIGN KEY (patient_id) REFERENCES public.patients(id);


--
-- Name: appointments appointments_doctor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT appointments_doctor_id_fkey FOREIGN KEY (doctor_id) REFERENCES public.doctors(id) ON DELETE CASCADE;


--
-- Name: appointments appointments_patient_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT appointments_patient_id_fkey FOREIGN KEY (patient_id) REFERENCES public.patients(id) ON DELETE CASCADE;


--
-- Name: beds beds_bed_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.beds
    ADD CONSTRAINT beds_bed_type_id_fkey FOREIGN KEY (bed_type_id) REFERENCES public.bed_types(id);


--
-- Name: beds beds_ward_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.beds
    ADD CONSTRAINT beds_ward_id_fkey FOREIGN KEY (ward_id) REFERENCES public.wards(id);


--
-- Name: credit_ledgers credit_ledgers_invoice_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.credit_ledgers
    ADD CONSTRAINT credit_ledgers_invoice_id_fkey FOREIGN KEY (invoice_id) REFERENCES public.invoices(invoice_id);


--
-- Name: doctors doctors_hospital_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctors
    ADD CONSTRAINT doctors_hospital_id_fkey FOREIGN KEY (hospital_id) REFERENCES public.hospitals(id) ON DELETE CASCADE;


--
-- Name: encounters encounters_patient_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.encounters
    ADD CONSTRAINT encounters_patient_id_fkey FOREIGN KEY (patient_id) REFERENCES public.patients(id);


--
-- Name: family_history family_history_appointment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.family_history
    ADD CONSTRAINT family_history_appointment_id_fkey FOREIGN KEY (appointment_id) REFERENCES public.appointments(id) ON DELETE CASCADE;


--
-- Name: admissions fk_admissions_hospital; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admissions
    ADD CONSTRAINT fk_admissions_hospital FOREIGN KEY (hospital_id) REFERENCES public.hospitals(id) ON DELETE SET NULL;


--
-- Name: symptoms fk_appointment; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.symptoms
    ADD CONSTRAINT fk_appointment FOREIGN KEY (appointment_id) REFERENCES public.appointments(id) ON DELETE CASCADE;


--
-- Name: health_info health_info_appointment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.health_info
    ADD CONSTRAINT health_info_appointment_id_fkey FOREIGN KEY (appointment_id) REFERENCES public.appointments(id) ON DELETE CASCADE;


--
-- Name: hospital_payments hospital_payments_hospital_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hospital_payments
    ADD CONSTRAINT hospital_payments_hospital_id_fkey FOREIGN KEY (hospital_id) REFERENCES public.hospitals(id) ON DELETE CASCADE;


--
-- Name: hospital_permissions hospital_permissions_hospital_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hospital_permissions
    ADD CONSTRAINT hospital_permissions_hospital_id_fkey FOREIGN KEY (hospital_id) REFERENCES public.hospitals(id) ON DELETE CASCADE;


--
-- Name: hospital_permissions hospital_permissions_permission_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hospital_permissions
    ADD CONSTRAINT hospital_permissions_permission_id_fkey FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;


--
-- Name: hospitals hospitals_admin_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: hospitease_admin
--

ALTER TABLE ONLY public.hospitals
    ADD CONSTRAINT hospitals_admin_id_fkey FOREIGN KEY (admin_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: insurance_claims insurance_claims_encounter_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insurance_claims
    ADD CONSTRAINT insurance_claims_encounter_id_fkey FOREIGN KEY (encounter_id) REFERENCES public.encounters(encounter_id);


--
-- Name: insurance_claims insurance_claims_insurance_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insurance_claims
    ADD CONSTRAINT insurance_claims_insurance_id_fkey FOREIGN KEY (insurance_id) REFERENCES public.insurance_providers(insurance_id);


--
-- Name: invoices invoices_encounter_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_encounter_id_fkey FOREIGN KEY (encounter_id) REFERENCES public.encounters(encounter_id);


--
-- Name: medical_histories medical_histories_patient_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medical_histories
    ADD CONSTRAINT medical_histories_patient_id_fkey FOREIGN KEY (patient_id) REFERENCES public.patients(id) ON DELETE CASCADE;


--
-- Name: medicines medicines_appointment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medicines
    ADD CONSTRAINT medicines_appointment_id_fkey FOREIGN KEY (appointment_id) REFERENCES public.appointments(id) ON DELETE CASCADE;


--
-- Name: nursing_notes nursing_notes_admission_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nursing_notes
    ADD CONSTRAINT nursing_notes_admission_id_fkey FOREIGN KEY (admission_id) REFERENCES public.admissions(id);


--
-- Name: patients patients_hospital_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: hospitease_admin
--

ALTER TABLE ONLY public.patients
    ADD CONSTRAINT patients_hospital_id_fkey FOREIGN KEY (hospital_id) REFERENCES public.hospitals(id);


--
-- Name: payments payments_invoice_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_invoice_id_fkey FOREIGN KEY (invoice_id) REFERENCES public.invoices(invoice_id);


--
-- Name: receipt_line_items receipt_line_items_receipt_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receipt_line_items
    ADD CONSTRAINT receipt_line_items_receipt_id_fkey FOREIGN KEY (receipt_id) REFERENCES public.receipts(id) ON DELETE CASCADE;


--
-- Name: staff staff_hospital_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff
    ADD CONSTRAINT staff_hospital_id_fkey FOREIGN KEY (hospital_id) REFERENCES public.hospitals(id);


--
-- Name: staff_responsibility_assignments staff_responsibility_assignments_assigned_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff_responsibility_assignments
    ADD CONSTRAINT staff_responsibility_assignments_assigned_by_fkey FOREIGN KEY (assigned_by) REFERENCES public.users(id);


--
-- Name: staff_responsibility_assignments staff_responsibility_assignments_responsibility_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff_responsibility_assignments
    ADD CONSTRAINT staff_responsibility_assignments_responsibility_id_fkey FOREIGN KEY (responsibility_id) REFERENCES public.staff_responsibilities(id) ON DELETE CASCADE;


--
-- Name: staff_responsibility_assignments staff_responsibility_assignments_revoked_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff_responsibility_assignments
    ADD CONSTRAINT staff_responsibility_assignments_revoked_by_fkey FOREIGN KEY (revoked_by) REFERENCES public.users(id);


--
-- Name: staff_responsibility_assignments staff_responsibility_assignments_staff_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff_responsibility_assignments
    ADD CONSTRAINT staff_responsibility_assignments_staff_id_fkey FOREIGN KEY (staff_id) REFERENCES public.staff(id) ON DELETE CASCADE;


--
-- Name: staff staff_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff
    ADD CONSTRAINT staff_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: users users_hospital_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: hospitease_admin
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_hospital_id_fkey FOREIGN KEY (hospital_id) REFERENCES public.hospitals(id);


--
-- Name: vitals vitals_appointment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: hospitease_admin
--

ALTER TABLE ONLY public.vitals
    ADD CONSTRAINT vitals_appointment_id_fkey FOREIGN KEY (appointment_id) REFERENCES public.appointments(id) ON DELETE CASCADE;


--
-- Name: wards wards_hospital_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wards
    ADD CONSTRAINT wards_hospital_id_fkey FOREIGN KEY (hospital_id) REFERENCES public.hospitals(id);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: kapiljani
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- Name: TABLE appointments; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.appointments TO hospitease_admin;


--
-- Name: SEQUENCE appointments_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.appointments_id_seq TO hospitease_admin;


--
-- Name: TABLE audit_logs; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.audit_logs TO hospitease_admin;


--
-- Name: SEQUENCE audit_logs_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.audit_logs_id_seq TO hospitease_admin;


--
-- Name: TABLE doctors; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.doctors TO hospitease_admin;


--
-- Name: SEQUENCE doctors_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.doctors_id_seq TO hospitease_admin;


--
-- Name: TABLE documents; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.documents TO hospitease_admin;


--
-- Name: SEQUENCE documents_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.documents_id_seq TO hospitease_admin;


--
-- Name: TABLE family_history; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.family_history TO hospitease_admin;


--
-- Name: SEQUENCE family_history_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.family_history_id_seq TO hospitease_admin;


--
-- Name: TABLE health_info; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.health_info TO hospitease_admin;


--
-- Name: SEQUENCE health_info_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.health_info_id_seq TO hospitease_admin;


--
-- Name: TABLE hospital_payments; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.hospital_payments TO hospitease_admin;


--
-- Name: SEQUENCE hospital_payments_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.hospital_payments_id_seq TO hospitease_admin;


--
-- Name: TABLE hospital_permissions; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.hospital_permissions TO hospitease_admin;


--
-- Name: SEQUENCE hospital_permissions_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.hospital_permissions_id_seq TO hospitease_admin;


--
-- Name: TABLE hospitals; Type: ACL; Schema: public; Owner: hospitease_admin
--

GRANT ALL ON TABLE public.hospitals TO postgres;


--
-- Name: TABLE medical_histories; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.medical_histories TO hospitease_admin;


--
-- Name: SEQUENCE medical_histories_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.medical_histories_id_seq TO hospitease_admin;


--
-- Name: TABLE medicines; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.medicines TO hospitease_admin;


--
-- Name: SEQUENCE medicines_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.medicines_id_seq TO hospitease_admin;


--
-- Name: TABLE patients; Type: ACL; Schema: public; Owner: hospitease_admin
--

GRANT ALL ON TABLE public.patients TO postgres;


--
-- Name: SEQUENCE permissions_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.permissions_id_seq TO hospitease_admin;


--
-- Name: TABLE permissions; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.permissions TO hospitease_admin;


--
-- Name: SEQUENCE receipt_line_items_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.receipt_line_items_id_seq TO hospitease_admin;


--
-- Name: TABLE receipt_line_items; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.receipt_line_items TO hospitease_admin;


--
-- Name: SEQUENCE receipts_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.receipts_id_seq TO hospitease_admin;


--
-- Name: TABLE receipts; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.receipts TO hospitease_admin;


--
-- Name: TABLE roles; Type: ACL; Schema: public; Owner: hospitease_admin
--

GRANT ALL ON TABLE public.roles TO postgres;


--
-- Name: TABLE symptoms; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.symptoms TO hospitease_admin;


--
-- Name: SEQUENCE symptoms_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.symptoms_id_seq TO hospitease_admin;


--
-- Name: TABLE tests; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.tests TO hospitease_admin;


--
-- Name: SEQUENCE tests_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.tests_id_seq TO hospitease_admin;


--
-- Name: TABLE users; Type: ACL; Schema: public; Owner: hospitease_admin
--

GRANT ALL ON TABLE public.users TO postgres;


--
-- PostgreSQL database dump complete
--

