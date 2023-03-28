Install Salt-SSH:
  pkg.latest:
    - name: salt-ssh
    - refresh: True

Refresh pillar:
  module.run:
    - name: saltutil.refresh_pillar
    - refresh: True

#Create Private SSH Key if missing
Generate Salt master Private SSH Key:
  cmd.run:
    - name: ssh-keygen -q -N '' -f /root/.ssh/id_rsa
    - creates: /root/.ssh/id_rsa

#Create public SSH Key if missing
Generate Salt Master Public SSH Key:
  cmd.run: 
    - name: ssh-keygen -y -f /root/.ssh/id_rsa > /root/.ssh/id_rsa.pub
    - creates: /root/.ssh/id_rsa.pub

store id_rsa.pub in SaltMine:
  module.run:
    - name: mine.update