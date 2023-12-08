@ignore @report=true
Feature:Helper for running fair-detail api

  Background: Set config
    * string getContentFairDetailUri = "/bookfairs-content/api/fairdetail"

    #Input: FAIR_ID, (OPTIONAL) VERSION
    #Output: response
  @GetContentFairDetailRunner
  Scenario:Run GetFairDetail API
    Given url BOOKFAIRS_CONTENT_URL + getContentFairDetailUri
    Given header Authorization = 'Bearer '+CONTENT_ACCESS_TOKEN
    * def VERSION = karate.get('VERSION', '')
    And param version = VERSION
    And def pathParams = {bookFairId : '#(FAIR_ID)'}
    And path pathParams.bookFairId
    And method GET
