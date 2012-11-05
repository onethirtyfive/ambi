require 'spec_helper'

module Ambi
  describe Scope do 
    let(:parent) { Scope.new(DSL::Domain) }
    let(:child)  { Scope.new(DSL::App, parent) }

    describe 'domain exposure via #_domain' do
      it 'inherits if not explicitly set' do
        parent._domain = :'otherblog.org'
        child._domain.should == :'otherblog.org'
      end

      it 'overrides if explicitly set' do
        parent._domain = :'myblog.com'
        child._domain  = :'otherblog.org'
        child._domain.should == :'otherblog.org'
      end
    end

    describe 'request method access via #request_methods, #request_method' do
      it 'inherits if not explicitly set' do
        parent.request_method = :get
        child.request_methods.should == [:get]
      end

      it 'overrides if explicitly set' do
        parent.request_method = :get
        child.request_method  = :post
        child.request_methods.should == [:post]
      end
    end

    describe 'path matcher exposure via #relative_path_matcher, #path_matcher' do
      it 'accepts a string' do
        parent.relative_path_matcher = '/foo'
        parent.path_matcher.should match('/foo')
      end

      it 'accepts a regular expression' do
        parent.relative_path_matcher = %r{/[a-z]+}
        parent.path_matcher.should match('/foo')
        parent.path_matcher.should_not match('/123')
      end

      it 'defaults to an optional forward slash' do
        parent.path_matcher.should match('/')
        parent.path_matcher.should match('')
        parent.path_matcher.should_not match('something else')
      end

      it 'builds from parent (by appending)' do
        parent.relative_path_matcher = %r{/foo/?}
        child.relative_path_matcher  = '/bar'
        child.path_matcher.should match('/foo/bar')
        child.path_matcher.should_not match('/foo/will')
      end
    end
  end
end