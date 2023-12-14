@ignore @report=true
Feature: Helper for running session-controller endpoints

  Background: Set config
    * string createSessionUri = "/api/session"
    * string getSessionInfoUri = "/api/session"
    * string getSessionIdentifiersUri = "/api/session/identifiers"


  # Input: USER_NAME, PASSWORD, FAIRID
  # Output: response, SCHL, PP2
  @CreateSession
  Scenario: Run create payportal 2.0 session for user: <USER_NAME> and fair: <FAIRID>
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
    * param fairId = FAIRID
    * url BOOKFAIRS_PAYPORTAL_URL + createSessionUri
    * cookies { SCHL : '#(schlResponse.SCHL)'}
    Then method POST
    * def SCHL = schlResponse.SCHL
    * def PP2 = responseCookies["PP2.0"].value

  # Input: USER_NAME, PASSWORD, FAIRID
  # Output: response
  @GetSessionInfo
  Scenario: Run get session info for user: <USER_NAME> and fair: <FAIRID>
    Given def sessionResponse = call read('RunnerHelper.feature@CreateSession'){FAIR_ID: '#(FAIRID)'}
    * url BOOKFAIRS_PAYPORTAL_URL + getSessionInfoUri
    * cookies { SCHL : '#(sessionResponse.SCHL)', PP2.0:'#(sessionResponse.PP2)'}
    Then method GET

  # Input: USER_NAME, PASSWORD, FAIRID
  # Output: response
  @GetSessionIdentifiers
  Scenario: Run get session identigiers for user: <USER_NAME> and fair: <FAIRID>
    Given def sessionResponse = call read('RunnerHelper.feature@CreateSession'){FAIR_ID: '#(FAIRID)'}
    * replace getFairHomepageUri.fairIdOrCurrent = FAIRID_OR_CURRENT
    * url BOOKFAIRS_PAYPORTAL_URL + getSessionIdentifiersUri
    * cookies { SCHL : '#(sessionResponse.SCHL)', PP2.0:'#(sessionResponse.PP2)'}
    Then method GET