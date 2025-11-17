provider "azurerm" {
  features {}
}

##-----------------------------------------------------------------------------
## Resource Group module call
## Resource group in which all resources will be deployed.
##-----------------------------------------------------------------------------
module "resource_group" {
  source      = "terraform-az-modules/resource-group/azurerm"
  version     = "1.0.3"
  name        = "core"
  environment = "dev"
  location    = "centralus"
  label_order = ["name", "environment", "location"]
}

# ------------------------------------------------------------------------------
# Virtual Network
# ------------------------------------------------------------------------------
module "vnet" {
  source              = "terraform-az-modules/vnet/azurerm"
  version             = "1.0.3"
  name                = "core"
  environment         = "dev"
  label_order         = ["name", "environment", "location"]
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  address_spaces      = ["10.0.0.0/16"]
}

# ------------------------------------------------------------------------------
# Subnet
# ------------------------------------------------------------------------------
module "subnet" {
  source               = "terraform-az-modules/subnet/azurerm"
  version              = "1.0.1"
  environment          = "dev"
  label_order          = ["name", "environment", "location"]
  resource_group_name  = module.resource_group.resource_group_name
  location             = module.resource_group.resource_group_location
  virtual_network_name = module.vnet.vnet_name
  subnets = [
    {
      name            = "subnet1"
      subnet_prefixes = ["10.0.1.0/24"]
    }
  ]
}

# ------------------------------------------------------------------------------
# VMSS Agent
# ------------------------------------------------------------------------------
module "vmss-agent" {
  source              = "../../"
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  name                = "core"
  environment         = "dev"
  subnet_id           = module.subnet.subnet_ids["subnet1"]
  ssh_public_key      = "ssh-AAA"
  custom_data = base64encode(<<EOF
#cloud-config
packages:
  - curl
  - apt-transport-https
  - gnupg
  - lsb-release
  - unzip
runcmd:
  # Update and install Docker
  - sudo apt-get -y update
  - sudo apt install -y docker.io
  - sudo systemctl start docker
  - sudo systemctl enable docker
  # Set permissions on Docker socket
  - sudo chmod 777 /var/run/docker.sock
  # Install Terraform
  - curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
  - echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list
  - sudo apt-get update && sudo apt-get install -y terraform
  # Install Helm (latest version)
  - curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
  # Install Azure CLI
  - curl -sL https://aka.ms/InstallAzureCLIDeb | bash
  # Install kubectl (latest stable version)
  - curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
EOF
  )
}