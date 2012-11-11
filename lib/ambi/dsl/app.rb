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
            Scope.new(DSL::App, options) { clean_room_eval(&block) }
          end
        end

        def at(relative_path, &block)
          if Kernel.block_given?
            options = { parent: scope, at: relative_path }
            Scope.new(DSL::App, options) { clean_room_eval(&block) }
          end
        end

        def expose(name, options = {}, &block)
          options = options.merge({ parent: scope })
          Scope.new(DSL::Endpoint, options) { clean_room_eval(&block) }
        end
      end
    end
  end
end
