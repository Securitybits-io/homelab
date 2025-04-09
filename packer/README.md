# homelab-templates
Templates for the Homelab Proxmox server

## packer.securitybits.local
```
$env:PROXMOX_USERNAME="user@pve"
$env:PROXMOX_PASSWORD="Password"
$env:PACKER_USERNAME="packer"
$env:PACKER_PASSWORD="packer-password"

choco install packer jq
packer init .
packer build .
```