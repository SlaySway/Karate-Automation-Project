@GetFinancialSummary @PerformanceEnhancement @4bfinfrom
Feature: GetFinancialSummary GET Api tests

  Background: Set config
    * def obj = Java.type('utils.StrictValidation')
    * def getFinancialSummaryUri = "/bookfairs-jarvis/api/user/fairs/<resourceId>/financials/summary"

  @Happy
  Scenario Outline: Validate successful response for valid request for user:<USER_NAME> and fair:<RESOURCE_ID>
    Given def getFinancialSummaryResponse = call read('RunnerHelper.feature@GetFinancialSummary')
    Then match getFinancialSummaryResponse.responseStatus == 200

    @QA
    Examples:
      | USER_NAME              | PASSWORD  | RESOURCE_ID |
      | mtodaro@scholastic.com | passw0rd  | 5694318     |
      | mtodaro@scholastic.com | passw0rd  | current     |
      | azhou1@scholastic.com  | password2 | 5694296     |

  @Unhappy
  Scenario Outline: Validate when user doesn't have access to CPTK for user:<USER_NAME> and fair:<RESOURCE_ID>
    Given def getFinancialSummaryResponse = call read('RunnerHelper.feature@GetFinancialSummary')
    Then match getFinancialSummaryResponse.responseStatus == 204
    And match getFinancialSummaryResponse.responseHeaders['Sbf-Jarvis-Reason'][0] == "NO_ASSOCIATED_RESOURCES"

    @QA
    Examples:
      | USER_NAME           | PASSWORD  | RESOURCE_ID |
      | nofairs@testing.com | password1 | current     |

  @Unhappy
  Scenario Outline: Validate when user attempts to access a non-COA Accepted fair:<USER_NAME> and fair:<RESOURCE_ID>
    Given def getFinancialSummaryResponse = call read('RunnerHelper.feature@GetFinancialSummary')
    Then match getFinancialSummaryResponse.responseStatus == 204
    And match getFinancialSummaryResponse.responseHeaders['Sbf-Jarvis-Reason'][0] == "NEEDS_COA_CONFIRMATION"

    @QA
    Examples:
      | USER_NAME              | PASSWORD | RESOURCE_ID |
      | mtodaro@scholastic.com | passw0rd | 5694317     |

  @Unhappy
  Scenario Outline: Validate when SCHL cookie is not passed for fair:<RESOURCE_ID>
    * replace getFinancialSummaryUri.resourceId =  RESOURCE_ID
    * url BOOKFAIRS_JARVIS_URL + getFinancialSummaryUri
    Given method get
    Then match responseStatus == 204
    And match responseHeaders['Sbf-Jarvis-Reason'][0] == "NO_SCHL"

    @QA
    Examples:
      | RESOURCE_ID |
      | 5694296     |
      | current     |

  @Unhappy
  Scenario: Validate when SCHL cookie is expired
    * replace getFinancialSummaryUri.resourceId =  "current"
    * url BOOKFAIRS_JARVIS_URL + getFinancialSummaryUri
    * cookies { SCHL : 'eyJraWQiOiJub25wcm9kLTIwMjEzMzExMzMyIiwidHlwIjoiSldUIiwiYWxnIj'}
    Given method get
    Then match responseStatus == 204
    And match responseHeaders['Sbf-Jarvis-Reason'][0] == "NO_SCHL"

  @Unhappy
  Scenario Outline: Validate when user doesn't have access to specific fair for user:<USER_NAME> and fair:<RESOURCE_ID>
    Given def getFinancialSummaryResponse = call read('RunnerHelper.feature@GetFinancialSummary')
    Then match getFinancialSummaryResponse.responseStatus == 403
    And match getFinancialSummaryResponse.responseHeaders['Sbf-Jarvis-Reason'][0] == "RESOURCE_ID_NOT_VALID"

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | RESOURCE_ID |
      | azhou1@scholastic.com | password2 | 5734325     |

  @Unhappy
  Scenario Outline: Validate when user uses an invalid fair ID for user:<USER_NAME> and fair:<RESOURCE_ID>
    Given def getFinancialSummaryResponse = call read('RunnerHelper.feature@GetFinancialSummary')
    Then match getFinancialSummaryResponse.responseStatus == 404
    And match getFinancialSummaryResponse.responseHeaders['Sbf-Jarvis-Reason'][0] == "MALFORMED_RESOURCE_ID"

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | RESOURCE_ID |
      | azhou1@scholastic.com | password2 | abc1234     |

  @Happy
  Scenario Outline: Validate when user inputs different configurations for fairId/current for CONFIRMED fairs:<USER_NAME>, fair:<RESOURCE_ID>, scenario:<SCENARIO>
    Given def getFinancialSummaryResponse = call read('RunnerHelper.feature@GetFinancialSummary')
    Then match getFinancialSummaryResponse.responseHeaders['Sbf-Jarvis-Resource-Id'][0] == EXPECTED_FAIR
    And if(RESOURCE_ID == 'current') karate.log(karate.match(getFinancialSummaryResponse.responseHeaders['Sbf-Jarvis-Resource-Selection'][0], 'AUTOMATICALLY_SELECTED_THIS_REQUEST'))

    @QA
    Examples:
      | USER_NAME                                   | PASSWORD  | RESOURCE_ID | EXPECTED_FAIR | SCENARIO                                     |
      | azhou1@scholastic.com                       | password2 | 5694296     | 5694296       | Return path parameter fairId information     |
      | azhou1@scholastic.com                       | password2 | current     | 5694296       | Has current, upcoming, and past fairs        |
      | hasAllFairs@testing.com                     | password1 | current     | 5694301       | Has all fairs                                |
      | hasUpcomingAndPastFairs@testing.com         | password1 | current     | 5694305       | Has upcoming and past fairs                  |
      | hasPastFairs@testing.com                    | password1 | current     | 5694307       | Has past fairs                               |
      | hasRecentlyUpcomingAndPastFairs@testing.com | password1 | current     | 5694303       | Has recently ended, upcoming, and past fairs |

  @Happy
  Scenario Outline: Validate when user inputs different configurations for fairId/current WITH SBF_JARVIS for DO_NOT_SELECT mode with user:<USER_NAME>, fair:<RESOURCE_ID>, cookie fair:<SBF_JARVIS_FAIR>
    Given def selectFairResponse = call read('classpath:common/bookfairs/jarvis/SelectionAndBasicInfo/RunnerHelper.feature@SelectFair'){RESOURCE_ID: <SBF_JARVIS_FAIR>}
    * replace getFinancialSummaryUri.resourceId = RESOURCE_ID
    * url BOOKFAIRS_JARVIS_URL + getFinancialSummaryUri
    * cookies { SCHL : '#(selectFairResponse.SCHL)', SBF_JARVIS: '#(selectFairResponse.SBF_JARVIS)'}
    Then method get
    Then match responseHeaders['Sbf-Jarvis-Resource-Id'][0] == EXPECTED_FAIR
    And if(RESOURCE_ID == 'current') karate.log(karate.match(responseHeaders['Sbf-Jarvis-Resource-Selection'][0], 'PREVIOUSLY_SELECTED'))

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | RESOURCE_ID | EXPECTED_FAIR | SBF_JARVIS_FAIR |
      | azhou1@scholastic.com | password2 | 5694296     | 5694296       | 5694309         |
      | azhou1@scholastic.com | password2 | current     | 5694296       | 5694296         |

  @Regression @ignore
  Scenario Outline: Validate regression using dynamic comparison || fairId=<RESOURCE_ID>
    * def BaseResponseMap = call read('RunnerHelper.feature@GetFinancialSummaryBase')
    * def TargetResponseMap = call read('RunnerHelper.feature@GetFinancialSummary')
    * string base = BaseResponseMap.response
    * string target = TargetResponseMap.response
    * def compResult = obj.strictCompare(base, target)
    Then print "Response from production code base", BaseResponseMap.response
    Then print "Response from current qa code base", TargetResponseMap.response
    Then print 'Differences any...', compResult

    Examples:
      | USER_NAME             | PASSWORD  | RESOURCE_ID |
      | azhou1@scholastic.com | password2 | 5694296     |
