Feature: Domain
  In order to code for the web
  As a developer
  I want to develop my domain

  Background:
    Given a domain definition:
      """
      domain :'myblog.com' do
        mounting :entries, on: '/entries' do
          via :get do
            at('/')    { route! :index }
            at('/:id') { route! :show  }
          end
        end
      end
      """
    And a call to Ambi#parse on this domain definition

  Scenario: Defining a domain
    When I access the new :'myblog.com' build via Ambi#[]
    Then it should have 2 routes

  Scenario: Mounting the domain
    When I call #to_app on the resulting build for :'myblog.com'
    And I issue a GET on "/entries/2"
    Then the response status should be 501
    And the response should have the following headers:
      | name         | value      |
      | Content-Type | text/plain |
    And the response body should be:
      """
      Not Implemented
      """

