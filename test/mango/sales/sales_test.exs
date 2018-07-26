defmodule Mango.SalesTest do
  use Mango.DataCase

  alias Mango.Sales
  alias Mango.Sales.Order
  alias Mango.Catalog.Product
  alias Mango.CRM

  test "create_cart" do
    assert %Order{status: "In Cart"} = Sales.create_cart
  end

  test "get_cart/1" do
    cart = Sales.create_cart
    retrieved_cart = Sales.get_cart(cart.id)

    assert cart.id == retrieved_cart.id
  end

  test "add_to_cart/2" do
    product = %Product{
      name: "Tomato",
      pack_size: "1 kg",
      price: 55,
      sku: "A123",
      is_seasonal: false,
      category: "vegetables"
    }
    |> Repo.insert!

    cart = Sales.create_cart
    {:ok, cart} = Sales.add_to_cart(cart, %{"product_id" => product.id, "quantity" => "2"})

    assert [line_item] = cart.line_items
    assert line_item.product_id == product.id
    assert line_item.product_name == "Tomato"
    assert line_item.pack_size == "1 kg"
    assert line_item.quantity == 2
    assert line_item.unit_price == Decimal.new(product.price)
    assert line_item.total == Decimal.mult(Decimal.new(product.price), Decimal.new(2))
  end

  test "get_customer_orders/1" do
    valid_attrs = %{
      "name" => "Ford",
      "email" => "fordp@betelgeuse.com",
      "password" => "theansweris42",
      "residence_area" => "Betelgeuse",
      "phone" => "424242"
    }

    {:ok, ford} = CRM.create_customer(valid_attrs)

    order = %Order{
      status: "Confirmed",
      total: 25.00,
      comments: "Stock up",
      customer_id: ford.id,
      customer_name: ford.name,
      email: ford.email,
      residence_area: ford.residence_area
    }
    |> Repo.insert!

    arthur_attrs = %{
      "name" => "Arthur",
      "email" => "arthur@milliways.com",
      "password" => "theansweris42",
      "residence_area" => "Earth",
      "phone" => "1010101"
    }

    {:ok, arthur} = CRM.create_customer(arthur_attrs)

    arthur_order = %Order{
      status: "Delivered",
      total: 60.00,
      comments: "Pantry",
      customer_id: arthur.id,
      customer_name: arthur.name,
      email: arthur.email,
      residence_area: arthur.residence_area
    }
    |> Repo.insert!

    retrieved_customer_orders = Sales.get_customer_orders(ford)

    assert [customer_order] = retrieved_customer_orders
    assert customer_order.id == order.id
    assert customer_order.status == order.status
    assert customer_order.total == Decimal.new(order.total)

    refute customer_order.status == arthur_order.status
  end

end