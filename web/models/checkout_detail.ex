defmodule TRexRestPhoenix.CheckoutDetail do
  use TRexRestPhoenix.Web, :model

  schema "checkout_detail" do
    field :unit, :integer
    field :price, :float
    field :checkout_id, :integer
    field :book_id, :integer

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:unit, :price, :checkout_id, :book_id])
    |> validate_required([:unit, :price, :checkout_id, :book_id])
  end
end
