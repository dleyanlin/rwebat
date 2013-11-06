Feature: Handling frames

Scenario: visit a site
    When I visit the site url
    Then I get the site url address "dbld.qa.webex.com"

Scenario: Currently use browser
    When I set option to "ie"
    Then I should seen that ie browser

Scenario: Attach popup windows
    When borwser pop up a windows and attach the title "Calendar"
    Then I get the windows title "Calendar"

Scenario: switch frame
    When have iframe in the page
    And switch the frame "mainFrame"
    Then the joinnow button exists