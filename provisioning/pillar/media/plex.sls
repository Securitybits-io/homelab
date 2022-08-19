mounts:
  mounted:
    plexmedia:
      name: /plexmedia
      device: //10.0.11.241/PlexMedia
      fstype: cifs
      mkmnt: True         # Default is False, True used for testing
      config: /etc/fstab
      opts: rw,username=guest,password="",vers=3.0,file_mode=0777,dir_mode=0777
      persist: True
      mount: True
    plexbackup:
      name: /plexbackup
      device: //10.0.11.241/Securitybits.Systems/PlexBackup
      fstype: cifs
      mkmnt: True
      config: /etc/fstab
      opts: rw,username=guest,password="",vers=3.0,uid=996,file_mode=0777,dir_mode=0777
      persist: True
      mount: True