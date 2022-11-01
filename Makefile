include .env
export

DELAY_SECONDS=10

RED=\033[0;31m
ORANGE=\033[0;33m
GREEN=\033[0;32m
NOCOLOR=\033[0m

instances=1
containers=1 

instance_ids=$(shell cd terraform && terraform output --json instance-ids | sed -r 's/(,|\[|\])/ /g')

edit: terraform-init terraform wait ansible

terraform: terraform-plan terraform-apply

ansible: ansible-init ansible-exec ansible-destroy

clean: ansible-destroy terraform-destroy

wait:
	@echo "${ORANGE}Waiting for ${DELAY_SECONDS} seconds for the machines to start${NOCOLOR}"
	@sleep $(DELAY_SECONDS)

terraform-init:
	@echo "${ORANGE}terraform-init${NOCOLOR}"
	@cd terraform && \
	terraform init -upgrade

terraform-plan:
	@echo "${ORANGE}terraform-plan${NOCOLOR}"
	@cd terraform && \
	terraform plan -out=environment.tfplan -var instance_count=${instances}

terraform-apply:
	@echo "${ORANGE}terraform-apply${NOCOLOR}"
	@cd terraform && \
	terraform apply -auto-approve environment.tfplan

terraform-output:
	@cd terraform && \
	terraform output --json $(output)

terraform-destroy:
	@echo "${ORANGE}terraform-destroy${NOCOLOR}"
	@cd terraform && \
	terraform destroy -auto-approve

ansible-init:
	@echo "${ORANGE}Creating ansible file for environment.${NOCOLOR}"
	@mkdir ansible/.tmp
	@cp config/ansible.ini ansible/.tmp/inventory.ini
	@cp config/aws-monitor.service ansible/.tmp/
	@echo "[default]" > ansible/.tmp/credentials && cat .env >> ansible/.tmp/credentials
	@cp lib/* ansible/.tmp/
	@cd terraform && terraform refresh && terraform output --json application-ip | grep -oE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' >> ../ansible/.tmp/inventory.ini
	@cd terraform && terraform output --json application-details > ../ansible/.tmp/instances.tmp
	@cd terraform && terraform output --json application-count > ../ansible/.tmp/count.tmp

ansible-exec:
	@echo "${ORANGE}Executing ansible command.${NOCOLOR}"
	ansible-playbook ansible/nginx.yml
	ansible-playbook -i ansible/.tmp/inventory.ini ansible/playbook.yml --extra-vars="container_count=${containers}"
	
ansible-destroy:
	@echo "${RED}Deleting ansible file.${NOCOLOR}"
	@rm -rf ansible/.tmp

start:
	@echo "${ORANGE}Starting aws instance${NOCOLOR}"
	@aws ec2 start-instances --instance-ids $(instance_ids)
	@aws ec2 wait instance-running --instance-ids $(instance_ids)
	@echo Instance IP
	@aws ec2 describe-instances --instance-ids $(instance_id) --query=Reservations[].Instances[].PublicIpAddress --region ap-south-1
	@echo "${GREEN}Started aws instance${NOCOLOR}"

stop:
	@echo "${ORANGE}Stopping aws instance${NOCOLOR}"
	@aws ec2 stop-instances --instance-ids $(instance_ids)
	@aws ec2 wait instance-stopped --instance-ids $(instance_ids)
	@echo "${RED}Stopped aws instance${NOCOLOR}"

status:
	@echo "${ORANGE}Aws instance status${NOCOLOR}"
	@aws ec2 describe-instance-status --instance-ids $(instance_ids)