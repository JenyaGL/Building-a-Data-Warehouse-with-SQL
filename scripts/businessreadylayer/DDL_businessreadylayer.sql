/*

DDL stage: business ready layer

this script creates the views for the business ready layer in the data warehouse.
This layes is the final dimention and facts tables, they are connected in a star schema.

each view performs transformations and combines data from the filtered layer to produce a clean and bussiness-ready dataset.

it creates the views in the business ready layer; if the views already exist, it drops them and creates a new empty version of them.


usage:
This views can be queried directly for analytics and reporting.
*/


-- Create Dimension: businessreadylayer.dim_customers
-- =============================================================================
IF OBJECT_ID ('filteredlayer.crm_cust_info','V') IS NOT NULL
	DROP TABLE businessreadylayer.dim_customers

CREATE VIEW businessreadylayer.dim_customers AS

SELECT
	ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key,
	cust_info.cst_id AS customer_id,
	cust_info.cst_key AS customer_number,
	cust_info.cst_firstname AS first_name,
	cust_info.cst_lastname AS last_name,
	cust_loc.CNTRY AS country,
	cust_info.cst_marital_status AS martila_status,
CASE WHEN cust_info.cst_gndr != 'Unknown' THEN cust_info.cst_gndr -- cust_info(CRM DATA) is the master table
	 ELSE COALESCE(cust_pers.GEN,'Unknown')
END AS gender,
	cust_pers.BDATE AS birthdate,
	cust_info.cst_create_date AS create_date



	
FROM filteredlayer.crm_cust_info AS cust_info
LEFT JOIN filteredlayer.erp_CUST_AZ12 as cust_pers ON cust_info.cst_key = cust_pers.CID
LEFT JOIN filteredlayer.erp_LOC_A101 as cust_loc ON cust_info.cst_key = cust_loc.CID




print '-----------------'

-- Create Dimension: businessreadylayer.dim_customers
-- =============================================================================
IF OBJECT_ID ('businessreadylayer.dim_products','V') IS NOT NULL
	DROP TABLE businessreadylayer.dim_products

go
CREATE VIEW businessreadylayer.dim_products as 

SELECT
ROW_NUMBER() OVER (ORDER BY prd_start_dt,prd_key) AS product_key,
prd_info.prd_id AS product_id,
prd_info.cat_id AS category_id,
prd_info.prd_key AS product_number,
prd_info.prd_nm AS product_name,
prd_info.prd_cost AS poduct_cost,
prd_info.prd_line AS product_line,
prd_cat.CAT AS category,
prd_cat.SUBCAT AS sub_category,
prd_cat.MAINTENANCE AS maintenance,
prd_info.prd_start_dt AS  product_start_date


FROM filteredlayer.crm_prd_info AS prd_info
Left JOIN filteredlayer.erp_px_cat_g1v2 AS prd_cat ON prd_info.cat_id = prd_cat.id
WHERE prd_end_dt IS NULL --Filter out all historical data



print '-----------------'

-- Create Dimension: businessreadylayer.dim_customers
-- =============================================================================
IF OBJECT_ID ('businessreadylayer.fact_orders','V') IS NOT NULL
	DROP TABLE businessreadylayer.fact_orders
  
go
CREATE VIEW businessreadylayer.fact_orders AS

SELECT
sales.sls_ord_num AS order_num,
dim_pr.product_key,
dim_cus.customer_key,
sales.sls_order_dt AS order_date,
sales.sls_ship_dt AS Ship_date,
sales.sls_due_dt AS due_date,
sales.sls_sales AS sales_amount,
sales.sls_quantity AS sales_quantity,
sales.sls_price AS sales_price

FROM filteredlayer.crm_sales_details AS sales
LEFT JOIN businessreadylayer.dim_products AS dim_pr ON sales.sls_prd_key = dim_pr.product_number
LEFT JOIN businessreadylayer.dim_customers AS dim_cus ON sales.sls_cust_id = dim_cus.customer_id


-- this is a test for orders with miossing values

SELECT *
FROM businessreadylayer.fact_orders AS f_orders
LEFT JOIN businessreadylayer.dim_customers AS dim_cus ON f_orders.customer_key = dim_cus.customer_key
LEFT JOIN businessreadylayer.dim_products AS dim_pr ON f_orders.product_key = dim_pr.product_key
WHERE dim_cus.customer_key Is NULL


SELECT * FROM businessreadylayer.fact_orders
