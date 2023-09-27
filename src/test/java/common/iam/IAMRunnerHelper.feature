@ignore @report=true
Feature: Helper for running SCHL login api

  # Input: USER_ID, PWD
  # Output: response.SCHL
  @SCHLCookieRunner
  Scenario: Login to IAM to obtain the SCHL cookie
    * def reqBody =
      """
      {
          "username" : '#(USER_ID)',
          "password" : '#(PWD)'
      }
      """
    Given url SCHL_LOGIN_URL
    And request reqBody
    And method POST
    And def SCHL = "SCHL=" + responseCookies.SCHL.value