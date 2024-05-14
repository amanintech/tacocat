# Outputs file
output "catapp_ip" {
  value = "http://${azurerm_public_ip.catapp-pip.ip_address}"
}

