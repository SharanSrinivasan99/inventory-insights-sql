# 📊 Inventory Insights: Wide World Importers (BUSINFO 702)

This repository contains SQL scripts and exploratory data analysis for **BUSINFO 702 - Individual Assignment** at the University of Auckland. The project focuses on deriving insights from the **Wide World Importers** sample database using **advanced SQL queries** and inventory analytics.

---

## 🧩 Project Overview

The aim of this assignment was to explore business questions related to **sales performance**, **inventory turnover**, **supplier reliability**, and **product demand trends**. The insights generated support better operational and strategic decisions around **stock control**, **supply chain efficiency**, and **customer purchasing behaviour**.

All queries were executed using **T-SQL** against Microsoft's Wide World Importers database.

---

## 📌 Key Tasks

### ✅ Task A: SQL Queries with Reasoning
Six structured SQL queries were written, each accompanied by:
- Step-by-step reasoning
- Drafting process with initial errors and how they were resolved
- Explanation of join choices, filtering logic, and aggregations

> These included:
- Calculating average order value per customer (2016)
- Identifying top-performing stock groups by revenue
- Ranking suppliers by sales contribution
- Comparing delivery method usage across functions
- Identifying top 10 customers by unique products and spend
- Exploring purchasing patterns of the top 5 customers using CTE

### ✅ Task B: Exploratory Data Analysis (EDA)
Analytical queries were written to answer inventory-specific questions:
- 🔁 **Stock turnover rate**: Which items sell fast vs. sit idle?
- 📅 **Seasonal trends**: Yearly and monthly sales patterns
- ⏱️ **Supplier reliability**: Vendors with most late deliveries
- 📉 **Outlier detection**: Products with unusual revenue or volume patterns

---

## 📈 Key Findings

- Several stock groups (e.g., Novelty Items, Packaging Materials) dominated total sales.
- A few suppliers were consistently late, affecting fulfilment reliability.
- Items like *USB Food Flash Drives* had high turnover, while others lagged.
- Seasonal spikes observed in November–December for novelty products.
- Delivery methods were unevenly used between sales and purchasing — suggesting process gaps.

---

## 🧠 Learning Reflection

This assignment sharpened:
- Complex SQL skills (joins, subqueries, aggregates, CTEs)
- Logical problem-solving and debugging SQL syntax errors
- Translating business questions into technical queries
- Drawing operational insights from raw transactional data

Shoutout to `ChatGPT`, caffeine, and countless `GROUP BY` errors along the way ☕.

---

## 📂 Files in this Repo

| File Name | Description |
|-----------|-------------|
| `Assingnment_Neat.sql` | Finalised SQL queries with annotations and reasoning |
| `InvAssignment_441056765.pdf` | Formal assignment submission with business context, interpretations, and discussion |
| `BUSINFO 702- Individual assignment specification.pdf` | Official task brief and rubric |

---

## 🛑 Disclaimer

This repository was created as part of a university assignment and is shared for educational purposes. The SQL code is written specifically for the **Wide World Importers** sample database schema and may not apply directly to other systems.

---


---

