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

variable "lb-front-end-ip" {
  type = string
}
