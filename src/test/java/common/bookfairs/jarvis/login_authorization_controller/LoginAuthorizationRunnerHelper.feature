@ignore @report=true
Feature: Helper for running fair-settings-controller apis

  Background: Set config
    * string beginFairSessionUri = "/api/login/userAuthorization/fairs"

    # Input: SCHL, FAIR_ID
    # Output: response.SBF_JARVIS
    @BeginFairSessionRunner
    Scenario: Run GetFairSettings api with no other endpoint calls
      Given url BOOKFAIRS_JARVIS_URL + beginFairSessionUri
      And headers {Content-Type : 'application/json', Cookie : '#(SCHL)'}
      And def pathParams = {bookFairId : '#(FAIR_ID)'}
      And path pathParams.bookFairId
      And method GET
      Then def SBF_JARVIS = "SBF_JARVIS=" + responseCookies.SBF_JARVIS.value
