base:
  '*':
    - default.promtail-host
  
  'salt':
    - mine.public-ssh

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

  'ytdl-tactube':
    - youtubedl.ytdl-tactube
  
  'ytdl-youtube':
    - youtubedl.ytdl-youtube