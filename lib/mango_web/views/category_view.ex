defmodule MangoWeb.CategoryView do
  use MangoWeb, :view

  def title_case(name) do
    String.capitalize(name)
  end

end