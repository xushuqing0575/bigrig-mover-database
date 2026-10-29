-- Selected portfolio excerpt from T1-brm-schema.sql
-- Chloe Shuqing Xu. Requires the matching Oracle project schema.

-- EMPLOYEE
CREATE TABLE employee(
    emp_no NUMBER(3) NOT NULL,
    emp_gname VARCHAR2(30),
    emp_fname VARCHAR2(30),
    emp_contact_no CHAR(10) NOT NULL,
    emp_licenceno VARCHAR2(11),
    emp_role CHAR(1) NOT NULL,
    emp_no_manager NUMBER(3)
);
COMMENT ON COLUMN employee.emp_no IS 
    'Employee number';
COMMENT ON COLUMN employee.emp_gname IS 
    'Employee given name';
COMMENT ON COLUMN employee.emp_fname IS 
    'Employee family name';
COMMENT ON COLUMN employee.emp_contact_no IS 
    'Employee contact number';
COMMENT ON COLUMN employee.emp_licenceno IS 
    'Employee licence number';
COMMENT ON COLUMN employee.emp_role IS 
    'Employee role';
COMMENT ON COLUMN employee.emp_no_manager IS 
    'Employee manager number';
ALTER TABLE employee ADD CONSTRAINT employee_pk PRIMARY KEY (emp_no);
ALTER TABLE employee ADD CONSTRAINT employee_contact_uq UNIQUE (emp_contact_no);
ALTER TABLE employee ADD CONSTRAINT employee_licence_uq UNIQUE (emp_licenceno);
ALTER TABLE employee 
    ADD CONSTRAINT ck_emp_role CHECK (emp_role IN (
        'B',
        'T',
        'M',
        'D'
    ));

-- JOB
CREATE TABLE job(
    job_no NUMBER(5) NOT NULL,
    job_pickup_dt DATE NOT NULL,
    job_intended_dropoff_dt DATE NOT NULL,
    job_cost NUMBER(6,2),
    job_payment_made CHAR(1) NOT NULL,
    quote_no NUMBER(5) NOT NULL,
    sched_emp_no NUMBER(3) NOT NULL,
    driver_emp_no NUMBER(3) NOT NULL,
    trailer_code CHAR(5) NOT NULL,
    truck_vin CHAR(17) NOT NULL
);
COMMENT ON COLUMN job.job_no IS
    'job number';
COMMENT ON COLUMN job.job_pickup_dt IS
    'job scheduled pick up date and time';
COMMENT ON COLUMN job.job_intended_dropoff_dt IS
    'job intended drop-off date and time';
COMMENT ON COLUMN job.job_cost IS
    'the actual job cost';
COMMENT ON COLUMN job.job_payment_made IS
    'whether the joob has been paid or not';
COMMENT ON COLUMN job.quote_no IS
    'quote number';
COMMENT ON COLUMN job.sched_emp_no IS
    'employee number of dispatcher who scheduled the job';
COMMENT ON COLUMN job.driver_emp_no IS
    'employee number of driver in this job';
COMMENT ON COLUMN job.trailer_code IS
    'trailer code';
COMMENT ON COLUMN job.truck_vin IS
    'vehicle identification number';
ALTER TABLE job ADD CONSTRAINT job_pk PRIMARY KEY (job_no);
ALTER TABLE job ADD CONSTRAINT job_pquote_uq UNIQUE (quote_no);
ALTER TABLE job 
    ADD CONSTRAINT ck_job_payment_made CHECK (job_payment_made IN (
        'Y',
        'N' 
    ));

-- QUOTE
CREATE TABLE quote(
    quote_no NUMBER(5) NOT NULL,
    quote_prepared_date DATE NOT NULL,
    quote_pref_start_date DATE NOT NULL,
    quote_start_location VARCHAR2(50) NOT NULL,
    quote_end_location VARCHAR2(60) NOT NULL,
    quote_cost NUMBER(6,2) NOT NULL,
    cust_no NUMBER(4) NOT NULL,
    emp_no NUMBER(3) NOT NULL
);
COMMENT ON COLUMN quote.quote_no IS
    'quote number';
COMMENT ON COLUMN quote.quote_prepared_date IS
    'quote prepared date';
COMMENT ON COLUMN quote.quote_pref_start_date IS
    'the preferred start date for the quote';
COMMENT ON COLUMN quote.quote_start_location IS
    'the quote start location';
COMMENT ON COLUMN quote.quote_end_location IS
    'the quote end location';
COMMENT ON COLUMN quote.quote_cost IS
    'quote cost';
COMMENT ON COLUMN quote.cust_no IS
    'customer number';
COMMENT ON COLUMN quote.emp_no IS
    'employee number of dispatcher who prepared the quote';
ALTER TABLE quote ADD CONSTRAINT quote_pk PRIMARY KEY (quote_no);


-- Foreign key constraints
ALTER TABLE employee
    ADD CONSTRAINT employee_manager_fk FOREIGN KEY (emp_no_manager)
        REFERENCES employee (emp_no);
ALTER TABLE quote
    ADD CONSTRAINT customer_quote_fk FOREIGN KEY (cust_no)
        REFERENCES customer (cust_no);
ALTER TABLE quote
    ADD CONSTRAINT employee_quote_fk FOREIGN KEY (emp_no)
        REFERENCES employee (emp_no);
ALTER TABLE job
    ADD CONSTRAINT quote_job_fk FOREIGN KEY (quote_no)
        REFERENCES quote (quote_no);
ALTER TABLE job
    ADD CONSTRAINT employee_sched_job_fk FOREIGN KEY (sched_emp_no)
        REFERENCES employee (emp_no);
ALTER TABLE job
    ADD CONSTRAINT employee_driver_job_fk FOREIGN KEY (driver_emp_no)
        REFERENCES employee (emp_no);
ALTER TABLE job
    ADD CONSTRAINT combination_job_fk FOREIGN KEY (trailer_code,
                                                truck_vin)
        REFERENCES combination (trailer_code,
                            truck_vin);
