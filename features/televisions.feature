Feature: Visitors to the Which? television landing page
  Are able to refine results of television review listings
  On different screen sizes


  Scenario: Visitor on large screen device refines list of televisions by screen size and brand
    Given I am a non member currently on the Which? television review listings page
    When I refine results by screen size to 27-39"
    Then results returned will only be of televisions between 27-39"
    When I select sort by Price (low to high)
    Then results are ordered by lowest to highest priced televisions
    When I refine results by brand to Sony
    Then results returned will only be of Sony televisions
    When I select the first television in results
    Then product summary page is displayed for the same television
    When I select the Review section
    Then as a non member I'm asked to subscribe to Which

  @small_screen
  Scenario Outline: Visitor on small screen device is able to refine list of televisions by screen size
    Given I am a non member currently on the Which? television review listings page
    When I select refine button
    And expands list of screen size options
    And I refine results by screen size to <size>
    And I select view button
    Then results returned will only be of televisions between <size>

  Examples:
    | size   |
    | 17-26" |
    | 27-39" |
    | 40-46" |
    | 47-55" |
    | 56"+   |

