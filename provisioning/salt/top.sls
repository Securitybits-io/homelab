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

  'atak-docker-01':
    - docker
    - promtail-formula.docker
    - docker.containers
    - docker.compose.ng

  # 'media-docker-01':
    # - docker
    # - promtail-formula.docker
    # - docker.containers
    # - docker.compose.ng

  # 'mgmt-docker-01':
    # - docker
    # - promtail-formula.docker
    # - docker.containers
    # - docker.compose.ng

  # 'offsec-docker-01':
    # - docker
    # - promtail-formula.docker
    # - docker.containers
    # - docker.compose.ng

  # 'public-docker-01':
    # - docker
    # - promtail-formula.docker
    # - docker.containers
    # - docker.compose.ng