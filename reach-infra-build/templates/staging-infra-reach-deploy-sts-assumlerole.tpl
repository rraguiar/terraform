{
  "Version": "2012-10-17",
  "Statement": {
    "Effect": "Allow",
    "Principal": { 
      "Service": [
          "ec2.amazonaws.com",
          "ssm.amazonaws.com",
          "s3.amazonaws.com",
          "ecs.amazonaws.com",
          "ecs-tasks.amazonaws.com"
        ]
      },
    "Action": "sts:AssumeRole"
  }
}