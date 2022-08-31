{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "cloudwatch:GetMetricStatistics",
                "cloudwatch:ListMetrics",
                "ec2:DescribeInstances",
                "ec2:DescribeInstanceStatus",
                "ec2:DescribeTags",
                "elasticache:DescribeCacheClusters",
                "elasticache:DescribeReplicationGroups",
                "iam:GetRole",
                "iam:ListRoles",
                "kms:Decrypt",
                "rds:DescribeDBClusterEndpoints",
                "rds:DescribeDBClusters",
                "rds:DescribeDBInstances",
                "s3:ListAllMyBuckets"
            ],
            "Resource": "*"
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": [
                "s3:DeleteObject",
                "s3:GetObject",
                "s3:GetBucketLocation",
                "s3:ListBucket",
                "s3:PutObject",
                "secretsmanager:GetSecretValue"
            ],
            "Resource": [
                "arn:aws:secretsmanager:ca-central-1:738001968068:secret:*",
                "arn:aws:s3:::ep-prod-infrastructure-s3",
                "arn:aws:s3:::ep-prod-infrastructure-s3/*",
                "arn:aws:s3:::staging-infra-apple-bucket",
                "arn:aws:s3:::staging-infra-apple-bucket/*",
                "arn:aws:secretsmanager:ca-central-1:738001968068:secret:apple/*",
                "arn:aws:ecr:ca-central-1:738001968068:repository/apple",
                "arn:aws:ecs:*:738001968068:cluster/*",
                "arn:aws:ecs:*:738001968068:container-instance/*",
                "arn:aws:ecs:*:738001968068:task-set/*/*/*",
                "arn:aws:ecs:*:738001968068:task/*",
                "arn:aws:ecs:*:738001968068:capacity-provider/*",
                "arn:aws:ecs:*:738001968068:task-definition/*:*",
                "arn:aws:ecs:*:738001968068:service/*"
            ]
        }
    ]
}