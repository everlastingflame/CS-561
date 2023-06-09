WITH grouped_sales AS(
SELECT cust, min(quant) as min_q, max(quant) as max_q,ROUND(avg(quant)) as avg_q
FROM sales
GROUP BY cust
),

max_sales AS(
SELECT maximum.cust, max_q, sls.prod, sls.date, sls.state
FROM grouped_sales maximum, sales sls
WHERE maximum.cust = sls.cust and max_q = sls.quant
),

min_sales AS(
SELECT minimum.cust, min_Q, sls2.prod, sls2.date, sls2.state
FROM grouped_sales minimum, sales sls2
WHERE minimum.cust = sls2.cust and min_q = sls2.quant
)

SELECT gr.cust, gr.min_q, MIN.prod, MIN.date, MIN.state, gr.max_q, MAX.prod, MAX.date, MAX.state, gr.avg_q
FROM min_sales AS MIN, max_sales as MAX, grouped_sales AS gr
WHERE MIN.cust = MAX.cust and MIN.cust = gr.cust and MAX.cust = gr.cust
order by cust
