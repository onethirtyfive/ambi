require 'spec_helper'

module Ambi
  module DSL
    describe Top do
      context 'quacking scope' do
        subject { Scope.new(DSL::Top) }

        it 'responds to #domain' do
          subject.should respond_to(:domain)
        end

        it 'responds to #app' do
          subject.should respond_to(:app)
        end
      end
    end
  end
end