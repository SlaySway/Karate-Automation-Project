@ignore @report=true
Feature: Helper for running event_controller endpoints

  Background: Set config
    * string getFairEventsUri = "/api/user/fairs/<resourceId>/homepage/events"
    * string setFairEventsUri = "/api/user/fairs/<resourceId>/homepage/events"

  # TODO: dev incomplete
  # Input: USER_NAME, PASSWORD, FAIR_ID
  # Output: response
  @GetFairEvents
  Scenario: Run get event fair event for user: <USER_NAME> and fair: <FAIR_ID>
    * replace getFairEventsUri.resourceId = FAIR_ID
    * url CANADA_TOOLKIT_URL + getFairEventsUri
    * cookies { userEmail : '#(USER_NAME)'}
    Then method GET

  # TODO: dev incomplete
  # Input: USER_NAME, PASSWORD, FAIR_ID, REQUEST_BODY
  # Output: response
  @SetFairEvents
  Scenario: Run create fair event for user: <USER_NAME> and fair: <FAIR_ID>
    * replace setFairEventsUri.resourceId = FAIR_ID
    * url CANADA_TOOLKIT_URL + setFairEventsUri
    * request REQUEST_BODY
    * cookies { userEmail : '#(USER_NAME)'}
    Then method PUT