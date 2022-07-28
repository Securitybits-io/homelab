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

### Templates
```bash
export PROXMOX_USERNAME="ProxmoxUser@pam"
export PROXMOX_PASSWORD="ProxmoxPassw0rd!"
export SSH_USER="provision"
export SSH_PASS="pass"
```

## Roadmap

### Tasks
#### Docker Apps to create
- [ ] Firefly Management
- [ ] Papertrail-ng
- [ ] IPAM / Netbox
- [ ] Reverse Proxy (Nginx/Traefik)
- [x] Ombi
- [ ] Arma3 Server with automatic modlist download
- [ ] Git Server (Gitlab/Gitea)
- [ ] Git Runners (Drone?)
- [ ] Guacamole
- [ ] Kavitareader
- [ ] plausible.io
- [ ] emulatorjs
- [ ] Tdarr
- [ ] Wazuh

#### Homelab Tasks
- [ ] Saltstack
  - [ ] Formulas
    - [x] Set Correct Timezone and NTP Server
    - [ ] CIS Benchmarks
    - [ ] Git runners Docker-in-Docker
- [x] Add Telegraf Proxmox Plugin
- [ ] Create Windows templating