@GetLibraryDetailsTest @QA
Feature: Library details API automation tests

  Background: Set config
    * def obj = Java.type('utils.StrictValidation')
    * string getLibraryDetails = "/api/user/library/orgs/<accountId>"

  Scenario Outline: Validate 200 response code for a valid request
    * def getLibraryDetailsResponseMap = call read('classpath:common/bookfairs/library_processing/RunnerHelper.feature@GetLibraryDetails'){ACCOUNT_ID : '<ACCOUNT_ID>'}
    Then match getLibraryDetailsResponseMap.responseStatus == 200
    * def readingPlacementValue = getLibraryDetailsResponseMap.response.readingLabelPlacement.value
    * def readingPlacementValFunction =
    """
     function(){
    if(getLibraryDetailsResponseMap.response.readingLabelPlacement.value >= 57 && getLibraryDetailsResponseMap.response.readingLabelPlacement.value <= 59)
    return true
      }
    """
    * def barCodePlacementValFunction =
    """
    function(){
    if(getLibraryDetailsResponseMap.response.barcodePlacement.value >= 1 && getLibraryDetailsResponseMap.response.barcodePlacement.value <= 18)
    return true
      }
    """

    @QA
    Examples:
      | ACCOUNT_ID |
      | 12345      |

  Scenario Outline: Validate 200 response code for an accountId not existing in database
    * def getLibraryDetailsResponseMap = call read('classpath:common/bookfairs/library_processing/RunnerHelper.feature@GetLibraryDetails'){ACCOUNT_ID : '<ACCOUNT_ID>'}
    Then match getLibraryDetailsResponseMap.responseStatus == 200

    @QA
    Examples:
      | ACCOUNT_ID |
      | abcd1234   |

  Scenario Outline: Validate 404 response code for passing no accountId
    * def getLibraryDetailsResponseMap = call read('classpath:common/bookfairs/library_processing/RunnerHelper.feature@GetLibraryDetails'){ACCOUNT_ID : '<ACCOUNT_ID>'}
    Then match getLibraryDetailsResponseMap.responseStatus == 404

    @QA
    Examples:
      | ACCOUNT_ID |
      |            |

  @Regression @ignore
  Scenario Outline: Validate regression using dynamic comparison || accountId=<ACCOUNT_ID>
    * def BaseResponseMap = call read('classpath:common/bookfairs/library_processing/RunnerHelper.feature@GetLibraryDetailsBase')
    * def TargetResponseMap = call read('classpath:common/bookfairs/library_processing/RunnerHelper.feature@GetLibraryDetails')
    Then match BaseResponseMap.responseStatus == TargetResponseMap.responseStatus
    Then match BaseResponseMap.response == TargetResponseMap.response

    * string base = BaseResponseMap.response
    * string target = TargetResponseMap.response
    * def compResult = obj.strictCompare(base, target)
    Then print "Response from production code base", base
    Then print "Response from current qa code base", target
    Then print 'Differences any...', compResult
    And match base == target

    @QA
    Examples:
      | ACCOUNT_ID |
      | 12345      |
