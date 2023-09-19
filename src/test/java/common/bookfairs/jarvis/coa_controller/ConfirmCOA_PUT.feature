#Author: Ravindra Pallerla
@confirmCOATest
Feature: ConfirmCOA API automation tests

  Background: Set config
    * string confirmCOAUrl = "/bookfairs-jarvis/api/user/fairs/current/coa/confirmation"

  Scenario Outline: Validate when sessoion cookies are not passed
    Given url BOOKFAIRS_JARVIS_URL + confirmCOAUrl
    When method get
    Then match responseStatus == 401

    Examples: 
      | USER_NAME                    | PASSWORD |
      | sd-consultant@scholastic.com | passw0rd |

  Scenario Outline: Validate when sessoion cookies are invalid
    Given url BOOKFAIRS_JARVIS_URL + confirmCOAUrl
    And cookies {SCHL : 'eyJraWQiOiJub25wcm9kLTIwMjEzMzExMzMyIiwidHlwIjoiSldUIiwiYWxnIjoiSFMyNTYifQ.e', SBF_JARVIS : 'eyJraWQiOiJub25wcm9kLTIwMjEzMzExMzMyIiwidHlwIjoiSldUIiwiYWxnIjoiSFMyNTYifQ.e'}
    When method get
    Then match responseStatus == 401

    Examples: 
      | USER_NAME                    | PASSWORD |
      | sd-consultant@scholastic.com | passw0rd |

  Scenario Outline: Validate 200 response code for a valid request
    * def ResponseDataMap = call read('classpath:common/bookfairs/jarvis/coa_controller/COARunnerHelper.feature@confirmCoaRunner'){USER_ID : '<USER_NAME>', PWD : '<PASSWORD>', FAIRID : '<FAIR_ID>'}
    Then match ResponseDataMap.StatusCode == 200
    And print ResponseDataMap.ResponseString

    Examples: 
      | USER_NAME              | PASSWORD | FAIR_ID |
      #| mtodaro@scholastic.com | passw0rd | 5782057 |
      #| mtodaro@scholastic.com | passw0rd | 5782054 |
      | mtodaro@scholastic.com | passw0rd | 5782058 |
      | mtodaro@scholastic.com | passw0rd | 5782061 |
      | mtodaro@scholastic.com | passw0rd | 5782060 |
      | mtodaro@scholastic.com | passw0rd | 5782056 |
      | mtodaro@scholastic.com | passw0rd | 5782055 |
      | mtodaro@scholastic.com | passw0rd | 5782053 |
