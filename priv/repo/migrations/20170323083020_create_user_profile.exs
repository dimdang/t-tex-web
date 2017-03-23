defmodule TRexRestPhoenix.Repo.Migrations.CreateUserProfile do
  use Ecto.Migration

  def change do
    create table(:user_profile) do
      add :firstname, :string
      add :lastname, :string
      add :address, :string
      add :photo, :string
      add :status, :boolean, default: false, null: false
      add :phone, :string
      add :account_id, :integer

      timestamps()
    end

  end
end
