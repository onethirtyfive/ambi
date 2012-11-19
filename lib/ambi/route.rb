require 'active_support/core_ext/module/delegation'
require 'rack/mount'

module Ambi
  class Route
    class << self
      def criteria
        @criteria ||= \
          [:name, :path, :request_methods, :path_requirements].freeze
      end

      def delegatees
        @delegatees ||= ([
          :domain, :app, :domain_stack, :app_stack, :endpoint_stack
        ] + criteria - [:name]).freeze
      end

      def not_implemented
        [501, { 'Content-Type' => 'text/plain' }, ['Not Implemented']]
      end

      def strexp(path, path_requirements, anchor = true)
        Rack::Mount::Strexp.new(path, path_requirements, %w( / . ? ), anchor)
      end
    end

    attr_reader :scope, :name, :block

    def initialize(scope, name, &block)
      @scope = scope
      @name  = name
      @block = block_given? ? block : (-> { self.class.not_implemented })
    end

    def mount_in(route_set)
      _request_methods = request_methods.collect { |m| m.to_s.upcase }
      _path_info       = Route.strexp(path, path_requirements)

      route_set.add_route self,
        { request_methods: _request_methods, path_info: _path_info },
        { domain: domain, app: app },
        name
    end

    delegate *delegatees, :to => :scope

    def <=>(other)
      self.criteria <=> other.criteria
    end

    protected

    def criteria
      @criteria ||= self.class.criteria.collect do |criterion|
        send criterion
      end
    end
  end
end
