defmodule TRexRestPhoenix.Repo.Migrations.CreateUserProfile do
  use Ecto.Migration

  def change do
    create table(:user_profile) do
      add :firstname, :string
      add :lastname, :string
      add :address, :string
      add :photo, :text
      add :status, :boolean, default: false, null: false
      add :account_id, :integer

      timestamps()
    end

  end
end
