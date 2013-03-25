@user
Feature: User works with postal orders
  Background:
    Given "Pictures" category with "Lilac" product
    And user on welcome page
    Given user follows "Pictures"
    When user clicks to checkout "Lilac" product
    And goes to cart

  Scenario: User orders a product
    Given user should see "Lilac" product
    When user clicks to checkout ordered products
    And fill postal order form
    And clicks to submit
    Then user should see thanks for order message
    And user receive an postal order checkout email
    And admin receive an postal order admin email
    Given "Lilac" product is archived

  Scenario: User can't checkout an archived product
    Given "Lilac" product state is set to archived
    When user clicks to checkout ordered products
    Then user should see no stored products message

  Scenario: User can't order an archived product
    When user clicks to checkout ordered products
    And "Lilac" product state is set to archived
    And user fill postal order form
    And clicks to submit
    Then user should see postal orders products have changed message
