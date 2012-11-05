require 'ambi'

module Ambi
  describe Domain do
    subject { Domain }

    before(:each) do
      subject.reset!
    end

    describe '#all' do
      it 'copies and returns the list of domains' do
        subject.register(:foo)
        subject.all.object_id.should_not == subject.send(:domains).object_id
      end
    end

    describe '#register' do
      it 'creates a domain if none exists' do
        expect {
          subject.register(:foo)
        }.to change(subject, :domains)
      end
    end
  end
end