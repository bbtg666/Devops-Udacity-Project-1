variable "location" {
  type    = string
}

variable "suffix" {
  type    = string
}

variable "tags" {
  type = map(string)
}

variable "resource-group-name" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "vm-count" {
  type = number
}

variable "admin-user" {
  type = string
  default = "giangnt75"
}

variable "admin-password" {
  type = string
  default = "Password@11"
}

variable "vm-size" {
  type = string
  default = "Standard_B1s"
}