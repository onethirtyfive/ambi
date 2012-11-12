require 'spec_helper'

module Ambi
  module DSL
    describe Routing do
      it 'specifies the routing DSL'
    end

    describe Stacking do
      it 'specifies the middleware DSL'
    end

    describe Responding do
      subject { Responding }

      include_context 'DSL clean room', subject.call

      describe '#route!' do
        let(:scope) do
          Scope.new(DSL::Endpoint, domain: :'myblog.com', app: :entries)
        end

        let!(:fake_route) { mock_route(:index, '/', [:get], {}) }

        it 'creates a route with the scope, name, and block' do
          Route.should_receive(:new).once.and_return(fake_route)
          clean_room.route!(:index) {}
        end
      end
    end
  end
end