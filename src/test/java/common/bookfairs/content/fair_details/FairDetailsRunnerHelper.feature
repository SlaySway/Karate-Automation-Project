
Feature:Helper for running FairDetails api

  Background: Set config
    * string GETContentFairDetail = "/api/fairdetail"

  @GETContentFairDetail
  Scenario:Run GetFairDetail API
    Given url BOOKFAIRS_CONTENT_URL + GETContentFairDetail
    Given header Authorization = 'Bearer '+contentAccessToken
    And def pathParams = {bookFairId : '#(FAIRID)'}
    And path pathParams.bookFairId
    And method get
    Then def StatusCode = responseStatus
    And def ResponseString = response