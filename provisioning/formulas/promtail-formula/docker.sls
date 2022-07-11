{% set loki = pillar['loki'] %}

install loki logging plugin:
    cmd.run:
        - name: docker plugin install grafana/loki-docker-driver --alias loki --grant-all-permissions
    require:
        - pkg: docker

{% set host = loki['host'] %}
create daemon json:
    file.managed:
        - name: /etc/docker/daemon.json
        - mode: 0644
        - user: root
        - group: root
        - contents: | 
            {
                "log-driver": "loki",
                "log-opts": {
                    "loki-url": "http://{{ host }}:3100/loki/api/v1/push",
                    "loki-batch-size": "400"
                }
            }

restart docker daemon:
    cmd.run: 
        - name: systemctl restart docker
        - require:
            - create daemon json

sleep 10:
    cmd.run