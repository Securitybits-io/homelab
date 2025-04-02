# Securitybits Homelab
Small Repo for my homelab consisting of Docker and Saltstack

## Overview

### Hardware

### Features

### Tech stack

## Get started

### Apps
Folder with all the Docker applications that are running in my homelab

### Platform
```bash
export PM_API_URL="https://<Proxmox Host>:8006/api2/json"
export PM_USER="ProxmoxUser@pam"
export PM_PASS="ProxmoxPassw0rd!"
export TF_VAR_SSH_USER="provision"
export TF_VAR_SSH_PASS="pass"
secbits:~/ terraform apply
```

### Provisioning
#### Initial provision of the Salt Master
```bash
export SSH_USER="provision"
export SSH_PASS="pass"
salt-ssh salt --user=${SSH_USER} --passwd=${SSH_PASS} -i state.sls vm.salt
```

#### Initial provision of Ansible
```bash
ansible-playbook -i production --limit=ansible playbooks/provision-ssh-key.yml --ask-vault-pass --user=provision --ask-pass
ansible-playbook -i production --limit=ansible site.yml --ask-vault-pass --user=provision --ask-pass
```

### Templates
```bash
export PROXMOX_USERNAME="ProxmoxUser@pam"
export PROXMOX_PASSWORD="ProxmoxPassw0rd!"
export SSH_USER="provision"
export SSH_PASS="pass"
```

## Roadmap

### Tasks
#### Nomad Apps to create
- [ ] lunasea https://www.lunasea.app/
- [x] authelia
- [ ] Kometa
- [ ] PiHole
- [ ] umami https://umami.is/
- [ ] Papertrail-ng
- [x] Reverse Proxy (Traefik)
- [x] Ombi
- [ ] Guacamole
- [ ] Kavitareader
- [ ] plausible.io
- [ ] emulatorjs
- [ ] SocioBoard
- [x] Wazuh
- [x] Immich Photo Backup tool
- [ ] Shlink
- [ ] Taskwarrior
- [ ] Activitywatch https://activitywatch.net/
- [ ] uptime-kuma https://github.com/louislam/uptime-kuma
- [x] Microbin https://hub.docker.com/r/danielszabo99/microbin

### Links
https://www.plexopedia.com/plex-media-server/general/claim-server/#claimservermanually