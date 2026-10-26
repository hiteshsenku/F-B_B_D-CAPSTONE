# Part C — Tableau Public Dashboard Specification

## Data source

Connect Tableau Public to `data/orders_clean.csv`. The file contains 63 completed orders and 13 columns. Set the numeric fields to Number (whole number); keep `order_month` as a string in `YYYY-MM` format so the labels remain exactly `2026-09`, `2026-10`, and `2026-11`. For the line chart, sort `order_month` ascending; the fixed-width `YYYY-MM` labels sort chronologically.

| Column | Tableau role | Classification | Notes |
|---|---|---|---|
| `order_id` | Dimension | Dimension | Unique order identifier; do not aggregate or sum it. |
| `order_month` | Dimension | Dimension | Month label in `YYYY-MM` format. |
| `clean_first_name` | Dimension | Dimension | Cleaned customer first name. |
| `clean_last_name` | Dimension | Dimension | Cleaned customer last name. |
| `region` | Dimension | Dimension | Sales region. |
| `rep_name` | Dimension | Dimension | Sales representative. |
| `item` | Dimension | Dimension | Product/item name. |
| `category` | Dimension | Dimension | Product category. |
| `unit_price` | Measure | Measure | Unit price in INR. |
| `quantity` | Measure | Measure | Units on the order. |
| `amount` | Measure | Measure | Recorded order amount in INR; use `SUM(amount)` for revenue. |
| `revenue_calc` | Measure | Measure | Calculated `unit_price × quantity`, used as a validation measure. |
| `status` | Dimension | Dimension | Status field; the CSV contains completed orders only. |

**Field-count check:** 13 columns total — 9 Dimensions and 4 Measures.

## KPI cards

Create two KPI cards at the top of the dashboard. The values below represent the full dataset with the `category` filter set to **All**.

| KPI card | Tableau calculation | Required displayed value |
|---|---|---:|
| Total Revenue | `SUM([amount])` | **₹346,200 INR** |
| Total Units Sold | `SUM([quantity])` | **106 units** |

The Total Revenue card equals Part A, q05's `total_revenue` of **346200 INR**.

## Chart sheets

All figures in the following tables are for the complete dataset with `category = All`. Revenue uses `SUM(amount)` in INR. When a category filter is selected, the views should recalculate to the selected category.

### 1. Revenue by Region

- **Chart type:** Horizontal bar chart.
- **Rows shelf:** `region`.
- **Columns shelf:** `SUM(amount)`.
- **Colour shelf:** `region` (one consistent colour per region).
- **Marks / labels:** Bar; label each bar with `SUM(amount)` formatted as INR with comma separators.
- **Sort:** `SUM(amount)` descending.
- **Why this chart:** A horizontal bar chart makes regional revenue easy to compare and rank at a glance.

Plain-text data table (INR):

| Region | Revenue (`SUM(amount)`) |
|---|---:|
| North | 119,300 |
| South | 82,500 |
| West | 74,900 |
| East | 69,500 |
| **Grand Total** | **346,200** |

### 2. Revenue by Category

- **Chart type:** Horizontal bar chart.
- **Rows shelf:** `category`.
- **Columns shelf:** `SUM(amount)`.
- **Colour shelf:** `category` (one consistent colour per category).
- **Marks / labels:** Bar; label each bar with `SUM(amount)` formatted as INR with comma separators.
- **Sort:** `SUM(amount)` descending.
- **Why this chart:** A bar chart makes the relative revenue contribution of each product category straightforward to compare.

Plain-text data table (INR):

| Category | Revenue (`SUM(amount)`) |
|---|---:|
| Electronics | 142,300 |
| Home | 126,400 |
| Apparel | 77,500 |
| **Grand Total** | **346,200** |

### 3. Revenue Trend by Month and Category

- **Chart type:** Multi-series line chart.
- **Columns shelf:** `order_month` (ascending order: `2026-09`, `2026-10`, `2026-11`; keep the month labels in `YYYY-MM` format).
- **Rows shelf:** `SUM(amount)`.
- **Colour shelf:** `category` (one line per category).
- **Marks / labels:** Line; optionally label each monthly point with its value, formatted as INR.
- **Why this chart:** A line chart reveals how revenue changes month to month and whether categories follow different trajectories.

Plain-text data table (INR):

| Order month | Apparel | Electronics | Home | Monthly total |
|---|---:|---:|---:|---:|
| 2026-09 | 24,700 | 43,000 | 30,600 | 98,300 |
| 2026-10 | 30,600 | 49,900 | 12,600 | 93,100 |
| 2026-11 | 22,200 | 49,400 | 83,200 | 154,800 |
| **Category total** | **77,500** | **142,300** | **126,400** | **346,200** |

### 4. Region x Category Detail

- **Chart type:** Text table (crosstab; not a bar chart).
- **Rows shelf:** `region`.
- **Columns shelf:** `category`.
- **Colour shelf:** None; use plain text cells so the exact values remain the focus.
- **Marks / labels:** Set Marks to **Text** and place `SUM(amount)` on Text; format values as INR with comma separators.
- **Why this chart:** A crosstab gives the exact revenue for every region/category combination and supports precise lookup rather than visual estimation.

Plain-text data table (INR):

| Region | Apparel | Electronics | Home | Region total |
|---|---:|---:|---:|---:|
| East | 10,600 | 21,400 | 37,500 | 69,500 |
| North | 19,400 | 73,400 | 26,500 | 119,300 |
| South | 10,000 | 28,700 | 43,800 | 82,500 |
| West | 37,500 | 18,800 | 18,600 | 74,900 |
| **Category total** | **77,500** | **142,300** | **126,400** | **346,200** |

## Dashboard layout

Use a single **vertical container** as the dashboard's main layout, ordered from top to bottom as follows:

1. **KPI cards first:** a horizontal container across the top with Total Revenue on the left and Total Units Sold on the right.
2. **Category filter next:** directly below the KPI cards, in a horizontal container spanning the dashboard's top band. Show `category` as a single-value or multiple-value dropdown and default it to **All**.
3. **Trend chart:** place *Revenue Trend by Month and Category* in a full-width horizontal container below the filter.
4. **Comparison charts:** place *Revenue by Region* and *Revenue by Category* side by side in the same horizontal container, with approximately equal widths.
5. **Detail table last:** place *Region x Category Detail* in a full-width horizontal container at the bottom.

Configure the `category` filter to **Apply to Worksheets → All Using This Data Source**, so it filters all four worksheets: Revenue by Region, Revenue by Category, Revenue Trend by Month and Category, and Region x Category Detail. Keep the filter visible on the dashboard directly below the KPI cards.

With **Use as Filter** switched on for *Revenue by Region*, clicking a region's bar filters the other charts and the detail table to that selected region's records (while the category filter continues to apply).

## Insight and recommendation narrative

### Visualization summary

The dashboard summarizes 63 completed orders worth **₹346,200** across four regions, three categories, and three months (September–November 2026). It pairs two headline KPIs with regional and category comparisons, a monthly category trend, and a region-by-category crosstab for exact values. Total units sold are **106**.

### Summary analysis

1. **North leads regional revenue:** North generated **₹119,300**, compared with South at **₹82,500**; North is ahead by **₹36,800**.
2. **Electronics is the largest category overall:** Electronics contributed **₹142,300**, ahead of Home at **₹126,400** by **₹15,900**, while Apparel contributed **₹77,500**.
3. **Revenue rose sharply in November:** total monthly revenue increased from **₹93,100** in October to **₹154,800** in November, a rise of **₹61,700**. Home was the main driver, increasing from **₹12,600** in October to **₹83,200** in November.
4. **Category strength differs by region:** North Electronics generated **₹73,400**, the largest region/category cell, while West Apparel generated **₹37,500**, the strongest Apparel region/category cell.

### Recommendations

1. **Protect availability and promote Electronics in North.** North Electronics generated **₹73,400**; maintain adequate stock of key electronics items and run a targeted, measurable promotion rather than discounting the entire category. **Success metric:** monthly North Electronics revenue, with stockout rate as a guardrail.
2. **Plan Home inventory for the November-style spike, especially in South.** Home revenue reached **₹83,200** in November, and South contributed **₹43,800** in Home revenue across the period. Review replenishment and supplier lead times before the next comparable peak. **Success metric:** Home revenue by month and region, alongside Home stockout rate.
3. **Run a focused Apparel campaign in West.** West Apparel produced **₹37,500**, the highest Apparel total among regions, while total Apparel revenue fell from **₹30,600** in October to **₹22,200** in November. Test a West-focused campaign and protect stock in the best-selling Apparel items. **Success metric:** West Apparel monthly revenue and units sold, compared with the pre-campaign baseline.

## Reconciliation

All amounts below are INR. The Part B pivot grand total is the grand total from the `amount` pivot by category and region. The values reconcile exactly.

| Total Revenue KPI (`SUM(amount)`) | Sum of Revenue by Region values | Sum of Revenue by Category values | Part B pivot grand total |
|---:|---:|---:|---:|
| **346,200** | **346,200** | **346,200** | **346,200** |

**Equality check:** all four values are equal (INR 346,200).
