module Ambi
  class Exposure
    attr_reader :scope, :block

    def initialize(scope, &block)
      raise ArgumentError.new('closure scope must be non-nil') if scope.nil?
      raise ArgumentError.new('closure requires a block') unless block_given?
      @scope = scope
      @block = block
    end

    def to_app
      scope.derived_stack_for(:app)
    end
  end
end