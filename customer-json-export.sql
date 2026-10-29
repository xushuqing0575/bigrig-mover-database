-- Selected portfolio excerpt from T6-brm-json.sql
-- Chloe Shuqing Xu. Requires the matching Oracle project schema.

SELECT
    JSON_OBJECT(
        '_id' VALUE c.cust_no,
        'customer_name' VALUE
            CASE
                WHEN c.cust_gname IS NOT NULL
                    AND c.cust_fname IS NOT NULL THEN
                    c.cust_gname
                    || ' '
                    || c.cust_fname
                WHEN c.cust_gname IS NOT NULL THEN
                    c.cust_gname
                ELSE 
                    c.cust_fname
            END,
        'customer_business' VALUE NVL(c.cust_bname, '-'),
        'customer_address' VALUE c.cust_street
            || ', '
            || c.cust_town
            || ', '
            || c.cust_pcode,
        'customer_phone' VALUE c.cust_contact_no,
        'customer_stats' VALUE JSON_OBJECT(
            'number_of_quotes' VALUE COUNT(q.quote_no),
            'number_of_jobs' VALUE COUNT(j.job_no),
            'total_paid_jobcost' VALUE
                CASE
                    WHEN SUM(
                        CASE
                            WHEN j.job_payment_made = 'Y' THEN
                                1
                            ELSE
                                0
                        END
                    ) =0 THEN
                        '-'
                    ELSE
                        TRIM(TO_CHAR(SUM(
                            CASE
                                WHEN j.job_payment_made = 'Y' THEN
                                    NVL(j.job_cost, q.quote_cost)
                                ELSE
                                    0
                            END
                        ), '$99999.99'))
                END,
            'total_unpaid_jobcost' VALUE
                CASE
                    WHEN SUM(
                        CASE
                            WHEN j.job_payment_made = 'N' THEN
                                1
                            ELSE
                                0
                        END
                    ) =0 THEN
                        '-'
                    ELSE
                        TRIM(TO_CHAR(SUM(
                            CASE
                                WHEN j.job_payment_made = 'N' THEN
                                    NVL(j.job_cost, q.quote_cost)
                                ELSE
                                    0
                            END
                        ), '$99999.99'))
                END
        ),
        'quotes' VALUE JSON_ARRAYAGG(
            JSON_OBJECT(
                'quote_no' VALUE q.quote_no,
                'quote_prepared_on' VALUE TO_CHAR(q.quote_prepared_date, 'DD-Mon-YYYY'),
                'preferred_start_date' VALUE TO_CHAR(q.quote_pref_start_date, 'DD-Mon-YYYY'),
                'start_location' VALUE q.quote_start_location,
                'end_location' VALUE q.quote_end_location,
                'quote_cost' VALUE TRIM(TO_CHAR(q.quote_cost, '$99999.99')),
                'assigned_to_job' VALUE q.quote_assigned_job,
                'job_cost' VALUE
                    CASE
                        WHEN j.job_no IS NULL THEN
                            '-'
                        ELSE
                            TRIM(TO_CHAR(NVL(j.job_cost, q.quote_cost), '$99999.99'))
                    END
            )
            ORDER BY q.quote_no
        ) FORMAT JSON
    )
    || ','
FROM
    customer c
    JOIN quote q ON c.cust_no = q.cust_no
    LEFT OUTER JOIN job j ON q.quote_no = j.quote_no
GROUP BY
    c.cust_no,
    c.cust_gname,
    c.cust_fname,
    c.cust_bname,
    c.cust_contact_no,
    c.cust_street,
    c.cust_town,
    c.cust_pcode
ORDER BY
    c.cust_no;
