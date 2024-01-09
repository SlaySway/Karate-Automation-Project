@PostCOApdfLinkTest @PerformanceEnhancement
Feature: PostCOApdfLink API automation tests

  Background: Set config
    * string postCOApdfLinkUri = "/bookfairs-jarvis/api/user/fairs/<fairIdOrCurrent>/coa/pdf-links"
    * def obj = Java.type('utils.StrictValidation')

  Scenario Outline: Validate with a valid fairId or current keyword
    * def requestBody =
      """
        {
        "email": '<EMAIL>',
        "message": '<MESSAGE>',
        }
      """
    * def postCOApdfLinkResponse = call read('classpath:common/bookfairs/jarvis/BeforeCOAAccepted/RunnerHelper.feature@PostCOApdfLink')
    Then match postCOApdfLinkResponse.responseStatus == 200
    Then match postCOApdfLinkResponse.response == 'Successful'

    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT | EMAIL                 | MESSAGE |
      | azhou1@scholastic.com | password1 | 5694296           | azhou1@scholastic.com | test    |
      | azhou1@scholastic.com | password1 | current           | azhou1@scholastic.com | TEST3   |

  Scenario Outline: Validate regression using dynamic comparison || fairId=<FAIR_ID>
    * def requestBody =
      """
        {
        "email": '<EMAIL>',
        "message": '<MESSAGE>',
        }
      """
    * def TargetResponseMap = call read('classpath:common/bookfairs/jarvis/BeforeCOAAccepted/RunnerHelper.feature@PostCOApdfLink')
    * def BaseResponseMap = call read('classpath:common/bookfairs/jarvis/BeforeCOAAccepted/RunnerHelper.feature@PostCOApdfLinkBase')
    Then match BaseResponseMap.responseStatus == TargetResponseMap.responseStatus
    Then match BaseResponseMap.response == TargetResponseMap.response
    * string base = BaseResponseMap.response
    * string target = TargetResponseMap.response
    * def compResult = obj.strictCompare(base, target)
    Then print "Response from production code base", base
    Then print "Response from current qa code base", target
    Then print 'Differences any...', compResult
    And match base == target

    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT | EMAIL                 | MESSAGE |
      | azhou1@scholastic.com | password1 | 5694296           | azhou1@scholastic.com | test    |

  Scenario Outline: Validate PostCOApdfLink API with a valid fairId SCHL and Session Cookie
    * def requestBody =
      """
        {
        "email": '<EMAIL>',
        "message": '<MESSAGE>',
        }
      """
    * def postCOApdfLinkResponse = call read('classpath:common/bookfairs/jarvis/BeforeCOAAccepted/RunnerHelper.feature@PostCOApdfLink')
    Then match postCOApdfLinkResponse.responseStatus == 200
    * print postCOApdfLinkResponse.response

    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT | EMAIL                 | MESSAGE |
      | azhou1@scholastic.com | password1 | 5694296           | azhou1@scholastic.com | test    |

  Scenario Outline: Validate PostCOApdfLink API with current keyword SCHL and Session Cookie
    * def getCookie = call read('classpath:common/bookfairs/jarvis/SelectionAndBasicInfo/RunnerHelper.feature@SelectFair')
    * def requestBody =
      """
        {
        "email": '<EMAIL>',
        "message": '<MESSAGE>',
        }
      """
    * def postCOApdfLinkResponse = call read('classpath:common/bookfairs/jarvis/BeforeCOAAccepted/RunnerHelper.feature@PostCOApdfLink')
    Then match postCOApdfLinkResponse.responseStatus == 200
    * print postCOApdfLinkResponse.response

    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT | EMAIL                 | MESSAGE |
      | azhou1@scholastic.com | password1 | current           | azhou1@scholastic.com | test    |

  Scenario Outline: Validate with invalid fairId and valid login session
    * def requestBody =
      """
        {
        "email": '<EMAIL>',
        "message": '<MESSAGE>',
        }
      """
    And replace postCOApdfLinkUri.fairIdOrCurrent = FAIRID_OR_CURRENT
    Given url BOOKFAIRS_JARVIS_URL + postCOApdfLinkUri
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
    And cookies { SCHL : '#(schlResponse.SCHL)'}
    And request requestBody
    And method POST
    Then match responseStatus == 403
    And match responseHeaders['Sbf-Jarvis-Reason'][0] == "FAIR_ID_NOT_VALID"

    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT | EMAIL                 | MESSAGE |
      | azhou1@scholastic.com | password1 | 6598              | azhou1@scholastic.com | test    |

  Scenario Outline: Validate with invalid login session and a valid fairId
    * def requestBody =
      """
        {
        "email": '<EMAIL>',
        "message": '<MESSAGE>',
        }
      """
    And replace postCOApdfLinkUri.fairIdOrCurrent = FAIRID_OR_CURRENT
    Given url BOOKFAIRS_JARVIS_URL + postCOApdfLinkUri
    And cookies { SCHL : eyJraWQiOiJub25wcm9kLTIwMjEzMzExMzMyIiwidHlwIjoiSldUIiwiYWxnIjoSMyNTYifQ.eyJpc3MiOiJNeVNjaGwiLCJhdWQiOiJTY2hvbGFzdGljIiwibmJmIjoxNzAxMzY1MzUyLCJzdWIiOiI5ODMwMzM2MSIsImlhdCI6MTcwMTM2NTM1NywiZXhwIjoxNzAxMzY3MTU3fQ.RuNxPupsos4pRP7GVeYoUTM_bxxHfXS4FWpf_bZaeZs}
    And request requestBody
    And method POST
    Then match responseStatus == 401

    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT | EMAIL                 | MESSAGE |
      | azhou1@scholastic.com | password1 | 5775209           | azhou1@scholastic.com | test    |

  Scenario Outline: Validate PostCOApdfLink API with invalid keyword and SCHL cookie
    * def requestBody =
      """
        {
        "email": '<EMAIL>',
        "message": '<MESSAGE>',
        }
      """
    And replace postCOApdfLinkUri.fairIdOrCurrent = FAIRID_OR_CURRENT
    Given url BOOKFAIRS_JARVIS_URL + postCOApdfLinkUri
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
    And cookies { SCHL : '#(schlResponse.SCHL)'}
    And request requestBody
    And method POST
    Then match responseStatus == 404

    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT | EMAIL                 | MESSAGE |
      | azhou1@scholastic.com | password1 | testing           | azhou1@scholastic.com | test    |

  Scenario Outline: Validate with invalid login session and a valid fairId
    * def requestBody =
      """
        {
        "email": '<EMAIL>',
        "message": '<MESSAGE>',
        }
      """
    And replace postCOApdfLinkUri.fairIdOrCurrent = FAIRID_OR_CURRENT
    Given url BOOKFAIRS_JARVIS_URL
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
    And cookies { SCHL : '#(schlResponse.SCHL)'}
    And request requestBody
    And method POST
    Then match responseStatus == 404

    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT | EMAIL                 | MESSAGE |
      | azhou1@scholastic.com | password1 | 5775209           | azhou1@scholastic.com | test    |

  Scenario Outline: Validate PostCOApdfLink API with SCHL Session Cookie and no request payload
    * def requestBody = ""
    * def postCOApdfLinkResponse = call read('classpath:common/bookfairs/jarvis/BeforeCOAAccepted/RunnerHelper.feature@PostCOApdfLink')
    Then match postCOApdfLinkResponse.responseStatus == 415

    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT | EMAIL                 | MESSAGE |
      | azhou1@scholastic.com | password1 | 5775209           | azhou1@scholastic.com | test    |


  @Unhappy
  Scenario Outline: Validate when SCHL cookie is not passed for fair:<FAIRID_OR_CURRENT>
    * replace postCOApdfLinkUri.fairIdOrCurrent = FAIRID_OR_CURRENT
    * url BOOKFAIRS_JARVIS_URL + postCOApdfLinkUri
    Given method get
    Then match responseStatus == 204
    And match responseHeaders['Sbf-Jarvis-Reason'][0] == "NO_SCHL"

    @QA
    Examples:
      | FAIRID_OR_CURRENT |
      | 5694296           |

  @Unhappy
  Scenario Outline: Validate when user uses an invalid fair ID for user:<USER_NAME> and fair:<FAIRID_OR_CURRENT>
    Given def postCOApdfLinkResponse = call read('RunnerHelper.feature@PostCOApdfLink')
    Then match postCOApdfLinkResponse.responseStatus == 404
    And match postCOApdfLinkResponse.responseHeaders['Sbf-Jarvis-Reason'][0] == "MALFORMED_FAIR_ID"

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com | password1 | abc1234           |