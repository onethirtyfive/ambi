require 'ambi/dsl'

module Ambi
  class Scope
    class NoDomainError < RuntimeError; end;

    attr_reader   :dsl, :parent
    attr_writer   :_domain, :app, :request_methods
    attr_accessor :relative_path_matcher

    def initialize(dsl, parent = nil)
      @dsl    = dsl
      @parent = parent

      eigenclass = (class << self; self; end)
      eigenclass.send(:include, @dsl)
    end

    def _domain
      return @_domain unless @_domain.nil?

      begin
        parent._domain
      rescue NameError
        raise NoDomainError.new('domain must be specified separately or on app')
      end
    end

    def request_methods
      return @request_methods unless @request_methods.nil?

      begin
        parent.request_methods
      rescue NameError
        []
      end
    end

    def request_method=(method)
      self.request_methods = [method]
    end

    def path_matcher
      parent_path_matcher =
        begin
          parent.path_matcher
        rescue NameError
          %r{/?}
        end
      return parent_path_matcher.to_s if relative_path_matcher.nil?

      components = [parent_path_matcher.to_s, relative_path_matcher.to_s]
      Regexp.new(components.flatten.join)
    end
  end
end