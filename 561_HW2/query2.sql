With Q1 as(
select cust, prod, month, ROUND(avg(quant)) as Q1avg, 1 as QRTR
from sales
where month between 1 and 3
group by cust, prod, month
),

Q2 as(
select cust, prod, month, ROUND(avg(quant)) as Q2avg, 2 as QRTR
from sales
where month between 4 and 6
group by cust, prod, month
),

Q3 as(
select cust, prod, month, ROUND(avg(quant)) as Q3avg, 3 as QRTR
from sales
where month between 7 and 9
group by cust, prod, month
),

Q4 as(
select cust, prod, month, ROUND(avg(quant)) as Q4avg, 4 as QRTR
from sales
where month between 10 and 12
group by cust, prod, month
),

all_quarters AS (
SELECT cust, prod, QRTR, Q1avg as avg_sales
FROM (
  SELECT cust, prod, QRTR, Q1avg FROM Q1
  UNION ALL
  SELECT cust, prod, QRTR, Q2avg FROM Q2
  UNION ALL
  SELECT cust, prod, QRTR, Q3avg FROM Q3
  UNION ALL
  SELECT cust, prod, QRTR, Q4avg FROM Q4
) AS quarterly_sales
GROUP BY cust, prod, QRTR, avg_sales
),

avgSLS as(
SELECT cust, prod, QRTR, ROUND(avg(avg_sales)) as avgQ
FROM all_quarters 
group by cust, prod, QRTR
)

select t_cur.cust customer, t_cur.prod product, t_cur.QRTR, t_past.avgQ as before_avg, t_cur.avgQ during_avg, t_future.avgQ as after_avg
from avgSLS as t_cur
LEFT JOIN avgSLS as t_past
ON t_past.cust = t_cur.cust and t_past.prod = t_cur.prod and t_cur.QRTR - 1 = t_past.QRTR
LEFT JOIN avgSLS as t_future
ON t_future.cust = t_cur.cust and t_future.prod = t_cur.prod and t_cur.QRTR + 1 = t_future.QRTR
order by customer, product, QRTR;




