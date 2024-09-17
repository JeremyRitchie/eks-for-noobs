resource "aws_kms_key" "ebs" {
    description             = "KMS key for EBS encryption"
    deletion_window_in_days = 7
    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
        {
            Effect    = "Allow"
            Principal = {
            AWS = "arn:aws:iam::747340109238:root"
            }
            Action    = "kms:*"
            Resource  = "*"
        },
        ]
    })
}

resource "aws_kms_alias" "ebs" {
    name          = "alias/ebs"
    target_key_id = aws_kms_key.ebs.key_id
}