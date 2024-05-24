################ ENVIRONMENT SETUP ###################
# create a virtual env
create-venv:
    rm -rf .venv && poetry config virtualenvs.in-project true && poetry install --no-root

################ DBT COMMANDS ###################
# These env variables tell dbt which directory to run the dbt commands from
# !!!! THE ENV VARIABLE MAY NEED TO BE CHANGED FOR WINDOWS !!!!!!
export DBT_PROFILES_DIR := (`PWD` + "/sde_dbt_tutorial")
export DBT_PROJECT_DIR := (`PWD` + "/sde_dbt_tutorial")

profile-dir:
    echo $DBT_PROFILES_DIR

project-dir:
    echo $DBT_PROJECT_DIR

# Download dependencies
deps:
    dbt deps

# Run Snapshot
snapshot:
    dbt snapshot
    
# Run sde_dbt_tutorial models
run-sde:
    dbt run --select sde_dbt_tutorial

# Test
test-raw:
    dbt test --select "source:*"

test-warehouse:
    dbt test --exclude "source:*"

test:
    just test-raw
    just test-warehouse

# generate dbt docs
docs-gen:
    dbt docs generate

# Serve docs
serve:
    dbt docs serve

# Generate and serve dbt docs
docs:
    just docs-gen
    just serve

# Debug connections
debug:
    dbt debug

check-orphan-tests:
    python3 check_orphans.py 

################# DQ REPORT ####################

# Generate elementary tables
elem-tables:
    dbt run --select elementary

elem-tables-prod:
    dbt run --select elementary --target prod

# run elementary tests
elem-test:
    dbt test --select elementary

elem-test-prod:
    dbt test --select elementary --target prod

# Generate DQ report
dq-report:
    edr report

################## LINT & FORMATTING ###########

lint-sql:
    sqlfluff lint sde_dbt_tutorial/models --dialect postgres

format-sql:
    sqlfluff fix sde_dbt_tutorial/models --dialect postgres --show-lint-violations

lint-yml:
    yamllint sde_dbt_tutorial/models sde_dbt_tutorial/snapshots sde_dbt_tutorial/dbt_project.yml sde_dbt_tutorial/packages.yml sde_dbt_tutorial/profiles.yml

format-yml:
    yamlfix sde_dbt_tutorial/models

################## WORKFLOW COMMANDS ###########

lint-format:
    just format-sql
    just lint-sql
    just format-yml
    just lint-yml

dev-run:
    just test-raw
    just snapshot
    just run-sde
    just check-orphan-tests
    just test-warehouse

prod-run:
    dbt test --target prod --select "source:*"
    dbt snapshot --target prod
    dbt run --select sde_dbt_tutorial --target prod
    just check-orphan-tests
    dbt test --target prod --exclude "source:*"

ci:
    just lint-format
    just dev-run

################## CONNECTION ##################

start-db:
    docker run -d \
        --name postgres \
        -e POSTGRES_USER=dbt \
        -e POSTGRES_PASSWORD=password1234 \
        -e POSTGRES_DB=dbt \
        -v $(pwd)/raw_data:/input_data \
        -v $(pwd)/warehouse_setup:/docker-entrypoint-initdb.d \
        -p 5432:5432 \
        postgres:16

up:
    just start-db
    just deps
    just elem-tables
    just elem-tables-prod

warehouse:
    PGPASSWORD=password1234 pgcli -h localhost -U dbt -p 5432 -d dbt   

stakeholder:
    PGPASSWORD=password1234 pgcli -h localhost -U stakeholder -p 5432 -d dbt

down:
    docker ps -q -f name=postgres | grep -q . && docker stop postgres && docker rm postgres


restart:
    rm -rf /raw_data/*
    rm -rf ./sde_dbt_tutorial/target
    just down
    just up
