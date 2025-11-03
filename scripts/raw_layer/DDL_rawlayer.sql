/*

DDL stage:

this script defines the structure of the raw layer database tabels.
it creates the tables in the raw layer, it the tables already exist it drops them and creates a new empty version of them. 

*/

IF OBJECT_ID ('rawlayer.crm_cust_info','U') IS NOT NULL
	DROP TABLE rawlayer.crm_cust_info

CREATE TABLE rawlayer.crm_cust_info(
cst_id VARCHAR(50),
cst_key VARCHAR(50),
cst_firstname VARCHAR(50),
cst_lastname VARCHAR(50),
cst_marital_status VARCHAR(50),
cst_gndr VARCHAR(50),
cst_create_date DATETIME
)
GO

IF OBJECT_ID ('rawlayer.crm_prd_info','U') IS NOT NULL
	DROP TABLE rawlayer.crm_prd_info

CREATE TABLE rawlayer.crm_prd_info(
prd_id VARCHAR(50),
prd_key VARCHAR(50),
prd_nm VARCHAR(50),
prd_cost INT,
prd_line VARCHAR(50),
prd_start_dt DATETIME,
prd_end_dt DATETIME
)
GO

IF OBJECT_ID ('rawlayer.crm_sales_details','U') IS NOT NULL
	DROP TABLE rawlayer.crm_sales_details

CREATE TABLE rawlayer.crm_sales_details(
sls_ord_num VARCHAR(50),
sls_prd_key VARCHAR(50),
sls_cust_id INT,
sls_order_dt INT,
sls_ship_dt INT,
sls_due_dt INT,
sls_sales INT,
sls_quantity INT,
sls_price INT
)
GO

IF OBJECT_ID ('rawlayer.erp_CUST_AZ12','U') IS NOT NULL
	DROP TABLE rawlayer.erp_CUST_AZ12

CREATE TABLE rawlayer.erp_CUST_AZ12(
CID VARCHAR(50),
BDATE DATE,
GEN VARCHAR(50)
)
GO
  
IF OBJECT_ID ('rawlayer.erp_loc_A101','U') IS NOT NULL
	DROP TABLE rawlayer.erp_loc_A101

CREATE TABLE rawlayer.erp_loc_A101(
CID VARCHAR(50),
CNTRY VARCHAR(50)
)
GO

IF OBJECT_ID ('rawlayer.erp_px_cat_g1v2','U') IS NOT NULL
	DROP TABLE rawlayer.erp_px_cat_g1v2

CREATE TABLE rawlayer.erp_px_cat_g1v2(
ID VARCHAR(50),
CAT VARCHAR(50),
SUBCAT VARCHAR(50),
MAINTENANCE VARCHAR(50)
)
