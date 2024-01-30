Feature: Fund Controller api tests for general health

  Scenario Outline: Verify all scenarios return a happy response code for funding
    * def getDate =
  """
  function() {
    var DateTimeFormatter = Java.type('java.time.format.DateTimeFormatter');
    var dtf = DateTimeFormatter.ofPattern('ddHHmmss');
    var ldt = java.time.LocalDateTime.now();
    return ldt.format(dtf);
  }
  """
    * json apiParamsAsJson = apiParams
    * apiParamsAsJson.REQUEST_BODY.orderId = getDate()
    * print apiParamsAsJson
    Given call read('RunnerHelper.feature@' + api) apiParamsAsJson
    Then match responseStatus == EXPECTED_CODE * 1

    @QA
    Examples:
      | api                  | EXPECTED_CODE | apiParams                                                                                                                                                                                                                                                                                           |
      | FundWalletByWalletId | 201           | {WALLETID: 1214783, REQUEST_BODY:{  "orderId": 'must be randomly generated',  "amount": 2,  "fundType": "cc",  "purchaserInfo": {    "idamUserId": "98220298",    "firstName": "KarateAPITesting",    "lastName": "AutomatedTests",    "email": "azhou1@scholastic.com",    "state": "NY",    "walletOwner": false  }}} |