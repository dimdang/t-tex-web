defmodule TRexRestPhoenix.WhoWeAreTest do
  use TRexRestPhoenix.ModelCase

  alias TRexRestPhoenix.WhoWeAre

  @valid_attrs %{our_mission: "some content", our_mission_photo: "some content", our_product: "some content", our_product_photo: "some content", what_we_do: "some content", what_we_do_photo: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = WhoWeAre.changeset(%WhoWeAre{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = WhoWeAre.changeset(%WhoWeAre{}, @invalid_attrs)
    refute changeset.valid?
  end
end
