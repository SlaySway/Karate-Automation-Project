@ignore @report=true
Feature: Helper for running event_controller endpoints

  Background: Set config
    * string getFairEventsUri = "/api/fairs/<fairId>/events"
    * string createFairEventsUri = "/api/fairs/<fairId>/events"

  # TODO: dev incomplete
  # Input: USER_NAME, PASSWORD, FAIR_ID
  # Output: response
  @GetFairEvents
  Scenario: Run get event fair event for user: <USER_NAME> and fair: <FAIR_ID>
    * replace getFairEventsUri.fairId = FAIR_ID
    * url CANADA_TOOLKIT_URL + getFairEventsUri
    Then method GET

  # TODO: dev incomplete
  # Input: USER_NAME, PASSWORD, FAIR_ID, REQUEST_BODY
  # Output: response
  @CreateFairEvents
  Scenario: Run create fair event for user: <USER_NAME> and password: <REQUEST_BODY.password>
    * replace createFairEventsUri.fairId = FAIR_ID
    * url CANADA_TOOLKIT_URL + createFairEventsUri
    * request REQUEST_BODY
    Then method PUT