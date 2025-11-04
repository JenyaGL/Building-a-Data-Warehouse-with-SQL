/*

this script is for loading csv dat from the sources to the raw layer

loading data into rawlayer schema from external CSV files. 
It performs the following actions:
    - Truncates the rawlayer tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to rawlayer tables.

usage:

EXEC  rawlayer.load_rawlayer
===========================================
*/

CREATE OR ALTER PROCEDURE rawlayer.load_rawlayer AS 

BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;

	BEGIN TRY

		SET @batch_start_time = GETDATE()

		PRINT'========================';
		PRINT'Load raw layer'
		PRINT'=========================';

		PRINT'-------------------------';
		PRINT'Load CRM Tables'
		PRINT'-------------------------';

		SET @start_time = GETDATE()
		PRINT 'truncating rawlayer.crm_cust_info'
		TRUNCATE TABLE rawlayer.crm_cust_info

		PRINT 'inserting rawlayer.crm_cust_info'
		BULK INSERT rawlayer.crm_cust_info
		FROM 'C:\Users\jenya\sql\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH ( FIRSTROW = 2,
			   FIELDTERMINATOR = ',',
			   TABLOCK)


		SELECT COUNT(*)
		FROM rawlayer.crm_cust_info

		SET @end_time = GETDATE()
		PRINT 'LOAD Duration:' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds'
		PRINT('------------')

		SET @start_time = GETDATE()
		PRINT 'truncating rawlayer.crm_prd_info'
		TRUNCATE TABLE rawlayer.crm_prd_info

		PRINT 'inserting rawlayer.crm_prd_info'

		BULK INSERT rawlayer.crm_prd_info
		FROM 'C:\Users\jenya\sql\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH ( FIRSTROW = 2,
			   FIELDTERMINATOR = ',',
			   TABLOCK)


		SELECT COUNT(*) FROM rawlayer.crm_prd_info

		SET @end_time = GETDATE()
		PRINT 'Rawlayer LOAD Duration:' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds'
		PRINT('------------')


		SET @start_time = GETDATE()
		PRINT 'truncating rawlayer.crm_sales_details'
		TRUNCATE TABLE rawlayer.crm_sales_details

		PRINT 'inserting rawlayer.crm_sales_details'

		BULK INSERT rawlayer.crm_sales_details
		FROM 'C:\Users\jenya\sql\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH ( FIRSTROW = 2,
			   FIELDTERMINATOR = ',',
			   TABLOCK)


		SELECT COUNT(*) FROM rawlayer.crm_sales_details

		SET @end_time = GETDATE()
		PRINT 'LOAD Duration:' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds'
		PRINT('------------')

		PRINT'-------------------------';
		PRINT'Load ERP Tables';
		PRINT'------------------------';

		SET @start_time = GETDATE()
		PRINT 'truncating'
		TRUNCATE TABLE rawlayer.erp_cust_AZ12

		PRINT 'inserting rawlayer.erp_cust_AZ12'

		BULK INSERT rawlayer.erp_cust_AZ12
		FROM 'C:\Users\jenya\sql\sql-data-warehouse-project\datasets\source_erp\cust_AZ12.csv'
		WITH ( FIRSTROW = 2,
			   FIELDTERMINATOR = ',',
			   TABLOCK)


		SELECT COUNT(*) FROM rawlayer.erp_cust_AZ12

		SET @end_time = GETDATE()
		PRINT 'LOAD Duration:' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds'
		PRINT('------------')


		SET @start_time = GETDATE()
		PRINT 'truncating rawlayer.erp_loc_A101'
		TRUNCATE TABLE rawlayer.erp_loc_A101

		PRINT 'inserting rawlayer.erp_loc_A101'

		BULK INSERT rawlayer.erp_loc_A101
		FROM 'C:\Users\jenya\sql\sql-data-warehouse-project\datasets\source_erp\loc_A101.csv'
		WITH ( FIRSTROW = 2,
			   FIELDTERMINATOR = ',',
			   TABLOCK)


		SELECT COUNT(*) FROM rawlayer.erp_loc_A101

		SET @end_time = GETDATE()
		PRINT 'LOAD Duration:' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds'
		PRINT('------------')


		SET @start_time = GETDATE()
		PRINT 'truncating rawlayer.erp_PX_CAT_G1V2'
		TRUNCATE TABLE rawlayer.erp_PX_CAT_G1V2

		PRINT 'inserting rawlayer.erp_PX_CAT_G1V2'
		BULK INSERT rawlayer.erp_PX_CAT_G1V2
		FROM 'C:\Users\jenya\sql\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH ( FIRSTROW = 2,
			   FIELDTERMINATOR = ',',
			   TABLOCK)


		SELECT COUNT(*) FROM rawlayer.erp_PX_CAT_G1V2

		SET @end_time = GETDATE()
		PRINT 'LOAD Duration:' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds'
		PRINT('------------')

	SET @batch_end_time = GETDATE()
	
	PRINT '----------------'
	PRINT 'LOADING rawlayer duration:' + CAST(DATEDIFF(second,@batch_start_time, @batch_end_time) AS VARCHAR) + 'Seconds'
	PRINT '----------------'

	END TRY

	BEGIN CATCH
		PRINT ' ERROR DURING RAWLAYER LOADING STAGE'
		PRINT ' ERROR'+ ERROR_MESSAGE()
		PRINT ' ERROR'+ CAST (ERROR_MESSAGE() AS VARCHAR)

	END CATCH
END
