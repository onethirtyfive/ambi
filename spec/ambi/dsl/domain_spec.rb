require 'spec_helper'

module Ambi
  module DSL
    describe Domain do
      context 'quacking scope' do
        subject { Scope.new(DSL::Domain) }

        it 'responds to #app' do
          subject.should respond_to(:app)
        end
      end
    end
  end
end