base:
  '*':
    - default.promtail-host
    - default.telegraf
  
  'salt':
    - mine.public-ssh
  
  'plex':
    - media.plex

  '*-docker-0*':
    - default.promtail-docker

  'atak-docker-01':
    - docker.atak-docker-01
  
  'offsec-docker-01':
    - docker.offsec-docker-01

  'media-docker-01':
    - docker.media-docker-01

  'mgmt-docker-01':
    - docker.mgmt-docker-01

  'logging-docker-01':
    - docker.logging-docker-01

  'public-docker-01':
    - docker.public-docker-01

  'gameservers-docker-01':
    - docker.gameservers-docker-01

  'ytdl-tactube':
    - media.tactube
  
  'ytdl-youtube':
    - media.youtube