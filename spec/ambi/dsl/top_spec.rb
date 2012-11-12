require 'spec_helper'

module Ambi
  module DSL
    describe Top do
      subject { Top }

      include_context 'DSL clean room', subject.call

      describe '#domain' do
        it 'creates a new scope with the provided domain name' do
          options = { parent: nil, domain: :'myblog.com' }
          Scope.should_receive(:new).once.with(Domain, options)
          clean_room.domain(:'myblog.com') {}
        end
      end

      describe '#app' do
        it 'raises an error if :domain not explicitly provided' do
          expect {
            clean_room.app(:entries) {}
          }.to raise_error(ArgumentError, /:domain/)
        end

        it 'creates a new scope with the provided app name' do
          options = { parent: scope, domain: :'myblog.com', app: :entries }
          Scope.should_receive(:new).once.with(App, options)
          clean_room.app(:entries, domain: :'myblog.com') {}
        end
      end
    end
  end
end