require 'spec_helper'

module Ambi
  module DSL
    describe App do
      context 'quacking scope' do
        subject { Scope.new(DSL::App) }

        it 'responds to #at' do
          subject.should respond_to(:at)
        end

        it 'responds to #via' do
          subject.should respond_to(:via)
        end

        it 'responds to #expose!' do
          subject.should respond_to(:expose!)
        end
      end

      describe 'domain-specific language' do
        describe '#expose!' do
          subject do
            Scope.new(DSL::App, domain: :blog, app: :entries)
          end

          it 'adds a route record to the domain' do
            expect {
              subject.instance_eval do
                expose! :index, via: :get, at: '/' do
                  puts "hai"
                end
              end
            }.to change(Ambi[:blog], :size)
          end
        end
      end
    end
  end
end