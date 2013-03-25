@admin
Feature: Admin change state of postal order
  Background:
    Given "Pictures" category with "Lilac" product
    And order for delivery of "Lilac" product
    When admin is signed in

  Scenario: Admin changes postal order state to delivery
    Given admin on order edit page
    And admin should see confirmed postal order state
    When admin clicks confirmed postal order
    Then order state is processing
    And customer receive an postal order process email

  Scenario: Admin changes postal order state to complete
    Given order state is set to processing
    And admin on order edit page
    When admin clicks processing postal order
    Then order state is completed
    And customer receive an postal order complete email

  Scenario: Admin cancels postal order
    Given admin on order edit page
    When admin clicks canceled postal order
    Then order state is canceled
    And customer receive an postal order cancel email
    And "Lilac" product is not archived
