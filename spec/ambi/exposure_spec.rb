require 'spec_helper'

module Ambi
  describe Exposure do
    let(:no_op) do
      -> {}
    end

    describe 'initialization' do
      it 'raises ArgumentError with a nil scope' do
        expect {
          Exposure.new(nil, &no_op)
        }.to raise_error(ArgumentError)
      end

      it 'raises ArgumentError without a block' do
        expect {
          Exposure.new(Scope.new)
        }.to raise_error(ArgumentError)
      end
    end

    describe '#to_app' do
      let(:scope) { Scope.new(DSL::Endpoint) }

      it 'uses derived stack'
    end
  end
end