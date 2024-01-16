@CreateWalletRefund
Feature: CreateWalletRefund POST api tests

  Background: Set config
    * def obj = Java.type('utils.StrictValidation')
    * string createWalletRefund = "/api/wallets/<walletId>/transactions/<transactionId>/refunds"

  @Happy
  Scenario Outline: Create a wallet refund on the transaction for user: <USER_NAME>, fair: <FAIRID>, wallet: <WALLETID> transaction: <TRANSACTIONID>
    * def REQUEST_BODY =
      """
        {
         "amount": 1.00,
         "note": "Postman test"
        }
      """
    Given def createWalletRefundResponse = call read('RunnerHelper.feature@CreateWalletRefund')
    Then match createWalletRefundResponse.responseStatus == 201

    @QA
    Examples:
      | FAIRID  | USER_NAME              | PASSWORD | WALLETID | TRANSACTIONID |
      | 5694329 | mtodaro@scholastic.com | passw0rd | 1214555  | 386761        |

  @Unhappy
  Scenario Outline: Verify walletRefund returns a 401 status code when user is not logged in myScholastic
    Given url BOOKFAIRS_PAYPORTAL_URL + createWalletRefund
    * replace createWalletRefund.walletId = WALLETID
    * replace createWalletRefund.transactionId = TRANSACTIONID
    * url BOOKFAIRS_PAYPORTAL_URL + createWalletRefund
    * cookies { SCHL : '#(schlResponse.SCHL)'}
    * def REQUEST_BODY =
      """
        {
         "amount": 1.00,
         "note": "testing"
        }
      """
    Then method POST
    Then match responseStatus == 401
    Then match response.errorMessage == "Not a valid session. Please make sure that a valid SCHL cookie is specified."

    @QA
    Examples:
      | WALLETID | TRANSACTIONID |
      | 1214555  | 386771        |
      | 1214556  | 386772        |

  Scenario Outline: Verify walletRefund returns 401 status code when no request body is passed
    Given def sessionResponse = call read('classpath:common/bookfairs/payportal/session/RunnerHelper.feature@CreateSession')
    * replace createWalletRefund.walletId = WALLETID
    * replace createWalletRefund.transactionId = TRANSACTIONID
    * url BOOKFAIRS_PAYPORTAL_URL + createWalletRefund
    * cookies { SCHL : '#(sessionResponse.SCHL)', PP2.0:'#(sessionResponse.PP2)'}
    Then method POST
    Then match responseStatus == 400

    @QA
    Examples:
      | FAIRID  | USER_NAME              | PASSWORD | WALLETID | TRANSACTIONID |
      | 5694329 | mtodaro@scholastic.com | passw0rd | 1214555  | 386771        |

  Scenario Outline: Verify walletRefund returns 401 status code when session cookie is not created
    Given def sessionResponse = call read('classpath:common/bookfairs/payportal/session/RunnerHelper.feature@CreateSession')
    * replace createWalletRefund.walletId = WALLETID
    * replace createWalletRefund.transactionId = TRANSACTIONID
    * url BOOKFAIRS_PAYPORTAL_URL + createWalletRefund
    * cookies { SCHL : '#(sessionResponse.SCHL)', PP2.0:'eyJraWQiOiJub25wcm9kLTIwMjEzMzExMzMyIiwidHlwIjoiSldUIiwiYWxnIjoiSFMyNTYifQ.eyJpc3MiOiJNeVNjaGwiLCJhdWQiOiJTY2hvbGFzdGljIiwibmJmIjox'}
    Then method POST
    Then match responseStatus == 401
    Then match response.errorMessage == "No valid fair. Please make sure that PP2.0 cookie is specified"

    @QA
    Examples:
      | FAIRID  | USER_NAME              | PASSWORD | WALLETID | TRANSACTIONID |
      | 5694329 | mtodaro@scholastic.com | passw0rd | 1214556  | 386772        |
