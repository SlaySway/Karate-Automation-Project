#Author: Ravindra Pallerla

@ignore @report=true
Feature: Helper for running current-fair-controller apis

  Background: Set config
    * string externalSCHCookieUri = "/api/login"
    * string beginFairSessionUri = "/bookfairs-jarvis/api/login/userAuthorization/fairs"
    * string setUserFairsUrl = "/bookfairs-jarvis/api/user/fairs/current"

  @setUserFairsRunner
  Scenario: Run setUserFairs api
    * def reqBody =
      """
      {
          "username" : '#(USER_ID)',
          "password" : '#(PWD)'
      }
      """
    Given url EXTERNAL_SCH_COOKIE_URL + externalSCHCookieUri
    And headers {Content-Type : 'application/json'}
    And request reqBody
    And method post
    And def SCHL_SESSION = 'SCHL='+responseCookies.SCHL.value
    Given url BOOKFAIRS_JARVIS_URL + setUserFairsUrl
    And headers {Content-Type : 'application/json', Cookie : '#(SCH_Cookie)'}
    * def jsonBody = {inputpayLoad : '#(jsonInput)'}
    And request jsonBody.inputpayLoad
    When method PUT
    Then def StatusCode = responseStatus
    And def ResponseString = response