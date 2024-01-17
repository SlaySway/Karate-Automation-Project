@GETWalletTransactions
Feature: Wallets transactions GET api tests

  Background: Set config
    * def obj = Java.type('utils.StrictValidation')
    * string getWalletTransactions = "/api/wallets/<walletId>/transactions"

  @Happy
  Scenario Outline: Get the transactions for the wallet for user: <USER_NAME>, fair: <FAIRID>, and wallet: <WALLETID>
    Given def getWalletsTransactionsResponse = call read('RunnerHelper.feature@GetWalletTransactions')
    Then match getWalletsTransactionsResponse.responseStatus == 200

    @QA
    Examples:
      | USER_NAME              | PASSWORD | FAIRID  | WALLETID |
      | mtodaro@scholastic.com | passw0rd | 5694329 | 1214555  |

  @Unhappy
  Scenario Outline: Verify getWalletsTransactions returns a 401 status code when user is not logged in myScholastic
    Given url BOOKFAIRS_PAYPORTAL_URL + getWalletTransactions
    * replace getWalletTransactions.walletId = WALLETID
    * url BOOKFAIRS_PAYPORTAL_URL + getWalletTransactions
    * cookies { SCHL : '#(schlResponse.SCHL)'}
    Then method GET
    Then match responseStatus == 401

    @QA
    Examples:
      | FAIRID  | WALLETID |
      | 5694329 | 1214555  |

  Scenario Outline: Verify getWalletsTransactions returns 401 status code when session cookie is not created
    Given def sessionResponse = call read('classpath:common/bookfairs/payportal/session/RunnerHelper.feature@CreateSession')
    * replace getWalletTransactions.walletId = WALLETID
    * url BOOKFAIRS_PAYPORTAL_URL + getWalletTransactions
    * cookies { SCHL : '#(sessionResponse.SCHL)', PP2.0:'eyJraWQiOiJub25wcm9kLTIwMjEzMzExMzMyIiwidHlwIjoiSldUIiwiYWxnIjoiSFMyNTYifQ.eyJpc3MiOiJNeVNjaGwiLCJhdWQiOiJTY2hvbGFzdGljIiwibmJmIjox'}
    Then method GET
    Then match responseStatus == 401
    Then match response.errorMessage == "No valid fair. Please make sure that PP2.0 cookie is specified"

    @QA
    Examples:
      | USER_NAME              | PASSWORD | FAIRID  | WALLETID |
      | mtodaro@scholastic.com | passw0rd | 5694329 | 1214555  |
