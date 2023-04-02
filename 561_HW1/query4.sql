with cust_purchases as(
select cust,prod, ROUND(avg(quant)) as avg, count(quant), sum(quant) 
	from sales group by cust,prod
),
q1 as(
select cust, prod, ROUND(avg(quant)) as Q1_avg
	from sales
	where month between 1 and 3 
	group by cust, prod
),

q2 as(
select cust, prod, ROUND(avg(quant)) as Q2_avg
	from sales
	where month between 4 and 6 
	group by cust, prod
),

q3 as(
select cust, prod, ROUND(avg(quant)) as Q3_avg
	from sales
	where month between 7 and 9 
	group by cust, prod
),

q4 as(
select cust, prod, ROUND(avg(quant)) as Q4_avg
	from sales
	where month between 10 and 12 
	group by cust, prod
)

SELECT cust_purchases.cust, cust_purchases.prod, q1.Q1_avg, q2.Q2_avg, q3.Q3_avg, q4.Q4_avg, cust_purchases.avg, cust_purchases.sum as total, cust_purchases.count
	from cust_purchases left join q1 on q1.cust = cust_purchases.cust and q1.prod = cust_purchases.prod
	left join q2 on q2.cust = cust_purchases.cust and q2.prod = cust_purchases.prod
	left join q3 on q3.cust = cust_purchases.cust and q3.prod = cust_purchases.prod
	left join q4 on q4.cust = cust_purchases.cust and q4.prod = cust_purchases.prod