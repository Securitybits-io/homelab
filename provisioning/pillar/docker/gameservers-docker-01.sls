mounts:
  mounted:
    docker-mount:
      name: /docker/
      device: //10.0.11.241/Securitybits.Systems/Docker
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
        container_name: "portainer-agent-gameservers"
        volumes:
          - "/var/run/docker.sock:/var/run/docker.sock"
          - "/var/lib/docker/volumes:/var/lib/docker/volumes"
        ports:
          - "9001:9001"
        restart: always