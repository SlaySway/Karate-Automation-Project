@ignore @report=true
Feature: Helper for running BookFairs User endpoints

  Background: Set config
    * string getSelectionAndTokenInfoUri = "/bookfairs-jarvis/api/user/schools/<schoolId>"
    * string getSalesHistoryUri = "/bookfairs-jarvis/api/user/schools/<schoolId>/sales-history"
    * string getTransactionDetailsUri = "/bookfairs-jarvis/api/user/schools/<schoolId>/scholastic-dollars/account"
    * string getBasicInfoUri = "/bookfairs-jarvis/api/user/schools/selected/basic-info"

     # Input: USER_NAME, PASSWORD, SCHOOL_ID
  # Output: response
  @GetSelectionAndTokenInfo
  Scenario: Run get selection and token info for user: <USER_NAME> and schoolId: <SCHOOL_ID>
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
    * replace getSelectionAndTokenInfoUri.schoolId = SCHOOL_ID
    And params {mode : '#(mode)'}
    * url BOOKFAIRS_JARVIS_URL + getSelectionAndTokenInfoUri
    * cookies { SCHL : '#(schlResponse.SCHL)'}
    Then method get

  # Input: USER_NAME, PASSWORD, SCHOOL_ID
  # Output: response
  @GetSelectionAndTokenInfoBase
  Scenario: Run get selection and token info for user: <USER_NAME> and schoolId: <SCHOOL_ID>
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
    * replace getSelectionAndTokenInfoUri.schoolId = SCHOOL_ID
    And params {mode : '#(mode)'}
    * url BOOKFAIRS_JARVIS_BASE + getSelectionAndTokenInfoUri
    * cookies { SCHL : '#(schlResponse.SCHL)'}
    Then method get

  # Input: USER_NAME, PASSWORD, SCHOOL_ID
  # Output: response
  @GetSalesHistory
  Scenario: Run get user sales history for user: <USER_NAME> and schoolId: <USER_SCHOOL_ID>
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
    * replace getSalesHistoryUri.schoolId = USER_SCHOOL_ID
    * url BOOKFAIRS_JARVIS_URL + getSalesHistoryUri
    * cookies { SCHL : '#(schlResponse.SCHL)'}
    Then method get

  # Input: USER_NAME, PASSWORD, SCHOOL_ID
  # Output: response
  @GetSalesHistoryBase
  Scenario: Run get user sales history for user: <USER_NAME> and schoolId: <USER_SCHOOL_ID>
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
    * replace getSalesHistoryUri.schoolId = USER_SCHOOL_ID
    * url BOOKFAIRS_JARVIS_BASE + getSalesHistoryUri
    * cookies { SCHL : '#(schlResponse.SCHL)'}
    Then method get

    # Input: USER_NAME, PASSWORD, SCHOOL_ID
  # Output: response
  @GetTransactionDetails
  Scenario: Run get user transaction details for user: <USER_NAME> and schoolId: <USER_SCHOOL_ID>
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
    * replace getTransactionDetailsUri.schoolId = USER_SCHOOL_ID
    * url BOOKFAIRS_JARVIS_URL + getTransactionDetailsUri
    * cookies { SCHL : '#(schlResponse.SCHL)'}
    Then method get

  # Input: USER_NAME, PASSWORD, SCHOOL_ID
  # Output: response
  @GetTransactionDetailsBase
  Scenario: Run get user transaction details for user: <USER_NAME> and schoolId: <USER_SCHOOL_ID>
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
    * replace getTransactionDetailsUri.schoolId = USER_SCHOOL_ID
    * url BOOKFAIRS_JARVIS_BASE + getTransactionDetailsUri
    * cookies { SCHL : '#(schlResponse.SCHL)'}
    Then method get

    # Input: USER_NAME, PASSWORD, SCHOOL_ID
  # Output: response
  @GetBasicInfo
  Scenario: Run get user transaction details for user: <USER_NAME> and schoolId: <USER_SCHOOL_ID>
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
    * url BOOKFAIRS_JARVIS_URL + getBasicInfoUri
    * cookies { SCHL : '#(schlResponse.SCHL)'}
    Then method get

  # Input: USER_NAME, PASSWORD, SCHOOL_ID
  # Output: response
  @GetBasicInfoBase
  Scenario: Run get user transaction details for user: <USER_NAME> and schoolId: <USER_SCHOOL_ID>
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
    * url BOOKFAIRS_JARVIS_BASE + getBasicInfoUri
    * cookies { SCHL : '#(schlResponse.SCHL)'}
    Then method get
