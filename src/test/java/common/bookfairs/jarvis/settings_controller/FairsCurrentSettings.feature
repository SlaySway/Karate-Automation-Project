#Author: Ravindra Pallerla

@fairsCurrentettingsTest
Feature: FairsCurrentSettings API automation tests

  Background: Set config
    * string userCurrentFairsUrl = "/bookfairs-jarvis/api/user/fairs/current/settings"

  Scenario Outline: Validate 200 response code for a valid request
    * def ResponseDataMap = call read('classpath:utils/ComparisonHelper.feature@FairsCurrentSettingsCompHelper'){userId : '<USER_NAME>', pwd : '<PASSWORD>', fairId : '<FAIR_ID>'}
    Then match ResponseDataMap.TargetStatusCd == 200
    Then match ResponseDataMap.BaseStatusCd == ResponseDataMap.TargetStatusCd
    And match ResponseDataMap.BaseResponse == ResponseDataMap.TargetResponse
    And print ResponseDataMap.BaseResponse
    And print ResponseDataMap.TargetResponse

    @QA
    Examples: 
      | USER_NAME                           | PASSWORD | FAIR_ID |
      | sdevineni-consultant@scholastic.com | passw0rd | 5383023 |

  Scenario Outline: Validate reqeust when COA is not accepted
    * def ResponseDataMap = call read('classpath:utils/ComparisonHelper.feature@FairsCurrentSettingsCompHelper'){userId : '<USER_NAME>', pwd : '<PASSWORD>', fairId : '<FAIR_ID>'}
    Then match ResponseDataMap.TargetStatusCd == 403
    Then match ResponseDataMap.BaseStatusCd == ResponseDataMap.TargetStatusCd
    And match ResponseDataMap.BaseResponse == ResponseDataMap.TargetResponse
    And print ResponseDataMap.BaseResponse
    And print ResponseDataMap.TargetResponse

    @QA
    Examples: 
      | USER_NAME                           | PASSWORD | FAIR_ID |
      | sdevineni-consultant@scholastic.com | passw0rd | 5387380 |

  Scenario Outline: Validate fairInfo when COA is accepted
    * def ResponseDataMap = call read('classpath:utils/ComparisonHelper.feature@FairsCurrentSettingsCompHelper'){userId : '<USER_NAME>', pwd : '<PASSWORD>', fairId : '<FAIR_ID>'}
    Then match ResponseDataMap.TargetStatusCd == 200
    Then match ResponseDataMap.BaseStatusCd == ResponseDataMap.TargetStatusCd
    And match ResponseDataMap.BaseResponse == ResponseDataMap.TargetResponse
    And print ResponseDataMap.BaseResponse
    And print ResponseDataMap.TargetResponse

    @QA
    Examples: 
      | USER_NAME                           | PASSWORD | FAIR_ID |
      | sdevineni-consultant@scholastic.com | passw0rd | 5383023 |

  Scenario Outline: Validate ewallet when COA is accepted and enabled is true
    * def ResponseDataMap = call read('classpath:utils/ComparisonHelper.feature@FairsCurrentSettingsCompHelper'){userId : '<USER_NAME>', pwd : '<PASSWORD>', fairId : '<FAIR_ID>'}
    Then match ResponseDataMap.TargetStatusCd == 200
    Then match ResponseDataMap.BaseStatusCd == ResponseDataMap.TargetStatusCd
    And match ResponseDataMap.BaseResponse == ResponseDataMap.TargetResponse
    And print ResponseDataMap.BaseResponse
    And print ResponseDataMap.TargetResponse

    @QA
    Examples: 
      | USER_NAME                           | PASSWORD | FAIR_ID |
      | sdevineni-consultant@scholastic.com | passw0rd | 5383023 |

  Scenario Outline: Validate when COA is accepted and ewallet enabled is false
    * def ResponseDataMap = call read('classpath:utils/ComparisonHelper.feature@FairsCurrentSettingsCompHelper'){userId : '<USER_NAME>', pwd : '<PASSWORD>', fairId : '<FAIR_ID>'}
    Then match ResponseDataMap.TargetStatusCd == 200
    Then match ResponseDataMap.BaseStatusCd == ResponseDataMap.TargetStatusCd
    And match ResponseDataMap.BaseResponse == ResponseDataMap.TargetResponse
    And print ResponseDataMap.BaseResponse
    And print ResponseDataMap.TargetResponse

    @QA
    Examples: 
      | USER_NAME                           | PASSWORD | FAIR_ID |
      | sdevineni-consultant@scholastic.com | passw0rd | 5383023 |

  Scenario Outline: Validate when COA is accepted and onlineFair enabled is true
    * def ResponseDataMap = call read('classpath:utils/ComparisonHelper.feature@FairsCurrentSettingsCompHelper'){userId : '<USER_NAME>', pwd : '<PASSWORD>', fairId : '<FAIR_ID>'}
    Then match ResponseDataMap.TargetStatusCd == 200
    Then match ResponseDataMap.BaseStatusCd == ResponseDataMap.TargetStatusCd
    And match ResponseDataMap.BaseResponse == ResponseDataMap.TargetResponse
    And print ResponseDataMap.BaseResponse
    And print ResponseDataMap.TargetResponse

    @QA
    Examples: 
      | USER_NAME                           | PASSWORD | FAIR_ID |
      | sdevineni-consultant@scholastic.com | passw0rd | 5383023 |

  Scenario Outline: Validate when COA is accepted and onlineFair enabled is false
    * def ResponseDataMap = call read('classpath:utils/ComparisonHelper.feature@FairsCurrentSettingsCompHelper'){userId : '<USER_NAME>', pwd : '<PASSWORD>', fairId : '<FAIR_ID>'}
    Then match ResponseDataMap.TargetStatusCd == 200
    Then match ResponseDataMap.BaseStatusCd == ResponseDataMap.TargetStatusCd
    And match ResponseDataMap.BaseResponse == ResponseDataMap.TargetResponse
    And print ResponseDataMap.BaseResponse
    And print ResponseDataMap.TargetResponse

    @QA
    Examples: 
      | USER_NAME                           | PASSWORD | FAIR_ID |
      | sdevineni-consultant@scholastic.com | passw0rd | 5383023 |

  Scenario Outline: Validate consultant information when COA is accepted
    * def ResponseDataMap = call read('classpath:utils/ComparisonHelper.feature@FairsCurrentSettingsCompHelper'){userId : '<USER_NAME>', pwd : '<PASSWORD>', fairId : '<FAIR_ID>'}
    Then match ResponseDataMap.TargetStatusCd == 200
    Then match ResponseDataMap.BaseStatusCd == ResponseDataMap.TargetStatusCd
    And match ResponseDataMap.BaseResponse == ResponseDataMap.TargetResponse
    And print ResponseDataMap.BaseResponse
    And print ResponseDataMap.TargetResponse

    @QA
    Examples: 
      | USER_NAME                           | PASSWORD | FAIR_ID |
      | sdevineni-consultant@scholastic.com | passw0rd | 5383023 |

  Scenario Outline: Validate co-chairs information when COA is accepted
    * def ResponseDataMap = call read('classpath:utils/ComparisonHelper.feature@FairsCurrentSettingsCompHelper'){userId : '<USER_NAME>', pwd : '<PASSWORD>', fairId : '<FAIR_ID>'}
    Then match ResponseDataMap.TargetStatusCd == 200
    Then match ResponseDataMap.BaseStatusCd == ResponseDataMap.TargetStatusCd
    And match ResponseDataMap.BaseResponse == ResponseDataMap.TargetResponse
    And print ResponseDataMap.BaseResponse
    And print ResponseDataMap.TargetResponse

    @QA
    Examples: 
      | USER_NAME                           | PASSWORD | FAIR_ID |
      | sdevineni-consultant@scholastic.com | passw0rd | 5383023 |
