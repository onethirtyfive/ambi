Dir[File.dirname(__FILE__) + '/ambi/*.rb'].each { |file| require file }

module Ambi
  class << self
    def parse!(source)
      Scope.new(DSL::Top).instance_eval(source)
    end
  end
end