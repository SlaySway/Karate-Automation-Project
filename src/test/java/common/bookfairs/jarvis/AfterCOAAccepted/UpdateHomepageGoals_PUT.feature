@UpdateHomepageGoals
Feature: UpdateHomepageGoals PUT Api tests

  Background: Set config
    * def obj = Java.type('utils.StrictValidation')
    * def updateHomepageGoalsUri = "/bookfairs-jarvis/api/user/fairs/<fairIdOrCurrent>/homepage/goals"

  @Unhappy
  Scenario Outline: Validate when SCHL cookie is not passed for fair:<FAIRID_OR_CURRENT>
    * replace updateHomepageGoalsUri.fairIdOrCurrent =  FAIRID_OR_CURRENT
    * url BOOKFAIRS_JARVIS_URL + updateHomepageGoalsUri
    Given method put
    Then match responseStatus == 401

    @QA
    Examples:
      | FAIRID_OR_CURRENT |
      | 5633533           |
      | current           |

  @Unhappy
  Scenario Outline: Validate when SCHL cookie is expired
    * replace updateHomepageGoalsUri.fairIdOrCurrent =  "current"
    * url BOOKFAIRS_JARVIS_URL + updateHomepageGoalsUri
    * cookies { SCHL : '<EXPIRED_SCHL>'}
    Given method put
    Then match responseStatus == 401

    @QA
    Examples:
      | EXPIRED_SCHL |
      | eyJraWQiOiJub25wcm9kLTIwMjEzMzExMzMyIiwidHlwIjoiSldUIiwiYWxnIjoiSFMyNTYifQ.eyJpc3MiOiJNeVNjaGwiLCJhdWQiOiJTY2hvbGFzdGljIiwibmJmIjoxNjk5MzkwNzUyLCJzdWIiOiI5ODYzNTUyMyIsImlhdCI6MTY5OTM5MDc1NywiZXhwIjoxNjk5MzkyNTU3fQ.s3Czg7lmT6kETAcyupYDus8sxtFQMz7YOMKWz1_S-i8 |

  @Happy
  Scenario Outline: Validate when user doesn't have access to CPTK for user:<USER_NAME> and fair:<FAIRID_OR_CURRENT>
    * def REQUEST_BODY = {}
    Given def updateHomepageGoalsResponse = call read('RunnerHelper.feature@UpdateHomepageGoals')
    Then match updateHomepageGoalsResponse.responseStatus == 204
    And match updateHomepageGoalsResponse.responseHeaders['Sbf-Jarvis-Reason'][0] == "NO_ASSOCIATED_FAIRS"

    @QA
    Examples:
      | USER_NAME           | PASSWORD  | FAIRID_OR_CURRENT |
      | nofairs@testing.com | password1 | current           |

  @Unhappy
  Scenario Outline: Validate when user doesn't have access to specific fair for user:<USER_NAME> and fair:<FAIRID_OR_CURRENT>
    * def REQUEST_BODY = {}
    Given def updateHomepageGoalsResponse = call read('RunnerHelper.feature@UpdateHomepageGoals')
    Then match updateHomepageGoalsResponse.responseStatus == 403
    And match updateHomepageGoalsResponse.responseHeaders['Sbf-Jarvis-Reason'][0] == "FAIR_ID_NOT_VALID"

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com | password1 | 5734325           |

  @Unhappy
  Scenario Outline: Validate when user attempts to access a non-COA Accepted fair:<USER_NAME> and fair:<FAIRID_OR_CURRENT>
    * def REQUEST_BODY = {}
    Given def updateHomepageGoalsResponse = call read('RunnerHelper.feature@UpdateHomepageGoals')
    Then match updateHomepageGoalsResponse.responseStatus == 204
    And match updateHomepageGoalsResponse.responseHeaders['Sbf-Jarvis-Reason'][0] == "NEEDS_COA_CONFIRMATION"

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com | password1 | 5829187           |

  @Happy
  Scenario Outline: Validate when user inputs different configurations for fairId/current for CONFIRMED fairs:<USER_NAME>, fair:<FAIRID_OR_CURRENT>
    * def REQUEST_BODY = {}
    Given def updateHomepageGoalsResponse = call read('RunnerHelper.feature@UpdateHomepageGoals')
    Then match updateHomepageGoalsResponse.responseHeaders['Sbf-Jarvis-Fair-Id'][0] == EXPECTED_FAIR
    And if(FAIRID_OR_CURRENT == 'current') karate.log(karate.match(updateHomepageGoalsResponse.responseHeaders['Sbf-Jarvis-Default-Fair'][0], 'AUTOMATICALLY_SELECTED_THIS_REQUEST'))

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT | EXPECTED_FAIR |
      | azhou1@scholastic.com | password1 | 5633533           | 5633533       |

  @Happy
  Scenario Outline: Validate when user inputs different configurations for fairId/current WITH SBF_JARVIS for DO_NOT_SELECT mode with user:<USER_NAME>, fair:<FAIRID_OR_CURRENT>, cookie fair:<SBF_JARVIS_FAIR>
    Given def selectFairResponse = call read('classpath:common/bookfairs/jarvis/SelectionAndBasicInfo/RunnerHelper.feature@SelectFair'){FAIRID_OR_CURRENT: <SBF_JARVIS_FAIR>}
    * def REQUEST_BODY = {}
    * replace updateHomepageGoalsUri.fairIdOrCurrent = FAIRID_OR_CURRENT
    * url BOOKFAIRS_JARVIS_URL + updateHomepageGoalsUri
    * cookies { SCHL : '#(selectFairResponse.SCHL)', SBF_JARVIS: '#(selectFairResponse.SBF_JARVIS)'}
    Then method put
    Then match responseHeaders['Sbf-Jarvis-Fair-Id'][0] == EXPECTED_FAIR
    And if(FAIRID_OR_CURRENT == 'current') karate.log(karate.match(responseHeaders['Sbf-Jarvis-Default-Fair'][0], 'PREVIOUSLY_SELECTED'))

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT | EXPECTED_FAIR | SBF_JARVIS_FAIR |
      | azhou1@scholastic.com | password1 | 5633533           | 5633533       | 5782595         |
      | azhou1@scholastic.com | password1 | current           | 5633533       | 5633533         |