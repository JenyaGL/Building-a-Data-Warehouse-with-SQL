--EXEC filteredlayer.LOAD_FILTEREDLAYER

CREATE OR ALTER PROCEDURE filteredlayer.LOAD_FILTEREDLAYER AS
BEGIN

	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME; 
    BEGIN TRY
        SET @batch_start_time = GETDATE();
        PRINT '================================================';
        PRINT 'Loading filteredlayer';
        PRINT '================================================';

		PRINT '------------------------------------------------';
		PRINT 'Loading CRM Tables';
		PRINT '------------------------------------------------';


	-- INSERTING FILTERED rawlayer.crm_cust_info DATA TO filteredlayer.crm_cust_info

	SET @start_time = GETDATE()

	PRINT 'TRUNCATE TABLE filteredlayer.crm_cust_info'


	TRUNCATE TABLE filteredlayer.crm_cust_info

	PRINT 'NSERTING FILTERED rawlayer.crm_cust_info DATA TO filteredlayer.crm_cust_info'


	INSERT INTO filteredlayer.crm_cust_info(
				cst_id,
				cst_key,
				cst_firstname,
				cst_lastname,
				cst_marital_status,
				cst_gndr,
				cst_create_date)

	SELECT 
	cst_id,
	cst_key,
	TRIM(cst_firstname) AS cst_firstname,
	TRIM(cst_lastname) AS cst_lastname,

	CASE
		WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
		WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
		ELSE 'Unknown'
	END cst_marital_status,

	CASE
		WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
		WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
		ELSE 'Unknown'
	END cst_gndr,

		 cst_create_date
	FROM(SELECT *,ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) as flag_last
	FROM rawlayer.crm_cust_info

	WHERE cst_id IS NOT NULL) AS T
	WHERE FLAG_LAST = 1



	SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';



	SET @start_time = GETDATE();

	PRINT 'TRUNCATE TABLE filteredlayer.crm_prd_info'


	TRUNCATE TABLE filteredlayer.crm_prd_info

	PRINT 'NSERTING FILTERED rawlayer.crm_prd_info DATA TO filteredlayer.crm_prd_info'

	-- INSERTING FILTERED RAWLAYER.CRM_PRD_INFO DATA TO filteredlayer.crm_prd_info TABLE 

	INSERT INTO filteredlayer.crm_prd_info (
		prd_id,
		cat_id,
		prd_key,
		prd_nm,
		prd_cost,
		prd_line,
		prd_start_dt,
		prd_end_dt
	)

	SELECT
	prd_id,
	REPLACE(SUBSTRING(prd_key,1,5),'-','_') AS cat_id, -- this is the tables's Primary key to build relashionship with erp_PX_CAT_G1V2 table -- EXTRACT CATEGORY ID

	SUBSTRING(prd_key,7,LEN(prd_key)) AS prd_key, -- this is the foreign key to build relashionship with CRM_SALES_details table -- EXTRACT PRODUCT KEY
	prd_nm,
	ISNULL(prd_cost,0) AS prd_cost, --replacing NULL values with 0, since its the prices data.
	CASE UPPER(TRIM(prd_line))
		WHEN 'M' THEN 'Mountain'
		WHEN 'R' THEN 'Road'
		WHEN 'S' THEN 'Sport'
		WHEN 'T' THEN 'Touring'
		ELSE 'Unknown'
	END prd_line, -- replace the category abbeviations into the full terms to make sure its understood


	CAST(prd_start_dt AS DATE) AS prd_start_dt,
	CAST(LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)-1 AS DATE) AS prd_end_dt

	FROM rawlayer.crm_prd_info

	SET @end_time = GETDATE();
    PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
    PRINT '>> -------------';

	-- SELECT * FROM filteredlayer.crm_prd_info

	SET @start_time = GETDATE();

	PRINT 'TRUNCATE TABLE filteredlayer.crm_sales_details'

	TRUNCATE TABLE filteredlayer.crm_sales_details

	PRINT 'NSERTING FILTERED rawlayer.crm_sales_details DATA TO filteredlayer.crm_sales_details'

	-- INSERTING FILTERED RAWLAYER.crm_sales_details DATA TO filteredlayer.crm_sales_details TABLE 

	INSERT INTO filteredlayer.crm_sales_details (

	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	sls_order_dt,
	sls_ship_dt,
	sls_due_dt,
	sls_sales,
	sls_quantity,
	sls_price
	)

	SELECT
	sls_ord_num, 
	sls_prd_key, -- This key connects with crm_prd_info  
	sls_cust_id, -- This key connects with crm_cust_info

	CASE WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL
		 ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
	END AS sls_order_dt, -- we go with the same logic on all date column so we will not have any errors in the fututre

	CASE WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN NULL
		 ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE) -- we go with the same logic on all date column so we will not have any errors in the fututre
	END AS sls_ship_dt,

	CASE WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8 THEN NULL
		 ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE) -- we go with the same logic on all date column so we will not have any errors in the fututre
	END AS sls_due_dt,

	CASE 
		WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price)
			THEN sls_quantity * ABS(sls_price)
		ELSE sls_sales
	END AS sls_sales, -- Recalculate sales if original value is missing or incorrect

		sls_quantity,

	CASE 
		WHEN sls_price IS NULL OR sls_price <= 0 
			THEN sls_sales / NULLIF(sls_quantity, 0)
		ELSE sls_price  -- Derive price if original value is invalid
	END AS sls_price

	FROM rawlayer.crm_sales_details

	-- TEST TO SEE IF TRIM FUNCTION IS NEEDED ON A STRING COLUMN AND THE CONNECTIONS BETWEEN AND TO CHECK RELASHIONSHIP KEYS BETWEEN THE TABLES
	-- WHERE sls_ord_num != TRIM(sls_ord_num) 
	-- WHERE sls_cust_id NOT IN (SELECT cst_id from Filteredlayer.crm_cust_info)
	-- WHERE sls_prd_key NOT IN (SELECT prd_key from Filteredlayer.crm_prd_info)

	-- SELECT COUNT(*) FROM filteredlayer.crm_sales_details
	SET @end_time = GETDATE();
    PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
    PRINT '>> -------------';

		PRINT '------------------------------------------------';
		PRINT 'Loading ERP Tables';
		PRINT '------------------------------------------------';


	SET @start_time = GETDATE();

	PRINT 'TRUNCATE TABLE filteredlayer.erp_CUST_AZ12'

	TRUNCATE TABLE filteredlayer.erp_CUST_AZ12

	PRINT 'NSERTING FILTERED rawlayer.erp_CUST_AZ12 DATA TO filteredlayer.erp_CUST_AZ12 TABLE'

	-- INSERTING FILTERED rawlayer.erp_CUST_AZ12 DATA TO filteredlayer.erp_CUST_AZ12 TABLE 

	INSERT INTO filteredlayer.erp_CUST_AZ12 (CID,BDATE,GEN)

	SELECT

	CASE WHEN CID LIKE 'NAS%' THEN SUBSTRING(CID, 4, LEN(CID))
		 ELSE CID
	END AS CID,

	CASE WHEN BDATE > GETDATE() THEN NULL
		 ELSE BDATE
	END AS BDATE,


	CASE WHEN UPPER(TRIM(GEN)) IN ('F','FEMALE') THEN 'FEMALE'
		 WHEN UPPER(TRIM(GEN)) IN ('M','MALE') THEN 'MALE'
		 ELSE 'Unknown'
	END AS GEN

	FROM rawlayer.erp_CUST_AZ12


	PRINT 'TRUNCATE TABLE filteredlayer.erp_loc_A101'

	TRUNCATE TABLE filteredlayer.erp_loc_A101

	PRINT 'NSERTING FILTERED rawlayer.erp_loc_A101 DATA TO filteredlayer.erp_loc_A101 TABLE'

	-- INSERTING FILTERED rawlayer.erp_CUST_AZ12 DATA TO filteredlayer.erp_CUST_AZ12 TABLE 

	SET @end_time = GETDATE();
    PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
    PRINT '>> -------------';


	SET @start_time = GETDATE();

	INSERT INTO filteredlayer.erp_loc_A101(

	CID,
	CNTRY
	)

	Select

	REPLACE(CID,'-','') CID,

	CASE WHEN UPPER(TRIM(CNTRY)) IN ('US','UNITED STATES','USA') THEN 'UNITED STATES'
		 WHEN UPPER(TRIM(CNTRY)) IN ('UK','UNITED KINGDOM') THEN 'UNITED KINGDOM'
		 WHEN UPPER(TRIM(CNTRY)) IN ('DE','GERMANY') THEN 'GERMANY'
		 WHEN UPPER(TRIM(CNTRY)) IN ('CA','CANADA') THEN 'CANADA'
		 WHEN UPPER(TRIM(CNTRY)) IN ('FR','FRANCE') THEN 'FRANCE'
		 when UPPER(TRIM(CNTRY)) IN ('AUS','AUSTRALIA') THEN 'AUSTRALIA'

		 ELSE 'Unknown'
	END AS CNTRY

	from rawlayer.erp_LOC_A101

	SET @end_time = GETDATE();
    PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
    PRINT '>> -------------';


	SET @start_time = GETDATE();

	PRINT 'TRUNCATE TABLE filteredlayer.erp_px_cat_g1v2'

	TRUNCATE TABLE filteredlayer.erp_px_cat_g1v2

	PRINT 'NSERTING FILTERED rawlayer.erp_CUST_AZ12 DATA TO filteredlayer.erp_CUST_AZ12 TABLE'

	INSERT INTO filteredlayer.erp_px_cat_g1v2(

	ID,
	CAT,
	SUBCAT,
	MAINTENANCE
	)

	SELECT
	ID,
	CAT,
	SUBCAT,
	MAINTENANCE

	FROM RAWLAYER.erp_px_cat_g1v2

SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

		SET @batch_end_time = GETDATE();
		PRINT '=========================================='
		PRINT 'Loading Silver Layer is Completed';
        PRINT '   - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '=========================================='
		
	END TRY
	BEGIN CATCH
		PRINT '=========================================='
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '=========================================='
	END CATCH
END
