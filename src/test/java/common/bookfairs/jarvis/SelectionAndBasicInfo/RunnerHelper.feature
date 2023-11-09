@ignore @report=true
Feature: Helper for running Selection and Basic Info APIs

  Background: Set config
    * string selectionAndBasicInfoUri = "/bookfairs-jarvis/api/user/fairs/<fairIdOrCurrent>"

  # Input: USER_NAME, PASSWORD, FAIRID_OR_CURRENT
  # Output: response, SBF_JARVIS, SCHL
  @SelectFair
  Scenario: Run select fair api
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
    And replace selectionAndBasicInfoUri.fairIdOrCurrent = FAIRID_OR_CURRENT
    Given url BOOKFAIRS_JARVIS_URL + selectionAndBasicInfoUri
    And cookies { SCHL : '#(schlResponse.SCHL)'}
    And param fairSelectionMode = "SELECT"
    And method get
    Then def SBF_JARVIS = responseCookies.SBF_JARVIS == '#notnull' ? responseCookies.SBF_JARVIS.value : "null"
    Then def SCHL = schlResponse.SCHL

  # Input: USERNAME, PASSWORD, FAIRID_OR_CURRENT
  # Output: response, SBF_JARVIS, SCHL
  @GetFairSessionInfo
  Scenario: Run get fair session info api
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner'){USER_NAME : '#(USER_NAME)', PASSWORD : '#(PASSWORD)'}
    Given url BOOKFAIRS_JARVIS_URL + beginFairSessionUri
    And cookies { SCHL : '#(schlResponse.SCHL)'}
    And def pathParams = {bookFairId : '#(FAIR_ID)'}
    And path pathParams.bookFairId
    And method get
    Then def SBF_JARVIS = responseCookies.SBF_JARVIS.value
    Then def SCHL = schlResponse.SCHL