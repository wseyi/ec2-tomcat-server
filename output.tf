output "tomcat_public_ip" {
  value = aws_instance.tomcat_instance.public_ip
}