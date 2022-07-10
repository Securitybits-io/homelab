#Package.mount init.sls
{% set mounts = pillar['mounts'] %}

nfs-common:
  pkg.installed: []

cifs-utils:
  pkg.installed: []

{%- for name, opts in mounts.get('mounted', {}).items() %}

mount {{ name }}:
  mount.mounted:
    - name: {{ opts.get('name') }}
    - device: {{ opts.get('device') }}
    - fstype: {{ opts.get('fstype', 'ext4') }}
    - mkmnt: {{ opts.get('mkmnt', False) }}
    - opts: {{ opts.get('opts', 'defaults') }}
    - dump: {{ opts.get('dump', '0') }}
    - pass_num: {{ opts.get('pass_num', '0') }}
    - config: {{ opts.get('config', '/etc/fstab') }}
    - persist: {{ opts.get('persist', True) }}
    - mount: {{ opts.get('mount', True) }}
    - user: {{ opts.get('user', 'root') }}
    - match_on: {{ opts.get('match_on', 'auto') }}
    - order: 1
    - require:
      - pkg: nfs-common
      - pkg: cifs-utils
{%- endfor -%}

{%- for name, opts in mounts.get('unmounted', {}).items() %}
unmount {{ name }}:
  mount.unmounted:
    - name: {{ opts.get('name') }}
    - device: {{ opts.get('device') }}
    - config: {{ opts.get('config', '/etc/fstab') }}
    - persist: {{ opts.get('persist', False) }}
    - user: {{ opts.get('user', 'root') }}
{%- endfor %}
