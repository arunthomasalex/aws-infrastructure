include .env
export

edit: terraform-init terraform-plan terraform-apply ansible-exec
create: terraform-plan terraform-apply ansible-exec 
clean: terraform-destroy

terraform-init:
	@echo "terraform-init"
	cd terraform && \
	terraform init -upgrade && \
	cd ~

terraform-plan:
	@echo "terraform-plan"
	cd terraform && \
	terraform plan -out=environment.tfplan && \
	cd ~

terraform-apply:
	@echo "terraform-apply"
	cd terraform && \
	terraform apply -auto-approve environment.tfplan && \
	cd ~

terraform-destroy:
	@echo "terraform-destroy"
	cd terraform && \
	terraform destroy -auto-approve && \
	cd ~

ansible-exec:
	@echo "ansible-exec"
	./ansible/execute.sh
