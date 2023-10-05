@GetFatpipeDiscountSummaryTest
Feature: Fatpipe Discount summary report API automation tests

  Background: Set config
    * string getDiscountSummaryUri = "/api/v1/fairs"

  Scenario Outline: Validate a 200 status code for a valid request
    * def getFatpipeDiscountSummaryReportResponse = call read('classpath:common/bookfairs/fatpipe_reports/pos_reporting_service/POSReportingRunnerHelper.feature@GetFatpipeDiscountSummaryReportRunner'){FAIR_ID : '<FAIR_ID>'}
    * print getFatpipeDiscountSummaryReportResponse
    Then match getFatpipeDiscountSummaryReportResponse.responseStatus == 200
    Then match getFatpipeDiscountSummaryReportResponse.response.metaData.params.fairId == '#(FAIR_ID)'

    @QA
    Examples:
      | FAIR_ID |
      | 5633533 |

#  Note: This API cannot distinguish between invalid Fairs and Fairs which simply have no data.
  Scenario Outline: Validate a 200 status code for a invalid fairId
    * def getFatpipeDiscountSummaryReportResponse = call read('classpath:common/bookfairs/fatpipe_reports/pos_reporting_service/POSReportingRunnerHelper.feature@GetFatpipeDiscountSummaryReportRunner'){FAIR_ID : '<FAIR_ID>'}
    * print getFatpipeDiscountSummaryReportResponse
    Then match getFatpipeDiscountSummaryReportResponse.responseStatus == 200
    Then match getFatpipeDiscountSummaryReportResponse.response.metaData.params.fairId == '#(FAIR_ID)'

    @QA
    Examples:
      | FAIR_ID |
      | 5630    |
      | 563b    |

  Scenario Outline: Validate when invalid input is provided
    Given url BOOKFAIRS_FATPIPE_REPORTS_URL + getDiscountSummaryUri
    And headers {Content-Type : 'application/json'}
    And def pathParams = {bookFairId : '#(FAIR_ID)'}
    And path pathParams.bookFairId + '/pos/discount/summary'
    And params {perRegister : 'false', transactionStatusGroup : 'REGIS', typeCode : 'xyz'}
    And method GET
    #COMMENT : On postman and swagger 400 is generated for this test scenario but here it shows 404, please suggest what to do with this scenario.
    Then match responseStatus == 404

    @QA
    Examples:
      | FAIR_ID |
      | 5633533 |
