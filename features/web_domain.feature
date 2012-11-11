Feature: Domain
  In order to code for the web
  As a developer
  I want to develop my domain

  Background:
    Given a file containing:
      """
      domain :'myblog.com' do
        app :entries, at: '/entries' do
          expose :index,  via: :get
          expose :show,   via: :show, at: '/:id'
          expose :create, via: :post
        end
      end
      """

  Scenario: Naming a domain
    When I call Ambi#parse, passing the file's contents
    And I call Ambi::Build#new, passing the result of Ambi#parse
    Then the resulting Build should have the following attributes:
      | attribute | value         |
      | domain    | :'myblog'.com |
      | apps      | [:entries]    |
