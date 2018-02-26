defmodule TRexRestPhoenix.Repo.Migrations.CreateCart do
  use Ecto.Migration

  def change do
    create table(:carts) do
      add :price, :float
      add :unit, :integer
      add :status, :integer
      add :account_id, :integer
      add :book_id, :integer

      timestamps()
    end

  end
end
