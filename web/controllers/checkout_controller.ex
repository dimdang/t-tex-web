defmodule TRexRestPhoenix.CheckoutController do
  use TRexRestPhoenix.Web, :controller

  alias TRexRestPhoenix.Checkout
  alias TRexRestPhoenix.Account
  alias TRexRestPhoenix.UserProfile
  alias TRexRestPhoenix.CheckoutDetail
  alias TRexRestPhoenix.Book
  alias TRexRestPhoenix.Cart

  def index(conn, _params) do
    checkouts = Repo.all(from checkout in Checkout, where: checkout.status != 0)
    json conn, %{
                  data: customIndex(checkouts)
                }
  end

  defp customIndex(checkouts) do
    for c <- checkouts do
      profile = Repo.get_by(UserProfile, account_id: c.account_id)
      account = Repo.get_by(Account, id: c.account_id)

      case c.status do
        1 -> customTemplateIndex(c,"will delivery",profile,account)
        2 -> customTemplateIndex(c,"done",profile,account)
      end
    end
  end

  #custom template json for checkout
  defp customTemplateIndex(c,status,profile,account) do
    %{
        id: c.id,
        status: status,
        date: c.inserted_at,
        profile: %{
          firstname: profile.firstname,
          lastname: profile.lastname,
          address: profile.address,
          photo: profile.photo,
          id: profile.account_id,
          phone: profile.phone,
          email: account.email
        }
    }
  end

  def create(conn, %{"checkout" => checkout_params}) do
    changeset = Checkout.changeset(%Checkout{}, checkout_params)

    case Repo.insert(changeset) do
      {:ok, checkout} ->
        saveCheckoutDetail(checkout)
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

  def payment(conn, %{"payment" => payment_params}) do

    name = Map.get(payment_params, "name")
    number = Map.get(payment_params, "number")
    exp_month = Map.get(payment_params, "exp_month")
    exp_year = Map.get(payment_params, "exp_year")
    cvc = Map.get(payment_params, "cvc")
    amount = Map.get(payment_params, "amount")

    params = [
      source: [
        object: "card",
        #4111111111111111
        number: number,
        #10
        exp_month: exp_month,
        #2020
        exp_year: exp_year,
        name: name,
        cvc: cvc
      ]
    ]

    {:ok, charge} = Stripe.Charges.create(amount, params)

    json conn , %{data: charge}

  end

  defp saveCheckoutDetail(checkout) do
    cart = Repo.all(from c in Cart, where: c.account_id == ^checkout.account_id)
    for c <- cart do
      checkoutDetail = %{
        unit: c.unit,
        price: c.price,
        checkout_id: checkout.id,
        book_id: c.book_id
      }

      Repo.insert(CheckoutDetail.changeset(%CheckoutDetail{}, checkoutDetail))
      Repo.delete!(c)
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
