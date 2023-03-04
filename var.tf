variable "profile" {
type = string 
default = "terraform"  
}
variable "region" {
    type = string
    default = "us-west-2"
}
variable "vpc_cidr" {
    type = string
    default = "192.168.0.0/16"
}
variable "public_cidr" {
    type = list(string)
    default = ["192.168.1.0/24" , "192.168.2.0/24"]
}
variable "private_cidr" {
    type = list(string)
    default = ["192.168.11.0/24" , "192.168.12.0/24"]
}
variable "azs" {
    type = list(string)
    default = ["us-west-2a", "us-west-2b"]
}
