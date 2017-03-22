defmodule TRexRestPhoenix.CheckoutController do
  use TRexRestPhoenix.Web, :controller

  alias TRexRestPhoenix.Checkout
  alias TRexRestPhoenix.Account
  alias TRexRestPhoenix.UserProfile
  alias TRexRestPhoenix.CheckoutDetail
  alias TRexRestPhoenix.Book

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
      account = Repo.get_by(Account, id: checkout.account_id) # find who checkout these books
      profile = Repo.get_by(UserProfile, account_id: account.id) # find their profile
      checkoutDetail = Repo.all(from chdetail in CheckoutDetail, where: chdetail.checkout_id == ^checkout.id)

      conn
      |> assign(:checkout, checkout)
      |> assign(:books, renderBooks(checkoutDetail))
      |> assign(:account, account)
      |> assign(:profile, profile)
      |> render("detail.json")
  end

  #helper function to render books that user buy
  defp renderBooks(checkoutDetail) do
    for chDetail <- checkoutDetail do
      book = Repo.get_by(Book, id: chDetail.book_id)
      %{
        sub_total: chDetail.unit * chDetail.price,
        book_id: book.id,
        title: book.title,
        unit: chDetail.unit,
        price: chDetail.price,
        shipping_weight: book.shipping_weight,
        publisher_name: book.publisher_name,
        page_count: book.page_count,
        language: book.language,
        isbn: book.isbn,
        image: book.image
      }
    end
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
