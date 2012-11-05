Dir[File.dirname(__FILE__) + '/dsl/*.rb'].each { |file| require file }

require 'active_support/core_ext/string'

module Ambi
  module DSL
    module Runnable
      def self.included(receiver)
        receiver.instance_eval <<-EOV
          def self.runner_klass
            @klass ||=
              Class.new(Object) do
                include #{receiver}

                def call(source = nil, &block)
                  if source.respond_to?(:to_str)
                    instance_eval(source)
                  elsif block_given?
                    instance_eval(&block)
                  end
                end
              end
            @klass
          end

          def self.runner
            runner_klass.new
          end
        EOV
      end
    end # Runnable

    [Top].each { |klass| klass.send(:include, Runnable) }
  end # DSL
end #  Ambi