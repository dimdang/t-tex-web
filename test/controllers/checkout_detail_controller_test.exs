defmodule TRexRestPhoenix.CheckoutDetailControllerTest do
  use TRexRestPhoenix.ConnCase

  alias TRexRestPhoenix.CheckoutDetail
  @valid_attrs %{book_id: 42, checkout_id: 42, price: "120.5", unit: 42}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, checkout_detail_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    checkout_detail = Repo.insert! %CheckoutDetail{}
    conn = get conn, checkout_detail_path(conn, :show, checkout_detail)
    assert json_response(conn, 200)["data"] == %{"id" => checkout_detail.id,
      "unit" => checkout_detail.unit,
      "price" => checkout_detail.price,
      "checkout_id" => checkout_detail.checkout_id,
      "book_id" => checkout_detail.book_id}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, checkout_detail_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, checkout_detail_path(conn, :create), checkout_detail: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(CheckoutDetail, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, checkout_detail_path(conn, :create), checkout_detail: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    checkout_detail = Repo.insert! %CheckoutDetail{}
    conn = put conn, checkout_detail_path(conn, :update, checkout_detail), checkout_detail: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(CheckoutDetail, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    checkout_detail = Repo.insert! %CheckoutDetail{}
    conn = put conn, checkout_detail_path(conn, :update, checkout_detail), checkout_detail: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    checkout_detail = Repo.insert! %CheckoutDetail{}
    conn = delete conn, checkout_detail_path(conn, :delete, checkout_detail)
    assert response(conn, 204)
    refute Repo.get(CheckoutDetail, checkout_detail.id)
  end
end
