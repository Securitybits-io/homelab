Install Salt-Minion:
  pkg.latest:
    - name: salt-minion
    - refresh: True

Configure Salt-Minion:
  file.managed:
    - name: /etc/salt/minion.d/salt-master.conf
    - contents: |
        log_level: info
        master: salt.securitybits.local
    - require: 
      - Install Salt-Minion

Restart Salt-Minion:
  cmd.run:
    - name: systemctl restart salt-minion
    - watch: /etc/salt/minion.d/salt-master.conf
    - require:
      - Configure Salt-Minion