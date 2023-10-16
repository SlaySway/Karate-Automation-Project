@ignore @report=true
Feature: Helper for running SCHL login api

  # Input: USER_NAME, PASSWORD
  # Output: response.SCHL
  @SCHLCookieRunner
  Scenario: Login to IAM to obtain the SCHL cookie
    * def requestBody =
      """
      {
          "username" : '#(USER_NAME)',
          "password" : '#(PASSWORD)'
      }
      """
    Given url SCHL_LOGIN_URL
    And request requestBody
    And method POST
    And def SCHL = responseCookies.SCHL.value