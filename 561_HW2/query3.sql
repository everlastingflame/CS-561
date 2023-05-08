with avgSLS as(
SELECT cust, prod, state, ROUND(avg(quant)) quant 
from sales 
group by cust, prod, state
),
otherCust as(
SELECT sls.cust, sls.prod, sls.state, ROUND(avg(sls2.quant)) quant
from sales sls
LEFT JOIN sales sls2
on sls.prod = sls2.prod and sls.state = sls2.state and sls.cust <> sls2.cust 
group by sls.cust, sls.prod, sls.state
),

otherProd as(
select sls.cust, sls.prod, sls.state, ROUND(avg(sls2.quant)) quant
from sales sls
LEFT JOIN sales sls2
ON sls.prod <> sls2.prod and sls.state = sls2.state and sls.cust = sls2.cust
group by sls.cust, sls.prod, sls.state
)

select avgSLS.cust customer, avgSLS.prod product, avgSLS.state state, ROUND(avgSLS.quant) PROD_AVG, ROUND(otherCust.quant) OTHER_CUST_AVG, ROUND(otherProd.quant) OTHER_PROD_AVG
from avgSLS
LEFT JOIN otherCust
ON avgSLS.cust = otherCust.cust and avgSLS.prod = otherCust.prod and avgSLS.state = otherCust.state
LEFT JOIN otherProd
ON avgSLS.cust = otherProd.cust and avgSLS.prod = otherProd.prod and avgSLS.state = otherProd.state
order by customer, product;