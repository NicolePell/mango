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

end