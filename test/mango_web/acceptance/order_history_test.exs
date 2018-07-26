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

    {:ok, customer} = CRM.create_customer(valid_attrs)

    Repo.insert %Order{
      status: "Confirmed",
      total: 2.50,
      comments: "Stock up",
      customer_id: customer.id,
      customer_name: customer.name,
      email: customer.email,
      residence_area: customer.residence_area
    }

    ##############################################################

    :ok
  end

  test "navigate to a list of 'My Orders' from the user menu" do
    ##############################################################
    # TODO: Extract login_as(user) into a test helper
    navigate_to("/login")

    form = find_element(:id, "session-form")
    find_within_element(form, :name, "session[email]")
    |> fill_field("fordp@betelgeuse.com")

    find_within_element(form, :name, "session[password]")
    |> fill_field("theansweris42")

    find_within_element(form, :tag, "button")
    |> click

    assert current_path() == "/"
    message = find_element(:class, "alert-info")
              |> visible_text

    assert message == "Login successful"
    ##############################################################

    find_element(:id, "user-menu")
    |> click

    find_element(:id, "orders-link")
    |> click

    assert current_path() == "/orders"
  end

  test "view order details using the 'View' link from the 'My Orders' page" do
  end

  test "user sees a 404 page when attempting to view an order that does not belong to the user" do
  end

end
