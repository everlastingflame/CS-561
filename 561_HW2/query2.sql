with avgSLS as(
SELECT cust, prod, ceiling(month / 3.0) qtr, ROUND(avg(quant)) as avgQ
FROM sales 
group by cust, prod, qtr
)

select during.cust customer, during.prod product, during.qtr, bfr.avgQ as before_avg, during.avgQ during_avg, aftr.avgQ as after_avg
from avgSLS as during
LEFT JOIN avgSLS as bfr
ON bfr.cust = during.cust and bfr.prod = during.prod and during.qtr - 1 = bfr.qtr
LEFT JOIN avgSLS as aftr
ON aftr.cust = during.cust and aftr.prod = during.prod and during.qtr + 1 = aftr.qtr
order by customer, product, qtr;