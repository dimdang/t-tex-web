defmodule TRexRestPhoenix.UserProfileControllerTest do
  use TRexRestPhoenix.ConnCase

  alias TRexRestPhoenix.UserProfile
  @valid_attrs %{account_id: 42, address: "some content", firstname: "some content", lastname: "some content", phone: "some content", photo: "some content", status: true}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, user_profile_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    user_profile = Repo.insert! %UserProfile{}
    conn = get conn, user_profile_path(conn, :show, user_profile)
    assert json_response(conn, 200)["data"] == %{"id" => user_profile.id,
      "firstname" => user_profile.firstname,
      "lastname" => user_profile.lastname,
      "address" => user_profile.address,
      "photo" => user_profile.photo,
      "status" => user_profile.status,
      "phone" => user_profile.phone,
      "account_id" => user_profile.account_id}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, user_profile_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, user_profile_path(conn, :create), user_profile: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(UserProfile, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, user_profile_path(conn, :create), user_profile: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    user_profile = Repo.insert! %UserProfile{}
    conn = put conn, user_profile_path(conn, :update, user_profile), user_profile: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(UserProfile, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    user_profile = Repo.insert! %UserProfile{}
    conn = put conn, user_profile_path(conn, :update, user_profile), user_profile: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    user_profile = Repo.insert! %UserProfile{}
    conn = delete conn, user_profile_path(conn, :delete, user_profile)
    assert response(conn, 204)
    refute Repo.get(UserProfile, user_profile.id)
  end
end
