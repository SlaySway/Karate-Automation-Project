@ignore @report=true
Feature: Helper for running Selection and Basic Info APIs

  Background: Set config

  # Input: USER_NAME, PASSWORD, FAIRID_OR_CURRENT
  # Output: response, SBF_JARVIS, SCHL
  @SelectFair
  Scenario: Run select fair api for user: <USER_NAME> and fair:<FAIRID_OR_CURRENT>
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
    * url BOOKFAIRS_JARVIS_URL
    * path "/bookfairs-jarvis/api/user/fairs/", FAIRID_OR_CURRENT
    * cookies { SCHL : '#(schlResponse.SCHL)'}
    * param fairSelectionMode = "SELECT"
    Then method get
    And def SBF_JARVIS = responseCookies.SBF_JARVIS != '#null' ? responseCookies.SBF_JARVIS.value:"null"
    And def SCHL = schlResponse.SCHL

  # Input: USERNAME, PASSWORD, FAIRID_OR_CURRENT
  # Output: response
  @GetFairSessionInfo
  Scenario: Run get fair api for user: <USER_NAME> and fair:<FAIRID_OR_CURRENT>
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
    * url BOOKFAIRS_JARVIS_URL
    * path "/bookfairs-jarvis/api/user/fairs/", FAIRID_OR_CURRENT
    * cookies { SCHL : '#(schlResponse.SCHL)'}
    * param fairSelectionMode = "DO_NOT_SELECT"
    Then method get
    And def SBF_JARVIS = responseCookies.SBF_JARVIS != '#null' ? responseCookies.SBF_JARVIS.value:"null"
    And def SCHL = schlResponse.SCHL