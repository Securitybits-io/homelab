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

docker:
  compose:
    ng:
      portainer-agent:
        image: "portainer/agent:latest"
        container_name: "portainer-agent-logging"
        volumes:
          - "/var/run/docker.sock:/var/run/docker.sock"
          - "/var/lib/docker/volumes:/var/lib/docker/volumes"
        ports:
          - "9001:9001"
        restart: always