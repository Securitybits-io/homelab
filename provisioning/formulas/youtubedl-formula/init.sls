{% set youtubedl = pillar['youtubedl'] %}
{% set folder = salt['pillar.get']('youtubedl:folder') %}
{% set crontime = pillar['cron'] %}

install dependencies:
  pkg.installed:
    - pkgs:
      - python3-pip
      - ffmpeg
      - mlocate

youtubedl dependencies:
  pip.installed:
    - name: yt-dlp
    - require:
      - install dependencies

create /opt/youtube-dl:
  file.managed:
    - name: /opt/youtube-dl.sh
    - mode: "0744"
    - contents: |
        #!/bin/bash
        /usr/local/bin/yt-dlp -N 5 --playlist-reverse --download-archive /youtube-dl/{{ folder }}/downloaded.txt -i -o "/youtube-dl/{{ folder }}/%(uploader)s/%(playlist)s/%(upload_date>%Y)s/%(playlist)s - S%(upload_date>%Y)sE%(playlist_index)s - %(title)s.%(ext)s" -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]" -S vcodec:h264 --merge-output-format mkv --add-metadata --write-thumbnail --write-description --write-auto-subs --sub-langs en,sv,-live_chat --convert-subs srt --batch-file=/opt/channel.list --compat-options playlist-index
    - require:
      - youtubedl dependencies

create /opt/channel-list:
  file.managed:
    - name: /opt/channel.list
    - mode: "0644"
    - contents: |
{% for channel, values in salt['pillar.get']('youtubedl:channels').items() %}
        # {{ channel }}
        {{ values['url'] }}
{% endfor %}
    - require:
      - youtubedl dependencies


create cronjob for /opt/youtube-dl:
  cron.present:
    - order: Last
    - name: /usr/bin/sh /opt/youtube-dl.sh
    {% if crontime['minute'] is defined %}
    - minute: {{ crontime['minute'] | default('*') }}
    {% endif %}
    {% if crontime['hour'] is defined %}
    - hour: {{ crontime['hour'] | default('*') }}
    {% endif %}
    {% if crontime['daymonth'] is defined %}
    - daymonth: {{ crontime['daymonth'] | default('*') }}
    {% endif %}
    {% if crontime['month'] is defined %}
    - month: {{ crontime['month'] | default('*') }}
    {% endif %}
    {% if crontime['dayweek'] is defined %}
    - dayweek: {{ crontime['dayweek'] | default('*') }}
    {% endif %}
    - require:
      - create /opt/youtube-dl