@ignore @report=true
Feature: Helper for running Before COA Accepted endpoints

  Background: Set config
    * string getJWTForCOAUri = "/bookfairs-jarvis/api/user/fairs/<fairIdOrCurrent>/coa/pdf-links"
   

  # Input: USER_NAME, PASSWORD, FAIRID_OR_CURRENT
  # Output: response
  @GetJWTForCOA
  Scenario: Get a JWT for COA
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
    And replace getJWTForCOAUri.fairIdOrCurrent = FAIRID_OR_CURRENT
    Given url BOOKFAIRS_JARVIS_URL + getJWTForCOAUri
    And cookies { SCHL : '#(schlResponse.SCHL)'}
    And method get

  # Input: USER_NAME, PASSWORD, FAIRID_OR_CURRENT
  # Output: response
  @GetJWTForCOABase
  Scenario: Get a JWT for COA
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunnerBase')
    And replace getJWTForCOAUri.fairIdOrCurrent = FAIRID_OR_CURRENT
    Given url BOOKFAIRS_JARVIS_BASE + getJWTForCOAUri
    And cookies { SCHL : '#(schlResponse.SCHL)'}
    And method get