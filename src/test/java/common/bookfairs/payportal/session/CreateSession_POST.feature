@CreateSession
Feature: CreateSession GET api tests

  Background: Set config
    * def obj = Java.type('utils.StrictValidation')
    * string createSessionUri = "/api/session"

  @Happy
  Scenario Outline: Verify CreateSession returns a successful 200 response status code for user: <USER_NAME> and fair: <FAIRID>
    Given def createSessionResponse = call read('RunnerHelper.feature@CreateSession')
    Then match createSessionResponse.responseStatus == 200

    @QA
    Examples:
      | FAIRID  | USER_NAME              | PASSWORD |
      | 5694329 | mtodaro@scholastic.com | passw0rd |

  @Unhappy
  Scenario Outline: Verify CreateSession returns 401 status code when not logged in
    Given url BOOKFAIRS_PAYPORTAL_URL + createSessionUri
    * param fairId = FAIRID
    * url BOOKFAIRS_PAYPORTAL_URL + createSessionUri
    * cookies { SCHL : '#(schlResponse.SCHL)'}
    Then method POST
    Then match responseStatus == 401
    Then match response.errorMessage == "Not a valid session. Please make sure that a valid SCHL cookie is specified."

    @QA
    Examples:
      | FAIRID  |
      | 5694316 |
      | 5694329 |

  @Unhappy
  Scenario Outline: Verify CreateSession returns 401 status code when logged in with no parameters
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
    Given url BOOKFAIRS_PAYPORTAL_URL + createSessionUri
    * url BOOKFAIRS_PAYPORTAL_URL + createSessionUri
    * cookies { SCHL : '#(schlResponse.SCHL)'}
    Then method POST
    Then match responseStatus == 401
    Then match response.errorMessage ==  "FairId should be provided"

    @QA
    Examples:
      | FAIRID | USER_NAME                           | PASSWORD |
      |        | mtodaro@scholastic.com              | passw0rd |
      |        | sdevineni-consultant@scholastic.com | passw0rd |

  @Unhappy
  Scenario Outline: Verify CreateSession returns 401 status code when user doesn't have access to fair
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
    Given url BOOKFAIRS_PAYPORTAL_URL + createSessionUri
    * param fairId = FAIRID
    * url BOOKFAIRS_PAYPORTAL_URL + createSessionUri
    * cookies { SCHL : '#(schlResponse.SCHL)'}
    Then method POST
    Then match responseStatus == 401
    Then match response.errorMessage == "Invalid fair"

    @QA
    Examples:
      | FAIRID | USER_NAME                           | PASSWORD |
      | 569432 | mtodaro@scholastic.com              | passw0rd |
      | 569438 | sdevineni-consultant@scholastic.com | passw0rd |
