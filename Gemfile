source 'https://rubygems.org'
ruby '2.3.1'

gem 'rails',                      '~> 5.0.0', '>= 5.0.0.1'
gem 'mysql2',                     '~> 0.4.5'
gem 'puma',                       '~> 3.0'
gem 'rollbar',                    '2.11.3'
gem 'devise_token_auth',          '~> 0.1.39'
gem 'omniauth',                   '~> 1.3', '>= 1.3.1'
gem 'active_model_serializers',   '~> 0.10.3'
gem 'prmd',                       '~> 0.12.0'

group :development do
  gem 'spring-watcher-listen',    '~> 2.0.0'
  gem 'listen',                   '~> 3.0.5'
end

group :test do
  gem 'shoulda-matchers',       '3.0.1', require: false
  gem 'simplecov',              '0.12.0', require: false
  gem 'email_spec',             '1.6.0'
  gem 'vcr',                    '3.0.0'
  gem 'database_cleaner',       '1.5.3'
  gem 'webmock',                '1.22.3'
  gem 'coveralls',              '0.8.15', require: false
  gem 'ffaker',                 '~> 2.2.0'  
  gem 'json_matchers',          '~> 0.6.3'
end

group :development, :test do
  gem 'rspec-rails',            '3.5.1'
  gem 'factory_girl_rails',     '4.5.0'
  gem 'spring-commands-rspec',  '1.0.4'
  gem 'byebug',                 '8.2.1'
  gem 'spring',                 '2.0.0'
end
