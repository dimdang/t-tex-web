defmodule TRexRestPhoenix.CheckoutDetailTest do
  use TRexRestPhoenix.ModelCase

  alias TRexRestPhoenix.CheckoutDetail

  @valid_attrs %{book_id: 42, checkout_id: 42, price: "120.5", unit: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = CheckoutDetail.changeset(%CheckoutDetail{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = CheckoutDetail.changeset(%CheckoutDetail{}, @invalid_attrs)
    refute changeset.valid?
  end
end
