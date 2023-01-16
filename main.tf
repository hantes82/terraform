provider "aws" {
	region = "us-east-2"
}

resource "aws_instance""example" {
	ami		="ami-0c55b159cbfafe1f0"
	instance_type	="t2.micro"
	vpc_security_group_ids =[aws_security_group.instance.id]
	
	user_data 	= <<-EOF
			  #!/bin/bash
			  echo "Witaj, Swiecie" > index.html
			  nohup busybox httpd -f -p ${var.server_port} &
			  EOF
	tags		=  {
		Name = "Terraform-example"
	}	
} 
resource "aws_security_group" "instance" {
	name 	="terraform-example-instance"

	ingress {
	from_port	=var.server_port
	to_port		=var.server_port
	protocol	="tcp"
	cidr_blocks	=["0.0.0.0/0"]
	}
}
variable "server_port" {
	description ="Port servera WWW"
	type =number
	default =8080
}
output "public_ip" {
	value = aws_instance.example.public.ip
	description ="Publiczny adres IP servera WWW"

}
