Feature: Test the endpoints necessary for scheduled job to change satus of fair

  Scenario Outline: User has a REOPENED fair that is then set to PROCESSED then back to REOPENED
    Given def mongoJson = call read('classpath:common/bookfairs/ewallet_2/MongoDBRunner.feature@FindDocumentByFieldThenUpdateField') {collection:"fair", field:"_id", value:"#(FAIRID_OR_CURRENT)", updateField:'status', updateValue:'OPEN'}
    Given def mongoJson = call read('classpath:common/bookfairs/ewallet_2/MongoDBRunner.feature@FindDocumentByField') {collection:"fair", field:"_id", value:"#(FAIRID_OR_CURRENT)"}
    Then match mongoJson.document.status == "OPEN"
    Given def apiResponse = call read('RunnerHelper.feature@UpdateFairChecksByFairId') {FAIRID:'#(FAIRID_OR_CURRENT)', disableFairApiCheck: true, disablePosApiCheck: true}
    Then match apiResponse.responseStatus == 200
    Given def mongoJson = call read('classpath:common/bookfairs/ewallet_2/MongoDBRunner.feature@FindDocumentByField') {collection:"fair", field:"_id", value:"#(FAIRID_OR_CURRENT)"}
    Then match mongoJson.document.status == "OPEN"
    Given def apiResponse = call read('RunnerHelper.feature@CloseFairByFairId') {FAIRID:'#(FAIRID_OR_CURRENT)'}
    Then match apiResponse.responseStatus == 201
    Given def mongoJson = call read('classpath:common/bookfairs/ewallet_2/MongoDBRunner.feature@FindDocumentByField') {collection:"fair", field:"_id", value:"#(FAIRID_OR_CURRENT)"}
    Then match mongoJson.document.status == "PROCESSED"
    Given def apiResponse = call read('RunnerHelper.feature@UpdateFairChecksByFairId') {FAIRID:'#(FAIRID_OR_CURRENT)', disableFairApiCheck: true, disablePosApiCheck: true}
    Then match apiResponse.responseStatus == 200
    Given def mongoJson = call read('classpath:common/bookfairs/ewallet_2/MongoDBRunner.feature@FindDocumentByField') {collection:"fair", field:"_id", value:"#(FAIRID_OR_CURRENT)"}
    Then match mongoJson.document.status == "REOPENED"
    Given def apiResponse = call read('RunnerHelper.feature@UpdateFairChecksByFairId') {FAIRID:'#(FAIRID_OR_CURRENT)', disableFairApiCheck: true, disablePosApiCheck: true}
    Then match apiResponse.responseStatus == 200
    Given def mongoJson = call read('classpath:common/bookfairs/ewallet_2/MongoDBRunner.feature@FindDocumentByField') {collection:"fair", field:"_id", value:"#(FAIRID_OR_CURRENT)"}
    Then match mongoJson.document.status == "REOPENED"
    Given def apiResponse = call read('RunnerHelper.feature@CloseFairByFairId') {FAIRID:'#(FAIRID_OR_CURRENT)'}
    Then match apiResponse.responseStatus == 201
    Given def mongoJson = call read('classpath:common/bookfairs/ewallet_2/MongoDBRunner.feature@FindDocumentByField') {collection:"fair", field:"_id", value:"#(FAIRID_OR_CURRENT)"}
    Then match mongoJson.document.status == "PROCESSED"
    Given def apiResponse = call read('RunnerHelper.feature@UpdateFairChecksByFairId') {FAIRID:'#(FAIRID_OR_CURRENT)', disableFairApiCheck: true, disablePosApiCheck: true}
    Then match apiResponse.responseStatus == 200
    Given def mongoJson = call read('classpath:common/bookfairs/ewallet_2/MongoDBRunner.feature@FindDocumentByField') {collection:"fair", field:"_id", value:"#(FAIRID_OR_CURRENT)"}
    Then match mongoJson.document.status == "REOPENED"

    Examples:
      | FAIRID_OR_CURRENT |
      | 5694296           |
