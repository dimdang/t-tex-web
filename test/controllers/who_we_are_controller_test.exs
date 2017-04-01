defmodule TRexRestPhoenix.WhoWeAreControllerTest do
  use TRexRestPhoenix.ConnCase

  alias TRexRestPhoenix.WhoWeAre
  @valid_attrs %{our_mission: "some content", our_mission_photo: "some content", our_product: "some content", our_product_photo: "some content", what_we_do: "some content", what_we_do_photo: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, who_we_are_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    who_we_are = Repo.insert! %WhoWeAre{}
    conn = get conn, who_we_are_path(conn, :show, who_we_are)
    assert json_response(conn, 200)["data"] == %{"id" => who_we_are.id,
      "our_mission" => who_we_are.our_mission,
      "our_mission_photo" => who_we_are.our_mission_photo,
      "what_we_do" => who_we_are.what_we_do,
      "what_we_do_photo" => who_we_are.what_we_do_photo,
      "our_product" => who_we_are.our_product,
      "our_product_photo" => who_we_are.our_product_photo}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, who_we_are_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, who_we_are_path(conn, :create), who_we_are: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(WhoWeAre, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, who_we_are_path(conn, :create), who_we_are: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    who_we_are = Repo.insert! %WhoWeAre{}
    conn = put conn, who_we_are_path(conn, :update, who_we_are), who_we_are: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(WhoWeAre, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    who_we_are = Repo.insert! %WhoWeAre{}
    conn = put conn, who_we_are_path(conn, :update, who_we_are), who_we_are: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    who_we_are = Repo.insert! %WhoWeAre{}
    conn = delete conn, who_we_are_path(conn, :delete, who_we_are)
    assert response(conn, 204)
    refute Repo.get(WhoWeAre, who_we_are.id)
  end
end
