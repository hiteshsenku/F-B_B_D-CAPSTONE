# Part B — Spreadsheet cleaning and reconciliation

## Formulas (first data row)

The source `orders` tab contains 90 data rows in rows 2–91. The formulas below are the exact formulas entered in row 2 of each added column; they were filled down through row 91.

| Added column | Cell | Formula |
| --- | --- | --- |
| `clean_first_name` | K2 | `=PROPER(TRIM(C2))` |
| `clean_last_name` | L2 | `=PROPER(TRIM(D2))` |
| `category` | M2 | `=VLOOKUP(G2,products!$A$2:$C$10,2,FALSE)` |
| `unit_price` | N2 | `=XLOOKUP(G2,products!$A$2:$A$10,products!$C$2:$C$10,"UNKNOWN_ITEM")` |
| `revenue_calc` | O2 | `=N2*H2` |

The lookup ranges are absolute references, so they remain fixed when copied down. The XLOOKUP fallback was tested separately in `orders!Q2` using the key `Mystery Item`; the displayed result is `UNKNOWN_ITEM`.

## Completed-order aggregates

These are calculated from the 63 rows where `status = completed`, with `amount` treated as numeric.

| Metric | Result |
| --- | --- |
| COUNT | 63 |
| SUM | 346200 |
| AVERAGE | 5495.24 |
| MIN | 1100 |
| MAX | 15600 |

## Pivot tables

### Pivot (i): Sum of `amount` by `category` and `region`

| category | East | North | South | West | Grand Total |
| --- | --- | --- | --- | --- | --- |
| Apparel | 10600 | 19400 | 10000 | 37500 | 77500 |
| Electronics | 21400 | 73400 | 28700 | 18800 | 142300 |
| Home | 37500 | 26500 | 43800 | 18600 | 126400 |
| Grand Total | 69500 | 119300 | 82500 | 74900 | 346200 |

### Pivot (ii): Sum of `amount` and count of `order_id` by `order_month`

| order_month | Sum of amount | Count of order_id |
| --- | --- | --- |
| 2026-09 | 98300 | 19 |
| 2026-10 | 93100 | 20 |
| 2026-11 | 154800 | 24 |
| Grand Total | 346200 | 63 |

## Reconciliation

Part A q05 reports `total_orders = 63`, `total_revenue = 346200`, and `avg_order_value = 5495.238095238095`. Spreadsheet figures are calculated over the completed-order data.

| Metric | Spreadsheet | Part A q05 | Match/Mismatch |
| --- | --- | --- | --- |
| COUNT | 63 | 63 | Match |
| SUM | 346200 | 346200 | Match |
| AVERAGE | 5495.24 | 5495.24 | Match |

## Data validation

- **Missing amounts:** Part A q02 identifies exactly three rows with blank `amount`: order IDs **1001**, **1010**, and **1064**. They are all `pending`, not `completed`. I preserved these blanks in the full `orders` source tab rather than replacing them with zero or an estimate, because a missing amount is not evidence of zero revenue. They do not enter the completed-order aggregates or pivots.
- **Consistent data types:** `order_id`, `unit_price`, `quantity`, `amount`, and `revenue_calc` are numeric values in the workbook; blanks in the source amount field remain blank. `order_month` is preserved as text in `YYYY-MM` form (for example, `2026-09`) and is not converted to a date. The exported CSV was checked for the exact 13-column header, 63 data rows, and text-form month labels. CSV files serialize fields as text, so numeric typing is enforced in the workbook and should be retained on import by assigning numeric types to numeric columns.
- **Duplicate IDs:** There are **0 duplicate `order_id` values** among completed orders.
- **Outlier check:** Using the 1.5×IQR rule, Q1 = 2800, Q3 = 7200, IQR = 4400, and the upper fence = 13800. The largest amount, **15600**, is above this fence and is therefore a high-value outlier by that rule. The following orders tie at this amount: **1061, 1065, 1069, 1077**. Because four orders share the same item-level amount pattern, this should be flagged for review, not automatically deleted or altered.
- **Decision for the next colleague:** Keep missing source amounts blank and keep the original `orders` tab unchanged except for clearly labelled calculated columns. Use `completed_orders` as the filtered, sorted value-only reporting extract, and rerun the reconciliation whenever the source data changes.

## Setup

- Tabs created: **`orders`** and **`products`**. The workbook also contains the reporting extract tab **`completed_orders`**.
- Imported into `orders`: **90 data rows** plus one header row (range `A1:O91` for source plus calculated columns).
- `products` query: `SELECT item, category, unit_price FROM products ORDER BY item`; header plus 9 product rows occupy **`A1:C10`**.
- Before building `completed_orders`, applied the filter **`status = completed`**, then sorted visible rows by **`amount` descending (largest to smallest)**. Pasted the resulting **63 rows as values** into `completed_orders`.
- `completed_orders` export range: **`A1:M64`** only; summary aggregates and pivot tables are outside this range and do not appear in `data/orders_clean.csv`.
