@ignore @report=true
Feature: Helper for running fair-settings-controller apis

  Background: Set config
    * string getFairSettingsUri = "/bookfairs-jarvis/api/user/fairs/current/settings"

    # Input: USER_NAME, PASSWORD, FAIR_ID
    # Output: response
    @GetFairSettingsRunner
    Scenario: Run GetFairsettings api with no other endpoint calls
      Given def loginAuthorizationResponse = call read('classpath:common/bookfairs/jarvis/login_authorization_controller/LoginAuthorizationRunnerHelper.feature@BeginFairSessionRunner'){USER_NAME : '#(USER_NAME)', PASSWORD : '#(PASSWORD)'}
      * print loginAuthorizationResponse
      Given url BOOKFAIRS_JARVIS_URL + getFairSettingsUri
      And cookies { SCHL : '#(loginAuthorizationResponse.SCHL)', SBF_JARVIS: '#(loginAuthorizationResponse.SBF_JARVIS)'}
      And method GET