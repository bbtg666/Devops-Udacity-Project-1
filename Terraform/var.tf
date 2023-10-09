variable "vm-count" {
  type    = number
  default = 2
}

variable "location" {
  type    = string
  default = "eastus"
}

variable "suffix" {
  type    = string
  default = "udacity-giang-devops"
}

variable "tag-project-1" {
  type = map(string)
  default = {
    "UdacityDevopsProject": "1"
  }
}
