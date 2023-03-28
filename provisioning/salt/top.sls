base:
  '*':
    - defaults.enable-color-prompt
    - defaults.user.christoffer
    - defaults.timezone
    #- defaults.wazuh-agent
    - defaults.cis
    #- promtail-formula.host
    #- telegraf-formula

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

  'media-docker-01':
    - mount-formula

  'gameservers-docker-01':
    - mount-formula

  '*-docker-0*':
    - docker
    #- promtail-formula.docker
    - docker.containers
    - docker.compose.ng

  'nginx':
    - vm.nginx
    
  'plex':
    - plex-formula
    - mount-formula

  'ytdl-*':
    - youtubedl-formula
    - mount-formula

  'takserver':
    - docker