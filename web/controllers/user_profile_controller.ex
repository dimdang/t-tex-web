defmodule TRexRestPhoenix.UserProfileController do
  use TRexRestPhoenix.Web, :controller

  alias TRexRestPhoenix.UserProfile

  def index(conn, _params) do
    user_profile = Repo.all(UserProfile)
    render(conn, "index.json", user_profile: user_profile)
  end

  def create(conn, %{"user_profile" => user_profile_params}) do
    changeset = UserProfile.changeset(%UserProfile{}, user_profile_params)

    case Repo.insert(changeset) do
      {:ok, user_profile} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", user_profile_path(conn, :show, user_profile))
        |> render("show.json", user_profile: user_profile)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(TRexRestPhoenix.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user_profile = Repo.get!(UserProfile, id)
    render(conn, "show.json", user_profile: user_profile)
  end

  def update(conn, %{"id" => id, "user_profile" => user_profile_params}) do
    user_profile = Repo.get!(UserProfile, id)
    changeset = UserProfile.changeset(user_profile, user_profile_params)

    case Repo.update(changeset) do
      {:ok, user_profile} ->
        render(conn, "show.json", user_profile: user_profile)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(TRexRestPhoenix.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user_profile = Repo.get!(UserProfile, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(user_profile)

    send_resp(conn, :no_content, "")
  end
end
