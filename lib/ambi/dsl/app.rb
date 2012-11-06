module Ambi
  module DSL
    module App
      def self.included(receiver)
        receiver.send(:include, Syntax)
      end

      module Syntax
        def at(relative_path_matcher, &block)
          options = { relative_path_matcher: relative_path_matcher }
          scope = Scope.new(dsl, { parent: self }.merge(options))
          scope.instance_eval(&block) if block_given?
        end

        def via(*args, &block)
          options = { request_methods: args }
          scope = Scope.new(dsl, { parent: self }.merge(options))
          scope.instance_eval(&block) if block_given?
        end

        def expose!(name, context = {})
          # pending implemenation: see spec
        end
      end
    end
  end
end
