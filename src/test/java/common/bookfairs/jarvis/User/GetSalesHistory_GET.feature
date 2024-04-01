@GetSalesHistoryTest @public&userTests @PerformanceEnhancement
Feature: GetSalesHistory API automation tests

  Background: Set config
    * string getSalesHistoryUri = "/bookfairs-jarvis/api/user/schools/<schoolId>/sales-history"
    * def obj = Java.type('utils.StrictValidation')
    * string invalidSalesHistoryUri = "/bookfairs-jarvis/api/user/schools/<schoolId>/sale-history"
    * string getSelectionAndTokenInfoUri = "/bookfairs-jarvis/api/user/schools/<schoolId>"

  @Happy
  Scenario Outline: Validate request when valid schoolId is passed for user:<USER_NAME> and schoolId:<SCHOOL_ID>
    Given def getSalesHistoryResponse = call read('RunnerHelper.feature@GetSalesHistory')
    Then match getSalesHistoryResponse.responseStatus == 200

    @QA
    Examples:
      | USER_NAME              | PASSWORD | USER_SCHOOL_ID |
      | mtodaro@scholastic.com | passw0rd | 337017         |

    @Happy
    Scenario Outline: Validate request when "selected" keyword is passed with SelectAndToken API mode as SELECT for user:<USER_NAME> and schoolId:<SCHOOL_ID>
      Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
      * replace getSelectionAndTokenInfoUri.schoolId = SCHOOL_ID
      And params {mode : '#(mode)'}
      * url BOOKFAIRS_JARVIS_URL + getSelectionAndTokenInfoUri
      * cookies { SCHL : '#(schlResponse.SCHL)'}
      Then method get
      * replace getSalesHistoryUri.schoolId = USER_SCHOOL_ID
      * url BOOKFAIRS_JARVIS_URL + getSalesHistoryUri
      * cookies { SCHL : '#(schlResponse.SCHL)'}
      Then method get
      Then match responseStatus == 200

      @QA
      Examples:
        | USER_NAME              | PASSWORD  | SCHOOL_ID | mode   | USER_SCHOOL_ID |
        | mtodaro@scholastic.com | passw0rd  | 337017    | SELECT | selected       |
        | mtodaro@scholastic.com | passw0rd  | 337017    | SELECT | 337017         |
        | azhou1@scholastic.com  | password1 | 1033128   | SELECT | selected       |

  @Unhappy
  Scenario Outline: Validate request when "selected" keyword is passed with SelectAndToken API mode as DO_NOT_SELECT for user:<USER_NAME> and schoolId:<SCHOOL_ID>
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
    * replace getSelectionAndTokenInfoUri.schoolId = SCHOOL_ID
    And params {mode : '#(mode)'}
    * url BOOKFAIRS_JARVIS_URL + getSelectionAndTokenInfoUri
    * cookies { SCHL : '#(schlResponse.SCHL)'}
    Then method get
    * replace getSalesHistoryUri.schoolId = USER_SCHOOL_ID
    * url BOOKFAIRS_JARVIS_URL + getSalesHistoryUri
    * cookies { SCHL : '#(schlResponse.SCHL)'}
    Then method get
    Then match responseStatus == 204
    And match responseHeaders['Sbf-Jarvis-Reason'][0] == "SELECTION_REQUIRED"

    @QA
    Examples:
      | USER_NAME              | PASSWORD  | SCHOOL_ID | mode          | USER_SCHOOL_ID |
      | mtodaro@scholastic.com | passw0rd  | 337017    | DO_NOT_SELECT | selected       |
      | azhou1@scholastic.com  | password1 | 1033128   | DO_NOT_SELECT | selected       |

  @Unhappy
  Scenario Outline: Validate request when "selected" keyword is passed without calling the getSelectAndInfoUri for user:<USER_NAME> and schoolId:<SCHOOL_ID>
    Given def getSalesHistoryResponse = call read('RunnerHelper.feature@GetSalesHistory')
    Then match getSalesHistoryResponse.responseStatus == 204
    And match getSalesHistoryResponse.responseHeaders['Sbf-Jarvis-Reason'][0] == "SELECTION_REQUIRED"

    @QA
    Examples:
      | USER_NAME              | PASSWORD  | USER_SCHOOL_ID |
      | mtodaro@scholastic.com | passw0rd  | selected       |
      | azhou1@scholastic.com  | password1 | selected       |

  @Unhappy
  Scenario Outline: Validate when other than "selection" keyword/invalid schoolId is passed for user:<USER_NAME> and schoolId:<SCHOOL_ID>
    Given def getSalesHistoryResponse = call read('RunnerHelper.feature@GetSalesHistory')
    Then match getSalesHistoryResponse.responseStatus == 500

    @QA
    Examples:
      | USER_NAME              | PASSWORD | USER_SCHOOL_ID |
      | mtodaro@scholastic.com | passw0rd | abcd           |
      | mtodaro@scholastic.com | passw0rd | 12345          |


  @Unhappy
  Scenario Outline: Validate when unsupported http method is called
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
    * replace getSalesHistoryUri.schoolId = USER_SCHOOL_ID
    * url BOOKFAIRS_JARVIS_URL + getSalesHistoryUri
    * cookies { SCHL : '#(schlResponse.SCHL)'}
    Given method patch
    Then match responseStatus == 405
    Then match response.error == "Method Not Allowed"

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | USER_SCHOOL_ID |
      | azhou1@scholastic.com | password1 | 1033128        |

  @Unhappy
  Scenario Outline: Validate for internal server error
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
    * replace invalidSalesHistoryUri.schoolId = USER_SCHOOL_ID
    * url BOOKFAIRS_JARVIS_URL + invalidSalesHistoryUri
    * cookies { SCHL : '#(schlResponse.SCHL)'}
    Given method get
    Then match responseStatus == 500

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | USER_SCHOOL_ID |
      | azhou1@scholastic.com | password1 | 1033128        |

  @Regression @ignore
  Scenario Outline: Validate regression using dynamic comparison || schoolId=<SCHOOL_ID>
    * def BaseResponseMap = call read('RunnerHelper.feature@GetSalesHistoryBase')
    * def TargetResponseMap = call read('RunnerHelper.feature@GetSalesHistory')
    * string base = BaseResponseMap.response
    * string target = TargetResponseMap.response
    * def compResult = obj.strictCompare(base, target)
    Then print "Response from production code base", BaseResponseMap.response
    Then print "Response from current qa code base", TargetResponseMap.response
    Then print 'Differences any...', compResult

    Examples:
      | USER_NAME              | PASSWORD | USER_SCHOOL_ID |
      | mtodaro@scholastic.com | passw0rd | 337017         |