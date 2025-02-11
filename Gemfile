source "https://rubygems.org"

gem "bootsnap", require: false
gem "jbuilder"
gem "kamal", require: false
gem "pg"
gem "puma", ">= 5.0"
gem "rails", "~> 8.0.1"
gem "solid_cable"
gem "solid_cache"
gem "solid_queue"
gem "sqlite3", ">= 2.1"
gem "thruster", require: false
gem "tzinfo-data", platforms: %i[ windows jruby ]

group :development, :test do
  gem "brakeman", require: false
  gem "capybara"
  gem "database_cleaner"
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "dotenv-rails"
  gem "factory_bot_rails"
  gem "faker"
  gem "pry-byebug"
  gem "pry-rails"
  gem "rspec-rails"
  gem "rubocop-rails-omakase", require: false
end

group :development do
  gem "fasterer"
  gem "overcommit"
  gem "rubocop"
  gem "rubocop-config-prettier"
  gem "rubocop-performance"
  gem "rubocop-rails"
  gem "rubocop-rspec"
end

group :test do
  gem "shoulda-matchers"
  gem "simplecov"
end

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin Ajax possible
# gem "rack-cors"
