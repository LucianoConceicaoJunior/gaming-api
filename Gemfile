# frozen_string_literal: true

source 'https://rubygems.org'

gem 'api_guard'
gem 'bcrypt', '~> 3.1.7'
gem 'bootsnap', require: false
gem 'capistrano'
gem 'capistrano-bundler'
gem 'capistrano-rails'
gem 'capistrano-rvm'
gem 'capistrano3-puma', github: 'seuros/capistrano-puma'
gem 'faker'
gem 'pg', '~> 1.1'
gem 'puma', '>= 5.0'
gem 'rails', '~> 7.2.1'
gem 'tzinfo-data', platforms: %i[ windows jruby ]

group :development, :test do
  gem 'brakeman', require: false
  gem 'debug', platforms: %i[ mri windows ], require: 'debug/prelude'
  gem 'pry-byebug'
  gem 'rspec-rails', '~> 7.0.0'
  gem 'rubocop'
  gem 'rubocop-factory_bot'
  gem 'rubocop-rails'
  gem 'rubocop-rails-omakase', require: false
  gem 'rubocop-rspec'
  gem 'rubocop-rspec_rails'
end
