base:
  '*':
    - defaults.enable-color-prompt
    - users
    
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
    - mount-formula
    - docker
    # - promtail-formula.docker
    - docker.ng
    - docker.containers

  # 'media-docker-01':

  # 'mgmt-docker-01':

  # 'offsec-docker-01':

  # 'public-docker-01':