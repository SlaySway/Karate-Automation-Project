@ignore @report=true
Feature: Helper for running cybersource-controller endpoints

  Background: Set config
    * string createCreditCardSignatureUri = "/api/cyber-source/signatures/<payportalTransactionType>"
    * string recordCreditCardTransactionPostbackUri = "/api/cyber-source/postback"
    * string recordCreditCardTransactionNotificationUri = "/api/cyber-source/notifications"
    * string cybersourceSecureAcceptanceUrl = "https://testsecureacceptance.cybersource.com/silent/embedded/pay"

  # Input: USER_NAME, PASSWORD, FAIRID, TRANSACTION_TYPE, REQUEST_BODY
  # Output: response
  @CreateCreditCardSignature
  Scenario: Create the credit card transaction signature needed to hit cybersource: <USER_NAME>, fair: <FAIRID>, and type: <TRANSACTION_TYPE>
    Given def sessionResponse = call read('classpath:common/bookfairs/payportal/session/RunnerHelper.feature@CreateSession')
    * replace createCreditCardSignatureUri.payportalTransactionType = TRANSACTION_TYPE
    * url BOOKFAIRS_PAYPORTAL_URL + createCreditCardSignatureUri
    * cookies { SCHL : '#(sessionResponse.SCHL)', PP2.0 : '#(sessionResponse.PP2)'}
    * request REQUEST_BODY
    Then method POST

  # Input: USER_NAME, PASSWORD, FAIRID, REQUEST_BODY
  # Output: response
  @RecordCreditCardTransactionPostback
  Scenario: Create a postback record for the transaction in the request body for user: <USER_NAME>, fair: <FAIRID>, and wallet: <WALLETID>
    Given def sessionResponse = call read('classpath:common/bookfairs/payportal/session/RunnerHelper.feature@CreateSession')
    * url BOOKFAIRS_PAYPORTAL_URL + recordCreditCardTransactionPostbackUri
    * cookies { SCHL : '#(sessionResponse.SCHL)', PP2.0 : '#(sessionResponse.PP2)'}
    * request REQUEST_BODY
    Then method POST

  # Input: USER_NAME, PASSWORD, FAIRID, WALLETID, REQUEST_BODY
  # Output: response
  @RecordCreditCardTransactionNotification
  Scenario: Create a transactions for the wallet for user: <USER_NAME>, fair: <FAIRID>, and wallet: <WALLETID>
    Given def sessionResponse = call read('classpath:common/bookfairs/payportal/session/RunnerHelper.feature@CreateSession')
    * url BOOKFAIRS_PAYPORTAL_URL + recordCreditCardTransactionNotificationUri
    * cookies { SCHL : '#(sessionResponse.SCHL)', PP2.0 : '#(sessionResponse.PP2)'}
    * request REQUEST_BODY
    Then method POST

  # Input: REQUEST_BODY
  # Output: response
  @GetWalletsForFair @QA
  Scenario: Create the transaction by sending cybersource the modified signature body
    * url cybersourceSecureAcceptanceUrl
    * request REQUEST_BODY
    Then method POST

