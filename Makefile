include .env
export

edit: terraform-init terraform-plan terraform-apply ansible-exec
create: terraform-plan terraform-apply ansible-exec 
clean: terraform-destroy

test:
	@echo "Print test"

terraform-init:
	@echo "terraform-init"
	cd terraform && \
	terraform init -upgrade && \
	cd ~

terraform-plan:
	@echo "terraform-plan"
	cd terraform && \
	terraform plan && \
	cd ~

terraform-apply:
	@echo "terraform-apply"
	cd terraform && \
	terraform apply -auto-approve && \
	cd ~

terraform-destroy:
	@echo "terraform-destroy"
	cd terraform && \
	terraform destroy -auto-approve && \
	cd ~

ansible-exec:
	@echo "ansible-exec"
