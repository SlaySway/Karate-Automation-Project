Feature: Legacy Controller

  Scenario Outline: Verify all scenarios return a happy response code
    Given call read('RunnerHelper.feature@' + api)
    Then match [200, 204] contains only responseStatus

    Examples:
      | api                           | VOUCHERID | TRANSACTIONID | REQUEST_BODY                                                       | QUERY_PARAMS                                                                                                                                                   |
      | GetWalletByVoucherParameters  |           |               |                                                                    | {type:'string',key:'string', attribute:{fairid:'string',grade:'grade'},transactions:'true',showTransactions:'true',status:'string',showNonLegacyFields:'true'} |
      | CreateVoucher                 |           |               |                                                                    | {type:'string',key:'string', attribute:{fairid:'string'},showNonLegacyFields:'string'}                                                                         |
      | CreateVoucherTransactions     | 123456    |               | {type: 'INITIAL_AUTH', amount: 1, timestamp:'',reference:'string'} |                                                                                    |
      | GetWalletsByCustomerId        |           |               |                                                                    | {customerProfileId: 'string'}                                                                                                                                  |
      | GetVoucherByVoucherId         | 123456    |               |                                                                    |                                                                                                                                                                |
      | GetTransactionByTransactionId |           | 123456        |                                                                    |                                                                                                                                                                |