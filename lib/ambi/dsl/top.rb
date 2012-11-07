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
          options = { domain: domain }
          scope = Scope.new(DSL::Domain, { parent: self }.merge(options))
          scope.instance_eval(&block) if block_given?
        end

        def app(name, options = {}, &block)
          domain = options[:domain]
          raise ArgumentError.new('must provide :domain option') unless domain

          options = { domain: domain }
          scope = Scope.new(DSL::App, { parent: self }.merge(options))
          scope.instance_eval(&block) if block_given?
        end
      end
    end
  end
end