require 'ambi/dsl'

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

    STATE = [
      :parent, :children, :stack,
      :domain, :app, :exposures,
      :request_methods, :relative_path, :relative_path_requirements
    ].freeze

    def self.state
      STATE
    end

    def initialize(options = {})
      self.class.state.each do |state|
        instance_variable_set "@own_#{state}".to_sym, options[state]
      end

      (@own_parent.own_children << self) unless @own_parent.nil?

      @own_children  ||= []
      @request_methods = [@request_methods] if @request_method.kind_of?(Symbol)
    end

    def clean_room_eval(dsl, source = nil, &block)
      clean_room = CleanRoom.new(self, dsl)
      if block_given?
        clean_room.instance_eval(&block)
      else
        unless source.respond_to?(:to_str)
          raise '#clean_room_eval requires either a block, or #to_str'
        end
        clean_room.instance_eval(source.to_str)
      end
    end

    def stack_for(level, acc = [])
      own_parent.stack_for(level, acc) unless own_parent.nil?

      case level
      when :domain; acc.concat(own_stack || []) if  own_parent.nil?
      when :app;    acc.concat(own_stack || []) if !own_parent.nil?
      end

      acc
    end

    def domain
      return own_domain unless own_domain.nil?

      if own_parent.nil?
        raise NoDomainError.new(':domain must be defined standalone or in scope')
      end

      own_parent.domain
    end

    def app
      return own_app unless own_app.nil?

      if own_parent.nil?
        raise NoAppError.new(':app must be defined standalone or in scope')
      end

      own_parent.app
    end

    def request_methods
      return own_request_methods unless own_request_methods.nil?
      own_parent.nil? ? (own_parent || []) : own_parent.request_methods
    end

    def path
      parent_path = own_parent.nil? ? '/' : own_parent.path

      c = [parent_path, own_relative_path].compact.collect(&:to_str)
      c.flatten.join.squeeze('/')
    end

    def path_requirements
      parent_path_requirements = \
        own_parent.nil? ? {}
                        : own_parent.path_requirements

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

    state.each { |state| attr_reader "own_#{state}".to_sym }
  end
end