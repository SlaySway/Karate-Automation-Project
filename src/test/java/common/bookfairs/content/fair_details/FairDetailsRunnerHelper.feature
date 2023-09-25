
@ignore @report=true
Feature:Helper for running fair-detail api

  Background: Set config
    * string getContentFairDetail = "/bookfairs-content/api/fairdetail"

    #Input: FAIR_ID
    #Output: response
  @GetContentFairDetailRunner
  Scenario:Run GetFairDetail API
    Given url BOOKFAIRS_CONTENT_URL + getContentFairDetail
    Given header Authorization = 'Bearer '+CONTENT_ACCESS_TOKEN
    And def pathParams = {bookFairId : '#(FAIR_ID)'}
    And path pathParams.bookFairId
    And method GET
