defmodule TRexRestPhoenix.UserProfileTest do
  use TRexRestPhoenix.ModelCase

  alias TRexRestPhoenix.UserProfile

  @valid_attrs %{account_id: 42, address: "some content", firstname: "some content", lastname: "some content", phone: "some content", photo: "some content", status: true}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = UserProfile.changeset(%UserProfile{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = UserProfile.changeset(%UserProfile{}, @invalid_attrs)
    refute changeset.valid?
  end
end
