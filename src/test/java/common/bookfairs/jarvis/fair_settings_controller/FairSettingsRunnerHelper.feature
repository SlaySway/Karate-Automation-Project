@ignore @report=true
Feature: Helper for running fair-settings-controller apis

  Background: Set config
    * string externalSCHLCookieUri = "/api/login"
    * string beginFairSessionUri = "/api/login/userAuthorization/fairs"
    * string getFairSettingsUri = "/api/user/fairs/current/settings"
    * string getFairSettingsDatesUrl = "/api/user/fairs/current/settings/dates"
    * string setFairBlkOutDatesUrl = "/api/user/fairs/current/settings/dates/blackout-dates"

  # Input: SCHL, SBF_JARVIS
  # Output: response
  @GetFairSettingsRunner
  Scenario: Run GetFairsettings api with no other endpoint calls
    Given url BOOKFAIRS_JARVIS_URL + getFairSettingsUri
    * def SCHL = SCHL.replace("SCHL=", "")
    * def SBF_JARVIS = beginFairSessionResponse.SBF_JARVIS.replace("SBF_JARVIS=", "")
    And cookies { SCHL : '#(SCHL)', SBF_JARVIS: '#(SBF_JARVIS)'}
    And method GET

  # Input: USER_ID, PWD, FAIRID
  @GetFairSettingsBase
  Scenario: Run GetFairsettings api in base environment
    * def reqBody =
      """
      {
          "username" : '#(USER_ID)',
          "password" : '#(PWD)'
      }
      """
    Given url EXTERNAL_SCH_COOKIE_BASE + externalSCHLCookieUri
    And headers {Content-Type : 'application/json'}
    And request reqBody
    And method post
    And def SCHL_SESSION = 'SCHL='+responseCookies.SCHL.value
    Given url BOOKFAIRS_JARVIS_BASE + beginFairSessionUri
    And headers {Content-Type : 'application/json', Cookie : '#(SCHL_SESSION)'}
    And def pathParams = {bookFairId : '#(FAIRID)'}
    And path pathParams.bookFairId
    And method get
    Then def JARVIS_FAIR_SESSION = responseCookies.SBF_JARVIS.value
    Then def BFS_SCHL = responseCookies.SCHL.value
    Given url BOOKFAIRS_JARVIS_BASE + getFairSettingsUri
    And cookies {SCHL : '#(BFS_SCHL)', SBF_JARVIS : '#(JARVIS_FAIR_SESSION)'}
    When method get
    And def BaseStatCd = responseStatus
    Then string BaseResponse = response

  # Input: USER_ID, PWD, FAIRID
  @GetFairSettingsTarget
  Scenario: Run GetFairsettings api in target environment
    * def reqBody =
      """
      {
          "username" : '#(USER_ID)',
          "password" : '#(PWD)'
      }
      """
    Given url EXTERNAL_SCH_COOKIE_TARGET + externalSCHLCookieUri
    And headers {Content-Type : 'application/json'}
    And request reqBody
    And method post
    And def SCHL_SESSION = 'SCHL='+responseCookies.SCHL.value
    Given url BOOKFAIRS_JARVIS_TARGET + beginFairSessionUri
    And headers {Content-Type : 'application/json', Cookie : '#(SCHL_SESSION)'}
    And def pathParams = {bookFairId : '#(FAIRID)'}
    And path pathParams.bookFairId
    And method get
    Then def JARVIS_FAIR_SESSION = responseCookies.SBF_JARVIS.value
    Then def BFS_SCHL = responseCookies.SCHL.value
    Given url BOOKFAIRS_JARVIS_TARGET + getFairSettingsUri
    And cookies {SCHL : '#(BFS_SCHL)', SBF_JARVIS : '#(JARVIS_FAIR_SESSION)'}
    When method get
    And def TargetStatCd = responseStatus
    Then string TargetResponse = response

  # Input: USER_ID, PWD, FAIRID
  @getFairSettingsDatesBase
  Scenario: Run getFairSettingsDates api in base environment
    * def reqBody =
      """
      {
          "username" : '#(USER_ID)',
          "password" : '#(PWD)'
      }
      """
    Given url EXTERNAL_SCH_COOKIE_BASE + externalSCHLCookieUri
    And headers {Content-Type : 'application/json'}
    And request reqBody
    And method post
    And def SCHL_SESSION = 'SCHL='+responseCookies.SCHL.value
    Given url BOOKFAIRS_JARVIS_BASE + beginFairSessionUri
    And headers {Content-Type : 'application/json', Cookie : '#(SCHL_SESSION)'}
    And def pathParams = {bookFairId : '#(FAIRID)'}
    And path pathParams.bookFairId
    And method get
    Then def JARVIS_FAIR_SESSION = responseCookies.SBF_JARVIS.value
    Then def BFS_SCHL = responseCookies.SCHL.value
    Given url BOOKFAIRS_JARVIS_BASE + getFairSettingsDatesUrl
    And cookies {SCHL : '#(BFS_SCHL)', SBF_JARVIS : '#(JARVIS_FAIR_SESSION)'}
    When method get
    And def BaseStatCd = responseStatus
    Then string BaseResponse = response

  # Input: USER_ID, PWD, FAIRID
  @getFairSettingsDatesTarget
  Scenario: Run getFairSettingsDates api in target environment
    * def reqBody =
      """
      {
          "username" : '#(USER_ID)',
          "password" : '#(PWD)'
      }
      """
    Given url EXTERNAL_SCH_COOKIE_TARGET + externalSCHLCookieUri
    And headers {Content-Type : 'application/json'}
    And request reqBody
    And method post
    And def SCHL_SESSION = 'SCHL='+responseCookies.SCHL.value
    Given url BOOKFAIRS_JARVIS_TARGET + beginFairSessionUri
    And headers {Content-Type : 'application/json', Cookie : '#(SCHL_SESSION)'}
    And def pathParams = {bookFairId : '#(FAIRID)'}
    And path pathParams.bookFairId
    And method get
    Then def JARVIS_FAIR_SESSION = responseCookies.SBF_JARVIS.value
    Then def BFS_SCHL = responseCookies.SCHL.value
    Given url BOOKFAIRS_JARVIS_TARGET + getFairSettingsDatesUrl
    And cookies {SCHL : '#(BFS_SCHL)', SBF_JARVIS : '#(JARVIS_FAIR_SESSION)'}
    When method get
    And def TargetStatCd = responseStatus
    Then string TargetResponse = response
