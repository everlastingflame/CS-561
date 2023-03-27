with food_sales AS(
SELECT month, prod, sum(quant) as total_sales
from sales
group by month, prod
),

best_months as (
SELECT month, prod, 
	max(food_sales.total_sales) OVER(PARTITION BY food_sales.prod) as best_sale
from food_sales
),

worst_months as(
SELECT month, prod, 
	min(food_sales.total_sales) OVER(PARTITION BY food_sales.prod) as worst_sale
from food_sales
),

best_table as(
SELECT b.month, b.prod
	from best_months as b, food_sales as fsa
	where b.month = fsa.month and b.prod = fsa.prod and b.best_sale = fsa.total_sales
	group by b.month, b.prod 
),

worst_table as(
SELECT w.month, w.prod
	from worst_months as w, food_sales as fsa
	where w.month = fsa.month and w.prod = fsa.prod and w.worst_sale = fsa.total_sales
	group by w.month, w.prod 
)

SELECT b.prod as product, b.month as most_fav_mo, w.month as least_fav_mo
	from best_table as b, worst_table as w
	where b.prod = w.prod
	order by b.prod

