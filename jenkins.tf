resource "aws_instance" "jenkins" {
  ami                    = data.aws_ami.joindevops.id
  vpc_security_group_ids = ["sg-06382d8940e141231"]
  instance_type          = "t3.micro"
  subnet_id              = "subnet-095a1f4d4024b60f7"
  tags = merge(
    var.common_tags,
    {

      Name = "${var.project_name}-${var.environment}-jenkins"
    }
  )
  # 20GB is not enough
  root_block_device {
    volume_size           = 50    # Size of the root volume in GB
    volume_type           = "gp3" # General Purpose SSD (you can change it if needed)
    delete_on_termination = true  # Automatically delete the volume when the instance is terminated
  }

  user_data = file("jenkins-master.sh")

}
# jenkins agent creating
resource "aws_instance" "jenkins-agent" {
  ami                    = "ami-09c813fb71547fc4f"
  vpc_security_group_ids = ["sg-06382d8940e141231"]
  instance_type          = "t3.micro"
  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-jenkins-agent"
    }
  )
  root_block_device {
    volume_size           = 50    # Size of the root volume in GB
    volume_type           = "gp3" # General Purpose SSD (you can change it if needed)
    delete_on_termination = true  # Automatically delete the volume when the instance is terminated
  }

  user_data = file("jenkins-agent.sh")

}
module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 2.0"

  zone_name = var.zone_name

  records = [
    {
      name = "jenkins"
      type = "A"
      ttl  = 1
      records = [
        aws_instance.jenkins.public_ip
      ]
      allow_overwrite = true
    },
    {
      name = "jenkins-agent"
      type = "A"
      ttl  = 1
      records = [
        aws_instance.jenkins-agent.private_ip
      ]
      allow_overwrite = true
    }
  ]

}