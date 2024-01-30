@ignore @report=true
Feature: Helper for health-controller endpoints

  Background: Set config
    * string getServerHealthUri = "/health"

  # Output: response
  @GetServerHealth
  Scenario: Get the server health for ewallet2.0
    * url BOOKFAIRS_EWALLET_2_URL + getServerHealthUri
    Then method GET