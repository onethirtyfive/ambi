Dir[File.dirname(__FILE__) + '/ambi/*.rb'].each { |file| require file }

module Ambi
  class << self
    def parse!(source)
      Scope.new(DSL::Top).instance_eval(source)
    end

    def reset!
      @domains = Hash.new { |key| [] }
    end

    def register!(domain)
      domains[domain] = [] unless domains.include?(domain)
      domains[domain]
    end
    alias [] register!

    def domains
      reset! unless @domains
      @domains
    end
  end
end