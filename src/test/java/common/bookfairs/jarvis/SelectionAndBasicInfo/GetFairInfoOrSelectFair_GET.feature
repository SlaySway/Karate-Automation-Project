@GetFairInfoOrSelectFair
Feature: GetFairInfoOrSelectFair GET Api tests

  Background: Set config
    * def obj = Java.type('utils.StrictValidation')
    * string selectionAndBasicInfoUri = "/bookfairs-jarvis/api/user/fairs/<fairIdOrCurrent>"

  @Happy
  Scenario Outline: Validate successful response for valid request
    * def selectFairResponse = call read('classpath:common/bookfairs/jarvis/SelectionAndBasicInfo/RunnerHelper.feature@SelectFair'){USER_NAME : '<USER_NAME>', PASSWORD : '<PASSWORD>', FAIRID_OR_CURRENT: '<FAIRID_OR_CURRENT>'}
    Then match selectFairResponse.responseStatus == 200

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com | password1 | 5633533           |

  @Unhappy
  Scenario Outline: Validate when SCHL cookie is not passed
    Given replace selectionAndBasicInfoUri.fairIdOrCurrent = '<FAIRID_OR_CURRENT>'
    And url BOOKFAIRS_JARVIS_URL + selectionAndBasicInfoUri
    When method get
    Then match responseStatus == 401

    @QA
    Examples:
      | FAIRID_OR_CURRENT |
      | 5633533           |
      | current           |

  @Unhappy
  Scenario Outline: Validate when SCHL cookie is expired
    Given replace selectionAndBasicInfoUri.fairIdOrCurrent = 'current'
    And cookies { SCHL : '<EXPIRED_SCHL>'}
    And url BOOKFAIRS_JARVIS_URL + selectionAndBasicInfoUri
    When method get
    Then match responseStatus == 401

    @QA
    Examples:
      | EXPIRED_SCHL |
      | eyJraWQiOiJub25wcm9kLTIwMjEzMzExMzMyIiwidHlwIjoiSldUIiwiYWxnIjoiSFMyNTYifQ.eyJpc3MiOiJNeVNjaGwiLCJhdWQiOiJTY2hvbGFzdGljIiwibmJmIjoxNjk5MzkwNzUyLCJzdWIiOiI5ODYzNTUyMyIsImlhdCI6MTY5OTM5MDc1NywiZXhwIjoxNjk5MzkyNTU3fQ.s3Czg7lmT6kETAcyupYDus8sxtFQMz7YOMKWz1_S-i8 |

  @Happy
  Scenario Outline: Validate when user doesn't have access to CPTK
    * def selectFairResponse = call read('classpath:common/bookfairs/jarvis/SelectionAndBasicInfo/RunnerHelper.feature@SelectFair'){USER_NAME : '<USER_NAME>', PASSWORD : '<PASSWORD>', FAIRID_OR_CURRENT: '<FAIRID_OR_CURRENT>'}
    Then match selectFairResponse.responseStatus == 204
    Then match selectFairResponse.responseHeaders['Sbf-Jarvis-Reason'][0] == "NO_ASSOCIATED_FAIRS"

    @QA
    Examples:
      | USER_NAME           | PASSWORD  | FAIRID_OR_CURRENT |
      | nofairs@testing.com | password1 | current           |

  @Unhappy
  Scenario Outline: Validate when user doesn't have access to specific fair
    * def selectFairResponse = call read('classpath:common/bookfairs/jarvis/SelectionAndBasicInfo/RunnerHelper.feature@SelectFair'){USER_NAME : '<USER_NAME>', PASSWORD : '<PASSWORD>', FAIRID_OR_CURRENT: '<FAIRID_OR_CURRENT>'}
    Then match selectFairResponse.responseStatus == 403
    Then match selectFairResponse.responseHeaders['Sbf-Jarvis-Reason'][0] == "FAIR_ID_NOT_VALID"

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com | password1 | 5734325           |

  @Happy
  Scenario Outline: Validate when user inputs different configurations
    Given schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner'){USER_NAME : '#(USER_NAME)', PASSWORD : '#(PASSWORD)'}

    * def selectFairResponse = call read('classpath:common/bookfairs/jarvis/SelectionAndBasicInfo/RunnerHelper.feature@SelectFairTest'){USER_NAME : '<USER_NAME>', PASSWORD : '<PASSWORD>', FAIRID_OR_CURRENT: '<FAIRID_OR_CURRENT>'}
    Then match selectFairResponse.responseStatus == 403
    Then match selectFairResponse.responseHeaders['Sbf-Jarvis-Reason'][0] == "FAIR_ID_NOT_VALID"

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT | SCHL_INCLUDED |
      | azhou1@scholastic.com | password1 | 5734325           | false         |
