module Ambi
  module DSL
    module App
      def self.included(receiver)
        receiver.send(:include, Syntax)
      end

      module Syntax
      end
    end
  end
end
