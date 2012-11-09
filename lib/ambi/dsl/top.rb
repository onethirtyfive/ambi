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
            options = { parent: scope, domain: domain }
            Scope.new(options).clean_room_eval(DSL::Domain, &block)
          end
        end

        def app(name, options = {}, &block)
          domain = options[:domain]
          raise ArgumentError.new('must provide :domain option') unless domain

          if Kernel.block_given?
            options = { parent: scope, domain: domain }
            Scope.new(options).clean_room_eval(DSL::App, &block)
          end
        end
      end
    end
  end
end