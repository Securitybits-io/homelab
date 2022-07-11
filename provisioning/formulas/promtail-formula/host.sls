{% set promtail = pillar.get('promtail') %}

create promtail directory:
  file.directory:
    - name: /opt/promtail
    - user: root
    - group: root
    - dir_mode: 0755
    - file_mode: 0744
    
download and extract promtail:
  archive.extracted:
    - name: /opt/promtail
    - source: https://github.com/grafana/loki/releases/download/{{ promtail['version'] }}/promtail-linux-amd64.zip
    - skip_verify: True
    - enforce_toplevel: False
    - user: root
    - group: root
    - require: 
        - create promtail directory

set promtail executable:
  file.managed:
    - name: /opt/promtail/promtail-linux-amd64
    - mode: 0744
    - user: root
    - group: root
    - require: 
        - download and extract promtail

{% set loki_url = promtail['loki'] %}
create promtail configuration:
  file.managed:
    - name: /opt/promtail/promtail-host.yaml
    - user: root
    - group: root
    - mode: 0640
    - contents: | 
        server:
          http_listen_port: 9080
          grpc_listen_port: 0

        positions:
          filename: /tmp/positions.yaml

        clients:
          - url: http://{{ loki_url }}/loki/api/v1/push

        scrape_configs:
        - job_name: system
          static_configs:
          - targets:
              - localhost
            labels:
              job: hostlogs
              __path__: /var/log/*log
              hostname: {{ grains['id'] }}

add promtail service file:
  file.managed:
    - name: /lib/systemd/system/promtail.service
    - user: root
    - group: root
    - mode: 0777
    - require:
      - download and extract promtail
    - contents: |
        [Unit]
        Description=Promtail client for sending logs to Loki
        After=network.target
        
        [Service]
        ExecStart=/opt/promtail/promtail-linux-amd64 -config.file=/opt/promtail/promtail-host.yaml -config.expand-env=true
        Restart=always
        TimeoutStopSec=3
        
        [Install]
        WantedBy=multi-user.target

reload systemctl promtail:
  module.run:
    - name: service.systemctl_reload
    - onchanges:
      - file: /lib/systemd/system/promtail.service
    - require:
      - add promtail service file

Promtail Service:
  service.running:
    - name: promtail
    - order: last
    - enable: true
    - require:
      - add promtail service file