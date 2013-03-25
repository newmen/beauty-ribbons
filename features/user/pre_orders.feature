@user
Feature: User works with pre order
  Background:
    Given "Pictures" category with "Lilac" archived product
    And user on welcome page
    Given user follows archive
    When user clicks to checkout "Lilac" product
    And goes to cart

  Scenario: User pre order a product
    Given user should see "Lilac" product
    When user clicks to checkout desired products
    And fill pre order form
    And clicks to submit
    Then user should see thanks for order message
    And user receive an pre order checkout email
    And admin receive an pre order admin email

  Scenario: User can't checkout an unarchived product
    Given "Lilac" product state is set to unarchived
    When user clicks to checkout desired products
    Then user should see no stored products message

  Scenario: User can't pre order an unarchived product
    When user clicks to checkout desired products
    And "Lilac" product state is set to unarchived
    And user fill pre order form
    And clicks to submit
    Then user should see pre orders products have changed message
