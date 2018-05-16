defmodule MangoWeb.HomepageTest do
  use Mango.DataCase
  use Hound.Helpers

  hound_session()

  setup do
    alias Mango.Repo
    alias Mango.Catalog.Product

    Repo.insert %Product{ name: "Tomato", price: 0.65, sku: "A123", is_seasonal: false, category: "vegetables" }
    Repo.insert %Product{ name: "Apple", price: 0.25, sku: "B456", is_seasonal: true, category: "fruits" }

    :ok 
  end

  test "presence of featured products" do
    navigate_to("/")

    page_title = find_element(:css, ".page-title")
    |> visible_text
    assert page_title == "Seasonal products"

    product = find_element(:css, ".product")
    product_name = find_within_element(product, :css, ".product-name")
    |> visible_text
    product_price = find_within_element(product, :css, ".product-price")
    |> visible_text

    assert product_name == "Apple"
    assert product_price == "£ 0.25"

    refute page_source() =~ "Tomato"
  end

end