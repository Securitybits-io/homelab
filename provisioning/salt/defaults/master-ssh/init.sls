#make master update mine

{% set PubKey = salt['mine.get']('salt', 'master-ssh-pub-key') -%} 
{% set pub = PubKey.values() | first -%}
joining controller {{ id }}:
  cmd.run:
    - name: /var/lib/zerotier-one/zerotier-cli join {{ nwid }} && touch /opt/zerotier-{{ nwid }}.joined
    - creates: /opt/zerotier-{{ nwid }}.joined
    - require:
      - install ZeroTier-cli