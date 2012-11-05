require 'spec_helper'

module Ambi
  module DSL
    describe Top do
      subject { ::Ambi::Scope.new(Top) }

      context 'quacking' do
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