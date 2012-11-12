require 'ambi/dsl'
require 'set'

module Ambi
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
      def dsls
        @dsls ||= [DSL::Endpoint, DSL::App, DSL::Domain].freeze
      end

      def levels
        @levels ||= [:endpoint, :app, :domain].freeze
      end

      def state
        @state ||= [
          :stack,
          :domain, :app,
          :name, :request_methods, :relative_path, :relative_path_requirements
        ].freeze
      end
    end

    def initialize(dsl, options = {}, &block)
      @dsl    = dsl
      @parent = options[:parent]

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

    def clean_room_parse(source)
      clean_room = CleanRoom.new(self, dsl)
      unless source.respond_to?(:to_str)
        raise '#clean_room_eval requires either a block or #to_str'
      end
      clean_room.instance_eval(source.to_str)
    end

    def clean_room_eval(&block)
      clean_room = CleanRoom.new(self, dsl)
      clean_room.instance_eval(&block) # if block_given?
    end

    def stack(level, acc = [])
      parent.stack(level, acc) unless no_parent?

      case level
      when :domain;   acc.concat(own_stack || []) if dsl == DSL::Domain
      when :app;      acc.concat(own_stack || []) if dsl == DSL::App
      when :endpoint; acc.concat(own_stack || []) if dsl == DSL::Endpoint
      end

      acc
    end

    def domain
      return own_domain unless own_domain.nil?

      if no_parent?
        raise NoDomainError.new(':domain must be defined standalone or in scope')
      end

      parent.domain
    end

    def app
      return own_app unless own_app.nil?

      if no_parent?
        raise NoAppError.new(':app must be defined standalone or in scope')
      end

      parent.app
    end

    def name(level = :domain, acc = [])
      parent.name(level, acc) unless no_parent?

      eligible_dsls = self.class.dsls[0..self.class.levels.index(level)]
      acc << own_name if own_name && eligible_dsls.include?(dsl)

      acc
    end

    def request_methods
      return own_request_methods unless own_request_methods.nil?
      no_parent? ? (parent || []) : parent.request_methods
    end

    def path
      parent_path = no_parent? ? '/' : parent.path

      c = [parent_path, own_relative_path].compact.collect(&:to_str)
      c.flatten.join.squeeze('/')
    end

    def path_requirements
      parent_path_requirements = \
        no_parent? ? {} : parent.path_requirements

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

    protected

    attr_reader :dsl, :parent

    def no_parent?
      parent.nil?
    end

    state.each { |state| attr_reader "own_#{state}".to_sym }
  end
end