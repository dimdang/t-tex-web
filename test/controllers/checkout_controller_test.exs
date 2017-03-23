defmodule TRexRestPhoenix.CheckoutControllerTest do
  use TRexRestPhoenix.ConnCase

  alias TRexRestPhoenix.Checkout
  @valid_attrs %{account_id: 42, status: 42}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, checkout_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    checkout = Repo.insert! %Checkout{}
    conn = get conn, checkout_path(conn, :show, checkout)
    assert json_response(conn, 200)["data"] == %{"id" => checkout.id,
      "account_id" => checkout.account_id,
      "status" => checkout.status}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, checkout_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, checkout_path(conn, :create), checkout: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Checkout, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, checkout_path(conn, :create), checkout: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    checkout = Repo.insert! %Checkout{}
    conn = put conn, checkout_path(conn, :update, checkout), checkout: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Checkout, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    checkout = Repo.insert! %Checkout{}
    conn = put conn, checkout_path(conn, :update, checkout), checkout: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    checkout = Repo.insert! %Checkout{}
    conn = delete conn, checkout_path(conn, :delete, checkout)
    assert response(conn, 204)
    refute Repo.get(Checkout, checkout.id)
  end
end
