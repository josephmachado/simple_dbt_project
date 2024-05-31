Repository for the following blogs

1. [dbt(data build tool) Tutorial](https://www.startdataengineering.com/post/dbt-data-build-tool-tutorial/)

# Setup

## Prerequisites

1. [python ^3.11](https://www.python.org/downloads/)
2. [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)

In addition to the tools, you would also need to know what dbt is, you can learn about it here: [dbt tutorial](https://www.startdataengineering.com/post/dbt-data-build-tool-tutorial/).

Clone the git repo as shown below:

```bash
git clone https://github.com/josephmachado/simple_dbt_project.git
cd simple_dbt_project
```

## Demo on CodeSpaces

Here is a demo of how to run this on CodeSpaces:

[![dbt on codespaces demo](https://img.youtube.com/vi/UEVuIKmx5X0/maxresdefault.jpg)](https://youtu.be/UEVuIKmx5X0)

Setup python virtual environment as shown below:

```bash
rm -rf myenv
# set up venv and run dbt
python -m venv myenv
source myenv/bin/activate
pip install -r requirements.txt
```

# Run dbt 

Run dbt commands as shown below:

```bash
dbt clean
dbt deps
dbt snapshot
dbt run 
dbt test
dbt docs generate
dbt docs serve
```

Go to [http://localhost:8080](http://localhost:8080) to see the dbt documentation. If you are running this on GitHub CodeSpaces, follow [this section]() to expose port 8080 for access from your browser.

Press Ctrl + c to stop the document server.

# Create snapshots

Let's do some testing, Insert some data into source customer table(in our case the new_customer data is appended into customers.csv), to demonstrate dbt snapshots. Since we are using duckdb and the base table is essentially data at [customer.csv](./raw_data/customer.csv) we have to append new data to this customer.csv file as shown below:

```bash
# Remove header from ./raw_data/customers_new.csv
# and append it to ./raw_data/customers.csv
echo "" >> ./raw_data/customers.csv
tail -n +2 ./raw_data/customer_new.csv >> ./raw_data/customers.csv

# NOTE: Windows users need to do this manually or via powershell as
```

Run snapshot and create models again.

```bash
dbt snapshot 
dbt run 
```

```bash
# reset customers.csv
head -n -5 ./raw_data/customers.csv > temp
cat temp > ./raw_data/customers.csv 
rm temp
```

Let's open a python REPL and check our data, as shown below:

```python
import duckdb
con = duckdb.connect("dbt.duckdb")
results = con.execute("select * from snapshots.customers_snapshot where customer_id = 82").fetchall()
for row in results:
    print(row)
# NOTE: You will see 2 rows printed
exit()
```

