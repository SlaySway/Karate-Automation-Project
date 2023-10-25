@confirmCOATest
Feature: ConfirmCOA API automation tests

  Background: Set config
    * string confirmCOAUri = "/api/user/fairs/current/coa/confirmation"

  Scenario: Validate when session cookies are not passed
    Given url BOOKFAIRS_JARVIS_URL + confirmCOAUri
    When method GET
    Then match responseStatus == 401

  Scenario: Validate when session cookies are invalid
    Given url BOOKFAIRS_JARVIS_URL + confirmCOAUri
    And cookies {SCHL : 'eyJraWQiOiJub25wcm9kLTIwMjEzMzExMzMyIiwidHlwIjoiSldUIiwiYWxnIjoiSFMyNTYifQ.e', SBF_JARVIS : 'eyJraWQiOiJub25wcm9kLTIwMjEzMzExMzMyIiwidHlwIjoiSldUIiwiYWxnIjoiSFMyNTYifQ.e'}
    When method get
    Then match responseStatus == 401

  Scenario Outline: Validate 200 response code for a valid request
    * def ResponseDataMap = call read('classpath:common/bookfairs/jarvis/coa_controller/COARunnerHelper.feature@confirmCoaRunner'){USER_ID : '<USER_NAME>', PASSWORD : '<PASSWORD>', FAIR_ID : '<FAIR_ID>'}
    Then match ResponseDataMap.responseStatus == 200

    Examples: 
      | USER_NAME              | PASSWORD | FAIR_ID |
      | mtodaro@scholastic.com | passw0rd | 5782058 |
      | mtodaro@scholastic.com | passw0rd | 5782061 |
      | mtodaro@scholastic.com | passw0rd | 5782060 |
      | mtodaro@scholastic.com | passw0rd | 5782056 |
      | mtodaro@scholastic.com | passw0rd | 5782055 |
      | mtodaro@scholastic.com | passw0rd | 5782053 |
