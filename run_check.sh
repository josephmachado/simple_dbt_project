#!/bin/bash

echo "##############################################"
echo "# Clean up"
echo "##############################################"
rm -f *.duckdb

echo "##############################################"
echo "# EL data"
echo "##############################################"
uv run python extract_load_pipeline.py

echo "##############################################"
echo "# Clean up dbt packages"
echo "##############################################"
uv run dbt clean
uv run dbt deps

echo "##############################################"
echo "# Load seed data"
echo "##############################################"
uv run dbt seed

echo "##############################################"
echo "# Run pipeline: bronze -> snapshot -> silver -> gold"
echo "##############################################"
uv run dbt run --select models/bronze
uv run dbt snapshot
uv run dbt run --select models/silver models/gold

echo "##############################################"
echo "# Run data quality tests"
echo "##############################################"
uv run dbt test

echo "##############################################"
echo "# Check snapshot and incremental state"
echo "##############################################"
uv run python -c "import duckdb; c=duckdb.connect('dbt.duckdb'); print('dim_customer:', c.sql('select count(*) from snapshots.dim_customer').fetchone()[0]); print('fct_clickstream:', c.sql('select count(*) from fct_clickstream').fetchone()[0])"

echo "##############################################"
echo "# Re-run snapshot and incremental pipelines"
echo "##############################################"
uv run python load_new_data.py # Inserts new data
uv run dbt run --select models/bronze
uv run dbt snapshot
uv run dbt run --select models/silver
uv run dbt test

echo "##############################################"
echo "# Final check of snapshot and incremental state"
echo "# Expect: 2 snapshot rows for customer_id = 82, and fct_clickstream count = 110"
echo "##############################################"
uv run python -c "
import duckdb, sys
c = duckdb.connect('dbt.duckdb')
dim = c.sql('select count(*) from snapshots.dim_customer where customer_id = 82').fetchone()[0]
fct = c.sql('select count(*) from fct_clickstream').fetchone()[0]
print('dim_customer id=82 rows:', dim)
print('fct_clickstream:', fct)
ok = dim == 2 and fct == 110
print('CHECK PASSED' if ok else 'CHECK FAILED')
sys.exit(0 if ok else 1)
"
