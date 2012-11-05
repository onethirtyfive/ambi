require 'ambi'

module Ambi
  describe '#parse!' do
    let(:runner) { DSL::Top.runner_klass.new }

    before do
      DSL::Top.stub!(:runner).and_return(runner)
    end

    it 'evaluates in the context of the DSL' do
      runner.should_receive(:domain).once
      Ambi.parse! <<-EOV
        domain 'myblog.com'
      EOV
    end
  end
end