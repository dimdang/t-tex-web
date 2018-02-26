defmodule TRexRestPhoenix.AuthorTest do
  use TRexRestPhoenix.ModelCase

  alias TRexRestPhoenix.Author

  @valid_attrs %{description: "some content", firstname: "some content", lastname: "some content", photo: "some content", position: "some content", status: true}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Author.changeset(%Author{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Author.changeset(%Author{}, @invalid_attrs)
    refute changeset.valid?
  end
end
