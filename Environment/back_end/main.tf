module "azurerm_resource_group" {
  source                  = "../../Modules/azurerm_resource_group"
  resource_group_name     = "todo_app_rg"
  resource_group_location = "West US"
}

module "azurerm_virtual_network" {
  depends_on           = [module.azurerm_resource_group]
  source               = "../../Modules/azurerm_virtual_network"
  virtual_network_name = "todoapp_vnet"
  address_space        = ["10.0.0.0/16"]
  location             = "West US"
  resource_group_name  = "todo_app_rg"
}



module "azurerm_backend_subnet" {
  depends_on           = [module.azurerm_virtual_network]
  source               = "../../Modules/azurerm_subnet"
  subnet_name          = "backend-subnet"
  resource_group_name  = "todo_app_rg"
  virtual_network_name = "todoapp_vnet"
  address_prefixes     = ["10.0.2.0/24"]
}



module "backend_public_ip" {
  depends_on          = [module.azurerm_virtual_network]
  source              = "../../Modules/azurerm_public_ip"
  pip_name            = "backend_pip"
  resource_group_name = "todo_app_rg"
  location            = "West US"
}


module "backend_vm" {
  depends_on = [module.azurerm_backend_subnet, module.backend_public_ip, module.azurerm_virtual_network, module.azurerm_resource_group]
  source     = "../../Modules/azurerm_virtual_machine"

  network_interface_name = "backend_nic"
  location               = "West US"
  resource_group_name    = "todo_app_rg"
  ip_name                = "backend_ip"
  virtual_machine_name   = "todoBackendVM"
  subnet_name            = "backend-subnet"
  virtual_network_name   = "todoapp_vnet"
  public_ip_name         = "backend_pip"
  admin_username         = "testadmin"
  admin_password         = "Password@1234"
  image_publisher        = "Canonical"
  image_offer            = "0001-com-ubuntu-server-focal"
  image_sku              = "20_04-lts"
  image_version          = "latest"

}
