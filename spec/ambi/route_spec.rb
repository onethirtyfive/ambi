require 'spec_helper'

module Ambi
  describe Route do
    subject do
      Ambi.eval do
        domain :'myblog.com' do
          mounting :entries, on: '/entries' do
            via :get do
              at('/:id', :id => /[0-9]+/) { route! :show  }
            end
          end
        end
      end
      Ambi[:'myblog.com'].routes.first
    end

    let(:route_set) { Rack::Mount::RouteSet.new }

    describe '#mount_in' do
      let(:strexp) { Route.strexp(subject.path, subject.path_requirements) }

      let(:requirements) { { request_methods: ['GET'], path_info: strexp } }
      let(:givens)       { { domain: :'myblog.com', app: :entries } }

      it 'calls RouteSet#add_route' do
        args = [subject, requirements, givens, :show]
        route_set.should_receive(:add_route).once.with(*args)
        subject.mount_in(route_set)
      end
    end
  end
end
