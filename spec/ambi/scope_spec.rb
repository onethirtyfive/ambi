require 'spec_helper'

module Ambi
  describe Scope do 
    let(:domain_scope)   { Scope.new(DSL::Domain) }
    let(:app_scope)      { Scope.new(DSL::App, parent: domain_scope) }
    let(:endpoint_scope) { Scope.new(DSL::Endpoint, parent: app_scope) }

    describe '#initialize' do
      it 'evaluates any provided block in instance context' do
        Scope.any_instance.should_receive(:rock_the_suburbs!).once
        Scope.new(DSL::App) do
          rock_the_suburbs!
        end
      end
    end

    describe 'stack via #own_stack/#stack' do
      let(:domain_scope_stack) { [[mock('middleware1')], [mock('middleware2')], [mock('middleware3')]] }
      let(:app_scope_stack)    { [[mock('middleware4')], [mock('middleware5')], [mock('middleware6')]] }
      let(:endpoint_stack)     { [[mock('middleware7')], [mock('middleware8')], [mock('middleware9')]] }

      before do
        domain_scope.instance_variable_set(:@own_stack, domain_scope_stack)
        app_scope.instance_variable_set(:@own_stack, app_scope_stack)
        endpoint_scope.instance_variable_set(:@own_stack, endpoint_stack)
      end

      it 'always builds the same domain stack' do
        [domain_scope, app_scope, endpoint_scope].each do |scope|
          scope.stack(:domain).should == domain_scope_stack
        end
      end

      it 'builds recursively a scope-specific stack from parent scopes (by appending)' do
        # Grandchild and parent use DSL::App and DSL::Domain, respectively,
        # so their middleware stacks are kept separate.
        domain_scope_stack.each do |middleware|
          endpoint_scope.stack(:app).should_not include(middleware)
        end

        (app_scope_stack + endpoint_stack).each do |middleware|
          domain_scope.stack(:domain).should_not include(middleware)
          domain_scope.stack(:app).should_not include(middleware)
        end
      end
    end

    describe 'domain via #own_domain/#domain' do
      it 'raises an error if neither explicitly set nor inherited' do
        expect {
          endpoint_scope.domain
        }.to raise_error(Scope::NoDomainError)
      end

      it 'inherits from parent scopes if not explicitly set' do
        domain_scope.instance_variable_set(:@own_domain, :'otherblog.com')
        app_scope.domain.should == :'otherblog.com'
      end

      it 'overrides parent scopes if explicitly set' do
        domain_scope.instance_variable_set(:@own_domain, :'myblog.com')
        app_scope.instance_variable_set(:@own_domain, :'otherblog.com')
        app_scope.domain.should == :'otherblog.com'
      end
    end

    describe 'app via #own_app/#app' do
      it 'raises an error if neither explicitly set nor inherited' do
        expect {
          app_scope.app
        }.to raise_error(Scope::NoAppError)
      end

      it 'inherits from parent scopes if not explicitly set' do
        domain_scope.instance_variable_set(:@own_app, :entries)
        app_scope.app.should == :entries
      end

      it 'overrides parent scopes if explicitly set' do
        domain_scope.instance_variable_set(:@own_app, :entries)
        app_scope.instance_variable_set(:@own_app, :comments)
        app_scope.app.should == :comments
      end
    end

    describe 'name via #own_name/#name' do
      let(:domain_name)   { :'myblog.com' }
      let(:app_name)      { :entries }
      let(:endpoint_name) { :index   } 

      before do
        domain_scope.instance_variable_set(:@own_name, domain_name)
        app_scope.instance_variable_set(:@own_name, app_name)
        endpoint_scope.instance_variable_set(:@own_name, endpoint_name)
      end

      it 'builds recursively a scope-specific name from parent scopes (by appending)' do
        # [:'myblog.com', :entries, :index]
        endpoint_scope.name(:domain).should include(domain_name)
        endpoint_scope.name(:domain).should include(app_name)
        endpoint_scope.name(:domain).should include(endpoint_name)

        # [:entries, :index]
        endpoint_scope.name(:app).should_not include(domain_name)
        endpoint_scope.name(:app).should     include(app_name)
        endpoint_scope.name(:app).should     include(endpoint_name)

        # [:index]
        endpoint_scope.name(:endpoint).should_not include(domain_name)
        endpoint_scope.name(:endpoint).should_not include(app_name)
        endpoint_scope.name(:endpoint).should     include(endpoint_name)
      end
    end

    describe 'request method via #own_request_methods/#request_methods' do
      it 'inherits from parent scopes if not explicitly set' do
        domain_scope.instance_variable_set(:@own_request_methods, [:get])
        app_scope.request_methods.should == [:get]
      end

      it 'overrides parent scopes if explicitly set' do
        domain_scope.instance_variable_set(:@own_request_methods, [:get])
        app_scope.instance_variable_set(:@own_request_methods, [:post])
        app_scope.request_methods.should == [:post]
      end
    end

    describe 'path via #own_relative_path/#path' do
      it 'accepts a string' do
        domain_scope.instance_variable_set(:@own_relative_path, '/foo')
        domain_scope.path.should match('/foo')
      end

      it 'defaults to an optional forward slash' do
        domain_scope.path.should == '/'
      end

      it 'builds recursively from parent scopes (by appending)' do
        domain_scope.instance_variable_set(:@own_relative_path, '/foo')
        app_scope.instance_variable_set(:@own_relative_path, '/bar')
        endpoint_scope.path.should == '/foo/bar'
      end
    end

    describe 'path constraints via #own_relative_path_requirements/#path_requirements' do
      let(:requirements) do
        { foo: /bar/ }
      end

      it 'accepts a hash' do
        domain_scope.instance_variable_set(:@own_relative_path_requirements, requirements)
        domain_scope.path_requirements.should == requirements
      end

      it 'builds recursively from parent scopes (by per-requirement override)' do
        domain_scope.instance_variable_set(:@own_relative_path_requirements, { foo: /bar/ })
        app_scope.instance_variable_set(:@own_relative_path_requirements, { baz: /bat/ })
        endpoint_scope.instance_variable_set(:@own_relative_path_requirements, { a: /b/ })
        endpoint_scope.path_requirements.should == { foo: /bar/, baz: /bat/, a: /b/ }
      end
    end
  end
end