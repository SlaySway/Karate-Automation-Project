@CreateWalletTransactions
Feature: CreateWalletTransactions POST api tests

  Background: Set config
    * def obj = Java.type('utils.StrictValidation')
    * string createWalletTransactions = "/api/wallets/<walletId>/transactions"

  @Happy
  Scenario Outline: Create a transactions for the wallet for user: <USER_NAME>, fair: <FAIRID>, and wallet: <WALLETID>
    * def REQUEST_BODY =
    """
     {
     "amount": 2.00,
     "note": "Postman test"
     }
    """
    Given def createWalletTransactionResponse = call read('RunnerHelper.feature@CreateWalletTransactions')
    Then match createWalletTransactionResponse.responseStatus == 201

    @QA
      Examples:
        | FAIRID  | USER_NAME              | PASSWORD | WALLETID |
        | 5694329 | mtodaro@scholastic.com | passw0rd | 1214555  |

  Scenario Outline: Verify walletTransactions returns a 401 status code when user is not logged in myScholastic
    Given url BOOKFAIRS_PAYPORTAL_URL + createWalletTransactions
    * replace createWalletTransactions.walletId = WALLETID
    * def REQUEST_BODY =
    """
     {
     "amount": 3.00,
     "note": "Test1"
     }
    """
    * url BOOKFAIRS_PAYPORTAL_URL + createWalletTransactions
    * cookies { SCHL : '#(schlResponse.SCHL)'}
    Then method POST
    Then match responseStatus == 401

    @QA
    Examples:
      | WALLETID |
      | 1214556  |

  Scenario Outline: Verify walletTransactions returns a 401 status code when invalid walletId is passed
    Given def sessionResponse = call read('classpath:common/bookfairs/payportal/session/RunnerHelper.feature@CreateSession')
    * replace createWalletTransactions.walletId = WALLETID
    * def REQUEST_BODY =
    """
     {
     "amount": 2.00,
     "note": "Postman test"
     }
    """
    * url BOOKFAIRS_PAYPORTAL_URL + createWalletTransactions
    * cookies { SCHL : '#(sessionResponse.SCHL)', PP2.0:'#(sessionResponse.PP2)'}
    Then method POST
    Then match responseStatus == 403

    @QA
    Examples:
      | USER_NAME              | PASSWORD | FAIRID  | WALLETID |
      | mtodaro@scholastic.com | passw0rd | 5694329 | 1214550  |

  Scenario Outline: Verify walletTransaction returns 401 status code when session cookie is not created
    Given def sessionResponse = call read('classpath:common/bookfairs/payportal/session/RunnerHelper.feature@CreateSession')
    * replace createWalletTransactions.walletId = WALLETID
    * url BOOKFAIRS_PAYPORTAL_URL + createWalletTransactions
    * cookies { SCHL : '#(sessionResponse.SCHL)', PP2.0:'eyJraWQiOiJub25wcm9kLTIwMjEzMzExMzMyIiwidHlwIjoiSldUIiwiYWxnIjoiSFMyNTYifQ.eyJpc3MiOiJNeVNjaGwiLCJhdWQiOiJTY2hvbGFzdGljIiwibmJmIjox'}
    Then method POST
    Then match responseStatus == 401
    Then match response.errorMessage == "No valid fair. Please make sure that PP2.0 cookie is specified"

    @QA
    Examples:
      | USER_NAME              | PASSWORD | FAIRID  | WALLETID |
      | mtodaro@scholastic.com | passw0rd | 5694329 | 1214555  |

  Scenario Outline: Verify walletTransaction returns 401 status code when no request body is passed
    Given def sessionResponse = call read('classpath:common/bookfairs/payportal/session/RunnerHelper.feature@CreateSession')
    * replace createWalletTransactions.walletId = WALLETID
    * url BOOKFAIRS_PAYPORTAL_URL + createWalletTransactions
    * cookies { SCHL : '#(sessionResponse.SCHL)', PP2.0:'#(sessionResponse.PP2)'}
    Then method POST
    Then match responseStatus == 400

    @QA
    Examples:
      | USER_NAME              | PASSWORD | FAIRID  | WALLETID |
      | mtodaro@scholastic.com | passw0rd | 5694329 | 1214555  |