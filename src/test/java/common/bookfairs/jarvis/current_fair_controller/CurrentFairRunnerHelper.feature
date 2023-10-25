@ignore @report=true
Feature: Helper for running current-fair-controller apis

  Background: Set config
    * string beginFairSessionUri = "/bookfairs-jarvis/api/user/fairs/current"

  # Inputs: USER_NAME, PASSWORD, REQUEST_BODY
  # Outputs: response
  @SetUserFairsRunner
  Scenario: Run setUserFairs api
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
    Given url BOOKFAIRS_JARVIS_URL + beginFairSessionUri
    And cookies { SCHL : '#(schlResponse.SCHL)'}
    And request REQUEST_BODY
    When method put