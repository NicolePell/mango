defmodule Mango.CatalogTest do
  use ExUnit.Case

  alias Mango.Catalog
  alias Mango.Catalog.Product

  test "list_products/0 returns all products" do
    [product_one = %Product{}, product_two = %Product{}] = Catalog.list_products
    
    assert product_one.name == "Tomato"
    assert product_two.name == "Apple"
  end

  test "list_seasonal_products/0 returns all seasonal products" do
    [product_one = %Product{}] = Catalog.list_seasonal_products
    
    assert product_one.name == "Apple"
  end

end