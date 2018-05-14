defmodule MangoWeb.CategoryPageTest do
  use ExUnit.Case
  use Hound.Helpers

  hound_session()

  setup do
    ### GIVEN ### 
    # There are two products Apple and Tomato priced 100 and 50
    # categorized under `fruits` and `vegetables` respsectively
    :ok 
  end

  test "show fruits" do
    ### WHEN ### 
    # I navigate to the fruits page
    navigate_to("/categories/fruits")

    ## THEN ##
    # I expect the page title to be "Fruits"
    page_title = find_element(:css, ".page-title")
    |> visible_text()

    assert page_title == "Fruits"

    ### AND ###
    # I expect Apple in the product displayed
    product = find_element(:css, ".product")
    product_name = find_within_element(product, :css, ".product-name")
    |> visible_text()
    product_price = find_within_element(product, :css, ".product-price")
    |> visible_text()

    assert product_name == "Apple"
    ### AND ###
    # I expect it's price to be displayed on screen.
    assert product_price == "100"

    ### AND ###
    # I expect that Tomato is not present on screen.
    refute page_source() =~ "Tomato"
  end

  test "show vegetables" do
    ### WHEN ### 
    # I navigate to the vegetables page
    navigate_to("/categories/vegetables")

    ## THEN ##
    # I expect the page title to be "Vegetables"
    page_title = find_element(:css, ".page-title")
    |> visible_text()

    assert page_title == "Vegetables"

    ### AND ###
    # I expect Tomato in the product displayed
    product = find_element(:css, ".product")
    product_name = find_within_element(product, :css, ".product-name")
    |> visible_text()
    product_price = find_within_element(product, :css, ".product-price")
    |> visible_text()

    assert product_name == "Tomato"
    ### AND ###
    # I expect it's price to be displayed on screen.
    assert product_price == "50"

    ### AND ###
    # I expect that Tomato is not present on screen.
    refute page_source() =~ "Apple"
  end

end