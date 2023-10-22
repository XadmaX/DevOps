provider "aws" {
  region = "eu-central-1"
}

resource "aws_default_vpc" "default" {}

# data "template_file" "init" {
#   template = file("template/setup.tpl")
#   vars = {
#     jdk_pkg = "openjdk-11-jdk"
#   }
# }

# provisioner "file" {
#   source      = "conf/proxy.conf"
#   destination = "/etc/apache2/mods-enabled/proxy.conf"
# }

resource "aws_instance" "webserver-test" {
  ami                    = "ami-04e601abe3e1a910f"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.webserver-test.id]
  key_name               = "jenkins-ubuntu"
  # user_data              = data.template_file.init.rendered
  user_data = templatefile("template/setup_web.tpl", { web_serv = "apache2" })
  tags = {
    Name  = "Web "
    Owner = "Yehor"
  }
}

resource "aws_instance" "jenkins_master" {
  ami                    = "ami-04e601abe3e1a910f"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.webserver-test.id]
  key_name               = "jenkins-ubuntu"
  # user_data              = data.template_file.init.rendered
  user_data = templatefile("template/setup_master.tpl", {
    jdk_pkg           = "openjdk-11-jdk",
    jenkins_key       = "jenkins.io-2023",
    jenkins_list_type = "debian-stable"
  })
  tags = {
    Name  = "Jenkins Master "
    Owner = "Yehor"
  }
  provisioner "local-exec" {
    # command = "scp -i ${aws_instance.key_name} ./jenkins_home.zip ${aws_instance.jenkins_master.public_ip}:/home"
    command = "echo 'Jenkins IP: ${aws_instance.jenkins_master.public_ip}'"
  }
  depends_on = [
    aws_instance.jenkins-slave
  ]
}

resource "aws_instance" "jenkins-slave" {
  ami                    = "ami-04e601abe3e1a910f"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.webserver-test.id]
  key_name               = "jenkins-ubuntu"
  # user_data              = data.template_file.init.rendered
  user_data = templatefile("template/setup_slave.tpl", { jdk_pkg = "openjdk-11-jdk" })
  tags = {
    Name  = "Jenkins Slave "
    Owner = "Yehor"
  }
}

resource "aws_security_group" "webserver-test" {
  name        = "WebServer Security Group"
  description = "My First SecurityGroup"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "Web "
    Owner = "Yehor"
  }

}

output "webserver_ip" {
  value = aws_instance.webserver-test.public_ip
}

output "jenkins_master_ip" {
  value = aws_instance.jenkins_master.public_ip
}

output "jenkins_slave_ip" {
  value = aws_instance.jenkins-slave.public_ip
}
