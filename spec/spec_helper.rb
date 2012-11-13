require 'ambi'

ENV['RACK_ENV'] = 'test'

here = File.dirname(__FILE__)
Dir[File.expand_path(here + "/support/*.rb")].each do |support_file|
  require support_file
end

RSpec.configure do |config|
  config.before do
    Ambi.reset!
  end
  config.include Support::DSLCleanRoom
  config.include Support::RouteHelpers
end