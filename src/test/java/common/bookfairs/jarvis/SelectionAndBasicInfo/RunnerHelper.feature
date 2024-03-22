@ignore @report=true
Feature: Helper for running Selection and Basic Info APIs

  Background: Set config

  # Input: USER_NAME, PASSWORD, RESOURCE_ID
  # Output: response, SBF_JARVIS, SCHL
  # def selectFairResponse = call read('classpath:common/bookfairs/jarvis/SelectionAndBasicInfo/RunnerHelper.feature@SelectFair'){RESOURCE_ID: 'current'}
  @SelectFair
  Scenario: Run select fair api for user: <USER_NAME> and fair:<RESOURCE_ID>
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
    * url BOOKFAIRS_JARVIS_URL
    * path "/bookfairs-jarvis/api/user/fairs/", RESOURCE_ID
    * cookies { SCHL : '#(schlResponse.SCHL)'}
    * param mode = "SELECT"
    Then method get
    And def SBF_JARVIS = responseCookies.SBF_JARVIS.value
    And def SCHL = schlResponse.SCHL

  # Same endpoint as @SelectFair just with different selection mode
  # Input: USERNAME, PASSWORD, FAIRID_OR_CURRENT
  # Output: response
  # def getFairResponse = call read('classpath:common/bookfairs/jarvis/SelectionAndBasicInfo/RunnerHelper.feature@GetFair'){FAIRID_OR_CURRENT: 'current'}
  @GetFairInfo
  Scenario: Run get fair api for user: <USER_NAME> and fair:<FAIRID_OR_CURRENT>
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
    * url BOOKFAIRS_JARVIS_URL
    * path "/bookfairs-jarvis/api/user/fairs/", FAIRID_OR_CURRENT
    * cookies { SCHL : '#(schlResponse.SCHL)'}
    * param fairSelectionMode = "DO_NOT_SELECT"
    Then method get
    And def SBF_JARVIS = responseCookies.SBF_JARVIS.value
    And def SCHL = schlResponse.SCHL