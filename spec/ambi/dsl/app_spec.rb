require 'spec_helper'

module Ambi
  module DSL
    describe App do
      describe 'domain-specific language' do
        describe '#expose' do
          subject do
            Scope.new(domain: :blog, app: :entries)
          end
        end
      end
    end
  end
end