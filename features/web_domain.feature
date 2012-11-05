Feature: Domain
  In order to code for the web
  As a developer
  I want to develop my domain

  Scenario: Specifying a domain
    Given a file "domain.rb" with:
      """
        domain 'myblog.com'
      """
    When I parse it with:
      """
        source = File.read("domain.rb")
        Ambi.parse!(source)
      """
    And I obtain a result with:
      """
        Ambi::Domain.all
      """
    Then result should be a hash containing the following keys:
      | domain     |
      | myblog.com |