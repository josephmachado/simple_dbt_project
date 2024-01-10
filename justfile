################ ENVIRONMENT SETUP ###################
# create a virtual env
create-venv:
    python3 -m venv venv

# activate virtual env
activate-venv:
    . venv/bin/activate

# Deactivate virtual env
deactivate:
    deactivate

################ DBT COMMANDS ###################
# These env variables tell dbt which directory to run the dbt commands from
export DBT_PROFILES_DIR := (`PWD` + "/sde_dbt_tutorial")
export DBT_PROJECT_DIR := (`PWD` + "/sde_dbt_tutorial")

foo:
    echo $DBT_PROFILES_DIR
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
test:
    dbt test

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

################# DQ REPORT ####################

# Generate DQ report
dq-report:
    dbt run --select elementary
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

prod-run:
    dbt deps --target prod
    dbt snapshot --target prod
    dbt run --select sde_dbt_tutorial --target prod
    dbt test --target prod

ci:
    just lint-format
    just prod-run

################## CONNECTION ##################

up:
	docker compose up --build -d

warehouse:
    just up 
    sleep 5
    PGPASSWORD=password1234 pgcli -h localhost -U dbt -p 5432 -d dbt   

stakeholder:
    just up
    sleep 5
    PGPASSWORD=password1234 pgcli -h localhost -U stakeholder -p 5432 -d dbt   

down:
	docker compose down 

restart:
    rm -rf /raw_data/*
    just down
    just up