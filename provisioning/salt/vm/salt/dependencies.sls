python3:
  pkg.installed: []

python3-pip:
  pkg.installed: []

libgit2-dev:
  pkg.installed: []

python3-pygit2:
  pkg.installed: []


python-git:
  pip.installed:
    - name: python-git
    - require:
      - pkg: python3-pip
      - pkg: python3

pywinrm:
  pip.installed:
    - name: pywinrm
    - require:
      - pkg: python3-pip
      - pkg: python3

smbprotocol:
  pip.installed:
    - name: smbprotocol
    - require:
      - pkg: python3-pip
      - pkg: python3

pypsexec:
  pip.installed:
    - name: pypsexec
    - require:
      - pkg: python3-pip
      - pkg: python3

requests:
  pip.installed:
    - name: requests
    - require:
      - pkg: python3-pip
      - pkg: python3

IPy:
  pip.installed:
    - name: IPy
    - require:
      - pkg: python3-pip
      - pkg: python3
