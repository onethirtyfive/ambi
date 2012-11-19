module Ambi
  class CleanRoom < BasicObject
    attr_reader :scope

    def initialize(scope, dsl)
      @scope = scope
      eigenclass = (class << self; self; end)
      eigenclass.send(:include, dsl)
    end
  end
end