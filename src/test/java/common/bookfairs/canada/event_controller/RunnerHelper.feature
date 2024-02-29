@ignore @report=true
Feature: Helper for running event_controller endpoints

  Background: Set config
    * string getFairEventsUri = "/api/user/fairs/<resourceId>/homepage/events"
    * string updateFairEventsUri = "/api/user/fairs/<resourceId>/homepage/events"

  # TODO: dev incomplete
  # Input: USER_NAME, PASSWORD, FAIR_ID
  # Output: response
  @GetFairEvents
  Scenario: Run get event fair event for user: <USER_NAME> and fair: <FAIR_ID>
    * replace getFairEventsUri.resourceId = FAIR_ID
    * url CANADA_TOOLKIT_URL + getFairEventsUri
    Then method GET

  # TODO: dev incomplete
  # Input: USER_NAME, PASSWORD, FAIR_ID, REQUEST_BODY
  # Output: response
  @UpdateFairEvents
  Scenario: Run create fair event for user: <USER_NAME> and password: <REQUEST_BODY.password>
    * replace updateFairEventsUri.resourceId = FAIR_ID
    * url CANADA_TOOLKIT_URL + updateFairEventsUri
    * request REQUEST_BODY
    Then method PUT