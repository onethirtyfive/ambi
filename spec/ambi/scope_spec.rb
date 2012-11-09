require 'spec_helper'

module Ambi
  describe Scope do 
    let(:parent)     { Scope.new }
    let(:child)      { Scope.new(parent: parent) }
    let(:grandchild) { Scope.new(parent: child)  }

    describe 'middleware via #own_stack/#stack_for' do
      let(:parent_stack)     { [[mock('middleware1')], [mock('middleware2')], [mock('middleware3')]] }
      let(:child_stack)      { [[mock('middleware4')], [mock('middleware5')], [mock('middleware6')]] }
      let(:grandchild_stack) { [[mock('middleware7')], [mock('middleware8')], [mock('middleware9')]] }

      before do
        parent.instance_variable_set(:@own_stack, parent_stack)
        child.instance_variable_set(:@own_stack, child_stack)
        grandchild.instance_variable_set(:@own_stack, grandchild_stack)
      end

      it 'always builds the same domain stack' do
        [parent, child, grandchild].each do |scope|
          scope.stack_for(:domain).should == parent_stack
        end
      end

      it 'builds recursively a scope-specific stack from parent scopes (by appending)' do
        # Grandchild and parent use DSL::App and DSL::Domain, respectively,
        # so their middleware stacks are kept separate.
        parent_stack.each do |middleware|
          grandchild.stack_for(:app).should_not include(middleware)
        end

        (child_stack + grandchild_stack).each do |middleware|
          parent.stack_for(:domain).should_not include(middleware)
          parent.stack_for(:app).should_not include(middleware)
        end
      end
    end

    describe 'domain via #own_domain/#domain' do
      it 'raises an error if neither explicitly set nor inherited' do
        expect {
          child.domain
        }.to raise_error(Scope::NoDomainError)
      end

      it 'inherits from parent scopes if not explicitly set' do
        parent.instance_variable_set(:@own_domain, :'otherblog.org')
        child.domain.should == :'otherblog.org'
      end

      it 'overrides parent scopes if explicitly set' do
        parent.instance_variable_set(:@own_domain, :'myblog.com')
        child.instance_variable_set(:@own_domain, :'otherblog.org')
        child.domain.should == :'otherblog.org'
      end
    end

    describe 'app via #own_app/#app' do
      it 'raises an error if neither explicitly set nor inherited' do
        expect {
          child.app
        }.to raise_error(Scope::NoAppError)
      end

      it 'inherits from parent scopes if not explicitly set' do
        parent.instance_variable_set(:@own_app, :entries)
        child.app.should == :entries
      end

      it 'overrides parent scopes if explicitly set' do
        parent.instance_variable_set(:@own_app, :entries)
        child.instance_variable_set(:@own_app, :comments)
        child.app.should == :comments
      end
    end

    describe 'request method via #own_request_methods/#request_methods' do
      it 'inherits from parent scopes if not explicitly set' do
        parent.instance_variable_set(:@own_request_methods, [:get])
        child.request_methods.should == [:get]
      end

      it 'overrides parent scopes if explicitly set' do
        parent.instance_variable_set(:@own_request_methods, [:get])
        child.instance_variable_set(:@own_request_methods, [:post])
        child.request_methods.should == [:post]
      end
    end

    describe 'path via #own_relative_path/#path' do
      it 'accepts a string' do
        parent.instance_variable_set(:@own_relative_path, '/foo')
        parent.path.should match('/foo')
      end

      it 'defaults to an optional forward slash' do
        parent.path.should == '/'
      end

      it 'builds recursively from parent scopes (by appending)' do
        parent.instance_variable_set(:@own_relative_path, '/foo')
        child.instance_variable_set(:@own_relative_path, '/bar')
        child.path.should == '/foo/bar'
      end
    end

    describe 'path constraints via #own_relative_path_requirements/#path_requirements' do
      let(:requirements) do
        { foo: /bar/ }
      end

      it 'accepts a hash' do
        parent.instance_variable_set(:@own_relative_path_requirements, requirements)
        parent.path_requirements.should == requirements
      end

      it 'builds recursively from parent scopes (by per-requirement override)' do
        parent.instance_variable_set(:@own_relative_path_requirements, { foo: /bar/ })
        child.instance_variable_set(:@own_relative_path_requirements, { baz: /bat/ })
        grandchild.instance_variable_set(:@own_relative_path_requirements, { a: /b/ })
        grandchild.path_requirements.should == { foo: /bar/, baz: /bat/, a: /b/ }
      end
    end
  end
end