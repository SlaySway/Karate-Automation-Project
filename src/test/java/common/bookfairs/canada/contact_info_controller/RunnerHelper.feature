@ignore @report=true
Feature: Helper for running event_controller endpoints

  Background: Set config
    * string getFairContactInfoUri = "/api/homepage/<fairId>/contactInfo"
    * string updateFairContactInfoUri = "/api/homepage/<fairId>/contactInfo"

  # TODO: dev incomplete
  # Input: USER_NAME, PASSWORD, FAIR_ID
  # Output: response
  @GetFairContactInfo
  Scenario: Run get fair contact info for user: <USER_NAME> and fair: <FAIR_ID>
    * replace getFairContactInfoUri.fairId = FAIR_ID
    * url CANADA_TOOLKIT_URL + getFairContactInfoUri
    Then method GET

  # TODO: dev incomplete
  # Input: USER_NAME, PASSWORD, FAIR_ID, REQUEST_BODY
  # Output: response
  @UpdateFairContactInfo
  Scenario: Run create fair event for user: <USER_NAME> and password: <REQUEST_BODY.password>
    * replace updateFairContactInfoUri.fairId = FAIR_ID
    * url CANADA_TOOLKIT_URL + updateFairContactInfoUri
    * request REQUEST_BODY
    Then method PUT