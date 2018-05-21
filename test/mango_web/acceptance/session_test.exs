defmodule MangoWeb.SessionTest do
  use Mango.DataCase
  use Hound.Helpers

  alias Mango.CRM
  
  hound_session()

  setup do
    ### GIVEN ###
    # There is a valid registered user
    valid_attrs = %{
      "name" => "Arthur",
      "email" => "arthurd@earth.com",
      "password" => "theansweris42",
      "residence_area" => "Earth",
      "phone" => "424242"
    }

    {:ok, _} = CRM.create_customer(valid_attrs)

    :ok
  end

  test "successful login for valid credentials" do
    navigate_to("/login")

    form = find_element(:id, "session-form")
    find_within_element(form, :name, "session[email]")
    |> fill_field("arthurd@earth.com")

    find_within_element(form, :name, "session[password]")
    |> fill_field("theansweris42")

    find_within_element(form, :tag, "button")
    |> click

    assert current_path() == "/"
    message = find_element(:class, "alert-info")
              |> visible_text
    
    assert message == "Login successful"
  end

  test "shows error message for invalid credentials" do
    navigate_to("/login")

    form = find_element(:id, "session-form")

    find_within_element(form, :tag, "button")
    |> click

    assert current_path() == "/login"
    message = find_element(:class, "alert-danger")
              |> visible_text

    assert message == "Invalid username/password combination"
  end
end