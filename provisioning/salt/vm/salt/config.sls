git:
  pkg.installed: []

Clone Homelab Repo:
  git.latest:
    - name: https://github.com/Securitybits-io/homelab.git
    - target: /root/homelab
    - branch: main
    - require:
      - pkg: git