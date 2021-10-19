output "sftp_server_id" {
  value = aws_transfer_server.main.id
}

output "transfer_server_endpoint" {
  value = aws_transfer_server.main.endpoint
}
