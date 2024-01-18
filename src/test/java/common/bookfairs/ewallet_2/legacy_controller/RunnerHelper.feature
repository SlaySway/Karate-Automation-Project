@ignore @report=true
Feature: Helper for running legacy-controller endpoints

  Background: Set config
    * string getWalletByVoucherParametersUri = "/vouchers"
    * string createVoucherUri = "/vouchers"
    * string createVoucherTransactionsUri = "/vouchers/<voucherId>/transactions"
    * string getWalletsByCustomerIdUri = "/wallets"
    * string getVoucherByVoucherIdUri = "/vouchers/<voucherId>"
    * string getTransactionByTransactionIdUri = "/transactions/<transactionId>"

  # Input: type, key, fairId, grade, transactions, showTransactions, status, showNonLegacyFields
  # Output: response
  @GetWalletByVoucherParameters
  Scenario: Get voucher/wallet by voucher parameters
    * url BOOKFAIRS_EWALLET_2_URL + getWalletByVoucherParametersUri
    * def attribute = { fairid : '#(fairId)', grade :  '#(grade)'}
    * params {type:'#(type)',key:'#(key)', attribute:'#(attribute)',transactions:'#(transactions)',showTransactions:'#(showTransactions)',status:'#(status)',showNonLegacyFields:'#(showNonLegacyFields)'}
    Then method GET

  # Input: type, fairId, showNonLegacyFields
  # Output: response
  @CreateVoucher
  Scenario: Create voucher/wallet
    * url BOOKFAIRS_EWALLET_2_URL + createVoucherUri
    * def attribute = { fairid : '#(fairId)'}
    * params {type:'#(type)',key:'#(key)', attribute:'#(attribute)',showNonLegacyFields:'#(showNonLegacyFields)'}
    Then method PUT

  # Input: VOUCHERID, REQUEST_BODY
  # Output: response
  @CreateVoucherTransactions
  Scenario: Create a voucher transaction
    * replace createVoucherTransactionsUri.voucherId = VOUCHERID
    * url BOOKFAIRS_EWALLET_2_URL + createVoucherTransactionsUri
    * request REQUEST_BODY
    Then method POST

  # Input: customerProfileId
  # Output: response
  @GetWalletsByCustomerId
  Scenario: Get vouchers for a customer
    * url BOOKFAIRS_EWALLET_2_URL + getWalletsByCustomerIdUri
    * params {customerProfileId: '#(customerProfileId)'}
    Then method GET

  # Input: VOUCHERID
  # Output: response
  @GetVoucherByVoucherId
  Scenario: Get a voucher
    * replace getVoucherByVoucherIdUri.voucherId = VOUCHERID
    * url BOOKFAIRS_EWALLET_2_URL + getVoucherByVoucherIdUri
    Then method GET

  # Input: TRANSACTIONID
  # Output: response
  @GetTransactionByTransactionId
  Scenario: Get a voucher
    * replace getTransactionByTransactionIdUri.voucherId = TRANSACTIONID
    * url BOOKFAIRS_EWALLET_2_URL + getTransactionByTransactionIdUri
    Then method GET

