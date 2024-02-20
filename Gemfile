source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.2"

gem 'blueprinter'
gem "bootsnap", require: false
gem 'e164'
gem "importmap-rails"
gem "jbuilder"
gem "olive_branch"
gem "omniauth-auth0"
gem 'omniauth-rails_csrf_protection'
gem "pg", "~> 1.1"
gem "puma", "~> 5.0"
gem "rack-cors"
gem "rails", "~> 7.0.7", ">= 7.0.7.2"
gem "redis"
gem "resque"
gem 'rswag-api'
gem 'rswag-ui'
gem 'scout_apm'
gem "sentry-rails"
gem "sentry-ruby"
gem "slack-notifier"
gem "sprockets-rails"
gem "stimulus-rails"
gem "strong_migrations"
gem "timecop"
gem "turbo-rails"
gem "twilio-ruby"
gem 'tzinfo-data'
gem 'value_semantics'

group :development, :test do
  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem "dotenv-rails"
  gem "factory_bot_rails"
  gem 'faker'
  gem "pry"
  gem 'pry-byebug'
  gem "rspec-rails"
  gem 'rswag-specs'
  gem "rubocop"
  gem 'rubocop-factory_bot'
  gem 'rubocop-rails'
  gem 'rubocop-rspec'
end

group :development do
  gem 'annotate'
  gem "spring"
  gem 'spring-commands-rspec'
  gem "web-console"
end

group :test do
  gem 'database_cleaner-active_record'
end
