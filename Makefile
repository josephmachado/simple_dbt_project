up:
	docker compose up --build -d

down:
	docker compose down 

sh:
	docker exec -ti dbt bash

warehouse:
	PGPASSWORD=password1234 pgcli -h localhost -U dbt -p 5432 -d dbt
