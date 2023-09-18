#Author: Ravindra Pallerla

@fairsCurrentettingsTest
Feature: FairsCurrentSettings API automation tests

  Background: Set config
    * string userCurrentFairsUrl = "/bookfairs-jarvis/api/user/fairs/current/settings"
    * def obj = Java.type('utils.StrictValidation')

  Scenario Outline: Validate when sessoion cookies are not passed
    Given url BOOKFAIRS_JARVIS_TARGET + userCurrentFairsUrl
    When method get
    Then match responseStatus == 401

    Examples: 
      | USER_NAME                    | PASSWORD |
      | sd-consultant@scholastic.com | passw0rd |

  Scenario Outline: Validate when sessoion cookies are invalid
    Given url BOOKFAIRS_JARVIS_TARGET + userCurrentFairsUrl
    And cookies {SCHL : 'eyJraWQiOiJub25wcm9kLTIwMjEzMzExMzMyIiwidHlwIjoiSldUIiwiYWxnIjoiSFMyNTYifQ.e', SBF_JARVIS : 'eyJraWQiOiJub25wcm9kLTIwMjEzMzExMzMyIiwidHlwIjoiSldUIiwiYWxnIjoiSFMyNTYifQ.e'}
    When method get
    Then match responseStatus == 401

    Examples: 
      | USER_NAME                    | PASSWORD |
      | sd-consultant@scholastic.com | passw0rd |

  Scenario Outline: Validate 200 response code for a valid request
    * def ResponseDataMap = call read('classpath:utils/RunnerHelper.feature@FairsCurrentSettingsTarget'){USER_ID : '<USER_NAME>', PWD : '<PASSWORD>', FAIRID : '<FAIR_ID>'}
    Then match ResponseDataMap.StatusCode == 200

    Examples: 
      | USER_NAME                           | PASSWORD | FAIR_ID |
      | sdevineni-consultant@scholastic.com | passw0rd | 5383023 |

  Scenario Outline: Validate bookfairAccountId
    * def ResponseDataMap = call read('classpath:utils/RunnerHelper.feature@FairsCurrentSettingsTarget'){USER_ID : '<USER_NAME>', PWD : '<PASSWORD>', FAIRID : '<FAIR_ID>'}
    * def CMDMResponseDataMap = call read('classpath:utils/CMDM_Services_RunnerHelper.feature@FairsServiceRunner'){FAIRID : '<FAIR_ID>'}
    Then match ResponseDataMap.BFAcctId == CMDMResponseDataMap.BFAccountId

    Examples: 
      | USER_NAME                           | PASSWORD | FAIR_ID |
      | sdevineni-consultant@scholastic.com | passw0rd | 5383023 |

  Scenario Outline: Validate fairType 'case'
    * def ResponseDataMap = call read('classpath:utils/RunnerHelper.feature@FairsCurrentSettingsTarget'){USER_ID : '<USER_NAME>', PWD : '<PASSWORD>', FAIRID : '<FAIR_ID>'}
    Then match ResponseDataMap.FairType == 'case'

    Examples: 
      | USER_NAME                           | PASSWORD | FAIR_ID |
      | sdevineni-consultant@scholastic.com | passw0rd | 5383023 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5790926 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5644036 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5644040 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5644048 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5495158 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5591617 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5644034 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5725452 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5731880 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5725433 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5576627 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5209377 |

  Scenario Outline: Validate fairType 'tabletop'
    * def ResponseDataMap = call read('classpath:utils/RunnerHelper.feature@FairsCurrentSettingsTarget'){USER_ID : '<USER_NAME>', PWD : '<PASSWORD>', FAIRID : '<FAIR_ID>'}
    Then match ResponseDataMap.FairType == 'tabletop'

    Examples: 
      | USER_NAME                           | PASSWORD | FAIR_ID |
      | sdevineni-consultant@scholastic.com | passw0rd | 5782070 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5782069 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5782071 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5644037 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5644038 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5638185 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5557393 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5414061 |

  Scenario Outline: Validate fairType 'bogo case'
    * def ResponseDataMap = call read('classpath:utils/RunnerHelper.feature@FairsCurrentSettingsTarget'){USER_ID : '<USER_NAME>', PWD : '<PASSWORD>', FAIRID : '<FAIR_ID>'}
    Then match ResponseDataMap.FairType == 'bogo case'

    Examples: 
      | USER_NAME                           | PASSWORD | FAIR_ID |
      | sdevineni-consultant@scholastic.com | passw0rd | 5638187 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5762088 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5762089 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5762087 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5603785 |

  Scenario Outline: Validate fairType 'bogo tabletop'
    * def ResponseDataMap = call read('classpath:utils/RunnerHelper.feature@FairsCurrentSettingsTarget'){USER_ID : '<USER_NAME>', PWD : '<PASSWORD>', FAIRID : '<FAIR_ID>'}
    Then match ResponseDataMap.FairType == 'bogo tabletop'

    Examples: 
      | USER_NAME                           | PASSWORD | FAIR_ID |
      | sdevineni-consultant@scholastic.com | passw0rd | 5638186 |

  Scenario Outline: Validate fairType 'Virtual'
    * def ResponseDataMap = call read('classpath:utils/RunnerHelper.feature@FairsCurrentSettingsTarget'){USER_ID : '<USER_NAME>', PWD : '<PASSWORD>', FAIRID : '<FAIR_ID>'}
    Then match ResponseDataMap.FairType == 'Virtual'

    Examples: 
      | USER_NAME                           | PASSWORD | FAIR_ID |
      | sdevineni-consultant@scholastic.com | passw0rd | 5731020 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5638188 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5725454 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5731008 |

  @ignore
  Scenario Outline: Validate fairType 'discounted 25%'
    * def ResponseDataMap = call read('classpath:utils/RunnerHelper.feature@FairsCurrentSettingsTarget'){USER_ID : '<USER_NAME>', PWD : '<PASSWORD>', FAIRID : '<FAIR_ID>'}
    Then match ResponseDataMap.FairType == 'discounted 25%'

    Examples: 
      | USER_NAME                           | PASSWORD | FAIR_ID |
      | sdevineni-consultant@scholastic.com | passw0rd |         |
      | sdevineni-consultant@scholastic.com | passw0rd |         |
      | sdevineni-consultant@scholastic.com | passw0rd |         |
      | sdevineni-consultant@scholastic.com | passw0rd |         |
