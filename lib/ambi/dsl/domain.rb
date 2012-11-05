module Ambi
  module DSL
    module Domain
      def self.included(receiver)
        receiver.send(:include, Syntax)
      end

      module Syntax
        def app(name, context = {}, &block)
          scope = Scope.new(DSL::App, self)
          scope._domain = context.delete(:domain)
          scope.instance_eval(&block) if block_given?
        end
      end
    end
  end
end
