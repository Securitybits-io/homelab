# Terraform Lifecycle

This repository has two Terraform roots with different ownership boundaries. Keep them separate.

## Roots and Workspaces

| Root | Workspace | Purpose |
| --- | --- | --- |
| `templates/` | Terraform Cloud workspace `templates` | Builds the Debian 13 image import, cloud-init snippet, and Proxmox template VM. |
| `terraform/` | Terraform Cloud workspace `infrastructure` | Builds workload VMs and Namecheap DNS records. |

## Environment Variables

Set credentials outside the repository. Use your shell, Terraform Cloud variables, or a secret manager.

```bash
export PROXMOX_VE_ENDPOINT="https://<proxmox-host>:8006/"
export PROXMOX_VE_USERNAME="<user>@pam"
export PROXMOX_VE_PASSWORD="<password>"
export PM_API_URL="https://<proxmox-host>:8006/api2/json"
export PM_USER="<user>@pam"
export PM_PASS="<password>"
export TF_VAR_namecheap_username="<namecheap-username>"
export TF_VAR_namecheap_api_user="<namecheap-api-user>"
export TF_VAR_namecheap_api_key="<namecheap-api-key>"
```

Only set variables that are required by the root you are running.

## Template Workflow

Use this when changing the Debian image, cloud-init template, or Proxmox VM template settings.

```bash
cd templates
terraform init
terraform fmt -check -recursive
terraform validate
terraform plan
terraform apply
```

The template must remain generic:

- Do not bake hostnames into the template.
- Do not bake service-specific packages into the template.
- Do not use application-specific storage mounts in template cloud-init.
- Keep it limited to SSH and Ansible-ready bootstrapping.

## Workload Workflow

Use this when changing workload VMs or DNS.

```bash
cd terraform
terraform init
terraform fmt -check -recursive
terraform validate
terraform plan
terraform apply
```

The workload root is in a mixed migration state:

- New Hashistack resources use `proxmox_virtual_environment_vm` with `provider = bpg-proxmox`.
- Older resources still use Telmate `proxmox_vm_qemu`.
- DNS records are managed with the Namecheap provider.

## Debian 13 VM Pattern

New Debian VMs should clone template VM ID `9000` and keep per-VM values in locals or maps:

- name
- CPU cores
- memory
- disk size
- VLAN ID
- MAC address
- description
- tags

When several VMs only differ by data, prefer a single resource with `for_each` over repeated resource blocks.

## Migration Procedure for Legacy VMs

Use additive migration. Do not replace state in place unless you have a deliberate rollback plan.

1. Confirm the current legacy VM resource and state address.
2. Add a new Debian 13 replacement resource with a distinct name, MAC, and host identity.
3. Run `terraform plan` and confirm no unrelated changes appear.
4. Apply only the additive replacement.
5. Provision the new VM with Ansible.
6. Migrate application data using an app-specific runbook.
7. Update DNS, DHCP, reverse proxy, monitoring, and Nomad constraints as needed.
8. Leave the old VM powered off but available for rollback.
9. Remove the old Terraform resource only after the replacement has survived a normal maintenance cycle.

## DNS Change Procedure

`terraform/dns.tf` manages `securitybits.io` with Namecheap `mode = "OVERWRITE"`.

Before changing DNS:

1. Export or screenshot the current Namecheap records.
2. Compare every live record with `terraform/dns.tf`.
3. Add any externally required record to Terraform before applying.
4. Run `terraform plan` and inspect all DNS record changes.
5. Apply only when the desired record set is complete.

## Validation Boundaries

`terraform fmt -check` and `terraform validate` check syntax and provider configuration. They do not prove that a Proxmox apply is safe or that a VM boots correctly. Always inspect the plan and verify the resulting VM through Proxmox, SSH, and Ansible.
