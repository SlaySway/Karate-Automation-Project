@GetFairInfo
Feature: Canada Toolkit Get Fair Info API Tests

  #TODO: When time is available
  # validate fairInfo against cmdm fair dates
  # validate all other fields against mongo except fairInfo.dates and provinces
  Background: Set config
    * string getFairInfoUri = "/api/user/fairs/<fairId>/homepage/fair-info"

  Scenario Outline: Validate fields against mongo and 200 OK when valid userEmail and resourceId provided, user:<USER_NAME>, fair:<FAIRID_OR_CURRENT>
    Given def response = call read('RunnerHelper.feature@GetFairInfo'){FAIR_ID:<FAIRID_OR_CURRENT>, USER_NAME:<USER_NAME>}
    * print response.response

    And def AGGREGATE_PIPELINE =
    """
    [
      {
        $match:{
            "fairId":"#(FAIRID_OR_CURRENT)"
        }
      }
    ]
    """
    And def mongoResults = call read('classpath:common/bookfairs/canada/MongoDBRunner.feature@RunAggregate'){collectionName: "fairs"}


    Then match response.responseStatus == 200

  @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com | password1 | 5196693           |