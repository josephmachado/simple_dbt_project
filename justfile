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

################## LINT & FORMATTING ###########

lint-sql:
    sqlfluff lint ./models --dialect postgres

format-sql:
    sqlfluff fix ./models --dialect postgres --show-lint-violations

lint-yml:
    yamllint ./models ./snapshots ./dbt_project.yml ./packages.yml ./profiles.yml

format-yml:
    yamlfix ./models

################## WORKFLOW COMMANDS ###########

lint-format:
    just format-sql
    just lint-sql
    just format-yml
    just lint-yml

ci:
    just lint-format
    just dev-run

################## CONNECTION ##################

up:
    just deps

warehouse:
    ./duckdb

restart:
    rm -rf ./target
    rm -rf *.duckdb
    rm -rf dbt_packages
    dbt clean
    just up
