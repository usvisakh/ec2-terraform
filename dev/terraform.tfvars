region              = "us-west-2"
environment         = "visakh-test"
bucket_name         = "visakh-jenkins-sftp"
log_bucket_name     = "visakh-jenkins-sftp-logs"
enable_versioning   = false
enable_logging      = true
sftp_server_name    = "visakh-sftp-server"
sftp_user_role_name = "sftp-role-viskh-test"

sftp_users_with_keys = [
  {
    user    = "visakh"
    pub_key = ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDi4bOnlTpp7dOoKKREtw356HBw07D5UkogppZ4LxEUiIfWX0X+HGzOz0c9NntwSq0pf6it+ikGjUC9au5HZmxKfYg5SWzP1i5tFy2GvXBqD3kDF/W/9djEsb5uld2PEobnTSQZwp9ym1jmlvyNMkvGrh+9dA4GRCeoCe1DTBvB2yWATUcaaN6Kpjm6Vns/jSW9rdOSjNoVPdL58NkpVVY91G5ZnNOZk8fjkDwQW7HRb5Lw9MDEFX8suXadKWW6XKPlyXnyeVMlE/8NIhSyCAOitDEGI304AJQYT1/rmWAl/A58wNdAPF4laBq8nlcLiIpfuCJ4ULF7xqrDg7jW8J84zbwRtGW75jzujzmhA36old5AdRUirl8h446To1iXGgJ+lc3RN6VVk295Vai0Do+GqI5EGqMihnEZcWEc0nzN9DYmk5YqqYMEFUzVaWoWjhxkiCfyPV6dSlyscdKoyBrpUT77a0OyX5vwGEp+qsFD7o/srdnPxIUC0TJ1qzwGuxM= root@DESKTOP-H56CL44"]
  },
  {
    user    = "shyam"
    pub_key = ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDhoPKHVGIdLm6HtBiLpYdl/JDuMoKyFUJi25/tBd6eBBOwZBjsA1BP+3lVdji6yOfZ0Z+A1OjIuUwlzbVKYp/MdCkgNgySIalDQa1L6OAiSiNzWr3kEfczTNCo1VPyqtXmaaUdPNx/pDJOzbTXUDah5qzp9palW1Frx+303258QNT3RhFk3NaQe13BWjiLy21sMww88EKeAzBxwSPVwVP5b8w7wpR0Rz320lgsaJeNrDhAJap7kVSS+SN0XsSvqazAhUfzbCTWWTbJQnQQAdneTmrG/EZ1I4IbaqHOEShlSdshswCWVmNNl33CmVEvYFts04/cyZK0rG9wucKIWBwYf3EB0FCiCK4tqr7aUHySGr6Vdz6KB7+QgOFUQ8pPv7MV8jnfea/xaqfJMSJyIUnWbQoy+NAM01sPOGcWznRbM642zRZUAgwQWr10U2QoB4coE4DqQUg1b6rzxwGjDflBAVhUot4qRCXItkoS0Pxp8xFkLZmqfnurLu3bzfYhMXc= bryce@Bryce-Desktop"]
  },
]
