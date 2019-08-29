# Exactly as it sounds.  Site wide IAM roles, policies, etc.
# These usually cross different environments within an account
# which is why they are here but for organizational reasons
# they are not placed in 'envs_support.tf' even though many
# of these are for exactly that but not entirely.
resource "aws_iam_instance_profile" "winjump" {
  name = "${var.name}-winjump-profile"
  role = "${aws_iam_role.winjump.name}"
}

resource "aws_iam_role" "winjump" {
  name = "${var.name}-winjump-role"
  path = "/"

  assume_role_policy = <<-EOF
  {
      "Version": "2012-10-17",
      "Statement": [
          {
              "Action": "sts:AssumeRole",
              "Principal": {
                 "Service": "ec2.amazonaws.com"
              },
              "Effect": "Allow",
              "Sid": ""
          }
      ]
  }
  EOF
}

resource "aws_iam_instance_profile" "linjump" {
  name = "${var.name}-linjump-profile"
  role = "${aws_iam_role.linjump.name}"
}

resource "aws_iam_role" "linjump" {
  name = "${var.name}-linjump-role"
  path = "/"

  assume_role_policy = <<-EOF
  {
      "Version": "2012-10-17",
      "Statement": [
          {
              "Action": "sts:AssumeRole",
              "Principal": {
                 "Service": "ec2.amazonaws.com"
              },
              "Effect": "Allow",
              "Sid": ""
          }
      ]
  }
  EOF
}

resource "aws_iam_instance_profile" "ad-gui" {
  name = "${var.name}-ad-gui-profile"
  role = "${aws_iam_role.winjump.name}"
}

resource "aws_iam_role" "ad-gui" {
  name = "${var.name}-ad-gui-role"
  path = "/"

  assume_role_policy = <<-EOF
  {
      "Version": "2012-10-17",
      "Statement": [
          {
              "Action": "sts:AssumeRole",
              "Principal": {
                 "Service": "ec2.amazonaws.com"
              },
              "Effect": "Allow",
              "Sid": ""
          }
      ]
  }
  EOF
}

resource "aws_iam_instance_profile" "ad-core" {
  name = "${var.name}-ad-core-profile"
  role = "${aws_iam_role.ad-core.name}"
}

resource "aws_iam_role" "ad-core" {
  name = "${var.name}-ad-core-role"
  path = "/"

  assume_role_policy = <<-EOF
  {
      "Version": "2012-10-17",
      "Statement": [
          {
              "Action": "sts:AssumeRole",
              "Principal": {
                 "Service": "ec2.amazonaws.com"
              },
              "Effect": "Allow",
              "Sid": ""
          }
      ]
  }
  EOF
}
