require 'ambi/dsl'

module Ambi
  class Scope
    class NoDomainError < RuntimeError; end;
    class NoAppError    < RuntimeError; end;

    attr_reader :dsl

    STATE = [
        :parent, :children,
        :stack,
        :domain, :app,
        :request_methods, :relative_path_matcher
      ].freeze
    STATE.each { |state| attr_reader "own_#{state}".to_sym }

    def self.state
      STATE
    end

    def initialize(dsl, options = {})
      @dsl = dsl
      eigenclass = (class << self; self; end)
      eigenclass.send(:include, dsl)

      self.class.state.each do |state|
        instance_variable_set "@own_#{state}".to_sym, options[state]
      end

      (own_parent.own_children << self) unless own_parent.nil?

      @own_children  ||= []
      @request_methods = [@request_methods] if @request_method.kind_of?(Symbol)
    end

    def derived_domain
      return own_domain unless own_domain.nil?

      if own_parent.nil?
        raise NoDomainError.new(':domain must be defined standalone or in scope')
      end

      own_parent.derived_domain
    end

    def derived_app
      return own_app unless own_app.nil?

      if own_parent.nil?
        raise NoAppError.new(':app must be defined standalone or in scope')
      end

      own_parent.derived_app
    end

    def derived_request_methods
      return own_request_methods unless own_request_methods.nil?
      own_parent.nil? ? [] : own_parent.derived_request_methods
    end

    def derived_path_matcher
      parent_derived_path_matcher = \
        own_parent.nil? ? %r{/?} : own_parent.derived_path_matcher

      return parent_derived_path_matcher.to_s if own_relative_path_matcher.nil?

      components = \
        [parent_derived_path_matcher.to_s, own_relative_path_matcher.to_s]

      Regexp.new(components.flatten.join)
    end

    def inspect
      self.class.state.collect do |state|
        state = "own_#{state}".to_sym
        value = self.send(state)
        "@#{state}=#{value}" if value
      end.compact.join(',')
    end
  end
end