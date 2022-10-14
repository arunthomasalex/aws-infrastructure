variable "awsprops" {
  type = map
  default = {
    region = "ap-south-1"
    ami = "ami-068257025f72f470d"
    itype = "t2.micro"
    enable_publicip = true
    enable_dns = true
    keyname = "terraform"
  }
}

variable "instance_count" {
  type = number
  description = "No of instances to be created"
  default = 1
}

variable "ssh_key_file" {
  type = string
  description = "Public key file for ssh connection."
  default = "../config/sshkey.pub"
}

variable "user-data-script" {
  type = string
  description = "User script to be executed in the new instance."
  default = ""
}

variable "vpc-cidr-block" {
  description = "The CIDR block to associate to the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet-cidr-block" {
  description = "The CIDR block to associate to the subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "instance-tag-name" {
  description = "The Name to apply to the Instance"
  type        = string
  default     = "terraform"
}

variable "vpc-tag-name" {
  description = "The Name to apply to the VPC"
  type        = string
  default     = "terraform"
}

variable "ig-tag-name" {
  description = "The name to apply to the Internet gateway tag"
  type        = string
  default     = "terraform"
}

variable "subnet-tag-name" {
  description = "The Name to apply to the VPN"
  type        = string
  default     = "terraform"
}

variable "sg-tag-name" {
  description = "The Name to apply to the security group"
  type        = string
  default     = "terraform"
}

variable "ingress_ports" {
  type        = list(number)
  description = "list of ingress ports"
  default     = [22, 80, 443]
}

# variable "egress_ports" {
#   type        = list(string)
#   description = "list of egress ports"
#   default     = [0]
# }