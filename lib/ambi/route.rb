require 'active_support/core_ext/module/delegation'

module Ambi
  class Route
    attr_reader :scope, :block

    class << self
      def criteria
        @criteria ||= \
          [:name, :path, :request_methods, :path_requirements].freeze
      end

      def delegatees
        @delegatees ||= ([
          :stack, :domain, :app
        ] + criteria).freeze
      end
    end

    def initialize(scope, name, &block)
      @scope = scope
      @name  = name
      @block = block
    end

    delegate *delegatees, :to => :scope

    def <=>(other)
      self.criteria <=> other.criteria
    end

    protected

    def criteria
      @criteria ||= self.class.criteria.collect do |criterion|
        send criterion
      end
    end
  end
end