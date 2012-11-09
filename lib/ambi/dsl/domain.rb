module Ambi
  module DSL
    module Domain
      def self.included(receiver)
        receiver.send(:include, Syntax)
      end

      module Syntax
        def app(app, options = {}, &block)
          if Kernel.block_given?
            options = { parent: scope, app: app }
            Scope.new(options).clean_room_eval(DSL::App, &block)
          end
        end
      end
    end
  end
end
