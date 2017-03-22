defmodule TRexRestPhoenix.Repo.Migrations.CreateCheckoutDetail do
  use Ecto.Migration

  def change do
    create table(:checkout_detail) do
      add :unit, :integer
      add :price, :float
      add :checkout_id, :integer
      add :book_id, :integer

      timestamps()
    end

  end
end
