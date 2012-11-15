source :rubygems

gem 'rack'
gem 'activesupport', '~> 3.2.8'

group :test do
  gem 'cucumber'
  gem 'rspec'
  gem 'capybara'
  gem 'guard-cucumber'
  gem 'guard-rspec'
  gem 'rb-fsevent', :require => RUBY_PLATFORM.include?('darwin') && 'rb-fsevent'
  gem 'growl',      :require => RUBY_PLATFORM.include?('darwin') && 'growl'
  gem 'rb-inotify', :require => RUBY_PLATFORM.include?('linux')  && 'rb-inotify'
end

