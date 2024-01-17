@GetSessionIdentifiers
Feature: GetSessionIdentifiers GET api tests

  Background: Set config
    * def obj = Java.type('utils.StrictValidation')
    * string getSessionIdentifiersUri = "/api/session/identifiers"

  @Happy
  Scenario Outline: Verify GetSessionIdentifiers returns a successful 200 response status code for user: <USER_NAME> and fair: <FAIRID>
    Given def getSessionIdentifiersResponse = call read('RunnerHelper.feature@GetSessionIdentifiers')
    Then match getSessionIdentifiersResponse.responseStatus == 200

    @QA
      Examples:
        | FAIRID  | USER_NAME              | PASSWORD |
        | 5694329 | mtodaro@scholastic.com | passw0rd |

  @Unhappy
  Scenario Outline: Verify SessionIdentifiers returns 401 status code when user is not logged in MyScholastic
    Given url BOOKFAIRS_PAYPORTAL_URL + getSessionIdentifiersUri
    * param FAIRID = FAIRID
    * url BOOKFAIRS_PAYPORTAL_URL + getSessionIdentifiersUri
    * cookies { SCHL : '#(schlResponse.SCHL)'}
    Then method GET
    Then match responseStatus == 401
    Then match response.errorMessage == "Not a valid session. Please make sure that a valid SCHL cookie is specified."

    @QA
    Examples:
      | FAIRID  |
      | 5694329 |
      | 5694298 |

  @Unhappy
  Scenario Outline: Verify SessionIdentifiers returns 401 status code when new fair session is not created
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
    Given url BOOKFAIRS_PAYPORTAL_URL + getSessionIdentifiersUri
    * url BOOKFAIRS_PAYPORTAL_URL + getSessionIdentifiersUri
    * cookies { SCHL : '#(schlResponse.SCHL)'}
    Then method GET
    Then match responseStatus == 401
    Then match response.errorMessage ==  "No valid fair. Please make sure that PP2.0 cookie is specified"

    @QA
    Examples:
      | USER_NAME                           | PASSWORD |
      | sdevineni-consultant@scholastic.com | passw0rd |
      | mtodaro@scholastic.com              | passw0rd |

    @Unhappy
    Scenario Outline: Verify SessionIdentifiers returns 401 status code when user doesn't have access to fair
      Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
      Given url BOOKFAIRS_PAYPORTAL_URL + getSessionIdentifiersUri
      * param fairId = FAIRID
      * url BOOKFAIRS_PAYPORTAL_URL + getSessionIdentifiersUri
      * cookies { SCHL : '#(schlResponse.SCHL)'}
      Then method GET
      Then match responseStatus == 401
      Then match response.errorMessage == "No valid fair. Please make sure that PP2.0 cookie is specified"

      @QA
      Examples:
        | FAIRID | USER_NAME                           | PASSWORD |
        | 569431 | mtodaro@scholastic.com              | passw0rd |
        | 569408 | sdevineni-consultant@scholastic.com | passw0rd |
