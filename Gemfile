ruby '2.4.1'
source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.1.0'
gem 'webpacker', github: 'rails/webpacker'

platform :ruby do
  gem 'pg', '~> 0.18'
  gem 'puma', '~> 3.7'
  gem 'unicorn'
  gem 'mini_racer'

  gem 'mongoid', '~> 6.0.0'
  gem "mongoid-enum", git: 'https://github.com/monster-media/mongoid-enum'
  gem 'mongoid-slug'
  gem 'mongoid-paperclip'
  gem 'mongoid-locker'
  gem 'mongoid-history'
  gem 'mongoid_rails_migrations'

  gem 'bson_ext'
  gem 'redis', '~> 3.2'
  gem 'redis-namespace'
  gem 'redis-rails'
end

# default
gem 'uglifier', '>= 1.3.0'
gem 'sprockets', '~> 3.0'
gem 'sprockets-es6'
gem 'turbolinks', '~> 5'
gem 'sass-rails', '~> 5.0'

source 'https://rails-assets.org' do
  gem 'rails-assets-bootstrap'
  gem 'rails-assets-bootstrap-datepicker'
  gem 'rails-assets-bootstrap-datetimepicker'
  gem 'rails-assets-jquery'
  gem 'rails-assets-jquery-ujs'
  gem 'rails-assets-jquery-ui'
  gem 'rails-assets-fontawesome'
  gem 'rails-assets-moment'
  gem 'rails-assets-slick.js'
  gem 'rails-assets-parsleyjs'
end
gem 'coffee-rails', '~> 4.2'
gem 'jquery-rails'

group :production do
  gem 'rails_12factor'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console'
  gem 'listen', '~> 3.0.5'

  gem 'meta_request'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  gem 'better_errors'
  gem 'binding_of_caller'

  # Deployment process
  gem 'capistrano', '~> 3.1'
  gem 'capistrano-rails', '~> 1.1'
  gem 'capistrano-bundler', '~> 1.1.2'
  gem 'capistrano-rbenv', git: 'https://github.com/capistrano/rbenv'
  gem 'airbrussh', require: false
  gem 'slackistrano', '3.1.0.beta'
end

group :development, :test do
  gem 'byebug'
  gem 'pry'
  gem 'pry-nav'
  gem 'pry-rails'
  gem 'pry-stack_explorer'
  gem 'pry-theme'

  %w[rspec-core rspec-expectations rspec-mocks rspec-rails rspec-support].each do |lib|
    gem lib, git: "https://github.com/rspec/#{lib}.git", branch: 'master'
  end

  gem 'factory_girl_rails'
  gem 'faker'
  gem 'ffaker'
end

group :test do
  gem 'capybara'
  gem 'capybara-webkit'
  gem 'database_cleaner'
  gem 'shoulda'
  gem 'shoulda-matchers'#, '~> 3.0'
  gem 'poltergeist'
  gem 'foreman'
  gem 'launchy'
  gem 'rspec-collection_matchers'
  gem 'simplecov'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'bcrypt', '~> 3.1.7'
gem 'jwt'
# gem 'knock', '~> 2.0'
gem 'hashie', '3.5.1'
gem 'devise', github: 'plataformatec/devise'
gem 'erubis'
gem 'omniauth-facebook'
gem 'koala'

gem 'jbuilder', '~> 2.5'
gem 'rack-cors'
gem 'rack-attack'


# ------------------------------------------

gem 'bootstrap-sass'
gem 'font-awesome-sass', '~> 4.6.2'
gem 'bootstrap3-datetimepicker-rails', '~> 4.17.42'

gem 'jquery-ui-rails'
gem 'jquery-turbolinks'
gem 'jquery-slick-rails'
gem 'jquery-validation-rails'
gem 'parsley-rails'
gem 'momentjs-rails'

# ------------------------------------------

gem 'grape'
gem 'grape-entity'
gem 'grape-swagger'
gem 'grape-swagger-rails'
gem 'grape-swagger-entity'
gem 'grape-swagger-representable'
gem 'grape-active_model_serializers'
gem 'active_model_serializers'
gem 'activemodel-serializers-xml'
gem 'hashie-forbidden_attributes'
gem 'open_uri_redirections'
gem 'jsonapi'
gem 'jsonapi-parser', '~> 0.1.1.beta2'

# ActiveRecord Helper
# gem 'figaro'
# gem 'annotate'
# gem 'has_scope'
# gem 'friendly_id'
# # gem 'acts_as_paranoid', '~> 0.5.0'
# gem 'paperclip', git: 'https://github.com/thoughtbot/paperclip'
# gem 'paperclip-ffmpeg'
# gem 'rqrcode_png'
# gem 'dragonfly', '~> 1.0.12'
# gem 'money-rails'
# gem 'monetize'

# gem 'rubyzip', '= 1.0.0'
# gem 'axlsx', '= 2.0.1'
# gem 'axlsx_rails'

# worker
# gem 'devise-async'
gem 'sidekiq'
gem 'sidekiq-cron'

# gem 'react_on_rails', '~> 6'

gem 'simple_form'
gem 'country_select'
gem 'show_for'
gem 'cocoon'
gem 'kaminari'
gem 'rails_autolink'
gem 'rails-controller-testing'

# gem 'firebase'
# gem 'gcloud'
gem 'aws-sdk', '~> 2'
# gem 'omise'
# gem 'mailgun'
# gem 'one_signal'
# gem 'slack-notifier'
# gem 'rollbar'

# marketing
# gem 'meta-tags'
# gem 'google-api-client'
# gem 'mixpanel-ruby'
# gem 'vanity'
# gem 'split'
