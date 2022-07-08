# homelab
Small Repo for my homelab consisting of Docker and Saltstack


## Provisioning
### Initial provision of the Salt Master
```bash
export SSH_USER="user"
export SSH_PASS="pass"
salt-ssh salt-bak --user=${SSH_USER} --passwd=${SSH_PASS} -i state.apply
```