WITH ranked_sales AS (
 SELECT  prod, quant, ROW_NUMBER() OVER (PARTITION BY prod ORDER BY quant) AS sales_rank, COUNT(*) OVER (PARTITION BY prod) AS sales_count
 FROM sales
)
SELECT prod, quant AS median_sales
FROM ranked_sales
WHERE sales_rank = (sales_count)/2;

