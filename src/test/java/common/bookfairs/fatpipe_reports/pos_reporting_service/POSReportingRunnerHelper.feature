@ignore @report=true
Feature:Helper for running POS fatpipe reporting apis

  Background: Set config
    * string getFatpipeReportsUri = "/api/v1/fairs"
    * string getOrphansTransactionByTransactionId = "/api/v1/transactions"

    #Input: FAIR_ID, source[ALL/POS/PP], includeNetzero, perRegister, tenderAuthStatusGroup, tenderStatusGroup, transactionStatusGroup
    #Output: response
  @GetFatpipeTenderSummaryReportRunner
  Scenario:Run GetTenderSummaryReport API
    Given url BOOKFAIRS_FATPIPE_REPORTS_URL + getFatpipeReportsUri
    And headers {Content-Type : 'application/json'}
    And def pathParams = {bookFairId : '#(FAIR_ID)'}
    And path pathParams.bookFairId + '/pos/tenders/summary'
    And params {source : '#(source)', includeNetzero : 'false',includeNetzero : 'false',perRegister:'false',tenderAuthStatusGroup:'REGISTER', tenderStatusGroup:'REGISTER',transactionStatusGroup:'REGISTER'}
    And method GET

    #Input: FAIR_ID, source[ALL/POS/PP], includeNetzero, perRegister, tenderAuthStatusGroup, tenderStatusGroup, transactionStatusGroup
    #Output: response
  @GetFatpipeTenderSummaryReportBase
  Scenario:Run GetTenderSummaryReport API
    Given url BOOKFAIRS_FATPIPE_REPORTS_BASE + getFatpipeReportsUri
    And headers {Content-Type : 'application/json'}
    And def pathParams = {bookFairId : '#(FAIR_ID)'}
    And path pathParams.bookFairId + '/pos/tenders/summary'
    And params {source : '#(source)', includeNetzero : 'false',includeNetzero : 'false',perRegister:'false',tenderAuthStatusGroup:'REGISTER', tenderStatusGroup:'REGISTER',transactionStatusGroup:'REGISTER'}
    And method GET

    #Input: FAIR_ID, source[ALL/POS/PP], perRegister, transactionStatusGroup
    #Output: response
  @GetFatpipeSalesSummaryReportRunner
  Scenario:Run GetSalesSummaryReport API
    Given url BOOKFAIRS_FATPIPE_REPORTS_URL + getFatpipeReportsUri
    And headers {Content-Type : 'application/json'}
    And def pathParams = {bookFairId : '#(FAIR_ID)'}
    And path pathParams.bookFairId + '/pos/sales/summary'
    And params {source : '#(source)', perRegister : 'false', transactionStatusGroup : 'REGISTER'}
    And method GET

    #Input: FAIR_ID, source[ALL/POS/PP], perRegister, transactionStatusGroup
    #Output: response
  @GetFatpipeSalesSummaryReportBase
  Scenario:Run GetSalesSummaryReport API
    Given url BOOKFAIRS_FATPIPE_REPORTS_BASE + getFatpipeReportsUri
    And headers {Content-Type : 'application/json'}
    And def pathParams = {bookFairId : '#(FAIR_ID)'}
    And path pathParams.bookFairId + '/pos/sales/summary'
    And params {source : '#(source)', perRegister : 'false', transactionStatusGroup : 'REGISTER'}
    And method GET

    #Input: FAIR_ID, perRegister, transactionStatusGroup
    #Output: response
  @GetFatpipeDiscountSummaryReportRunner
  Scenario:Run GetDiscountSummaryReport API
    Given url BOOKFAIRS_FATPIPE_REPORTS_URL + getFatpipeReportsUri
    And headers {Content-Type : 'application/json'}
    And def pathParams = {bookFairId : '#(FAIR_ID)'}
    And path pathParams.bookFairId + '/pos/discounts/summary'
    And params {perRegister : 'false', transactionStatusGroup : 'REGISTER'}
    And method GET

     #Input: FAIR_ID, perRegister, transactionStatusGroup
    #Output: response
  @GetFatpipeDiscountSummaryReportBase
  Scenario:Run GetDiscountSummaryReport API
    Given url BOOKFAIRS_FATPIPE_REPORTS_BASE + getFatpipeReportsUri
    And headers {Content-Type : 'application/json'}
    And def pathParams = {bookFairId : '#(FAIR_ID)'}
    And path pathParams.bookFairId + '/pos/discounts/summary'
    And params {perRegister : 'false', transactionStatusGroup : 'REGISTER'}
    And method GET

    #Input: FAIR_ID,itemIdentityMode,transactionStatusGroup,rollupGroupingCode,size,transactionMode
    #Output: response
  @GetFatpipeItemsItemizedReportRunner
  Scenario:Run GetItemsItemizedReport API
    Given url BOOKFAIRS_FATPIPE_REPORTS_URL + getFatpipeReportsUri
    And headers {Content-Type : 'application/json'}
    And def pathParams = {bookFairId : '#(FAIR_ID)'}
    And path pathParams.bookFairId + '/pos/items/itemized'
    And params {itemIdentityMode: 'PRODUCT', page: 0, rollupGroupingCode: 'ITEM', size: 100, transactionMode: 'SALE',transactionStatusGroup : 'REGISTER'}
    And method GET

    #Input: FAIR_ID,itemIdentityMode,transactionStatusGroup,rollupGroupingCode,size,transactionMode
    #Output: response
  @GetFatpipeItemsItemizedReportBase
  Scenario:Run GetItemsItemizedReport API
    Given url BOOKFAIRS_FATPIPE_REPORTS_BASE + getFatpipeReportsUri
    And headers {Content-Type : 'application/json'}
    And def pathParams = {bookFairId : '#(FAIR_ID)'}
    And path pathParams.bookFairId + '/pos/items/itemized'
    And params {itemIdentityMode: 'PRODUCT', page: 0, rollupGroupingCode: 'ITEM', size: 100, transactionMode: 'SALE',transactionStatusGroup : 'REGISTER'}
    And method GET

    #Input: FAIR_ID,transactionStatusGroup,amountType,perRegister,boardSize,metricCode
    #Output: response
  @GetFatpipeItemsLeaderboardReportRunner
  Scenario:Run GetItemsItemizedReport API
    Given url BOOKFAIRS_FATPIPE_REPORTS_URL + getFatpipeReportsUri
    And headers {Content-Type : 'application/json'}
    And def pathParams = {bookFairId : '#(FAIR_ID)'}
    And path pathParams.bookFairId + '/pos/items/leaderboard'
    And params {amountType:'NON_DISCOUNTED',perRegister : 'false',transactionStatusGroup : 'REGISTER', boardSize:10,metricCode:'CNT'}
    And method GET

    #Input: FAIR_ID,transactionStatusGroup,amountType,perRegister,boardSize,metricCode
    #Output: response
  @GetFatpipeItemsLeaderboardReportBase
  Scenario:Run GetItemsItemizedReport API
    Given url BOOKFAIRS_FATPIPE_REPORTS_BASE + getFatpipeReportsUri
    And headers {Content-Type : 'application/json'}
    And def pathParams = {bookFairId : '#(FAIR_ID)'}
    And path pathParams.bookFairId + '/pos/items/leaderboard'
    And params {amountType:'NON_DISCOUNTED',perRegister : 'false',transactionStatusGroup : 'REGISTER', boardSize:10,metricCode:'CNT'}
    And method GET

    #Input: FAIR_ID,transactionStatusGroup,perRegister,typeCode
    #Output: response
  @GetFatpipeItemsSummaryReportRunner
  Scenario:Run GetItemsSummaryReport API
    Given url BOOKFAIRS_FATPIPE_REPORTS_URL + getFatpipeReportsUri
    And headers {Content-Type : 'application/json'}
    And def pathParams = {bookFairId : '#(FAIR_ID)'}
    And path pathParams.bookFairId + '/pos/items/summary'
    And params {perRegister : 'false',transactionStatusGroup : 'REGISTER',typeCode : 'BOOK'}
    And method GET

    #Input: FAIR_ID,transactionStatusGroup,perRegister,typeCode
    #Output: response
  @GetFatpipeItemsSummaryReportBase
  Scenario:Run GetItemsSummaryReport API
    Given url BOOKFAIRS_FATPIPE_REPORTS_BASE + getFatpipeReportsUri
    And headers {Content-Type : 'application/json'}
    And def pathParams = {bookFairId : '#(FAIR_ID)'}
    And path pathParams.bookFairId + '/pos/items/summary'
    And params {perRegister : 'false',transactionStatusGroup : 'REGISTER',typeCode : 'BOOK'}
    And method GET

    #Input: FAIR_ID,orphanStatus
    #Output: response
  @GetFatpipeOrphansTransactionReportRunner
  Scenario:Run GetOrphanTransactionReport API
    Given url BOOKFAIRS_FATPIPE_REPORTS_URL + getFatpipeReportsUri
    And headers {Content-Type : 'application/json'}
    And def pathParams = {bookFairId : '#(FAIR_ID)'}
    And path pathParams.bookFairId + '/pos/orphans'
    And params {orphanStatus : 'true'}
    And method GET

    #Input: FAIR_ID,orphanStatus
    #Output: response
  @GetFatpipeOrphansTransactionReportBase
  Scenario:Run GetOrphanTransactionReport API
    Given url BOOKFAIRS_FATPIPE_REPORTS_BASE + getFatpipeReportsUri
    And headers {Content-Type : 'application/json'}
    And def pathParams = {bookFairId : '#(FAIR_ID)'}
    And path pathParams.bookFairId + '/pos/orphans'
    And params {orphanStatus : 'true'}
    And method GET

    #Input: FAIR_ID,connectivityFilter,includeNetzero,perRegister
    #Output: response
  @GetFatpipePOSstatusReportRunner
  Scenario:Run GetPOSstatusReport API
    Given url BOOKFAIRS_FATPIPE_REPORTS_URL + getFatpipeReportsUri
    And headers {Content-Type : 'application/json'}
    And def pathParams = {bookFairId : '#(FAIR_ID)'}
    And path pathParams.bookFairId + '/pos/status'
    And params {connectivityFilter : 'REGISTER', includeNetzero:'false', perRegister:'false'}
    And method GET

    #Input: FAIR_ID,connectivityFilter,includeNetzero,perRegister
    #Output: response
  @GetFatpipePOSstatusReportBase
  Scenario:Run GetPOSstatusReport API
    Given url BOOKFAIRS_FATPIPE_REPORTS_BASE + getFatpipeReportsUri
    And headers {Content-Type : 'application/json'}
    And def pathParams = {bookFairId : '#(FAIR_ID)'}
    And path pathParams.bookFairId + '/pos/status'
    And params {connectivityFilter : 'REGISTER', includeNetzero:'false', perRegister:'false'}
    And method GET

     #Input: FAIR_ID,page,size,tenderAuthStatusGroup,tenderStatusGroup,transactionStatusGroup,typeCode
     #Output: response
  @GetFatpipeTendersItemizedReportRunner
  Scenario:Run GetTendersItemizedReport API
    Given url BOOKFAIRS_FATPIPE_REPORTS_URL + getFatpipeReportsUri
    And headers {Content-Type : 'application/json'}
    And def pathParams = {bookFairId : '#(FAIR_ID)'}
    And path pathParams.bookFairId + '/pos/tenders/itemized'
    And params {tenderAuthStatusGroup:'REGISTER',tenderStatusGroup:'REGISTER',transactionStatusGroup:'REGISTER',page:0,size:100}
    And method GET

    #Input: FAIR_ID,page,size,tenderAuthStatusGroup,tenderStatusGroup,transactionStatusGroup,typeCode
     #Output: response
  @GetFatpipeTendersItemizedReportBase
  Scenario:Run GetTendersItemizedReport API
    Given url BOOKFAIRS_FATPIPE_REPORTS_BASE + getFatpipeReportsUri
    And headers {Content-Type : 'application/json'}
    And def pathParams = {bookFairId : '#(FAIR_ID)'}
    And path pathParams.bookFairId + '/pos/tenders/itemized'
    And params {tenderAuthStatusGroup:'REGISTER',tenderStatusGroup:'REGISTER',transactionStatusGroup:'REGISTER',page:0,size:100}
    And method GET

    #Input: transactionId
     #Output: response
  @GetFatpipeOrphansTransactionByTransactionIdReportRunner
  Scenario:Run GetOrphansTransactionByTransactionIdReport API
    Given url BOOKFAIRS_FATPIPE_REPORTS_URL + getOrphansTransactionByTransactionId
    And headers {Content-Type : 'application/json'}
    And def pathParams = {transactionId : '#(TRANSACTION_ID)'}
    And path pathParams.transactionId + '/pos/orphans'
    And method GET

   #Input: transactionId
     #Output: response
  @GetFatpipeOrphansTransactionByTransactionIdReportBase
  Scenario:Run GetOrphansTransactionByTransactionIdReport API
    Given url BOOKFAIRS_FATPIPE_REPORTS_BASE + getOrphansTransactionByTransactionId
    And headers {Content-Type : 'application/json'}
    And def pathParams = {transactionId : '#(TRANSACTION_ID)'}
    And path pathParams.transactionId + '/pos/orphans'
    And method GET
