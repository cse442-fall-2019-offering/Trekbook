.PHONY: build
build:
	docker-compose build

.PHONY: run
run:
	docker-compose stop
	docker-compose up -d

.PHONY: createadmin
createadmin:
	docker-compose run --rm api ./manage.py createsuperuser --username admin