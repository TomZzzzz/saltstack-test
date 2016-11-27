include:
  - gitlab.user
postgresql-install:
  pkg.installed:
    - name:
      - postgresql
      - postgresql-client
      - libpq-dev
    - unless: psql --version
