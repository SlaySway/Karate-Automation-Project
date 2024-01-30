@POSTCreditCardPostback @QA @ignore
Feature: Credit card postback API testcases

  Background: Set config
    * def obj = Java.type('utils.StrictValidation')
    * def objMapper = Java.type('java.util.Map')
    * string creditCardTransactionPostback = "/api/cyber-source/postback"
    * string cybersourceSecureAcceptanceUrl = "https://testsecureacceptance.cybersource.com/silent/embedded/pay"

  Scenario Outline: Create a postback record for the transaction in the request body for user: <USER_NAME>, fair: <FAIRID>, and wallet: <WALLETID>
    * def REQUEST_BODY =
    """
     {
     "amount":  32.88,
     "billToForename": "Postman",
     "billToSurname": "Testing",
     "billToAddressPostalCode": "94043"
     }
    """
    Given def creditCardSignatureResponse = call read('classpath:common/bookfairs/payportal/cybersource/RunnerHelper.feature@CreateCreditCardSignature')
    Then match creditCardSignatureResponse.responseStatus == 200
    * def REQ_BODY =
    """
    function(){
    try{
    const userData = objectMapper.readValue(creditCardSignatureResponse.response);
    const reqBody = Object.entries(userData)
        .map(([key, value]) => entry(key, value))
        .concat(ImmutableMap.of(
            "cardType", "001",
            "cardExpiryDate", "12-2024",
            "cardNumber", "4111111111111111",
            "cardCvn", "838"
        ).entries())
        .map(([key, value]) => `${LOWER_CAMEL.to(LOWER_UNDERSCORE, key)}=${UrlEscapers.urlFormParameterEscaper().escape(value)}`)
        .join('&');

    const requestBody = Object.entries(userData)
        .map(([key, value]) => `${key}=${UrlEscapers.urlFormParameterEscaper().escape(value)}`)
        .join('&');

    console.log("Signature token:", requestBody);
        } catch (error) {
    throw new Error(error);
      }
      }
   """
    * def INPUT_BODY = REQ_BODY()
    * print INPUT_BODY
    Given def externalResponse = call read('classpath:common/bookfairs/payportal/cybersource/RunnerHelper.feature@CyberSourceSecureAcceptanceTransaction')
    Then match externalResponse.responseStatus == 200

    @QA
    Examples:
      | TRANSACTION_TYPE | FAIRID  | USER_NAME              | PASSWORD |
      | sale             | 5694329 | mtodaro@scholastic.com | passw0rd |

