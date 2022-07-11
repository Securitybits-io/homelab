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
- [ ] Ombi
- [ ] Arma3 Server with automatic modlist download
- [ ] Git Server (Gitlab/Gitea)
- [ ] Git Runners
- [ ] Youtube-DL with recurring downloads
- [ ] Guacamole

#### Migrate form VMware to Proxmox
- [ ] Dockers
  - [ ] Mgmt Docker
  - [ ] Public Docker
  - [x] Offsec Docker
  - [ ] Media Docker
  - [ ] Logging Docker
  - [x] ATAK Docker
  - [ ] Gameserver Docker  
- [ ] Youtube-DL
- [x] Salt-Master  
- [ ] Plex
- [ ] Ombi
- [ ] Nginx
- [ ] IPam

- [ ] Windows
  - [ ] Cloud Backup
  - [ ] Arma Server

#### Homelab Tasks
- [ ] Migrate deprecated Saltstack to Private Github
- [ ] Sunset Gitlab
  - [ ] Move active projects to Github
- [ ] Saltstack
  - [ ] Formulas
    - [x] Create state to copy public SSH key to all minions
    - [ ] Set Correct Timezone and NTP Server
    - [x] Mount CIFS Share
    - [ ] CIS Benchmarks
    - [ ] Git runners Docker-in-Docker
    - [ ] Plex installer
    - [x] Promtail Logging Binary installer
    - [ ] Telegraf State for hosts
    - [ ] Youtube-DL State formula
    - [ ] Reverse Proxy formula