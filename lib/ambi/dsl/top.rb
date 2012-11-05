require 'ambi/dsl/domain'
require 'ambi/dsl/app'

module Ambi
  module DSL
    module Top
      def self.included(receiver)
        receiver.send(:include, Syntax)
      end

      module Syntax
        def domain(name, &block)
          Ambi::Domain.register(name)
          Scope.new(DSL::Domain, self).instance_eval(&block) if block_given?
        end

        def app(name, context = {}, &block)
          domain = context.delete(:domain)
          raise ArgumentError.new('must provide :domain option') unless domain
          Scope.new(DSL::App, self).instance_eval(&block)
        end
      end
    end
  end
end