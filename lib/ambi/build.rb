require 'active_support/core_ext/module/delegation'

module Ambi
  class Build
    class RouteSet < Array
      class InconsistentDomainError < RuntimeError; end;
      class InconsistentRootsError  < RuntimeError; end;

      def domain
        unique_domains = collect(&:domain).uniq
        unless unique_domains.size == 1
          message = "Multiple domains specified in build: #{unique_domains}"
          raise InconsistentDomainError, message
        end
        unique_domains.first
      end

      def roots
        @roots ||= apps.each_with_object({}) do |app, acc|
          unique_roots = self.in(app).collect(&:roots).uniq
          unless unique_roots.size == 1
            message = "Inconsistent roots specified in build: #{unique_roots}"
            raise InconsistentRootsError, message
          end
          acc[app] = unique_roots.first
        end
        @roots
      end

      def apps
        @apps ||= by_app.keys
      end

      def by_app
        unless @by_app
          @by_app = group_by(&:app)
          @by_app.values.each { |values| values.sort! }
        end
        @by_app
      end

      def in(app)
        @in      ||= {}
        @in[app] ||= by_app[app]
      end
    end

    attr_reader :routes

    class InconsistentDomainStackError < RuntimeError; end;
    class InconsistentAppStackError    < RuntimeError; end;

    delegate :domain, :roots, :apps, :by_app, :in, :to => :routes

    def initialize(routes)
      @routes = RouteSet.new(routes.sort)
    end

    def +(other)
      Build.new(routes + other.routes)
    end

    def assert_sane_build!
      assert_consistent_domain!
      assert_consistent_roots!
      assert_consistent_domain_stack!
      apps.each { |app| assert_consistent_app_stack_for!(app) }
    end

    def to_app
      mappings = apps.each_with_object({}) do |app, acc|
        roots[app].each { |root| acc[root] = route_set_for(app) }
      end

      Rack::Builder.new do |builder|
        mappings.each do |root, route_set|
          builder.map root do
            run route_set
          end
        end
      end.to_app
    end

    private

    def assert_consistent_domain!
      domain
    end

    def assert_consistent_roots!
      roots
    end

    def assert_consistent_domain_stack!
      unique_domain_stacks = routes.uniq(&:domain_stack)
      unless unique_domain_stacks.size == 1
        message = "Inconsistent domain stacks for #{domain}."
        raise InconsistentDomainStackError, message
      end
    end

    def assert_consistent_app_stack_for!(app)
      unique_app_stacks = routes.in(app).collect(&:app_stack).uniq
      unless unique_app_stacks.size == 1
        message = "Inconsistent app stacks for #{app}."
        raise InconsistentAppStackError, message
      end
    end

    def route_set_for(app)
      route_set = Rack::Mount::RouteSet.new.tap do |route_set|
        self.in(app).each { |route| route.mount_in(route_set) }
      end
      route_set.freeze
    end
  end
end
