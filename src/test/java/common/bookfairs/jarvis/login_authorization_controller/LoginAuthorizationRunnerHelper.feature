@ignore @report=true
Feature: Helper for running fair-settings-controller apis

  Background: Set config
    * string beginFairSessionUri = "/bookfairs-jarvis/api/login/userAuthorization/fairs"

    # Input: USER_NAME, PASSWORD, FAIR_ID
    # Output: response.SBF_JARVIS
    @BeginFairSessionRunner
    Scenario: Run GetFairSettings api with no other endpoint calls
      Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner'){USER_NAME : '#(USER_NAME)', PASSWORD : '#(PASSWORD)'}
      Given url BOOKFAIRS_JARVIS_URL + beginFairSessionUri
      And cookies { SCHL : '#(schlResponse.SCHL)'}
      And def pathParams = {bookFairId : '#(FAIR_ID)'}
      And path pathParams.bookFairId
      And method GET
      Then def SBF_JARVIS = responseCookies.SBF_JARVIS.value
