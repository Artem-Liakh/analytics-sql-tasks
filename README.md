# 🧠 SQL Marketing Analytics Portfolio

[![SQL](https://img.shields.io/badge/Language-SQL-blue)](https://www.postgresql.org/)
[![PostgreSQL](https://img.shields.io/badge/Database-PostgreSQL-336791?logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![Analytics](https://img.shields.io/badge/Focus-Marketing%20Analytics-orange)](#)
[![Status](https://img.shields.io/badge/Project%20Type-Educational-blueviolet)](#)
[![License: MIT](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

This repository contains structured SQL scripts developed as part of a hands-on marketing analytics curriculum. The scripts demonstrate advanced data manipulation, metric engineering, and query optimization techniques applied to real-world advertising datasets from **Facebook Ads** and **Google Ads**.

---

## 📌 Project Objective

To design and implement SQL-based analytical pipelines for evaluating digital marketing performance, optimizing ad spend, and extracting business insights from multi-source advertising data.

---

## 📂 Folder: `db_scripts/`

Each script represents a milestone in the learning path, progressing from fundamental aggregation to advanced performance analysis.

### `Homeworks_2.sql`
- **Purpose**: Aggregates Facebook Ads daily performance by campaign.
- **Key Metrics**: `CPC`, `CPM`, `CTR`, `ROMI`.
- **Techniques Used**:
  - Conditional aggregation
  - Data type casting
  - Campaign-level segmentation

---

### `Homework_3.sql`
- **Purpose**: Combines Facebook Ads and Google Ads into a unified reporting layer.
- **Key Metrics**: `CPM`, `CTR`, `CPC`, `CPL`, `ROI`, `ROAS`, `ROMI`.
- **Techniques Used**:
  - `UNION` of normalized data sources
  - Aggregated media source comparison
  - Data normalization for cross-channel performance tracking

---

### `Homework_3(part_2).sql`
- **Purpose**: Campaign- and adset-level daily analytics for both platforms.
- **Deliverables**:
  - Granular view of spend and value distribution
  - Time series sorted by `ad_date`, `campaign_name`

---

### `Homework_6.sql`
- **Purpose**: Decodes and extracts `utm_campaign` parameters from tracking URLs.
- **Highlights**:
  - Custom PostgreSQL function `tmp_url_decode(text)`
  - UTM-based grouping for campaign attribution
  - Performance metrics by decoded campaign names

---

### `Homework_7.sql`
- **Purpose**: Monthly trend analysis and benchmarking for UTM campaigns.
- **Key Features**:
  - Rolling comparisons with `LAG()` window functions
  - Monthly KPIs: `CTR`, `CPC`, `CPM`, `ROMI`
  - Percentage change calculations month-over-month

---

## 💡 Key Skills Demonstrated

- Advanced SQL (CTEs, window functions, aggregations)
- Data wrangling & normalization across ad platforms
- URL parameter decoding and regex extraction
- Campaign performance attribution
- Business metric engineering (ROMI, ROAS, etc.)

---

## 🧑‍💻 About the Author

This repository is maintained by a **Data Analytics student** specializing in marketing performance analysis and SQL data modeling. These scripts were developed as part of a practical learning curriculum and demonstrate hands-on experience in working with advertising data pipelines.

---

## 🚀 Future Plans

- Automate pipeline using dbt or Airflow
- Visualize results with BI tools (e.g., Power BI, Tableau)
- Extend scripts to include customer LTV and funnel metrics

---

## 📄 License

This project is released under the [MIT License](LICENSE).
