defmodule TRexRestPhoenix.Repo.Migrations.CreateBook do
  use Ecto.Migration

  def change do
    create table(:books) do
      add :title, :string
      add :isbn, :string
      add :price, :float
      add :unit, :integer
      add :publisher_name, :string
      add :published_year, :string
      add :page_count, :string
      add :language, :string
      add :shipping_weight, :float
      add :book_dimensions, :string
      add :status, :integer
      add :image, :text
      add :category_id, :integer
      add :author_id, :integer

      timestamps()
    end

  end
end
