# resource "aws_key_pair" "ubuntu" {
#   key_name   = "ubuntu"
#   public_key = file(var.PUBLIC_KEY)
# }

# data "aws_availability_zones" "available" {
# }

# data "aws_ami" "ubuntu" {
#   most_recent = true
#   owners      = ["099720109477"] # Canonical

#   filter {
#     name   = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
#   }

#   filter {
#     name   = "root-device-type"
#     values = ["ebs"]
#   }
# }

# resource "aws_instance" "ubuntu" {
#   key_name          = aws_key_pair.ubuntu.key_name
#   ami               = data.aws_ami.ubuntu.id #"ami-0fb653ca2d3203ac1"
#   instance_type     = "t2.micro"
#   availability_zone = data.aws_availability_zones.available.names[0]
#   tags = {
#     Name = "koko_instance"
#   }

#   vpc_security_group_ids = [
#     aws_security_group.ubuntu.id
#   ]

#   provisioner "file" {
#     source      = "./pnginx.sh"
#     destination = "/tmp/pnginx.sh"
#   }

#   provisioner "remote-exec" {
#     inline = [
#       "chmod +x /tmp/pnginx.sh",
#       "sudo bash /tmp/pnginx.sh"
#     ]
#   }

#   connection {
#     type        = "ssh"
#     user        = var.USER
#     private_key = file(var.PRIVATE_KEY)
#     host        = self.public_ip
#   }

#   ebs_block_device {
#     device_name = "/dev/sda1"
#     volume_type = "gp2"
#     volume_size = 30
#   }
# }

# resource "aws_eip" "ubuntu" {
#   vpc      = true
#   instance = aws_instance.ubuntu.id
# }

# output "public_ip" {
#   value = aws_instance.ubuntu.public_ip
# }
