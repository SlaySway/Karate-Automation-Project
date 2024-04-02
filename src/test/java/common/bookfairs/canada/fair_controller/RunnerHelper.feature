@ignore @report=true
Feature: Helper for running event_controller endpoints

  Background: Set config
    * string setFliersUri = "/api/user/fairs/<resourceId>/fliers"

  # TODO: dev incomplete
  # Input: USER_NAME, PASSWORD, FAIR_ID
  # Output: response
  @SetFliers
  Scenario: Run set fair fliers for user: <USER_NAME> and fair: <FAIR_ID>
    * replace setFliersUri.resourceId = FAIR_ID
    * url CANADA_TOOLKIT_URL + setFliersUri
    * request REQUEST_BODY
    * cookies { userEmail : '#(USER_NAME)'}
    Then method PUT