require 'ambi'

module Ambi
  describe 'Ambi#parse!' do
    subject { Ambi }

    describe '#parse' do
      let!(:scope) { Scope.new }

      before do
        Scope.stub!(:new).and_return(scope)
      end

      it 'evaluates the source in a DSL::domain clean room' do
        source = <<-EOV
          domain 'myblog.com'
        EOV
        scope.should_receive(:clean_room_eval).once.with(DSL::Top, source)
        subject.parse!(source)
      end
    end

    describe 'class methods' do
      describe '#reset!' do
        it 'resets class-level state' do
          subject.instance_variable_set(:@domains, { foo: [] })
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

      describe '#registered?' do
        it 'returns true only if a domain is registered' do
          Ambi.register!(:foo)
          Ambi.registered?(:foo).should be_true
          Ambi.registered?(:bar).should be_false
        end
      end

      describe '#build' do
        let(:domain) do
          [mock('closure'), mock('closure'), mock('closure')]
        end

        let(:app) do
          mock('app', :to_app => -> {})
        end

        before do
          Ambi.stub!(:[]).and_return(domain)
          Ambi::Builder.stub!(:new).and_return(app)
        end

        it 'creates a builder with a domain' do
          Ambi::Builder.should_receive(:new).once.with(domain, '/').and_return(app)
          Ambi.build(domain)
        end

        it 'returns a callable' do
          Ambi.build(domain).should respond_to(:call)
        end
      end
    end
  end
end