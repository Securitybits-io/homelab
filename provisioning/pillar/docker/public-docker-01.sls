mounts:
  mounted:
    docker-mount:
      name: /backup
      device: //10.0.11.241/Securitybits.Systems/Docker
      fstype: cifs
      mkmnt: True
      config: /etc/fstab
      opts: rw,username=guest,password="",vers=3.0,file_mode=0660,dir_mode=0660
      persist: True
      mount: True
    PiwigoGallery:
      name: /docker/data/piwigo-reference
      device: //10.0.11.241/PlexMedia/Pictures/Reference
      fstype: cifs
      mkmnt: True
      config: /etc/fstab
      opts: rw,username=guest,password="",vers=3.0,file_mode=0777,dir_mode=0777
      persist: True
      mount: True

docker:
  compose:
    ng:
      portainer-agent:
        image: "portainer/agent:latest"
        container_name: "portainer-agent-public"
        volumes:
          - "/var/run/docker.sock:/var/run/docker.sock"
          - "/var/lib/docker/volumes:/var/lib/docker/volumes"
        ports:
          - "9001:9001"
        restart: always