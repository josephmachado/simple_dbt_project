################ ENVIRONMENT SETUP ###################
# create a virtual env
create-venv:
    rm -rf .venv && poetry config virtualenvs.in-project true && poetry install --no-root

################ DBT COMMANDS ###################

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

up:
    just deps

warehouse:
    PGPASSWORD=password1234 pgcli -h localhost -U dbt -p 5432 -d dbt   

stakeholder:
    PGPASSWORD=password1234 pgcli -h localhost -U stakeholder -p 5432 -d dbt

restart:
    rm -rf /raw_data/*
    rm -rf ./sde_dbt_tutorial/target
    rm -rf *.duckdb
    just up
