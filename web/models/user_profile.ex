defmodule TRexRestPhoenix.UserProfile do
  use TRexRestPhoenix.Web, :model

  schema "user_profile" do
    field :firstname, :string
    field :lastname, :string
    field :address, :string
    field :photo, :string
    field :status, :boolean, default: false
    field :phone, :string
    field :account_id, :integer

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:firstname, :lastname, :address, :photo, :status, :phone, :account_id])
    |> validate_required([:firstname, :lastname, :address, :photo, :status, :phone, :account_id])
  end
end
