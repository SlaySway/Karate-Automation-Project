@ignore @report=true
Feature: Helper for running fair-settings-controller apis

  Background: Set config
    * string externalSCHLCookieUri = "/api/login"
    * string beginFairSessionUri = "/api/login/userAuthorization/fairs"
    * string getFairSettingsUri = "/api/user/fairs/current/settings"

  # Input: SCHL, SBF_JARVIS
  # Output: response
    @GetFairSettingsRunner
    Scenario: Run GetFairsettings api with no other endpoint calls
      Given url BOOKFAIRS_JARVIS_URL + getFairSettingsUri
      * def SCHL = SCHL.replace("SCHL=", "")
      * def SBF_JARVIS = beginFairSessionResponse.SBF_JARVIS.replace("SBF_JARVIS=", "")
      And cookies { SCHL : '#(SCHL)', SBF_JARVIS: '#(SBF_JARVIS)'}
      And method GET