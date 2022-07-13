plex disable:
  service.dead:
    - name: plexmediaserver
    - enable: False

plex uninstall:
  pkg.purged:
    - name: plexmediaserver
