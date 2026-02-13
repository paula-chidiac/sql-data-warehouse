# Data Warehouse & Analytics
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-4169E1?style=flat&logo=postgresql&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-Data_Engineering-blue)
![ETL](https://img.shields.io/badge/ETL-Pipeline-success)
![Architecture](https://img.shields.io/badge/Architecture-Medallion-orange)

Welcome to the **Data Warehouse & Analytics** project repository.  
This project demonstrates the implementation of a modern Data Warehouse using the Medallion architecture, with a focus on dimensional modeling, data quality, and analytical support.

The implementation follows Data Engineering best practices, including structured ETL pipelines and standardized naming conventions.

🇧🇷 Versão em português disponível aqui: [README.md](README.md)

---

## 🏗️ Data Architecture

The architecture follows the **Medallion** pattern, organized into three layers:

### Bronze
Stores raw data ingested from source systems (ERP and CRM) without structural transformations.

### Silver
Responsible for data cleansing, standardization, normalization, and application of data quality rules.

### Gold
Contains data modeled using a **Star Schema**, structured for analytics, reporting, and high-performance analytical queries.

---

## 📖 Project Overview

This project includes:

- Data Warehouse architecture design  
- Development of ETL pipelines  
- Data quality and consistency handling  
- Dimensional modeling (fact and dimension tables)  
- Business-oriented analytical queries  

The final model supports analysis such as:

- Customer behavior  
- Product performance  
- Sales trends  

---

## 🛠️ Technologies Used

- PostgreSQL  
- Draw.io for architecture and data modeling diagrams  
- Git for version control  

---

## 📂 Repository Structure

The repository is organized as follows:

- `datasets/` → CSV files used as data sources  
- `docs/` → Diagrams, data catalog, and technical documentation  
- `scripts/` → SQL scripts organized by layer (bronze, silver, and gold)  
- `tests/` → Data validation and quality control scripts  

---

## 📌 Standards & Conventions

The project follows formal naming standards:

- `snake_case` for all objects  
- `dim_`, `fact_`, and `report_` prefixes in the Gold layer  
- Surrogate keys using the `_key` suffix  
- Clear separation between Bronze, Silver, and Gold layers  

Full documentation of naming conventions is available in the `docs` directory.

---

## 🙏 Acknowledgment

This project was inspired by the educational content from **Data With Baraa**.

The technical implementation, PostgreSQL adaptation, and architectural decisions were developed independently.
