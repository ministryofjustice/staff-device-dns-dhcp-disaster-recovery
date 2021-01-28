build:
	docker-compose build

restore-dns-dhcp-config: build
	docker-compose run --rm app ./restore-dns-dhcp-config.sh

restore-service-container: build
	docker-compose run --rm app ./restore-service-container.sh