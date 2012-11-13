Feature: Domain
  In order to code for the web
  As a developer
  I want to develop my domain

  Background:
    Given a file containing:
      """
      domain :'myblog.com' do
        app :entries do
          given(via: :get) do
            at('/')    { route! :index }
            at('/:id') { route! :show  }
          end
        end
      end
      """

  Scenario: Defining a (tiny) domain
    When I call Ambi#parse, passing the file's contents
    And I access the resulting build for :'myblog.com' via Ambi#[]
    Then the resulting build should have 2 routes
