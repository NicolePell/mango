defmodule Mango.CRMTest do
  use Mango.DataCase

  alias Mango.CRM
  alias Mango.CRM.Customer

  test "build_customer/0 returns a customer changeset" do
    assert %Ecto.Changeset{data: %Customer{}} = CRM.build_customer()
  end

  test "build_customer/1 returns a customer changeset with values applied" do
    attrs = %{"name" => "Arthur"}
    changeset = CRM.build_customer(attrs)
    assert changeset.params == attrs
  end

  test "create_customer/1 returns a customer for valid data" do
    valid_attrs = %{
      "name" => "Arthur",
      "email" => "arthurd@milliways.com",
      "password" => "theansweris42",
      "residence_area" => "earth",
      "phone" => "424242"
    }

    assert {:ok, customer} = CRM.create_customer(valid_attrs)
    assert Comeonin.Bcrypt.checkpw(valid_attrs["password"], customer.password_hash)
  end

  test "create_customer/1 returns a changeset for invalid data" do
    invalid_attrs = %{}
    assert {:error, %Ecto.Changeset{}} = CRM.create_customer(invalid_attrs)
  end

  test "get_customer_by_email" do
    valid_attrs = %{
      "name" => "Arthur",
      "email" => "arthurd@milliways.com",
      "password" => "theansweris42",
      "residence_area" => "earth",
      "phone" => "424242"
    }

    {:ok, customer} = CRM.create_customer(valid_attrs)
    returning_customer = CRM.get_customer_by_email("arthurd@milliways.com")
    assert customer.id == returning_customer.id
  end

  test "get_customer_by_credentials" do
    valid_attrs = %{
      "name" => "Arthur",
      "email" => "arthurd@milliways.com",
      "password" => "theansweris42",
      "residence_area" => "earth",
      "phone" => "424242"
    }

    {:ok, customer} = CRM.create_customer(valid_attrs)
    returning_customer = CRM.get_customer_by_credentials(valid_attrs)
    assert customer.id == returning_customer.id
  end

end