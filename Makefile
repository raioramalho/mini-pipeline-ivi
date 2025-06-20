build:
	docker build -t mini-api -f Dockerfile.api .
	docker build -t mini-processor -f Dockerfile.processor .

deploy:
	kubectl apply -f k8s/
