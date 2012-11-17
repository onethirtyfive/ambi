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
          :domain, :app, :domain_stack, :app_stack, :endpoint_stack
        ] + criteria).freeze
      end

      def not_implemented
        [405, { 'Content-Type' => 'text/plain' }, ['Not Implemented']]
      end
    end

    def initialize(scope, name, &block)
      @scope = scope
      @name  = name
      @block = block_given? ? block : self.class.not_implemented
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
