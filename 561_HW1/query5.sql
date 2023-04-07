Select Product, customer, CT_AVG, NY_AVG, NJ_AVG, PA_AVG, average, total, count
from
(SELECT CT_report.prod as Product, CT_report.cust as customer, CT_average_sales_quantities as CT_AVG,
NY_average_sales_quantities as NY_AVG,
NJ_average_sales_quantities as NJ_AVG,
PA_average_sales_quantities as PA_AVG
from
(select prod, cust, ROUND(avg(quant)) as CT_average_sales_quantities
from sales 
where state = 'CT' group by prod, cust order by cust, prod) as CT_report

inner join

(select prod, cust, ROUND(avg(quant)) as NY_average_sales_quantities
from sales 
where state = 'NY' group by prod, cust order by cust, prod) as NY_report

on CT_report.cust = NY_report.cust and CT_report.prod = NY_report.prod

inner join

(select prod, cust, ROUND(avg(quant)) as NJ_average_sales_quantities
from sales 
where state = 'NJ' group by prod, cust order by cust, prod) as NJ_report

on CT_report.cust = NJ_report.cust and CT_report.prod = NJ_report.prod

inner join

(select prod, cust, ROUND(avg(quant)) as PA_average_sales_quantities
from sales 
where state = 'PA' group by prod, cust order by cust, prod) as PA_report

on CT_report.cust = PA_report.cust and CT_report.prod = PA_report.prod) as State_avg_report

inner join 

(Select prod, cust, ROUND(avg(quant)) as average, sum(quant) as total, count(quant) as count from sales group by prod, cust) as avg_report

on State_avg_report.product = avg_report.prod and State_avg_report.customer = avg_report.cust