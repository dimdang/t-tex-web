defmodule TRexRestPhoenix.CheckoutTest do
  use TRexRestPhoenix.ModelCase

  alias TRexRestPhoenix.Checkout

  @valid_attrs %{account_id: 42, status: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Checkout.changeset(%Checkout{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Checkout.changeset(%Checkout{}, @invalid_attrs)
    refute changeset.valid?
  end
end
