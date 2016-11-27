include:
  - gitlab.postgresql
  - gitlab.user
/root/createdb.sh:
  file.managed:
    - source: salt://gitlab/files/createdb.sh
    - user: root
    - group: root
    - mode: 744

createdb:
  cmd.run:
    - name: /root/createdb.sh
    - unless: sudo -u git -H psql -d gitlabhq_production -c "SELECT VERSION()" 
    - require:
      - file: /root/createdb.sh
      - pkg: postgresql-install
      - user: git-user
