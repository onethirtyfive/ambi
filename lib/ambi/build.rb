require 'set'

module Ambi
  class Build
    attr_reader :routes

    def initialize(routes)
      @routes = SortedSet.new(routes)
    end

    def +(other)
      Build.new(routes + other.routes)
    end

    def to_app
      # Stub for duck-type check
      -> env { [404, { 'Content-Type' => 'text/plain' }, ['Not Found']] }
    end
  end
end
