require 'cucumber'
require 'cucumber/rspec/doubles'

require 'ambi'

ENV['RACK_ENV'] = 'test'

here = File.dirname(__FILE__)
Dir[File.expand_path(here + "/support/**/*.rb")].each do |support_file|
  require support_file
end
