Feature: Legacy Controller api tests for general health

  Scenario Outline: Verify all scenarios return a happy response code
    * json apiParamsAsJson = apiParams
    Given call read('RunnerHelper.feature@' + api) apiParamsAsJson
    Then match responseStatus == EXPECTED_CODE * 1

    @QA
    Examples:
      | api                          | EXPECTED_CODE | apiParams                                                                                                                                                      |
      | GetWalletByVoucherParameters | 200           | {type:'string',key:'string', attribute:{fairid:'string',grade:'grade'},transactions:'true',showTransactions:'true',status:'string',showNonLegacyFields:'true'} |
#      | RetryFundingWallet           | 200           | {}                                                                                                                                                             |

#Feature: Legacy Controller api tests for general health
#
#  Scenario Outline: Verify all scenarios return a happy response code
#    Given call read('RunnerHelper.feature@' + api)
#    Then match [200, 204] contains only responseStatus
#
#    Examples:
#      | api                           | VOUCHERID | TRANSACTIONID | REQUEST_BODY                                                       | QUERY_PARAMS                                                                                                                                                   |
#      | GetWalletByVoucherParameters  |           |               |                                                                    | {type:'string',key:'string', attribute:{fairid:'string',grade:'grade'},transactions:'true',showTransactions:'true',status:'string',showNonLegacyFields:'true'} |
#      | CreateVoucher                 |           |               |                                                                    | {type:'string',key:'string', attribute:{fairid:'string'},showNonLegacyFields:'string'}                                                                         |
#      | CreateVoucherTransactions     | 123456    |               | {type: 'INITIAL_AUTH', amount: 1, timestamp:'',reference:'string'} |                                                                                                                                                                |
#      | GetWalletsByCustomerId        |           |               |                                                                    | {customerProfileId: 'string'}                                                                                                                                  |
#      | GetVoucherByVoucherId         | 123456    |               |                                                                    |                                                                                                                                                                |
#      | GetTransactionByTransactionId |           | 123456        |                                                                    |                                                                                                                                                                |