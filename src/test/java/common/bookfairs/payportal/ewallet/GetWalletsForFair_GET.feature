@GETWalletsByFair
Feature: Wallets by fair GET api tests

  Background: Set config
    * def obj = Java.type('utils.StrictValidation')
    * string getWalletByFair = "/api/user/fairs"

@Happy
Scenario Outline: Get the wallets related to the fair for user: <USER_NAME> and fair: <FAIRID>
  Given def getWalletsForFairsResponse = call read('RunnerHelper.feature@GetWalletsForFair')
  Then match getWalletsForFairsResponse.responseStatus == 200

  @QA
  Examples:
    | USER_NAME              | PASSWORD | FAIRID  |
    | mtodaro@scholastic.com | passw0rd | 5694314 |

  @Unhappy
  Scenario Outline: Verify getWalletsForFairs returns a 401 status code when user is not logged in myScholastic
    Given url BOOKFAIRS_PAYPORTAL_URL + getWalletByFair
    * url BOOKFAIRS_PAYPORTAL_URL + getWalletByFair
    * cookies { SCHL : '#(schlResponse.SCHL)'}
    Then method GET
    Then match responseStatus == 401

    @QA
    Examples:
      | FAIRID  |
      | 5694297 |

  Scenario Outline: Verify getWalletsForFair returns 401 status code when session cookie is not created
    Given def sessionResponse = call read('classpath:common/bookfairs/payportal/session/RunnerHelper.feature@CreateSession')
    * url BOOKFAIRS_PAYPORTAL_URL + getWalletByFair
    * cookies { SCHL : '#(sessionResponse.SCHL)', PP2.0:'eyJraWQiOiJub25wcm9kLTIwMjEzMzExMzMyIiwidHlwIjoiSldUIiwiYWxnIjoiSFMyNTYifQ.eyJpc3MiOiJNeVNjaGwiLCJhdWQiOiJTY2hvbGFzdGljIiwibmJmIjox'}
    Then method GET
    Then match responseStatus == 401
    Then match response.errorMessage == "No valid fair. Please make sure that PP2.0 cookie is specified"

    @QA
    Examples:
      | USER_NAME              | PASSWORD | FAIRID  |
      | mtodaro@scholastic.com | passw0rd | 5694315 |
