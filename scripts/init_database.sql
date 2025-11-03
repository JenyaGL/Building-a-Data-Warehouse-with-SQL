/* 

script purpose:

Creating the database and the schemas
the database name is datawarehouse
the schemas that are created in the database are rawlayer, filteredlayer and businessreadylayer

additionaly,
this script purpose is that in a case that there is a database names datawarehouse this script will drop it and create ane one.
all exisitng data will be deleted

/*

-- THE go sepoerator acts as a seperator between sql statements. 
-- some statements require a go seperator in order to execute properly some dont but its good to seperate the code for readability.

USE master
go

--drop datawarehouse
IF EXISTS (Select 1 from sys.databases WHERE name = 'datawarehouse')
BEGIN
	ALTER database datawarehouse SET single_user WITH ROLLBACK IMMEDIATE
	DROP DATABASE datawarehouse
END

go

CREATE DATABASE datawarehouse

use datawarehouse
GO
CREATE SCHEMA rawlayer
GO
CREATE SCHEMA filteredlayer
GO
CREATE SCHEMA businessreadylayer
GO
