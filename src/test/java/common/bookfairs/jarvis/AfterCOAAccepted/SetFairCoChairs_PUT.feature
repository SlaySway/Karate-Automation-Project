@SetFairCoChairs @PerformanceEnhancement
Feature: SetFairCoChairs PUT Api tests

  Background: Set config
    * def obj = Java.type('utils.StrictValidation')
    * def setFairCoChairsUri = "/bookfairs-jarvis/api/user/fairs/<fairIdOrCurrent>/homepage/events"
    * def sleep = function(millis){ java.lang.Thread.sleep(millis) }
    * def defaultRequestBody =
    """
    {
      "co-chairs":[
        {
          "firstName": "Automation",
          "lastName": "Testing",
          "email": "a@a.com"
        }
      ]
     }
    """

  @Happy
  Scenario Outline: Validate successful response for valid change request for user:<USER_NAME>, fair:<FAIRID_OR_CURRENT>, request scenario:<requestBody>
    Given def getFairSettingsResponse = call read('RunnerHelper.feature@GetFairSettings')
    Then getFairSettingsResponse.responseStatus == 200
    * def originalCoChairs = getFairSettingsResponse.response["co-chairs"].map(x => {delete x.salesforceId; return x})
    * def REQUEST_BODY = defaultRequestBody
    Given def setCoChairsResponse = call read('RunnerHelper.feature@SetFairCoChairs')
    Then setCoChairsResponse.responseStatus == 200
    * sleep(1000)
    Given def getFairSettingsResponse = call read('RunnerHelper.feature@GetFairSettings')
    Then getFairSettingsResponse.responseStatus == 200
    Then match getFairSettingsResponse.response contains deep REQUEST_BODY
    * set REQUEST_BODY.co-chairs = originalCoChairs
    Given def setCoChairsResponse = call read('RunnerHelper.feature@SetFairCoChairs')
    Then setCoChairsResponse.responseStatus == 200
    * sleep(1000)
    Given def getFairSettingsResponse = call read('RunnerHelper.feature@GetFairSettings')
    Then match getFairSettingsResponse.responseStatus == 200
    Then match getFairSettingsResponse.response["co-chairs"] contains deep originalCoChairs

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com | password2 | 5694296           |

  @Happy
  Scenario Outline: Validate response for request with same email:<USER_NAME>, fair:<FAIRID_OR_CURRENT>
    * def REQUEST_BODY =
    """
    {
      "co-chairs":[
        {
          "firstName": "Automation",
          "lastName": "Testing",
          "email": "a@a.com"
        },
        {
          "firstName": "Automation",
          "lastName": "Testing",
          "email": "a@a.com"
        }
      ]
     }
    """
    Given def setCoChairsResponse = call read('RunnerHelper.feature@SetFairCoChairs')
    Then match setCoChairsResponse.responseStatus == 409
    And match setCoChairsResponse.response == "Please enter a unique email address."

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com | password2 | 5694296           |

  @Unhappy
  Scenario Outline: Validate when invalid request body for user:<USER_NAME> and fair:<FAIRID_OR_CURRENT>
    * def REQUEST_BODY = ""
    Given def setFairCochairsResponse = call read('RunnerHelper.feature@SetFairCoChairs')
    Then match setFairCochairsResponse.responseStatus == 415

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com | password2 | 5694296           |

  @Unhappy
  Scenario Outline: Validate when user doesn't have access to CPTK for user:<USER_NAME> and fair:<FAIRID_OR_CURRENT>
    * def REQUEST_BODY = defaultRequestBody
    Given def setFairCochairsResponse = call read('RunnerHelper.feature@SetFairCoChairs')
    Then match setFairCochairsResponse.responseStatus == 204
    And match setFairCochairsResponse.responseHeaders['Sbf-Jarvis-Reason'][0] == "NO_ASSOCIATED_RESOURCES"

    @QA
    Examples:
      | USER_NAME           | PASSWORD  | FAIRID_OR_CURRENT |
      | nofairs@testing.com | password1 | 5694296           |

  @Unhappy
  Scenario Outline: Validate when user attempts to access a non-COA Accepted fair:<USER_NAME> and fair:<FAIRID_OR_CURRENT>
    * def REQUEST_BODY = defaultRequestBody
    Given def setFairCochairsResponse = call read('RunnerHelper.feature@SetFairCoChairs')
    Then match setFairCochairsResponse.responseStatus == 204
    And match setFairCochairsResponse.responseHeaders['Sbf-Jarvis-Reason'][0] == "NEEDS_COA_CONFIRMATION"

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com | password2 | 5694300           |

  @Unhappy
  Scenario Outline: Validate when SCHL cookie is not passed for fair:<FAIRID_OR_CURRENT>
    * replace setFairCoChairsUri.fairIdOrCurrent =  FAIRID_OR_CURRENT
    * url BOOKFAIRS_JARVIS_URL + setFairCoChairsUri
    Given method put
    Then match responseStatus == 204
    And match responseHeaders['Sbf-Jarvis-Reason'][0] == "NO_SCHL"

    @QA
    Examples:
      | FAIRID_OR_CURRENT |
      | 5694296           |
      | current           |

  @Unhappy
  Scenario Outline: Validate when SCHL cookie is expired
    * replace setFairCoChairsUri.fairIdOrCurrent =  "current"
    * url BOOKFAIRS_JARVIS_URL + setFairCoChairsUri
    * cookies { SCHL : '<EXPIRED_SCHL>'}
    Given method put
    Then match responseStatus == 204
    And match responseHeaders['Sbf-Jarvis-Reason'][0] == "NO_SCHL"

    @QA
    Examples:
      | EXPIRED_SCHL                                                                                                                                                                                                                                                      |
      | eyJraWQiOiJub25wcm9kLTIwMjEzMzExMzMyIiwidHlwIjoiSldUIiwiYWxnIjoiSFMyNTYifQ.eyJpc3MiOiJNeVNjaGwiLCJhdWQiOiJTY2hvbGFzdGljIiwibmJmIjoxNjk5MzkwNzUyLCJzdWIiOiI5ODYzNTUyMyIsImlhdCI6MTY5OTM5MDc1NywiZXhwIjoxNjk5MzkyNTU3fQ.s3Czg7lmT6kETAcyupYDus8sxtFQMz7YOMKWz1_S-i8 |

  @Unhappy
  Scenario Outline: Validate when user doesn't have access to specific fair for user:<USER_NAME> and fair:<FAIRID_OR_CURRENT>
    * def REQUEST_BODY = defaultRequestBody
    Given def setFairCochairsResponse = call read('RunnerHelper.feature@SetFairCoChairs')
    Then match setFairCochairsResponse.responseStatus == 403
    And match setFairCochairsResponse.responseHeaders['Sbf-Jarvis-Reason'][0] == "RESOURCE_ID_NOT_VALID"

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com | password2 | 5734325           |

  @Unhappy
  Scenario Outline: Validate when user uses invalid fair ID for user:<USER_NAME> and fair:<FAIRID_OR_CURRENT>
    * def REQUEST_BODY = defaultRequestBody
    Given def setFairCochairsResponse = call read('RunnerHelper.feature@SetFairCoChairs')
    Then match setFairCochairsResponse.responseStatus == 404
    And match setFairCochairsResponse.responseHeaders['Sbf-Jarvis-Reason'][0] == "MALFORMED_RESOURCE_ID"

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com | password2 | abc1234           |

  @Happy
  Scenario Outline: Validate when user inputs different configurations for fairId/current for CONFIRMED fairs:<USER_NAME>, fair:<FAIRID_OR_CURRENT>
    * def REQUEST_BODY = defaultRequestBody
    Given def setFairCochairsResponse = call read('RunnerHelper.feature@SetFairCoChairs')
    Then match setFairCochairsResponse.responseHeaders['Sbf-Jarvis-Fair-Id'][0] == EXPECTED_FAIR
    And if(FAIRID_OR_CURRENT == 'current') karate.log(karate.match(setFairCochairsResponse.responseHeaders['Sbf-Jarvis-Default-Fair'][0], 'AUTOMATICALLY_SELECTED_THIS_REQUEST'))

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT | EXPECTED_FAIR |
      | azhou1@scholastic.com | password2 | 5694296           | 5694296       |

  @Happy
  Scenario Outline: Validate when user inputs different configurations for fairId/current WITH SBF_JARVIS for DO_NOT_SELECT mode with user:<USER_NAME>, fair:<FAIRID_OR_CURRENT>, cookie fair:<SBF_JARVIS_FAIR>
    Given def selectFairResponse = call read('classpath:common/bookfairs/jarvis/SelectionAndBasicInfo/RunnerHelper.feature@SelectFair'){FAIRID_OR_CURRENT: <SBF_JARVIS_FAIR>}
    * def REQUEST_BODY = defaultRequestBody
    * replace setFairCoChairsUri.fairIdOrCurrent = FAIRID_OR_CURRENT
    * url BOOKFAIRS_JARVIS_URL + setFairCoChairsUri
    * cookies { SCHL : '#(selectFairResponse.SCHL)', SBF_JARVIS: '#(selectFairResponse.SBF_JARVIS)'}
    Then method put
    Then match responseHeaders['Sbf-Jarvis-Fair-Id'][0] == EXPECTED_FAIR
    And if(FAIRID_OR_CURRENT == 'current') karate.log(karate.match(responseHeaders['Sbf-Jarvis-Default-Fair'][0], 'PREVIOUSLY_SELECTED'))

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT | EXPECTED_FAIR | SBF_JARVIS_FAIR |
      | azhou1@scholastic.com | password2 | 5694296           | 5694296       | 5694309         |
      | azhou1@scholastic.com | password2 | current           | 5694296       | 5694296         |

  @Unhappy
  Scenario Outline: Validate when current is used without SBF_JARVIS user:<USER_NAME> and fair:<FAIRID_OR_CURRENT>
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
    * replace setFairCoChairsUri.fairIdOrCurrent =  FAIRID_OR_CURRENT
    * url BOOKFAIRS_JARVIS_URL + setFairCoChairsUri
    * cookies { SCHL : '#(schlResponse.SCHL)'}
    * request {}
    Given method put
    Then match responseStatus == 400
    And match responseHeaders['Sbf-Jarvis-Reason'][0] == "NO_SELECTED_FAIR"

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com | password2 | current           |