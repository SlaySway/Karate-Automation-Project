@ignore @report=true
Feature: Helper for running co-chairs-controller apis

  Background: Set config
    * string setCoChairsUri = "/bookfairs-jarvis/api/private/fairs/current/settings/co-chairs"

  # Inputs: USER_NAME, PASSWORD, FAIR_ID, REQUEST_BODY
  # Outputs: response
  @SetCoChairsRunner
  Scenario: Run co-chairs api
    Given def loginAuthorizationResponse = call read('classpath:common/bookfairs/jarvis/login_authorization_controller/LoginAuthorizationRunnerHelper.feature@BeginFairSessionRunner'){USER_NAME : '#(USER_NAME)', PASSWORD : '#(PASSWORD)'}
    Given url BOOKFAIRS_JARVIS_URL + setCoChairsUri
    And cookies { SCHL : '#(loginAuthorizationResponse.SCHL)', SBF_JARVIS: '#(loginAuthorizationResponse.SBF_JARVIS)'}
    And request REQUEST_BODY
    When method put
