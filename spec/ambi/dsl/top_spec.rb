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
    end
  end
end