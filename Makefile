include .env
export

DELAY_SECONDS=10

RED=\033[0;31m
ORANGE=\033[0;33m
GREEN=\033[0;32m
NOCOLOR=\033[0m

edit: terraform-init terraform wait ansible

terraform: terraform-plan terraform-apply

ansible: ansible-init ansible-exec ansible-finish

clean: terraform-destroy

wait:
	@echo "${ORANGE}Waiting for ${DELAY_SECONDS} seconds${NOCOLOR}"
	@sleep $(DELAY_SECONDS)

terraform-init:
	@echo "${ORANGE}terraform-init${NOCOLOR}"
	@cd terraform && \
	terraform init -upgrade

terraform-plan:
	@echo "${ORANGE}terraform-plan${NOCOLOR}"
	@cd terraform && \
	terraform plan -out=environment.tfplan

terraform-apply:
	@echo "${ORANGE}terraform-apply${NOCOLOR}"
	@cd terraform && \
	terraform apply -auto-approve environment.tfplan

terraform-destroy:
	@echo "${ORANGE}terraform-destroy${NOCOLOR}"
	@cd terraform && \
	terraform destroy -auto-approve

ansible-init:
	@echo "${ORANGE}Creating ansible file for environment.${NOCOLOR}"
	@cp config/ansible.ini ansible/inventory.ini
	@cd terraform && terraform output --json ec2instance-ip | grep -oE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' >> ../ansible/inventory.ini

ansible-exec:
	@echo "${ORANGE}Executing ansible command.${NOCOLOR}"
	ansible-playbook -i ansible/inventory.ini ansible/playbook.yml
	
ansible-finish:
	@echo "${RED}Deleting ansible file.${NOCOLOR}"
	@rm -f ansible/inventory.ini