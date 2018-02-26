defmodule TRexRestPhoenix.Repo.Migrations.CreateAccount do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :email, :string
      add :password, :text
      add :role, :integer
      add :status, :boolean, default: false, null: false

      timestamps()
    end

  end
end
