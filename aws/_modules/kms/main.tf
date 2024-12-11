

# ---------------------------------------------------------------------
# KMS
# ---------------------------------------------------------------------
resource "aws_kms_alias" "TerraFailKMS_alias" {
  name          = "alias/TerraFailKMS_alias"
  target_key_id = aws_kms_key.TerraFailKMS_key.key_id
}

resource "aws_kms_key" "TerraFailKMS_key" {
  # Drata: Configure [aws_kms_key.tags] to ensure that organization-wide tagging conventions are followed.
  description             = "KMS key template"
  deletion_window_in_days = 10
  key_usage               = "ENCRYPT_DECRYPT"
  enable_key_rotation     = false
  is_enabled              = false

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Describe the policy statement",
      "Effect": "Allow",
      "Principal": "user@terrafail.com",
      "Action": "KMS:ListKeys",
      "Resource": "KMS:*",
      "Condition": {
        "StringEquals": {
          "kms:KeySpec": "SYMMETRIC_DEFAULT"
        }
      }
    }
  ]
}
EOF
}
