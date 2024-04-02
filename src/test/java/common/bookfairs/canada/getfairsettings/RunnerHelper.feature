@ignore @report=true
Feature: Helper for running TO BE ANNOUNCED endpoints

  Background: Set config
    * string getFairSettingsUri = "/api/user/fairs/<resourceId>/settings"

  # TODO: dev incomplete
  # Input: USER_NAME, PASSWORD, FAIR_ID
  # Output: response
  @GetFairSettings
  Scenario: Run begin fair session for user: <USER_NAME> and fair: <FAIR_ID>
    * replace getFairSettingsUri.resourceId = FAIR_ID
    * url CANADA_TOOLKIT_URL + getFairSettingsUri
    Then method GET