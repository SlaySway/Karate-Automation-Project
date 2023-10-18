@getCOAConfirmTest
Feature: GetCOAConfirmation API automation tests

  Background: Set config
    * string getCOAConfirmUrl = "/api/private/fairs/current/coa"
    * def obj = Java.type('utils.StrictValidation')

  Scenario Outline: Validate when sessoion cookies are not passed
    Given url BOOKFAIRS_JARVIS_TARGET + getCOAConfirmUrl
    When method get
    Then match responseStatus == 401

    Examples: 
      | USER_NAME                    | PASSWORD |
      | sd-consultant@scholastic.com | passw0rd |

  Scenario Outline: Validate when sessoion cookies are invalid
    Given url BOOKFAIRS_JARVIS_TARGET + getCOAConfirmUrl
    And cookies {SCHL : 'eyJraWQiOiJub25wcm9kLTIwMjEzMzExMzMyIiwidHlwIjoiSldUIiwiYWxnIjoiSFMyNTYifQ.e', SBF_JARVIS : 'eyJraWQiOiJub25wcm9kLTIwMjEzMzExMzMyIiwidHlwIjoiSldUIiwiYWxnIjoiSFMyNTYifQ.e'}
    When method get
    Then match responseStatus == 401

    Examples: 
      | USER_NAME                    | PASSWORD |
      | sd-consultant@scholastic.com | passw0rd |

  Scenario Outline: Validate 200 response code for a valid request || fairId=<FAIR_ID>
    * def ResponseDataMap = call read('classpath:common/bookfairs/jarvis/coa_controller/COARunnerHelper.feature@getCoaConfirmTarget'){USER_ID : '<USER_NAME>', PWD : '<PASSWORD>', FAIRID : '<FAIR_ID>'}
    Then match ResponseDataMap.TargetStatCd == 200
    And print ResponseDataMap.TargetResponse

    Examples: 
      | USER_NAME              | PASSWORD | FAIR_ID |
      | mtodaro@scholastic.com | passw0rd | 5782058 |

  Scenario Outline: Validate service response schema || fairId=<FAIR_ID>
    * def ResponseDataMap = call read('classpath:common/bookfairs/jarvis/coa_controller/COARunnerHelper.feature@getCoaConfirmTarget'){USER_ID : '<USER_NAME>', PWD : '<PASSWORD>', FAIRID : '<FAIR_ID>'}
    Then match ResponseDataMap.TargetStatCd == 200
    And json ActualResponseSchema = ResponseDataMap.TargetResponse
    And json ExpectedSchema = call read('classpath:common/bookfairs/jarvis/coa_controller/GetCOAConfirmation_schema.json')
    And match ExpectedSchema == ActualResponseSchema

    Examples: 
      | USER_NAME                           | PASSWORD | FAIR_ID |
      | sdevineni-consultant@scholastic.com | passw0rd | 5495158 |

  Scenario Outline: Validate fairType 'bogo tabletop' || fairId=<FAIR_ID>
    * def ResponseDataMap = call read('classpath:common/bookfairs/jarvis/coa_controller/COARunnerHelper.feature@getCoaConfirmTarget'){USER_ID : '<USER_NAME>', PWD : '<PASSWORD>', FAIRID : '<FAIR_ID>'}
    Then json ResponseObject = ResponseDataMap.TargetResponse
    Then match ResponseObject.fairInfo.fairType == 'bogo tabletop'

    Examples: 
      | USER_NAME                           | PASSWORD | FAIR_ID |
      | sdevineni-consultant@scholastic.com | passw0rd | 5638186 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5644037 |

  Scenario Outline: Validate fairType 'Virtual' || fairId=<FAIR_ID>
    * def ResponseDataMap = call read('classpath:common/bookfairs/jarvis/coa_controller/COARunnerHelper.feature@getCoaConfirmTarget'){USER_ID : '<USER_NAME>', PWD : '<PASSWORD>', FAIRID : '<FAIR_ID>'}
    Then json ResponseObject = ResponseDataMap.TargetResponse
    Then match ResponseObject.fairInfo.fairType == 'Virtual'

    Examples: 
      | USER_NAME                           | PASSWORD | FAIR_ID |
      | sdevineni-consultant@scholastic.com | passw0rd | 5731020 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5638188 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5725454 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5731008 |

  Scenario Outline: Validate fairType 'discounted 25%' || fairId=<FAIR_ID>
    * def ResponseDataMap = call read('classpath:common/bookfairs/jarvis/coa_controller/COARunnerHelper.feature@getCoaConfirmTarget'){USER_ID : '<USER_NAME>', PWD : '<PASSWORD>', FAIRID : '<FAIR_ID>'}
    Then json ResponseObject = ResponseDataMap.TargetResponse
    Then match ResponseObject.fairInfo.fairType == 'discounted 25%'

    Examples: 
      | USER_NAME              | PASSWORD | FAIR_ID |
      | mtodaro@scholastic.com | passw0rd | 5782058 |
      | mtodaro@scholastic.com | passw0rd | 5782061 |
      | mtodaro@scholastic.com | passw0rd | 5782060 |
      | mtodaro@scholastic.com | passw0rd | 5782056 |
      | mtodaro@scholastic.com | passw0rd | 5782055 |
      | mtodaro@scholastic.com | passw0rd | 5782053 |

  Scenario Outline: Validate bookfairAccountId is matching with cmdm bookFairId || fairId=<FAIR_ID>
    * def ResponseDataMap = call read('classpath:common/bookfairs/jarvis/coa_controller/COARunnerHelper.feature@getCoaConfirmTarget'){USER_ID : '<USER_NAME>', PWD : '<PASSWORD>', FAIRID : '<FAIR_ID>'}
    * def CMDMResponseDataMap = call read('classpath:common/cmdm/fairs/CMDMRunnerHelper.feature@GetFairRunner'){FAIRID : '<FAIR_ID>'}
    Then match ResponseDataMap.BFAcctId == CMDMResponseDataMap.response.organization.bookfairAccountId

    Examples: 
      | USER_NAME                           | PASSWORD | FAIR_ID |
      | sdevineni-consultant@scholastic.com | passw0rd | 5495158 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5591617 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5644034 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5725452 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5731880 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5725433 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5576627 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5209377 |

  Scenario Outline: Validate regression using dynamic comaprison || fairId=<FAIR_ID>
    * def BaseResponseMap = call read('classpath:common/bookfairs/jarvis/coa_controller/COARunnerHelper.feature@getCoaConfirmBase'){USER_ID : '<USER_NAME>', PWD : '<PASSWORD>', FAIRID : '<FAIR_ID>'}
    * def TargetResponseMap = call read('classpath:common/bookfairs/jarvis/coa_controller/COARunnerHelper.feature@getCoaConfirmTarget'){USER_ID : '<USER_NAME>', PWD : '<PASSWORD>', FAIRID : '<FAIR_ID>'}
    Then match BaseResponseMap.BaseStatCd == TargetResponseMap.TargetStatCd
    * def compResult = obj.strictCompare(BaseResponseMap.BaseResponse, TargetResponseMap.TargetResponse)
    Then print "Response from production code base", BaseResponseMap.BaseResponse
    Then print "Response from current qa code base", TargetResponseMap.TargetResponse
    Then print 'Differences any...', compResult
    And match BaseResponseMap.BaseResponse == TargetResponseMap.TargetResponse
    

    Examples: 
      | USER_NAME                           | PASSWORD | FAIR_ID |
      | mtodaro@scholastic.com              | passw0rd | 5782058 |
      | mtodaro@scholastic.com              | passw0rd | 5782061 |
      | mtodaro@scholastic.com              | passw0rd | 5782060 |
      | mtodaro@scholastic.com              | passw0rd | 5782056 |
      | mtodaro@scholastic.com              | passw0rd | 5782055 |
      | mtodaro@scholastic.com              | passw0rd | 5782053 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5495158 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5591617 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5644034 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5725452 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5731880 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5725433 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5576627 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5209377 |
      | mtodaro@scholastic.com              | passw0rd | 5782061 |
      | mtodaro@scholastic.com              | passw0rd | 5782060 |
      | mtodaro@scholastic.com              | passw0rd | 5782056 |
      | mtodaro@scholastic.com              | passw0rd | 5782055 |
      | mtodaro@scholastic.com              | passw0rd | 5782053 |