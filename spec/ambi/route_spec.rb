require 'spec_helper'

module Ambi
  describe Route do
    let(:build) do
      Ambi.eval do
        domain :'myblog.com' do
          mounting :entries, on: '/entries' do
            at('/:id', :id => /[0-9]+/) do
              via(:get)                       { route! :show     }
              via(:put)                       { route! :update   }
              via(:get, :post, :put, :delete) { route! :wildcard }
            end
          end
        end
      end
      Ambi[:'myblog.com']
    end

    # Build#routes is a collection with a deterministic order.
    # These tests rely on that order.

    describe '#conditions' do
      subject { build.routes[0] } # :show

      it 'yields hash containing conditions hashes keyed to request method' do
        subject.conditions.size.should == 1
      end

      describe 'conditions hash' do
        it 'includes :request_method key, with upcased value' do
          subject.conditions[:get].should include(:request_method)
        end

        it 'includes :path_info key, with strexp value' do
          Route.should_receive(:strexp).once.and_return('/someregex/')
          subject.conditions[:get].should include(:path_info)
        end
      end
    end

    describe '#givens' do
      subject { build.routes[0] } # :show

      it 'includes :domain key, with value' do
        subject.givens.should include(:domain)
        subject.givens[:domain].should == subject.domain
      end

      it 'includes :app key, with value' do
        subject.givens.should include(:app)
        subject.givens[:app].should == subject.app
      end
    end

    describe '#mount_in' do
      shared_examples 'a route mounting itself' do
        let(:route_set)       { Rack::Mount::RouteSet.new }
        let(:request_methods) { subject.request_methods   }

        it 'calls RouteSet#add_route for each request method' do
          request_methods.each do |request_method|
            times = request_methods.count
            route_set.should_receive(:add_route).exactly(times).times
            subject.mount_in(route_set)
          end
        end
      end

      describe ':show' do
        subject { build.routes[0] } # :show
        it_behaves_like 'a route mounting itself'
      end

      describe ':update' do
        subject { build.routes[1] } # :update
        it_behaves_like 'a route mounting itself'
      end

      describe ':wildcard' do
        subject { build.routes[2] } # :wildcard
        it_behaves_like 'a route mounting itself'
      end
    end
  end
end
