include:
  - gitlab.user

gitlab-install:
  file.recurse:
    - source: salt://gitlab/files/gitlab
    - name: /home/git/gitlab
    - user: git
    - group: git
    - dir_mode: 755
    - file_mode: 644
    - makedirs: True
    - backup: minion
    - include_enpty: True
    - unless: test -d /home/git/gitlab
    - require:
      - user: git-user

gitlab-satellites:
  file.directory:
    - name: /home/git/gitlab-satellites
    - user: git
    - group: git
    - mode: 750
    - unless: test -d /home/git/gitlab-satellites
    - require:
      - user: git-user

gem-install:
  cmd.run:
    - cwd: /home/git/gitlab/
    - name: gem install bundler && sudo -u git -H bundle install --deployment --without development test mysql aws
    - unless: which bundler
    - require:
      - file: gitlab-install

gitlab-shell-install:
  cmd.run:
    - cwd: /home/git/gitlab/
    - name: sudo -u git -H bundle exec rake gitlab:shell:install[v1.9.4] REDIS_URL=redis://localhost:6379 RAILS_ENV=production
    - unless: test -d /home/git/gitlab-shell/config.yml
    - require:
      - file: gitlab-install
      - user: git-user
      - cmd: gem-install

initialize-database:
  cmd.run:
    - cwd: /home/git/gitlab/
    - name: sudo -u git -H bundle exec rake gitlab:setup RAILS_ENV=production
    - unless: sudo -u git -H bundle exec rake gitlab:check RAILS_ENV=production
    - require:
      - file: gitlab-install
      - user: git-user
      - cmd: gitlab-shell-install 

gitlab-boot:
  cmd.run:
    - cwd: /home/git/gitlab/
    - name: cp lib/support/init.d/gitlab /etc/init.d/gitlab && update-rc.d gitlab defaults 21 && cp lib/support/logrotate/gitlab /etc/logrotate.d/gitlab && sudo -u git -H bundle exec rake assets:precompile RAILS_ENV=production && sudo -u git -H git config --global user.name "GitLab" && sudo -u git -H git config --global user.email "localhost" && sudo -u git -H git config --global core.autocrlf input
    - unless: sudo -u git -H bundle exec rake gitlab:env:info RAILS_ENV=production
    - require:
      - user: git-user
      - cmd: initialize-database

gitlab-start:
  service.running:
    - name: gitlab
    - enable: True
    - require:
      - user: git-user
      - cmd: gitlab-boot
