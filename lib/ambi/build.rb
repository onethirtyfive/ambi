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
      -> {}
    end
  end
end