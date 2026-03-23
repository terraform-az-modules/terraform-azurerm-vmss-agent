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
  version             = "1.0.4"
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
  ssh_public_key      = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCrLYo7b+IBzOLRJtxS+PTZxLFojNS6fHzGm6a1Ldzo/NHccHo9Dnd1TOesoCiK5VytgutPUKbZ+7kvz0v1MbKWQhP6f4XuQi/Acq14TJIQ5HFl1lk9S0v0HsrAzWKr4hSnGI+FmYO+/sFy/swlV4TNEAfNqJDlD7SEeuiKFtx58u04Sctvr3X1hJ6ZXmAv/9/AYbhyPIP91Bu38ANwThqahHz7SuD7vyhT1986WnxYplAyqH21rJo59BXlcaoFtsP6VZ7+IkIZCp9KERolvi/Uq8pP48HCYjT3JRPMAc+9lGJHGmcdJwFmZgDLZvcEGfqu/hPCwXCAeRFjqgq6gT/mUJoxHU96ifkFA+tuF2n3h6gOZsk3oUpUqVTWVBySJ0m0yTyo8U9sjsA83QxR8oEwHT7EmKKVkiHah2WCi0/U7yS9i64LQd+PxdJ8vCGei/mbX3vZjdz8d1QK8X2oDSBr0FlY6Ffb/SfY6e9KpgMWdllA4R17f+9MHAVuj7Upg8sAY19zWcUSOQIuQlNIIQJ7j6a6PxqcnIVPvOg1gWsVMORZdOm6HNA9S+oGZXRtSy4Oyny7uh41CjvSfv2fqw2C6uALEyDx+Mqb6pbfS8J+DSUkotdKI6NcduxRNglzH11adjCxstxQGjDw/SZU6r1Du10ftbPknmyC4+AbSZUZBw== terraform@vm"
  # user should add their own ssh public key
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
