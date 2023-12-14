@GetSessionIdentifiers
Feature: GetSessionIdentifiers GET api tests

  Background: Set config
    * def obj = Java.type('utils.StrictValidation')
    * string getSessionIdentifiersUri = "/api/session/identifiers"

  @Happy
  Scenario Outline: Verify GetSessionIdentifiers returns a successful 200 response status code for user: <USER_NAME> and fair: <FAIRID>
    # TODO

    @QA
    Examples:
      | FAIRID  | USER_NAME             | PASSWORD  |
      | 5633533 | azhou1@scholastic.com | password1 |

  @Unhappy
  Scenario Outline: Verify SessionIdentifiers returns 401 status code when user is not logged in MyScholastic
    # TODO

    @QA
    Examples:
      | FAIRID  | USER_NAME             | PASSWORD  |
      | 5633533 | azhou1@scholastic.com | password1 |

  @Unhappy
  Scenario Outline: Verify SessionIdentifiers returns 401 status code when new fair session is not created
    # TODO

    @QA
    Examples:
      | FAIRID  | USER_NAME             | PASSWORD  |
      | 5633533 | azhou1@scholastic.com | password1 |