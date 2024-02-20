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
      | 5694329 | mtodaro@scholastic.com | passw0rd |

  @Unhappy @GETSessionInfo
  Scenario Outline: Verify SessionInfo returns 401 status code when user is not logged in myscholastic
    Given url BOOKFAIRS_PAYPORTAL_URL + getSessionInfoUri
    * url BOOKFAIRS_PAYPORTAL_URL + getSessionInfoUri
    * cookies { SCHL : '#(schlResponse.SCHL)'}
    Then method GET
    Then match responseStatus == 401
    Then match response.errorMessage == "Not a valid session. Please make sure that a valid SCHL cookie is specified."

    @QA
    Examples:
      | FAIRID  |
      | 5694316 |
      | 5694329 |

  @Unhappy
  Scenario Outline: Verify SessionInfo returns 401 status code when a new fair session is not created
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
    Given url BOOKFAIRS_PAYPORTAL_URL + getSessionInfoUri
#    * param FAIRID = FAIRID
    * url BOOKFAIRS_PAYPORTAL_URL + getSessionInfoUri
    * cookies { SCHL : '#(schlResponse.SCHL)'}
    Then method GET
    Then match responseStatus == 401
    Then match response.errorMessage ==  "No valid fair. Please make sure that PP2.0 cookie is specified"

    @QA
    Examples:
      | FAIRID | USER_NAME              | PASSWORD |
      | 563353 | mtodaro@scholastic.com | passw0rd |

  @Happy
  Scenario Outline: Verify GetSessionInfo returns proper sales amounts for user: <USER_NAME> and fair: <FAIRID>
    Given def getSessionInfoResponse = call read('RunnerHelper.feature@GetSessionInfo')
    Then match getSessionInfoResponse.responseStatus == 200


    @QA
    Examples:
      | FAIRID | USER_NAME              | PASSWORD |
      | 5694329 | mtodaro@scholastic.com | passw0rd |