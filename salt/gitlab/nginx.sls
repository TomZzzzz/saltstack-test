nginx-install:
  pkg.installed:
    - name: nginx
    - unless: /etc/nginx/nginx.conf
  cmd.run:
    - cwd: /home/git/gitlab/
    - name: cp lib/support/nginx/gitlab /etc/nginx/sites-available/gitlab && rm /etc/nginx/sites-enabled/default &&  ln -s /etc/nginx/sites-available/gitlab /etc/nginx/sites-enabled/gitlab
  service.running:
    - name: nginx
    - enable: True
    - require:
      - pkg: nginx-install
