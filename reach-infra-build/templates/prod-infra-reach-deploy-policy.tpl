{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "GeneralServices",
            "Effect": "Allow",
            "Action": [
                "cloudwatch:GetMetricStatistics",
                "cloudwatch:ListMetrics",
                "ec2:DescribeIamInstanceProfileAssociations",
                "ec2:DescribeInstanceAttribute",
                "ec2:DescribeInstances",
                "ec2:DescribeInstanceStatus",
                "ec2:DescribeTags",
                "elasticache:DescribeCacheClusters",
                "elasticache:DescribeReplicationGroups",
                "iam:GetRole",
                "iam:ListRoles",
                "iam:PassRole",
                "kms:Decrypt",
                "rds:DescribeDBClusterEndpoints",
                "rds:DescribeDBClusters",
                "rds:DescribeDBInstances",
                "s3:ListAllMyBuckets",
                "secretsmanager:ListSecrets"
            ],
            "Resource": "*"
        },
        {
            "Sid": "GetSSMParameters",
            "Effect": "Allow",
            "Action": "ssm:GetParameters",
            "Resource": [
                "arn:aws:ssm:ca-central-1:738001968068:parameter/buildkite-agent-token"
            ]
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": [
                "s3:DeleteObject",
                "s3:GetBucketLocation",
                "s3:GetObject",
                "s3:ListBucket",
                "s3:PutObject",
                "secretsmanager:GetSecretValue"
            ],
            "Resource": [
                "arn:aws:secretsmanager:ca-central-1:738001968068:secret:*",
                "arn:aws:s3:::ep-prod-infrastructure-s3",
                "arn:aws:s3:::ep-prod-infrastructure-s3/*",
                "arn:aws:s3:::prod-infra-reach-bucket",
                "arn:aws:s3:::prod-infra-reach-bucket/*",
                "arn:aws:secretsmanager:ca-central-1:738001968068:secret:reach/*",
                "arn:aws:ecr:ca-central-1:738001968068:repository/reach",
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