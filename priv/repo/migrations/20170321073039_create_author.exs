defmodule TRexRestPhoenix.Repo.Migrations.CreateAuthor do
  use Ecto.Migration

  def change do
    create table(:authors) do
      add :firstname, :string
      add :lastname, :string
      add :description, :string
      add :photo, :text
      add :status, :boolean, default: false, null: false

      timestamps()
    end

  end
end
