['top', 'domain', 'app', 'endpoint'].each do |level|
  require "ambi/dsl/#{level}"
end

module Ambi
  module DSL
    module Routing
      def self.included(receiver)
        receiver.send(:include, Syntax)
      end

      module Syntax
        def url(*args)
          # pending: generate a url
        end

        def path(*args)
          # pending: generate a relative path
        end
      end
    end

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

    [Domain, App, Endpoint].each do |dsl|
      dsl.send(:include, Routing)
      dsl.send(:include, Middleware)
    end
  end
end
