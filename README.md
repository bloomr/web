Bloom'r
======

[http://www.bloomr.org](www.bloomr.org)

[![Build Status](https://travis-ci.org/bloomr/web.svg?branch=master)](https://travis-ci.org/bloomr/web)

This is the repo for the Bloom'r web app.

Run as prod
===========

add to .env
RACK_ENV=production
RAILS_ENV=production
SECRET_KEY_BASE=production
in config/production: config.force_ssl=false
precompile assets: foreman run bundle exec rake assets:precompile
foreman s -f Procfile.dev
