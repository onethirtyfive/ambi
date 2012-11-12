require 'spec_helper'

module Ambi
  describe Route do
    let(:no_op) do
      -> {}
    end

    describe '#initialize' do
      it 'raises ArgumentError without a block' do
        expect {
          Route.new(Scope.new, :index)
        }.to raise_error(ArgumentError)
      end
    end
  end
end