include .env
export

edit: terraform-init terraform-plan terraform-apply ansible-exec
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
	./ansible/execute.sh
