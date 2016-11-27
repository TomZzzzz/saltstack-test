ruby-install:
  file.managed:
    - name: /opt/ruby-2.1.2.tar.gz
    - source: salt://gitlab/files/ruby-2.1.2.tar.gz
    - mode: 755
    - user: root
    - group: root
  cmd.run:
    - name: cd /opt && tar zxvf ruby-2.1.2.tar.gz && cd ruby-2.1.2 && ./configure --disable-install-rdoc --prefix=/usr/local && make && make install
    - unless: ruby -v
    - require:
      - file: ruby-install
