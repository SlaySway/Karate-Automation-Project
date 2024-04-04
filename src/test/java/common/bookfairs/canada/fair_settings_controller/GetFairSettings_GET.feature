@GetFairSettings
Feature: Canada Toolkit get fair settings API Tests

  Scenario Outline: Validate fair settings returns 200 response and response is from CMDM
    Given def response = call read('RunnerHelper.feature@GetFairSettings'){FAIR_ID:<FAIRID_OR_CURRENT>}
    * def getCMDMFairSettingsResponse = call read('classpath:common/cmdm/canada/RunnerHelper.feature@GetFairRunner'){FAIR_ID:<FAIRID_OR_CURRENT>}
    * def buildResponseFromCMDMResponse =
    """
      function(cmdm){
        let DateUtils = Java.type('utils.DateUtils');
        let expectedResponse = {};

        let expectedSalesHistory = []
        cmdm.salesHistory.forEach((saleHistory) => {
          let newHistory = {};
          newHistory.start = saleHistory.startDate;
          newHistory.end = saleHistory.endDate;
          newHistory.sales = saleHistory.sales;
          expectedSalesHistory.push(newHistory)
        })
        expectedResponse.salesHistory = expectedSalesHistory;

        expectedResponse.consultant = cmdm.consultant
        expectedResponse.scholasticDollars = cmdm.scholasticDollars

        expectedResponse.organization = {}
        expectedResponse.organization.bookfairAccountId = cmdm.organization.bookfairAccountId;

        expectedResponse.homepage = {}

        expectedResponse.user = {}

        expectedResponse.fairInfo = {}
        expectedResponse.fairInfo.id = cmdm.fairInfo.fairId
        expectedResponse.fairInfo.name = cmdm.fairInfo.name
        expectedResponse.fairInfo.start = cmdm.fairInfo.startDate
        expectedResponse.fairInfo.end = cmdm.fairInfo.endDate
        expectedResponse.fairInfo.setup = cmdm.fairInfo.setUpDate
        expectedResponse.fairInfo.coaStatus = cmdm.fairInfo.coaStatus
        expectedResponse.fairInfo.coaAcceptedDate = cmdm.fairInfo.coaAcceptedDate
        expectedResponse.fairInfo.requestDateChangePending = cmdm.fairInfo.isRequestDateChangePending
        expectedResponse.fairInfo.fliers.fifthAndBelow = cmdm.fairInfo.numberOfFliersFiveAndBelowGrades
        expectedResponse.fairInfo.fliers.sixthAndAbove = cmdm.fairInfo.numberOfFliersSixAndAboveGrades
        expectedResponse.fairInfo.planningKitShipped = cmdm.fairInfo.isPlanningKitShipped
        expectedResponse.fairInfo.shippingDate = cmdm.fairInfo.shippingDate

        return expectedResponse;
      }
      """
    * print response.response
    * print getCMDMFairSettingsResponse.response
    * print buildResponseFromCMDMResponse(getCMDMFairSettingsResponse.response)

    # validate fair info from cmdm
      # where is fliers from
      # where is requestDateChangePending data from
      # where is planningKitShipped from
    # validate enableSwitch depending on how many fairs user has
    # validate organization bookfairAccountId
    # validate homepage url
    # validate salesHistory
    # validate consultant
    # validate sdBalance

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com | password1 | 5196693           |