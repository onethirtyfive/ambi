module Support
  module Rack
    module Test
      def app=(app)
        @app = app
      end

      def app
        @app
      end
    end
  end
end

World(Support::Rack::Test)