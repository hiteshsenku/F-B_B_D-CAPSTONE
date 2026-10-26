# Completed Orders Analytics: SQL, Spreadsheet, Dashboard Specification, and AI Verification

## Project overview

This project analyzes seeded order data using SQL, prepares a cleaned completed-orders extract for spreadsheet reporting, specifies a leadership dashboard, and documents how AI-generated SQL and spreadsheet advice were verified against the data.

- **SQL compiler and dialect:** SQLite; the queries were run against the provided SQLite-compatible schema and seed.
- **Spreadsheet tool used:** LibreOffice Calc for spreadsheet review and formula recalculation.
- **Dashboard built in Tableau Public:** No. Part C is a detailed Tableau Public build specification; an interactive workbook/dashboard was not built or published.

## Three most important findings

Completed orders total **₹346,200 across 63 orders and 106 units**, consistent with Part A q05 and the Part B completed-order summary. **North is the leading region at ₹119,300**, compared with South at ₹82,500; Electronics is the largest category at **₹142,300**. Revenue varies by month: overall October 2026 revenue is ₹93,100 versus ₹154,800 in November, with Home revenue rising from ₹12,600 to ₹83,200. Separately, North revenue decreases from ₹53,500 in September to ₹41,300 in October, a **22.8% decline**; this contradicts the unsupported AI claim that North revenue grew 38% month over month.

## File index

| File | Part | Purpose |
|---|---|---|
| `README.md` | All parts | Project overview, tools, key findings, file index, and assumptions. |
| `sql/00_schema_and_seed.sql` | Part A | Creates and seeds the source database tables. |
| `sql/q01.sql` | Part A | Query 01. |
| `sql/q02.sql` | Part A | Query 02; source data quality / missing amount check. |
| `sql/q03.sql` | Part A | Query 03. |
| `sql/q04.sql` | Part A | Query 04. |
| `sql/q05.sql` | Part A | Completed-order revenue and KPI totals. |
| `sql/q06.sql` | Part A | Query 06. |
| `sql/q07.sql` | Part A | Query 07. |
| `sql/q08.sql` | Part A | Query 08. |
| `sql/q09.sql` | Part A | Enriched order export query. |
| `sql/q10.sql` | Part A | Query 10. |
| `sql/q11.sql` | Part A | Monthly regional revenue query. |
| `sql/q12.sql` | Part A | Query 12. |
| `sql/q13.sql` | Part A | Rep/month revenue, target, and performance-tier query. |
| `sql/d1_corrected.sql` | Part D | Corrected regional completed-order revenue query for Scenario D1. |
| `results/query_results.md` | Part A | Recorded SQL query outputs. |
| `data/orders_enriched.csv` | Part A | Enriched order dataset exported from q09. |
| `data/orders_clean.csv` | Part B | Cleaned completed-orders extract used for spreadsheet reporting and Part C. |
| `docs/spreadsheet_notes.md` | Part B | Spreadsheet cleaning, formulas, summary tables, and reconciliation notes. |
| `docs/dashboard_spec.md` | Part C | Tableau Public dashboard specification, chart data, layout, insights, and recommendations. |
| `docs/ai_log.md` | Part D | Structured prompts, SQL defect analysis and verification, formula diagnosis, and skeptical-analyst review. |

## Assumptions and choices

- SQLite is the SQL dialect used with the supplied schema and seed.
- Revenue is `SUM(orders.amount)` for completed orders when the task asks for completed-order revenue. Missing source amounts are not converted to zero; the three missing amounts identified in the source belong to pending orders and do not affect the completed-order revenue total.
- Part C uses `data/orders_clean.csv`, containing completed orders only. `order_month` is retained in `YYYY-MM` format so it can be sorted chronologically.
- Part C specifies a Tableau Public dashboard but does not claim an interactive dashboard was built or published.
- Where the brief allowed chart choices, horizontal bar charts are used for regional and category comparisons, and the category filter defaults to All.
