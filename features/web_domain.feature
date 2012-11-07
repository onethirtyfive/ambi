Feature: Domain
  In order to code for the web
  As a developer
  I want to develop my domain

  Background:
    Given a file containing:
      """
      domain :'myblog.com' do
        mount :entries, at: '/entries'

        app :entries do
          expose! :index, via: :get do
            # do nothing
          end
        end
      end
      """

  Scenario: Naming a domain
    When I parse the file with Ambi
    Then Ambi should be aware of the following domains:
      | domain     |
      | myblog.com |

  Scenario: Fleshing out a domain
    When I parse the file with Ambi
    And I tell Ambi to build "myblog.com"
    And I visit "/entries"
    Then the response status should be "200 OK"