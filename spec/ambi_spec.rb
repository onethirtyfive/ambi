require 'ambi'

module Ambi
  describe 'Ambi#parse!' do
    subject { Ambi}

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
end