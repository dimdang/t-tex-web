defmodule TRexRestPhoenix.CheckoutDetailController do
  use TRexRestPhoenix.Web, :controller

  alias TRexRestPhoenix.CheckoutDetail

  def index(conn, _params) do
    checkout_detail = Repo.all(CheckoutDetail)
    render(conn, "index.json", checkout_detail: checkout_detail)
  end

  def create(conn, %{"checkout_detail" => checkout_detail_params}) do
    changeset = CheckoutDetail.changeset(%CheckoutDetail{}, checkout_detail_params)

    case Repo.insert(changeset) do
      {:ok, checkout_detail} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", checkout_detail_path(conn, :show, checkout_detail))
        |> render("show.json", checkout_detail: checkout_detail)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(TRexRestPhoenix.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    checkout_detail = Repo.get!(CheckoutDetail, id)
    render(conn, "show.json", checkout_detail: checkout_detail)
  end

  def update(conn, %{"id" => id, "checkout_detail" => checkout_detail_params}) do
    checkout_detail = Repo.get!(CheckoutDetail, id)
    changeset = CheckoutDetail.changeset(checkout_detail, checkout_detail_params)

    case Repo.update(changeset) do
      {:ok, checkout_detail} ->
        render(conn, "show.json", checkout_detail: checkout_detail)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(TRexRestPhoenix.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    checkout_detail = Repo.get!(CheckoutDetail, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(checkout_detail)

    send_resp(conn, :no_content, "")
  end
end
