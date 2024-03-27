@GetFinancialFormSales @PerformanceEnhancement
Feature: GetFinancialFormSales GET Api tests

  Background: Set config
    * def obj = Java.type('utils.StrictValidation')
    * def getFinancialFormSalesUri = "/bookfairs-jarvis/api/user/fairs/<resourceId>/financials/form/sales"

  @Happy
  Scenario Outline: Validate when user doesn't have access to CPTK for user:<USER_NAME> and fair:<RESOURCE_ID>
    Given def getFinancialFormSalesResponse = call read('RunnerHelper.feature@GetFinancialFormSales')
    Then match getFinancialFormSalesResponse.responseStatus == 200

    @QA
    Examples:
      | USER_NAME              | PASSWORD  | RESOURCE_ID |
      | mtodaro@scholastic.com | passw0rd  | 5694314     |
      | mtodaro@scholastic.com | passw0rd  | current     |
      | azhou1@scholastic.com  | password1 | 5694296     |

  @Happy
  Scenario Outline: Validate with request payload for user:<USER_NAME> and fair:<RESOURCE_ID>
    * def REQUEST_BODY = read('UpdateFinFormSalesRequest.json')[requestBodyJson]
    Given def updateFinFormSalesResponse = call read('RunnerHelper.feature@UpdateFinFormSales')
    Then match updateFinFormSalesResponse.responseStatus == 200
    Then def getFinancialFormSalesResponse = call read('RunnerHelper.feature@GetFinancialFormSales')
    And match getFinancialFormSalesResponse.responseStatus == 200
    And match getFinancialFormSalesResponse.response.scholasticDollars.totalRedeemed == REQUEST_BODY.sales.scholasticDollars.totalRedeemed
    And match getFinancialFormSalesResponse.response.scholasticDollars.taxExemptSales == REQUEST_BODY.sales.scholasticDollars.taxExemptSales
    And match getFinancialFormSalesResponse.response.scholasticDollars.taxCollected == REQUEST_BODY.sales.scholasticDollars.taxCollected
    And match getFinancialFormSalesResponse.response.tenderTotals.cashAndChecks == REQUEST_BODY.sales.tenderTotals.cashAndChecks
    And match getFinancialFormSalesResponse.response.tenderTotals.creditCards == REQUEST_BODY.sales.tenderTotals.creditCards
    And match getFinancialFormSalesResponse.response.tenderTotals.purchaseOrders == REQUEST_BODY.sales.tenderTotals.purchaseOrders
    And match getFinancialFormSalesResponse.response.grossSales.taxExemptSales == REQUEST_BODY.sales.grossSales.taxExemptSales
    And match getFinancialFormSalesResponse.response.grossSales.taxableSales == REQUEST_BODY.sales.grossSales.taxableSales
    And match getFinancialFormSalesResponse.response.grossSales.total == REQUEST_BODY.sales.grossSales.taxExemptSales + REQUEST_BODY.sales.grossSales.taxableSales
    * def taxTotal = getFinancialFormSalesResponse.response.grossSales.taxableSales - (getFinancialFormSalesResponse.response.grossSales.taxableSales/(1+getFinancialFormSalesResponse.response.taxRate/100.0))
    And match getFinancialFormSalesResponse.response.grossSales.taxTotal == Math.ceil(taxTotal*100)/100
    And match getFinancialFormSalesResponse.response.netSales.shareTheFairFunds.collected == REQUEST_BODY.sales.netSales.shareTheFairFunds.collected
    And match getFinancialFormSalesResponse.response.netSales.shareTheFairFunds.redeemed == REQUEST_BODY.sales.netSales.shareTheFairFunds.redeemed

    @QA
    Examples:
      | USER_NAME              | PASSWORD  | RESOURCE_ID | requestBodyJson |
      | mtodaro@scholastic.com | passw0rd  | 5694318     | updateSales     |
      | azhou1@scholastic.com  | password1 | 5694296     | updateSales     |

  @Unhappy
  Scenario Outline: Validate when user doesn't have access to CPTK for user:<USER_NAME> and fair:<RESOURCE_ID>
    Given def getFinancialFormSalesResponse = call read('RunnerHelper.feature@GetFinancialFormSales')
    Then match getFinancialFormSalesResponse.responseStatus == 204
    And match getFinancialFormSalesResponse.responseHeaders['Sbf-Jarvis-Reason'][0] == "NO_ASSOCIATED_RESOURCES"

    @QA
    Examples:
      | USER_NAME           | PASSWORD  | RESOURCE_ID |
      | nofairs@testing.com | password1 | current     |

  @Unhappy
  Scenario Outline: Validate when user attempts to access a non-COA Accepted fair:<USER_NAME> and fair:<RESOURCE_ID>
    Given def getFinancialFormSalesResponse = call read('RunnerHelper.feature@GetFinancialFormSales')
    Then match getFinancialFormSalesResponse.responseStatus == 204
    And match getFinancialFormSalesResponse.responseHeaders['Sbf-Jarvis-Reason'][0] == "NEEDS_COA_CONFIRMATION"

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | RESOURCE_ID |
      | azhou1@scholastic.com | password1 | 5694300     |

  @Unhappy
  Scenario Outline: Validate when SCHL cookie is not passed for fair:<RESOURCE_ID>
    * replace getFinancialFormSalesUri.resourceId =  RESOURCE_ID
    * url BOOKFAIRS_JARVIS_URL + getFinancialFormSalesUri
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
    * replace getFinancialFormSalesUri.resourceId =  "current"
    * url BOOKFAIRS_JARVIS_URL + getFinancialFormSalesUri
    * cookies { SCHL : 'eyJraWQiOiJub25wcm9kLTIwMjEzMzExMzMyIiwidHlwIjoiSldUIiwiYWxnIj'}
    Given method get
    Then match responseStatus == 204
    And match responseHeaders['Sbf-Jarvis-Reason'][0] == "NO_SCHL"

  @Unhappy
  Scenario Outline: Validate for Bad request
    Given def selectFairResponse = call read('classpath:common/bookfairs/jarvis/SelectionAndBasicInfo/RunnerHelper.feature@SelectFair'){RESOURCE_ID: <SBF_JARVIS_FAIR>}
    * replace getFinancialFormSalesUri.resourceId =  RESOURCE_ID
    * url BOOKFAIRS_JARVIS_URL + getFinancialFormSalesUri
    * cookies { SCHL : '#(selectFairResponse.SCHL)', SBF_JARVIS: '#(selectFairResponse.SBF_JARVIS)'}
    Given method put
    Then match responseStatus == 400

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | RESOURCE_ID | SBF_JARVIS_FAIR |
      | azhou1@scholastic.com | password1 | 5694296     | 5694309         |

  @Unhappy
  Scenario Outline: Validate when user doesn't have access to specific fair for user:<USER_NAME> and fair:<RESOURCE_ID>
    Given def getFinancialFormSalesResponse = call read('RunnerHelper.feature@GetFinancialFormSales')
    Then match getFinancialFormSalesResponse.responseStatus == 403
    And match getFinancialFormSalesResponse.responseHeaders['Sbf-Jarvis-Reason'][0] == "RESOURCE_ID_NOT_VALID"

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | RESOURCE_ID |
      | azhou1@scholastic.com | password1 | 5734325     |

  @Unhappy
  Scenario Outline: Validate when user uses an invalid fair ID for user:<USER_NAME> and fair:<RESOURCE_ID>
    Given def getFinancialFormSalesResponse = call read('RunnerHelper.feature@GetFinancialFormSales')
    Then match getFinancialFormSalesResponse.responseStatus == 404
    And match getFinancialFormSalesResponse.responseHeaders['Sbf-Jarvis-Reason'][0] == "MALFORMED_RESOURCE_ID"

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | RESOURCE_ID |
      | azhou1@scholastic.com | password1 | abc1234     |

  @Unhappy
  Scenario Outline: Validate when unsupported http method is called
    Given def selectFairResponse = call read('classpath:common/bookfairs/jarvis/SelectionAndBasicInfo/RunnerHelper.feature@SelectFair'){RESOURCE_ID: <SBF_JARVIS_FAIR>}
    * replace getFinancialFormSalesUri.resourceId =  RESOURCE_ID
    * url BOOKFAIRS_JARVIS_URL + getFinancialFormSalesUri
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
    Given def getFinancialFormSalesResponse = call read('RunnerHelper.feature@GetFinancialFormSales')
    Then match getFinancialFormSalesResponse.responseHeaders['Sbf-Jarvis-Resource-Id'][0] == EXPECTED_FAIR
    And if(RESOURCE_ID == 'current') karate.log(karate.match(getFinancialFormSalesResponse.responseHeaders['Sbf-Jarvis-Resource-Selection'][0], 'AUTOMATICALLY_SELECTED_THIS_REQUEST'))

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
    * replace getFinancialFormSalesUri.resourceId = RESOURCE_ID
    * url BOOKFAIRS_JARVIS_URL + getFinancialFormSalesUri
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
    * def BaseResponseMap = call read('RunnerHelper.feature@GetFinancialFormSalesBase')
    * def TargetResponseMap = call read('RunnerHelper.feature@GetFinancialFormSales')
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
  Scenario Outline: Validate with database for user <USER_NAME>, fair:<RESOURCE_ID>
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
    Given def getFinancialFormSalesResponse = call read('RunnerHelper.feature@GetFinancialFormSales')
    Then match getFinancialFormSalesResponse.responseStatus == 200
    Then def mongoJson = call read('classpath:common/bookfairs/bftoolkit/MongoDBRunner.feature@FindDocumentByField') {collection:"financials", field:"_id", value:"#(RESOURCE_ID)"}
    * convertNumberDecimal(mongoJson.document)
    * print mongoJson.document
    And def currentDocument = mongoJson.document
    And match currentDocument.sales.scholasticDollars.totalRedeemed == getFinancialFormSalesResponse.response.scholasticDollars.totalRedeemed
    And match currentDocument.sales.scholasticDollars.taxExemptSales == getFinancialFormSalesResponse.response.scholasticDollars.taxExemptSales
    And match currentDocument.sales.scholasticDollars.taxCollected == getFinancialFormSalesResponse.response.scholasticDollars.taxCollected
    And match currentDocument.sales.tenderTotals.cashAndChecks == getFinancialFormSalesResponse.response.tenderTotals.cashAndChecks
    And match currentDocument.sales.tenderTotals.creditCards == getFinancialFormSalesResponse.response.tenderTotals.creditCards
    And match currentDocument.sales.tenderTotals.purchaseOrders == getFinancialFormSalesResponse.response.tenderTotals.purchaseOrders
    And match currentDocument.sales.grossSales.taxExemptSales == getFinancialFormSalesResponse.response.grossSales.taxExemptSales
    And match currentDocument.sales.grossSales.taxableSales == getFinancialFormSalesResponse.response.grossSales.taxableSales
#    And match currentDocument.sales.grossSales.total == getFinancialFormSalesResponse.response.grossSales.total
#    And match currentDocument.sales.grossSales.taxTotal == getFinancialFormSalesResponse.response.grossSales.taxTotal
    And match currentDocument.sales.netSales.shareTheFairFunds.collected == getFinancialFormSalesResponse.response.netSales.shareTheFairFunds.collected
    And match currentDocument.sales.netSales.shareTheFairFunds.redeemed == getFinancialFormSalesResponse.response.netSales.shareTheFairFunds.redeemed
    Then def mongoJson = call read('classpath:common/bookfairs/bftoolkit/MongoDBRunner.feature@FindDocumentByField') {collection:"bookFairDataLoad", field:"fairId", value:"#(RESOURCE_ID)"}
    * convertNumberDecimal(mongoJson.document)
    And def currentDocument = mongoJson.document
    * def taxRate = (currentDocument.taxDetailTaxRate)/1000
    And match taxRate == getFinancialFormSalesResponse.response.taxRate

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | RESOURCE_ID |
      | azhou1@scholastic.com | password1 | 5694296     |
