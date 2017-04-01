defmodule TRexRestPhoenix.WhoWeAreController do
  use TRexRestPhoenix.Web, :controller

  alias TRexRestPhoenix.WhoWeAre

  def index(conn, _params) do
    who_we_are = Repo.all(WhoWeAre)
    render(conn, "index.json", who_we_are: who_we_are)
  end

  def create(conn, %{"who_we_are" => who_we_are_params}) do
    changeset = WhoWeAre.changeset(%WhoWeAre{}, who_we_are_params)

    case Repo.insert(changeset) do
      {:ok, who_we_are} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", who_we_are_path(conn, :show, who_we_are))
        |> render("show.json", who_we_are: who_we_are)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(TRexRestPhoenix.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    who_we_are = Repo.get!(WhoWeAre, id)
    render(conn, "show.json", who_we_are: who_we_are)
  end

  def update(conn, %{"id" => id, "who_we_are" => who_we_are_params}) do
    who_we_are = Repo.get!(WhoWeAre, id)
    changeset = WhoWeAre.changeset(who_we_are, who_we_are_params)

    case Repo.update(changeset) do
      {:ok, who_we_are} ->
        render(conn, "show.json", who_we_are: who_we_are)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(TRexRestPhoenix.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    who_we_are = Repo.get!(WhoWeAre, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(who_we_are)

    send_resp(conn, :no_content, "")
  end
end
