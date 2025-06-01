variable "prefix" {
  description = "Naming prefix for resources. Should be 3-8 characters."
  type        = string
  default     = "tacoweb"

  validation {
    condition     = length(var.prefix) >= 3 && length(var.prefix) <= 8
    error_message = "Naming prefix should be between 3-8 characters. Submitted value was ${length(var.prefix)}."
  }
}

variable "application_port" {
  description = "Port to use for the flask application. Defaults to 8080."
  type        = number
  default     = 8080
}
variable "rgname" {
  type = string
}
variable "vnetname" {
  type = string
}
variable "subnet_name" {
  type = string

}
variable "vmname" {
  type = string
}
variable "vmsize" {
  type = string

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


variable "nsgname" {
  type = string

}
variable "vmssname" {
  type = string
}
variable "vmssku" {
  type = string
}
variable "vms_count" {
  type = number
}