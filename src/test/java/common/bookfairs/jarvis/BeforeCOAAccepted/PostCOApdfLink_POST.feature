@PostCOApdfLinkTest
Feature: PostCOApdfLink API automation tests

  Background: Set config
    * string postCOApdfLinkUri = "/bookfairs-jarvis/api/user/fairs/<fairIdOrCurrent>/coa/pdf-links"

  Scenario Outline: Validate with a valid fairId or current keyword
    * def requestBody =
     """
       {
       "email": '<EMAIL>',
       "message": '<MESSAGE>',
       }
      """
    * def postCOApdfLinkResponse = call read('classpath:common/bookfairs/jarvis/BeforeCOAAccepted/RunnerHelper.feature@PostCOApdfLink'){USER_NAME : '<USER_NAME>', PASSWORD : '<PASSWORD>', FAIRID_OR_CURRENT : '<fairIdOrCurrent>',REQUEST_BODY : '#(requestBody)'}
    Then match postCOApdfLinkResponse.responseStatus == 200

    Examples:
      | USER_NAME                           | PASSWORD  | fairIdOrCurrent | EMAIL                             | MESSAGE|
      | azhou1@scholastic.com               | password1 | 5633533         |azhou1@scholastic.com              | test   |
      | sdevineni-consultant@scholastic.com | passw0rd  | 5644038         |sdevineni-consultant@scholastic.com| TEST1  |
#      | sdevineni-consultant@scholastic.com | passw0rd  | current         |sdevineni-consultant@scholastic.com| TEST2  |
#      | azhou1@scholastic.com               | password1 | current         |azhou1@scholastic.com              | TEST3  |

#  Scenario Outline: Validate regression using dynamic comparison || fairId=<FAIR_ID>
#    * def requestBody =
#     """
#       {
#       "email": '<EMAIL>',
#       "message": '<MESSAGE>',
#       }
#      """
#    * def TargetResponseMap = call read('classpath:common/bookfairs/jarvis/BeforeCOAAccepted/RunnerHelper.feature@PostCOApdfLink'){USER_NAME : '<USER_NAME>', PASSWORD : '<PASSWORD>', FAIRID_OR_CURRENT : '<fairIdOrCurrent>',REQUEST_BODY : '#(requestBody)'}
#    * def BaseResponseMap = call read('classpath:common/bookfairs/jarvis/BeforeCOAAccepted/RunnerHelper.feature@PostCOApdfLinkBase'){USER_NAME : '<USER_NAME>', PASSWORD : '<PASSWORD>', FAIRID_OR_CURRENT : '<fairIdOrCurrent>',REQUEST_BODY : '#(requestBody)'}
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
#      | USER_NAME                           | PASSWORD  | fairIdOrCurrent | EMAIL                             | MESSAGE|
#      | azhou1@scholastic.com               | password1 | 5633533         |azhou1@scholastic.com              | test   |
#      | sdevineni-consultant@scholastic.com | passw0rd  | 5644038         |sdevineni-consultant@scholastic.com| TEST1  |
#      | sdevineni-consultant@scholastic.com | passw0rd  | current         |sdevineni-consultant@scholastic.com| TEST2  |
#      | azhou1@scholastic.com               | password1 | current         |azhou1@scholastic.com              | TEST3  |

  Scenario Outline: Validate PostCOApdfLink API with a valid fairId SCHL and Session Cookie
    * def getCookie = call read('classpath:common/bookfairs/jarvis/SelectionAndBasicInfo/RunnerHelper.feature@SelectFair'){FAIRID_OR_CURRENT : '<fairIdOrCurrent>'}
    * def requestBody =
     """
       {
       "email": '<EMAIL>',
       "message": '<MESSAGE>',
       }
      """
    * def postCOApdfLinkResponse = call read('classpath:common/bookfairs/jarvis/BeforeCOAAccepted/RunnerHelper.feature@PostCOApdfLink'){USER_NAME : '<USER_NAME>', PASSWORD : '<PASSWORD>', FAIRID_OR_CURRENT : '<fairIdOrCurrent>',REQUEST_BODY : '#(requestBody)'}
    Then match postCOApdfLinkResponse.responseStatus == 200
    * print postCOApdfLinkResponse.response

    Examples:
      | USER_NAME                           | PASSWORD  | fairIdOrCurrent | EMAIL                             | MESSAGE|
      | azhou1@scholastic.com               | password1 | 5633533         |azhou1@scholastic.com              | test   |
      | sdevineni-consultant@scholastic.com | passw0rd  | 5644038         |sdevineni-consultant@scholastic.com| TEST1  |

  Scenario Outline: Validate PostCOApdfLink API with current keyword SCHL and Session Cookie
    * def getCookie = call read('classpath:common/bookfairs/jarvis/SelectionAndBasicInfo/RunnerHelper.feature@SelectFair'){FAIRID_OR_CURRENT : '<fairIdOrCurrent>'}
    * def requestBody =
     """
       {
       "email": '<EMAIL>',
       "message": '<MESSAGE>',
       }
      """
    * def postCOApdfLinkResponse = call read('classpath:common/bookfairs/jarvis/BeforeCOAAccepted/RunnerHelper.feature@PostCOApdfLink'){USER_NAME : '<USER_NAME>', PASSWORD : '<PASSWORD>', FAIRID_OR_CURRENT : '<fairIdOrCurrent>',REQUEST_BODY : '#(requestBody)'}
    Then match postCOApdfLinkResponse.responseStatus == 200
    * print postCOApdfLinkResponse.response
#showing 400 for current keyword everytime
    Examples:
      | USER_NAME                           | PASSWORD  | fairIdOrCurrent | EMAIL                              | MESSAGE|
      | azhou1@scholastic.com               | password1 | current         | azhou1@scholastic.com              | test   |
      | sdevineni-consultant@scholastic.com | passw0rd  | current         | sdevineni-consultant@scholastic.com| TEST2  |

  Scenario Outline: Validate with invalid fairId or current keyword
    * def getCookie = call read('classpath:common/bookfairs/jarvis/SelectionAndBasicInfo/RunnerHelper.feature@SelectFair'){FAIRID_OR_CURRENT : '<fairIdOrCurrent>'}
    * def requestBody =
     """
       {
       "email": '<EMAIL>',
       "message": '<MESSAGE>',
       }
      """
    * def postCOApdfLinkResponse = call read('classpath:common/bookfairs/jarvis/BeforeCOAAccepted/RunnerHelper.feature@PostCOApdfLink'){USER_NAME : '<USER_NAME>', PASSWORD : '<PASSWORD>', FAIRID_OR_CURRENT : '<fairIdOrCurrent>',REQUEST_BODY : '#(requestBody)'}
    Then match postCOApdfLinkResponse.responseStatus == 403

    Examples:
      | USER_NAME                           | PASSWORD  | fairIdOrCurrent | EMAIL                              | MESSAGE|
      | azhou1@scholastic.com               | password1 | 6598            | azhou1@scholastic.com              | test   |