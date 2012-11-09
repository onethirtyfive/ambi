Dir[File.dirname(__FILE__) + '/ambi/*.rb'].each { |file| require file }

module Ambi
  class << self
    def parse!(source)
      Scope.new.clean_room_eval(DSL::Top, source)
    end

    def reset!
      @domains = Hash.new { |key| [] }
    end

    def register!(domain)
      domains[domain] = [] unless domains.include?(domain)
      domains[domain]
    end
    alias [] register!

    def registered?(domain)
      domains.has_key?(domain)
    end

    def build(domain, location = '/')
      Builder.new(self[domain], location).to_app
    end

    private

    def domains
      reset! unless @domains
      @domains
    end
  end
end