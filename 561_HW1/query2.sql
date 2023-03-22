WITH daily_sales AS(
SELECT month, day, sum(quant) as total_sales
from sales
GROUP BY month, day
),

max_sales AS(
SELECT daily_sales.month as maxMonth, daily_sales.day as MOST_PROFIT_DAY, 
	max(daily_sales.total_sales) OVER(PARTITION BY daily_sales.month) as MOST_PROFIT_TOTAL_Q
from daily_sales
),

min_sales AS(
SELECT daily_sales.month as minMonth, daily_sales.day as LEAST_PROFIT_DAY, 
	min(daily_sales.total_sales) OVER(PARTITION BY daily_sales.month) as LEAST_PROFIT_TOTAL_Q
from daily_sales
),

max_table as(
select d.month, d.day, ma.MOST_PROFIT_TOTAL_Q
from daily_sales as d, max_sales as ma
where d.total_sales = ma.MOST_PROFIT_TOTAL_Q
group by d.month, d.day, ma.MOST_PROFIT_TOTAL_Q
),

min_table as(
select d.month, d.day, mi.LEAST_PROFIT_TOTAL_Q
from daily_sales as d, min_sales as mi
where d.total_sales = mi.LEAST_PROFIT_TOTAL_Q
group by d.month, d.day, mi.LEAST_PROFIT_TOTAL_Q
)

select ma.month, ma.day as most_profit_day, ma.MOST_PROFIT_TOTAL_Q, mi.day as least_profit_day, mi.LEAST_PROFIT_TOTAL_Q
from max_table as ma, min_table as mi
where ma.month = mi.month 
order by ma.month


