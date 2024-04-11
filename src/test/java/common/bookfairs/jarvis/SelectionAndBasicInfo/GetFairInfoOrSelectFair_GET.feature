@GetFairInfoOrSelectFair @PerformanceEnhancement
Feature: GetFairInfoOrSelectFair GET Api tests

  Background: Set config
    * def obj = Java.type('utils.StrictValidation')
    * def selectFairUri = "/bookfairs-jarvis/api/user/fairs/"

  @Happy
  Scenario Outline: Validate when user doesn't have access to CPTK for user:<USER_NAME> and fair:<RESOURCE_ID>
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
    * url BOOKFAIRS_JARVIS_URL
    * path selectFairUri, 'current'
    * param fairSelectionMode = "SELECT"
    * cookies { SCHL : #(schlResponse.SCHL)}
    Given method get
    Then match responseStatus == 204
    And match responseHeaders['Sbf-Jarvis-Reason'][0] == "NO_ASSOCIATED_RESOURCES"

    @QA
    Examples:
      | USER_NAME           | PASSWORD  |
      | nofairs@testing.com | password1 |

  @Unhappy
  Scenario Outline: Validate when SCHL cookie is not passed for fair:<RESOURCE_ID>
    * url BOOKFAIRS_JARVIS_URL
    * path selectFairUri, RESOURCE_ID
    * param fairSelectionMode = "SELECT"
    Given method get
    Then match responseStatus == 204
    And match responseHeaders['Sbf-Jarvis-Reason'][0] == "NO_SCHL"

    @QA
    Examples:
      | RESOURCE_ID |
      | 5694296     |
      | current     |

  @Unhappy
  Scenario Outline: Validate when SCHL cookie is expired
    * url BOOKFAIRS_JARVIS_URL
    * path selectFairUri, 'current'
    * param fairSelectionMode = "SELECT"
    * cookies { SCHL : '<EXPIRED_SCHL>'}
    Given method get
    Then match responseStatus == 204
    And match responseHeaders['Sbf-Jarvis-Reason'][0] == "NO_SCHL"

    @QA
    Examples:
      | EXPIRED_SCHL                                                                                                                                                                                                                                                      |
      | eyJraWQiOiJub25wcm9kLTIwMjEzMzExMzMyIiwidHlwIjoiSldUIiwiYWxnIjoiSFMyNTYifQ.eyJpc3MiOiJNeVNjaGwiLCJhdWQiOiJTY2hvbGFzdGljIiwibmJmIjoxNjk5MzkwNzUyLCJzdWIiOiI5ODYzNTUyMyIsImlhdCI6MTY5OTM5MDc1NywiZXhwIjoxNjk5MzkyNTU3fQ.s3Czg7lmT6kETAcyupYDus8sxtFQMz7YOMKWz1_S-i8 |

  @Unhappy
  Scenario Outline: Validate when no fairSelection mode is provided
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
    * url BOOKFAIRS_JARVIS_URL
    * path selectFairUri, RESOURCE_ID
    * cookies { SCHL : #(schlResponse.SCHL)}
    Given method get
    Then match responseStatus == 400
    And match responseHeaders['Sbf-Jarvis-Reason'][0] == "BAD_RESOURCE_SELECTION_MODE"

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | RESOURCE_ID |
      | azhou1@scholastic.com | password2 | current     |

  @Unhappy
  Scenario Outline: Validate when user doesn't have access to specific fair for user:<USER_NAME> and fair:<RESOURCE_ID>
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
    * url BOOKFAIRS_JARVIS_URL
    * path selectFairUri, RESOURCE_ID
    * cookies { SCHL : #(schlResponse.SCHL)}
    * param fairSelectionMode = "SELECT"
    Given method get
    Then match responseStatus == 403
    And match responseHeaders['Sbf-Jarvis-Reason'][0] == "RESOURCE_ID_NOT_VALID"

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | RESOURCE_ID |
      | azhou1@scholastic.com | password2 | 5734325     |

  @Unhappy
  Scenario Outline: Validate when user uses invalid fair ID for user:<USER_NAME> and fair:<RESOURCE_ID>
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
    * url BOOKFAIRS_JARVIS_URL
    * path selectFairUri, RESOURCE_ID
    * cookies { SCHL : #(schlResponse.SCHL)}
    * param fairSelectionMode = "SELECT"
    Given method get
    Then match responseStatus == 404
    And match responseHeaders['Sbf-Jarvis-Reason'][0] == "MALFORMED_RESOURCE_ID"

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | RESOURCE_ID |
      | azhou1@scholastic.com | password2 | abc1234     |

  @Happy
  Scenario Outline: Validate when user inputs different configurations for fairId/current for user:<USER_NAME>, fair:<RESOURCE_ID>, scenario:<SCENARIO>
    Given def selectFairResponse = call read('classpath:common/bookfairs/jarvis/SelectionAndBasicInfo/RunnerHelper.feature@SelectFair')
    Then match selectFairResponse.response.fair.id == EXPECTED_FAIR
    And if(RESOURCE_ID == 'current') karate.log(karate.match(selectFairResponse.responseHeaders['Sbf-Jarvis-Default-Fair'][0], 'AUTOMATICALLY_SELECTED_THIS_REQUEST'))

    @QA
    Examples:
      | USER_NAME                                   | PASSWORD  | RESOURCE_ID | EXPECTED_FAIR | SCENARIO                                     |
      | azhou1@scholastic.com                       | password1 | 5694296     | 5694296       | Return path parameter fairId information     |
      | azhou1@scholastic.com                       | password1 | current     | 5694296       | Has current, upcoming, and past fairs        |
      | hasAllFairs@testing.com                     | password1 | current     | 5694301       | Has all fairs                                |
      | hasUpcomingAndPastFairs@testing.com         | password1 | current     | 5694305       | Has upcoming and past fairs                  |
      | hasPastFairs@testing.com                    | password1 | current     | 5694307       | Has past fairs                               |
      | hasRecentlyUpcomingAndPastFairs@testing.com | password1 | current     | 5694303       | Has recently ended, upcoming, and past fairs |

  @Happy
  Scenario Outline: Validate when user has only one fair or multiple fairs that enableSwitch is false or true respectively, user:<USER_NAME>
    Given def selectFairResponse = call read('classpath:common/bookfairs/jarvis/SelectionAndBasicInfo/RunnerHelper.feature@SelectFair'){RESOURCE_ID: 'current'}
    Then match selectFairResponse.responseStatus == 200
    Then match selectFairResponse.response.enableSwitch == '#(ENABLE_SWITCH_EXPECTED === "true")'

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | ENABLE_SWITCH_EXPECTED |
      | azhou1@scholastic.com | password2 | true                   |
      | onefair@testing.com   | password1 | false                  |

  @Happy
  Scenario Outline: Validate successful response for valid request for user:<USER_NAME> and fair:<RESOURCE_ID>
    Given def selectFairResponse = call read('classpath:common/bookfairs/jarvis/SelectionAndBasicInfo/RunnerHelper.feature@SelectFair')
    Then match selectFairResponse.responseStatus == 200

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | RESOURCE_ID |
      | azhou1@scholastic.com | password2 | 5694296     |

# Testing with fairSelectionMode set to DO_NOT_SELECT:

  @Happy @GetFairInfo
  Scenario Outline: Validate successful response for valid request for user:<USER_NAME> and fair:<RESOURCE_ID>
    Given def getFairResponse = call read('classpath:common/bookfairs/jarvis/SelectionAndBasicInfo/RunnerHelper.feature@GetFairInfo')
    Then match getFairResponse.responseStatus == 200

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | RESOURCE_ID |
      | azhou1@scholastic.com | password2 | 5694296     |

  @Happy @GetFairInfo
  Scenario Outline: Validate when user doesn't have access to CPTK for user:<USER_NAME> and fair:<RESOURCE_ID>
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
    * url BOOKFAIRS_JARVIS_URL
    * path selectFairUri, 'current'
    * cookies { SCHL : #(schlResponse.SCHL)}
    * param fairSelectionMode = "DO_NOT_SELECT"
    Given method get
    Then match responseStatus == 204
    And match responseHeaders['Sbf-Jarvis-Reason'][0] == "NO_ASSOCIATED_RESOURCES"

    @QA
    Examples:
      | USER_NAME           | PASSWORD  | RESOURCE_ID |
      | nofairs@testing.com | password1 | current     |

  @Unhappy @GetFairInfo
  Scenario Outline: Validate when SCHL cookie is not passed for fair:<RESOURCE_ID>
    * url BOOKFAIRS_JARVIS_URL
    * path selectFairUri, RESOURCE_ID
    * param fairSelectionMode = "DO_NOT_SELECT"
    Given method get
    Then match responseStatus == 204
    And match responseHeaders['Sbf-Jarvis-Reason'][0] == "NO_SCHL"

    @QA
    Examples:
      | RESOURCE_ID |
      | 5694296     |
      | current     |

  @Unhappy @GetFairInfo
  Scenario Outline: Validate when SCHL cookie is expired
    * url BOOKFAIRS_JARVIS_URL
    * path selectFairUri, 'current'
    * param fairSelectionMode = "DO_NOT_SELECT"
    * cookies { SCHL : '<EXPIRED_SCHL>'}
    Given method get
    Then match responseStatus == 204
    And match responseHeaders['Sbf-Jarvis-Reason'][0] == "NO_SCHL"

    @QA
    Examples:
      | EXPIRED_SCHL                                                                                                                                                                                                                                                      |
      | eyJraWQiOiJub25wcm9kLTIwMjEzMzExMzMyIiwidHlwIjoiSldUIiwiYWxnIjoiSFMyNTYifQ.eyJpc3MiOiJNeVNjaGwiLCJhdWQiOiJTY2hvbGFzdGljIiwibmJmIjoxNjk5MzkwNzUyLCJzdWIiOiI5ODYzNTUyMyIsImlhdCI6MTY5OTM5MDc1NywiZXhwIjoxNjk5MzkyNTU3fQ.s3Czg7lmT6kETAcyupYDus8sxtFQMz7YOMKWz1_S-i8 |


  @Unhappy @GetFairInfo
  Scenario Outline: Validate when user doesn't have access to specific fair for user:<USER_NAME> and fair:<RESOURCE_ID>
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
    * url BOOKFAIRS_JARVIS_URL
    * path selectFairUri, RESOURCE_ID
    * cookies { SCHL : #(schlResponse.SCHL)}
    * param fairSelectionMode = "DO_NOT_SELECT"
    Given method get
    Then match responseStatus == 403
    And match responseHeaders['Sbf-Jarvis-Reason'][0] == "RESOURCE_ID_NOT_VALID"

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | RESOURCE_ID |
      | azhou1@scholastic.com | password2 | 5734325     |

  @Unhappy @GetFairInfo
  Scenario Outline: Validate when user uses invalid fair ID for user:<USER_NAME> and fair:<RESOURCE_ID>
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
    * url BOOKFAIRS_JARVIS_URL
    * path selectFairUri, RESOURCE_ID
    * cookies { SCHL : #(schlResponse.SCHL)}
    * param fairSelectionMode = "DO_NOT_SELECT"
    Given method get
    Then match responseStatus == 404
    And match responseHeaders['Sbf-Jarvis-Reason'][0] == "MALFORMED_RESOURCE_ID"

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | RESOURCE_ID |
      | azhou1@scholastic.com | password2 | abc1234     |

  @Happy @GetFairInfo
  Scenario Outline: Validate when user inputs different configurations for fairId/current WITH SBF_JARVIS for DO_NOT_SELECT mode with user:<USER_NAME>, fair:<RESOURCE_ID>, cookie fair:<SBF_JARVIS_FAIR>
    Given def selectFairResponse = call read('classpath:common/bookfairs/jarvis/SelectionAndBasicInfo/RunnerHelper.feature@SelectFair'){RESOURCE_ID: <SBF_JARVIS_FAIR>}
    * url BOOKFAIRS_JARVIS_URL
    * path selectFairUri, RESOURCE_ID
    * cookies { SCHL : '#(selectFairResponse.SCHL)', SBF_JARVIS: '#(selectFairResponse.SBF_JARVIS)'}
    * param fairSelectionMode = "DO_NOT_SELECT"
    Then method get
    And match response.fair.id == EXPECTED_FAIR
    And if(RESOURCE_ID == 'current') karate.log(karate.match(responseHeaders['Sbf-Jarvis-Default-Fair'][0], 'PREVIOUSLY_SELECTED'))
    And if(RESOURCE_ID != 'current') karate.log(karate.match(responseHeaders['Sbf-Jarvis-Default-Fair'][0], 'MANUALLY_SELECTED_THIS_REQUEST'))

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | RESOURCE_ID | EXPECTED_FAIR | SBF_JARVIS_FAIR |
      | azhou1@scholastic.com | password2 | 5694296     | 5694296       | 5694300         |
      | azhou1@scholastic.com | password2 | current     | 5694296       | 5694296         |

  @Happy @GetFairInfo
  Scenario Outline: Validate when user inputs different configurations for fairId/current for user:<USER_NAME>, fair:<RESOURCE_ID>
    Given def getFairResponse = call read('classpath:common/bookfairs/jarvis/SelectionAndBasicInfo/RunnerHelper.feature@GetFairInfo')
    Then match getFairResponse.response.fair.id == EXPECTED_FAIR

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | RESOURCE_ID | EXPECTED_FAIR |
      | azhou1@scholastic.com | password2 | 5694296     | 5694296       |

  @Happy @GetFairInfo
  Scenario Outline: Validate when user inputs current for GetFairInfo user:<USER_NAME>, fair:<RESOURCE_ID>
    Given def getFairResponse = call read('classpath:common/bookfairs/jarvis/SelectionAndBasicInfo/RunnerHelper.feature@GetFairInfo'){RESOURCE_ID: 'current'}
    Then match getFairResponse.response.fair.id == '#notpresent'

    @QA
    Examples:
      | USER_NAME             | PASSWORD  |
      | azhou1@scholastic.com | password2 |


