resource "aws_security_group" "eks" {
  name        = "education-sg-${var.environment}"
  description = "Allow traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "public-access-cidrs"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.cluster_endpoint_public_access_cidrs
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = merge(var.tags, {
    Environment = var.environment
    Product     = var.product
  })

}