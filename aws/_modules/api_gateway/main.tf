

# ---------------------------------------------------------------------
# ApiGateway
# ---------------------------------------------------------------------

resource "aws_api_gateway_rest_api" "TerraFailAPI" {
  # Drata: Configure [aws_api_gateway_rest_api.tags] to ensure that organization-wide tagging conventions are followed.
  name = "TerraFailAPI"

  endpoint_configuration {
    types = ["EDGE"]
  }

  policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": "user@terrafail.com",
        "Action": "execute-api:Invoke",
        "Resource": "S3:PutObject"
      }
    ]
  }
  EOF
}

resource "aws_api_gateway_account" "TerraFailAPI_account" {
  depends_on = [
    aws_iam_role_policy_attachment.TerraFailAPI_iam_policy_attachment,
    aws_iam_role_policy.TerraFailAPI_iam_role_policy
  ]
}

resource "aws_api_gateway_resource" "TerraFailAPI_resource" {
  rest_api_id = aws_api_gateway_rest_api.TerraFailAPI.id
  parent_id   = aws_api_gateway_rest_api.TerraFailAPI.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_integration" "TerraFailAPI_integration" {
  rest_api_id = aws_api_gateway_rest_api.TerraFailAPI.id
  resource_id = aws_api_gateway_resource.TerraFailAPI_resource.id
  http_method = aws_api_gateway_method.TerraFailAPI_method.http_method
  type        = "MOCK"
  depends_on  = [aws_api_gateway_method.TerraFailAPI_method]
}

resource "aws_api_gateway_deployment" "TerraFailAPI_deployment" {
  rest_api_id       = aws_api_gateway_rest_api.TerraFailAPI.id
  description       = "TerraFailAPI_deployment"
  stage_description = "TerraFailAPI_deployment description"
  stage_name        = "TerraFailAPI_stage"

  depends_on = [aws_api_gateway_method.TerraFailAPI_method]
}

resource "aws_api_gateway_domain_name" "TerraFailAPI_domain_name" {
  # Drata: Configure [aws_api_gateway_domain_name.tags] to ensure that organization-wide tagging conventions are followed.
  certificate_arn = aws_acm_certificate_validation.TerraFailAPI_cert.certificate_arn
  domain_name     = "www.thisisthedarkside.com"
  security_policy = "tls_1_2"
}

resource "aws_api_gateway_api_key" "TerraFailAPI_key" {
  # Drata: Configure [aws_api_gateway_api_key.tags] to ensure that organization-wide tagging conventions are followed.
  name        = "TerraFailAPI_key"
  description = "TerraFailAPI_key description"
  enabled     = true
}

resource "aws_api_gateway_method_settings" "TerraFailAPI_method_settings" {
  rest_api_id = aws_api_gateway_rest_api.TerraFailAPI.id
  stage_name  = aws_api_gateway_stage.TerraFailAPI_stage.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled      = true
    logging_level        = "ERROR"
    caching_enabled      = false
    cache_data_encrypted = false
  }
}

resource "aws_api_gateway_method" "TerraFailAPI_method" {
  rest_api_id   = aws_api_gateway_rest_api.TerraFailAPI.id
  resource_id   = aws_api_gateway_resource.TerraFailAPI_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_usage_plan" "TerraFailAPI_usage_plan" {
  # Drata: Configure [aws_api_gateway_usage_plan.tags] to ensure that organization-wide tagging conventions are followed.
  name = "TerraFailAPI_usage_plan"

  api_stages {
    api_id = aws_api_gateway_rest_api.TerraFailAPI.id
    stage  = aws_api_gateway_stage.TerraFailAPI_stage.stage_name
  }
}

resource "aws_api_gateway_stage" "TerraFailAPI_stage" {
  # Drata: Configure [aws_api_gateway_stage.tags] to ensure that organization-wide tagging conventions are followed.
  # Drata: Configure [aws_api_gateway_stage.access_log_settings] to ensure that security-relevant events are logged to detect malicious activity
  deployment_id = aws_api_gateway_deployment.TerraFailAPI_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.TerraFailAPI.id
  stage_name    = "TerraFailAPI_stage"

  depends_on = [
    aws_api_gateway_account.TerraFailAPI_account
  ]
}

# ---------------------------------------------------------------------
# Lambda
# ---------------------------------------------------------------------
resource "aws_lambda_function" "TerraFailAPI_lambda_function" {
  # Drata: Configure [aws_lambda_function.vpc_config] to improve network monitoring capabilities and ensure network communication is restricted to trusted sources. Exclude this finding if there is a need for your Lambda Function to access external endpoints
  filename      = "${path.module}/foo.zip"
  function_name = "TerraFailAPI_lambda_function"
  role          = aws_iam_role.TerraFailAPI_iam_role.arn

  runtime = "nodejs20"
  handler = "index.test"
}

# ---------------------------------------------------------------------
# IAM
# ---------------------------------------------------------------------
resource "aws_iam_role" "TerraFailAPI_iam_role" {
  # Drata: Configure [aws_iam_role.tags] to ensure that organization-wide tagging conventions are followed.
  name = "TerraFailAPI_iam_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": ["apigateway.amazonaws.com","lambda.amazonaws.com"]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "TerraFailAPI_iam_role_policy" {
  name = "TerraFailAPI_iam_role_policy"
  role = aws_iam_role.TerraFailAPI_iam_role.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:DescribeLogGroups",
                "logs:DescribeLogStreams",
                "logs:PutLogEvents",
                "logs:GetLogEvents",
                "logs:FilterLogEvents"
            ],
            "Resource": "Lambda:InvokeFunction"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "TerraFailAPI_iam_policy_attachment" {
  role       = aws_iam_role.TerraFailAPI_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
}


# ---------------------------------------------------------------------
# CloudWatch
# ---------------------------------------------------------------------
resource "aws_cloudwatch_log_group" "TerraFailAPI_cloudwatch_group" {
  name = "TerraFailAPI_cloudwatch_group"

  tags = {
    Environment = "production"
  }
}
