require 'active_support/core_ext/module/delegation'

module Ambi
  class Build
    class RouteSet < Array
      class MultipleDomainsError < RuntimeError; end;

      def domain
        unique_domains = collect(&:domain).uniq
        unless unique_domains.size == 1
          message = "Multiple domains specified in build: #{unique_domains}"
          raise MultipleDomainsError.new(message)
        end
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

    attr_reader :route_set

    class InconsistentDomainStackError < RuntimeError; end;
    class InconsistentAppStackError    < RuntimeError; end;

    delegate :domain, :apps, :to => :route_set

    def initialize(route_set)
      @route_set = RouteSet.new(route_set.sort)
    end

    def +(other)
      Build.new(route_set + other.route_set)
    end

    def to_app
      ensure_single_domain!
      ensure_single_domain_stack!

      apps.each do |app|
        ensure_single_app_stack_for!(app)
      end

      -> env { [404, { 'Content-Type' => 'text/plain' }, ['Not Found']] }
    end

    private

    def ensure_single_domain!
      domain
    end

    def ensure_single_domain_stack!
      unique_domain_stacks = route_set.uniq(&:domain_stack)
      unless unique_domain_stacks.size == 1
        message = "Multiple domain stacks for #{domain}."
        raise InconsistentDomainStackError.new(message)
      end
    end

    def ensure_single_app_stack_for!(app)
      unique_app_stacks = route_set.in(app).collect(&:app_stack).uniq
      unless unique_app_stacks.size == 1
        message = "Multiple app stacks for #{app}."
        raise InconsistentAppStackError.new(message)
      end
    end
  end
end
