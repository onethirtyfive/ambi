['top', 'domain', 'app'].each do |level|
  require "ambi/dsl/#{level}"
end

module Ambi
  module DSL
    module Common
      def self.included(receiver)
        receiver.send(:include, Syntax)
      end

      module Syntax
      end
    end

    module Middleware
      def self.included(receiver)
        receiver.send(:include, Syntax)
      end

      module Syntax
        def use
          # pending: inject middleware at any level
        end
      end
    end

    [Top, Domain, App].each do |dsl|
      dsl.send(:include, Common)
      dsl.send(:include, Middleware)
    end
  end
end
