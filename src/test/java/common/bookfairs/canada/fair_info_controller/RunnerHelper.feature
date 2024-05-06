@ignore @report=true
Feature: Helper for running event_controller endpoints

  Background: Set config
    * string getFairInfoUri = "/api/user/fairs/<resourceId>/homepage/fair-info"
    * string updateFairInfoUri = "/api/user/fairs/<resourceId>/homepage/fair-info"

  # Input: USER_NAME, PASSWORD, FAIR_ID
  # Output: response
  @GetFairInfo
  Scenario: Run get fair info for user: <USER_NAME> and fair: <FAIR_ID>
    * replace getFairInfoUri.resourceId = FAIR_ID
    * url CANADA_TOOLKIT_URL + getFairInfoUri
    * cookies { userEmail : '#(USER_NAME)'}
    Then method GET

  # Input: USER_NAME, PASSWORD, FAIR_ID, REQUEST_BODY
  # Output: response
  @UpdateFairInfo
  Scenario: Run update fair info for user: <USER_NAME> and fair: <FAIR_ID>
    * replace updateFairInfoUri.resourceId = FAIR_ID
    * url CANADA_TOOLKIT_URL + updateFairInfoUri
    * request REQUEST_BODY
    * cookies { userEmail : '#(USER_NAME)'}
    Then method PUT