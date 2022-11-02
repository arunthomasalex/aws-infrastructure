# Aws infrastructure provisioner

Simple overview of use/purpose.

## Description

The scope of this project is to automate the environment creation and maintenance using Infrastructure as Code(IaC).

## Getting Started

### Dependencies

* Terraform should be installed in the system

### Installing
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

* 

## Help

Any advise for common problems or issues.
```
command to run if program contains helper info
```

## Authors

👤 **Arun Thomas Alex**

- LinkedIn: [@arunthomasalex](https://in.linkedin.com/in/arun-alex)
- Github: [@arunthomasalex](https://github.com/arunthomasalex)

## Version History

* 0.1
    * Initial Release

## License

This project is licensed under the [GNU] License - see the LICENSE file for details
