defmodule MangoWeb.OrderController do
  use MangoWeb, :controller

  alias Mango.Sales

  def index(conn, _params) do
    customer = conn.assigns.current_customer
    orders = Sales.get_customer_orders(customer)

    render conn, "index.html", customer: customer, orders: orders
  end

  def show(conn, %{"id" => id}) do
    order = Sales.get_order(id)

    render conn, "show.html", order: order
  end

end
