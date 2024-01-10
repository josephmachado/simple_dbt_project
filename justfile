################ ENVIRONMENT ###################
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

################# DQ REPORT ####################

# Generate DQ report
dq-report:
    dbt run --select elementary
    edr report

################## LINT & FORMATTING ###########

lint-sql:
    sqlfluff lint sde_dbt_tutorial/models --dialect postgres

format-sql:
    sqlfluff fix sde_dbt_tutorial/models --dialect postgres

lint-yml:
    yamllint sde_dbt_tutorial

format-yml:
    yamlfix sde_dbt_tutorial

################## WORKFLOW COMMANDS ###########

ci:
    just deps
    just snapshot
    just run-sde
    just test

################## CONNECTION ##################

up:
	docker compose up --build -d

warehouse:
    just up 
    sleep 10
    PGPASSWORD=password1234 pgcli -h localhost -U dbt -p 5432 -d dbt   

down:
	docker compose down 
