# Building-a-Data-Warehouse

This is my take on how to build a data warehouse using Microsoft SQL server. including ETL process, data Modeling and analytics.
KPI Dashboards on PowerBI.

Its an end-to-end project designed to be as a frame work for future use cases and data infastracture of a small business.


# Architecture

<img width="849" height="610" alt="image" src="https://github.com/user-attachments/assets/35ffc0b9-4b25-4a7c-b80f-c7306ea07823" />


-  Raw Layer: This stage stores data as-is from sources, later data is ingested from CSV/XLSX/API into SQL Server database.

-  Filtered Layer: This stage cleans, normalize and prepares the data for analysis.

-  BI Ready Layer: Thus layer contains business-ready data modeled into a star schema required for reporting and analytics.    

------
# Project overview:

This frame includes:

1) General data Warehouse design with 3 layers
2) A complete and customizable ETL Process 
3) star query data model

Heres a Notion documentation of this project

<https://www.notion.so/Data-Warehouse-Project-29c055b36518803cb54df77b50707fd1?source=copy_link>




Power BI KPI pages, connected via SQL server locally.

[Power BI KPI pages.pdf](https://github.com/user-attachments/files/23482475/Power.BI.KPI.pages.pdf)
