initialize-database:
  cmd.run:
    - cwd: /home/git/gitlab/
    - name: sudo -u git -H bundle exec rake gitlab:setup RAILS_ENV=production
    - unless: sudo -u git -H bundle exec rake gitlab:check RAILS_ENV=production

gitlab-boot:
  cmd.run:
    - cwd: /home/git/gitlab/
    - name: cp lib/support/init.d/gitlab /etc/init.d/gitlab && update-rc.d gitlab defaults 21 && cp lib/support/logrotate/gitlab /etc/logrotate.d/gitlab && sudo -u git -H bundle exec rake assets:precompile RAILS_ENV=production && sudo -u git -H git config --global user.name "GitLab" && sudo -u git -H git config --global user.email "localhost" && sudo -u git -H git config --global core.autocrlf input
    - unless: sudo -u git -H bundle exec rake gitlab:env:info RAILS_ENV=production

gitlab-start:
  service.running:
    - name: gitlab
    - enable: True
