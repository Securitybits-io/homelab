Install Salt-Minion:
  pkg.latest:
    - name: salt-minion
    - refresh: True

Configure Salt-Minion:
  file.managed:
    - name: /etc/salt/minion.d/salt-master.conf
    - contents: |
        log_level: info
        master: salt-bak.securitybits.local

#Restart Salt-Minion: