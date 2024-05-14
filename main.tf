provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

locals {
  naming_prefix = "${var.prefix}-${var.environment}"
}

resource "azurerm_resource_group" "main" {
  name     = "${local.naming_prefix}-workshop"
  location = var.location

  tags = {
    environment = "${var.environment}"
  }
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${local.naming_prefix}-vnet"
  location            = azurerm_resource_group.main.location
  address_space       = [var.address_space]
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "${local.naming_prefix}-subnet"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.main.name
  address_prefixes     = [var.subnet_prefix]
}

resource "azurerm_network_security_group" "catapp-sg" {
  name                = "${local.naming_prefix}-sg"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                       = "HTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTPS"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "catapp-nic" {
  name                = "${local.naming_prefix}-catapp-nic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "${local.naming_prefix}ipconfig"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.catapp-pip.id
  }
}

resource "azurerm_network_interface_security_group_association" "catapp-nic-sg-ass" {
  network_interface_id      = azurerm_network_interface.catapp-nic.id
  network_security_group_id = azurerm_network_security_group.catapp-sg.id
}

resource "azurerm_public_ip" "catapp-pip" {
  name                = "${local.naming_prefix}-ip"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
}

resource "azurerm_linux_virtual_machine" "catapp" {
  name                            = "${local.naming_prefix}-meow"
  location                        = azurerm_resource_group.main.location
  resource_group_name             = azurerm_resource_group.main.name
  size                            = var.vm_size
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = false
  network_interface_ids           = [azurerm_network_interface.catapp-nic.id]

  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = "60"

  }

  tags = {}

  custom_data = base64encode(templatefile("${path.module}/templates/setup-web.sh", {
    flask_port     = 80
    admin_username = var.admin_username
    vm_name        = "${local.naming_prefix}-meow"
    project        = var.project
  }))

  # Added to allow destroy to work correctly.
  depends_on = [azurerm_network_interface_security_group_association.catapp-nic-sg-ass]
}


