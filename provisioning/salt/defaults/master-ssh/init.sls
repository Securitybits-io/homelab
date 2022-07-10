{% set PubKey = salt['mine.get']('salt', 'master-ssh-pub-key') -%} 
{% set pub = PubKey.values() | first -%}
{% set server = grains['id'] %}
Add Public SSH Key to {{ server }}:
  ssh_auth.present:
    - user: root
    - names: 
      - {{ pub }}
    - order: last
