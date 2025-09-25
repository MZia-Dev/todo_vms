module "azurerm_resource_group" {
  source                  = "../../Modules/azurerm_resource_group"
  for_each = var.rgs
  resource_group_name     = each.value.name
  resource_group_location = each.value.location
}

module "azurerm_virtual_network" {
  depends_on           = [module.azurerm_resource_group]
  source               = "../../Modules/azurerm_virtual_network"
  virtual_network_name = "todoapp_vnet"
  address_space        = ["10.0.0.0/16"]
  location             = "West US"
  resource_group_name  = "todo_app_rg"
}

module "azurerm_frontend_subnet" {
  depends_on           = [module.azurerm_virtual_network]
  source               = "../../Modules/azurerm_subnet"
  subnet_name          = "frontend-subnet"
  resource_group_name  = "todo_app_rg"
  virtual_network_name = "todoapp_vnet"
  address_prefixes     = ["10.0.1.0/24"]

}


module "frontend_public_ip" {
  depends_on          = [module.azurerm_virtual_network]
  source              = "../../Modules/azurerm_public_ip"
  pip_name            = "frontend_pip"
  resource_group_name = "todo_app_rg"
  location            = "West US"
}


module "backend_vm" {
  depends_on = [module.azurerm_frontend_subnet, module.frontend_public_ip, module.azurerm_virtual_network, module.azurerm_resource_group]
  source     = "../../Modules/azurerm_virtual_machine"
  network_interface_name = "frontend_nic"
  location               = "West US"
  resource_group_name    = "todo_app_rg"
  ip_name                = "frontend_ip"
  virtual_machine_name   = "todoFrontendVM"
  subnet_name            = "frontend-subnet"
  virtual_network_name   = "todoapp_vnet"
  public_ip_name         = "frontend_pip"
  admin_username         = "testadmin"
  admin_password         = "Password@1234"
  image_publisher        = "Canonical"
  image_offer            = "ubuntu-24_04-lts"
  image_sku              = "ubuntu-pro-gen1"
  image_version          = "latest"

}
