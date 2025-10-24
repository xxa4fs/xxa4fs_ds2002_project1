# xxa4fs_ds2002_project1
Fall 2025 Jon Tupitza

## Overview
This project creates a dimensional data mart (`project1_dw`) to model sales transactions. 
Concepts used for this project include ETL processing, data transformations, using NoSQL methods, local file systems, and data analysis. 

## ETL Pipeline
Extract:
- `fact_sales_orders_vw` view from the `adventureworks` database provided sales transaction details. The adventureworks database was too large to be uploaded here but the queries version which generated the dimensions where I got the json, csv, and view is uploaded. 
- `products.json` file was exported as a json from what was originally the dim_products dimension on adventureworks database. It contains product information.
- `customers.csv` file was exported as a csv from the dim_customers dimension on adventureworks database. It contains customer information.
- `pymysql` and `pymongo` libraries were used to extract

Transform:
- Pandas dataframes was used to integrate dimension keys (`customer_key`, `product_key`, `date_key`)
- Transformations included merging data if their keys matched + calculating some metrics and handling data type conversions (ex. dates converted to 'datetime64[ns]')
- Missing values were filled with 0 where appropriate

Load:
- Transformed data was loaded into the `project1_dw ` MySQL database
- Tables `dim_date`, `dim_customers`, `dim_products`, and `fact_sales` were created
- A procedure was provided (originally in Microsft T-SQL form that was converted to MySQL form, both versions of which are uploaded in this repository) that was used to create the `dim_date` table

## Business Process
Data mart models the retail sales process and tracks customer purchases of products over time. 
Transaction details are recorded in `fact_sales` which is also linked to `di_customers`, `dim_products`, and `dim_date` if needed for analysis.

## Code Overview
The Jupyter notebook is called `ds2002_project1_take2.ipynb` (take2 because I did not want to try salvaging the take1). 
- Cells 1-5: importing libraries, defining variables and functions for MySQL and MongoDB
- Cell 6: loading `dim_customers` from `customers.csv` and adding surrogate `customer_key`
- Cell 7: uploading json file to MongoDB
- Cell 8: loading `dim_products` from `products.json` via MongoDB, transforming and adding surrogate `product_key`
- Cell 9: creating `dim_date` using the given procedure with dates from 1/1/2001 to 2030/12/31.
- Cell 10-12: extracting data from `fact_sales_orders_vw`, merging it with dimension tables, loading it into `fact_sales`
- Cell 13: SQL queries

## Deployment Strategy
- A local MySQL instance hosts the `project1_dw` data warehouse and accesses the `adventureworks` sample database.
- An Atlas-hosted MongoDB instance stores the `products.json` data.
- Requires Python 3.x with libraries installed via `pip` (e.g., `pymysql`, `pymongo`, `sqlalchemy`, `pandas`).
- Connection credentials are stored in the `mysql_args` and `mongodb_args` where the passwords may or may not be my real passwords
- The solution can scale by adjusting date ranges or adding indexes for larger data.
- Instructors can replicate the project using the provided code, data files, and a MySQL/MongoDB setup with the `adventureworks` database.

## Requirements Met
- `dim_date` enables time-based analysis with a comprehensive date range.
- `dim_customers` and `dim_products` provide customer and product details.
- `fact_sales` models the sales process with metrics like `quantity` and `total_amount`.
- Data sources: MySQL (`adventureworks.fact_sales_orders_vw`), MongoDB (`products.json`), and file system (`customers.csv`).
- Demonstrated with extraction, transformation, and loading.
- Two SQL queries show aggregation and grouping across three tables.

## Submission Artifacts
- **Jupyter Notebook**: `ds2002_project1_take2.ipynb`
- **Data Files**: `customers.csv`, `products.json`, `AdventureWorks_Queries_MySQL.sql`, `Create_Populate_DimDate_MSSQLSvr.sql`, `create_dim_date_mysql.sql`
- **Documentation**: This README.md
