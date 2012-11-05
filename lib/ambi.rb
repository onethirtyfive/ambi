Dir[File.dirname(__FILE__) + '/ambi/*.rb'].each { |file| require file }

module Ambi
  class << self
    def runner
      Class.new { include Syntax }.new
    end

    def parse!(source)
      runner.instance_eval(source)
    end
  end

  module Syntax
    def domain(name = 'default', &block)
      domain = Ambi::Domain.register(name)
    end
  end
end