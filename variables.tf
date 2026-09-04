##-----------------------------------------------------------------------------
## Naming convention
##-----------------------------------------------------------------------------
variable "custom_name" {
  type        = string
  default     = null
  description = "Override default naming convention"
}

variable "resource_position_prefix" {
  type        = bool
  default     = true
  description = <<EOT
Controls the placement of the resource type keyword (e.g., "vnet", "ddospp") in the resource name.

- If true, the keyword is prepended: "vnet-core-dev".
- If false, the keyword is appended: "core-dev-vnet".

This helps maintain naming consistency based on organizational preferences.
EOT
}

##-----------------------------------------------------------------------------
## Labels
##-----------------------------------------------------------------------------
variable "name" {
  type        = string
  default     = "core"
  description = "Name (e.g. `app` or `cluster`)."
}

variable "location" {
  type        = string
  default     = null
  description = "The location/region where the virtual network is created. Changing this forces a new resource to be created."
}

variable "environment" {
  type        = string
  default     = "dev"
  description = "Environment (e.g. `prod`, `dev`, `staging`)."
}

variable "managedby" {
  type        = string
  default     = "terraform-az-modules"
  description = "ManagedBy, eg 'terraform-az-modules'."
}

variable "label_order" {
  type        = list(string)
  default     = ["name", "environment", "location"]
  description = "The order of labels used to construct resource names or tags."
}

variable "repository" {
  type        = string
  default     = "https://github.com/terraform-az-modules/terraform-azure-vmss-agent"
  description = "Terraform current module repo"
  validation {
    condition     = can(regex("^https://", var.repository))
    error_message = "The module-repo value must be a valid Git repo link."
  }
}

variable "deployment_mode" {
  type        = string
  default     = "terraform"
  description = "Specifies how the infrastructure/resource is deployed"
}

variable "extra_tags" {
  type        = map(string)
  default     = null
  description = "Variable to pass extra tags."
}

##-----------------------------------------------------------------------------
## Virtual Machine Scale Set
##-----------------------------------------------------------------------------
variable "enable" {
  type        = bool
  default     = true
  description = "Flag to control the module creation"
}

variable "resource_group_name" {
  type        = string
  default     = null
  description = "The name of the resource group in which to create the virtual network."
}

variable "instances_count" {
  type        = number
  default     = 1
  description = "The number of instances to create in the Virtual Machine Scale Set."
}

variable "computer_name_prefix" {
  type        = string
  default     = "vmss-agent"
  description = "The prefix for the computer name of the virtual machines in the scale set."
}

variable "zones_list" {
  type        = list(string)
  default     = null
  description = "A list of availability zones to spread the virtual machines across."
}

variable "single_placement_group" {
  type        = bool
  default     = true
  description = "Specifies if the scale set should be limited to a single placement group."
}

variable "proximity_placement_group_id" {
  type        = string
  default     = null
  description = "The ID of the proximity placement group to which the scale set should be assigned."
}

variable "admin_username" {
  type        = string
  default     = "ubuntu"
  description = "The administrator username for the virtual machines."
}

variable "disable_password_authentication" {
  type        = bool
  default     = true
  description = "If true, password authentication will be disabled."
}

variable "admin_password" {
  type        = string
  default     = null
  sensitive   = true
  description = "The administrator password for the virtual machines. Required if disable_password_authentication is false."
}

variable "ssh_public_key" {
  type        = string
  default     = null
  description = "The SSH public key to install on the virtual machines. Required if disable_password_authentication is true."
}

variable "source_image_id" {
  type        = string
  default     = null
  description = "The ID of a custom image to use for the virtual machines."
}

variable "source_image_reference" {
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  default = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  description = "Specifies the gallery image to use. Used if source_image_id is null."
}

variable "plan" {
  type = object({
    name      = string
    publisher = string
    product   = string
  })
  default     = null
  description = "Specifies the plan information for a marketplace image."
}

variable "os_disk_caching" {
  type        = string
  default     = "ReadWrite"
  description = "The caching mode for the OS disk."
}

variable "os_disk_managed_disk_type" {
  type        = string
  default     = null
  description = "The type of managed disk for the OS disk."
}

variable "os_disk_size_gb" {
  type        = number
  default     = null
  description = "The size of the OS disk in gigabytes."
}

variable "os_disk_encryption_set_id" {
  type        = string
  default     = null
  description = "The ID of the disk encryption set to use for the OS disk."
}

variable "os_disk_write_accelerator_enabled" {
  type        = bool
  default     = false
  description = "Enable Write Accelerator for the OS disk."
}

variable "os_ephemeral_disk_enabled" {
  type        = bool
  default     = true
  description = "Enable ephemeral OS disk."
}

variable "os_ephemeral_disk_placement" {
  type        = string
  default     = "CacheDisk"
  description = "The placement of the ephemeral OS disk. Can be 'CacheDisk' or 'ResourceDisk'."
}

variable "data_disks" {
  type = list(object({
    lun                       = number
    caching                   = string
    create_option             = string
    disk_size_gb              = number
    storage_account_type      = string
    disk_encryption_set_id    = string
    write_accelerator_enabled = bool
  }))
  default     = []
  description = "A list of data disks to attach to the virtual machines."
}

variable "subnet_id" {
  type        = string
  default     = null
  description = "The ID of the subnet to which the VMSS network interfaces should be connected."
}

variable "network_security_group_id" {
  type        = string
  default     = null
  description = "The ID of the Network Security Group to associate with the network interfaces."
}

variable "dns_servers" {
  type        = list(string)
  default     = null
  description = "A list of DNS servers to use for the network interfaces."
}

variable "load_balancer_backend_address_pool_ids" {
  type        = list(string)
  default     = []
  description = "A list of backend address pool IDs from a Load Balancer to associate with the VMSS."
}

variable "application_gateway_backend_address_pool_ids" {
  type        = list(string)
  default     = []
  description = "A list of backend address pool IDs from an Application Gateway to associate with the VMSS."
}

variable "load_balancer_inbound_nat_rules_ids" {
  type        = list(string)
  default     = []
  description = "A list of inbound NAT rule IDs from a Load Balancer to associate with the VMSS."
}

variable "application_security_group_ids" {
  type        = list(string)
  default     = []
  description = "A list of Application Security Group IDs to associate with the network interfaces."
}

variable "upgrade_mode" {
  type        = string
  default     = "Manual"
  description = "The upgrade mode for the scale set. Can be 'Manual', 'Automatic', or 'Rolling'."
}

variable "overprovision" {
  type        = bool
  default     = false
  description = "Specifies whether to overprovision virtual machines in the scale set."
}

variable "rolling_upgrade_policy" {
  type = object({
    max_batch_instance_percent              = number
    max_unhealthy_instance_percent          = number
    max_unhealthy_upgraded_instance_percent = number
    pause_time_between_batches              = string
  })
  default = {
    max_batch_instance_percent              = 20
    max_unhealthy_instance_percent          = 20
    max_unhealthy_upgraded_instance_percent = 20
    pause_time_between_batches              = "PT0S"
  }
  description = "Configuration for rolling upgrades."
}

variable "automatic_os_upgrade" {
  type        = bool
  default     = false
  description = "Enable automatic OS upgrades."
}

variable "disable_automatic_rollback" {
  type        = bool
  default     = false
  description = "Disable automatic rollback on failed OS upgrade."
}

variable "scale_in_policy" {
  type        = string
  default     = "Default"
  description = "The scale-in policy for the scale set. Can be 'Default', 'NewestVM', or 'OldestVM'."
}

variable "scale_in_force_deletion" {
  type        = bool
  default     = false
  description = "Force the deletion of virtual machines during scale-in operations."
}

variable "priority" {
  type        = string
  default     = null
  description = "The priority for the virtual machines. Can be 'Regular' or 'Spot'."
}

variable "eviction_policy" {
  type        = string
  default     = null
  description = "The eviction policy for Spot instances. Can be 'Deallocate' or 'Delete'."
}

variable "max_bid_price" {
  type        = number
  default     = null
  description = "The maximum price to pay for a Spot instance."
}

variable "spot_restore_enabled" {
  type        = bool
  default     = false
  description = "Enable automatic restore for Spot instances."
}

variable "spot_restore_timeout" {
  type        = string
  default     = "PT30M"
  description = "The timeout for spot restore operations in ISO 8601 format."
}

variable "identity" {
  type = object({
    type         = string
    identity_ids = list(string)
  })
  default     = null
  description = "Managed identity configuration for the scale set."
}

variable "encryption_at_host_enabled" {
  type        = bool
  default     = true
  description = "Enable encryption at the host level."
}

variable "secure_boot_enabled" {
  type        = bool
  default     = false
  description = "Enable secure boot for the virtual machines."
}

variable "vtpm_enabled" {
  type        = bool
  default     = false
  description = "Enable virtual Trusted Platform Module (vTPM)."
}

variable "secrets" {
  type = list(object({
    key_vault_id = string
    url          = string
  }))
  default     = []
  description = "A list of secrets from a Key Vault to install on the virtual machines."
}

variable "custom_data" {
  type        = string
  default     = null
  description = "Base64-encoded custom data to pass to the virtual machines."
}

variable "user_data" {
  type        = string
  default     = null
  description = "Base64-encoded user data for the virtual machines."
}

variable "provision_vm_agent" {
  type        = bool
  default     = true
  description = "Specifies whether to provision the VM agent."
}

variable "extensions" {
  type = list(object({
    name                       = string
    publisher                  = string
    type                       = string
    type_handler_version       = string
    auto_upgrade_minor_version = bool
    force_update_tag           = string
    settings                   = any
    protected_settings         = any
    provision_after_extensions = list(string)
  }))
  default     = []
  description = "A list of extensions to install on the virtual machines."
}

variable "do_not_run_extensions_on_overprovisioned_machines" {
  type        = bool
  default     = false
  description = "If true, extensions will not run on overprovisioned VMs."
}

variable "health_probe_id" {
  type        = string
  default     = null
  description = "The ID of a Load Balancer health probe to use for health checks."
}

variable "zone_balancing_enabled" {
  type        = bool
  default     = false
  description = "Enable zone balancing for the scale set."
}

variable "automatic_instance_repair" {
  type = object({
    enabled      = bool
    grace_period = string
    action       = string
  })
  default     = null
  description = "Configuration for automatic instance repair."
}

variable "edge_zone" {
  type        = string
  default     = null
  description = "Specifies the Edge Zone where the scale set should be created."
}

variable "ultra_ssd_enabled" {
  type        = bool
  default     = false
  description = "Enable Ultra SSD support for the virtual machines."
}

variable "vms_size" {
  type        = string
  default     = "Standard_E2s_v3"
  description = "VM Size for the VMSS Agent"
}
