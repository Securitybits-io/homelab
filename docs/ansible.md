# Ansible Provisioning

Ansible configures hosts after Terraform creates them. The main inventory is `ansible/production`, and `ansible/site.yml` imports the primary playbooks.

## Main Entry Points

| File | Purpose |
| --- | --- |
| `ansible/site.yml` | Imports the main host playbooks. |
| `ansible/production` | Static production inventory. |
| `ansible/playbooks/provision-ssh-key.yml` | Initial SSH key provisioning for new hosts. |
| `ansible/nomad.yml` | Configures Nomad servers and clients and deploys job variables. |
| `ansible/playbooks/bootstrap_vault.yml` | Vault bootstrap workflow. |

## Inventory Groups

Important groups in `ansible/production`:

| Group | Purpose |
| --- | --- |
| `nomad_servers` | Nomad server hosts. |
| `nomad_clients` | Nomad client hosts. |
| `consul_servers` | Consul server hosts. |
| `vault_servers` | Vault server hosts. |
| `hashistack` | Combined Nomad, Consul, and Vault inventory. |
| `docker_hosts` | Hosts that run Docker outside or alongside Nomad. |
| `private` | Private network workloads. |

## Bootstrap a New Host

Run this from the Ansible directory:

```bash
cd ansible
ansible-playbook -i production --limit <host> playbooks/provision-ssh-key.yml --ask-vault-pass --user=provision --ask-pass
```

After SSH key provisioning succeeds, run the host playbook:

```bash
ansible-playbook -i production --limit <host> site.yml --ask-vault-pass
```

Use `--limit` for first runs and migrations so unrelated hosts are not changed.

## Configure the Hashistack

```bash
cd ansible
ansible-playbook -i production nomad.yml --ask-vault-pass
```

The Nomad playbook:

- Applies common, CIS, SSH, Docker, Consul, Nomad, and Alloy roles.
- Copies `../jobs` to `/opt/jobs` on Nomad servers.
- Finds `host_vars/nomad/jobs-vars/*.nv.hcl`.
- Copies those files to `/opt/jobs-vars`.
- Runs `nomad var put -force` for each variable file.

## Role Ownership

Keep role responsibilities focused:

| Role | Ownership |
| --- | --- |
| `common` | Base host defaults and common OS settings. |
| `cis` | Security hardening tasks. |
| `ssh` | SSH users, keys, and sudoers. |
| `docker` | Docker repository and runtime installation. |
| `consul` | Consul installation and configuration. |
| `nomad` | Nomad installation, CNI setup, and configuration. |
| `vault` | Vault installation and configuration. |
| `alloy` | Grafana Alloy installation and config. |
| `smb-mount` | SMB mounts for hosts that need network storage. |
| `plex` | Plex-specific package and service management. |

## Debian 13 Notes

Debian 13 enforces externally managed Python environments. Prefer distribution packages and role-managed repositories over system-wide `pip` installs.

For repository roles:

- Install `gpg` before repository setup or cleanup.
- Prefer `/etc/apt/keyrings`.
- Use `{{ ansible_distribution_release }}` instead of Ubuntu-only release names.

## Validation

Recommended checks before broad runs:

```bash
cd ansible
ansible-inventory -i production --graph
ansible-playbook -i production site.yml --syntax-check --ask-vault-pass
```

If Ansible is not installed in the current shell, do not treat `git diff --check` as a replacement for Ansible validation. It only verifies whitespace problems in the Git diff.
