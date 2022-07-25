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