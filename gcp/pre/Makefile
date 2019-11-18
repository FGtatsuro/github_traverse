deployment_name := github-traverse-pre

.PHONY: create preview cancel update
create:
	$(eval OUTPUT := $(shell gcloud deployment-manager deployments describe $(deployment_name) 2>/dev/null))
	@if [ -z "$(OUTPUT)" ]; then \
		gcloud deployment-manager deployments create $(deployment_name) --template main.jinja \
		--automatic-rollback-on-error; \
	fi

preview:
	$(eval OUTPUT := $(shell gcloud deployment-manager deployments describe $(deployment_name) 2>/dev/null))
	@if [ -n "$(OUTPUT)" ]; then \
		gcloud deployment-manager deployments update $(deployment_name) --template main.jinja \
		 --preview; \
	fi

cancel:
	$(eval OUTPUT := $(shell gcloud deployment-manager deployments describe $(deployment_name) 2>/dev/null))
	@if [ -n "$(OUTPUT)" ]; then \
		gcloud deployment-manager deployments cancel-preview $(deployment_name); \
	fi

update:
	$(eval OUTPUT := $(shell gcloud deployment-manager deployments describe $(deployment_name) 2>/dev/null))
	@if [ -n "$(OUTPUT)" ]; then \
		gcloud deployment-manager deployments update $(deployment_name); \
	fi
