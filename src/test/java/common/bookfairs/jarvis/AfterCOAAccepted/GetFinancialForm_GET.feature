@GetFinancialForm @PerformanceEnhancement @4bfinfrom
Feature: GetFinancialForm GET Api tests

  Background: Set config
    * def obj = Java.type('utils.StrictValidation')
    * def getFinancialFormUri = "/bookfairs-jarvis/api/user/fairs/<resourceId>/financials/form"
    * def invalidGetFinFormUri = "/bookfairs-jarvis/api/user/fairs/<resourceId>/financial/forms"

  @Happy
  Scenario Outline: Validating with valid fairId and user credentials for user:<USER_NAME> and fair:<RESOURCE_ID>
    Given def getFinancialFormResponse = call read('RunnerHelper.feature@GetFinancialForm')
    Then match getFinancialFormResponse.responseStatus == 200

    @QA
    Examples:
      | USER_NAME              | PASSWORD  | RESOURCE_ID |
      | mtodaro@scholastic.com | passw0rd  | 5694318     |
      | mtodaro@scholastic.com | passw0rd  | current     |
      | azhou1@scholastic.com  | password2 | 5694296     |

  @Unhappy
  Scenario Outline: Validate when user doesn't have access to CPTK for user:<USER_NAME> and fair:<RESOURCE_ID>
    Given def getFinancialFormResponse = call read('RunnerHelper.feature@GetFinancialForm')
    Then match getFinancialFormResponse.responseStatus == 204
    And match getFinancialFormResponse.responseHeaders['Sbf-Jarvis-Reason'][0] == "NO_ASSOCIATED_RESOURCES"

    @QA
    Examples:
      | USER_NAME           | PASSWORD  | RESOURCE_ID |
      | nofairs@testing.com | password1 | current     |

  @Unhappy
  Scenario Outline: Validate when user attempts to access a non-COA Accepted fair:<USER_NAME> and fair:<RESOURCE_ID>
    Given def getFinancialFormResponse = call read('RunnerHelper.feature@GetFinancialForm')
    Then match getFinancialFormResponse.responseStatus == 204
    And match getFinancialFormResponse.responseHeaders['Sbf-Jarvis-Reason'][0] == "NEEDS_COA_CONFIRMATION"

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | RESOURCE_ID |
      | azhou1@scholastic.com | password2 | 5694300     |

  @Unhappy
  Scenario Outline: Validate when SCHL cookie is not passed for fair:<RESOURCE_ID>
    * replace getFinancialFormUri.resourceId =  RESOURCE_ID
    * url BOOKFAIRS_JARVIS_URL + getFinancialFormUri
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
    * replace getFinancialFormUri.resourceId =  "current"
    * url BOOKFAIRS_JARVIS_URL + getFinancialFormUri
    * cookies { SCHL : 'eyJraWQiOiJub25wcm9kLTIwMjEzMzExMzMyIiwidHlwIjoiSldUIiwiYWxnIj'}
    Given method get
    Then match responseStatus == 204
    And match responseHeaders['Sbf-Jarvis-Reason'][0] == "NO_SCHL"

  @Unhappy
  Scenario Outline: Validate for internal server error
    Given def selectFairResponse = call read('classpath:common/bookfairs/jarvis/SelectionAndBasicInfo/RunnerHelper.feature@SelectFair'){RESOURCE_ID: <SBF_JARVIS_FAIR>}
    * replace invalidGetFinFormUri.resourceId =  RESOURCE_ID
    * url BOOKFAIRS_JARVIS_URL + invalidGetFinFormUri
    * cookies { SCHL : '#(selectFairResponse.SCHL)', SBF_JARVIS: '#(selectFairResponse.SBF_JARVIS)'}
    Given method get
    Then match responseStatus == 500

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | RESOURCE_ID | SBF_JARVIS_FAIR |
      | azhou1@scholastic.com | password2 | 5694296     | 5694309         |

  @Unhappy
  Scenario Outline: Validate when user doesn't have access to specific fair for user:<USER_NAME> and fair:<RESOURCE_ID>
    Given def getFinancialFormResponse = call read('RunnerHelper.feature@GetFinancialForm')
    Then match getFinancialFormResponse.responseStatus == 403
    And match getFinancialFormResponse.responseHeaders['Sbf-Jarvis-Reason'][0] == "RESOURCE_ID_NOT_VALID"

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | RESOURCE_ID |
      | azhou1@scholastic.com | password2 | 5734325     |

  @Unhappy
  Scenario Outline: Validate when user uses an invalid fair ID for user:<USER_NAME> and fair:<RESOURCE_ID>
    Given def getFinancialFormResponse = call read('RunnerHelper.feature@GetFinancialForm')
    Then match getFinancialFormResponse.responseStatus == 404
    And match getFinancialFormResponse.responseHeaders['Sbf-Jarvis-Reason'][0] == "MALFORMED_RESOURCE_ID"

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | RESOURCE_ID |
      | azhou1@scholastic.com | password2 | abc1234     |

  @Unhappy
  Scenario Outline: Validate when unsupported http method is called
    Given def selectFairResponse = call read('classpath:common/bookfairs/jarvis/SelectionAndBasicInfo/RunnerHelper.feature@SelectFair'){RESOURCE_ID: <SBF_JARVIS_FAIR>}
    * replace getFinancialFormUri.resourceId =  RESOURCE_ID
    * url BOOKFAIRS_JARVIS_URL + getFinancialFormUri
    * cookies { SCHL : '#(selectFairResponse.SCHL)', SBF_JARVIS: '#(selectFairResponse.SBF_JARVIS)'}
    Given method patch
    Then match responseStatus == 405
    Then match response.error == "Method Not Allowed"

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | RESOURCE_ID | SBF_JARVIS_FAIR |
      | azhou1@scholastic.com | password2 | 5694296     | 5694309         |

  @Happy
  Scenario Outline: Validate when user inputs different configurations for fairId/current for CONFIRMED fairs:<USER_NAME>, fair:<RESOURCE_ID>, scenario:<SCENARIO>
    Given def getFinancialFormResponse = call read('RunnerHelper.feature@GetFinancialForm')
    Then match getFinancialFormResponse.responseHeaders['Sbf-Jarvis-Resource-Id'][0] == EXPECTED_FAIR
    And if(RESOURCE_ID == 'current') karate.log(karate.match(getFinancialFormResponse.responseHeaders['Sbf-Jarvis-Resource-Selection'][0], 'AUTOMATICALLY_SELECTED_THIS_REQUEST'))

    @QA
    Examples:
      | USER_NAME                                   | PASSWORD  | RESOURCE_ID | EXPECTED_FAIR | SCENARIO                                     |
      | azhou1@scholastic.com                       | password2 | 5694296     | 5694296       | Return path parameter fairId information     |
      | azhou1@scholastic.com                       | password2 | current     | 5694296       | Has current, upcoming, and past fairs        |
      | hasAllFairs@testing.com                     | password1 | current     | 5694301       | Has all fairs                                |
      | hasUpcomingAndPastFairs@testing.com         | password1 | current     | 5694305       | Has upcoming and past fairs                  |
      | hasPastFairs@testing.com                    | password1 | current     | 5694307       | Has past fairs                               |
      | hasRecentlyUpcomingAndPastFairs@testing.com | password1 | current     | 5694303       | Has recently ended, upcoming, and past fairs |

  @Happy
  Scenario Outline: Validate when user inputs different configurations for fairId/current WITH SBF_JARVIS for DO_NOT_SELECT mode with user:<USER_NAME>, fair:<RESOURCE_ID>, cookie fair:<SBF_JARVIS_FAIR>
    Given def selectFairResponse = call read('classpath:common/bookfairs/jarvis/SelectionAndBasicInfo/RunnerHelper.feature@SelectFair'){RESOURCE_ID: <SBF_JARVIS_FAIR>}
    * replace getFinancialFormUri.resourceId = RESOURCE_ID
    * url BOOKFAIRS_JARVIS_URL + getFinancialFormUri
    * cookies { SCHL : '#(selectFairResponse.SCHL)', SBF_JARVIS: '#(selectFairResponse.SBF_JARVIS)'}
    Then method get
    Then match responseHeaders['Sbf-Jarvis-Resource-Id'][0] == EXPECTED_FAIR
    And if(RESOURCE_ID == 'current') karate.log(karate.match(responseHeaders['Sbf-Jarvis-Resource-Selection'][0], 'PREVIOUSLY_SELECTED'))

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | RESOURCE_ID | EXPECTED_FAIR | SBF_JARVIS_FAIR |
      | azhou1@scholastic.com | password2 | 5694296     | 5694296       | 5694309         |
      | azhou1@scholastic.com | password2 | current     | 5694296       | 5694296         |

  @Regression @ignore
  Scenario Outline: Validate regression using dynamic comparison || fairId=<RESOURCE_ID>
    * def BaseResponseMap = call read('RunnerHelper.feature@GetFinancialFormBase')
    * def TargetResponseMap = call read('RunnerHelper.feature@GetFinancialForm')
    * string base = BaseResponseMap.response
    * string target = TargetResponseMap.response
    * def compResult = obj.strictCompare(base, target)
    Then print "Response from production code base", BaseResponseMap.response
    Then print "Response from current qa code base", TargetResponseMap.response
    Then print 'Differences any...', compResult

    Examples:
      | USER_NAME             | PASSWORD  | RESOURCE_ID |
      | azhou1@scholastic.com | password2 | 5694296     |

  @Happy @ignore
  Scenario Outline: Validate invoice flow for user <USER_NAME>, fair:<RESOURCE_ID>
    Given def mongoQueryResponse = call read("classpath:common/bookfairs/bftoolkit/MongoDBRunner.feature@FindDocumentThenDeleteField"){collection:"financials",findField:"_id",findValue:"#(RESOURCE_ID)",deleteField:"confirmation"}
    Then def getFinancialFormResponse = call read('RunnerHelper.feature@GetFinancialForm')
    And match getFinancialFormResponse.response.status.type == "ready"
    And match getFinancialFormResponse.response.invoice == "#null"
    Then def submitFinFormResponse = call read('RunnerHelper.feature@SubmitFinForm')
    And match submitFinFormResponse.responseStatus == 200
    Then def getFinancialFormResponse = call read('RunnerHelper.feature@GetFinancialForm')
    And match getFinancialFormResponse.response.status.type == "confirmed"
    And match getFinancialFormResponse.response.invoice != "#null"
    * def mongoQueryResponse = call read("classpath:common/bookfairs/bftoolkit/MongoDBRunner.feature@FindDocumentByField"){collection:"financials",field:"_id",value:"#(RESOURCE_ID)"}
    * def createExpectedResponse =
    """
    function(mongoDoc) {
      let expectedResponse = {}
      expectedResponse.totalCollected = mongoDoc.sales.grossSales.total
      expectedResponse.digitalPaymentsCollected = mongoDoc.sales.tenderTotals.creditCards
      expectedResponse.purchaseOrders = mongoDoc.sales.tenderTotals.purchaseOrders
      expectedResponse.cashProfit = mongoDoc.fairEarning.cashProfitSelected + mongoDoc.sales.tenderTotals.cashAndChecks
      expectedResponse.amountDue = expectedResponse.totalCollected - (expectedResponse.digitalPaymentsCollected + expectedResponse.purchaseOrders + expectedResponse.cashProfit)
      return expectedResponse
    }
    """
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
    * convertNumberDecimal(mongoQueryResponse.document)
    * def expectedResponse = createExpectedResponse(mongoQueryResponse.document);
#    And match getFinancialFormResponse.response.invoice.number == "W"+"#(RESOURCE_ID)"+"BF"
    * match getFinancialFormResponse.response.invoice.amountDetails == expectedResponse

    @QA
    Examples:
      | USER_NAME              | PASSWORD | RESOURCE_ID |
      | mtodaro@scholastic.com | passw0rd | 5694324     |

  @Happy @Mongo
  Scenario Outline: Validate with database when invoice section is null and status is ready for user <USER_NAME>, fair:<RESOURCE_ID>
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
    Given def getFinancialFormResponse = call read('RunnerHelper.feature@GetFinancialForm')
    Then match getFinancialFormResponse.responseStatus == 200
    And match getFinancialFormResponse.response.status.type == "ready"
    And match getFinancialFormResponse.response.invoice == "#null"
    Then def mongoJson = call read('classpath:common/bookfairs/bftoolkit/MongoDBRunner.feature@FindDocumentByField') {collection:"financials", field:"_id", value:"#(RESOURCE_ID)"}
    * convertNumberDecimal(mongoJson.document)
    * print mongoJson.document
    And def currentDocument = mongoJson.document
    And match currentDocument.sales.scholasticDollars.totalRedeemed == getFinancialFormResponse.response.sales.scholasticDollars.totalRedeemed
    And match currentDocument.sales.scholasticDollars.taxExemptSales == getFinancialFormResponse.response.sales.scholasticDollars.taxExemptSales
    And match currentDocument.sales.scholasticDollars.taxCollected == getFinancialFormResponse.response.sales.scholasticDollars.taxCollected
    And match currentDocument.sales.tenderTotals.cashAndChecks == getFinancialFormResponse.response.sales.tenderTotals.cashAndChecks
    And match currentDocument.sales.tenderTotals.creditCards == getFinancialFormResponse.response.sales.tenderTotals.creditCards
    And match currentDocument.sales.tenderTotals.purchaseOrders == getFinancialFormResponse.response.sales.tenderTotals.purchaseOrders
    And match currentDocument.sales.grossSales.taxExemptSales == getFinancialFormResponse.response.sales.grossSales.taxExemptSales
    And match currentDocument.sales.grossSales.taxableSales == getFinancialFormResponse.response.sales.grossSales.taxableSales
    And match currentDocument.sales.grossSales.total == getFinancialFormResponse.response.sales.grossSales.total
    And match currentDocument.sales.grossSales.taxTotal == getFinancialFormResponse.response.sales.grossSales.taxTotal
    And match currentDocument.sales.netSales.shareTheFairFunds.collected == getFinancialFormResponse.response.sales.netSales.shareTheFairFunds.collected
    And match currentDocument.sales.netSales.shareTheFairFunds.redeemed == getFinancialFormResponse.response.sales.netSales.shareTheFairFunds.redeemed
    Then def mongoJson = call read('classpath:common/bookfairs/bftoolkit/MongoDBRunner.feature@FindDocumentByField') {collection:"bookFairDataLoad", field:"fairId", value:"#(RESOURCE_ID)"}
    * convertNumberDecimal(mongoJson.document)
    And def bookFairDataLoadDocument = mongoJson.document
    * def taxRate = (bookFairDataLoadDocument.taxDetailTaxRate)/1000
    And match taxRate == getFinancialFormResponse.response.sales.taxRate
    Then def mongoJson = call read('classpath:common/bookfairs/bftoolkit/MongoDBRunner.feature@FindDocumentByField') {collection:"financials", field:"_id", value:"#(RESOURCE_ID)"}
    * convertNumberDecimal(mongoJson.document)
    And string purchaseOrderDocument = mongoJson.document.purchaseOrders
    * print purchaseOrderDocument
    * string poResponse = getFinancialFormResponse.response.purchaseOrders.list
    * print poResponse
    * def compResult = obj.strictCompare(purchaseOrderDocument, poResponse)
    Then print 'Differences any...', compResult
    And match currentDocument.sales.scholasticDollars.totalRedeemed == (getFinancialFormResponse.response.spending.scholasticDollars.totalRedeemed)* -1
    Given def getCMDMResponse = call read('classpath:common/cmdm/fairs/CMDMRunnerHelper.feature@GetFairRunner')
    Then match getCMDMResponse.responseStatus == 200
    * print (Math.abs(getFinancialFormResponse.response.earnings.scholasticDollars.due))
    * def schoolId = (getCMDMResponse.response.organization.bookfairAccountId).replaceFirst('^0+', '')
    * print schoolId
    And def AGGREGATE_PIPELINE =
    """
    [
    {
    $match:{
    "schoolId":"#(schoolId)"
    }
    }
    ]
    """
    And def mongoResults = call read('classpath:common/bookfairs/bftoolkit/MongoDBRunner.feature@RunAggregate'){collectionName: "profitBalanceDataLoad"}
    * convertNumberDecimal(mongoResults.document)
    And def currentDocument = mongoResults.document
#    * def checkIfExistingBalIsNull =
#    """
#      function(response){
#      if (currentDocument == null){
#      return response.spending.scholasticDollars.existingBalance = 0
#      }
#      else if (currentDocument != null){
#      return response.spending.scholasticDollars.existingBalance
#    """
#    Given def getFinancialFormResponse = call read('RunnerHelper.feature@GetFinancialForm')
#    * eval checkIfExistingBalIsNull(getFinancialFormResponse.response)
#
#    * def existingBal = currentDocument.voucherAmount + currentDocument.bookProfit
#    * print existingBal
#    Then match existingBal = getFinancialFormResponse.response.spending.scholasticDollars.existingBalance
#    * def appliedBalance = if(existingBal == 0.0) ? 0.0 : existingBal - getFinancialFormResponse.response.spending.scholasticDollars.totalRedeemed
#    * def due = if(existingBal > totalRedeemed)? due = 0.0 : due = existingSDBal- totalRedeemed
    Then def mongoJson = call read('classpath:common/bookfairs/bftoolkit/MongoDBRunner.feature@FindDocumentByField') {collection:"financials", field:"_id", value:"#(RESOURCE_ID)"}
    * convertNumberDecimal(mongoJson.document)
    And def earningsDocument = mongoJson.document
    * print earningsDocument
    And match getFinancialFormResponse.response.earnings.sales == Math.round(((earningsDocument.sales.grossSales.taxExemptSales + earningsDocument.sales.grossSales.taxableSales) - (earningsDocument.sales.scholasticDollars.totalRedeemed - earningsDocument.sales.scholasticDollars.taxCollected)* 0.5)*100)/100
    * def checkDollarFairLevel =
    """
    function(response){
    if (response.earnings.sales >= 3500){
    if (response.earnings.dollarFairLevel != '50') {
          karate.log('Expected "50" dollar fair level for sales >= 3500');
          karate.fail('Dollar fair level does not match expected value');
        }
      }
    else if (response.earnings.sales >= 1500 && response.earnings.sales <= 3500) {
    if (response.earnings.dollarFairLevel != '40') {
          karate.log('Expected "40" dollar fair level for sales between 1500 and 3500');
          karate.fail('Dollar fair level does not match expected value');
        }
      }
    else {
        if (response.earnings.dollarFairLevel != '30') {
          karate.log('Expected "30" dollar fair level');
          karate.fail('Dollar fair level does not match expected value');
        }
      }
    }
    """
    Given def getFinancialFormResponse = call read('RunnerHelper.feature@GetFinancialForm')
    * eval checkDollarFairLevel(getFinancialFormResponse.response)
    And match getFinancialFormResponse.response.earnings.scholasticDollars.earned == Math.round(((getFinancialFormResponse.response.earnings.sales) * getFinancialFormResponse.response.earnings.dollarFairLevel/100)*100)/100
    And match getFinancialFormResponse.response.earnings.scholasticDollars.due == getFinancialFormResponse.response.spending.scholasticDollars.due
    And match getFinancialFormResponse.response.earnings.scholasticDollars.balance == getFinancialFormResponse.response.earnings.scholasticDollars.earned - (Math.abs(getFinancialFormResponse.response.earnings.scholasticDollars.due))
    And match getFinancialFormResponse.response.earnings.scholasticDollars.selected == earningsDocument.fairEarning.scholasticDollars.selected
    And match getFinancialFormResponse.response.earnings.scholasticDollars.max == getFinancialFormResponse.response.earnings.scholasticDollars.balance
    And match getFinancialFormResponse.response.earnings.cash.selected == earningsDocument.fairEarning.cash.selected
    * def cashMax =
    """
     function(response){
     if(response.earnings.scholasticDollars.selected > 0) {
     return (response.earnings.scholasticDollars.balance - response.earnings.scholasticDollars.selected)* 0.5;
     }
     else{
     return (response.earnings.scholasticDollars.balance)* 0.5;
     }
     }
    """
    Given def getFinancialFormResponse = call read('RunnerHelper.feature@GetFinancialForm')
    * eval cashMax(getFinancialFormResponse.response)
    * def cashMaxVal = cashMax(getFinancialFormResponse.response)
    And match getFinancialFormResponse.response.earnings.cash.max == cashMaxVal

    @QA
    Examples:
      | USER_NAME              | PASSWORD  | RESOURCE_ID | FAIR_ID |
      | azhou1@scholastic.com  | password2 | 5694296     | 5694296 |
      | mtodaro@scholastic.com | passw0rd  | 5694314     | 5694314 |
