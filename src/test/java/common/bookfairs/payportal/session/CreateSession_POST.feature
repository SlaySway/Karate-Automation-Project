@CreateSession
Feature: CreateSession GET api tests

  Background: Set config
    * def obj = Java.type('utils.StrictValidation')

  @Happy
  Scenario Outline: Verify CreateSession returns a successful 200 response status code for user: <USER_NAME> and fair: <FAIRID>
    Given def createSessionResponse = call read('RunnerHelper.feature@CreateSession')
    Then match createSessionResponse.responseStatus == 200

    @QA
    Examples:
      | FAIRID  | USER_NAME             | PASSWORD  |
      | 5633533 | azhou1@scholastic.com | password1 |

  @Unhappy
  Scenario Outline: Verify CreateSession returns 401 status code when not logged in
    # TODO

    @QA
    Examples:
      | fairId  |
      | fairId1 |
      | fairId2 |

  @Unhappy
  Scenario Outline: Verify CreateSession returns 401 status code when logged in with no parameters
    # TODO

    @QA
    Examples:
      | fairId      | loginCredentials  |
      | emptyFairId | loginCredentials1 |


  @Unhappy
  Scenario Outline: Verify CreateSession returns 401 status code when user doesn't have access to fair
    # TODO

    @QA
    Examples:
      | fairId      | loginCredentials  |
      | emptyFairId | loginCredentials1 |