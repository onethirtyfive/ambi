require 'ambi'

module Ambi
  describe 'Ambi#parse!' do
    subject { Ambi }

    describe '#parse' do
      let!(:scope) { Scope.new(DSL::Top) }

      before do
        Scope.stub!(:new).and_return(scope)
      end

      it 'evaluates in the DSL-enabled scope' do
        scope.should_receive(:domain).once
        subject.parse! <<-EOV
          domain 'myblog.com'
        EOV
      end
    end

    describe 'class methods' do
      describe '#reset!' do
        it 'resets class-level state' do
          subject.instance_variable_set(:@domains, { :foo => [] })
          expect {
            subject.reset!
          }.to change(subject, :domains)
        end
      end

      describe '#register!' do
        it 'creates a domain if none exists' do
          expect {
            subject.register!(:foo)
          }.to change(subject, :domains)
        end
      end
    end
  end
end