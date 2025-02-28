variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "key_name" {
  description = "AWS Key Pair Name"
  default = "toluxfash"
}

variable "server_name" {
  description = "Name of the server"
  default     = "devops-todo-app"
}
