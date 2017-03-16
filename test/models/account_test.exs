defmodule TRexRestPhoenix.AccountTest do
  use TRexRestPhoenix.ModelCase

  alias TRexRestPhoenix.Account

  @valid_attrs %{email: "some content", password: "some content", role: 42, status: true}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Account.changeset(%Account{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Account.changeset(%Account{}, @invalid_attrs)
    refute changeset.valid?
  end
end
