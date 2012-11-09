module Ambi
  module DSL
    module App
      def self.included(receiver)
        receiver.send(:include, Syntax)
      end

      module Syntax
        def via(*args, &block)
          if Kernel.block_given?
            options = { parent: scope, request_methods: args }
            Scope.new(options).clean_room_eval(DSL::App, &block)
          end
        end

        def at(relative_path, &block)
          if Kernel.block_given?
            options = { parent: scope, relative_path: relative_path }
            Scope.new(options).clean_room_eval(DSL::App, &block)
          end
        end

        def expose!(name, options = {}, &block)
          Ambi[scope.domain] << Exposure.new(scope, &block)
        end
      end
    end
  end
end
