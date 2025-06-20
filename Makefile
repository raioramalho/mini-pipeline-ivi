build:
	docker build -t mini-api -f Dockerfile.api .
	docker build -t mini-processor -f Dockerfile.processor .

ENV ?= k8s

deploy:
	terraform -chdir=terraform/$(ENV) apply -auto-approve

dev:
	docker compose --env-file .env.dev up -d

homolog:
	docker compose --env-file .env.homolog up -d

prod:
	docker compose --env-file .env.prod up -d

logs:
	docker compose logs -f api
