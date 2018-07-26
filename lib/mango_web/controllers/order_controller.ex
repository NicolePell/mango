defmodule MangoWeb.OrderController do
  use MangoWeb, :controller

  alias Mango.Repo
  alias Mango.Sales.Order

  def index(conn, _params) do
    customer = conn.assigns.current_customer
    orders = get_customer_orders()

    render conn, "index.html", customer: customer, orders: orders
  end

  def show(conn, %{"id" => id}) do
    render conn, "show.html"
  end

  defp get_customer_orders do
    Order
    |> Repo.all
  end

end
