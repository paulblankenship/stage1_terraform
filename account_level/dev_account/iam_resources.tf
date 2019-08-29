# Exactly as it sounds.  Site wide IAM roles, policies, etc.
# These usually cross different environments within an account
# which is why they are here but for organizational reasons
# they are not placed in 'envs_support.tf' even though many
# of these are for exactly that but not entirely.
resource "aws_iam_instance_profile" "app_frontend" {
  name = "${var.name}_app_frontend_profile"
  role = "${aws_iam_role.app_frontend.name}"
}

resource "aws_iam_role" "app_frontend" {
  name = "${var.name}_app_frontend_role"
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

resource "aws_iam_instance_profile" "app_backend" {
  name = "${var.name}_app_backend_profile"
  role = "${aws_iam_role.app_backend.name}"
}

resource "aws_iam_role" "app_backend" {
  name = "${var.name}_app_backend_role"
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
