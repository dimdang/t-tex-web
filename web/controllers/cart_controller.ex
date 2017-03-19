defmodule TRexRestPhoenix.CartController do
  use TRexRestPhoenix.Web, :controller

  alias TRexRestPhoenix.Cart

  def index(conn, _params) do
    carts = Repo.all(Cart)
    render(conn, "index.json", carts: carts)
  end

  def create(conn, %{"cart" => cart_params}) do
    changeset = Cart.changeset(%Cart{}, cart_params)

    case Repo.insert(changeset) do
      {:ok, cart} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", cart_path(conn, :show, cart))
        |> render("show.json", cart: cart)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(TRexRestPhoenix.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    cart = Repo.get!(Cart, id)
    render(conn, "show.json", cart: cart)
  end

  def update(conn, %{"id" => id, "cart" => cart_params}) do
    cart = Repo.get!(Cart, id)
    changeset = Cart.changeset(cart, cart_params)

    case Repo.update(changeset) do
      {:ok, cart} ->
        render(conn, "show.json", cart: cart)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(TRexRestPhoenix.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    cart = Repo.get!(Cart, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(cart)

    send_resp(conn, :no_content, "")
  end
end
