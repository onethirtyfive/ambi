module Ambi
  class Domain
    class << self
      def reset!
        @domains = {}
      end

      def all
        domains.dup
      end

      def register(name)
        name = name.to_sym
        domains[name] ||= new
        domains[name]
      end

      private

      def domains
        @domains ||= {}
      end
    end
  end
end