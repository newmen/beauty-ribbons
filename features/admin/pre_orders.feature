@admin
Feature: Admin change state of pre order
  Background:
    Given "Pictures" category with "Lilac" archived product
    And order to manufacture of "Lilac" product
    When admin is signed in

  Scenario: Admin changes pre order state to manufacturing
    Given admin on order edit page
    And admin should see confirmed pre order state
    When admin clicks confirmed pre order
    Then order state is processing

  Scenario: Admin changes pre order state to complete
    Given order state is set to processing
    And admin on order edit page
    When admin clicks processing pre order
    Then order state is completed
    And customer receive an pre order complete email

  Scenario: Admin cancels pre order
    Given admin on order edit page
    When admin clicks canceled pre order
    Then order state is canceled
    And customer receive an pre order cancel email
