up:
	docker compose up --build -d

down:
	docker compose down 

sh:
	docker exec -ti dbt bash