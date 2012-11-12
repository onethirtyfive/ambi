require 'spec_helper'

module Ambi
  module DSL
    describe Domain do
      subject { Domain }

      include_context 'DSL clean room', subject.call

      describe '#app' do
        it 'creates a new scope with the provided app name' do
          options = { parent: scope, app: :entries }
          Scope.should_receive(:new).once.with(App, options)
          clean_room.app(:entries) {}
        end
      end
    end
  end
end