defmodule TRexRestPhoenix.CheckoutController do
  use TRexRestPhoenix.Web, :controller

  alias TRexRestPhoenix.Checkout

  def index(conn, _params) do
    checkouts = Repo.all(Checkout)
    render(conn, "index.json", checkouts: checkouts)
  end

  def create(conn, %{"checkout" => checkout_params}) do
    changeset = Checkout.changeset(%Checkout{}, checkout_params)

    case Repo.insert(changeset) do
      {:ok, checkout} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", checkout_path(conn, :show, checkout))
        |> render("show.json", checkout: checkout)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(TRexRestPhoenix.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    checkout = Repo.get!(Checkout, id)
    render(conn, "show.json", checkout: checkout)
  end

  def update(conn, %{"id" => id, "checkout" => checkout_params}) do
    checkout = Repo.get!(Checkout, id)
    changeset = Checkout.changeset(checkout, checkout_params)

    case Repo.update(changeset) do
      {:ok, checkout} ->
        render(conn, "show.json", checkout: checkout)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(TRexRestPhoenix.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    checkout = Repo.get!(Checkout, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(checkout)

    send_resp(conn, :no_content, "")
  end
end
