Feature: Search function in Google
 
  Scenario: Find what I'm looking for
    Given i am on the "input" search page
    When i enter "webex" into input field
    And  i click search button in the search page
    Then i should see link is "WebEx" in search result