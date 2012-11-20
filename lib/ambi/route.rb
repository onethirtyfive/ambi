require 'rack/lobster'
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
          :domain, :roots, :app, :domain_stack, :app_stack, :endpoint_stack
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
      @block = block_given? ? block : (-> env { self.class.not_implemented })
    end

    def call(env)
      # This obviously isn't complete.
      self.class.not_implemented
    end

    def mount_in(route_set)
      request_methods.each do |rm|
        rm, pi = rm.to_s.upcase, Route.strexp(path, path_requirements)

        conditions = { request_method: rm, path_info: pi }
        givens     = { domain: domain, app: app }

        route_set.add_route(self, conditions, givens, name)
      end
    end

    delegate *delegatees, :to => :scope

    def <=>(other)
      self.criteria <=> other.criteria
    end

    def conditions
      request_methods.each_with_object({}) do |request_method, acc|
        rm = request_method.to_s.upcase
        pi = Route.strexp(path, path_requirements)
        acc[request_method] = { request_method: rm, path_info: pi }
      end
    end

    def givens
      { domain: domain, app: app }
    end

    protected

    def criteria
      @criteria ||= self.class.criteria.collect do |criterion|
        send criterion
      end
    end
  end
end
