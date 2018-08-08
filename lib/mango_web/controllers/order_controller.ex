defmodule MangoWeb.OrderController do
  use MangoWeb, :controller

  alias Mango.Sales

  def index(conn, _params) do
    customer = conn.assigns.current_customer
    orders = Sales.get_customer_orders(customer)

    render conn, "index.html", customer: customer, orders: orders
  end

  def show(conn, %{"id" => id}) do
    customer = conn.assigns.current_customer
    order = Sales.get_order(id)

    if customer.id == order.customer_id  do
      render conn, "show.html", order: order
    else
      conn
      |> put_status(:not_found)
      |> put_view(MangoWeb.ErrorView)
      |> render("404.html")
    end
  end

end
