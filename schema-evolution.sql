-- Selected portfolio excerpt from T4-brm-mods.sql
-- Chloe Shuqing Xu. Requires the matching Oracle project schema.

--4(a)
ALTER TABLE quote ADD(
    quote_assigned_job CHAR(1) DEFAULT 'N' NOT NULL,
    quote_unassigned_reason VARCHAR2(100)
);
COMMENT ON COLUMN quote.quote_assigned_job IS 
'the quote is assigned to a job or not';
COMMENT ON COLUMN quote.quote_unassigned_reason IS
'the reason why the quote not assigned to a job';
ALTER TABLE quote 
    ADD CONSTRAINT quote_assigned_job_ck CHECK(
        quote_assigned_job IN (
            'Y',
            'N'
        )
    );
UPDATE quote
SET quote_assigned_job='Y'
WHERE quote_no IN (
    SELECT quote_no
    FROM job
);
    
COMMIT;
DESC quote;
SELECT quote_no, quote_assigned_job, quote_unassigned_reason
FROM quote
ORDER BY quote_no;


--4(b)
CREATE TABLE service(
    service_no NUMBER(5) NOT NULL,
    truck_vin CHAR(17) NOT NULL,
    service_start_dt DATE NOT NULL,
    service_end_dt DATE
);
COMMENT ON COLUMN service.service_no IS
'truck service number';
COMMENT ON COLUMN service.truck_vin IS
'truck vehicle identification number';
COMMENT ON COLUMN service.service_start_dt IS
'truck service start date and time';
COMMENT ON COLUMN service.service_end_dt IS
'truck service end date and time';
ALTER TABLE service
    ADD CONSTRAINT service_pk PRIMARY KEY (service_no);
ALTER TABLE service
    ADD CONSTRAINT service_dt_ck CHECK (
        service_end_dt IS NULL OR service_end_dt >= service_start_dt);
ALTER TABLE service
    ADD CONSTRAINT service_truck_fk FOREIGN KEY (truck_vin)
        REFERENCES truck(truck_vin);

CREATE TABLE service_task(
    service_task_code CHAR(5) NOT NULL,
    service_task_desc varchar2(60) NOT NULL
);
COMMENT ON COLUMN service_task.service_task_code IS
'service task code';
COMMENT ON COLUMN service_task.service_task_desc IS
'service task description';
ALTER TABLE service_task
    ADD CONSTRAINT service_task_pk PRIMARY KEY (service_task_code);
ALTER TABLE service_task
    ADD CONSTRAINT service_task_desc_uq UNIQUE(service_task_desc);
CREATE TABLE service_detail(
    service_no NUMBER(5) NOT NULL,
    service_task_code CHAR(5) NOT NULL,
    mech_emp_no NUMBER(3) NOT NULL,
    service_note VARCHAR2(200)
);
COMMENT ON COLUMN service_detail.service_no IS
'truck service number';
COMMENT ON COLUMN service_detail.service_task_code IS
'service task code';
COMMENT ON COLUMN service_detail.mech_emp_no IS
'mechanic employee number to the service task';
COMMENT ON COLUMN service_detail.service_note IS
'free text note for this service task';
ALTER TABLE service_detail
    ADD CONSTRAINT service_detail_pk PRIMARY KEY(
        service_no,
        service_task_code
    );
ALTER TABLE service_detail
    ADD CONSTRAINT service_detail_service_fk FOREIGN KEY(service_no)
        REFERENCES service(service_no);
ALTER TABLE service_detail
    ADD CONSTRAINT service_detail_task_fk FOREIGN KEY(service_task_code)
        REFERENCES service_task(service_task_code);
ALTER TABLE service_detail
    ADD CONSTRAINT service_detail_mech_fk FOREIGN KEY(mech_emp_no)
        REFERENCES employee(emp_no);

COMMIT;
DESC service;
DESC service_task;
DESC service_detail;
