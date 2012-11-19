require 'spec_helper'

module Ambi
  describe CleanRoom do
    let(:dsl) do
      Module.new do
        def do_dsl_stuff!
        end
      end
    end

    subject { CleanRoom.new(nil, dsl) }

    it 'evaluates in the provided scope' do
      expect {
        subject.do_dsl_stuff!
      }.not_to raise_error
    end
  end
end