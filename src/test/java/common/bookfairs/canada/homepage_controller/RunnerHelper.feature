@ignore @report=true
Feature: Helper for running homepage-controller apis

  Background: Set config
    * string getPublicHomepageUri = "/api/public/homepage/<homepageUrl>"

  #TODO: need to automate
  # Input: USER_NAME, PASSWORD, FAIR_ID
  # Output: response
  @GetFairSettings
  Scenario: Run begin fair session for user: <USER_NAME> and fair: <FAIR_ID>
    * replace getFairSettingsUri.resourceId = FAIR_ID
    * url CANADA_TOOLKIT_URL + getFairSettingsUri
    * cookies { userEmail : '#(USER_NAME)'}
    Then method GET