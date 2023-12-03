This is the code repo for dbt tutorial at https://www.startdataengineering.com/post/dbt-data-build-tool-tutorial

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

## Run dbt 

```bash
dbt deps
dbt snapshot
dbt run
dbt run --select elementary # Optional for generating observability report
dbt test
dbt docs generate
dbt docs serve
```

Insert updates into source customer table, to demonstrate snapshot

```bash
pgcli -h localhost -U dbt -p 5432 -d dbt
# password is password1234
COPY warehouse.customers(customer_id, zipcode, city, state_code, datetime_created, datetime_updated) FROM '/input_data/customer_new.csv' DELIMITER ',' CSV HEADER;
\q
```

Run snapshot and create models again.

```
dbt snapshot
dbt run
```

You can log into the data warehouse to see the models.

```bash
pgcli -h localhost -U dbt -p 5432 -d dbt
# password is password1234
select * from warehouse.customer_orders limit 3;
\q
```

## Stop docker container

```bash
cd ..
docker compose down
```
