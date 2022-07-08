Install Salt-Master:
  pkg.latest:
    - name: salt-master
    - refresh: True

/etc/salt:
  file.recurse:
    - source: salt://vm/salt/etc/salt
    - user: root
    - group: root
    - file_mode: 644
    - dir_mode: 755
    - include_empty: true

# restart service