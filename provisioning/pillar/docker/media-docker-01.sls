mounts:
  mounted:
    docker-mount:
      name: /backup
      device: //10.0.11.241/Securitybits.Systems/Docker
      fstype: cifs
      mkmnt: True         # Default is False, True used for testing
      config: /etc/fstab
      opts: rw,guest,vers=3.0,file_mode=0660,dir_mode=0660
      persist: True
      mount: True
    RadarrMovies:
      name: /docker/mnt/Movies
      device: //10.0.11.241/PlexMedia/Movies
      fstype: cifs
      mkmnt: True
      config: /etc/fstab
      opts: rw,guest,vers=3.0,file_mode=0777,dir_mode=0777
      persist: True
      mount: True
    downloads:
      name: /docker/mnt/downloads
      device: //10.0.11.241/PlexMedia/Downloads
      fstype: cifs
      mkmnt: True
      config: /etc/fstab
      opts: rw,guest,vers=3.0,file_mode=0777,dir_mode=0777
      persist: True
      mount: True
    radarr-backup:
      name: /docker/backup/radarr
      device: //10.0.11.241/Securitybits.Systems/Radarr
      fstype: cifs
      mkmnt: True         # Default is False, True used for testing
      config: /etc/fstab
      opts: rw,guest,vers=3.0,file_mode=0777,dir_mode=0777,nounix,uid=1000
      persist: True
      mount: True
    SonarrSeries:
      name: /docker/mnt/Series
      device: //10.0.11.241/PlexMedia/Series
      fstype: cifs
      mkmnt: True
      config: /etc/fstab
      opts: rw,guest,vers=3.0,file_mode=0777,dir_mode=0777
      persist: True
      mount: True
    sonarr-backup:
      name: /docker/backup/sonarr
      device: //10.0.11.241/Securitybits.Systems/Sonarr
      fstype: cifs
      mkmnt: True         # Default is False, True used for testing
      config: /etc/fstab
      opts: rw,guest,vers=3.0,file_mode=0777,dir_mode=0777,nounix,uid=1000
      persist: True
      mount: True
    ReadarrBooks:
      name: /docker/mnt/Books
      device: //10.0.11.241/PlexMedia/Books
      fstype: cifs
      mkmnt: True
      config: /etc/fstab
      opts: rw,guest,vers=3.0,file_mode=0777,dir_mode=0777
      persist: True
      mount: True
    YoutubeTactube:
      name: /docker/mnt/Tactube
      device: //10.0.11.241/PlexMedia/Youtube-DL/TacTube
      fstype: cifs
      mkmnt: True
      config: /etc/fstab
      opts: rw,guest,vers=3.0,file_mode=0777,dir_mode=0777
      persist: True
      mount: True
    Youtube:
      name: /docker/mnt/Youtube
      device: //10.0.11.241/PlexMedia/Youtube-DL/Youtube
      fstype: cifs
      mkmnt: True
      config: /etc/fstab
      opts: rw,guest,vers=3.0,file_mode=0777,dir_mode=0777
      persist: True
      mount: True

    readarr-backup:
      name: /docker/backup/readarr
      device: //10.0.11.241/Securitybits.Systems/Readarr
      fstype: cifs
      mkmnt: True         # Default is False, True used for testing
      config: /etc/fstab
      opts: rw,guest,vers=3.0,file_mode=0777,dir_mode=0777,nounix,uid=1000
      persist: True
      mount: True
    prowlarr-backup:
      name: /docker/backup/prowlarr
      device: //10.0.11.241/Securitybits.Systems/Prowlarr
      fstype: cifs
      mkmnt: True         # Default is False, True used for testing
      config: /etc/fstab
      opts: rw,guest,vers=3.0,file_mode=0777,dir_mode=0777,nounix,uid=1000
      persist: True
      mount: True
    bazarr-backup:
      name: /docker/backup/bazarr
      device: //10.0.11.241/Securitybits.Systems/Bazarr
      fstype: cifs
      mkmnt: True         # Default is False, True used for testing
      config: /etc/fstab
      opts: rw,guest,vers=3.0,file_mode=0777,dir_mode=0777,nounix,uid=1000
      persist: True
      mount: True
    tautulli backup:
      name: /docker/backup/tautulli
      device: //10.0.11.241/Securitybits.Systems/Tautulli
      fstype: cifs
      mkmnt: True         # Default is False, True used for testing
      config: /etc/fstab
      opts: rw,guest,vers=3.0,file_mode=0777,dir_mode=0777,nounix,uid=998
      persist: True
      mount: True


docker:
  compose:
    ng:
      portainer-agent:
        image: "portainer/agent:latest"
        container_name: "portainer-agent-04"
        volumes:
          - "/var/run/docker.sock:/var/run/docker.sock"
          - "/var/lib/docker/volumes:/var/lib/docker/volumes"
        ports:
          - "9001:9001"
        restart: always