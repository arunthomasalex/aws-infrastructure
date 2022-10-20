# infrastructure
Infrastructure provisioning

installation steps

python3 -m venv venv
source ./venv/bin/activate
pip install -r requirements.txt
chmod 400 config/sshkey

creating an environment
make

deleting an environment
make clean