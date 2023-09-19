#Author: Ravindra Pallerla
@ignore @report=false
Feature: Runner helper for running each scenario in both target and base environments individually

  Background: Set config
    * string ExternalSCHCookieUri = "/api/login"
    * string beginFairSessionUri = "/bookfairs-jarvis/api/login/userAuthorization/fairs"
    * string currentFairsUri = "/bookfairs-jarvis/api/user/fairs/current"
    * string  GetFairsSettingsUri = "/bookfairs-jarvis/api/user/fairs/current/settings"
    * string currentSettingsBlackOutDatesUri = "/bookfairs-jarvis/api/user/fairs/current/settings/dates/blackout-dates"
    * string fairSettingDatesUri = "/bookfairs-jarvis/api/user/fairs/current/settings/dates"
    * string homePageEventsPostUri = "/bookfairs-jarvis/api/user/fairs/current/homepage/events"
    * string coCharisUri = "/bookfairs-jarvis/api/private/fairs/current/settings/co-chairs"

  @currentFairsBase
  Scenario: Run currentFairs api  in base environment
    * def reqBody =
      """
      {
          "username" : '#(USER_ID)',
          "password" : '#(PWD)'
      }
      """
    Given url EXTERNAL_SCH_COOKIE_BASE + ExternalSCHCookieUri
    And headers {Content-Type : 'application/json'}
    And request reqBody
    And method post
    And def SCHL_SESSION = 'SCHL='+responseCookies.SCHL.value
    Given url BOOKFAIRS_JARVIS_BASE + currentFairsUri
    And headers {Content-Type : 'application/json', Cookie : '#(SCH_Cookie)'}
    * def jsonBody = {inputpayLoad : '#(jsonInput)'}
    And request jsonBody.inputpayLoad
    When method PUT
    Then def StatusCode = responseStatus
    And def ResponseString = response

  @currentFairsTarget
  Scenario: Run currentFairs api  in target environment
    * def reqBody =
      """
      {
          "username" : '#(USER_ID)',
          "password" : '#(PWD)'
      }
      """
    Given url EXTERNAL_SCH_COOKIE_TARGET + ExternalSCHCookieUri
    And headers {Content-Type : 'application/json'}
    And request reqBody
    And method post
    And def SCHL_SESSION = 'SCHL='+responseCookies.SCHL.value
    Given url BOOKFAIRS_JARVIS_TARGET + currentFairsUri
    And headers {Content-Type : 'application/json', Cookie : '#(SCH_Cookie)'}
    * def jsonBody = {inputpayLoad : '#(jsonInput)'}
    And request jsonBody.inputpayLoad
    When method PUT
    Then def StatusCode = responseStatus
    And def ResponseString = response

  @GetFairsSettingsBase
  Scenario: Run FairsCurrentSettings api  in base environment
    * def reqBody =
      """
      {
          "username" : '#(USER_ID)',
          "password" : '#(PWD)'
      }
      """
    Given url EXTERNAL_SCH_COOKIE_BASE + ExternalSCHCookieUri
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
    Given url BOOKFAIRS_JARVIS_BASE + GetFairsSettingsUri
    And cookies {SCHL : '#(BFS_SCHL)', SBF_JARVIS : '#(JARVIS_FAIR_SESSION)'}
    When method get
    Then def StatusCode = responseStatus
    And remove response.fairInfo.name
    And set response.ewallet.enabled = 'false'
    And def ResponseString = response

  @GetFairsSettingsTarget
  Scenario: Run FairsCurrentSettings api  in target environment
    * def reqBody =
      """
      {
          "username" : '#(USER_ID)',
          "password" : '#(PWD)'
      }
      """
    Given url EXTERNAL_SCH_COOKIE_TARGET + ExternalSCHCookieUri
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
    Given url BOOKFAIRS_JARVIS_TARGET + GetFairsSettingsUri
    And cookies {SCHL : '#(BFS_SCHL)', SBF_JARVIS : '#(JARVIS_FAIR_SESSION)'}
    When method get
    Then def StatusCode = responseStatus
    And def ResponseString = response
    And def BFAcctId = response.fairInfo.bookfairAccountId
    And def FairType = response.fairInfo.fairType
    And def chChairsInfo = response.

    
   @coChairsRunner
  Scenario: Run co-chairs api
    * def reqBody =
      """
      {
          "username" : '#(USER_ID)',
          "password" : '#(PWD)'
      }
      """
    Given url EXTERNAL_SCH_COOKIE_TARGET + ExternalSCHCookieUri
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
    Given url BOOKFAIRS_JARVIS_TARGET + coCharisUri
    * def putPayload = {inputBody : '#(Input_Body)'}
    And cookies {SCHL : '#(BFS_SCHL)', SBF_JARVIS : '#(JARVIS_FAIR_SESSION)'}
    And request putPayload.inputBody
    When method put
    Then def StatusCode = responseStatus
    And def ResponseString = response