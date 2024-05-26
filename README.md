Repository for the following blogs

1. [dbt(data build tool) Tutorial](https://www.startdataengineering.com/post/dbt-data-build-tool-tutorial/)

# Setup

## Prerequisites

1. [python](https://www.python.org/downloads/)
2. [poetry](https://python-poetry.org/docs/)
3. [duckdb](https://duckdb.org/docs/installation/)
5. [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
6. [just](https://github.com/casey/just)

In addition to the tools, you would also need to know what dbt is, you can learn about it here: [dbt tutorial](https://www.startdataengineering.com/post/dbt-data-build-tool-tutorial/).

Clone the git repo and switch to the `uplevel-workflow` branch.

```bash
git clone https://github.com/josephmachado/simple_dbt_project.git
cd simple_dbt_project
export DBT_PROJECT_DIR=$(just project-dir)
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
dbt run --select sde_dbt_tutorial
dbt test
dbt docs generate
dbt docs serve
```

Go to http://localhost:8080 to see the dbt documentation (press ctrl+c). 

Let's do some testing, Insert some data into source customer table(in our case the new_customer data is appended into customers.csv), to demonstrate dbt snapshots. From your terminal (after exiting dbt container) run the following command.

```bash
just warehouse
```

You will be logged into your warehouse, here use the below command:

```sql
COPY raw_layer.customers(customer_id, zipcode, city, state_code, datetime_created, datetime_updated) FROM '/input_data/customer_new.csv' DELIMITER ',' CSV HEADER;
\q
```

Run snapshot and create models again.
```bash
dbt snapshot --select sde_dbt_tutorial
dbt run --select sde_dbt_tutorial
```

From your terminal run the following command.

```bash
just warehouse
```

```sql
select * from your_name_warehouse.customer_orders limit 3;
\q
```

**Note**: The following sections are for this article [Uplevel dbt(data build tool) workflow](https://www.startdataengineering.com/post/uplevel-dbt-workflow/)

