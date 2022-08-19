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

docker:
  compose:
    ng:
      portainer:
        image: "portainer/portainer-ce:latest"
        container_name: "portainer-private"
        volumes:
          - "/docker/portainer_data/data:/data"
          - "/var/run/docker.sock:/var/run/docker.sock"
        ports:
          - "8000:8000"
          - "9000:9000"
        restart: always
      portainer-agent:
        image: "portainer/agent:latest"
        container_name: "portainer-agent-01"
        volumes:
          - "/var/run/docker.sock:/var/run/docker.sock"
          - "/var/lib/docker/volumes:/var/lib/docker/volumes"
        ports:
          - "9001:9001"
        restart: always
