base:
    '*':
        - gitlab.init
        - gitlab.user
        - gitlab.ruby
        - gitlab.postgresql
        - gitlab.createdb
        - gitlab.gitlab
        - gitlab.nginx
