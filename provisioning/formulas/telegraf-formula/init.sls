{% set telegraf = pillar['telegraf'] %}


telegraf dependencies:
  pkg.installed:
    - pkgs:
    {% if telegraf['snmptools'] is defined %}
      - snmp
      - snmp-mibs-downloader
    {% endif %}
    {% if telegraf['ipmitools'] is defined %}
      - ipmitool
    {% endif %}
      - python3-toml
    - reload_modules: true

{% if telegraf['snmptools'] is defined %}
add MIBs to SNMP:
  file.recurse:
    - name: /usr/share/snmp/mibs
    - source: salt://telegraf-formula/snmp/MIBs
    - user: root
    - group: root
    - file_mode: "0644"
    - dir_mode: "0777"
    - include_empty: true
    - require:
      - telegraf dependencies
{% endif %}

add telegraf repo:
  pkgrepo.managed:
    - humanname: Telegraf Repo
    - name: deb https://repos.influxdata.com/ubuntu focal stable
    - dist: focal
    - file: /etc/apt/sources.list.d/telegraf.list
    - key_url: https://repos.influxdata.com/influxdb.key

install telegraf:
  pkg.installed:
    - name: telegraf
    - require:
      - pkgrepo: add telegraf repo

{% if salt['pillar.get']('telegraf:config') %}
create telegraf config:
  file.managed:
    - name: /etc/telegraf/telegraf.conf
    - contents_pillar: telegraf:config
    - user: root
    - group: root
    - mode: "0644"
    - require:
      - telegraf dependencies
      - install telegraf
{% endif %}

telegraf:
  service.running:
    - enable: true
    - require:
      - pkg: install telegraf
    {% if salt['pillar.get']('telegraf:config') %}
    - watch:
      - file: /etc/telegraf/telegraf.conf
    {% if salt['pillar.get']('telegraf:modules') %}
    {% for module in salt['pillar.get']('telegraf:modules') %}
      - file: /etc/telegraf/telegraf.d/{{ module }}.conf
    {% endfor %}
    {% endif %}
    {% endif %}

{% if salt['pillar.get']('telegraf:modules') %}
  {% for module in salt['pillar.get']('telegraf:modules') %}
/etc/telegraf/telegraf.d/{{ module }}.conf:
  file.managed:
    - contents_pillar: telegraf:modules:{{ module }}:config
    - user: root
    - group: root
    - mode: "0644"
    - require:
      - install telegraf
  {% endfor %}
{% endif %}
