@ignore @report=true
Feature: Helper for running fair_selector endpoints

  Background: Set config
    * string beginFairSessionUri = "/api/user/fairs/<resourceId>"
    * string getFairSessionInfoUri = "/api/user/fairs"

  # TODO: dev incomplete
  # Input: USER_NAME, PASSWORD, FAIR_ID
  # Output: response
  @BeginFairSession
  Scenario: Run begin fair session for user: <USER_NAME> and fair: <FAIR_ID>
    * replace beginFairSessionUri.resourceId = FAIR_ID
    * url CANADA_TOOLKIT_URL + beginFairSessionUri
    * param mode = "SELECT"
    Then method GET

  # TODO: dev incomplete
  # Input: some kind of user cookie
  # Output: response
  @GetFairSessionInfo
  Scenario: Run create fair event for user: <USER_NAME> and password: <REQUEST_BODY.password>
    * url CANADA_TOOLKIT_URL + getFairSessionInfoUri
    * request REQUEST_BODY
    Then method GET