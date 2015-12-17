source 'https://rubygems.org'
ruby '2.2.3'

gem 'unicorn'
gem 'rack-timeout'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

gem 'devise'

gem 'bootstrap-sass', '~> 3.2.0'
gem 'autoprefixer-rails'

gem 'activeadmin', github: 'activeadmin'

gem 'select2-rails'
gem 'activeadmin-select2', github: 'mfairburn/activeadmin-select2'

gem 'acts-as-taggable-on', '~> 3.4'

gem "paperclip", "~> 4.2"
gem 'aws-sdk', '< 2.0'

gem 'newrelic_rpm'

gem 'rest-client'

gem "algoliasearch-rails"
gem "rack-cors"

gem "haml"
gem 'stripe'

group :production do
  gem 'pg'
  gem 'rails_12factor'
  gem 'heroku-deflater'
end

group :development, :test do
  gem 'sqlite3'
  gem 'rspec-rails'
  gem 'guard-rspec'
  gem 'spring-commands-rspec'
  gem 'capybara'
  gem "rack-livereload"
  gem 'guard-livereload', '~> 2.4', require: false
  gem 'growl'
  gem 'rb-fsevent' if `uname` =~ /Darwin/
end

group :test do
  gem 'rake'
end

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

