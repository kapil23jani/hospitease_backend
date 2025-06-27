CREATE TABLE public.appointments (
    id integer PRIMARY KEY,
    patient_id integer REFERENCES patients(id),
    doctor_id integer REFERENCES doctors(id),
    appointment_datetime character varying,
    problem character varying,
    appointment_type character varying,
    reason character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    hospital_id integer,
    blood_pressure character varying,
    pulse_rate character varying,
    temperature character varying,
    spo2 character varying,
    weight character varying,
    additional_notes text,
    advice text,
    follow_up_date character varying,
    follow_up_notes text,
    appointment_date text,
    appointment_time text,
    status text,
    appointment_unique_id character varying UNIQUE NOT NULL
);

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

CREATE TABLE public.receipt_line_items (
    id integer NOT NULL,
    item character varying(100),
    quantity integer,
    rate double precision,
    amount double precision,
    receipt_id integer
);

CREATE TABLE public.receipts (
    id integer NOT NULL,
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