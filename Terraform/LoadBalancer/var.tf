variable "location" {
  type = string
}

variable "suffix" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "resource-group-name" {
  type = string
}

variable "vm-count" {
  type = number
}

variable "list-network-interface" {
  type = list(string)
}
