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
        def expose!(name, context = {})
        end
      end
    end

    [Domain, App].each do |dsl|
      dsl.send(:include, Common)
    end
  end
end
