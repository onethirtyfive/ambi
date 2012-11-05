module Ambi
  module DSL
    module App
      def self.included(receiver)
        receiver.send(:include, Syntax)
      end

      module Syntax
        def at(relative_path_matcher, &block)
          scope = Scope.new(dsl, self)
          scope.relative_path_matcher = relative_path_matcher
          scope.instance_eval(&block) if block_given?
        end

        def via(*args, &block)
          scope = Scope.new(dsl, self)
          scope.request_methods = args
          scope.instance_eval(&block) if block_given?
        end

        def expose!(name, context = {})
          # pending implemenation: see spec
        end
      end
    end
  end
end
