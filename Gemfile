source 'https://rubygems.org'

gem 'rails', '~> 5.0.0', '>= 5.0.0.1'

platform :ruby do
  gem 'pg', '~> 0.18'
  gem 'puma', '~> 3.0'
  gem 'unicorn'
  gem 'mini_racer'
end

gem 'mongoid', '~> 6.0.0'
gem 'mongoid-slug'
gem 'mongoid_rails_migrations'
gem 'mongoid-paperclip'
gem 'bson_ext'
gem 'redis', '~> 3.0'
gem 'redis-rails'

gem 'jbuilder', '~> 2.5'
gem 'json', git: 'https://github.com/arnonhongklay/json', branch: 'v1.8'
gem 'jsonapi'
gem 'jsonapi-parser', '~> 0.1.1.beta2'
gem 'active_model_serializers'
gem 'rack-cors'
gem 'rack-attack'
gem 'hashie-forbidden_attributes'
gem 'grape'
gem 'grape-entity'
gem 'grape-swagger'
gem 'grape-swagger-rails'
gem 'grape-active_model_serializers'

gem 'knock', '~> 2.0'

gem 'devise'
gem 'omniauth-facebook'
gem 'figaro'


gem 'bcrypt', '~> 3.1.7'
gem 'sass-rails', '~> 5.0'
gem 'jquery-rails'
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'

gem 'bootstrap', '~> 4.0.0.alpha6'
gem "tabs_on_rails"


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
  gem 'capistrano-npm'
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

  # gem 'rspec-rails', '~> 3.0'
  git_source(:github) do |repo_name|
    repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
    "https://github.com/#{repo_name}.git"
  end

  gem 'factory_girl_rails'
  gem 'faker'
  gem 'ffaker'
end

group :test do
  gem 'capybara'
  gem 'capybara-webkit'
  gem 'database_cleaner'
  gem 'guard'
  gem 'guard-rspec'
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
