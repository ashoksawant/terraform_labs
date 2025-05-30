variable "resource_group" {
  type = string
}
variable "vnet" {
  type = string
}
variable "subnet" {
  type = string

}
variable "vmname" {
  type = string
}
variable "vmsize" {
  type = string

}
variable "os_disks" {
  type = map(string)
}
variable "user_name" {
  type      = string
  sensitive = true
}
variable "vm_password" {
  type      = string
  sensitive = true
}
variable "vm_os_image" {
  type = string
}
variable "public_ip" {
  type = string
}
variable "application_port" {
  type = number

}
variable "nsg_name" {
  type = string

}