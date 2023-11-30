@getPublicHomePageTest @public&userTests
Feature: GetPublicHomepage API automation tests

  Background: Set config
    * string getPublicHomepageUrl = "/bookfairs-jarvis/api/public/homepages"

  Scenario Outline: Validate request when manadtory path parameter 'webUrl' is not passed
    Given url BOOKFAIRS_JARVIS_URL + getPublicHomepageUrl
    And method get
    Then match responseStatus == 404

    @QA
    Examples: 
      | USER_NAME              | PASSWORD | FAIRID_OR_CURRENT | WEB_URL |
      | mtodaro@scholastic.com | passw0rd |           5795071 |         |

  Scenario Outline: Validate request when manadtory path parameter 'webUrl' is invalid
    Given url BOOKFAIRS_JARVIS_URL + getPublicHomepageUrl
    And path WEB_URL
    And method get
    Then match responseStatus == 404

    @QA
    Examples: 
      | USER_NAME              | PASSWORD | FAIRID_OR_CURRENT | WEB_URL  |
      | mtodaro@scholastic.com | passw0rd |           5795071 | abcd1234 |

  Scenario Outline: Validate request when optioanl query parameter 'fairId' is invalid
    Given url BOOKFAIRS_JARVIS_URL + getPublicHomepageUrl
    And path WEB_URL
    And param fairId = FAIRID_OR_CURRENT
    And method get
    Then match responseStatus == 500

    @QA
    Examples: 
      | USER_NAME              | PASSWORD | FAIRID_OR_CURRENT | WEB_URL                 |
      | mtodaro@scholastic.com | passw0rd |           1112223 | aboveandbeyondpreschool |

  Scenario Outline: Validate request when manadtory path parameter 'webUrl' is valid
    Given url BOOKFAIRS_JARVIS_URL + getPublicHomepageUrl
    And path WEB_URL
    And method get
    Then match responseStatus == 200

    @QA
    Examples: 
      | USER_NAME                        | PASSWORD  | FAIRID_OR_CURRENT | WEB_URL                 |
      | mtodaro@scholastic.com           | passw0rd  |           5795071 | aboveandbeyondpreschool |
      | amomin-consultant@scholastic.com | Bookfair2 |           5829151 | academystreetschool2    |

  Scenario Outline: Validate request when optioanl query parameter 'fairId' is valid
    Given url BOOKFAIRS_JARVIS_URL + getPublicHomepageUrl
    And path WEB_URL
    And param fairId = FAIRID_OR_CURRENT
    And method get
    Then match responseStatus == 200
    And match response.fair.id == <FAIRID_OR_CURRENT>

    @QA
    Examples: 
      | USER_NAME                        | PASSWORD  | FAIRID_OR_CURRENT | WEB_URL                 |
      | mtodaro@scholastic.com           | passw0rd  |           5795071 | aboveandbeyondpreschool |
      | amomin-consultant@scholastic.com | Bookfair2 |           5829151 | academystreetschool2    |

  #Enable this scenario after DEC release
  @ignore
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
      | USER_NAME              | PASSWORD | FAIRID_OR_CURRENT | WEB_URL                      |
      | mtodaro@scholastic.com | passw0rd |           5795066 | watergrasselementaryschool30 |
      | mtodaro@scholastic.com | passw0rd |           5795071 | watergrasselementaryschool6  |
      | mtodaro@scholastic.com | passw0rd |           5797220 | watergrasselementaryschool3  |
      | mtodaro@scholastic.com | passw0rd |           5795061 | watergrasselementaryschool1  |
      | mtodaro@scholastic.com | passw0rd |           5795064 | watergrasselementaryschool   |
      | mtodaro@scholastic.com | passw0rd |           5795065 | watergrasselementaryschool2  |
      | mtodaro@scholastic.com | passw0rd |           5795067 | watergrasselementaryschool4  |
      | mtodaro@scholastic.com | passw0rd |           5795068 | watergrasselementaryschool5  |
      | mtodaro@scholastic.com | passw0rd |           5795068 | watergrasselementaryschool5  |
      | mtodaro@scholastic.com | passw0rd |           5731888 | ourladyofgraceacademy8       |
      #| mtodaro@scholastic.com | passw0rd |           5814798 |                              |
      #| mtodaro@scholastic.com | passw0rd |           5795069 |                              |
      #| mtodaro@scholastic.com | passw0rd |           5795070 |                              |
