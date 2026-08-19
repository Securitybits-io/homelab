# Operational Procedures

This document collects common procedures that cross Terraform, Ansible, Nomad, and service operations.

## Standard Change Flow

1. Check repository status.
2. Identify the owner of the change: `templates/`, `terraform/`, `ansible/`, `jobs/`, or `apps/`.
3. Run the narrowest validation available for that owner.
4. Plan before applying infrastructure or scheduler changes.
5. Apply to one host or one job first when possible.
6. Verify health from the runtime, not only from the tool that made the change.
7. Commit code and documentation together when the operational process changes.

## Repository Status

```bash
git status --short
git diff --stat
```

If unrelated files are already modified, leave them alone unless they are part of the current change.

## Terraform Change Procedure

```bash
cd templates
terraform fmt -check -recursive
terraform validate
terraform plan
```

```bash
cd ../terraform
terraform fmt -check -recursive
terraform validate
terraform plan
```

Only run `apply` after inspecting the relevant plan.

## Ansible Change Procedure

```bash
cd ansible
ansible-inventory -i production --graph
ansible-playbook -i production site.yml --syntax-check --ask-vault-pass
```

For first runs or risky changes, add `--limit <host>`.

## Nomad Job Change Procedure

```bash
nomad job validate jobs/<path>/<job>.nomad.hcl
nomad job plan jobs/<path>/<job>.nomad.hcl
nomad job run jobs/<path>/<job>.nomad.hcl
```

After running a job:

```bash
nomad job status <job>
nomad alloc status <allocation-id>
nomad alloc logs <allocation-id>
```

## VM Replacement Procedure

1. Confirm which Terraform root owns the VM.
2. Create a replacement VM additively.
3. Keep a distinct name, MAC address, and state address during migration.
4. Run Terraform plan and apply only the replacement.
5. Bootstrap SSH access with Ansible.
6. Run the host's Ansible playbook.
7. Migrate application state with an app-specific runbook.
8. Update DNS, DHCP, reverse proxy, monitoring, and Nomad constraints.
9. Power off the old VM and keep it available for rollback.
10. Remove the old VM only after verification.

## Service Rollback Procedure

1. Stop or deregister the failed replacement.
2. Restore DNS, proxy, or service discovery to the previous target.
3. Start the previous VM or previous Nomad job version.
4. Verify service health and logs.
5. Keep automatic cleanup disabled for stateful applications until the old service is confirmed healthy.
6. Document the failed step before attempting the migration again.

## Documentation Update Procedure

Update documentation when any of these change:

- Terraform root ownership
- Terraform Cloud workspace names
- VM migration status
- Inventory groups
- Role ownership
- Nomad variable flow
- Secret source of truth
- Stateful service migration steps
- DNS ownership

Run this before committing documentation-only changes:

```bash
git diff --check
```
