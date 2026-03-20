provider "azurerm" {
  features {}
}

module "vmss-agent" {
  source = "../../"
}
