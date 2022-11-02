# Aws infrastructure provisioner
Simple overview of use/purpose.

## Description
The scope of this project is to automate the environment creation and maintenance using Infrastructure as Code(IaC).

## Getting Started

### Dependencies
* Terraform should be installed in the system

### Installing
* create .env file inside the folder and place the secret key and access key.
* python3 -m venv .venv
* . .venv/bin/activate
* pip install -r requirements.txt
* chmod 400 config/sshkey

### Executing program
* Create an environment and configure the instance with docker and deploy an application that is specified inside `ansible/playbook.yml`
```
make
```

* Destroy an environment
```
make clean
```

## Help
There are Two major steps when provisioning an environment:
* The following command is used to provision an environment in aws.
```
make terraform
```

* The next command will configure the system with docker and nginx.
```
make ansible
```

If any of the steps fail it can be re-run using these commands.
## Authors

👤 **Arun Thomas Alex**

- LinkedIn: [@arunthomasalex](https://in.linkedin.com/in/arun-alex)
- Github: [@arunthomasalex](https://github.com/arunthomasalex)

## Version History
* 0.1
    * Initial Release

## License
This project is licensed under the [GNU] License - see the LICENSE file for details
