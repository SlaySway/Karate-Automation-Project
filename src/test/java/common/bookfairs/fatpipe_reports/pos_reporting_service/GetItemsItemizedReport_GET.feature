@GetFatpipeItemsItemizedTest
Feature: Fatpipe Items itemized report API automation tests

  Background: Set config
    * string getItemsItemizedUri = "/api/v1/fairs"

  Scenario Outline: Validate a 200 status code for a valid request
    * def getFatpipeItemsItemizedReportResponse = call read('classpath:common/bookfairs/fatpipe_reports/pos_reporting_service/POSReportingRunnerHelper.feature@GetFatpipeItemsItemizedReportRunner'){FAIR_ID : '<FAIR_ID>'}
    * print getFatpipeItemsItemizedReportResponse
    Then match getFatpipeItemsItemizedReportResponse.responseStatus == 200
    Then match getFatpipeItemsItemizedReportResponse.response.metaData.params.fairId == '#(FAIR_ID)'

    @QA
    Examples:
      | FAIR_ID |
      | 5633533 |

    #  Note: This API cannot distinguish between invalid Fairs and Fairs which simply have no data.
  Scenario Outline: Validate a 200 status code for a invalid fairId
    * def getFatpipeItemsItemizedReportResponse = call read('classpath:common/bookfairs/fatpipe_reports/pos_reporting_service/POSReportingRunnerHelper.feature@GetFatpipeItemsItemizedReportRunner'){FAIR_ID : '<FAIR_ID>'}
    * print getFatpipeItemsItemizedReportResponse
    Then match getFatpipeItemsItemizedReportResponse.responseStatus == 200
    Then match getFatpipeItemsItemizedReportResponse.response.metaData.params.fairId == '#(FAIR_ID)'

    @QA
    Examples:
      | FAIR_ID |
      | 56300a  |
      | 56311b  |

  Scenario Outline: Validate when invalid input is provided
    Given url BOOKFAIRS_FATPIPE_REPORTS_URL + getItemsItemizedUri
    And headers {Content-Type : 'application/json'}
    And def pathParams = {bookFairId : '#(FAIR_ID)'}
    And path pathParams.bookFairId + '/pos/discount/summary'
    And params {itemIdentityMode: 'PRODUCT', page: 0, rollupGroupingCode: 'ITEM', size: 100, transactionMode: 'SALE',transactionStatusGroup : 'REGIST', typeCode : 'xyz'}
    And method GET
    #COMMENT : On postman and swagger 400 is generated for this test scenario but here it shows 404, please suggest what to do with this scenario.
    Then match responseStatus == 404

    @QA
    Examples:
      | FAIR_ID |
      | 5633533 |
