require 'spec_helper'

module Ambi
  module DSL
    describe Top do
      subject { Top.runner }

      describe '#domain' do
        it 'registers a domain' do
          expect {
            subject.call do
              domain 'myblog.com'
            end
          }.to change(::Ambi::Domain, :all)
        end
      end
    end
  end
end