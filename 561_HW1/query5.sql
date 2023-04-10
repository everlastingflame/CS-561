with NY_max as(
select prod, cust, max(quant) as NY_max_quantities
from sales 
where state = 'NY' 
group by prod, cust
order by cust, prod
),

NY_FINAL as(
select sls.prod, sls.cust, sls.date, nym.NY_max_quantities as NYMAX
from sales as sls, NY_max as nym
where nym.NY_max_quantities = sls.quant and nym.cust = sls.cust and nym.prod = sls.prod and sls.state = 'NY'
group by sls.prod, sls.cust, sls.date, nym.NY_max_quantities
order by cust, prod
),

CT_max as(
select prod, cust, max(quant) as CT_max_quantities
from sales 
where state = 'CT' 
group by prod, cust 
order by cust, prod
),

CT_FINAL as(
select sls.prod, sls.cust, sls.date, ctm.CT_max_quantities as CTMAX
from sales as sls, CT_max as ctm
where ctm.CT_max_quantities = sls.quant and ctm.cust = sls.cust and ctm.prod = sls.prod and sls.state = 'CT'
group by sls.prod, sls.cust, sls.date, ctm.CT_max_quantities
order by cust, prod
),

NJ_max as(
select prod, cust, max(quant) as NJ_max_quantities
from sales 
where state = 'NJ' 
group by prod, cust 
order by cust, prod
),

NJ_FINAL as(
select sls.prod, sls.cust, sls.date, njm.NJ_max_quantities AS NJMAX
from sales as sls, NJ_max as njm
where njm.NJ_max_quantities = sls.quant and njm.cust = sls.cust and njm.prod = sls.prod and sls.state = 'NJ'
group by sls.prod, sls.cust, sls.date, njm.NJ_max_quantities
order by cust, prod
)

SELECT njm.cust, njm.prod, njm.NJMAX as NJ_MAX, njm.date, nym.NYMAX as NY_MAX, nym.date, ctm.CTMAX as CT_MAX, ctm.date
from NJ_FINAL as njm, NY_FINAL as nym, CT_FINAL as ctm
where njm.prod = nym.prod and nym.prod = ctm.prod and njm.cust = nym.cust and nym.cust = ctm.cust
