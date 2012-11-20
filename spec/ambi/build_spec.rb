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

    describe 'routes' do
      it 'is a Build::RouteSet' do
        subject.routes.should be_kind_of(Build::RouteSet)
      end
    end

    describe '#+' do
      it 'combines two builds into one' do
        left  = Build.new(routes_a)
        right = Build.new(routes_b)
        (left + right).routes.should == subject.routes
      end
    end

    describe '#assert_sane_build!' do
      let(:deviant_route) { subject.routes.first }

      it 'ensures a common domain' do
        deviant_route.stub!(:domain).and_return(:'otherdomain.edu')
        expect {
          subject.assert_sane_build!
        }.to raise_error(Build::RouteSet::InconsistentDomainError)
      end

      it 'ensures common roots across all routes within one app' do
        deviant_route.stub!(:roots).and_return(['/different', '/roots'])
        expect {
          subject.assert_sane_build!
        }.to raise_error(Build::RouteSet::InconsistentRootsError)
      end

      it 'ensures a common domain stack across all routes' do
        deviant_route.stub!(:domain_stack).and_return([mock('deviant stack')])
        expect {
          subject.assert_sane_build!
        }.to raise_error(Build::InconsistentDomainStackError)
      end

      it 'ensures a common app stack across all same-app routes' do
        deviant_route.stub!(:app_stack).and_return([mock('deviant stack')])
        expect {
          subject.assert_sane_build!
        }.to raise_error(Build::InconsistentAppStackError)
      end
    end

    describe '#to_app' do
      it 'calls #to_app on each route at least once' do
        subject.routes.each do |route|
          route.should_receive(:mount_in).at_least(1).times.and_return(-> {})
        end
        subject.to_app
      end
    end
  end
end
