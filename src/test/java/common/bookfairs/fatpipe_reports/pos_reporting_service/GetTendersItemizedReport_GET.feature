@GetFatpipeTendersItemizedTest
Feature: Fatpipe Tenders Itemized report API automation tests

  Background: Set config
    * string getTendersItemizedUri = "/api/v1/fairs"

  Scenario Outline: Validate a 200 status code for a valid request
    * def getFatpipeTendersItemizedReportResponse = call read('classpath:common/bookfairs/fatpipe_reports/pos_reporting_service/POSReportingRunnerHelper.feature@GetFatpipeTendersItemizedReportRunner'){FAIR_ID : '<FAIR_ID>'}
    * print getFatpipeTendersItemizedReportResponse
    Then match getFatpipeTendersItemizedReportResponse.responseStatus == 200
    Then match getFatpipeTendersItemizedReportResponse.response.metaData.params.fairId == '#(FAIR_ID)'

    @QA
    Examples:
      | FAIR_ID |
      | 5633533 |

#  Note: This API cannot distinguish between invalid Fairs and Fairs which simply have no data.
  Scenario Outline: Validate a 200 status code for a invalid fairId
    * def getFatpipeTendersItemizedReportResponse = call read('classpath:common/bookfairs/fatpipe_reports/pos_reporting_service/POSReportingRunnerHelper.feature@@GetFatpipeTendersItemizedReportRunner'){FAIR_ID : '<FAIR_ID>'}
    * print getFatpipeTendersItemizedReportResponse
    Then match getFatpipeTendersItemizedReportResponse.responseStatus == 200
    Then match getFatpipeTendersItemizedReportResponse.response.metaData.params.fairId == '#(FAIR_ID)'

    @QA
    Examples:
      | FAIR_ID |
      | 5630    |

  Scenario Outline: Validate when invalid input is provided
    Given url BOOKFAIRS_FATPIPE_REPORTS_URL + getTendersItemizedUri
    And headers {Content-Type : 'application/json'}
    And def pathParams = {bookFairId : '#(FAIR_ID)'}
    And path pathParams.bookFairId + '/pos/tenders/itemized'
    And params {tenderAuthStatusGroup:'REGISTE',tenderStatusGroup:'REGIST',transactionStatusGroup:'REGISTER',page:0,size:100}
    And method GET
      #COMMENT : On postman and swagger 400 is generated for this test scenario but here it shows 404, please suggest what to do with this scenario.
    Then match responseStatus == 400

    @QA
    Examples:
      | FAIR_ID |
      | 5633533 |
