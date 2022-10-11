include .env
export

edit: terraform-init terraform ansible
terraform: terraform-plan terraform-apply
ansible: ansible-exec
clean: terraform-destroy

terraform-init:
	@echo "terraform-init"
	cd terraform && \
	terraform init -upgrade

terraform-plan:
	@echo "terraform-plan"
	cd terraform && \
	terraform plan -out=environment.tfplan

terraform-apply:
	@echo "terraform-apply"
	cd terraform && \
	terraform apply -auto-approve environment.tfplan

terraform-destroy:
	@echo "terraform-destroy"
	cd terraform && \
	terraform destroy -auto-approve

ansible-exec:
	@echo "ansible-exec"
	@cp config/ansible.ini ansible/inventory.ini
	@cd terraform && terraform output --json ec2instance-ip | grep -oE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' >> ../ansible/inventory.ini
	ansible-playbook -i ansible/inventory.ini ansible/playbook.yml
	rm ansible/inventory.ini