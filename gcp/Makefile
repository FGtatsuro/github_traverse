deployment_name := github-traverse

.PHONY: create preview cancel update destroy encrypt
create:
	$(eval OUTPUT := $(shell gcloud deployment-manager deployments describe $(deployment_name) 2>/dev/null))
	$(eval SLACK_WEBHOOK_URL := $(shell gcloud kms decrypt --ciphertext-file ../secrets.json.enc --plaintext-file - --location us --keyring github-traverse-keyring --key github-traverse-key | grep SLACK_WEBHOOK_URL | sed s/SLACK_WEBHOOK_URL=//))
	$(if $(SLACK_WEBHOOK_URL),, $(error Secret(secrets.json.enc) must include SLACK_WEBHOOK_URL for Slack incoming webhook URL))
	@if [ -z "$(OUTPUT)" ]; then \
		gcloud deployment-manager deployments create $(deployment_name) --template main.jinja \
		--properties "slackWebhookUrl:'$(SLACK_WEBHOOK_URL)'" --automatic-rollback-on-error; \
	fi

preview:
	$(eval OUTPUT := $(shell gcloud deployment-manager deployments describe $(deployment_name) 2>/dev/null))
	$(eval SLACK_WEBHOOK_URL := $(shell gcloud kms decrypt --ciphertext-file ../secrets.json.enc --plaintext-file - --location us --keyring github-traverse-keyring --key github-traverse-key | grep SLACK_WEBHOOK_URL | sed s/SLACK_WEBHOOK_URL=//))
	$(if $(SLACK_WEBHOOK_URL),, $(error Secret(secrets.json.enc) must include SLACK_WEBHOOK_URL for Slack incoming webhook URL))
	@if [ -n "$(OUTPUT)" ]; then \
		gcloud deployment-manager deployments update $(deployment_name) --template main.jinja \
		--properties "slackWebhookUrl:'$(SLACK_WEBHOOK_URL)'" --preview; \
	fi

cancel:
	$(eval OUTPUT := $(shell gcloud deployment-manager deployments describe $(deployment_name) 2>/dev/null))
	@if [ -n "$(OUTPUT)" ]; then \
		gcloud deployment-manager deployments cancel-preview $(deployment_name); \
	fi

update:
	$(eval OUTPUT := $(shell gcloud deployment-manager deployments describe --filter='name:$(deployment_name)' 2>/dev/null))
	@if [ -n "$(OUTPUT)" ]; then \
		gcloud deployment-manager deployments update $(deployment_name); \
	fi

destroy:
	$(eval OUTPUT := $(shell gcloud deployment-manager deployments describe $(deployment_name) 2>/dev/null))
	@# Now, Deployment Manager doesn't support cascading delete of Cloud Build Trigger.
	@if [ -n "$(OUTPUT)" ]; then \
		gcloud deployment-manager deployments delete $(deployment_name); \
		gcloud alpha builds triggers delete `gcloud alpha builds triggers describe $(deployment_name)-trigger-imagebuild --format="value(id)"` --quiet; \
		gcloud alpha builds triggers delete `gcloud alpha builds triggers describe $(deployment_name)-trigger-noticiationdeploy --format="value(id)"` --quiet; \
	fi

encrypt: # Generate encrypted file including secrets
	@gcloud kms encrypt --plaintext-file ../secrets.json --ciphertext-file ../secrets.json.enc \
		--location us --keyring github-traverse-keyring --key github-traverse-key
