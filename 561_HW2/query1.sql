WITH avgSLS as(
SELECT prod, month, ROUND(avg(quant)) as avgQ
FROM sales 
group by prod, month
),

grtr as(
select sales.prod, sales.month, sales.quant
from sales 
INNER JOIN avgSLS
ON sales.prod = avgSLS.prod and sales.month = avgSLS.month + 1 and sales.quant > avgSLS.avgQ
),

grtrFinal as(
select grtr.prod, grtr.month, grtr.quant
from grtr 
INNER JOIN avgSLS
ON grtr.prod = avgSLS.prod and grtr.month = avgSLS.month - 1 and grtr.quant < avgSLS.avgQ
),

lsthn as(
select sales.prod, sales.month, sales.quant
from sales 
INNER JOIN avgSLS
ON sales.prod = avgSLS.prod and sales.month = avgSLS.month + 1 and sales.quant < avgSLS.avgQ
),

lsthnFinal as(
select lsthn.prod, lsthn.month, lsthn.quant
from lsthn 
INNER JOIN avgSLS
ON lsthn.prod = avgSLS.prod and lsthn.month = avgSLS.month - 1 and lsthn.quant < avgSLS.avgQ
),

t_union as(
select * 
from grtrFinal UNION 
	select * 
	from lsthnFinal
),
t_final as(
select distinct sales.prod , sales.month, t_union.quant 
from sales
LEFT JOIN t_union
ON sales.prod = t_union.prod and sales.month = t_union.month)
	select prod product, month, count(quant) SALES_COUNT_BETWEEN_AVGS
	from t_final
	group by prod, month
	order by product, month;
