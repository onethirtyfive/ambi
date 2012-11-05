Dir[File.dirname(__FILE__) + '/ambi/*.rb'].each { |file| require file }

module Ambi
  class << self
    def parse!(source)
      DSL::Top.runner.call(source)
    end
  end
end