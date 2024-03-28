@GetFinancialFormEarnings @PerformanceEnhancement
Feature: GetFinancialFormEarnings GET Api tests

  Background: Set config
    * def obj = Java.type('utils.StrictValidation')
    * def getFinancialFormEarningsUri = "/bookfairs-jarvis/api/user/fairs/<resourceId>/financials/form/earnings"
    * def invalidGetFinFormEarningsUri = "/bookfairs-jarvis/api/user/fairs/<resourceId>/financial/forms/earn"

  @Happy
  Scenario Outline: Validate when user doesn't have access to CPTK for user:<USER_NAME> and fair:<RESOURCE_ID>
    Given def getFinancialFormEarningsResponse = call read('RunnerHelper.feature@GetFinancialFormEarnings')
    Then match getFinancialFormEarningsResponse.responseStatus == 200

    @QA
    Examples:
      | USER_NAME              | PASSWORD  | RESOURCE_ID |
      | mtodaro@scholastic.com | passw0rd  | 5694318     |
      | mtodaro@scholastic.com | passw0rd  | current     |
      | azhou1@scholastic.com  | password1 | 5694296     |

    @Happy
    Scenario Outline: Validate when user doesn't have access to CPTK for user:<USER_NAME> and fair:<RESOURCE_ID>
      * def REQUEST_BODY = { scholasticDollars:{selected:1}, cash:{selected:2} }
      Given def updateFinFormEarningsResponse = call read('RunnerHelper.feature@UpdateFinFormEarnings')
      Then match updateFinFormEarningsResponse.responseStatus == 200
      Then def getFinancialFormEarningsResponse = call read('RunnerHelper.feature@GetFinancialFormEarnings')
      And match getFinancialFormEarningsResponse.responseStatus == 200
      * print getFinancialFormEarningsResponse.response.scholasticDollars.selected
      And match getFinancialFormEarningsResponse.response.scholasticDollars.selected == REQUEST_BODY.scholasticDollars.selected
      And match getFinancialFormEarningsResponse.response.cash.selected == REQUEST_BODY.cash.selected

      @QA
      Examples:
        | USER_NAME              | PASSWORD  | RESOURCE_ID |
        | mtodaro@scholastic.com | passw0rd  | 5694318     |
        | azhou1@scholastic.com  | password1 | 5694296     |

  @Unhappy
  Scenario Outline: Validate when user doesn't have access to CPTK for user:<USER_NAME> and fair:<RESOURCE_ID>
    Given def getFinancialFormEarningsResponse = call read('RunnerHelper.feature@GetFinancialFormEarnings')
    Then match getFinancialFormEarningsResponse.responseStatus == 204
    And match getFinancialFormEarningsResponse.responseHeaders['Sbf-Jarvis-Reason'][0] == "NO_ASSOCIATED_RESOURCES"

    @QA
    Examples:
      | USER_NAME           | PASSWORD  | RESOURCE_ID |
      | nofairs@testing.com | password1 | current     |

  @Unhappy
  Scenario Outline: Validate when user attempts to access a non-COA Accepted fair:<USER_NAME> and fair:<RESOURCE_ID>
    Given def getFinancialFormEarningsResponse = call read('RunnerHelper.feature@GetFinancialFormEarnings')
    Then match getFinancialFormEarningsResponse.responseStatus == 204
    And match getFinancialFormEarningsResponse.responseHeaders['Sbf-Jarvis-Reason'][0] == "NEEDS_COA_CONFIRMATION"

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | RESOURCE_ID |
      | azhou1@scholastic.com | password1 | 5694300     |

  @Unhappy
  Scenario Outline: Validate when SCHL cookie is not passed for fair:<RESOURCE_ID>
    * replace getFinancialFormEarningsUri.resourceId =  RESOURCE_ID
    * url BOOKFAIRS_JARVIS_URL + getFinancialFormEarningsUri
    Given method get
    Then match responseStatus == 204
    And match responseHeaders['Sbf-Jarvis-Reason'][0] == "NO_SCHL"

    @QA
    Examples:
      | RESOURCE_ID |
      | 5694296     |
      | current     |

  @Unhappy
  Scenario: Validate when SCHL cookie is expired
    * replace getFinancialFormEarningsUri.resourceId =  "current"
    * url BOOKFAIRS_JARVIS_URL + getFinancialFormEarningsUri
    * cookies { SCHL : 'eyJraWQiOiJub25wcm9kLTIwMjEzMzExMzMyIiwidHlwIjoiSldUIiwiYWxnIj'}
    Given method get
    Then match responseStatus == 204
    And match responseHeaders['Sbf-Jarvis-Reason'][0] == "NO_SCHL"

  @Unhappy
  Scenario Outline: Validate for internal server error
    Given def selectFairResponse = call read('classpath:common/bookfairs/jarvis/SelectionAndBasicInfo/RunnerHelper.feature@SelectFair'){RESOURCE_ID: <SBF_JARVIS_FAIR>}
    * replace invalidGetFinFormEarningsUri.resourceId =  RESOURCE_ID
    * url BOOKFAIRS_JARVIS_URL + invalidGetFinFormEarningsUri
    * cookies { SCHL : '#(selectFairResponse.SCHL)', SBF_JARVIS: '#(selectFairResponse.SBF_JARVIS)'}
    Given method get
    Then match responseStatus == 500

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | RESOURCE_ID | SBF_JARVIS_FAIR |
      | azhou1@scholastic.com | password1 | 5694296     | 5694309         |

  @Unhappy
  Scenario Outline: Validate when user doesn't have access to specific fair for user:<USER_NAME> and fair:<RESOURCE_ID>
    Given def getFinancialFormEarningsResponse = call read('RunnerHelper.feature@GetFinancialFormEarnings')
    Then match getFinancialFormEarningsResponse.responseStatus == 403
    And match getFinancialFormEarningsResponse.responseHeaders['Sbf-Jarvis-Reason'][0] == "RESOURCE_ID_NOT_VALID"

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | RESOURCE_ID |
      | azhou1@scholastic.com | password1 | 5734325     |

  @Unhappy
  Scenario Outline: Validate when user uses an invalid fair ID for user:<USER_NAME> and fair:<RESOURCE_ID>
    Given def getFinancialFormEarningsResponse = call read('RunnerHelper.feature@GetFinancialFormEarnings')
    Then match getFinancialFormEarningsResponse.responseStatus == 404
    And match getFinancialFormEarningsResponse.responseHeaders['Sbf-Jarvis-Reason'][0] == "MALFORMED_RESOURCE_ID"

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | RESOURCE_ID |
      | azhou1@scholastic.com | password1 | abc1234     |

  @Unhappy
  Scenario Outline: Validate when unsupported http method is called
    Given def selectFairResponse = call read('classpath:common/bookfairs/jarvis/SelectionAndBasicInfo/RunnerHelper.feature@SelectFair'){RESOURCE_ID: <SBF_JARVIS_FAIR>}
    * replace getFinancialFormEarningsUri.resourceId =  RESOURCE_ID
    * url BOOKFAIRS_JARVIS_URL + getFinancialFormEarningsUri
    * cookies { SCHL : '#(selectFairResponse.SCHL)', SBF_JARVIS: '#(selectFairResponse.SBF_JARVIS)'}
    Given method patch
    Then match responseStatus == 405
    Then match response.error == "Method Not Allowed"

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | RESOURCE_ID | SBF_JARVIS_FAIR |
      | azhou1@scholastic.com | password1 | 5694296     | 5694309         |

  @Happy
  Scenario Outline: Validate when user inputs different configurations for fairId/current for CONFIRMED fairs:<USER_NAME>, fair:<RESOURCE_ID>, scenario:<SCENARIO>
    Given def getFinancialFormEarningsResponse = call read('RunnerHelper.feature@GetFinancialFormEarnings')
    Then match getFinancialFormEarningsResponse.responseHeaders['Sbf-Jarvis-Resource-Id'][0] == EXPECTED_FAIR
    And if(RESOURCE_ID == 'current') karate.log(karate.match(getFinancialFormEarningsResponse.responseHeaders['Sbf-Jarvis-Resource-Selection'][0], 'AUTOMATICALLY_SELECTED_THIS_REQUEST'))

    @QA
    Examples:
      | USER_NAME                                   | PASSWORD  | RESOURCE_ID | EXPECTED_FAIR | SCENARIO                                     |
      | azhou1@scholastic.com                       | password1 | 5694296     | 5694296       | Return path parameter fairId information     |
      | azhou1@scholastic.com                       | password1 | current     | 5694296       | Has current, upcoming, and past fairs        |
      | hasAllFairs@testing.com                     | password1 | current     | 5694301       | Has all fairs                                |
      | hasUpcomingAndPastFairs@testing.com         | password1 | current     | 5694305       | Has upcoming and past fairs                  |
      | hasPastFairs@testing.com                    | password1 | current     | 5694307       | Has past fairs                               |
      | hasRecentlyUpcomingAndPastFairs@testing.com | password1 | current     | 5694303       | Has recently ended, upcoming, and past fairs |

  @Happy
  Scenario Outline: Validate when user inputs different configurations for fairId/current WITH SBF_JARVIS for DO_NOT_SELECT mode with user:<USER_NAME>, fair:<RESOURCE_ID>, cookie fair:<SBF_JARVIS_FAIR>
    Given def selectFairResponse = call read('classpath:common/bookfairs/jarvis/SelectionAndBasicInfo/RunnerHelper.feature@SelectFair'){RESOURCE_ID: <SBF_JARVIS_FAIR>}
    * replace getFinancialFormEarningsUri.resourceId = RESOURCE_ID
    * url BOOKFAIRS_JARVIS_URL + getFinancialFormEarningsUri
    * cookies { SCHL : '#(selectFairResponse.SCHL)', SBF_JARVIS: '#(selectFairResponse.SBF_JARVIS)'}
    Then method get
    Then match responseHeaders['Sbf-Jarvis-Resource-Id'][0] == EXPECTED_FAIR
    And if(RESOURCE_ID == 'current') karate.log(karate.match(responseHeaders['Sbf-Jarvis-Resource-Selection'][0], 'PREVIOUSLY_SELECTED'))

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | RESOURCE_ID | EXPECTED_FAIR | SBF_JARVIS_FAIR |
      | azhou1@scholastic.com | password1 | 5694296     | 5694296       | 5694309         |
      | azhou1@scholastic.com | password1 | current     | 5694296       | 5694296         |

  @Regression @ignore
  Scenario Outline: Validate regression using dynamic comparison || fairId=<RESOURCE_ID>
    * def BaseResponseMap = call read('RunnerHelper.feature@GetFinancialFormEarningsBase')
    * def TargetResponseMap = call read('RunnerHelper.feature@GetFinancialFormEarnings')
    * string base = BaseResponseMap.response
    * string target = TargetResponseMap.response
    * def compResult = obj.strictCompare(base, target)
    Then print "Response from production code base", BaseResponseMap.response
    Then print "Response from current qa code base", TargetResponseMap.response
    Then print 'Differences any...', compResult

    Examples:
      | USER_NAME             | PASSWORD  | RESOURCE_ID |
      | azhou1@scholastic.com | password1 | 5694296     |

  @Happy @Mongo
  Scenario Outline: Validate invoice flow for user <USER_NAME>, fair:<RESOURCE_ID>
    * def convertNumberDecimal =
    """
    function(json){
      if(typeof json !== 'object' || json == null) {
          return json;
      }
      for(let field in json){
          let isFieldObject = (typeof json[field] === 'object');
          if(!Array.isArray(json[field]) && isFieldObject && json[field].containsKey('$numberDecimal')){
              json[field] = Number(json[field]['$numberDecimal']);
          }
          else if (isFieldObject){
              convertNumberDecimal(json[field]);
          }
        }
    }
    """
    Given def getFinancialFormEarningsResponse = call read('RunnerHelper.feature@GetFinancialFormEarnings')
    Then match getFinancialFormEarningsResponse.responseStatus == 200
    Then def mongoJson = call read('classpath:common/bookfairs/bftoolkit/MongoDBRunner.feature@FindDocumentByField') {collection:"financials", field:"_id", value:"#(RESOURCE_ID)"}
    * convertNumberDecimal(mongoJson.document)
    And def earningsDocument = mongoJson.document
    * print earningsDocument
    And match getFinancialFormEarningsResponse.response.sales == ((earningsDocument.sales.grossSales.taxExemptSales + earningsDocument.sales.grossSales.taxableSales) - (earningsDocument.sales.scholasticDollars.totalRedeemed - earningsDocument.sales.scholasticDollars.taxCollected)* 0.5)
    * def checkDollarFairLevel =
    """
    function(response){
    if (response.sales >= 3500){
    if (response.dollarFairLevel != '50') {
          karate.log('Expected "50" dollar fair level for sales >= 3500');
          karate.fail('Dollar fair level does not match expected value');
        }
      }
    else if (response.sales >= 1500 && response.sales <= 3500) {
    if (response.dollarFairLevel != '40') {
          karate.log('Expected "40" dollar fair level for sales between 1500 and 3500');
          karate.fail('Dollar fair level does not match expected value');
        }
      }
    else {
        if (response.dollarFairLevel != '30') {
          karate.log('Expected "30" dollar fair level');
          karate.fail('Dollar fair level does not match expected value');
        }
      }
    }
    """
    Given def getFinancialFormEarningsResponse = call read('RunnerHelper.feature@GetFinancialFormEarnings')
    * eval checkDollarFairLevel(getFinancialFormEarningsResponse.response)
    * print checkDollarFairLevel(getFinancialFormEarningsResponse.response)
    Given def getFinancialFormResponse = call read('RunnerHelper.feature@GetFinancialForm')
    Then match getFinancialFormResponse.responseStatus == 200
    And match getFinancialFormEarningsResponse.response.scholasticDollars.earned == Math.ceil(((getFinancialFormResponse.response.earnings.sales) * getFinancialFormEarningsResponse.response.dollarFairLevel/100)*100)/100
    And match getFinancialFormEarningsResponse.response.scholasticDollars.due == getFinancialFormResponse.response.spending.scholasticDollars.due
    And match getFinancialFormEarningsResponse.response.scholasticDollars.balance == getFinancialFormResponse.response.earnings.scholasticDollars.earned - (Math.abs(getFinancialFormResponse.response.earnings.scholasticDollars.due))
    And match getFinancialFormEarningsResponse.response.scholasticDollars.selected == earningsDocument.fairEarning.scholasticDollars.selected
    And match getFinancialFormEarningsResponse.response.scholasticDollars.max == getFinancialFormResponse.response.earnings.scholasticDollars.balance
    And match getFinancialFormEarningsResponse.response.cash.selected == earningsDocument.fairEarning.cash.selected
    And match getFinancialFormEarningsResponse.response.cash.max == Math.floor(((getFinancialFormEarningsResponse.response.scholasticDollars.balance)* 0.5)*100)/100

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | RESOURCE_ID |
      | azhou1@scholastic.com | password1 | 5694296     |
