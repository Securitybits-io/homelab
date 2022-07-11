base:
  '*':
    - defaults.enable-color-prompt
    - defaults.user.christoffer
    - promtail-formula.host

  '* not salt':
    - defaults.master-ssh

  'salt':
    - vm.salt.dependencies
    - vm.salt.repo
    - vm.salt.master
    - vm.salt.ssh
    - vm.salt.cloud
    - vm.salt.api
    - vm.salt.config

  'offsec-docker-01':
    - docker
    - promtail-formula.docker
    - docker.containers
    - docker.compose.ng

  'atak-docker-01':
    - docker
    - promtail-formula.docker
    - docker.containers
    - docker.compose.ng

  # 'media-docker-01':
  # 'mgmt-docker-01':
  # 'public-docker-01':
