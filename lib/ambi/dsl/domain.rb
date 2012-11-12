module Ambi
  module DSL
    module Domain
      def self.included(receiver)
        receiver.send(:include, Syntax)
      end

      module Syntax
        def app(app, options = {}, &block)
          if Kernel.block_given?
            options = options.merge(parent: scope, app: app)
            Scope.new(DSL::App, options) { clean_room_eval(&block) }
          end
        end
      end
    end
  end
end
