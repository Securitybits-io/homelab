#Package.Plex init.sls
add plex repo:
  pkgrepo.managed:
    - humanname: Plex Repo
    - name: deb https://downloads.plex.tv/repo/deb public main
    - file: /etc/apt/sources.list.d/plex.list
    - key_url: https://downloads.plex.tv/plex-keys/PlexSign.key

# Install package
install plex:
  pkg.installed:
    - name: plexmediaserver
    - require:
      - add plex repo

#Enable Package
plex enabled:
  service.running:
    - name: plexmediaserver
    - enable: True
    - require:
      - pkg: install plex
