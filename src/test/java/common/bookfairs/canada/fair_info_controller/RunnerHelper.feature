@ignore @report=true
Feature: Helper for running event_controller endpoints

  Background: Set config
    * string getFairInfoUri = "/api/homepage/<fairId>/fairInfo"
    * string updateFairInfoUri = "/api/homepage/<fairId>/fairInfo"

  # TODO: dev incomplete
  # Input: USER_NAME, PASSWORD, FAIR_ID
  # Output: response
  @GetFairInfo
  Scenario: Run get fair contact info for user: <USER_NAME> and fair: <FAIR_ID>
    * replace getFairInfoUri.fairId = FAIR_ID
    * url CANADA_TOOLKIT_URL + getFairInfoUri
    Then method GET

  # TODO: dev incomplete
  # Input: USER_NAME, PASSWORD, FAIR_ID, REQUEST_BODY
  # Output: response
  @UpdateFairInfo
  Scenario: Run create fair event for user: <USER_NAME> and password: <REQUEST_BODY.password>
    * replace updateFairInfoUri.fairId = FAIR_ID
    * url CANADA_TOOLKIT_URL + updateFairInfoUri
    * request REQUEST_BODY
    Then method PUT