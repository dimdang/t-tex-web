defmodule TRexRestPhoenix.Account do
  use TRexRestPhoenix.Web, :model
  use Rummage.Ecto

  schema "accounts" do
    field :email, :string
    field :password, :string
    field :role, :integer
    field :status, :boolean, default: false

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :password, :role, :status])
    |> validate_required([:email, :password, :role, :status])
  end
end
