['top', 'domain', 'app', 'endpoint'].each do |level|
  require "ambi/dsl/#{level}"
end

module Ambi
  module DSL
    module Middleware
      def self.included(receiver)
        receiver.send(:include, Syntax)
      end

      module Syntax
        def stack(&block)
          # pending: inject middleware at any level
        end
      end
    end

    [Domain, App, Closure].each do |dsl|
      dsl.send(:include, Middleware)
    end
  end
end
