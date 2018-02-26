defmodule TRexRestPhoenix.CartTest do
  use TRexRestPhoenix.ModelCase

  alias TRexRestPhoenix.Cart

  @valid_attrs %{account_id: 42, book_id: 42, price: "120.5", status: 42, unit: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Cart.changeset(%Cart{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Cart.changeset(%Cart{}, @invalid_attrs)
    refute changeset.valid?
  end
end
