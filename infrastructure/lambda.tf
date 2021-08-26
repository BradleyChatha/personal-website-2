// Anything to do with Lambda

data "archive_file" "empty" {
  type        = "zip"
  output_path = "${path.module}/private/lambda_function_payload.zip"

  source {
    content  = "This is just so I can actually create the fucking thing."
    filename = "dummy.txt"
  }
}

resource "aws_lambda_function" "dub_stats_updater" {
  filename         = data.archive_file.empty.output_path
  function_name    = "dub_stats_updater"
  role             = aws_iam_role.lambda.arn
  handler          = "index.handler"
  source_code_hash = filebase64sha256(data.archive_file.empty.output_path)
  runtime          = "nodejs14.x"
}

resource "aws_iam_role" "lambda" {
  name = "lambda-with-db-vcp-access"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Effect" : "Allow",
        "Sid" : ""
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda_rds_vpc_rw" {
  name = "lambda-rds-vpc-rw"
  role = aws_iam_role.lambda.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "SecretsManagerDbCredentialsAccess",
        "Effect" : "Allow",
        "Action" : [
          "secretsmanager:GetSecretValue",
          "secretsmanager:PutResourcePolicy",
          "secretsmanager:PutSecretValue",
          "secretsmanager:DeleteSecret",
          "secretsmanager:DescribeSecret",
          "secretsmanager:TagResource"
        ],
        "Resource" : "arn:aws:secretsmanager:*:*:secret:rds-db-credentials/*"
      },
      {
        "Sid" : "RDSDataServiceAccess",
        "Effect" : "Allow",
        "Action" : [
          "dbqms:CreateFavoriteQuery",
          "dbqms:DescribeFavoriteQueries",
          "dbqms:UpdateFavoriteQuery",
          "dbqms:DeleteFavoriteQueries",
          "dbqms:GetQueryString",
          "dbqms:CreateQueryHistory",
          "dbqms:DescribeQueryHistory",
          "dbqms:UpdateQueryHistory",
          "dbqms:DeleteQueryHistory",
          "rds-data:ExecuteSql",
          "rds-data:ExecuteStatement",
          "rds-data:BatchExecuteStatement",
          "rds-data:BeginTransaction",
          "rds-data:CommitTransaction",
          "rds-data:RollbackTransaction",
          "secretsmanager:CreateSecret",
          "secretsmanager:ListSecrets",
          "secretsmanager:GetRandomPassword",
          "tag:GetResources"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "VPCAccess",
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "ec2:CreateNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DeleteNetworkInterface",
          "ec2:AssignPrivateIpAddresses",
          "ec2:UnassignPrivateIpAddresses"
        ]
        "Resource" : "*"
      }
    ]
  })
}
