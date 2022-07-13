#init.sls nginx

###########################
### NGINX Configuration ###
###########################

install_nginx:
  pkg.installed:
    - name: nginx

/etc/nginx/nginx.conf:
  file.managed:
    - source: salt://vm/nginx/deploy_files/nginx.conf
    - user: root
    - group: root
    - mode: 640
    - require:
      - pkg: nginx

/etc/nginx/sites-available:
  file.recurse:
    - source: salt://vm/nginx/deploy_files/sites-available
    - user: root
    - group: root
    - file_mode: 644
    - dir_mode: 755
    - require:
      - pkg: nginx

/etc/nginx/conf.d:
  file.recurse:
    - source: salt://vm/nginx/deploy_files/conf.d
    - user: root
    - group: root
    - file_mode: 644
    - dir_mode: 755
    - require:
      - pkg: nginx

################################
### LetsEcrypt Configuration ###
################################

install_letsencrypt:
  pkg.installed:
    - name: certbot

install_python_certbot_nginx:
  pkg.installed:
    - name: python3-certbot-nginx

/var/log/letsencrypt.log:
  file.managed:
    - user: root
    - group: root
    - mode: 640
    - replace: False
    - require:
      - pkg: nginx

script_certificate_get:
  file.managed:
    - name: /etc/letsencrypt/certificate_get.sh
    - source: salt://vm/nginx/deploy_files/letsencrypt/certificate_get.sh
    - user: root
    - group: root
    - mode: 700
    - require:
      - remove_sym_default
      - pkg: certbot
      - pkg: python3-certbot-nginx
      - file: /var/log/letsencrypt.log

get_certificate:
  cmd.run:
    - order: last
    - name: bash /etc/letsencrypt/certificate_get.sh
    - creates: /etc/nginx/letsencrypt.created
    - require:
      - file: script_certificate_get

renew_certificate:
  cron.present:
    - name: /usr/bin/certbot renew --quiet
    - identifier: SECBITS_RENEW_SSL
    - user: root
    - minute: 15
    - hour: 03
    - require:
      - file: script_certificate_get

##############################
### Linking of active conf ###
##############################

remove_sym_default:
  file.absent:
    - name: /etc/nginx/sites-enabled/default
    - require:
      - pkg: nginx

########### SECURITYBITS #####

sym_dash.securitybits.io:
  file.symlink:
    - name: /etc/nginx/sites-enabled/dash.securitybits.io.conf
    - target: /etc/nginx/sites-available/dash.securitybits.io.conf
    - force: True
    - require:
      - pkg: nginx

sym_gitlab.securitybits.io:
  file.symlink:
    - name: /etc/nginx/sites-enabled/gitlab.securitybits.io.conf
    - target: /etc/nginx/sites-available/gitlab.securitybits.io.conf
    - force: True
    - require:
      - pkg: nginx

sym_ombi.securitybits.io:
  file.symlink:
    - name: /etc/nginx/sites-enabled/ombi.securitybits.io.conf
    - target: /etc/nginx/sites-available/ombi.securitybits.io.conf
    - force: True
    - require:
      - pkg: nginx

sym_guacamole.securitybits.io:
  file.symlink:
    - name: /etc/nginx/sites-enabled/guacamole.securitybits.io.conf
    - target: /etc/nginx/sites-available/guacamole.securitybits.io.conf
    - force: True
    - require:
      - pkg: nginx

sym_takmap.securitybits.io:
  file.symlink:
    - name: /etc/nginx/sites-enabled/takmap.securitybits.io.conf
    - target: /etc/nginx/sites-available/takmap.securitybits.io.conf
    - force: True
    - require:
      - pkg: nginx

##############################
### Services Configuration ###
##############################

config_nginx:
  service.running:
    - name: nginx
    - restart: true
    - enable: true
    - require:
      - pkg: install_nginx
    - watch:
      - file: /etc/nginx/nginx.conf
      - file: /etc/nginx/conf.d
      - pkg: nginx
