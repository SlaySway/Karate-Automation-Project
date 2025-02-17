@GetFairSettings @Jarvis @PerformanceEnhancement
Feature: GetFairSettings GET Api tests

  Background: Set config
    * def obj = Java.type('utils.StrictValidation')
    * def getFairSettingsUri = "/bookfairs-jarvis/api/user/fairs/<fairIdOrCurrent>/settings"

  @Unhappy
  Scenario Outline: Validate when user doesn't have access to CPTK for user:<USER_NAME> and fair:<FAIRID_OR_CURRENT>
    Given def getFairSettingsResponse = call read('RunnerHelper.feature@GetFairSettings')
    Then match getFairSettingsResponse.responseStatus == 204
    And match getFairSettingsResponse.responseHeaders['Sbf-Jarvis-Reason'][0] == "NO_ASSOCIATED_RESOURCES"

    @QA
    Examples:
      | USER_NAME           | PASSWORD  | FAIRID_OR_CURRENT |
      | nofairs@testing.com | password1 | current           |

  @Unhappy
  Scenario Outline: Validate when user attempts to access a non-COA Accepted fair:<USER_NAME> and fair:<FAIRID_OR_CURRENT>
    Given def getFairSettingsResponse = call read('RunnerHelper.feature@GetFairSettings')
    Then match getFairSettingsResponse.responseStatus == 204
    And match getFairSettingsResponse.responseHeaders['Sbf-Jarvis-Reason'][0] == "NEEDS_COA_CONFIRMATION"

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com | password2 | 5694300           |

  @Unhappy
  Scenario Outline: Validate when SCHL cookie is not passed for fair:<FAIRID_OR_CURRENT>
    * replace getFairSettingsUri.fairIdOrCurrent =  FAIRID_OR_CURRENT
    * url BOOKFAIRS_JARVIS_URL + getFairSettingsUri
    Given method get
    Then match responseStatus == 204
    And match responseHeaders['Sbf-Jarvis-Reason'][0] == "NO_SCHL"

    @QA
    Examples:
      | FAIRID_OR_CURRENT |
      | 5694296           |
      | current           |

  @Unhappy
  Scenario Outline: Validate when SCHL cookie is expired
    * replace getFairSettingsUri.fairIdOrCurrent =  "current"
    * url BOOKFAIRS_JARVIS_URL + getFairSettingsUri
    * cookies { SCHL : '<EXPIRED_SCHL>'}
    Given method get
    Then match responseStatus == 204
    And match responseHeaders['Sbf-Jarvis-Reason'][0] == "NO_SCHL"

    @QA
    Examples:
      | EXPIRED_SCHL                                                                                                                                                                                                                                                      |
      | eyJraWQiOiJub25wcm9kLTIwMjEzMzExMzMyIiwidHlwIjoiSldUIiwiYWxnIjoiSFMyNTYifQ.eyJpc3MiOiJNeVNjaGwiLCJhdWQiOiJTY2hvbGFzdGljIiwibmJmIjoxNjk5MzkwNzUyLCJzdWIiOiI5ODYzNTUyMyIsImlhdCI6MTY5OTM5MDc1NywiZXhwIjoxNjk5MzkyNTU3fQ.s3Czg7lmT6kETAcyupYDus8sxtFQMz7YOMKWz1_S-i8 |

  @Unhappy
  Scenario Outline: Validate when user doesn't have access to specific fair for user:<USER_NAME> and fair:<FAIRID_OR_CURRENT>
    Given def getFairSettingsResponse = call read('RunnerHelper.feature@GetFairSettings')
    Then match getFairSettingsResponse.responseStatus == 403
    And match getFairSettingsResponse.responseHeaders['Sbf-Jarvis-Reason'][0] == "RESOURCE_ID_NOT_VALID"

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com | password2 | 5734325           |

  @Unhappy
  Scenario Outline: Validate when user uses an invalid fair ID for user:<USER_NAME> and fair:<FAIRID_OR_CURRENT>
    Given def getFairSettingsResponse = call read('RunnerHelper.feature@GetFairSettings')
    Then match getFairSettingsResponse.responseStatus == 404
    And match getFairSettingsResponse.responseHeaders['Sbf-Jarvis-Reason'][0] == "MALFORMED_RESOURCE_ID"

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com | password2 | abc1234           |

  @Happy
  Scenario Outline: Validate when user inputs different configurations for fairId/current for CONFIRMED fairs:<USER_NAME>, fair:<FAIRID_OR_CURRENT>, scenario:<SCENARIO>
    Given def getFairSettingsResponse = call read('RunnerHelper.feature@GetFairSettings')
    Then match getFairSettingsResponse.responseHeaders['Sbf-Jarvis-Fair-Id'][0] == EXPECTED_FAIR
    And if(FAIRID_OR_CURRENT == 'current') karate.log(karate.match(getFairSettingsResponse.responseHeaders['Sbf-Jarvis-Default-Fair'][0], 'AUTOMATICALLY_SELECTED_THIS_REQUEST'))

    @QA
    Examples:
      | USER_NAME                                   | PASSWORD  | FAIRID_OR_CURRENT | EXPECTED_FAIR | SCENARIO                                     |
      | azhou1@scholastic.com                       | password2 | 5694296           | 5694296       | Return path parameter fairId information     |
      | azhou1@scholastic.com                       | password2 | current           | 5694296       | Has current, upcoming, and past fairs        |
      | hasAllFairs@testing.com                     | password2 | current           | 5694301       | Has all fairs                                |
      | hasUpcomingAndPastFairs@testing.com         | password1 | current           | 5694305       | Has upcoming and past fairs                  |
      | hasPastFairs@testing.com                    | password1 | current           | 5694307       | Has past fairs                               |
      | hasRecentlyUpcomingAndPastFairs@testing.com | password1 | current           | 5694303       | Has recently ended, upcoming, and past fairs |

  @Happy
  Scenario Outline: Validate when user inputs different configurations for fairId/current WITH SBF_JARVIS for DO_NOT_SELECT mode with user:<USER_NAME>, fair:<FAIRID_OR_CURRENT>, cookie fair:<SBF_JARVIS_FAIR>
    Given def selectFairResponse = call read('classpath:common/bookfairs/jarvis/SelectionAndBasicInfo/RunnerHelper.feature@SelectFair'){FAIRID_OR_CURRENT: <SBF_JARVIS_FAIR>}
    * replace getFairSettingsUri.fairIdOrCurrent = FAIRID_OR_CURRENT
    * url BOOKFAIRS_JARVIS_URL + getFairSettingsUri
    * cookies { SCHL : '#(selectFairResponse.SCHL)', SBF_JARVIS: '#(selectFairResponse.SBF_JARVIS)'}
    Then method get
    Then match responseHeaders['Sbf-Jarvis-Fair-Id'][0] == EXPECTED_FAIR
    And if(FAIRID_OR_CURRENT == 'current') karate.log(karate.match(responseHeaders['Sbf-Jarvis-Default-Fair'][0], 'PREVIOUSLY_SELECTED'))

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT | EXPECTED_FAIR | SBF_JARVIS_FAIR |
      | azhou1@scholastic.com | password2 | 5694296           | 5694296       | 5694309         |
      | azhou1@scholastic.com | password2 | current           | 5694296       | 5694296         |

  @Regression
  Scenario Outline: Validate regression using dynamic comparison || fairId=<FAIRID_OR_CURRENT>
    * def BaseResponseMap = call read('RunnerHelper.feature@GetFairSettings')
    * def TargetResponseMap = call read('RunnerHelper.feature@GetFairSettingsBase')
    * string base = BaseResponseMap.response
    * string target = TargetResponseMap.response
    * def compResult = obj.strictCompare(base, target)
    Then print "Response from production code base", BaseResponseMap.response
    Then print "Response from current qa code base", TargetResponseMap.response
    Then print 'Differences any...', compResult

    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com | password2 | 5694296           |

  @Happy
  Scenario Outline: Validate successful response for valid request for user:<USER_NAME> and fair:<FAIRID_OR_CURRENT>
    Given def getFairSettingsResponse = call read('RunnerHelper.feature@GetFairSettings')
    Then match getFairSettingsResponse.responseStatus == 200
    And def getCMDMFairSettingsResponse = call read('classpath:common/cmdm/fairs/CMDMRunnerHelper.feature@GetFairRunner'){FAIR_ID:<FAIRID_OR_CURRENT>}
    Then match getCMDMFairSettingsResponse.responseStatus == 200
    And match getFairSettingsResponse.response.fairInfo.taxStatus == getCMDMFairSettingsResponse.response.organization.taxStatus
    * def MONGO_COMMAND =
    """
    {
      find: "bookFairDataLoad",
      "filter": {
        "_id": "#(FAIRID_OR_CURRENT)"
      }
    }
    """
    And def mongoTaxRate = call read('classpath:common/bookfairs/bftoolkit/MongoDBRunner.feature@RunCommand')
    * print mongoTaxRate.document.cursor.firstBatch[0].taxDetailTaxRate
    * def taxRate = mongoTaxRate.document.cursor.firstBatch[0].taxDetailTaxRate
    * def taxRate = taxRate.slice(0,2) + "." + taxRate.slice(2)
    * def taxRate = (taxRate*1).toString()*1
    * print taxRate
    And match getFairSettingsResponse.response.fairInfo.taxRate == taxRate


    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com | password2 | 5694296           |