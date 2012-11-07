module Ambi
  module DSL
    module Endpoint
      def self.included(receiver)
        receiver.send(:include, Syntax)
      end

      module Syntax
      end
    end
  end
end