install wazuh-agent:
  pkg.installed:
    - sources:
      - wazuh-agent: https://packages.wazuh.com/4.x/apt/pool/main/w/wazuh-agent/wazuh-agent_4.3.6-1_amd64.deb
    - env:
      - WAZUH_MANAGER: 'mgmt-docker-01'
      - WAZUH_AGENT_GROUP: 'default'

daemon-reload:
  cmd.run:
    - name: systemctl daemon-reload
    - require:
      - install wazuh-agent

wazuh-agent:
  service.running:
    - enable: true