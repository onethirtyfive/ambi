module Ambi
  module DSL
    module Top
      def self.included(receiver)
        receiver.send(:include, Syntax)
      end

      module Syntax
        def domain(name = 'default', &block)
          domain = Ambi::Domain.register(name)
        end

        def app(name, context = {}, &block)
          domain = context.delete(:domain)
          raise ArgumentError.new('must provide :domain option') unless domain
        end
      end
    end
  end
end