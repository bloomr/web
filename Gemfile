source 'https://rubygems.org'
ruby '2.2.5'

gem 'unicorn'
gem 'rack-timeout'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.7'
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
gem 'turbolinks', '~> 5.0.0'
#
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

gem 'devise'
gem 'simple_token_authentication', '~> 1.0'

gem 'autoprefixer-rails'

gem 'activeadmin', github: 'activeadmin'

gem 'select2-rails'
gem 'activeadmin-select2', github: 'mfairburn/activeadmin-select2'

gem 'paperclip', '~> 4.2'
gem 'aws-sdk', '< 2.0'

gem 'newrelic_rpm'

gem 'rest-client'

gem 'algoliasearch-rails'
gem 'rack-cors'

gem 'haml'
gem 'haml-rails'

gem 'stripe'
gem 'mandrill-api'
gem 'httparty'
gem 'delayed_job_active_record'

gem 'rails-i18n', '~> 4.0.0'
gem 'factory_girl_rails'

gem 'impressionist'

gem 'jsonapi-resources', git: 'https://github.com/cerebris/jsonapi-resources.git', tag: '0.7.1.beta2'
gem 'active_model_serializers', '~> 0.10.0'

gem 'intercom', '~> 3.5.9'

gem 'sitemap_generator'
gem 'fog-aws'

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
  gem 'rack-livereload'
  gem 'guard-livereload', '~> 2.4', require: false
  gem 'growl'
  gem 'rubocop', require: false
  gem 'selenium-webdriver'
  gem 'database_cleaner'
  gem 'sprite-factory'
  gem 'rmagick'
end

group :test do
  gem 'rake'
end

group :darwin do
  gem 'rb-fsevent'
end

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
