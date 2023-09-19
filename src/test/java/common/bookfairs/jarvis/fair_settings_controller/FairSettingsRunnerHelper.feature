#Author: Ravindra Pallerla

@ignore @report=true
Feature: Helper for running fair-settings-controller apis

  Background: Set config
    * string externalSCHCookieUri = "/api/login"
    * string beginFairSessionUri = "/bookfairs-jarvis/api/login/userAuthorization/fairs"
    * string getFairSettingsBlackOutDatesUri = "/bookfairs-jarvis/api/user/fairs/current/settings/dates/blackout-dates"
    * string  getFairsSettingsUri = "/bookfairs-jarvis/api/user/fairs/current/settings"
    * string getFairSettingsDatesUri = "/bookfairs-jarvis/api/user/fairs/current/settings/dates"

  @getFairsSettingsRunner
  Scenario: Run GetFairsSettings api
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
    Given url BOOKFAIRS_JARVIS_URL + beginFairSessionUri
    And headers {Content-Type : 'application/json', Cookie : '#(SCHL_SESSION)'}
    And def pathParams = {bookFairId : '#(FAIRID)'}
    And path pathParams.bookFairId
    And method get
    Then def JARVIS_FAIR_SESSION = responseCookies.SBF_JARVIS.value
    Then def BFS_SCHL = responseCookies.SCHL.value
    Given url BOOKFAIRS_JARVIS_URL + getFairsSettingsUri
    And cookies {SCHL : '#(BFS_SCHL)', SBF_JARVIS : '#(JARVIS_FAIR_SESSION)'}
    When method get
    Then def StatusCode = responseStatus
    And def ResponseString = response
    And def BFAcctId = response.fairInfo.bookfairAccountId
    And def FairType = response.fairInfo.fairType