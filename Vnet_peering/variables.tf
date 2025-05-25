variable "resource_group_name" {
  type = string

}
variable "vnetname2" {
  type = string
}
variable "vnetname1" {
  type = string
}
variable "vnet1_subnet1" {
  type = string
}
variable "subnet2" {
  type = map(string)

}
variable "address_space" {
  type = list(string)
}
variable "public_ip" {
  type = list(string)

}



variable "vms" {
  type = list(string)

}
variable "password" {
  type      = string
  sensitive = true

}
