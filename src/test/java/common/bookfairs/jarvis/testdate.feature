#Author: Ravindra Pallerla

@ignore
Feature: date function testing

  Background: Set config

  Scenario: Validate http response code 204
    * def getDate =
      """
      function() {
      
      var SimpleDateFormat = Java.type('java.text.SimpleDateFormat');
      var sdf = new SimpleDateFormat('yyyy-MM-dd');
      var date = new java.util.Date();
      return sdf.format(date);
      }
      """
    * def currentDate = getDate()
    And print currentDate
