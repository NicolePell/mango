defmodule MangoWeb.LoadCustomerTest do
  use MangoWeb.ConnCase
  
  alias Mango.CRM

  @valid_attrs %{
    "name" => "Arthur",
    "email" => "arthurd@earth.com",
    "password" => "theansweris42",
    "residence_area" => "Earth",
    "phone" => "424242"
  }

  test "fetch customer from session on subsequent visit" do
    # Create new customer
    {:ok, customer} = CRM.create_customer(@valid_attrs)

    # Build a new conn by posting login data to "/session" path
    conn = post build_conn(), "/login", %{"session" => @valid_attrs}

    # We reuse the same conn now instead of building a new one
    conn = get conn, "/"

    # Now we expect the conn to have the `current_customer` data loaded in the conn
    assert customer.id == conn.assigns.current_customer.id
  end

end