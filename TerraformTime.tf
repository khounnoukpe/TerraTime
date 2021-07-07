provider "aws" {
  region = ""
  access_key = ""
  secret_key = ""
}

locals {
  common_tags = {
   Name = "REPLACE"
   App_Name = " REPLACE"
   Cost_center = "REPLACE"
   Business_unit = "REPLACE"
   Project = "REPLACE"
   App_role = "REPLACE"
   Customer = "REPLACE"
   Environment = "REPLACE"
   Confidentiality = "REPLACE"
   Owner = "REPLACE"
   Opt_in-Opt_out = "REPLACE"
   Application_ID = "REPLACE"
   Compliance = "REPLACE"
   Security_Classification = "NA"
  }

  ingress_rules = [{
        port        = 443
        description = "https port"
    },
    {
        port        = 8000
        description = "http proxy port"
    },
    {
        port        = 53
        description = "dns port"
    },
    {
        port        = 80
        description = "http port"
    },
    {
        port        = 3389
        description = "rdp port"
    },
    {
        port        = 22
        description = "ssh port"
    },
    {
        port        = 22
        description = "ssh port"
    },
    {
        port        = 23
        description = "telnet port"
    },
    {
        port        = 23
        description = "telnet port"
    },
    {
        port        = 25
        description = "smtp port"
    },
    {
        port        = 123
        description = "NTP port"
    },
    {
        port        = 2049
        description = "NFS port"
    },
    {
        port        = 1241
        description = "Nessus port"
    }]
}
resource "aws_instance" "REPLACEweb" {
  ami = var. ami_id["us-east-1"]
  instance_type = var. instance_type[0]
  tags = local.common_tags
}

resource "aws_instance" "REPLACEweb01" {
  ami = var. ami_id["us-east-1"]
  instance_type = var. instance_type[1]
  tags = local.common_tags
}

resource "aws_instance" "REPLACEweb02" {
  ami = var. ami_id["us-east-1"]
  instance_type = var. instance_type[2]
  tags = local.common_tags
}

  resource "aws_ebs_volume" "REPLACEebs" {
    availability_zone = aws_instance.REPLACEweb.availability_zone
    size              = 40

    tags = {
      Name = "HelloWorld"
    }
}

resource "aws_ebs_volume" "REPLACEebs01" {
  availability_zone = aws_instance.REPLACEweb01.availability_zone
  size              = 40

  tags = {
    Name = "HelloWorld01"
  }
}

resource "aws_ebs_volume" "REPLACEebs02" {
  availability_zone = aws_instance.REPLACEweb02.availability_zone
  size              = 40

  tags = {
    Name = "HelloWorld02"
  }
}

  output "REPLACE_ec2" {
    value = aws_instance.REPLACEweb.public_ip
  }

  resource "aws_eip" "REPLACE_eip" {
    vpc      = true
    tags = local.common_tags
}

  output "aws_eip" {
    value = aws_eip.REPLACE_eip.id
}

  resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.REPLACEweb.id
  allocation_id = aws_eip.REPLACE_eip.id
}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.REPLACEebs.id
  instance_id = aws_instance.REPLACEweb.id
}

resource "aws_volume_attachment" "ebs_att01" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.REPLACEebs01.id
  instance_id = aws_instance.REPLACEweb01.id
}

resource "aws_volume_attachment" "ebs_att02" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.REPLACEebs02.id
  instance_id = aws_instance.REPLACEweb02.id
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = "VPCID"

  dynamic "ingress" {
      for_each = local.ingress_rules
      content {
          description = ingress.value.description
          from_port   = ingress.value.port
          to_port     = ingress.value.port
          protocol    = "tcp"
          cidr_blocks = ["${aws_eip.REPLACE_eip.public_ip}/32"]
  #  cidr_blocks      = [aws_eip.REPLACE_eip.public_ip/32]

      }
  }

  tags = local.common_tags
}
