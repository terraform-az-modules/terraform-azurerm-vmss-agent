## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| accelerated\_networking | Enable accelerated networking for the network interfaces. | `bool` | `false` | no |
| admin\_password | The administrator password for the virtual machines. Required if disable\_password\_authentication is false. | `string` | `null` | no |
| admin\_username | The administrator username for the virtual machines. | `string` | `"ubuntu"` | no |
| application\_gateway\_backend\_address\_pool\_ids | A list of backend address pool IDs from an Application Gateway to associate with the VMSS. | `list(string)` | `[]` | no |
| application\_security\_group\_ids | A list of Application Security Group IDs to associate with the network interfaces. | `list(string)` | `[]` | no |
| automatic\_instance\_repair | Configuration for automatic instance repair. | <pre>object({<br>    enabled      = bool<br>    grace_period = string<br>    action       = string<br>  })</pre> | `null` | no |
| automatic\_os\_upgrade | Enable automatic OS upgrades. | `bool` | `false` | no |
| computer\_name\_prefix | The prefix for the computer name of the virtual machines in the scale set. | `string` | `"vmss-agent"` | no |
| custom\_data | Base64-encoded custom data to pass to the virtual machines. | `string` | `null` | no |
| custom\_name | Override default naming convention | `string` | `null` | no |
| data\_disks | A list of data disks to attach to the virtual machines. | <pre>list(object({<br>    lun                       = number<br>    caching                   = string<br>    create_option             = string<br>    disk_size_gb              = number<br>    storage_account_type      = string<br>    disk_encryption_set_id    = string<br>    write_accelerator_enabled = bool<br>  }))</pre> | `[]` | no |
| deployment\_mode | Specifies how the infrastructure/resource is deployed | `string` | `"terraform"` | no |
| disable\_automatic\_rollback | Disable automatic rollback on failed OS upgrade. | `bool` | `false` | no |
| disable\_password\_authentication | If true, password authentication will be disabled. | `bool` | `true` | no |
| dns\_servers | A list of DNS servers to use for the network interfaces. | `list(string)` | `null` | no |
| do\_not\_run\_extensions\_on\_overprovisioned\_machines | If true, extensions will not run on overprovisioned VMs. | `bool` | `false` | no |
| edge\_zone | Specifies the Edge Zone where the scale set should be created. | `string` | `null` | no |
| enable | Flag to control the module creation | `bool` | `true` | no |
| encryption\_at\_host\_enabled | Enable encryption at the host level. | `bool` | `true` | no |
| environment | Environment (e.g. `prod`, `dev`, `staging`). | `string` | `"dev"` | no |
| eviction\_policy | The eviction policy for Spot instances. Can be 'Deallocate' or 'Delete'. | `string` | `null` | no |
| extensions | A list of extensions to install on the virtual machines. | <pre>list(object({<br>    name                       = string<br>    publisher                  = string<br>    type                       = string<br>    type_handler_version       = string<br>    auto_upgrade_minor_version = bool<br>    force_update_tag           = string<br>    settings                   = any<br>    protected_settings         = any<br>    provision_after_extensions = list(string)<br>  }))</pre> | `[]` | no |
| extra\_tags | Variable to pass extra tags. | `map(string)` | `null` | no |
| health\_probe\_id | The ID of a Load Balancer health probe to use for health checks. | `string` | `null` | no |
| identity | Managed identity configuration for the scale set. | <pre>object({<br>    type         = string<br>    identity_ids = list(string)<br>  })</pre> | `null` | no |
| instances\_count | The number of instances to create in the Virtual Machine Scale Set. | `number` | `1` | no |
| ip\_forwarding\_enabled | Enable IP forwarding on the network interfaces. | `bool` | `false` | no |
| label\_order | The order of labels used to construct resource names or tags. | `list(string)` | <pre>[<br>  "name",<br>  "environment",<br>  "location"<br>]</pre> | no |
| load\_balancer\_backend\_address\_pool\_ids | A list of backend address pool IDs from a Load Balancer to associate with the VMSS. | `list(string)` | `[]` | no |
| load\_balancer\_inbound\_nat\_rules\_ids | A list of inbound NAT rule IDs from a Load Balancer to associate with the VMSS. | `list(string)` | `[]` | no |
| location | The location/region where the virtual network is created. Changing this forces a new resource to be created. | `string` | `null` | no |
| managedby | ManagedBy, eg 'terraform-az-modules'. | `string` | `"terraform-az-modules"` | no |
| max\_bid\_price | The maximum price to pay for a Spot instance. | `number` | `null` | no |
| name | Name (e.g. `app` or `cluster`). | `string` | `"core"` | no |
| network\_security\_group\_id | The ID of the Network Security Group to associate with the network interfaces. | `string` | `null` | no |
| os\_disk\_caching | The caching mode for the OS disk. | `string` | `"ReadWrite"` | no |
| os\_disk\_encryption\_set\_id | The ID of the disk encryption set to use for the OS disk. | `string` | `null` | no |
| os\_disk\_managed\_disk\_type | The type of managed disk for the OS disk. | `string` | `null` | no |
| os\_disk\_size\_gb | The size of the OS disk in gigabytes. | `number` | `null` | no |
| os\_disk\_write\_accelerator\_enabled | Enable Write Accelerator for the OS disk. | `bool` | `false` | no |
| os\_ephemeral\_disk\_enabled | Enable ephemeral OS disk. | `bool` | `true` | no |
| os\_ephemeral\_disk\_placement | The placement of the ephemeral OS disk. Can be 'CacheDisk' or 'ResourceDisk'. | `string` | `"CacheDisk"` | no |
| overprovision | Specifies whether to overprovision virtual machines in the scale set. | `bool` | `false` | no |
| plan | Specifies the plan information for a marketplace image. | <pre>object({<br>    name      = string<br>    publisher = string<br>    product   = string<br>  })</pre> | `null` | no |
| priority | The priority for the virtual machines. Can be 'Regular' or 'Spot'. | `string` | `null` | no |
| provision\_vm\_agent | Specifies whether to provision the VM agent. | `bool` | `true` | no |
| proximity\_placement\_group\_id | The ID of the proximity placement group to which the scale set should be assigned. | `string` | `null` | no |
| repository | Terraform current module repo | `string` | `"https://github.com/terraform-az-modules/terraform-azure-vmss-agent"` | no |
| resource\_group\_name | The name of the resource group in which to create the virtual network. | `string` | `null` | no |
| resource\_position\_prefix | Controls the placement of the resource type keyword (e.g., "vnet", "ddospp") in the resource name.<br><br>- If true, the keyword is prepended: "vnet-core-dev".<br>- If false, the keyword is appended: "core-dev-vnet".<br><br>This helps maintain naming consistency based on organizational preferences. | `bool` | `true` | no |
| rolling\_upgrade\_policy | Configuration for rolling upgrades. | <pre>object({<br>    max_batch_instance_percent              = number<br>    max_unhealthy_instance_percent          = number<br>    max_unhealthy_upgraded_instance_percent = number<br>    pause_time_between_batches              = string<br>  })</pre> | <pre>{<br>  "max_batch_instance_percent": 20,<br>  "max_unhealthy_instance_percent": 20,<br>  "max_unhealthy_upgraded_instance_percent": 20,<br>  "pause_time_between_batches": "PT0S"<br>}</pre> | no |
| scale\_in\_force\_deletion | Force the deletion of virtual machines during scale-in operations. | `bool` | `false` | no |
| scale\_in\_policy | The scale-in policy for the scale set. Can be 'Default', 'NewestVM', or 'OldestVM'. | `string` | `"Default"` | no |
| secrets | A list of secrets from a Key Vault to install on the virtual machines. | <pre>list(object({<br>    key_vault_id = string<br>    url          = string<br>  }))</pre> | `[]` | no |
| secure\_boot\_enabled | Enable secure boot for the virtual machines. | `bool` | `false` | no |
| single\_placement\_group | Specifies if the scale set should be limited to a single placement group. | `bool` | `true` | no |
| source\_image\_id | The ID of a custom image to use for the virtual machines. | `string` | `null` | no |
| source\_image\_reference | Specifies the gallery image to use. Used if source\_image\_id is null. | <pre>object({<br>    publisher = string<br>    offer     = string<br>    sku       = string<br>    version   = string<br>  })</pre> | <pre>{<br>  "offer": "0001-com-ubuntu-server-jammy",<br>  "publisher": "Canonical",<br>  "sku": "22_04-lts",<br>  "version": "latest"<br>}</pre> | no |
| spot\_restore\_enabled | Enable automatic restore for Spot instances. | `bool` | `false` | no |
| spot\_restore\_timeout | The timeout for spot restore operations in ISO 8601 format. | `string` | `"PT30M"` | no |
| ssh\_public\_key | The SSH public key to install on the virtual machines. Required if disable\_password\_authentication is true. | `string` | `null` | no |
| subnet\_id | The ID of the subnet to which the VMSS network interfaces should be connected. | `string` | `null` | no |
| ultra\_ssd\_enabled | Enable Ultra SSD support for the virtual machines. | `bool` | `false` | no |
| upgrade\_mode | The upgrade mode for the scale set. Can be 'Manual', 'Automatic', or 'Rolling'. | `string` | `"Manual"` | no |
| user\_data | Base64-encoded user data for the virtual machines. | `string` | `null` | no |
| vms\_size | VM Size for the VMSS Agent | `string` | `"Standard_E2s_v3"` | no |
| vtpm\_enabled | Enable virtual Trusted Platform Module (vTPM). | `bool` | `false` | no |
| zone\_balancing\_enabled | Enable zone balancing for the scale set. | `bool` | `false` | no |
| zones\_list | A list of availability zones to spread the virtual machines across. | `list(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| vmss\_id | The ID of the Linux Virtual Machine Scale Set. |
| vmss\_name | The name of the Linux Virtual Machine Scale Set. |
| vmss\_object | The full object of the Linux Virtual Machine Scale Set resource. |
| vmss\_system\_assigned\_identity\_principal\_id | The Principal ID for the System-Assigned Managed Identity of the VMSS. Returns null if a different identity type is used. |
| vmss\_system\_assigned\_identity\_tenant\_id | The Tenant ID for the System-Assigned Managed Identity of the VMSS. Returns null if a different identity type is used. |
| vmss\_unique\_id | The unique ID of the Linux Virtual Machine Scale Set. |

