require 'spec_helper'

module Ambi
  describe Domain do
    subject { Domain }

    describe '#reset!' do
      it 'resets class-level state' do
        subject.register(:foo)
        expect {
          subject.reset!
        }.to change(subject, :all)
      end
    end

    describe '#all' do
      before do
        subject.reset!
      end

      it 'copies and returns the list of domains' do
        subject.register(:foo)
        subject.all.object_id.should_not == subject.send(:domains).object_id
        subject.all.should == subject.send(:domains)
      end
    end

    describe '#register' do
      before do
        subject.reset!
      end

      it 'creates a domain if none exists' do
        expect {
          subject.register(:foo)
        }.to change(subject, :domains)
      end
    end
  end
end