defmodule TRexRestPhoenix.Repo.Migrations.CreateCheckout do
  use Ecto.Migration

  def change do
    create table(:checkouts) do
      add :account_id, :integer

      timestamps()
    end

  end
end
