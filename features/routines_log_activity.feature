Feature:  Routines log activity
  As a software routine
  I want log information
  So that a user may view my activity

  Scenario:  Simple console and default log warnings
    Given no existing log files for a name
    And some running code that wants to log to a name
    When the code warns about something
    Then I do see warning in the console
    And I do see warning in the default log

  Scenario:  Info when there is no configuration
    Given no existing log files for a name
    And some running code that wants to log to a name
    When the code informs us about something
    Then I do not see information in the console
    And I do see information in the default log

