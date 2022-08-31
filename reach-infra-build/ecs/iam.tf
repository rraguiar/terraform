resource "aws_iam_role" "ecs_node" {
  name = "${var.environment}-${var.customer}-${var.application_name}-ecs-instance-role"

  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ["ec2.amazonaws.com"]
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "ecs_node" {
  name = "${var.environment}-${var.customer}-${var.application_name}-ecs-instance-profile"
  role = aws_iam_role.ecs_node.name
  depends_on = [aws_iam_role.ecs_node]
}

resource "aws_iam_role_policy_attachment" "ecs_node_role" {
  role       = aws_iam_role.ecs_node.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "ecs_node_cloudwatchlogs_role" {
  role       = aws_iam_role.ecs_node.id
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

resource "aws_iam_role_policy_attachment" "ecs_node_cloudwatchagent_role" {
  role       = aws_iam_role.ecs_node.id
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy_attachment" "ecs_node_ssmagent_role" {
  role       = aws_iam_role.ecs_node.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "ecs_node_ecsagent_role" {
  role       = aws_iam_role.ecs_node.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"
}