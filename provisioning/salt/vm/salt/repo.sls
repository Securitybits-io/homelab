Add Salt Repo:
  pkgrepo.managed:
    - humanname: Saltstack Repo
    - name: deb [signed-by=/usr/share/keyrings/salt-archive-keyring.gpg arch=amd64] https://repo.saltproject.io/py3/ubuntu/20.04/amd64/latest focal main
    - file: /etc/apt/sources.list.d/salt.list
    - key_url: https://repo.saltproject.io/py3/ubuntu/20.04/amd64/latest/salt-archive-keyring.gpg
