#!/bin/bash

#create db
sudo -u postgres createuser --createdb git
sudo -u postgres createdb --owner=git gitlabhq_production
