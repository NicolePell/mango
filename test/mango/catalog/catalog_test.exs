defmodule Mango.CatalogTest do
  use Mango.DataCase

  alias Mango.{Catalog, Repo}
  alias Mango.Catalog.Product

  setup do
    Repo.insert %Product{ name: "Tomato", price: 0.65, sku: "A123", is_seasonal: false, category: "vegetables" }
    Repo.insert %Product{ name: "Apple", price: 0.59, sku: "B456", is_seasonal: true, category: "fruits" }

    :ok
  end

  test "list_products/0 returns all products" do
    [product_one = %Product{}, product_two = %Product{}] = Catalog.list_products
    
    assert product_one.name == "Tomato"
    assert product_two.name == "Apple"
  end

  test "list_seasonal_products/0 returns all seasonal products" do
    [product_one = %Product{}] = Catalog.list_seasonal_products
    
    assert product_one.name == "Apple"
  end

  test "get_category_products/1 returns products of a given category" do
    [product = %Product{}] = Catalog.get_category_products("fruits")
    
    assert product.name == "Apple"
  end

end