@ignore @report=true
Feature: Helper for running fair-settings-controller apis

  Background: Set config
    * string beginFairSessionUri = "/api/login/userAuthorization/fairs"

  # Input: USER_ID, PWD, FAIR_ID
  # Output: response.SCHL, response.SBF_JARVIS
  @BeginFairSessionRunner
  Scenario: Run GetFairSettings api
    * def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
    Given url BOOKFAIRS_JARVIS_URL + beginFairSessionUri
    * def SCHL = schlResponse.SCHL
    And headers {Content-Type : 'application/json', Cookie : '#(SCHL)'}
    And def pathParams = {bookFairId : '#(FAIR_ID)'}
    And path pathParams.bookFairId
    And method GET
    Then def SBF_JARVIS = "SBF_JARVIS=" + responseCookies.SBF_JARVIS.value