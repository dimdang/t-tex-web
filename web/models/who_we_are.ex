defmodule TRexRestPhoenix.WhoWeAre do
  use TRexRestPhoenix.Web, :model

  schema "who_we_are" do
    field :our_mission, :string
    field :our_mission_photo, :string
    field :what_we_do, :string
    field :what_we_do_photo, :string
    field :our_product, :string
    field :our_product_photo, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:our_mission, :our_mission_photo, :what_we_do, :what_we_do_photo, :our_product, :our_product_photo])
    |> validate_required([:our_mission, :our_mission_photo, :what_we_do, :what_we_do_photo, :our_product, :our_product_photo])
  end
end
