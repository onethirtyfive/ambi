Dir[File.dirname(__FILE__) + '/ambi/*.rb'].each { |file| require file }

module Ambi
  class << self
    def reset!
      @builds = Hash.new { |k| Build.new([]) }
    end

    def [](domain)
      builds[domain]
    end

    def []=(domain, to_app)
      unless to_app.respond_to?(:to_app)
        raise ArgumentError, 'Ambi#[]= argument must have #to_app'
      end
      builds[domain] = to_app
    end

    def parse(source)
      Scope.new(DSL::Top) { clean_room_parse(source) }
    end

    def eval(&block)
      Scope.new(DSL::Top) { clean_room_eval(&block) }
    end

    private

    def builds
      reset! unless @builds
      @builds
    end
  end
end