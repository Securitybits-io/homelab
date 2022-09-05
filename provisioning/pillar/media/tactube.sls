mounts:
  mounted:
    YoutubeDLMovies:
      name: /youtube-dl
      device: //10.0.11.241/PlexMedia/Youtube-DL
      fstype: cifs
      mkmnt: True
      config: /etc/fstab
      opts: rw,username=guest,password="",vers=3.0,file_mode=0777,dir_mode=0777
      persist: True
      mount: True

cron:
  minute: 0
  hour: 2

youtubedl:
  folder: TacTube
  channels:
    Tein:
      channel: "Tein"
      url: https://www.youtube.com/user/0simme0/videos