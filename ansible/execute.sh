#!/bin/bash

cd terraform
IPS=$(terraform output | awk 'match($0, /(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)/) {print substr($0, RSTART, RLENGTH)}')
cd -
cat config/ansible.ini > ansible/inventory.ini
for value in $IPS
do
    echo $value >> ansible/inventory.ini
done
ansible-playbook -i ansible/inventory.ini ansible/playbook.yml
rm ansible/inventory.ini