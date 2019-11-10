deployment_name := github-traverse

.PHONY: create preview cancel update destroy func_update/notification
create:
	$(eval OUTPUT := $(shell gcloud deployment-manager deployments list --filter='name:$(deployment_name)' 2>/dev/null))
	$(if $(SLACK_WEBHOOK_URL),, $(error This task requires SLACK_WEBHOOK_URL as an environment variable))
	@if [ -z "$(OUTPUT)" ]; then \
		gcloud deployment-manager deployments create $(deployment_name) --template main.jinja \
		--properties "slackWebhookUrl:'$(SLACK_WEBHOOK_URL)'" --automatic-rollback-on-error; \
	fi

preview:
	$(eval OUTPUT := $(shell gcloud deployment-manager deployments list --filter='name:$(deployment_name)' 2>/dev/null))
	$(if $(SLACK_WEBHOOK_URL),, $(error This task requires SLACK_WEBHOOK_URL as an environment variable))
	@if [ -n "$(OUTPUT)" ]; then \
		gcloud deployment-manager deployments update $(deployment_name) --template main.jinja \
		--properties "slackWebhookUrl:'$(SLACK_WEBHOOK_URL)'" --preview; \
	fi

cancel:
	$(eval OUTPUT := $(shell gcloud deployment-manager deployments list --filter='name:$(deployment_name)' 2>/dev/null))
	@if [ -n "$(OUTPUT)" ]; then \
		gcloud deployment-manager deployments cancel-preview $(deployment_name); \
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

func_update/notification:
	$(if $(SLACK_WEBHOOK_URL),, $(error This task requires SLACK_WEBHOOK_URL as an environment variable))
	$(if $(GCP_SOURCEREPOSITORY_URL),, $(error This task requires GCP_SOURCEREPOSITORY_URL as an environment variable))
	@gcloud functions deploy github-traverse-notification --entry-point notification --runtime python37 --trigger-event providers/cloud.pubsub/eventTypes/topic.publish --trigger-resource cloud-builds --source $(GCP_SOURCEREPOSITORY_URL) --set-env-vars SLACK_WEBHOOK_URL=$(SLACK_WEBHOOK_URL),REPO_NAME=github_traverse
