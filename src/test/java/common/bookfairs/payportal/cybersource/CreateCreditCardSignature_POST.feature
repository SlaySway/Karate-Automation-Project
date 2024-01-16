@POSTCreateCreditCardSignature
Feature: Create credit card signature API test cases

  Background: Set config
    * def obj = Java.type('utils.StrictValidation')
    * string createCreditCardSignature = "/api/cyber-source/signatures/<payportalTransactionType>"

  @Happy
  Scenario Outline:Create the credit card transaction signature needed to hit cybersource: <USER_NAME>, fair: <FAIRID>, and type: <TRANSACTION_TYPE>
    * def REQUEST_BODY =
    """
     {
     "amount":  32.88,
     "billToForename": "Postman",
     "billToSurname": "Testing",
     "billToAddressPostalCode": "94043"
     }
    """
    Given def createCreditCardSignatureResponse = call read('RunnerHelper.feature@CreateCreditCardSignature')
    Then match createCreditCardSignatureResponse.responseStatus == 200

    @QA
    Examples:
      | TRANSACTION_TYPE | FAIRID  | USER_NAME              | PASSWORD |
      | sale             | 5694329 | mtodaro@scholastic.com | passw0rd |

  @Unhappy
  Scenario Outline: Verify creditCardSignature returns a 401 status code when user is not logged in myScholastic
    Given url BOOKFAIRS_PAYPORTAL_URL + createCreditCardSignature
    * replace createCreditCardSignature.payportalTransactionType = TRANSACTION_TYPE
    * url BOOKFAIRS_PAYPORTAL_URL + createCreditCardSignature
    * cookies { SCHL : '#(schlResponse.SCHL)'}
    * def REQUEST_BODY =
    """
     {
     "amount":  32.88,
     "billToForename": "Postman",
     "billToSurname": "Testing",
     "billToAddressPostalCode": "94043"
     }
    """
    Then method POST
    Then match responseStatus == 401
    Then match response.errorMessage == "Not a valid session. Please make sure that a valid SCHL cookie is specified."

    @QA
    Examples:
      | TRANSACTION_TYPE  |
      | sale              |

  Scenario Outline: Verify creditCardSignature returns 401 status code when no request body is passed
    Given def sessionResponse = call read('classpath:common/bookfairs/payportal/session/RunnerHelper.feature@CreateSession')
    * replace createCreditCardSignature.payportalTransactionType = TRANSACTION_TYPE
    * url BOOKFAIRS_PAYPORTAL_URL + createCreditCardSignature
    * cookies { SCHL : '#(sessionResponse.SCHL)', PP2.0:'#(sessionResponse.PP2)'}
    Then method POST
    Then match responseStatus == 400

    @QA
    Examples:
      | TRANSACTION_TYPE | FAIRID  | USER_NAME              | PASSWORD |
      | sale             | 5694329 | mtodaro@scholastic.com | passw0rd |

  Scenario Outline: Verify creditCardSignature returns 401 status code when session cookie is not created
    Given def sessionResponse = call read('classpath:common/bookfairs/payportal/session/RunnerHelper.feature@CreateSession')
    * def REQUEST_BODY =
    """
     {
     "amount":  32.88,
     "billToForename": "Postman",
     "billToSurname": "Testing",
     "billToAddressPostalCode": "94043"
     }
    """
    * replace createCreditCardSignature.payportalTransactionType = TRANSACTION_TYPE
    * url BOOKFAIRS_PAYPORTAL_URL + createCreditCardSignature
    * cookies { SCHL : '#(sessionResponse.SCHL)', PP2.0:'eyJraWQiOiJub25wcm9kLTIwMjEzMzExMzMyIiwidHlwIjoiSldUIiwiYWxnIjoiSFMyNTYifQ.eyJpc3MiOiJNeVNjaGwiLCJhdWQiOiJTY2hvbGFzdGljIiwibmJmIjox'}
    Then method POST
    Then match responseStatus == 401
    Then match response.errorMessage == "No valid fair. Please make sure that PP2.0 cookie is specified"

    @QA
    Examples:
      | TRANSACTION_TYPE | FAIRID  | USER_NAME              | PASSWORD |
      | sale             | 5694329 | mtodaro@scholastic.com | passw0rd |

