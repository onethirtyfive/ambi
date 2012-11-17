require 'spec_helper'

module Ambi
  describe Build do
    let(:routes_a) do
      (1..3).collect { |n| mock_route(n.to_s, "/#{n}", [:get], {}) }
    end

    let(:routes_b) do
      (4..6).collect { |n| mock_route(n.to_s, "/#{n}", [:get], {}) }
    end

    subject { Build.new(routes_a + routes_b) }

    describe 'route_set' do
      it 'is a Builder::RouteSet' do
        subject.route_set.should be_kind_of(Build::RouteSet)
      end
    end

    describe '#+' do
      it 'combines two builds into one' do
        left  = Build.new(routes_a)
        right = Build.new(routes_b)
        (left + right).route_set.should == subject.route_set
      end
    end

    describe '#to_app' do
      let(:deviant_route) { subject.route_set.first }

      it 'ensures a common domain' do
        deviant_route.stub!(:domain).and_return(:'otherdomain.edu')
        expect {
          subject.to_app
        }.to raise_error(Build::RouteSet::MultipleDomainsError)
      end

      it 'ensures a common domain stack across all routes' do
        deviant_route.stub!(:domain_stack).and_return([mock('deviant stack')])
        expect {
          subject.to_app
        }.to raise_error(Build::InconsistentDomainStackError)
      end

      it 'ensures a common app stack across all same-app routes' do
        deviant_route.stub!(:app_stack).and_return([mock('deviant stack')])
        expect {
          subject.to_app
        }.to raise_error(Build::InconsistentAppStackError)
      end

      it 'generates a rack app' do
        subject.to_app.should respond_to(:call)
      end
    end
  end
end
