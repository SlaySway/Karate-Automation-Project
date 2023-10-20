@ignore @report=true
Feature: Helper for running current-fair-controller apis

  Background: Set config
    * string beginFairSessionUri = "/bookfairs-jarvis/api/user/fairs/current"

  @setUserFairsRunner
  Scenario: Run setUserFairs api
    Given def loginAuthorizationResponse = call read('classpath:common/bookfairs/jarvis/login_authorization_controller/LoginAuthorizationRunnerHelper.feature@BeginFairSessionRunner'){USER_NAME : '#(USER_NAME)', PASSWORD : '#(PASSWORD)'}
    Given url BOOKFAIRS_JARVIS_URL + beginFairSessionUri
    And cookies { SCHL : '#(loginAuthorizationResponse.SCHL)', SBF_JARVIS: '#(loginAuthorizationResponse.SBF_JARVIS)'}
    * def jsonBody = {inputpayLoad : '#(jsonInput)'}
    And request jsonBody.inputpayLoad
    When method PUT