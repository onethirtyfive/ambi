require 'spec_helper'

module Ambi
  describe Closure do
    let(:no_op) do
      -> {}
    end

    describe 'initialization' do
      it 'raises ArgumentError with a nil scope' do
        expect {
          Closure.new(nil, &no_op)
        }.to raise_error(ArgumentError)
      end

      it 'raises ArgumentError without a block' do
        expect {
          scope = Scope.new(DSL::Endpoint)
          Closure.new(scope)
        }.to raise_error(ArgumentError)
      end
    end

    describe '#to_app' do
      let(:scope) { Scope.new(DSL::Endpoint) }

      it 'uses derived middleware stack'
    end
  end
end