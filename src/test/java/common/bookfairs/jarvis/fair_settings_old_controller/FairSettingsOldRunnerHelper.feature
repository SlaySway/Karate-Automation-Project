@ignore @report=true
Feature: Helper for running fair-settings-controller apis

  Background: Set config
    * string putOnlineFairToggleUri = "/bookfairs-jarvis/api/private/fairs/current/onlinefair/toggle"
    * string putEnableEwalletUri = "/bookfairs-jarvis/api/private/fairs/current/ewallet/enable"
    * string postDisableEwalletUri = "/bookfairs-jarvis/api/private/fairs/current/ewallet/disable"

  # Input: USER_NAME, PASSWORD, FAIR_ID
  @PutOnlineFairToggleRunner
  Scenario: Run OnlineFairToggle api
    Given def loginAuthorizationResponse = call read('classpath:common/bookfairs/jarvis/login_authorization_controller/LoginAuthorizationRunnerHelper.feature@BeginFairSessionRunner'){USER_NAME : '#(USER_NAME)', PASSWORD : '#(PASSWORD)'}
    Given url BOOKFAIRS_JARVIS_URL + putOnlineFairToggleUri
    And cookies { SCHL : '#(loginAuthorizationResponse.SCHL)', SBF_JARVIS: '#(loginAuthorizationResponse.SBF_JARVIS)'}
    When method PUT

  # Input: USER_NAME, PASSWORD, FAIR_ID
  @PutEnableEwalletRunner
  Scenario: Run EnableEwallet api
    Given def loginAuthorizationResponse = call read('classpath:common/bookfairs/jarvis/login_authorization_controller/LoginAuthorizationRunnerHelper.feature@BeginFairSessionRunner'){USER_NAME : '#(USER_NAME)', PASSWORD : '#(PASSWORD)'}
    Given url BOOKFAIRS_JARVIS_URL + putEnableEwalletUri
    And cookies { SCHL : '#(loginAuthorizationResponse.SCHL)', SBF_JARVIS: '#(loginAuthorizationResponse.SBF_JARVIS)'}
    When method PUT

  # Input: USER_NAME, PASSWORD, FAIR_ID
  @PostDisableEwalletRunner
  Scenario: Run DisableEwallet api
    Given def loginAuthorizationResponse = call read('classpath:common/bookfairs/jarvis/login_authorization_controller/LoginAuthorizationRunnerHelper.feature@BeginFairSessionRunner'){USER_NAME : '#(USER_NAME)', PASSWORD : '#(PASSWORD)'}
    Given url BOOKFAIRS_JARVIS_URL + postDisableEwalletUri
    And cookies { SCHL : '#(loginAuthorizationResponse.SCHL)', SBF_JARVIS: '#(loginAuthorizationResponse.SBF_JARVIS)'}
    When method POST
