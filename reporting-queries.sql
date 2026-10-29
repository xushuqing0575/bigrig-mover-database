-- Selected portfolio excerpt from T5-brm-select.sql
-- Chloe Shuqing Xu. Requires the matching Oracle project schema.

/* (a) */
SELECT
    c.cust_no,
    CASE 
        WHEN c.cust_bname IS NOT NULL THEN 
            c.cust_bname
        WHEN c.cust_gname IS NOT NULL
            AND c.cust_fname IS NOT NULL THEN
            c.cust_gname
            || ' '
            || c.cust_fname
        WHEN c.cust_gname IS NOT NULL THEN
            c.cust_gname
        ELSE 
            c.cust_fname
    END AS customer_name,
    COUNT(q.quote_no) AS num_quotes,
    lpad(TO_CHAR(AVG(q.quote_cost), '$999,999.99'), 15, ' ') AS avg_quoted_cost
FROM 
        customer c 
    JOIN quote q ON c.cust_no=q.cust_no
GROUP BY
    c.cust_no,
    c.cust_bname,
    c.cust_gname,
    c.cust_fname
HAVING
        COUNT(q.quote_no)>1
    AND AVG(q.quote_cost)>(
        SELECT
            AVG(quote_cost)
        FROM
            quote
    )
ORDER BY
    AVG(q.quote_cost)DESC,
    c.cust_no;


/* (b) */
SELECT
    e.emp_no,
    CASE
        WHEN e.emp_gname IS NOT NULL
            AND e.emp_fname IS NOT NULL THEN
            e.emp_gname
            || ' '
            || e.emp_fname
        WHEN e.emp_gname IS NOT NULL THEN
            e.emp_gname
        ELSE
            e.emp_fname
    END AS emp_name,
    CASE e.emp_role
        WHEN 'B' THEN
            'Manager'
        WHEN 'T' THEN
            'Truck Dispatcher'
        WHEN 'M' THEN
            'Mechanic'
        WHEN 'D' THEN
            'Driver'
    END AS emp_role_full,
    CASE
        WHEN m.emp_no IS NULL THEN
            'No Manager'
        WHEN m.emp_gname IS NOT NULL
            AND m.emp_fname IS NOT NULL THEN
            m.emp_gname
            || ' '
            || m.emp_fname
        WHEN m.emp_gname IS NOT NULL THEN
            m.emp_gname
        ELSE
            m.emp_fname
    END AS manager_name,
    CASE
        WHEN e.emp_role = 'T' THEN
           COUNT(j.job_no)
        ELSE
            NULL
    END AS jobs_dispatched
FROM 
    employee e 
    LEFT OUTER JOIN employee m ON e.emp_no_manager=m.emp_no
    LEFT OUTER JOIN job j ON e.emp_no=j.sched_emp_no
GROUP BY
    e.emp_no,
    e.emp_gname,
    e.emp_fname,
    e.emp_role,
    m.emp_no,
    m.emp_gname,
    m.emp_fname
ORDER BY
    e.emp_no;


/* (c) */
SELECT 
    co.truck_vin,
    rpad(t.truck_rego,10, ' ') AS truck_rego,
    rpad(co.trailer_code, 12, ' ') AS trailer_code,
    lpad(TO_CHAR(tr.trailer_purchase_cost, '$999,999.99'), 21, ' ')AS trailer_purchase_cost,
    COUNT(j.job_no) AS num_jobs,
    CASE
        WHEN COUNT(j.job_no)=0 THEN
            lpad('No jobs', 17, ' ')
        ELSE
            lpad(TO_CHAR(SUM(q.quote_cost), '$999,999.99'), 17, ' ')
    END AS total_quoted_cost,
    CASE
        WHEN COUNT(j.job_no)=0 THEN
            'Never Used'
        WHEN COUNT(j.job_no)>(
            SELECT
                AVG(COUNT(*))
            FROM
                job
            GROUP BY
                    truck_vin,
                    trailer_code
        ) THEN
            'High Use'
        ELSE
            'Standard Use'
    END AS usage 
FROM
        combination co
    JOIN truck t ON co.truck_vin=t.truck_vin
    JOIN trailer tr ON co.trailer_code=tr.trailer_code
    LEFT OUTER JOIN job j ON co.truck_vin=j.truck_vin
                            AND co.trailer_code=j.trailer_code
    LEFT OUTER JOIN quote q ON j.quote_no = q.quote_no
GROUP BY
    co.truck_vin,
    t.truck_rego,
    co.trailer_code,
    tr.trailer_purchase_cost
ORDER BY
    COUNT(j.job_no) DESC,
    co.truck_vin,
    co.trailer_code;
