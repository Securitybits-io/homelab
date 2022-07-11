base:
  '*':
    - default.promtail-host
  
  'salt':
    - mine.public-ssh

  'atak-docker-01':
    - default.promtail-docker
    - docker.atak-docker-01
  
  'offsec-docker-01':
    - default.promtail-docker
    - docker.offsec-docker-01