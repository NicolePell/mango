defmodule Mango.Repo.Migrations.CorrectCustomerIdFieldTicket do
  use Ecto.Migration

  def change do
    rename table("tickets"), :customeer_id, to: :customer_id
  end

end
