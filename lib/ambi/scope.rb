require 'ambi/dsl'
require 'set'

module Ambi
  # Developer note:
  # Scopes are completely immutable except for #children, a SortedSet added to
  # by a child scope when instantiated. Members of #children are sorted by
  # criteria specified in the class method with the same name.
  class Scope
    class NoDomainError < RuntimeError; end;
    class NoAppError    < RuntimeError; end;

    class CleanRoom < BasicObject
      attr_reader :scope

      def initialize(scope, dsl)
        @scope = scope
        eigenclass = (class << self; self; end)
        eigenclass.send(:include, dsl)
      end
    end

    class << self
      def state
        @state ||= [
          :stack,
          :domain, :app,
          :request_methods, :relative_path, :relative_path_requirements
        ].freeze
      end

      def criteria
        @criteria ||= [:path, :request_methods, :path_requirements].freeze
      end
    end

    def initialize(dsl, options = {}, &block)
      @dsl      = dsl
      @parent   = options[:parent]
      @children = SortedSet.new
      unless parent.nil?
        parent.children = SortedSet.new(parent.children.to_a + [self])
      end

      @own_request_methods            = options[:via]
      @own_relative_path              = options[:at]
      @own_relative_path_requirements = options[:requirements]

      auto = self.class.state - \
        [:request_methods, :relative_path, :relative_path_requirements]

      auto.each do |state|
        instance_variable_set "@own_#{state}".to_sym, options[state]
      end

      @request_methods = [@request_methods] if @request_method.kind_of?(Symbol)

      instance_eval(&block) if block_given?

      self
    end

    def clean_room_eval(source = nil, &block)
      clean_room = CleanRoom.new(self, dsl)
      if block_given?
        clean_room.instance_eval(&block)
      elsif source
        unless source.respond_to?(:to_str)
          raise '#clean_room_eval requires either a block or #to_str'
        end
        clean_room.instance_eval(source.to_str)
      end
    end

    def stack_for(level, acc = [])
      parent.stack_for(level, acc) unless parent.nil?

      case level
      when :domain;   acc.concat(own_stack || []) if dsl == DSL::Domain
      when :app;      acc.concat(own_stack || []) if dsl == DSL::App
      when :endpoint; acc.concat(own_stack || []) if dsl == DSL::Endpoint
      end

      acc
    end

    def domain
      return own_domain unless own_domain.nil?

      if parent.nil?
        raise NoDomainError.new(':domain must be defined standalone or in scope')
      end

      parent.domain
    end

    def app
      return own_app unless own_app.nil?

      if parent.nil?
        raise NoAppError.new(':app must be defined standalone or in scope')
      end

      parent.app
    end

    def request_methods
      return own_request_methods unless own_request_methods.nil?
      parent.nil? ? (parent || []) : parent.request_methods
    end

    def path
      parent_path = parent.nil? ? '/' : parent.path

      c = [parent_path, own_relative_path].compact.collect(&:to_str)
      c.flatten.join.squeeze('/')
    end

    def path_requirements
      parent_path_requirements = \
        parent.nil? ? {} : parent.path_requirements

      if own_relative_path_requirements.nil?
        return parent_path_requirements.to_hash
      end

      parent_path_requirements.merge(own_relative_path_requirements || {})
    end

    def inspect
      instance_variables =
        self.class.state.collect do |state|
          state = "own_#{state}".to_sym
          value = self.send(state)
          "@#{state}=#{value}" if value
        end
      "#<Ambi::Scope: #{instance_variables.compact.join(',')}>"
    end

    def <=>(other)
      self.criteria <=> other.criteria
    end

    protected

    def criteria
      @criteria = self.class.criteria.collect do |criterion|
        send criterion
      end
    end

    attr_reader   :dsl, :parent
    attr_accessor :children

    state.each { |state| attr_reader "own_#{state}".to_sym }
  end
end