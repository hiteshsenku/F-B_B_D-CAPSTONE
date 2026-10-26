# Part D — AI Prompting and Verification Log

## Scenario D1 — assistant-generated regional revenue query

### 1. Five-part prompt for Part A q13

**Role**  
You are a careful SQL analyst working in SQLite. You write auditable queries and do not invent schema objects or business facts.

**Task**  
Write the Part A q13 query: for each sales representative and order month, calculate completed-order revenue, compare it with that representative's monthly target, and assign a performance tier.

**Context**  
Use only these real SQLite tables and columns: `reps(rep_id, rep_name, region, monthly_target)`, `customers(customer_id, first_name, last_name, city, region, age, rep_id)`, and `orders(order_id, customer_id, item, quantity, amount, status, order_month)`. Join `reps` to `customers` using `rep_id`, and `customers` to `orders` using `customer_id`. The SQL dialect is SQLite. Revenue is `SUM(orders.amount)` and the month field is `orders.order_month`.

**Constraints**  
Include completed orders only (`orders.status = 'completed'`). Group the result by representative and month (and the target field as needed). Apply these three tiers exactly: **Below Target** when revenue is less than `monthly_target`; **On Target** when revenue is greater than or equal to `monthly_target` but less than `1.1 * monthly_target`; **Above Target** when revenue is greater than or equal to `1.1 * monthly_target`. Do not use any `WITH` clauses or stored procedures. Use only the stated schema; do not invent tables or columns.

**Format**  
Return raw SQL only, with concise inline comments explaining the purpose of the query and important logic. Do not include markdown fences or prose outside the SQL.

### 2. Inspect Scenario D1 — defects in the assistant's answer

| Defect in original answer | Classification | Correct clause or fix |
|---|---|---|
| `FROM sales` refers to a table that does not exist in the seed schema. | fake method/function | Use `orders` joined to `customers`; the customer's `region` identifies the region for each order. |
| `region_name` and `total_sales` are not columns in the real schema. | fake method/function | Use `customers.region` and `orders.amount`; alias `SUM(orders.amount)` as `revenue` if desired. |
| `WHERE SUM(total_sales) > 80000` filters on an aggregate before grouping, which is invalid SQL logic (and the referenced column is also invalid). | logic error | Filter grouped results with `HAVING SUM(o.amount) > 80000`, after `GROUP BY`. |
| “North's revenue grew 38% month over month” is unsupported by the query and contradicted by q11 for September to October. | phantom statistic | Calculate the change from q11's completed North revenue values: September 2026 = 53,500 and October 2026 = 41,300; change = `(41,300 - 53,500) / 53,500 * 100 = -22.8%` (one decimal place). |

### 3. Corrected query and execution result

The executable query is saved in `sql/d1_corrected.sql`. It uses the seeded SQLite schema, joins `orders` to `customers`, includes completed orders only, groups by region, applies the strict threshold using `HAVING`, and sorts revenue descending.

**Execution result on the Part A seed:** exactly 2 rows returned.

| region | revenue (INR) |
|---|---:|
| North | 119300 |
| South | 82500 |

These are the only regions whose completed-order revenue is greater than 80,000 INR. The result is recorded in `results/d1_corrected_results.txt`.

**North month-over-month check using Part A q11:** North completed revenue was 53,500 in `2026-09` and 41,300 in `2026-10`. The actual change is `((41,300 - 53,500) / 53,500) × 100 = -22.8%` rounded to one decimal place. The assistant's **38% growth claim is contradicted by the data**: the revenue decreased, rather than grew, over that period.

### 4. Human-in-the-loop protocol for Scenario D1

**Specification.** I translated “which regions sell the most?” into a precise metric: sum of `orders.amount` for completed orders only, grouped by `customers.region`, with a strict threshold above 80,000 INR. This makes the population, metric, grouping and threshold explicit.

**Execution.** I ran `sql/d1_corrected.sql` against the SQLite database built from Part A's `sql/00_schema_and_seed.sql`. The query completed successfully and returned exactly two rows: North 119300 and South 82500.

**Inspection.** I checked the SQL against the actual schema and confirmed that every referenced table and column exists, the joins use the seeded keys, `WHERE` filters individual completed orders, and `HAVING` filters the grouped sums. The query contains no invented identifiers or aggregate in `WHERE`.

**Verification.** I compared the regional output with the seed-derived query result and independently checked North's monthly figures against q11: 53,500 in September and 41,300 in October. The arithmetic gives -22.8%, not +38%; the original growth claim is contradicted by the data.

**Decision.** **Reject the original answer** because it uses a nonexistent table and columns, puts an aggregate condition in `WHERE`, and asserts an unsupported and contradicted 38% growth statistic. **Accept the corrected version** because it runs against the real SQLite seed, returns exactly North 119300 and South 82500 above the 80000 threshold, and its monthly comparison agrees with q11.

## Scenario D2 — spreadsheet lookup returning an error

### 5. Five-part diagnostic prompt

**Role**  
You are a spreadsheet troubleshooting specialist. Diagnose the cause from the supplied cell contents and layout before proposing a repair.

**Task**  
Explain why an exact-match `VLOOKUP` returns “value not found” even though the item appears in the lookup table, and provide a repaired formula that preserves exact matching.

**Context**  
The formula in the `orders` sheet is `=VLOOKUP(G2, $A$2:$C$10, 3, FALSE)`. Cell `G2` contains the text ` Smart Watch` with one leading space before `Smart Watch`. The `products` tab occupies `A1:C10`, with headers in row 1, item names in column A, and unit prices in column C. The lookup range in the given formula is `$A$2:$C$10`.

**Constraints**  
Assume `Smart Watch` is present in the product table and the table layout is as described. Do not change the exact-match requirement (`FALSE`), do not change the return-column index (3), and do not assume the product is absent. Identify any whitespace mismatch explicitly.

**Format**  
Return a short diagnosis in plain language, followed by one repaired spreadsheet formula and a brief explanation of why it works.

**Root cause:** `G2` has a leading space, so its text is not an exact match for the lookup-table value `Smart Watch`. With `FALSE`, `VLOOKUP` requires an exact text match and does not automatically remove the extra space.

**Repaired formula:**

`=VLOOKUP(TRIM(G2), products!$A$2:$C$10, 3, FALSE)`

`TRIM(G2)` removes the leading space (and any other leading/trailing spaces) from the lookup key. Because the formula is entered on the separate `orders` worksheet, the lookup range must also explicitly reference the `products` worksheet. The formula still uses exact matching and returns the value from the third column of the products range, which is the unit price.

## Scenario D3 — skeptical-analyst check on Part C

### 6. Skeptical-analyst prompt

**Prompt to give the assistant:**

> Act as a skeptical business analyst reviewing this Part C recommendation: “Protect availability and promote Electronics in North. North Electronics generated ₹73,400; maintain adequate stock of key electronics items and run a targeted, measurable promotion rather than discounting the entire category. Success metric: monthly North Electronics revenue, with stockout rate as a guardrail.” Challenge this recommendation rather than simply endorsing it. List the assumptions it makes, distinguish correlation from evidence of cause, identify what the supplied completed-order data can and cannot establish, and request the additional evidence needed before attributing revenue to a promotion or stock availability. For each assumption, suggest a specific data check, comparison or experiment, and define a measurable success criterion.

### Unstated assumptions and checks

1. **Assumption: North Electronics' ₹73,400 revenue represents sustained demand, not a short-lived or uneven monthly pattern.** The data shows North Electronics revenue of ₹16,700 in `2026-09`, ₹39,400 in `2026-10`, and ₹17,300 in `2026-11` (19 units overall). This sharp rise and fall weakens any claim that the high three-month total alone proves sustained demand. Check the month-by-month figures and item-level units; continue to monitor revenue and units by month before setting a permanent higher stock level.

2. **Assumption: stockouts or insufficient availability are limiting North Electronics sales.** The supplied orders data has no inventory-on-hand, stockout, lost-sales, or supplier lead-time fields, so it cannot confirm that availability caused missed revenue. Check inventory and stockout logs for the relevant North Electronics items (Smart Watch: ₹45,000 and 10 units; Wireless Earbuds: ₹25,600 and 8 units; Bluetooth Speaker: ₹2,800 and 1 unit over the period). If stockout evidence is absent, weaken or defer the inventory recommendation rather than infer a stock problem from revenue alone.

3. **Assumption: a promotion will increase incremental revenue or profit rather than merely discount existing purchases or shift purchases between months.** The dataset has no promotion exposure, control group, discount, cost or margin fields; therefore the ₹73,400 total is not causal evidence for promotion effectiveness. Run a controlled or matched-region/item test, track incremental units and revenue against a baseline or holdout, and include gross margin and discount cost. Continue only if incremental contribution improves without an unacceptable margin decline.

4. **Assumption: North Electronics' result is sufficiently broad across products to justify a category-wide action.** The item breakdown is concentrated: Smart Watch contributes ₹45,000, Wireless Earbuds ₹25,600, and Bluetooth Speaker ₹2,800. Check the SKU-level trend and unit sales before choosing the promotion and replenishment scope. A narrow Smart Watch/Earbuds test is better supported than a blanket category-wide discount; compare each item's revenue, units and margin before and after the test.
