require 'spec_helper'

module Ambi
  module DSL
    describe App do
      describe 'domain-specific language' do
        describe '#expose!' do
          subject do
            Scope.new(domain: :blog, app: :entries)
          end

          it 'adds a route record to the domain' do
            expect {
              subject.clean_room_eval(DSL::App) do
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