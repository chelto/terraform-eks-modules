resource "aws_iam_role" "cluster" {
  name = "${var.environment}-Cluster-Role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
  tags = merge(var.tags, {
    Environment = var.environment
    Product     = var.product
  })
}

