require 'spec_helper'

module Ambi
  describe Build do
    describe 'routes' do
      let(:build) { Build.new([]) }

      it 'is a SortedSet' do
        build.routes.should be_kind_of(SortedSet)
      end
    end

    describe '#+' do
      let(:routes_a) do
        (1..3).collect { |n| mock_route(n.to_s, "/#{n}", [:get], {})}
      end

      let(:routes_b) do
        (4..6).collect { |n| mock_route(n.to_s, "/#{n}", [:get], {})}
      end

      it 'combines routes of both into a new Build' do
        left  = Build.new(routes_a)
        right = Build.new(routes_b)
        (left + right).routes.to_a.should == routes_a + routes_b
      end
    end

    describe '#to_app' do
      let(:build) { Build.new([]) }

      it 'generates a rack app' do
        build.to_app.should respond_to(:call)
      end
    end
  end
end