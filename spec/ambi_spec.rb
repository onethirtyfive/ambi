require 'spec_helper'

module Ambi
  describe 'Ambi#parse' do
    subject { Ambi }

    describe '#[]' do
      it 'returns a build for the provided key' do
        Ambi[:'myblog.com'].should be_kind_of(Build)
      end
    end

    describe '#[]=' do
      it 'allows setting of a #to_app by name' do
        expect {
          Ambi[:'myblog.com'] = mock('#to_app', to_app: nil)
        }.not_to raise_error
      end

      it 'raises if value is not a #to_app' do
        expect {
          Ambi[:'myblog.com'] = mock('not #to_app')
        }.to raise_error(ArgumentError, /#to_app/)
      end
    end

    describe '#parse' do
      def eval_source!
        source = <<-EOV
          domain :'myblog.com'
        EOV
        subject.parse(source)
      end

      it 'creates a domain-level scope' do
        Scope.should_receive(:new).once.with(DSL::Top)
        eval_source!
      end

      it "changes a domain's build" do
        eval_source!
        expect {
          source = <<-EOV
            domain :'myblog.com' do
              mounting :entries, on: '/entries' do
                via :get do
                  at('/') { route! :index }
                end
              end
            end
          EOV
          subject.parse(source)
        }.to change { Ambi[:'myblog.com'] }
      end
    end

    describe '#eval' do
      def within_entries_app(&block)
        Ambi.eval do
          domain :'myblog.com' do
            mounting(:entries, on: '/entries', &block)
          end
        end
      end

      def eval_block!
        within_entries_app do
          given(via: :get, at: '/') { route! :index }
        end
      end

      it 'creates a domain-level scope' do
        Scope.should_receive(:new).once.with(DSL::Top)
        eval_block!
      end

      it "changes a domain's build" do
        eval_block!
        expect {
          within_entries_app do
            given(via: :post, at: '/') { route! :create }
          end
        }.to change { Ambi[:'myblog.com'] }
      end
    end
  end
end