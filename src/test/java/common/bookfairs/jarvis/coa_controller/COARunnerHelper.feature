@ignore @report=true
Feature: Helper for running coa-controller apis

  Background: Set config
    * string confirmCOAUri = "/bookfairs-jarvis/api/user/fairs/current/coa/confirmation"
    * string getCOAUri = "/bookfairs-jarvis/api/private/fairs/current/coa"

  # Input: USER_ID, PASSWORD, FAIR_ID
  # Output: response
  @GetCOARunner
  Scenario: Run GetCOA api in target environment
    Given def loginAuthorizationResponse = call read('classpath:common/bookfairs/jarvis/login_authorization_controller/LoginAuthorizationRunnerHelper.feature@BeginFairSessionRunner'){USER_NAME : '#(USER_NAME)', PASSWORD : '#(PASSWORD)'}
    Given url BOOKFAIRS_JARVIS_TARGET + getCOAUri
    And cookies { SCHL : '#(loginAuthorizationResponse.SCHL)', SBF_JARVIS: '#(loginAuthorizationResponse.SBF_JARVIS)'}
    When method get

  # Input: USER_ID, PASSWORD, FAIR_ID
  # Output: response
  @GetCOABase
  Scenario: Run GetCOA api in base environment
    Given def loginAuthorizationResponse = call read('classpath:common/bookfairs/jarvis/login_authorization_controller/LoginAuthorizationRunnerHelper.feature@BeginFairSessionBase'){USER_NAME : '#(USER_NAME)', PASSWORD : '#(PASSWORD)'}
    Given url BOOKFAIRS_JARVIS_BASE + getCOAUri
    And cookies { SCHL : '#(loginAuthorizationResponse.SCHL)', SBF_JARVIS: '#(loginAuthorizationResponse.SBF_JARVIS)'}
    When method get

  # Input: USER_ID, PASSWORD, FAIR_ID
  # Output: response
  @ConfirmCoaRunner
  Scenario: Run ConfirmCOA api
    Given def loginAuthorizationResponse = call read('classpath:common/bookfairs/jarvis/login_authorization_controller/LoginAuthorizationRunnerHelper.feature@BeginFairSessionRunnerTarget'){USER_NAME : '#(USER_NAME)', PASSWORD : '#(PASSWORD)'}
    Given url BOOKFAIRS_JARVIS_URL + confirmCOAUri
    And cookies {SCHL : '#(BFS_SCHL)', SBF_JARVIS : '#(JARVIS_FAIR_SESSION)'}
    When method put