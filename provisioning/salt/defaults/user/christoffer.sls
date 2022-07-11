user_christoffer:
  group.present:
    - name: christoffer
    - gid: 4001

  user.present:
    - name: christoffer
    - fullname: Christoffer Claesson
    - shell: /bin/bash
    - uid: 4001
    - gid: 4001
    - empty_password: True
    - optional_groups:
      - sudo
    - require:
      - group: user_christoffer

  file.directory:
    - name: /home/christoffer
    - user: christoffer
    - group: christoffer
    - mode: 0751
    - makedirs: True

user_christoffer_forward:
  file.append:
    - name: /home/christoffer/.forward
    - text: Christoffer.Claesson@Securitybits.io

user_christoffer_sshdir:
  file.directory:
    - name: /home/christoffer/.ssh
    - user: christoffer
    - group: christoffer
    - mode: 0700

user_christoffer_authkeys:
  ssh_auth.present:
    - user: christoffer
    - names:
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDdECr4+uozDDtb/XZqbyJrHSWAMzvu7f2bF519OD6FGbv/N/qcTahVmaoR31AkKwb+sryCfx3ueaRre3WcVp7cb5TBG3sg00qdCuFCNIgMS9Bt5C6FHTx/ip418G/Edpkvwb22/0d6HqMALs1hDcOFlGlmzaSxkymN6LK6JYjUouyw0piIimbISJ3oRs7JtwB65bzthNIbOSpnYWxrNQrxWETSThbYqCOWTdG9KzWTZ7PCrLd5913FIQxynjhEqDpIdmUfhH6VjsGrQiwdAisXnkIKac2tWdhg46GKNfPpbjTa8JU+nXgsFXcBa69gGTZbG3nXk4PbdJ3xh2oSOIHmDeTfdpa6chfrWucRNmWcrOiGQkke67bGvo+Cbv0YylrwLxegfM9j6X2n4flRW4L4c4Ik3pEUAq/YkqVevlvZJPUOQYdsHkk2/ceI+D0oSuirtnFNA+qbLhWn6tiWid9d/UGvL2TMORPmw/U7+z6KvWR/3gQH1wqmDATdAPPLULk= christoffer@Christoffer-WSL
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDig3C10F6R2uEIwWF5c5IHf+oOZbQ10PVkGArm8UaW1BdqVlpF8HEv1zEQ5rNQbmDL10IHk1cm6jWBh0OPg/JYY1/WbDPzwwIA3hUFsGrztAbXsO0ohZ/N+muwPEU5LqCvMXQSHol5TygxPMdBED84M9+Nc0XFzhqzkmMSLC6LM7DIocEHJLpOGxwveaTm0JHa1115jVAL0tEtCYHYElQZ++BK/gY3PuO9Yc81+FllxdFJU/GMcqucVTQMdK/ADG3/hq2+LO9s/f3koT718bpAvJP/JJH7qQaPHpKSMVlyW4ZjX3W4/cT3sR4QY9DU6S/PpAXuSQrmJ0N3DHvpTY3d christoffer@Desktop

user_christoffer_sudoers:
  file.managed:
    - name: /etc/sudoers.d/christoffer
    - contents: 'christoffer ALL=(ALL) NOPASSWD:ALL'
    - mode: 0440
    - user: root
    - group: root
    - require: 
      - user_christoffer
