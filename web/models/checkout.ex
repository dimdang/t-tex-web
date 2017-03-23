defmodule TRexRestPhoenix.Checkout do
  use TRexRestPhoenix.Web, :model

  schema "checkouts" do
    field :account_id, :integer
    field :status, :integer

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:account_id, :status])
    |> validate_required([:account_id, :status])
  end
end
