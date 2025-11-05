-- This is an example of a quality check that we do for every table
-- we first do it to find errors and we do it again after fixing them
-- then we do these check once again on the new tables to varify high quality

-- 1) removing Duplicates and missing values(null)
-- Check for null duplicated values in the primary key
-- idealy this quey will return empty

SELECT cst_id,count(*) --place your primary key
FROM filteredlayer.crm_cust_info --place the table name
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id is null

-- 2) removing unwanted spaces
-- check for unwanted spaces in values in string columns
-- idealy this quey will return empty

SELECT cst_firstname -- place a string column
FROM filteredlayer.crm_cust_info -- --place the table name
WHERE cst_firstname != TRIM(cst_firstname)

SELECT cst_firstname
FROM filteredlayer.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname)


-- 3) data normalization and standardization
-- Our aim is to store clear and meaningful values rather than abbreviated terms
-- so in this gender case we will replace F with Female, M with male and NULL with n/a

SELECT DISTINCT cst_gndr
FROM filteredlayer.crm_cust_info

SELECT DISTINCT cst_marital_status
FROM filteredlayer.crm_cust_info



SELECT * FROM filteredlayer.crm_cust_info
