git-user:
  user.present:
    - name: git
    - system: True
    - shell: /sbin/nologin
    - fullname: GitLab
    - home: /home/git
    - gid_from_name: true
    - unless: cat /etc/passwd |grep git
