@ignore @report=true
Feature: Helper for running coa-controller apis

  Background: Set config
    * string confirmCOAUri = "/api/user/fairs/current/coa/confirmation"
    * string getCOAConfirmUri = "/api/private/fairs/current/coa"

  # Input: USER_ID, PWD, FAIR_ID
  # Output: response
  @getCoaConfirmBase
  Scenario: Run getCOAConfirmation api in base environment
    Given def loginAuthorizationResponse = call read('classpath:common/bookfairs/jarvis/login_authorization_controller/LoginAuthorizationRunnerHelper.feature@BeginFairSessionRunner'){USER_NAME : '#(USER_NAME)', PASSWORD : '#(PASSWORD)'}
    Given url BOOKFAIRS_JARVIS_BASE + getCOAConfirmUri
    And cookies { SCHL : '#(loginAuthorizationResponse.SCHL)', SBF_JARVIS: '#(loginAuthorizationResponse.SBF_JARVIS)'}
    When method get

  # Input: USER_ID, PWD, FAIR_ID
  # Output: response 
  @getCoaConfirmTarget
  Scenario: Run getCOAConfirmation api in target environment
    Given def loginAuthorizationResponse = call read('classpath:common/bookfairs/jarvis/login_authorization_controller/LoginAuthorizationRunnerHelper.feature@BeginFairSessionRunnerTarget'){USER_NAME : '#(USER_NAME)', PASSWORD : '#(PASSWORD)'}
    Given url BOOKFAIRS_JARVIS_TARGET + getCOAConfirmUri
    And cookies { SCHL : '#(loginAuthorizationResponse.SCHL)', SBF_JARVIS: '#(loginAuthorizationResponse.SBF_JARVIS)'}
    When method get

  # Input: USER_ID, PWD, FAIR_ID
  # Output: response
  @confirmCoaRunner
  Scenario: Run ConfirmCOA api
    Given def loginAuthorizationResponse = call read('classpath:common/bookfairs/jarvis/login_authorization_controller/LoginAuthorizationRunnerHelper.feature@BeginFairSessionRunnerTarget'){USER_NAME : '#(USER_NAME)', PASSWORD : '#(PASSWORD)'}
    Given url BOOKFAIRS_JARVIS_URL + confirmCOAUri
    And cookies {SCHL : '#(BFS_SCHL)', SBF_JARVIS : '#(JARVIS_FAIR_SESSION)'}
    When method put
    Then def StatusCode = responseStatus
    And def ResponseString = response