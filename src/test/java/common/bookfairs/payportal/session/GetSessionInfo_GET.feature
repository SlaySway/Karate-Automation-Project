@GetSessionInfo
Feature: GetSessionInfo GET api tests

  Background: Set config
    * def obj = Java.type('utils.StrictValidation')
    * string getSessionInfoUri = "/api/session"

  @Happy
  Scenario Outline: Verify GetSessionInfo returns a successful 200 response status code for user: <USER_NAME> and fair: <FAIRID>
    Given def getSessionInfoResponse = call read('RunnerHelper.feature@GetSessionInfo')
    Then match getSessionInfoResponse.responseStatus == 200

    @QA
    Examples:
      | FAIRID  | USER_NAME             | PASSWORD  |
      | 5633533 | azhou1@scholastic.com | password1 |

  @Regression @GETSessionInfo
  Scenario Outline: Verify SessionInfo returns 401 status code when user is not logged in myscholastic
    # TODO

    @QA
    Examples:
      | FAIRID  | USER_NAME             | PASSWORD  |
      | 5633533 | azhou1@scholastic.com | password1 |

  @Unhappy
  Scenario Outline: Verify SessionInfo returns 401 status code when a new fair session is not created
    # TODO

    @QA
    Examples:
      | FAIRID  | USER_NAME             | PASSWORD  |
      | 5633533 | azhou1@scholastic.com | password1 |