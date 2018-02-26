defmodule TRexRestPhoenix.Repo.Migrations.CreateWhoWeAre do
  use Ecto.Migration

  def change do
    create table(:who_we_are) do
      add :our_mission, :text
      add :our_mission_photo, :text
      add :what_we_do, :text
      add :what_we_do_photo, :text
      add :our_product, :text
      add :our_product_photo, :text

      timestamps()
    end

  end
end
