.PHONY: install-mediawiki validate-mediawiki validate-instance build-CF validate-CF deploy-CF 

build-CF:
	${INFO} "Building Cloudformation Templates"
	@ansible-playbook site.yml --tags "prepare"
	${INFO} "Built Cloudformation Templates"

validate-CF:
	${INFO} "Validating Cloudformation Templates"
	@ansible-playbook site.yml --tags "validate" 
	${INFO} "Validated Cloudformation Templates"

deploy-CF:
	${INFO} "Deploying Cloudformation Templates"
	ansible-playbook site.yml --tags "deploy"
	${INFO} "Deployed Cloudformation Templates"

validate-instance:
	${INFO} "Validating Instance status"
	@chmod +x scripts/vault.py
	@python scripts/update_hosts.py $(STACK_PREFIX)
	${INFO} "Validated Instance status" 

install-mediawiki:
	${INFO} "Installaing  mediawiki & its dependencies"
	@python scripts/update_hosts.py $(STACK_PREFIX) --extra-vars "@vaults/secret.yml"
	@chmod +x scripts/vault.py
	ansible-playbook site.yml --vault-password-file scripts/vault.py --extra-vars "@vaults/secret.yml" -i hosts --tags=install-mediawiki
	${INFO} "Installed  mediawiki & its dependencies" 

validate-mediawiki:
	${INFO} "Validating Mediawiki
	ansible-playbook site.yml --vault-password-file scripts/vault.py --extra-vars "@vaults/secret.yml" -i hosts --tags=validate-mediawiki
