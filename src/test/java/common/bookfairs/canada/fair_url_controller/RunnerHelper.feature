@ignore @report=true
Feature: Helper for running fair_url_controller endpoints

  Background: Set config
    * string getFairUrlUri = "/api/user/fairs/<resourceId>/homepage/fair-url"
    * string setFairUrlUri = "/api/user/fairs/<resourceId>/homepage/fair-url"

  # TODO: dev incomplete
  # Input: USER_NAME, PASSWORD, FAIR_ID
  # Output: response
  @GetFairUrl
  Scenario: Run get fair url for user: <USER_NAME> and fair: <FAIR_ID>
    * replace getFairUrlUri.resourceId = FAIR_ID
    * url CANADA_TOOLKIT_URL + getFairUrlUri
    * cookies { userEmail : '#(USER_NAME)'}
    Then method GET

  # TODO: dev incomplete
  # Input: USER_NAME, PASSWORD, FAIR_ID, REQUEST_BODY
  # Output: response
  @SetFairUrl
  Scenario: Run set fair url for user: <USER_NAME> and fair: <FAIR_ID>
    * replace setFairUrlUri.resourceId = FAIR_ID
    * url CANADA_TOOLKIT_URL + setFairUrlUri
    * request REQUEST_BODY
    * cookies { userEmail : '#(USER_NAME)'}
    Then method PUT