require 'ambi'

ENV['RACK_ENV'] = 'test'

RSpec.configure do |config|
  config.before { Ambi.reset! }
end