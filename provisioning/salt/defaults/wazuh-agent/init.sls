install wazuh-agent:
  cmd.run:
    - name: "curl -so wazuh-agent-4.3.6.deb https://packages.wazuh.com/4.x/apt/pool/main/w/wazuh-agent/wazuh-agent_4.3.6-1_amd64.deb && sudo WAZUH_MANAGER='10.0.40.6' WAZUH_AGENT_GROUP='default' dpkg -i ./wazuh-agent-4.3.6.deb"

daemon-reload:
  cmd.run:
    - name: systemctl daemon-reload
    - require:
      - install wazuh-agent

wazuh-agent:
  service.running:
    - enable: true