defmodule TRexRestPhoenix.Book do
  use TRexRestPhoenix.Web, :model
  use Rummage.Ecto

  schema "books" do
    field :title, :string
    field :isbn, :string
    field :price, :float
    field :unit, :integer
    field :publisher_name, :string
    field :published_year, :string
    field :page_count, :string
    field :language, :string
    field :shipping_weight, :float
    field :book_dimensions, :string
    field :status, :integer
    field :category_id, :integer
    field :author_id, :integer

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [ :title,
                      :isbn,
                      :price,
                      :unit,
                      :publisher_name,
                      :published_year,
                      :page_count,
                      :language,
                      :shipping_weight,
                      :book_dimensions,
                      :status,
                      :category_id,
                      :author_id])
    |> validate_required([  :title,
                            :isbn,
                            :price,
                            :unit,
                            :publisher_name,
                            :published_year,
                            :page_count,
                            :language,
                            :shipping_weight,
                            :book_dimensions,
                            :status,
                            :category_id,
                            :author_id])
  end
end
