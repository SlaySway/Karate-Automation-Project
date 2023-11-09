@ignore @report=true
Feature: Helper for running SCHL login api

  Background: set config
    * string loginUri = '/api/login'

  # Input: USER_NAME, PASSWORD
  # Output: response, SCHL
  # schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner'){USER_NAME : '#(USER_NAME)', PASSWORD : '#(PASSWORD)'}
  @SCHLCookieRunner
  Scenario: Login to IAM to obtain the SCHL cookie
    * def requestBody =
      """
      {
          "username" : '#(USER_NAME)',
          "password" : '#(PASSWORD)'
      }
      """
    Given url SCHL_LOGIN_URL + loginUri
    And request requestBody
    And method post
    And def SCHL = responseCookies.SCHL.value

  # Input: USER_NAME, PASSWORD
  # Output: response, SCHL
  @SCHLCookieRunnerBase
  Scenario: Login to IAM to obtain the SCHL cookie
    * def requestBody =
      """
      {
          "username" : '#(USER_NAME)',
          "password" : '#(PASSWORD)'
      }
      """
    Given url SCHL_LOGIN_BASE + loginUri
    And request requestBody
    And method post
    And def SCHL = responseCookies.SCHL.value