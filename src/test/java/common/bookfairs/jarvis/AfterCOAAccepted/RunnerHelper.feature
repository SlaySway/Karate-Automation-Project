@ignore @report=true
Feature: Helper for running Before COA Accepted endpoints

  Background: Set config
    * string getHomepageUri = "/bookfairs-jarvis/api/user/fairs/<fairIdOrCurrent>/homepage"

  # Input: USER_NAME, PASSWORD, FAIRID_OR_CURRENT
  # Output: response
  @GetHomepageDetails
  Scenario: Get Homepage Details for fair
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
    And replace getHomepageUri.fairIdOrCurrent = FAIRID_OR_CURRENT
    Given url BOOKFAIRS_JARVIS_URL + getHomepageUri
    And cookies { SCHL : '#(schlResponse.SCHL)'}
    And method get