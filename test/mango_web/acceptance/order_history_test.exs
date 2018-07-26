defmodule MangoWeb.OrderHistoryTest do
  use Mango.DataCase
  use Hound.Helpers

  hound_session()

  setup do
    alias Mango.Repo
    alias Mango.Sales.Order
    alias Mango.CRM

    ##############################################################
    # TODO: Use ex_machina to generate test data
    valid_attrs = %{
      "name" => "Ford",
      "email" => "fordp@betelgeuse.com",
      "password" => "theansweris42",
      "residence_area" => "Betelgeuse",
      "phone" => "424242"
    }

    {:ok, ford} = CRM.create_customer(valid_attrs)

    Repo.insert %Order{
      status: "Confirmed",
      total: 25.00,
      comments: "Stock up",
      customer_id: ford.id,
      customer_name: ford.name,
      email: ford.email,
      residence_area: ford.residence_area
    }

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
  end

  test "view order details using the 'View' link from the 'My Orders' page" do
  end

  test "user sees a 404 page when attempting to view an order that does not belong to the user" do
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
