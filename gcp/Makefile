deployment_name := github-traverse

.PHONY: create preview update destroy
create:
	$(eval OUTPUT := $(shell gcloud deployment-manager deployments list --filter='name:$(deployment_name)' 2>/dev/null))
	@if [ -z "$(OUTPUT)" ]; then \
		gcloud deployment-manager deployments create $(deployment_name) --template main.jinja --automatic-rollback-on-error; \
	fi

preview:
	$(eval OUTPUT := $(shell gcloud deployment-manager deployments list --filter='name:$(deployment_name)' 2>/dev/null))
	@if [ -n "$(OUTPUT)" ]; then \
		gcloud deployment-manager deployments update $(deployment_name) --template main.jinja --preview; \
	fi

update:
	$(eval OUTPUT := $(shell gcloud deployment-manager deployments list --filter='name:$(deployment_name)' 2>/dev/null))
	@if [ -n "$(OUTPUT)" ]; then \
		gcloud deployment-manager deployments update $(deployment_name); \
	fi

destroy:
	$(eval OUTPUT := $(shell gcloud deployment-manager deployments list --filter='name:$(deployment_name)' 2>/dev/null))
	@# Now, Deployment Manager doesn't support cascading delete of Cloud Build Trigger.
	@if [ -n "$(OUTPUT)" ]; then \
		gcloud deployment-manager deployments delete $(deployment_name); \
		gcloud alpha builds triggers delete `gcloud alpha builds triggers describe $(deployment_name)-trigger-imagebuild --format="value(id)"` --quiet; \
	fi
