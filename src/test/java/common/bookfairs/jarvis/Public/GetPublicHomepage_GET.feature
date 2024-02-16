@getPublicHomePageTest @public&userTests @PerformanceEnhancement
Feature: GetPublicHomepage API automation tests

  Background: Set config
    * string getPublicHomepageUrl = "/bookfairs-jarvis/api/public/homepages"

  Scenario Outline: Validate request when manadtory path parameter 'webUrl' is not passed
    Given url BOOKFAIRS_JARVIS_URL + getPublicHomepageUrl
    And method get
    Then match responseStatus == 404

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT | WEB_URL |
      | azhou1@scholastic.com | password1 | 5694296           |         |

  Scenario Outline: Validate request when manadtory path parameter 'webUrl' is invalid
    Given url BOOKFAIRS_JARVIS_URL + getPublicHomepageUrl
    And path WEB_URL
    And method get
    Then match responseStatus == 404

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT | WEB_URL |
      | azhou1@scholastic.com | password1 | 5694296           | abc123  |

  Scenario Outline: Validate request when optioanl query parameter 'fairId' is invalid
    Given url BOOKFAIRS_JARVIS_URL + getPublicHomepageUrl
    And path WEB_URL
    And param fairId = FAIRID_OR_CURRENT
    And method get
    Then match responseStatus == 500

    @QA
    Examples:
      | USER_NAME              | PASSWORD | FAIRID_OR_CURRENT | WEB_URL                 |
      | mtodaro@scholastic.com | passw0rd | 1112223           | aboveandbeyondpreschool |

  Scenario Outline: Validate request when manadtory path parameter 'webUrl' is valid
    Given url BOOKFAIRS_JARVIS_URL + getPublicHomepageUrl
    And path WEB_URL
    And method get
    Then match responseStatus == 200

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT | WEB_URL              |
      | azhou1@scholastic.com | password1 | 5694296           | iAmAnAutomationssUrl |

  Scenario Outline: Validate request when optioanl query parameter 'fairId' is valid
    Given url BOOKFAIRS_JARVIS_URL + getPublicHomepageUrl
    And path WEB_URL
    And param fairId = FAIRID_OR_CURRENT
    And method get
    Then match responseStatus == 200
    And match response.fair.id == <FAIRID_OR_CURRENT>

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT | WEB_URL            |
      | azhou1@scholastic.com | password1 | 5694296           | iAmAnAutomationUrl |

  #Enable this scenario after DEC release
  @ignore @Regression
  Scenario Outline: Validate regression with current prod version | <USER_NAME> | <FAIRID_OR_CURRENT> |
    Given url BOOKFAIRS_JARVIS_URL + getPublicHomepageUrl
    And path WEB_URL
    And param fairId = FAIRID_OR_CURRENT
    And method get
    Then string TargetResponse = response
    Then string TargetStatusCd = responseStatus
    Given url BOOKFAIRS_JARVIS_BASE + getPublicHomepageUrl
    And path WEB_URL
    And param fairId = FAIRID_OR_CURRENT
    And method get
    Then string BaseResponse = response
    Then string BaseStatusCd = responseStatus
    Then match BaseStatusCd == TargetStatusCd
    * def compResult = obj.strictCompare(BaseResponse, TargetResponse)
    Then print "Response from production code base", BaseResponse
    Then print "Response from current qa code base", TargetResponse
    Then print 'Differences any...', compResult
    And match BaseResponse == TargetResponse

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT | WEB_URL            |
      | azhou1@scholastic.com | password1 | 5694296           | iAmAnAutomationUrl |
