require 'ambi/dsl/domain'
require 'ambi/dsl/app'

module Ambi
  module DSL
    module Top
      def self.included(receiver)
        receiver.send(:include, Syntax)
      end

      module Syntax
        def domain(domain, &block)
          if Kernel.block_given?
            options = { parent: nil, domain: domain }
            Scope.new(DSL::Domain, options) { clean_room_eval(&block) }
          end
        end
      end
    end
  end
end