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
    docs-gen
    serve

################# DQ REPORT ####################

# Generate DQ report
dq-report:
    dbt run --select elementary
    edr report

################## LINT & FORMATTING ###########

lint:
    sqlfluff lint sde_dbt_tutorial/models --dialect postgres

format:
    sqlfluff fix sde_dbt_tutorial/models --dialect postgres

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
