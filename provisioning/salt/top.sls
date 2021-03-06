base:
  '*':
    - defaults.enable-color-prompt
    - defaults.user.christoffer
    - promtail-formula.host
    - telegraf-formula

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

  '*-docker-0*':
    - docker
    - promtail-formula.docker
    - docker.containers
    - docker.compose.ng

  'media-docker-01':
    - mount-formula

  'nginx':
    - vm.nginx

  # 'logging-docker-01'
  # 'offsec-docker-01':
  # 'atak-docker-01':
  # 'mgmt-docker-01':
  # 'public-docker-01':

  'ytdl-*':
    - mount-formula
    - youtubedl-formula
    
  'plex':
    - plex-formula
    - mount-formula
