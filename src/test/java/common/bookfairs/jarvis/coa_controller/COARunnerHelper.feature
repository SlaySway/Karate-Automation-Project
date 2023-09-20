#Author: Ravindra Pallerla

@ignore @report=true
Feature: Helper for running coa-controller apis

  Background: Set config
    * string externalSCHCookieUri = "/api/login"
    * string beginFairSessionUri = "/bookfairs-jarvis/api/login/userAuthorization/fairs"
    * string confirmCOAUri = "/bookfairs-jarvis/api/user/fairs/current/coa/confirmation"
      * string getCOAConfirmUrl = "/bookfairs-jarvis/api/private/fairs/current/coa"
  
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
    
    @getCoaConfirmRunner
  Scenario: Run getCOAConfirmation api
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
    Given url BOOKFAIRS_JARVIS_URL + getCOAConfirmUrl
    And cookies {SCHL : '#(BFS_SCHL)', SBF_JARVIS : '#(JARVIS_FAIR_SESSION)'}
    When method get
    Then def StatusCode = responseStatus
    And def ResponseString = response
    And def BFAcctId = response.organization.bookfairAccountId
    And def FairType = response.fairInfo.fairType