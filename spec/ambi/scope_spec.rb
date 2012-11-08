require 'spec_helper'

module Ambi
  describe Scope do 
    let(:parent)     { Scope.new(DSL::Domain) }
    let(:child)      { Scope.new(DSL::App, parent: parent) }
    let(:grandchild) { Scope.new(DSL::App, parent: child) }

    describe 'domain via #own_domain/#derived_domain' do
      it 'raises an error if neither explicitly set nor inherited' do
        expect {
          child.derived_domain
        }.to raise_error(Scope::NoDomainError)
      end

      it 'inherits from parent scopes if not explicitly set' do
        parent.instance_variable_set(:@own_domain, :'otherblog.org')
        child.derived_domain.should == :'otherblog.org'
      end

      it 'overrides parent scopes if explicitly set' do
        parent.instance_variable_set(:@own_domain, :'myblog.com')
        child.instance_variable_set(:@own_domain, :'otherblog.org')
        child.derived_domain.should == :'otherblog.org'
      end
    end

    describe 'app via #own_app/#derived_app' do
      it 'raises an error if neither explicitly set nor inherited' do
        expect {
          child.derived_app
        }.to raise_error(Scope::NoAppError)
      end

      it 'inherits from parent scopes if not explicitly set' do
        parent.instance_variable_set(:@own_app, :entries)
        child.derived_app.should == :entries
      end

      it 'overrides parent scopes if explicitly set' do
        parent.instance_variable_set(:@own_app, :entries)
        child.instance_variable_set(:@own_app, :comments)
        child.derived_app.should == :comments
      end
    end

    describe 'request method access via #own_request_methods/#derived_request_methods' do
      it 'inherits from parent scopes if not explicitly set' do
        parent.instance_variable_set(:@own_request_methods, [:get])
        child.derived_request_methods.should == [:get]
      end

      it 'overrides parent scopes if explicitly set' do
        parent.instance_variable_set(:@own_request_methods, [:get])
        child.instance_variable_set(:@own_request_methods, [:post])
        child.derived_request_methods.should == [:post]
      end
    end

    describe 'path via #own_relative_path/#derived_path' do
      it 'accepts a string' do
        parent.instance_variable_set(:@own_relative_path, '/foo')
        parent.derived_path.should match('/foo')
      end

      it 'defaults to an optional forward slash' do
        parent.derived_path.should == '/'
      end

      it 'builds recursively from parent scopes (by appending)' do
        parent.instance_variable_set(:@own_relative_path, '/foo')
        child.instance_variable_set(:@own_relative_path, '/bar')
        child.derived_path.should == '/foo/bar'
      end
    end

    describe 'path constraints via #own_relative_path_requirements/#derived_path_requirements' do
      let(:requirements) do
        { :foo => /bar/ }
      end

      it 'accepts a hash' do
        parent.instance_variable_set(:@own_relative_path_requirements, requirements)
        parent.derived_path_requirements.should == requirements
      end

      it 'builds recursively from parent scopes (by per-requirement override)' do
        parent.instance_variable_set(:@own_relative_path_requirements, { :foo => /bar/ })
        child.instance_variable_set(:@own_relative_path_requirements, { :baz => /bat/ })
        grandchild.instance_variable_set(:@own_relative_path_requirements, { :a => /b/ })
        grandchild.derived_path_requirements.should == { :foo => /bar/, :baz => /bat/, :a => /b/ }
      end
    end

    describe 'middleware via #own_stack/#derived_stack' do
      let(:parent_stack)     { [[mock('middleware1')], [mock('middleware2')], [mock('middleware3')]] }
      let(:child_stack)      { [[mock('middleware4')], [mock('middleware5')], [mock('middleware6')]] }
      let(:grandchild_stack) { [[mock('middleware7')], [mock('middleware8')], [mock('middleware9')]] }

      before do
        parent.instance_variable_set(:@own_stack, parent_stack)         # dsl: DSL::Domain
        child.instance_variable_set(:@own_stack, child_stack)           # dsl: DSL::App
        grandchild.instance_variable_set(:@own_stack, grandchild_stack) # dsl: DSL::App
      end

      it 'accepts an array of middleware arguments' do
        parent.derived_stack.should == parent_stack
        child.derived_stack.should == child_stack
        grandchild.derived_stack.should == child_stack + grandchild_stack
      end

      it 'builds recursively from parent scopes only of the same DSL (by appending)' do
        # Grandchild and parent use DSL::App and DSL::Domain, respectively,
        # so their middleware stacks are kept separate.
        parent_stack.each do |middleware|
          grandchild.derived_stack.should_not include(middleware)
        end

        (child_stack + grandchild_stack).each do |middleware|
          parent.derived_stack.should_not include(middleware)
        end
      end
    end
  end
end