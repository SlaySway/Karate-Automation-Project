@UpdateFairInfo
Feature: Canada Toolkit Update fair info API Tests

  # TODO: when dev complete
  Scenario: Mock api
    * def REQUEST_BODY =
    """
    {
        "name": "Our Lady Of Grace Academy Fair",
        "homePageStartDate": "2024-02-15",
        "homePageEndDate": "2024-03-05",
        "location": "Library",
        "address": {
            "addressLine1": "116 Ave. FRANK-ROBIN",
            "city": "GATINEAU",
            "region": "QUEBEC",
            "postalCode": "J9H 4A6"
        },
        "englishWelcomeMessage": "Test welcome message.",
        "frenchWelcomeMessage": "Testez le message de bienvenue.",
        "paymentOptions":{
            "cash": true,
            "cheque": false,
            "card": true
        }
    }
    """
    Given def response = call read('RunnerHelper.feature@UpdateFairInfo'){FAIR_ID:"random", USER_NAME:"random"}
    * print response.response
    Then match response.responseStatus == 200