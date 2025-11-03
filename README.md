# Building-a-Data-Warehouse

This is my take on how to build a data warehouse using Microsoft SQL server. including ETL process, data Modeling and analytics.
KPI Dashboards on PowerBI.

Its an end-to-end project designed to be as a frame work for future use cases and data infastracture of a small business.


# architecture

<img width="842" height="600" alt="image" src="https://github.com/user-attachments/assets/44cfb68b-2f58-4831-8885-6db42123f4f2" />

-  Raw Layer: This stage stores data as-is from sources, later data is ingested from CSV/XLSX/API into SQL Server database.

-  Filtered Layer: This stage cleans, normalize and prepares the data for analysis.

-  BI Ready Layer: Thus layer contains business-ready data modeled into a star schema required for reporting and analytics.    

------
# Project overview:

This frame includes:

1) General data Warehouse design with 3 layers
2) A complete and customizable ETL Process 
3) star query data model
