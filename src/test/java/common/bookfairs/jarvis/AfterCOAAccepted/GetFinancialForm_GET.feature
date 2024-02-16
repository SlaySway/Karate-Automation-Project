@GetFinancialForm @PerformanceEnhancement
Feature: GetFinancialForm GET Api tests

  Background: Set config
    * def obj = Java.type('utils.StrictValidation')
    * def getFinancialFormUri = "/bookfairs-jarvis/api/user/fairs/<fairIdOrCurrent>/financials/form"

  @Happy
  Scenario Outline: Validate when user doesn't have access to CPTK for user:<USER_NAME> and fair:<FAIRID_OR_CURRENT>
    Given def getFinancialFormResponse = call read('RunnerHelper.feature@GetFinancialForm')
    Then match getFinancialFormResponse.responseStatus == 200

    @QA
    Examples:
      | USER_NAME              | PASSWORD  | FAIRID_OR_CURRENT |
      | mtodaro@scholastic.com | passw0rd  | 5694318           |
      | mtodaro@scholastic.com | passw0rd  | current           |
      | azhou1@scholastic.com  | password1 | 5694296           |

  @Unhappy
  Scenario Outline: Validate when user doesn't have access to CPTK for user:<USER_NAME> and fair:<FAIRID_OR_CURRENT>
    Given def getFinancialFormResponse = call read('RunnerHelper.feature@GetFinancialForm')
    Then match getFinancialFormResponse.responseStatus == 204
    And match getFinancialFormResponse.responseHeaders['Sbf-Jarvis-Reason'][0] == "NO_ASSOCIATED_FAIRS"

    @QA
    Examples:
      | USER_NAME           | PASSWORD  | FAIRID_OR_CURRENT |
      | nofairs@testing.com | password1 | current           |

  @Unhappy
  Scenario Outline: Validate when user attempts to access a non-COA Accepted fair:<USER_NAME> and fair:<FAIRID_OR_CURRENT>
    Given def getFinancialFormResponse = call read('RunnerHelper.feature@GetFinancialForm')
    Then match getFinancialFormResponse.responseStatus == 204
    And match getFinancialFormResponse.responseHeaders['Sbf-Jarvis-Reason'][0] == "NEEDS_COA_CONFIRMATION"

    @QA
    Examples:
      | USER_NAME              | PASSWORD | FAIRID_OR_CURRENT |
      | mtodaro@scholastic.com | passw0rd | 5694300           |

  @Unhappy
  Scenario Outline: Validate when SCHL cookie is not passed for fair:<FAIRID_OR_CURRENT>
    * replace getFinancialFormUri.fairIdOrCurrent =  FAIRID_OR_CURRENT
    * url BOOKFAIRS_JARVIS_URL + getFinancialFormUri
    Given method get
    Then match responseStatus == 204
    And match responseHeaders['Sbf-Jarvis-Reason'][0] == "NO_SCHL"

    @QA
    Examples:
      | FAIRID_OR_CURRENT |
      | 5694296           |
      | current           |

  @Unhappy
  Scenario: Validate when SCHL cookie is expired
    * replace getFinancialFormUri.fairIdOrCurrent =  "current"
    * url BOOKFAIRS_JARVIS_URL + getFinancialFormUri
    * cookies { SCHL : 'eyJraWQiOiJub25wcm9kLTIwMjEzMzExMzMyIiwidHlwIjoiSldUIiwiYWxnIj'}
    Given method get
    Then match responseStatus == 204
    And match responseHeaders['Sbf-Jarvis-Reason'][0] == "NO_SCHL"

  @Unhappy
  Scenario Outline: Validate when user doesn't have access to specific fair for user:<USER_NAME> and fair:<FAIRID_OR_CURRENT>
    Given def getFinancialFormResponse = call read('RunnerHelper.feature@GetFinancialForm')
    Then match getFinancialFormResponse.responseStatus == 403
    And match getFinancialFormResponse.responseHeaders['Sbf-Jarvis-Reason'][0] == "FAIR_ID_NOT_VALID"

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com | password1 | 5734325           |

  @Unhappy
  Scenario Outline: Validate when user uses an invalid fair ID for user:<USER_NAME> and fair:<FAIRID_OR_CURRENT>
    Given def getFinancialFormResponse = call read('RunnerHelper.feature@GetFinancialForm')
    Then match getFinancialFormResponse.responseStatus == 404
    And match getFinancialFormResponse.responseHeaders['Sbf-Jarvis-Reason'][0] == "MALFORMED_FAIR_ID"

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com | password1 | abc1234           |

  @Happy
  Scenario Outline: Validate when user inputs different configurations for fairId/current for CONFIRMED fairs:<USER_NAME>, fair:<FAIRID_OR_CURRENT>, scenario:<SCENARIO>
    Given def getFinancialFormResponse = call read('RunnerHelper.feature@GetFinancialForm')
    Then match getFinancialFormResponse.responseHeaders['Sbf-Jarvis-Fair-Id'][0] == EXPECTED_FAIR
    And if(FAIRID_OR_CURRENT == 'current') karate.log(karate.match(getFinancialFormResponse.responseHeaders['Sbf-Jarvis-Default-Fair'][0], 'AUTOMATICALLY_SELECTED_THIS_REQUEST'))

    @QA
    Examples:
      | USER_NAME                                   | PASSWORD  | FAIRID_OR_CURRENT | EXPECTED_FAIR | SCENARIO                                     |
      | azhou1@scholastic.com                       | password1 | 5694296           | 5694296       | Return path parameter fairId information     |
      | azhou1@scholastic.com                       | password1 | current           | 5694296       | Has current, upcoming, and past fairs        |
      | hasAllFairs@testing.com                     | password1 | current           | 5694301       | Has all fairs                                |
      | hasUpcomingAndPastFairs@testing.com         | password1 | current           | 5694305       | Has upcoming and past fairs                  |
      | hasPastFairs@testing.com                    | password1 | current           | 5694307       | Has past fairs                               |
      | hasRecentlyUpcomingAndPastFairs@testing.com | password1 | current           | 5694303       | Has recently ended, upcoming, and past fairs |

  @Happy
  Scenario Outline: Validate when user inputs different configurations for fairId/current WITH SBF_JARVIS for DO_NOT_SELECT mode with user:<USER_NAME>, fair:<FAIRID_OR_CURRENT>, cookie fair:<SBF_JARVIS_FAIR>
    Given def selectFairResponse = call read('classpath:common/bookfairs/jarvis/SelectionAndBasicInfo/RunnerHelper.feature@SelectFair'){FAIRID_OR_CURRENT: <SBF_JARVIS_FAIR>}
    * replace getFinancialFormUri.fairIdOrCurrent = FAIRID_OR_CURRENT
    * url BOOKFAIRS_JARVIS_URL + getFinancialFormUri
    * cookies { SCHL : '#(selectFairResponse.SCHL)', SBF_JARVIS: '#(selectFairResponse.SBF_JARVIS)'}
    Then method get
    Then match responseHeaders['Sbf-Jarvis-Fair-Id'][0] == EXPECTED_FAIR
    And if(FAIRID_OR_CURRENT == 'current') karate.log(karate.match(responseHeaders['Sbf-Jarvis-Default-Fair'][0], 'PREVIOUSLY_SELECTED'))

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT | EXPECTED_FAIR | SBF_JARVIS_FAIR |
      | azhou1@scholastic.com | password1 | 5694296           | 5694296       | 5694309         |
      | azhou1@scholastic.com | password1 | current           | 5694296       | 5694296         |

  @Regression @ignore
  Scenario Outline: Validate regression using dynamic comparison || fairId=<FAIRID_OR_CURRENT>
    * def BaseResponseMap = call read('RunnerHelper.feature@GetFinancialFormBase')
    * def TargetResponseMap = call read('RunnerHelper.feature@GetFinancialForm')
    * string base = BaseResponseMap.response
    * string target = TargetResponseMap.response
    * def compResult = obj.strictCompare(base, target)
    Then print "Response from production code base", BaseResponseMap.response
    Then print "Response from current qa code base", TargetResponseMap.response
    Then print 'Differences any...', compResult

    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com | password1 | 5694296           |
