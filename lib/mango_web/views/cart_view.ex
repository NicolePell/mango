defmodule MangoWeb.CartView do
  use MangoWeb, :view

  alias Mango.Sales.Order

  def cart_count(conn = %Plug.Conn{}) do
    cart_count(conn.assigns.cart)
  end

  def cart_count(cart = %Order{}) do
    Enum.reduce(cart.line_items, 0, fn(item, accumulator) ->
      accumulator + item.quantity
    end)
  end

end