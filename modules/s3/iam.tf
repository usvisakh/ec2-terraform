resource "aws_iam_role" "replication" {
  count = var.enable_riplica ? 1 : 0
  name  = "s3-bucket-replication-${random_pet.this.id}"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "s3ReplicationAssume",
      "Effect": "Allow",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
  tags = merge(local.common_tags,
    {
      Name = "s3-bucket-replication-${random_pet.this.id}"
    },
  )

}

resource "aws_iam_policy" "replication" {
  count = var.enable_riplica ? 1 : 0
  name  = "s3-bucket-replication-${random_pet.this.id}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetReplicationConfiguration",
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::${local.bucket_name}"
      ]
    },
    {
      "Action": [
        "s3:GetObjectVersion",
        "s3:GetObjectVersionForReplication",
        "s3:GetObjectVersionAcl"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::${local.bucket_name}/*"
      ]
    },
    {
      "Action": [
        "s3:ReplicateObject",
        "s3:ReplicateDelete",
        "s3:ObjectOwnerOverrideToBucketOwner"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${local.destination_bucket_name}/*"
    },
    {
      "Action": [
        "kms:Decrypt"
      ],
      "Effect": "Allow",
      "Condition": {
        "StringLike": {
          "kms:ViaService": "s3.${data.aws_region.current-region.name}.amazonaws.com",
          "kms:EncryptionContext:aws:s3:arn": [
            "arn:aws:s3:::${local.bucket_name}/*"
          ]
        }
      },
      "Resource": [
        "${data.aws_kms_alias.origin.target_key_arn}"
      ]
    },
    {
      "Action": [
        "kms:Encrypt"
      ],
      "Effect": "Allow",
      "Condition": {
        "StringLike": {
          "kms:ViaService": "s3.${local.replica_region}.amazonaws.com",
          "kms:EncryptionContext:aws:s3:arn": [
            "arn:aws:s3:::${local.destination_bucket_name}/*"
          ]
        }
      },
      "Resource": [
        "${data.aws_kms_alias.replica.target_key_arn}"
      ]
    }
  ]
}
POLICY
  tags = merge(local.common_tags,
    {
      Name = "s3-bucket-replication-${random_pet.this.id}"
    },
  )
}




resource "aws_iam_policy_attachment" "replication" {
  count      = var.enable_riplica ? 1 : 0
  name       = "s3-bucket-replication-${random_pet.this.id}"
  roles      = [aws_iam_role.replication[count.index].name]
  policy_arn = aws_iam_policy.replication[count.index].arn
}