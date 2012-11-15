module Ambi
  module DSL
    module Domain
      def self.included(receiver)
        receiver.send(:include, Syntax)
      end

      module Syntax
        def mount(name, options = {}, &block)
          if Kernel.block_given?
            options[:mounts] = options.delete(:at)
            options = options.merge(app: name, parent: scope)
            Scope.new(DSL::App, options) { clean_room_eval(&block) }
          end
        end
      end
    end
  end
end
