module Ambi
  module DSL
    module App
      def self.included(receiver)
        receiver.send(:include, Syntax)
      end

      module Syntax
        def given(options = {}, &block)
          if Kernel.block_given?
            options = options.merge({ parent: scope })
            Scope.new(DSL::App, options) { clean_room_eval(&block) }
          end
        end

        def via(*args, &block)
          if Kernel.block_given?
            options = { parent: scope, via: args }
            Scope.new(DSL::App, options) { clean_room_eval(&block) }
          end
        end

        def at(relative_path, requirements = {}, &block)
          if Kernel.block_given?
            options = { parent: scope, at: relative_path }
            unless requirements.empty?
              options.merge!(requirements: requirements)
            end
            Scope.new(DSL::App, options) { clean_room_eval(&block) }
          end
        end

        def expose(route_name, options = {}, &block)
          options = options.merge({ parent: scope })
          Scope.new(DSL::Endpoint, options) { clean_room_eval(&block) }
        end
      end
    end
  end
end
