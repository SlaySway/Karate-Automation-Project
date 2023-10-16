@ignore @report=true
Feature: Helper for running homepage-controller apis

  Background: Set config
    * string externalSCHLCookieUri = "/api/login"
    * string beginFairSessionUri = "/api/login/userAuthorization/fairs"
    * string getHomepageDetailsUri = "/api/user/fairs"

  # Input: SCHL, SBF_JARVIS
  # Output: response
  @GetHomepageDetailsRunner
  Scenario: Run GetHomepageDetails api
    * def reqBody =
      """
      {
          "username" : '#(USER_ID)',
          "password" : '#(PWD)'
      }
      """
    Given url EXTERNAL_SCH_COOKIE_URL + externalSCHLCookieUri
    And headers {Content-Type : 'application/json'}
    And request reqBody
    And method POST
    And def SCHL_COOKIE = 'SCHL='+responseCookies.SCHL
    Given url BOOKFAIRS_JARVIS_URL + beginFairSessionUri
    And headers {Content-Type : 'application/json', Cookie : '#(SCHL_COOKIE)'}
    And def pathParams = {fairId : '#(FAIRID)'}
    And path pathParams.bookFairId
    And method GET
    * def JARVIS_FAIR_SESSION = responseHeaders.SBF_JARVIS
    Then def BFS_SCHL = responseCookies.SCHL
    Given url BOOKFAIRS_JARVIS_URL + getHomepageDetailsUri
    And cookies {SCHL : '#(BFS_SCHL)', SBF_JARVIS : '#(JARVIS_FAIR_SESSION)'}
    And def pathParams = {fairId : '#(FAIR_ID)'}
    And path pathParams.fairId + '/homepage'
    And method GET

