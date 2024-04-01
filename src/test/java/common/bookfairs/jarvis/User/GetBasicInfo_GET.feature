@GetSalesHistoryTest @public&userTests @PerformanceEnhancement
Feature: GetSalesHistory API automation tests

  Background: Set config
    * string getBasicInfoUri = "/bookfairs-jarvis/api/user/schools/selected/basic-info"
    * def obj = Java.type('utils.StrictValidation')
    * string invalidBasicInfoUri = "/bookfairs-jarvis/api/user/schools/selected/basic-in"
    * string getSelectionAndTokenInfoUri = "/bookfairs-jarvis/api/user/schools/<schoolId>"

  @Unhappy
  Scenario Outline: Validate request when selectionAndToken API is not called for user:<USER_NAME> and schoolId:<SCHOOL_ID>
    Given def getBasicInfoResponse = call read('RunnerHelper.feature@GetBasicInfo')
    Then match getBasicInfoResponse.responseStatus == 204
    And match getBasicInfoResponse.responseHeaders['Sbf-Jarvis-Reason'][0] == "SELECTION_REQUIRED"

    @QA
    Examples:
      | USER_NAME              | PASSWORD  |
      | mtodaro@scholastic.com | passw0rd  |
      | azhou1@scholastic.com  | password1 |

  @Happy
  Scenario Outline: Validate request when SelectAndToken API mode as SELECT is called for user:<USER_NAME> and schoolId:<SCHOOL_ID>
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
    * replace getSelectionAndTokenInfoUri.schoolId = SCHOOL_ID
    And params {mode : '#(mode)'}
    * url BOOKFAIRS_JARVIS_URL + getSelectionAndTokenInfoUri
    * cookies { SCHL : '#(schlResponse.SCHL)'}
    Then method get
    * url BOOKFAIRS_JARVIS_URL + getBasicInfoUri
    * cookies { SCHL : '#(schlResponse.SCHL)'}
    Then method get
    Then match responseStatus == 200
    And match response.email == USER_NAME
    And match response.school.id == SCHOOL_ID
    And match responseHeaders['Sbf-Jarvis-Resource-Id'][0] == SCHOOL_ID

    @QA
    Examples:
      | USER_NAME              | PASSWORD  | SCHOOL_ID | mode   |
      | mtodaro@scholastic.com | passw0rd  | 337017    | SELECT |
      | azhou1@scholastic.com  | password1 | 1033128   | SELECT |

  @Unhappy
  Scenario Outline: Validate when unsupported http method is called
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
    * url BOOKFAIRS_JARVIS_URL + getBasicInfoUri
    * cookies { SCHL : '#(schlResponse.SCHL)'}
    Given method patch
    Then match responseStatus == 405
    Then match response.error == "Method Not Allowed"

    @QA
    Examples:
      | USER_NAME             | PASSWORD  |
      | azhou1@scholastic.com | password1 |

  @Unhappy
  Scenario Outline: Validate for internal server error
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
    * url BOOKFAIRS_JARVIS_URL + invalidBasicInfoUri
    * cookies { SCHL : '#(schlResponse.SCHL)'}
    Given method get
    Then match responseStatus == 500

    @QA
    Examples:
      | USER_NAME             | PASSWORD  |
      | azhou1@scholastic.com | password1 |

  @Regression @ignore
  Scenario Outline: Validate regression using dynamic comparison || schoolId=<SCHOOL_ID>
    * def BaseResponseMap = call read('RunnerHelper.feature@GetBasicInfoBase')
    * def TargetResponseMap = call read('RunnerHelper.feature@GetBasicInfo')
    * string base = BaseResponseMap.response
    * string target = TargetResponseMap.response
    * def compResult = obj.strictCompare(base, target)
    Then print "Response from production code base", BaseResponseMap.response
    Then print "Response from current qa code base", TargetResponseMap.response
    Then print 'Differences any...', compResult

    Examples:
      | USER_NAME              | PASSWORD |
      | mtodaro@scholastic.com | passw0rd |