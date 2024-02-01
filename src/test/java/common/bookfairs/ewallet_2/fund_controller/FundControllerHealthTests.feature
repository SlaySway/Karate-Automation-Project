Feature: Fund Controller api tests for general health


  Scenario Outline: Verify fund scenarios return a happy response code for funding
    * def REQUEST_BODY =
    """
    {
      "customerProfileId": 98483103,
      "fairId": 5694296,
      "studentFirstName": "Karate",
      "studentLastName": "Automated",
      "teacherFirstName": "Testing",
      "teacherLastName": "Automated",
      "parentFirstName": "Automated",
      "parentLastName": "Testing",
      "grade": "pre_k",
      "recipientType": "TEACHER"
    }
    """
    Given def createWalletResponse = call read('classpath:common/bookfairs/ewallet_2/wallet_controller/RunnerHelper.feature@CreateWallet')
    * def walletId = createWalletResponse.response.id
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
    * set apiParamsAsJson.WALLETID = createWalletResponse.response.id
    Given call read('RunnerHelper.feature@' + api) apiParamsAsJson
    Then match responseStatus == EXPECTED_CODE * 1

    @CoveredInWalletFunctionalFlowTestAsThisTestIsntDynamicEnough
    Examples:
      | api                  | EXPECTED_CODE | apiParams                                                                                                                                                                                                                                                                                                               |
      | FundWalletByWalletId | 201           | {WALLETID: 1214783, REQUEST_BODY:{  "orderId": 'must be randomly generated',  "amount": 2,  "fundType": "cc",  "purchaserInfo": {    "idamUserId": "98220298",    "firstName": "KarateAPITesting",    "lastName": "AutomatedTests",    "email": "azhou1@scholastic.com",    "state": "NY",    "walletOwner": false  }}} |