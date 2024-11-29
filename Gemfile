source 'https://rubygems.org'

gem 'berkshelf', '~> 8.0'
gem 'chef', '~> 18.0'

group :test do
  gem 'chefspec', '~> 9.3.0'
  gem 'coveralls', require: false
  gem 'foodcritic', '~> 16.0'
  gem 'rake'
  gem 'rubocop', '~> 1.69.0'
  gem 'simplecov', '~> 0.10'
end

group :development do
  gem 'guard'
  gem 'guard-foodcritic', '~> 3.0'
  gem 'guard-rspec'
  gem 'guard-rubocop'
end

group :integration do
  gem 'kitchen-dokken'
  gem 'kitchen-inspec'
  gem 'kitchen-vagrant'
  gem 'test-kitchen', '~> 3.0'
end

group :tools do
  gem 'github_changelog_generator', '~> 1.16.0'
end
