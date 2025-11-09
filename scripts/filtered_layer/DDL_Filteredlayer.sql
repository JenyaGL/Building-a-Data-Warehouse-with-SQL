/*

DDL stage: filtered layer

this script defines the structure of the filtered layer database tables.

it creates the tables in the filtered layer; if the tables already exist, it drops them and creates a new empty version of them. 

*/

IF OBJECT_ID ('filteredlayer.crm_cust_info','U') IS NOT NULL
	DROP TABLE filteredlayer.crm_cust_info

CREATE TABLE filteredlayer.crm_cust_info(
cst_id VARCHAR(50),
cst_key VARCHAR(50),
cst_firstname VARCHAR(50),
cst_lastname VARCHAR(50),
cst_marital_status VARCHAR(50),
cst_gndr VARCHAR(50),
cst_create_date DATETIME,
dwh_create_date DATETIME2 DEFAULT GETDATE()
)
GO

IF OBJECT_ID ('filteredlayer.crm_prd_info','U') IS NOT NULL
	DROP TABLE filteredlayer.crm_prd_info

CREATE TABLE filteredlayer.crm_prd_info(
prd_id VARCHAR(50),
prd_key VARCHAR(50),
prd_nm VARCHAR(50),
prd_cost INT,
prd_line VARCHAR(50),
prd_start_dt DATETIME,
prd_end_dt DATETIME,
dwh_create_date DATETIME2 DEFAULT GETDATE()
)
GO

IF OBJECT_ID ('filteredlayer.crm_sales_details','U') IS NOT NULL
	DROP TABLE filteredlayer.crm_sales_details

CREATE TABLE filteredlayer.crm_sales_details(
sls_ord_num VARCHAR(50),
sls_prd_key VARCHAR(50),
sls_cust_id INT,
sls_order_dt DATE,
sls_ship_dt DATE,
sls_due_dt DATE,
sls_sales INT,
sls_quantity INT,
sls_price INT,
dwh_create_date DATETIME2 DEFAULT GETDATE()
)
GO

IF OBJECT_ID ('filteredlayer.erp_CUST_AZ12','U') IS NOT NULL
	DROP TABLE filteredlayer.erp_CUST_AZ12

CREATE TABLE filteredlayer.erp_CUST_AZ12(
CID VARCHAR(50),
BDATE DATE,
GEN VARCHAR(50),
dwh_create_date DATETIME2 DEFAULT GETDATE()
)
GO

IF OBJECT_ID ('filteredlayer.erp_loc_A101','U') IS NOT NULL
	DROP TABLE filteredlayer.erp_loc_A101

CREATE TABLE filteredlayer.erp_loc_A101(
CID VARCHAR(50),
CNTRY VARCHAR(50),
dwh_create_date DATETIME2 DEFAULT GETDATE()
)
GO

IF OBJECT_ID ('filteredlayer.erp_px_cat_g1v2','U') IS NOT NULL
	DROP TABLE filteredlayer.erp_px_cat_g1v2

CREATE TABLE filteredlayer.erp_px_cat_g1v2(
ID VARCHAR(50),
CAT VARCHAR(50),
SUBCAT VARCHAR(50),
MAINTENANCE VARCHAR(50),
dwh_create_date DATETIME2 DEFAULT GETDATE()
)
GO
