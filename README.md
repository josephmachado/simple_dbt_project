Repository for the following blogs

1. [dbt(data build tool) Tutorial](https://www.startdataengineering.com/post/dbt-data-build-tool-tutorial/)
2. [Uplevel dbt(data build tool) workflow](https://www.startdataengineering.com/post/uplevel-dbt-workflow/)

# Setup

## Prerequisites

1. [Docker](https://docs.docker.com/get-docker/)
2. [python](https://www.python.org/downloads/)
3. [poetry](https://python-poetry.org/docs/)
4. [pgcli](https://www.pgcli.com/install)
5. [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
6. [just](https://github.com/casey/just)

In addition to the tools, you would also need to know what dbt is, you can learn about it here: [dbt tutorial](https://www.startdataengineering.com/post/dbt-data-build-tool-tutorial/).

Clone the git repo and switch to the `uplevel-workflow` branch.

```bash
git clone https://github.com/josephmachado/simple_dbt_project.git
cd simple_dbt_project

# Set dbt env variables to tell dbt where the profiles.yml and dbt_project.yml files are
export DBT_PROFILES_DIR=$(just profile-dir)
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

Let's do some testing, Insert some data into source customer table, to demonstrate dbt snapshots. From your terminal (after exiting dbt container) run the following command.

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

## Use selectors and tags to only run necessary models/tests

We can use selectors to only select source models, models/tests with a specific tag, etc [see this link for details](https://docs.getdbt.com/reference/node-selection/methods).

for example 

```bash
# make sure your virtual env is acitaved
cd sde_dbt_tutorial
# Use the following command to list all the source table's tests
dbt ls --select "source:*,resource_type:test"
# Use the following command to list all dbt objects (tests, tables, views, etc) which has a tag elementary
dbt ls --select "tag:elementary"
cd ..
```

## Use defer to only run the required model and use prod's upstream tables

If you wan to use another environment's tables to build your model, you can use defer. Assuming we have two environments(schema) in the same database let's see how we can use defer to build a model for developing locally.

```bash
# make sure your virtual env is activated
just restart # this will clear out existing models in dev and prod
just prod-run # this will run dbt models in the prod environment

# make sure that you are in simple_dbt_project folder
rm -f ./sde_dbt_tutorial/prod-run-artifacts/manifest.json
cp ./sde_dbt_tutorial/target/manifest.json ./sde_dbt_tutorial/prod-run-artifacts/

# Run defer using pre build prod tables and create a new model in dev
cd sde_dbt_tutorial
dbt run --select "customer_orders" --defer --state prod-run-artifacts
cd ..
# You will see a log showing one model created

# Open warehouse with 
just warehouse
```

```sql
select * from your_name_warehouse.dim_customers; -- table does not exist error
select * from your_name_warehouse.customer_orders limit 10; -- you will see results
set search_path to 'your_name_warehouse';
\d -- you will only see customer_orders tables in your your_name_warehouse schema
\q -- exit pgcli
```

## Validate data before pushing to prod, with data-diff

We can use data-diff to compare (column value based) datasets. This is especially helpful when you want to make sure that your changes did not in advertently change the granularity, alter values, etc. Let's see how we can compare data using data-diff.

```bash
# make sure your virtual env is activated
just restart && just dev-run && just prod-run

# make sure that you are in simple_dbt_project folder
rm -f ./sde_dbt_tutorial/prod-run-artifacts/manifest.json
cp ./sde_dbt_tutorial/target/manifest.json ./sde_dbt_tutorial/prod-run-artifacts/

# go to and ./sde_dbt_tutorial/models/marts/marketing/customer_orders.sql 
# and add a new col 'som col' as some_new_col,

cd sde_dbt_tutorial
dbt run --select "customer_orders" && data-diff --dbt --state ./prod-run-artifacts/manifest.json --select customer_orders -k order_id,customer_id
cd ..
```

You will see the diff as shown below.

```bash

dbt.warehouse.customer_orders <> dbt.your_name_warehouse.customer_orders 
Column(s) added: {'some_new_col'}
No row differences

```

## Observe data quality with elementary

We have added elementary data checks in our dbt project, run them as shown below.

```bash
just restart
just dev-run 
just dq-report # creates and opens a static HTML file which shows dq report on your browser
```

add: image

**Note**: There are more dbt tools & process improvements explained at https://www.startdataengineering.com/post/uplevel-dbt-workflow/

## Autorun linting & checks locally before opening a PR to save on CI costs

```bash
echo -e '
#!/bin/sh
just ci
' > .git/hooks/pre-commit
chmod ug+x .git/hooks/*
```

# Shutdown

```bash
deactivate # to deactivate the virtual environment
just down # to stop postgres containers
```
