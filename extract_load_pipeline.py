import duckdb

con = duckdb.connect("./dbt.duckdb")

files = {
    "raw_customer": "./raw_data/customer.csv",
    "raw_orders": "./raw_data/orders.csv",
    "raw_state": "./raw_data/state.csv",
    "raw_clickstream": "./raw_data/clickstream.csv",
}

con.execute("CREATE SCHEMA IF NOT EXISTS raw")
con.commit()

for table, path in files.items():
    con.execute(f"CREATE OR REPLACE TABLE raw.{table} AS SELECT * FROM read_csv_auto('{path}')")

con.close()
