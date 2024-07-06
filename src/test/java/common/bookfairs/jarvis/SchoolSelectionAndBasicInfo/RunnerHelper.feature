@ignore @report=true
Feature: Helper for running School Selection and Basic Info APIs

  Background: Set config
    * string getSchoolsUri = "/bookfairs-jarvis/api/user/schools"
    * string getSelectAndTokenInfoUri = "/bookfairs-jarvis/api/user/schools/<schoolId>?mode=SELECT"

  # Input: USER_NAME, PASSWORD
  # Output: response
  # def getSchoolsResponse = call read('classpath:common/bookfairs/jarvis/SchoolSelectionAndBasicInfo/RunnerHelper.feature@GetSchools')
  @GetSchools
  Scenario: Run get schools api for user: <USER_NAME>
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
    * url BOOKFAIRS_JARVIS_URL
    * path getSchoolsUri
    * cookies { SCHL : '#(schlResponse.SCHL)'}
    Then method get
    And def SCHL = schlResponse.SCHL

  #Input: USER_NAME, PASSWORD
  # Output: response
  # def getSchoolsBaseResponse = call read('classpath:common/bookfairs/jarvis/SchoolSelectionAndBasicInfo/RunnerHelper.feature@GetSchoolsBase')
  @GetSchoolsBase
  Scenario: Run get schools api in stage environment for user: <USER_NAME>
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
    * url BOOKFAIRS_JARVIS_BASE
    * path getSchoolsUri
    * cookies { SCHL : '#(schlResponse.SCHL)'}
    Then method get
    And def SCHL = schlResponse.SCHL

    # Input: USER_NAME, PASSWORD,SCHOOL_ID, MODE
    # Output: response
    @GetSelectAndTokenInfo
    Scenario: Run get select and token info for user: <USER_NAME>
      Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
      * replace getSelectAndTokenInfoUri.schoolId = SCHOOL_ID
      * url BOOKFAIRS_JARVIS_URL + getSelectAndTokenInfoUri
      * cookies { SCHL : '#(schlResponse.SCHL)'}
      Then method get
