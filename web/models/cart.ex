defmodule TRexRestPhoenix.Cart do
  use TRexRestPhoenix.Web, :model

  schema "carts" do
    field :price, :float
    field :unit, :integer
    field :status, :integer
    field :account_id, :integer
    field :book_id, :integer

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:price, :unit, :status, :account_id, :book_id])
    |> validate_required([:price, :unit, :status, :account_id, :book_id])
  end
end
