# Query2Insight: Retail Analytics Dashboard

An end-to-end retail analytics project: raw CSV data is cleaned and analysed in **MySQL**, joined with **Power Query**, and presented as an interactive **Excel dashboard** (Pivot Tables, Pivot Charts, Slicers, KPI cards).

## Business Questions

- Which product category and region generate the most revenue?
- How does revenue change month to month?
- Who are the top-spending customers?
- How loyal are customers (one-time vs repeat)?
- How can customers be segmented by purchase frequency?

## Tools

| Tool | Used for |
|---|---|
| MySQL Workbench / SQL | Data cleaning, joins, CTEs, aggregations, views |
| Power Query | Joining transactions, products and customers into one model |
| Microsoft Excel | Pivot Tables, Pivot Charts, Slicers, KPI cards |

## Data

Three related tables: `customer_profiles` (customer, gender, age, location, join date), `product_inventory` (product, category, price, stock level), and `sales_transaction` (transaction, customer, product, quantity, date, price). Revenue is calculated as `QuantityPurchased * Price`.

After cleaning: **5,000 transactions**, **989 customers**.

## Data Cleaning (`01_data_cleaning_eda.sql`)

- Checked every key column for NULL and blank values.
- Replaced missing `Location` values with `unknown` and set impossible ages (below 0 or above 100) to NULL.
- Found duplicate `TransactionID` rows and created `sale_transaction_clean` using `SELECT DISTINCT`.
- Converted date columns to `DATE` and price to `DECIMAL(10,2)`.
- Checked quantity and price for zero or negative values.
- Added primary keys on customer, transaction, product and subcategory tables.

## SQL Analysis (`02_data_analysis.sql`, `03_views.sql`)

Queries cover total revenue, average transaction value, top and bottom 10 products, revenue by category, gender and location, top 10 customers, orders per customer, monthly trend and loyalty split.

Views created for the dashboard: `product_revenue`, `category_revenue`, `customer_spending`, `gender_category_revenue`, `category_location_revenue`, `monthly_trend`, `customer_segments`, `customer_loyalty`.

Customer segments in the final view: **low** (1-3 orders), **mid** (4-10), **high value** (more than 10).

## Dashboard (`Dashboard_Retail_analytics.xlsx`)

KPI cards (total revenue, customers, transactions), monthly revenue trend, revenue by category, category by location, customer segments, loyalty split, top 10 customers, revenue by gender and category, with Category and Location slicers.

## Key Findings (verified against the workbook)

| Metric | Result |
|---|---|
| Total revenue | 1,209,042 (currency not specified in source data) |
| Top category | Clothing, 669,913 (about 55% of revenue) |
| Top region | East, 334,087 (about 28%); South and West are close behind |
| Peak month | June, 323,463 (about 27% of revenue) |
| Repeat customers | 96% (950 of 989) |
| Segments | 279 low, 690 mid, 20 high value |

## Recommendations

- Keep Clothing stock availability high, since it drives most of the revenue.
- Review marketing in the North region, which has the lowest revenue.
- Investigate what drove June sales and test whether it can be repeated.
- Beauty & Health is the weakest category; test promotions before changing inventory.

## Limitations

- Transaction dates in the source file span 2001-2031 and the data covers only January to July of each year, so the monthly view groups by calendar month and should be treated as illustrative rather than a real seasonal pattern.
- The dataset appears synthetic; results demonstrate the analysis method, not real business performance.
- 69 transactions have an `unknown` location.

## Repository Contents

| File | Description |
|---|---|
| `01_data_cleaning_eda.sql` | Cleaning and validation |
| `02_data_analysis.sql` | Business questions and queries |
| `03_views.sql` | Views used by the dashboard |
| `Dashboard_Retail_analytics.xlsx` | Dashboard and supporting pivots |

Run the SQL files in order in MySQL Workbench after importing the three source CSVs into a database named `retail_analytics_db`.

## Author

**Sukanya Saha** | [LinkedIn](https://www.linkedin.com/in/sukanya-saha-921a20295) | [Portfolio](https://sukanya-portfolio-rust.vercel.app/)
