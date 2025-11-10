##-----------------------------------------------------------------------------
## Tagging Module – Applies standard tags to all resources
##-----------------------------------------------------------------------------
module "labels" {
  source          = "terraform-az-modules/tags/azurerm"
  version         = "1.0.2"
  name            = var.custom_name != null ? var.custom_name : var.name
  location        = var.location
  environment     = var.environment
  managedby       = var.managedby
  label_order     = var.label_order
  repository      = var.repository
  deployment_mode = var.deployment_mode
  extra_tags      = var.extra_tags
}

##-----------------------------------------------------------------------------
## Azure Linux Virtual Machine Scale Set (VMSS) Resource
##-----------------------------------------------------------------------------
resource "azurerm_linux_virtual_machine_scale_set" "linux_vmss" {
  count                                             = var.enable ? 1 : 0
  name                                              = var.resource_position_prefix ? format("vmss-%s", local.name) : format("%s-vsmss", local.name)
  location                                          = var.location
  resource_group_name                               = var.resource_group_name
  sku                                               = var.vms_size
  instances                                         = var.instances_count
  admin_username                                    = var.admin_username
  disable_password_authentication                   = var.disable_password_authentication
  custom_data                                       = var.custom_data
  admin_password                                    = var.disable_password_authentication ? null : var.admin_password
  tags                                              = module.labels.tags
  upgrade_mode                                      = var.upgrade_mode
  overprovision                                     = var.overprovision
  zone_balance                                      = var.zone_balancing_enabled
  zones                                             = var.zones_list
  source_image_id                                   = var.source_image_id
  computer_name_prefix                              = var.computer_name_prefix
  health_probe_id                                   = var.health_probe_id
  priority                                          = var.priority
  eviction_policy                                   = var.eviction_policy
  max_bid_price                                     = var.max_bid_price
  encryption_at_host_enabled                        = var.encryption_at_host_enabled
  user_data                                         = var.user_data
  provision_vm_agent                                = var.provision_vm_agent
  do_not_run_extensions_on_overprovisioned_machines = var.do_not_run_extensions_on_overprovisioned_machines
  single_placement_group                            = var.single_placement_group
  proximity_placement_group_id                      = var.proximity_placement_group_id
  secure_boot_enabled                               = var.secure_boot_enabled
  vtpm_enabled                                      = var.vtpm_enabled
  edge_zone                                         = var.edge_zone
  dynamic "admin_ssh_key" {
    for_each = var.disable_password_authentication ? [1] : []
    content {
      username   = var.admin_username
      public_key = var.ssh_public_key
    }
  }
  dynamic "source_image_reference" {
    for_each = var.source_image_id == null ? ["enabled"] : []
    content {
      publisher = var.source_image_reference.publisher
      offer     = var.source_image_reference.offer
      sku       = var.source_image_reference.sku
      version   = var.source_image_reference.version
    }
  }
  dynamic "identity" {
    for_each = var.identity[*]
    content {
      type         = var.identity.type
      identity_ids = var.identity.identity_ids
    }
  }
  os_disk {
    caching                   = var.os_ephemeral_disk_enabled ? "ReadOnly" : var.os_disk_caching
    storage_account_type      = var.os_ephemeral_disk_enabled ? "Standard_LRS" : var.os_disk_managed_disk_type
    disk_encryption_set_id    = var.os_disk_encryption_set_id
    disk_size_gb              = var.os_disk_size_gb
    write_accelerator_enabled = var.os_disk_write_accelerator_enabled

    dynamic "diff_disk_settings" {
      for_each = var.os_ephemeral_disk_enabled ? ["enabled"] : []
      content {
        option    = "Local"
        placement = var.os_ephemeral_disk_placement
      }
    }
  }
  network_interface {
    name                          = "${module.labels.id}-nic"
    primary                       = true
    dns_servers                   = var.dns_servers
    enable_ip_forwarding          = var.ip_forwarding_enabled
    enable_accelerated_networking = var.accelerated_networking
    network_security_group_id     = var.network_security_group_id
    ip_configuration {
      name                                         = "${module.labels.id}-ip-config"
      primary                                      = true
      subnet_id                                    = var.subnet_id
      application_gateway_backend_address_pool_ids = var.application_gateway_backend_address_pool_ids
      load_balancer_backend_address_pool_ids       = var.load_balancer_backend_address_pool_ids
      load_balancer_inbound_nat_rules_ids          = var.load_balancer_inbound_nat_rules_ids
      application_security_group_ids               = var.application_security_group_ids
    }
  }
  dynamic "automatic_os_upgrade_policy" {
    for_each = var.upgrade_mode == "Automatic" ? ["enabled"] : []
    content {
      disable_automatic_rollback  = var.disable_automatic_rollback
      enable_automatic_os_upgrade = var.automatic_os_upgrade
    }
  }
  dynamic "automatic_instance_repair" {
    for_each = var.automatic_instance_repair != null && var.automatic_instance_repair.enabled ? ["enabled"] : []
    content {
      enabled      = var.automatic_instance_repair.enabled
      grace_period = var.automatic_instance_repair.grace_period
      action       = var.automatic_instance_repair.action
    }
  }
  dynamic "rolling_upgrade_policy" {
    for_each = var.upgrade_mode != "Manual" ? ["enabled"] : []
    content {
      max_batch_instance_percent              = var.rolling_upgrade_policy.max_batch_instance_percent
      max_unhealthy_instance_percent          = var.rolling_upgrade_policy.max_unhealthy_instance_percent
      max_unhealthy_upgraded_instance_percent = var.rolling_upgrade_policy.max_unhealthy_upgraded_instance_percent
      pause_time_between_batches              = var.rolling_upgrade_policy.pause_time_between_batches
    }
  }
  scale_in {
    rule                   = var.scale_in_policy
    force_deletion_enabled = var.scale_in_force_deletion
  }
  lifecycle {
    ignore_changes = [instances]
  }
  dynamic "extension" {
    for_each = var.extensions
    content {
      name                       = extension.value.name
      publisher                  = extension.value.publisher
      type                       = extension.value.type
      type_handler_version       = extension.value.type_handler_version
      auto_upgrade_minor_version = extension.value.auto_upgrade_minor_version
      force_update_tag           = extension.value.force_update_tag
      protected_settings         = extension.value.protected_settings
      provision_after_extensions = extension.value.provision_after_extensions
      settings                   = extension.value.settings
    }
  }
  dynamic "additional_capabilities" {
    for_each = var.ultra_ssd_enabled ? ["enabled"] : []
    content {
      ultra_ssd_enabled = var.ultra_ssd_enabled
    }
  }
  dynamic "data_disk" {
    for_each = var.data_disks
    content {
      lun                       = data_disk.value.lun
      caching                   = data_disk.value.caching
      create_option             = data_disk.value.create_option
      disk_size_gb              = data_disk.value.disk_size_gb
      storage_account_type      = data_disk.value.storage_account_type
      disk_encryption_set_id    = data_disk.value.disk_encryption_set_id
      write_accelerator_enabled = data_disk.value.write_accelerator_enabled
    }
  }
  dynamic "plan" {
    for_each = var.plan != null ? [1] : []
    content {
      name      = var.plan.name
      publisher = var.plan.publisher
      product   = var.plan.productQ
    }
  }
  dynamic "secret" {
    for_each = var.secrets
    content {
      key_vault_id = secret.value.key_vault_id
      certificate {
        url = secret.value.url
      }
    }
  }
  dynamic "spot_restore" {
    for_each = var.priority == "Spot" && var.spot_restore_enabled ? [1] : []
    content {
      enabled = true
      timeout = var.spot_restore_timeout
    }
  }
}
