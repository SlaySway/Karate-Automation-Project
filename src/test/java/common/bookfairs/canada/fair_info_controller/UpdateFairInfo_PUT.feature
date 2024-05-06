@UpdateFairInfo
Feature: Canada Toolkit Update fair info API Tests

  Background: Set config
    * string getFairInfoUri = "/api/user/fairs/<fairId>/homepage/fair-info"
    * string updateFairInfoUri = "/api/user/fairs/<fairId>/homepage/fair-info"

  # TODO: when there is available time
  # grab current data from mongo
  # set request body to something different
  # hit the put api
  # grab the data from mongo
  # verify that its changed
  # set data back to original
  # hit the put api and return it back to normal
  Scenario Outline: Validate mongo is updated and 200 when valid request body and credentials provided, user:<USER_NAME>, fair:<FAIRID_OR_CURRENT>
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

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com | password1 | 5196693           |

    #TODO: when time is available
    # setting the dates to non dates will result in 400
    # setting paymentOptions booleans to string that can't be processed
    # setting address.province to anything but QUEBEC and ALBERTA <- will result in 500
    # strings can be anything, no restriction on them, except for start, end, address.province
    Scenario: Validate 400 Bad Request when invalid fields for request body used, , user:<USER_NAME>, fair:<FAIRID_OR_CURRENT>