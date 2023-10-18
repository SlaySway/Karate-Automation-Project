@ignore @report=true
Feature: Helper for running homepage-controller apis

  Background: Set config
    * string externalSCHLCookieUri = "/api/login"
    * string beginFairSessionUri = "/api/login/userAuthorization/fairs"
    * string getHomepageDetailsUri = "/bookfairs-jarvis/api/user/fairs/current/homepage"
    * string updateHomepageDetailsUri = "/bookfairs-jarvis/api/user/fairs/current/homepage"

  # Input: SCHL, SBF_JARVIS
  # Output: response
  @GetHomepageDetailsRunner
  Scenario: Run GetHomepageDetails api
    Given url BOOKFAIRS_JARVIS_URL + getHomepageDetailsUri
    * def SCHL = SCHL.replace("SCHL=", "")
    * def SBF_JARVIS = beginFairSessionResponse.SBF_JARVIS.replace("SBF_JARVIS=", "")
    And cookies { SCHL : '#(SCHL)', SBF_JARVIS: '#(SBF_JARVIS)'}
    And method GET

# Input: SCHL, SBF_JARVIS
  # Output: response
  @UpdateHomepageDetailsRunner
  Scenario: Run UpdateHomepageDetails api
    Given url BOOKFAIRS_JARVIS_URL + updateHomepageDetailsUri
    * def SCHL = SCHL.replace("SCHL=", "")
    * def SBF_JARVIS = beginFairSessionResponse.SBF_JARVIS.replace("SBF_JARVIS=", "")
    And cookies { SCHL : '#(SCHL)', SBF_JARVIS: '#(SBF_JARVIS)'}
    * def body = {FairId : '#(FAIRID)', paymentCheckCkbox : '#(paymentCheckCkbox)'}
    And method PUT
