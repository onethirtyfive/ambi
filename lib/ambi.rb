Dir[File.dirname(__FILE__) + '/ambi/*.rb'].each { |file| require file }

module Ambi
  class << self
    def parse(source)
      Scope.new(DSL::Top) { clean_room_eval(source) }
    end
  end
end