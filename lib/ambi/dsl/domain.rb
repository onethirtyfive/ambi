module Ambi
  module DSL
    module Domain
      def self.included(receiver)
        receiver.send(:include, Syntax)
      end

      module Syntax
        def app(app, &block)
          options = { app: app }
          scope = Scope.new(DSL::App, { parent: self }.merge(options))
          scope.instance_eval(&block) if block_given?
        end
      end
    end
  end
end
