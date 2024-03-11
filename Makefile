.DEFAULT_GOAL := help

.PHONY: restore-dns-dhcp-config
restore-dns-dhcp-config: ## Run script to restore dns or dhcp config
	./scripts/restore-dns-dhcp-config.sh

.PHONY: restore-service-container
restore-service-container: ## Run script to restore dns or dchp service container
	./scripts/restore-service-container.sh

help:
	@grep -h -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
