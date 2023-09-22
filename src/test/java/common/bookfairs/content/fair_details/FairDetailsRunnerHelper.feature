
@ignore @report=true
Feature:Helper for running fair-detail api

  Background: Set config
    * string getContentFairDetail = "/bookfairs-content/api/fairdetail"

  @getContentFairDetailRunner
  Scenario:Run GetFairDetail API
    Given url BOOKFAIRS_CONTENT_URL + getContentFairDetail
    Given header Authorization = 'Bearer '+CONTENT_ACCESS_TOKEN
    And def pathParams = {bookFairId : '#(FAIRID)'}
    And path pathParams.bookFairId
    And method get
    Then def StatusCode = responseStatus
    And def ResponseString = response