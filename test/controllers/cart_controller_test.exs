defmodule TRexRestPhoenix.CartControllerTest do
  use TRexRestPhoenix.ConnCase

  alias TRexRestPhoenix.Cart
  @valid_attrs %{account_id: 42, book_id: 42, price: "120.5", status: 42, unit: 42}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, cart_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    cart = Repo.insert! %Cart{}
    conn = get conn, cart_path(conn, :show, cart)
    assert json_response(conn, 200)["data"] == %{"id" => cart.id,
      "price" => cart.price,
      "unit" => cart.unit,
      "status" => cart.status,
      "account_id" => cart.account_id,
      "book_id" => cart.book_id}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, cart_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, cart_path(conn, :create), cart: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Cart, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, cart_path(conn, :create), cart: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    cart = Repo.insert! %Cart{}
    conn = put conn, cart_path(conn, :update, cart), cart: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Cart, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    cart = Repo.insert! %Cart{}
    conn = put conn, cart_path(conn, :update, cart), cart: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    cart = Repo.insert! %Cart{}
    conn = delete conn, cart_path(conn, :delete, cart)
    assert response(conn, 204)
    refute Repo.get(Cart, cart.id)
  end
end
