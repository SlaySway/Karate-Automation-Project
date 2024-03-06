@PostCOARequestChangeTest @PerformanceEnhancement
Feature: PostRequestChange API automation tests

  Background: Set config
    * string postCOARequestChangeUri = "/bookfairs-jarvis/api/user/fairs/<fairIdOrCurrent>/coa/change-request"
    * def obj = Java.type('utils.StrictValidation')

  Scenario Outline: Validate with a valid fairId or current keyword
    * def requestBody =
     """
       {
        "additionalDetails": '<additionalDetails>',
        "contactMethod": '<Cnt_Method>',
        "reasons": [
        "test"
         ]
        }
      """
    * def postCOAChangeRequestResponse = call read('classpath:common/bookfairs/jarvis/BeforeCOAAccepted/RunnerHelper.feature@PostChangeRequest')
    Then match postCOAChangeRequestResponse.responseStatus == 201

    @QA
    Examples:
      | USER_NAME                           | PASSWORD  | FAIRID_OR_CURRENT | additionalDetails | Cnt_Method |
      | azhou1@scholastic.com               | password1 | 5694296           | Test1             | Email      |
      | sdevineni-consultant@scholastic.com | passw0rd  | 5782071           | TEST2             | PhoneNum   |
      | sdevineni-consultant@scholastic.com | passw0rd  | current           | Siva              | Email      |
      | azhou1@scholastic.com               | password1 | current           | And               | Phn        |

  Scenario Outline: Validate regression using dynamic comparison || fairId=<FAIR_ID>
    * def requestBody =
     """
       {
        "additionalDetails": '<additionalDetails>',
        "contactMethod": '<Cnt_Method>',
        "reasons": [
        "test"
         ]
        }
      """
    * def TargetResponseMap = call read('classpath:common/bookfairs/jarvis/BeforeCOAAccepted/RunnerHelper.feature@PostChangeRequest')
    * def BaseResponseMap = call read('classpath:common/bookfairs/jarvis/BeforeCOAAccepted/RunnerHelper.feature@PostChangeRequestBase')
    Then match BaseResponseMap.responseStatus == TargetResponseMap.responseStatus
    Then match BaseResponseMap.response == TargetResponseMap.response

    * string base = BaseResponseMap.response
    * string target = TargetResponseMap.response
    * def compResult = obj.strictCompare(base, target)
    Then print "Response from production code base", base
    Then print "Response from current qa code base", target
    Then print 'Differences any...', compResult
    And match base == target

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT | additionalDetails | Cnt_Method |
      | azhou1@scholastic.com | password1 | 5694296           | Test1             | Email      |
      | azhou1@scholastic.com | password1 | current           | And               | Phn        |

  Scenario Outline: Validate with invalid login session and a valid fairId
    * def requestBody =
     """
       {
        "additionalDetails": '<additionalDetails>',
        "contactMethod": '<Cnt_Method>',
        "reasons": [
        "test"
         ]
        }
      """
    And replace postCOARequestChangeUri.fairIdOrCurrent = FAIRID_OR_CURRENT
    Given url BOOKFAIRS_JARVIS_URL + postCOARequestChangeUri
    And cookies { SCHL : eyJraWQiOiJub25wcm9kLTIwMjEzMzExMzMyIiwidHlwIjoiSldUIiwiYWxnIjoSMyNTYifQ.eyJpc3MiOiJNeVNjaGwiLCJhdWQiOiJTY2hvbGFzdGljIiwibmJmIjoxNzAxMzY1MzUyLCJzdWIiOiI5ODMwMzM2MSIsImlhdCI6MTcwMTM2NTM1NywiZXhwIjoxNzAxMzY3MTU3fQ.RuNxPupsos4pRP7GVeYoUTM_bxxHfXS4FWpf_bZaeZs}
    And request requestBody
    And method POST
    Then match responseStatus == 401

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT | additionalDetails | Cnt_Method |
      | azhou1@scholastic.com | password1 | 5775209           | Test1             | Email      |
      | azhou1@scholastic.com | password1 | current           | And               | Phn        |

  Scenario Outline: Validate with valid login session and a invalid fairId
    * def requestBody =
     """
       {
        "additionalDetails": '<additionalDetails>',
        "contactMethod": '<Cnt_Method>',
        "reasons": [
        "test"
         ]
        }
      """
    And replace postCOARequestChangeUri.fairIdOrCurrent = FAIRID_OR_CURRENT
    Given url BOOKFAIRS_JARVIS_URL + postCOARequestChangeUri
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunnerBase')
    And cookies { SCHL : '#(schlResponse.SCHL)'}
    And request requestBody
    And method POST
    Then match responseStatus == 403

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT | additionalDetails | Cnt_Method |
      | azhou1@scholastic.com | password1 | 57752ui           | Test1             | Email      |


  Scenario Outline: Validate with current keyword valid SCHL and invalid fairsession
    * def requestBody =
     """
       {
        "additionalDetails": '<additionalDetails>',
        "contactMethod": '<Cnt_Method>',
        "reasons": [
        "test"
         ]
        }
      """
    * def sbf_jarvis = call read('classpath:common/bookfairs/jarvis/SelectionAndBasicInfo/RunnerHelper.feature@SelectFair')
    And replace postCOARequestChangeUri.fairIdOrCurrent = FAIRID_OR_CURRENT
    Given url BOOKFAIRS_JARVIS_URL + postCOARequestChangeUri
    And cookies { SCHL : '#(sbf_jarvis.SCHL)',SBF_JARVIS  :eyJraWQiOiJub25wcm9kLTIwMjEzMzExMzMyIiwidHlwIjoiSldUIiwiYWxnIjoSMyNTYifQ}
    And request requestBody
    And method POST
    Then match responseStatus == 400

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT | additionalDetails | Cnt_Method |
      | azhou1@scholastic.com | password1 | current           | Test1             | Email      |

  Scenario Outline: Validate PostCOApdfLink API with SCHL Session Cookie and no request payload
    * def requestBody = ""
    * def postCOApdfLinkResponse = call read('classpath:common/bookfairs/jarvis/BeforeCOAAccepted/RunnerHelper.feature@PostChangeRequest')
    Then match postCOApdfLinkResponse.responseStatus == 415

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com | password1 | 5775209           |

  @Unhappy
  Scenario Outline: Validate when SCHL cookie is not passed for fair:<FAIRID_OR_CURRENT>
    * replace postCOARequestChangeUri.fairIdOrCurrent = FAIRID_OR_CURRENT
    * url BOOKFAIRS_JARVIS_URL + postCOARequestChangeUri
    Given method post
    Then match responseStatus == 204
    And match responseHeaders['Sbf-Jarvis-Reason'][0] == "NO_SCHL"

    @QA
    Examples:
      | FAIRID_OR_CURRENT |
      | 5694296           |

  @Unhappy
  Scenario Outline: Validate when user uses an invalid fair ID for user:<USER_NAME> and fair:<FAIRID_OR_CURRENT>
    Given def getCoaDatesResponse = call read('RunnerHelper.feature@PostChangeRequest')
    Then match getCoaDatesResponse.responseStatus == 404
    And match getCoaDatesResponse.responseHeaders['Sbf-Jarvis-Reason'][0] == "MALFORMED_RESOURCE_ID"

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT | requestBody |
      | azhou1@scholastic.com | password1 | abc1234           | {}          |