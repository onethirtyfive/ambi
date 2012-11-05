require 'spec_helper'

module Ambi
  module DSL
    describe App do
      context 'quacking scope' do
        subject { Scope.new(DSL::App) }

        it 'responds to #at' do
          subject.should respond_to(:at)
        end

        it 'responds to #via' do
          subject.should respond_to(:via)
        end

        it 'responds to #expose!' do
          subject.should respond_to(:expose!)
        end
      end
    end
  end
end