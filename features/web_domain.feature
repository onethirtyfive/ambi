Feature: Domain
  In order to code for the web
  As a developer
  I want to develop my domain

  Scenario: Naming a domain
    Given a file containing:
      """
      domain :'myblog.com'
      """
    When Ambi parses the file into a Rack-compatible app
    Then Ambi should be aware of the following domains:
      | domain     |
      | myblog.com |

  Scenario: Fleshing out a domain
    Given a file containing:
      """
      domain :'myblog.com' do
        mount :entries, at: '/entries'

        app :entries do
          expose! :index, via: :get
        end
      end
      """
    When Ambi parses the file into a Rack-compatible app
    And I visit "/entries" in domain "myblog.com"
    Then the response status should be "200 OK"