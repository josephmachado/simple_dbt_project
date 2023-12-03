This is the code repo for dbt tutorial at https://www.startdataengineering.com/post/dbt-data-build-tool-tutorial

# Setup

### Prerequisites

1. [Docker](https://docs.docker.com/get-docker/) and [Docker compose](https://docs.docker.com/compose/install/)
2. [dbt](https://docs.getdbt.com/dbt-cli/installation/)
3. [pgcli](https://www.pgcli.com/install)
4. [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)

Clone the git repo and start the warehouse & dbt docker containers, as shown below.

```bash
git clone https://github.com/josephmachado/simple_dbt_project.git
cd simple_dbt_project
make up
make sh
```

We use `make sh` to log into the dbt docker container, & run dbt commands.

## Run dbt 

Once you are inside the dbt docker container, run the following commands.

```bash
cd $WORKDIR # go to the directory where we have dbt code
dbt deps
dbt snapshot
dbt run --select sde_dbt_tutorial
dbt test
dbt docs generate
dbt docs serve
```

Go to http://localhost:8080 to see the dbt documentation (press ctrl+c). 


**[Optional] We can create a data observability report with Elemetary as shown below:**

```bash
dbt run --select elementary
edr report
```

From your file system, open the html file at the path `sde_dbt_tutorial/edr_target/elementary_report.html` on your broswer to see the data observability report.

You can exit the dbt container using `exit`.

Let's do some testing, Insert some data into source customer table, to demonstrate dbt snapshots. From your terminal (after exiting dbt container) run the following command.

```bash
make warehouse
```
You will be logged into your warehouse, here use the below command:

```sql
COPY warehouse.customers(customer_id, zipcode, city, state_code, datetime_created, datetime_updated) FROM '/input_data/customer_new.csv' DELIMITER ',' CSV HEADER;
\q
```

Run snapshot and create models again.

```bash
make sh
cd $WORKDIR # go to the directory where we have dbt code
dbt snapshot --select sde_dbt_tutorial
dbt run --select sde_dbt_tutorial
```
You can exit the dbt container using `exit`. From your terminal (after exiting dbt container) run the following command.

```bash
make warehouse
```

```sql
select * from warehouse.customer_orders limit 3;
\q
```

## Stop docker container

```bash
make down
```
