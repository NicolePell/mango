defmodule MangoWeb.OrderHistoryTest do
  use Mango.DataCase
  use Hound.Helpers

  alias Mango.Catalog.Product
  alias Mango.CRM
  alias Mango.Repo
  alias Mango.Sales.Order

  hound_session()

  setup do
    valid_attrs = %{
      "name" => "Ford",
      "email" => "fordp@betelgeuse.com",
      "password" => "theansweris42",
      "residence_area" => "Betelgeuse",
      "phone" => "424242"
    }

    {:ok, ford} = CRM.create_customer(valid_attrs)

    product = %Product{
                name: "Tomato",
                pack_size: "1 kg",
                price: 55,
                sku: "A123",
                is_seasonal: false,
                category: "vegetables"
              }
              |> Repo.insert!

    %Order{
      status: "Confirmed",
      total: 25.00,
      comments: "Stock up",
      customer_id: ford.id,
      customer_name: ford.name,
      email: ford.email,
      residence_area: ford.residence_area,
      line_items: [%{
        product_id: product.id,
        product_name: product.name,
        pack_size: product.pack_size,
        unit_price: product.price,
        total: Decimal.mult(product.price, 2),
        quantity: 2
      }]
    }
    |> Repo.insert!

    login_as(ford.email, ford.password)

    :ok
  end

  test "navigate to a list of 'My Orders' from the user menu" do
    find_element(:id, "user-menu")
    |> click

    find_element(:id, "orders-link")
    |> click

    assert current_path() == "/orders"

    page_title = find_element(:class, "page-title")
                 |> visible_text()

    assert page_title == "Ford's Orders"

    [order | _rest] = find_all_elements(:class, "order")

    order_status = find_within_element(order, :class, "order-status")
    |> visible_text()

    order_total = find_within_element(order, :class, "order-total")
    |> visible_text()

    assert order_status =~ "Confirmed"
    assert order_total =~ "£ 25.0"

    refute page_source() =~ "Delivered"
  end

  test "view order details using the 'View' link from the 'My Orders' page" do
    navigate_to("/orders")

    [order | _rest] = find_all_elements(:class, "order")

    find_within_element(order, :class, "order-details-link")
    |> click


    [line_item | _rest] = find_all_elements(:class, "order-line-items")

    product_name = find_within_element(line_item, :class, "product-name")
    |> visible_text()

    pack_size = find_within_element(line_item, :class, "pack-size")
    |> visible_text()

    quantity = find_within_element(line_item, :class, "quantity")
    |> visible_text()

    unit_price = find_within_element(line_item, :class, "unit-price")
    |> visible_text()

    total = find_within_element(line_item, :class, "total")
    |> visible_text()

    assert product_name == "Tomato"
    assert pack_size == "1 kg"
    assert quantity == "2"
    assert unit_price == "£ 55"
    assert total == "£ 110"
  end

  test "user sees a 404 page when attempting to view an order that does not belong to the user" do
    valid_attrs = %{
      "name" => "Arthur",
      "email" => "arthurd@milliways.com",
      "password" => "theansweris42",
      "residence_area" => "Earth",
      "phone" => "424242"
    }

    {:ok, arthur} = CRM.create_customer(valid_attrs)

    not_my_order = %Order{
      status: "Confirmed",
      total: 25.00,
      comments: "Not my order",
      customer_id: arthur.id,
      customer_name: arthur.name,
      email: arthur.email,
      residence_area: arthur.residence_area,
      line_items: []
    }
    |> Repo.insert!

    navigate_to("/orders/#{not_my_order.id}")

    assert page_source() =~ "Page not found"
  end

  defp login_as(email, password) do
    navigate_to("/login")

    form = find_element(:id, "session-form")
    find_within_element(form, :name, "session[email]")
    |> fill_field(email)

    find_within_element(form, :name, "session[password]")
    |> fill_field(password)

    find_within_element(form, :tag, "button")
    |> click

    assert current_path() == "/"
    message = find_element(:class, "alert-info")
              |> visible_text

    assert message == "Login successful"
  end

end
