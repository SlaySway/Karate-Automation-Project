@GetSelectionAndTokenInfoTest @public&userTests @PerformanceEnhancement
Feature: GetSelectionAndTokenInfo API automation tests

  Background: Set config
    * string getSelectionAndTokenInfoUri = "/bookfairs-jarvis/api/user/schools/<schoolId>"
    * def obj = Java.type('utils.StrictValidation')
    * string invalidSelectionAndTokenUri = "/bookfairs-jarvis/api/user/schoools/<schoolId>"

  @Happy
  Scenario Outline: Validate request when valid schoolId and mode is passed for user:<USER_NAME> and schoolId:<SCHOOL_ID>
    Given def getSelectionAndTokenInfoResponse = call read('RunnerHelper.feature@GetSelectionAndTokenInfo')
    Then match getSelectionAndTokenInfoResponse.responseStatus == 200
    And match getSelectionAndTokenInfoResponse.response.email == USER_NAME
    And match getSelectionAndTokenInfoResponse.response.school.id == SCHOOL_ID
    And match getSelectionAndTokenInfoResponse.responseHeaders['Sbf-Jarvis-Resource-Id'][0] == SCHOOL_ID

    @QA
    Examples:
      | USER_NAME              | PASSWORD | SCHOOL_ID | mode          |
      | mtodaro@scholastic.com | passw0rd | 337017    | DO_NOT_SELECT |
      | mtodaro@scholastic.com | passw0rd | 337017    | SELECT        |


  @Unhappy
  Scenario Outline: Validate when SCHL cookie is expired
    * replace getSelectionAndTokenInfoUri.schoolId = SCHOOL_ID
    * url BOOKFAIRS_JARVIS_URL + getSelectionAndTokenInfoUri
    * cookies { SCHL : 'eyJraWQiOiJub25wcm9kLTIwMjEzMzExMzMyIiwidHlwIjoiSldUIiwiYWxnIj'}
    Given method get
    Then match responseStatus == 204
    And match responseHeaders['Sbf-Jarvis-Reason'][0] == "NO_SCHL"

  @QA
    Examples:
      | SCHOOL_ID |
      | 337017    |

  @Unhappy
  Scenario Outline: Validate when there is no associated resources for user:<USER_NAME> and schoolId:<SCHOOL_ID>
    Given def getSelectionAndTokenInfoResponse = call read('RunnerHelper.feature@GetSelectionAndTokenInfo')
    Then match getSelectionAndTokenInfoResponse.responseStatus == 204
    And match getSelectionAndTokenInfoResponse.responseHeaders['Sbf-Jarvis-Reason'][0] == "NO_ASSOCIATED_RESOURCES"

    @QA
    Examples:
      | USER_NAME           | PASSWORD  | SCHOOL_ID | mode   |
      | nofairs@testing.com | password1 | 1033128   | SELECT |

  @Unhappy
  Scenario Outline: Validate when invalid mode is passed for user:<USER_NAME> and schoolId:<SCHOOL_ID>
    Given def getSelectionAndTokenInfoResponse = call read('RunnerHelper.feature@GetSelectionAndTokenInfo')
    Then match getSelectionAndTokenInfoResponse.responseStatus == 400
    And match getSelectionAndTokenInfoResponse.responseHeaders['Sbf-Jarvis-Reason'][0] == "BAD_SELECTION_MODE"

    @QA
    Examples:
      | USER_NAME              | PASSWORD | SCHOOL_ID | mode  |
      | mtodaro@scholastic.com | passw0rd | 337017    | ABCDE |

  @Unhappy
  Scenario Outline: Validate when invalid schoolId is passed for user:<USER_NAME> and schoolId:<SCHOOL_ID>
    Given def getSelectionAndTokenInfoResponse = call read('RunnerHelper.feature@GetSelectionAndTokenInfo')
    Then match getSelectionAndTokenInfoResponse.responseStatus == 403
    And match getSelectionAndTokenInfoResponse.responseHeaders['Sbf-Jarvis-Reason'][0] == "RESOURCE_ID_NOT_VALID"

    @QA
    Examples:
      | USER_NAME              | PASSWORD | SCHOOL_ID | mode   |
      | mtodaro@scholastic.com | passw0rd | 12345     | SELECT |

  @Unhappy
  Scenario Outline: Validate when unsupported http method is called
    Given def selectFairResponse = call read('classpath:common/bookfairs/jarvis/SelectionAndBasicInfo/RunnerHelper.feature@SelectFair'){RESOURCE_ID: <SBF_JARVIS_FAIR>}
    * replace getSelectionAndTokenInfoUri.schoolId = SCHOOL_ID
    * url BOOKFAIRS_JARVIS_URL + getSelectionAndTokenInfoUri
    * cookies { SCHL : '#(selectFairResponse.SCHL)', SBF_JARVIS: '#(selectFairResponse.SBF_JARVIS)'}
    Given method patch
    Then match responseStatus == 405
    Then match response.error == "Method Not Allowed"

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | RESOURCE_ID | SBF_JARVIS_FAIR | SCHOOL_ID | mode   |
      | azhou1@scholastic.com | password2 | 5694296     | 5694309         | 1033128   | SELECT |

  @Unhappy
  Scenario Outline: Validate for internal server error
    Given def selectFairResponse = call read('classpath:common/bookfairs/jarvis/SelectionAndBasicInfo/RunnerHelper.feature@SelectFair'){RESOURCE_ID: <SBF_JARVIS_FAIR>}
    * replace invalidSelectionAndTokenUri.schoolId = SCHOOL_ID
    * url BOOKFAIRS_JARVIS_URL + invalidSelectionAndTokenUri
    * cookies { SCHL : '#(selectFairResponse.SCHL)', SBF_JARVIS: '#(selectFairResponse.SBF_JARVIS)'}
    Given method get
    Then match responseStatus == 500

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | RESOURCE_ID | SBF_JARVIS_FAIR | SCHOOL_ID | mode   |
      | azhou1@scholastic.com | password2 | 5694296     | 5694309         | 1033128   | SELECT |

  @Regression @ignore
  Scenario Outline: Validate regression using dynamic comparison || schoolId=<SCHOOL_ID>
    * def BaseResponseMap = call read('RunnerHelper.feature@GetSelectionAndTokenInfoBase')
    * def TargetResponseMap = call read('RunnerHelper.feature@GetSelectionAndTokenInfo')
    * string base = BaseResponseMap.response
    * string target = TargetResponseMap.response
    * def compResult = obj.strictCompare(base, target)
    Then print "Response from production code base", BaseResponseMap.response
    Then print "Response from current qa code base", TargetResponseMap.response
    Then print 'Differences any...', compResult

    Examples:
      | USER_NAME              | PASSWORD | SCHOOL_ID |
      | mtodaro@scholastic.com | passw0rd | 337017    |