require 'spec_helper'

module Ambi
  module DSL
    describe App do
      subject { App }

      include_context 'DSL clean room', subject.call

      describe '#given' do
        it 'creates a new scope with the provided route options' do
          options = { parent: scope, via: :get }
          Scope.should_receive(:new).once.with(App, options)
          clean_room.given(via: :get) {}
        end
      end

      describe '#via' do
        it 'creates a new scope with the provided route request methods' do
          options = { parent: scope, via: [:get, :post] }
          Scope.should_receive(:new).once.with(App, options)
          clean_room.via(:get, :post) {}
        end
      end

      describe '#at' do
        it 'creates a new scope with the provided route path ' do
          options = { parent: scope, at: '/foo' }
          Scope.should_receive(:new).once.with(App, options)
          clean_room.at('/foo') {}
        end

        it 'creates a new scope with the provided route path and route requirements' do
          options = { parent: scope, at: '/:foo', requirements: { foo: /1/ } }
          Scope.should_receive(:new).once.with(App, options)
          clean_room.at('/:foo', foo: /1/) {}
        end
      end

      describe '#expose' do
        it 'creates a new scope with the provided route name' do
          options = { parent: scope, at: '/foo', via: [:get], name: :index }
          Scope.should_receive(:new).once.with(Endpoint, options)
          clean_room.expose(:index, options)
        end
      end
    end
  end
end