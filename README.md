Bloom'r
======

[http://www.bloomr.org](www.bloomr.org)

[![Build Status](https://travis-ci.org/bloomr/web.svg?branch=master)](https://travis-ci.org/bloomr/web)

This is the repo for the Bloom'r web app.

Run as prod
===========

in config/production: config.force_ssl=false
foreman run bundle exec rake assets:precompile && foreman s -e .env_prod -f Procfile.dev

Run Capybara Chrome Test
========================
add var
LC_NUMERIC='en_US.UTF-8'
