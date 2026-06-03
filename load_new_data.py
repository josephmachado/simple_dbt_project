import duckdb

con = duckdb.connect("./dbt.duckdb")

# new (incremental) data to APPEND onto existing raw tables
files = {
    "raw_clickstream": "./raw_data/clickstream_incremental.csv",
    "raw_customer": "./raw_data/customer_new.csv",
}

for table, path in files.items():
    before = con.execute(f"SELECT count(*) FROM raw.{table}").fetchone()[0]

    con.execute(
        f"INSERT INTO raw.{table} BY NAME SELECT * FROM read_csv_auto('{path}')"
    )

    after = con.execute(f"SELECT count(*) FROM raw.{table}").fetchone()[0]
    print(f"{table}: {before} -> {after} (+{after - before})")

con.commit()
con.close()
