Repository for the following blogs

1. [dbt(data build tool) Tutorial](https://www.startdataengineering.com/post/dbt-data-build-tool-tutorial/)

# Setup

## Prerequisites

1. [python ^3.11](https://www.python.org/downloads/)
2. [poetry](https://python-poetry.org/docs/)
3. [duckdb](https://duckdb.org/docs/installation/)
5. [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
6. [just](https://github.com/casey/just)

In addition to the tools, you would also need to know what dbt is, you can learn about it here: [dbt tutorial](https://www.startdataengineering.com/post/dbt-data-build-tool-tutorial/).

Clone the git repo and switch to the `uplevel-workflow` branch.

```bash
git clone https://github.com/josephmachado/simple_dbt_project.git
cd simple_dbt_project
```

**Note**: All the just commands are avaialble in the [justfile](./justfile)

## Create virtual environment and start postgres docker

In your project terminal, create a virtual environment and activate it as shown below.

```bash
just create-venv # uses poetry to install python modules in pyproject.ml
source .venv/bin/activate
```

Start the postgres container (to be used as warehouse for development) with the following command.

```bash
just restart # clears up any existing container with the same name, starts a new postgres container and sets up elementary (a dbt package) table.
```

## Run dbt

From your project terminal run the following commands.

```bash
dbt deps
dbt snapshot
dbt run 
dbt test
dbt docs generate
dbt docs serve
```

Go to http://localhost:8080 to see the dbt documentation (press ctrl+c). 

Let's do some testing, Insert some data into source customer table(in our case the new_customer data is appended into customers.csv), to demonstrate dbt snapshots.

Since we are using duckdb and the base table is essentially data at ./raw_data/customer.csv we have to append new data to this customer.csv file as shown below:

```bash
# Remove header from ./raw_data/customers_new.csv
# and append it to ./raw_data/customers.csv
echo "" >> ./raw_data/customers.csv
tail -n +2 ./raw_data/customer_new.csv >> ./raw_data/customers.csv

# NOTE: Windows users may need to do this manually or via powershell as
# Read the CSV file, skip the first line, and output to a new file

$newFilePath = './raw_data/customer_new.csv'
$existingFilePath = './raw_data/customers.csv'
Add-Content -Path $existingFilePath -Value "`n"
Get-Content -Path './raw_data/customer_new.csv' | Select-Object -Skip 1 | Set-Content -Path './raw_data/customers.csv'
```

Run snapshot and create models again.
```bash
dbt snapshot 
dbt run 
```

From your terminal run the following command.

```bash
just warehouse
```

```sql
D .open dbt.duckdb

-- You will see 2 rows for the same customer ud
-- this is the SCD2 version
select * 
from snapshots.customers_snapshot 
where customer_id = 82;
.exit
```

