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
        unless domains.include?(name)
          domains[name] = new
        end
        domains[name]
      end

      private

      def domains
        @domains ||= {}
      end
    end
  end
end