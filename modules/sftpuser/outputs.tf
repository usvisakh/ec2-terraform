output "sftp_users" {
  value = [for user in aws_transfer_user.main : user.user_name]
}
