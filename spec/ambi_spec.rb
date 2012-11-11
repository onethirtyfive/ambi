require 'ambi'

module Ambi
  describe 'Ambi#parse' do
    subject { Ambi }

    describe '#parse' do
      it 'creates a domain-level scope' do
        source = <<-EOV
          domain 'myblog.com'
        EOV
        Scope.should_receive(:new).once.with(DSL::Top)
        subject.parse(source)
      end
    end
  end
end