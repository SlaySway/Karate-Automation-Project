@ignore @report=true
Feature: Helper for running coa-controller apis

  Background: Set config
    * string externalSCHCookieUri = "/api/login"
    * string beginFairSessionUri = "/api/login/userAuthorization/fairs"
    * string confirmCOAUri = "/api/user/fairs/current/coa/confirmation"
    * string getCOAConfirmUrl = "/api/private/fairs/current/coa"

  # Input: USER_ID, PWD, FAIRID
  @getCoaConfirmBase
  Scenario: Run getCOAConfirmation api in base environment
    * def reqBody =
      """
      {
          "username" : '#(USER_ID)',
          "password" : '#(PWD)'
      }
      """
    Given url EXTERNAL_SCH_COOKIE_BASE + externalSCHCookieUri
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
    Given url BOOKFAIRS_JARVIS_BASE + getCOAConfirmUrl
    And cookies {SCHL : '#(BFS_SCHL)', SBF_JARVIS : '#(JARVIS_FAIR_SESSION)'}
    When method get
    And def BaseStatCd = responseStatus
    Then string BaseResponse = response

  # Input: USER_ID, PWD, FAIRID
  @getCoaConfirmTarget
  Scenario: Run getCOAConfirmation api in target environment
    * def reqBody =
      """
      {
          "username" : '#(USER_ID)',
          "password" : '#(PWD)'
      }
      """
    Given url EXTERNAL_SCH_COOKIE_TARGET + externalSCHCookieUri
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
    Given url BOOKFAIRS_JARVIS_TARGET + getCOAConfirmUrl
    And cookies {SCHL : '#(BFS_SCHL)', SBF_JARVIS : '#(JARVIS_FAIR_SESSION)'}
    When method get
    And def TargetStatCd = responseStatus
    Then string TargetResponse = response
    And def BFAcctId = response.organization.bookfairAccountId
    And def FairType = response.fairInfo.fairType

  @confirmCoaRunner
  Scenario: Run ConfirmCOA api
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
    Given url BOOKFAIRS_JARVIS_URL + confirmCOAUri
    And cookies {SCHL : '#(BFS_SCHL)', SBF_JARVIS : '#(JARVIS_FAIR_SESSION)'}
    When method put
    Then def StatusCode = responseStatus
    And def ResponseString = response