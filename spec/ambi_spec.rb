require 'ambi'

module Ambi
  describe '#parse!' do
    let(:runner) { mock('runner') }

    before do
      Ambi.stub!(:runner).and_return(runner)
    end

    it 'evaluates in the context of the DSL' do
      runner.should_receive(:domain).once
      Ambi.parse! <<-EOV
        domain 'myblog.com'
      EOV
    end
  end
end