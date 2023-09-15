#Author: Ravindra Pallerla

@ignore
Feature: External SCH Cookie generator service

  Background: Set config
    * string ExternalSCHCookieUri = "/api/login"
    * string beginFairSessionUri = "/bookfairs-jarvis/api/login/userAuthorization/fairs"

  @ExternalSCHCookieRunner
  Scenario: Run External SCH Cookie generator service and fetch SCHL cookie
    * def reqBody =
      """
      {
          "username" : '#(USER_ID)',
          "password" : '#(PWD)'
      }
      """
    Given url EXTERNAL_SCH_COOKIE + ExternalSCHCookieUri
    And headers {Content-Type : 'application/json'}
    And request reqBody
    And method post
    And def SCHL_SESSION = 'SCHL='+responseCookies.SCHL.value
    
   @BFSRunner
  Scenario: Run Book Fair Session generator service and fetch SBF_JARVIS response cookie
    * def reqBody =
      """
      {
          "username" : '#(USER_ID)',
          "password" : '#(PWD)'
      }
      """
    Given url EXTERNAL_SCH_COOKIE + ExternalSCHCookieUri
    And headers {Content-Type : 'application/json'}
    And request reqBody
    And method post
    And def SCHL_SESSION = 'SCHL='+responseCookies.SCHL.value
    Given url BOOKFAIRS_JARVIS_URL + beginFairSessionUri
    And headers {Content-Type : 'application/json', Cookie : '#(SCHL_SESSION)'}
    And def pathParams = {bookFairId : '#(FAIR_ID)'}
    And path pathParams.bookFairId
    And method get
    Then def JARVIS_FAIR_SESSION = responseCookies.SBF_JARVIS.value
    Then def BFS_SCHL = responseCookies.SCHL.value