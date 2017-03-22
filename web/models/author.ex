defmodule TRexRestPhoenix.Author do
  use TRexRestPhoenix.Web, :model

  schema "authors" do
    field :firstname, :string
    field :lastname, :string
    field :description, :string
    field :photo, :string
    field :status, :boolean, default: false

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:firstname, :lastname, :description, :photo, :status])
    |> validate_required([:firstname, :lastname, :description, :photo, :status])
  end
end
