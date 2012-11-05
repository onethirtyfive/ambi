require 'ambi/dsl'

module Ambi
  class Scope
    attr_accessor :level, :parent

    def initialize(dsl, parent = nil)
      @dsl    = dsl
      @parent = parent

      eigenclass = (class << self; self; end)
      eigenclass.send(:include, @dsl)
    end
  end
end