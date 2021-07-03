variable "ami_id" {
    type = map
    default = {
    us-east-1 = "ami-0fa60543f60171fe3"
    us-east-1 = "ami-0b0af3577fe5e3532"
    us-east-1 = "ami-0aeeebd8d2ab47354"
  }
}

variable "instance_type" {
  type = list
  default = ["t2.micro", "t2.medium", "t2.large"]
}

variable "profile" {
}

variable "region" {
}
