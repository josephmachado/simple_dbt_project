<!-- vim-markdown-toc GFM -->

* [dbt(data build tool) Tutorial](#dbtdata-build-tool-tutorial)
    * [CodeSpaces Setup (Recommended)](#codespaces-setup-recommended)
        * [Prerequisites](#prerequisites)
    * [Setup](#setup)
        * [Prerequisites](#prerequisites-1)
    * [Run pipeline with dbt](#run-pipeline-with-dbt)
    * [Validating SCD2 and Incremental table](#validating-scd2-and-incremental-table)

<!-- vim-markdown-toc -->
# dbt(data build tool) Tutorial 

Code for blog **[dbt(data build tool) Tutorial](https://www.startdataengineering.com/post/dbt-data-build-tool-tutorial/)**

## CodeSpaces Setup (Recommended)

### Prerequisites

1. [GitHub Account](https://github.com/)

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/josephmachado/simple_dbt_project)

> [!NOTE]
> Wait about 5 minutes for all packages to be automatically installed

## Setup

### Prerequisites

1. [uv](https://docs.astral.sh/uv/)
2. [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)

Clone and cd into the repo as shown below:

```bash
git clone https://github.com/josephmachado/simple_dbt_project.git
cd simple_dbt_project
```

## Run pipeline with dbt 

Let's simulate the EL process with this Python script.

```bash
rm *.duckdb
uv run python extract_load_pipeline.py
```

> [!NOTE]
> We use `uv run` to run all our python commands. As this command with run the python process inside the `uv` virtual env.

We clean up any old dbt package dependencies and re-install them.

```bash
uv run dbt clean
uv run dbt deps
```

We use `seed` to load a [mapping file](./data/order_status_code.csv). 

```bash
uv run dbt seed
```

We run the bronze layer pipeline first. Following that we run the `snapshot` pipeline which creates our `dim_customer` table. Finally we run the silver and gold layers.

```bash
uv run dbt run --select models/bronze
uv run dbt snapshot
uv run dbt run --select models/silver models/gold
```
We run pipelines in this order, since SCD2 tables can only be created with the `snapshot` command,

Finally we run the tests, create docs and serve them at port 8080. 

```bash
uv run dbt test
uv run dbt docs generate
uv run dbt docs serve
```

Go to [http://localhost:8080](http://localhost:8080) to see the dbt documentation. 

If you are running this on GitHub CodeSpaces, click on the `ports` tab and click on the link exposing port 8080.

## Validating SCD2 and Incremental table

Let's first check the current state of the SCD2 and Incremental tables.

```bash
uv run duckdb dbt.duckdb
```

```sql
select * from snapshots.dim_customer where customer_id = 82; -- one row 
select count(*) from fct_clickstream; -- 100
```

Now let's run the SCD2 and Incremental pipelines.

```bash
uv run python load_new_data.py # Inserts new data 
uv run dbt run --select models/bronze 
uv run dbt snapshot 
uv run dbt run --select models/silver
uv run dbt test
```

```bash
uv run duckdb dbt.duckdb
```

```sql
select * from snapshots.dim_customer where customer_id = 82; -- two row 
select count(*) from fct_clickstream; -- 110
```

> [!CAUTION]
> Do not forget to stop your codespaces machine
