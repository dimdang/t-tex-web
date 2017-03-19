defmodule TRexRestPhoenix.Checkout do
  use TRexRestPhoenix.Web, :model
  use Rummage.Ecto

  schema "checkouts" do
    field :account_id, :integer

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:account_id])
    |> validate_required([:account_id])
  end
end
