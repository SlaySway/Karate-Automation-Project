@PostCOARequestChangeTest
Feature: PostRequestChange API automation tests

  Background: Set config
    * string postCOARequestChangeUri = "/bookfairs-jarvis/api/user/fairs/<fairIdOrCurrent>/coa/change-request"

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
    * def postCOAChangeRequestResponse = call read('classpath:common/bookfairs/jarvis/BeforeCOAAccepted/RunnerHelper.feature@PostChangeRequest'){USER_NAME : '<USER_NAME>', PASSWORD : '<PASSWORD>', FAIRID_OR_CURRENT : '<fairIdOrCurrent>',REQUEST_BODY : '#(requestBody)'}
    Then match postCOAChangeRequestResponse.responseStatus == 201

    Examples:
      | USER_NAME                           | PASSWORD  | fairIdOrCurrent | additionalDetails| Cnt_Method|
      | azhou1@scholastic.com               | password1 | 5633533         | Test1            | Email     |
      | sdevineni-consultant@scholastic.com | passw0rd  | 5782071         | TEST2            | PhoneNum  |
  #      With current keyword test is getting failed
#      | sdevineni-consultant@scholastic.com | passw0rd  | current         | Siva             | Email     |
#      | azhou1@scholastic.com               | password1 | current         | And              | Phn       |

  #  Scenario Outline: Validate regression using dynamic comparison || fairId=<FAIR_ID>
#    * def requestBody =
#     """
#       {
#        "additionalDetails": '<additionalDetails>',
#        "contactMethod": '<Cnt_Method>',
#        "reasons": [
#        "test"
#         ]
#        }
#      """
 #   * def TargetResponseMap = call read('classpath:common/bookfairs/jarvis/BeforeCOAAccepted/RunnerHelper.feature@PostChangeRequest'){USER_NAME : '<USER_NAME>', PASSWORD : '<PASSWORD>', FAIRID_OR_CURRENT : '<fairIdOrCurrent>',REQUEST_BODY : '#(requestBody)'}
 #   * def BaseResponseMap = call read('classpath:common/bookfairs/jarvis/BeforeCOAAccepted/RunnerHelper.feature@PostChangeRequestBase'){USER_NAME : '<USER_NAME>', PASSWORD : '<PASSWORD>', FAIRID_OR_CURRENT : '<fairIdOrCurrent>',REQUEST_BODY : '#(requestBody)'}
#    Then match BaseResponseMap.responseStatus == TargetResponseMap.responseStatus
#    Then match BaseResponseMap.response == TargetResponseMap.response
#
#    * string base = BaseResponseMap.response
#    * string target = TargetResponseMap.response
#    * def compResult = obj.strictCompare(base, target)
#    Then print "Response from production code base", base
#    Then print "Response from current qa code base", target
#    Then print 'Differences any...', compResult
#    And match BaseResponseMap.BaseResponse == TargetResponseMap.TargetResponse
#
#    Examples:

#      | USER_NAME                           | PASSWORD  | fairIdOrCurrent | additionalDetails| Cnt_Method|
#      | azhou1@scholastic.com               | password1 | 5633533         | Test1            | Email     |
#      | sdevineni-consultant@scholastic.com | passw0rd  | 5782071         | TEST2            | PhoneNum  |
#      | sdevineni-consultant@scholastic.com | passw0rd  | current         | Test1            | Email     |
#      | azhou1@scholastic.com               | password1 | current         | Test1            | Email     |

  Scenario Outline: Validate PostChangeCOARequest API with a valid fairId SCHL and Session Cookie
    * def getCookie = call read('classpath:common/bookfairs/jarvis/SelectionAndBasicInfo/RunnerHelper.feature@SelectFair'){FAIRID_OR_CURRENT : '<fairIdOrCurrent>'}
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
    * def postCOAChangeRequestResponse = call read('classpath:common/bookfairs/jarvis/BeforeCOAAccepted/RunnerHelper.feature@PostChangeRequest'){USER_NAME : '<USER_NAME>', PASSWORD : '<PASSWORD>', FAIRID_OR_CURRENT : '<fairIdOrCurrent>',REQUEST_BODY : '#(requestBody)'}
    Then match postCOAChangeRequestResponse.responseStatus == 201
    * print postCOAChangeRequestResponse.response

    Examples:
      | USER_NAME                           | PASSWORD  | fairIdOrCurrent | additionalDetails| Cnt_Method|
      | azhou1@scholastic.com               | password1 | 5633533         | TEST2            | PhoneNum  |
      | sdevineni-consultant@scholastic.com | passw0rd  | 5644038         | TEST1            | PhoneNum  |

  Scenario Outline: Validate PostChangeCOARequest API with current keyword SCHL and Session Cookie
    * def getCookie = call read('classpath:common/bookfairs/jarvis/SelectionAndBasicInfo/RunnerHelper.feature@SelectFair'){FAIRID_OR_CURRENT : '<fairIdOrCurrent>'}
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
    * def postCOAChangeRequestResponse = call read('classpath:common/bookfairs/jarvis/BeforeCOAAccepted/RunnerHelper.feature@PostChangeRequest'){USER_NAME : '<USER_NAME>', PASSWORD : '<PASSWORD>', FAIRID_OR_CURRENT : '<fairIdOrCurrent>',REQUEST_BODY : '#(requestBody)'}
    Then match postCOAChangeRequestResponse.responseStatus == 201
    * print postCOAChangeRequestResponse.response

    Examples:
      | USER_NAME                           | PASSWORD  | fairIdOrCurrent |additionalDetails| Cnt_Method|
      | azhou1@scholastic.com               | password1 | current         |TEST2            | PhoneNum  |
      | sdevineni-consultant@scholastic.com | passw0rd  | current         |TEST3            | PhoneNum  |

  Scenario Outline: Validate with invalid fairId or current keyword
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
    * def postCOAChangeRequestResponse = call read('classpath:common/bookfairs/jarvis/BeforeCOAAccepted/RunnerHelper.feature@PostChangeRequest'){USER_NAME : '<USER_NAME>', PASSWORD : '<PASSWORD>', FAIRID_OR_CURRENT : '<fairIdOrCurrent>',REQUEST_BODY : '#(requestBody)'}
    Then match postCOAChangeRequestResponse.responseStatus == 401

    Examples:
      | USER_NAME                           | PASSWORD  | fairIdOrCurrent | additionalDetails| Cnt_Method|
      | azhou1@scholastic.com               | password1 | 56335           | Test1            | Email     |
