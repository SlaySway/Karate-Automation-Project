#Author: Ravindra Pallerla

@ignore
Feature: Helper feature for comparing both the target and base resopnses for each scenario

  @userCurrentFairsCompHelper
  Scenario: Run getFairs api
    * def BaseReq = call read('classpath:utils/RunnerHelper.feature@currentFairsBase'){USER_ID : '#(userId)', PWD : '#(pwd)', jsonInput : '#(inputBody)'}
    * def TargetReq = call read('classpath:utils/RunnerHelper.feature@currentFairsTarget'){USER_ID : '#(userId)', PWD : '#(pwd)', jsonInput : '#(inputBody)'}
    Then def BaseStatusCd = BaseReq.StatusCode
    Then string BaseResponse = BaseReq.ResponseString
    Then def TargetStatusCd = TargetReq.StatusCode
    Then string TargetResponse = TargetReq.ResponseString

  @FairsCurrentSettingsCompHelper
  Scenario: Run getFairs api
    * def BaseReq = call read('classpath:utils/RunnerHelper.feature@FairsCurrentSettingsBase'){USER_ID : '#(userId)', PWD : '#(pwd)', FAIRID : '#(fairId)'}
    * def TargetReq = call read('classpath:utils/RunnerHelper.feature@FairsCurrentSettingsTarget'){USER_ID : '#(userId)', PWD : '#(pwd)', FAIRID : '#(fairId)'}
    Then def BaseStatusCd = BaseReq.StatusCode
    Then string BaseResponse = BaseReq.ResponseString
    Then def TargetStatusCd = TargetReq.StatusCode
    Then string TargetResponse = TargetReq.ResponseString