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


  describe "tickets" do
    alias Mango.CRM.Ticket

    @valid_attrs %{message: "some message", status: "some status", subject: "some subject"}
    @invalid_attrs %{message: nil, status: nil, subject: nil}

    @valid_customer_attrs %{
      name: "Arthur",
      email: "arthurd@milliways.com",
      password: "theansweris42",
      residence_area: "earth"
    }

    def customer_fixture(attrs \\ %{}) do
      {:ok, customer} =
        attrs
        |> Enum.into(@valid_customer_attrs)
        |> CRM.create_customer()

      customer
    end

    def ticket_fixture(customer) do
      {:ok, ticket} =
        customer
        |> CRM.create_customer_ticket(@valid_attrs)

      ticket
    end

    @tag :pending
    test "list_customer_tickets/1 returns all tickets for a given customer" do
      customer = customer_fixture()
      ticket = ticket_fixture(customer)

      assert CRM.list_customer_tickets(customer) == [ticket]
    end

    test "get_customer_ticket!/2 returns the ticket with given id" do
      customer = customer_fixture()
      ticket = ticket_fixture(customer)

      assert CRM.get_customer_ticket!(customer, ticket.id) == ticket
    end

    test "create_customer_ticket/2 with valid data creates a ticket" do
      customer = customer_fixture()

      assert {:ok, %Ticket{} = ticket} = CRM.create_customer_ticket(customer, @valid_attrs)
      assert ticket.message == "some message"
      assert ticket.status == "some status"
      assert ticket.subject == "some subject"
    end

    test "create_customer_ticket/2 with invalid data returns error changeset" do
      customer = customer_fixture()

      assert {:error, %Ecto.Changeset{}} = CRM.create_customer_ticket(customer, @invalid_attrs)
    end

    test "build_customer_ticket/2 returns a ticket changeset" do
      customer = customer_fixture()

      assert %Ecto.Changeset{} = CRM.build_customer_ticket(customer, @valid_attrs)
    end
  end
end
