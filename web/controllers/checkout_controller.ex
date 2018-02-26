defmodule TRexRestPhoenix.CheckoutController do
  use TRexRestPhoenix.Web, :controller

  alias TRexRestPhoenix.Checkout
  alias TRexRestPhoenix.Account
  alias TRexRestPhoenix.UserProfile
  alias TRexRestPhoenix.CheckoutDetail
  alias TRexRestPhoenix.Book
  alias TRexRestPhoenix.Cart

  use PhoenixSwagger

  def swagger_definitions do
    %{
      Checkout: swagger_schema do
        title "Checkout"
        description "User checkout books"
        properties do
           account_id :integer, "Account ID", required: true
           status :integer, "Checkout Status", required: true
        end
        example %{
          account_id: 1,
          status: 1
        }
      end,
      CheckoutRequest: swagger_schema do
        title "Checkout Request"
        description "Post body for creating a checkout"
        property :checkout, Schema.ref(:Checkout), "The checkout detaills"
      end,
      CheckoutResponse: swagger_schema do
        title "Checkout Response"
        description "Response schema for single checkout"
        property :data, Schema.ref(:Checkout), "The checkout details"
      end,
      CheckoutsResponse: swagger_schema do
        title "Checkouts Response"
        description "Response schema for multiple checkouts"
        property :data, Schema.array(:Checkout), "The checkout details"
      end
    }
  end

  swagger_path(:index) do
    get "/api/v1/checkouts"
    summary "List all checkouts"
    description "List all checkouts in the database"
    produces "application/json"
    response 200, "OK", Schema.ref(:CheckoutsResponse), example: %{
      data: [
        %{
          id: 7,
          date: "2017-03-23T08:59:16.234776",
          status: "will delivery",
          profile: %{
            id: 1,
            photo: "user_1.jpg",
            phone: "098987877",
            lastname: "Kelvin",
            firstname: "DK",
            email: "xxx@mail.com",
            address: "Phnom Penh"
          }
        },
      ]
    }
  end

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

  swagger_path(:create) do
    post "/api/v1/checkouts"
    summary "Create checkout"
    description "Creates a new checkout"
    consumes "application/json"
    produces "application/json"
    parameter :checkout, :body, Schema.ref(:CheckoutRequest), "The checkout details", example: %{
      checkout: %{account_id: "1", status: 1}
    }
    response 201, "Checkout created OK", Schema.ref(:CheckoutResponse), example: %{
      data: %{account_id: "1", status: 1}
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

  swagger_path(:payment) do
    post "/api/v1/payment"
    summary "Create payment"
    description "Creates a new payment"
    consumes "application/json"
    produces "application/json"
    parameter :payment, :body, Schema.ref(:CheckoutRequest), "The payment details", example: %{
      payment: %{name: "DK", number: 4111111111111111, exp_month: 10, exp_year: 2020, cvc: 123, amount: 1000}
    }
    response 201, "payment created OK", Schema.ref(:CheckoutResponse), example: %{
      data: %{name: "DK", number: 4111111111111111, exp_month: 10, exp_year: 2020, cvc: 123, amount: 1000}
    }
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

  swagger_path(:show) do
    get "/api/v1/checkouts/{id}"
    summary "Show checkout"
    description "Show a checkout by ID"
    produces "application/json"
    parameter :id, :path, :integer, "checkout ID", required: true, example: 1
    response 200, "OK", Schema.ref(:CheckoutResponse), example: %{
      data:  %{
        status: 1,
        date: "2017-04-05T03:51:18.102568",
        profile: %{
          id: 1,
          photo: "myphoto.jpg",
          phone: "0933334343",
          firstname: "Kelvin",
          lastname: "DK",
          email: "xxx@mail.com",
          address: "Phnom Penh"
        },
        books: %{
          book_id: 7,
          title: "How to program in C",
          publisher_name: "Paul Deteil Inc.",
          shipping_weight: 1.2,
          price: 25,
          page_count: "235",
          unit: 2,
          language: "en",
          isbn: "454339403",
          image: "d4c5b53a-1914-11e7-b957-e0db559fd419.jpg",
          sub_total: 50
        }
      }
    }
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

  swagger_path(:update) do
     put "/api/v1/checkouts/{id}"
     summary "Update checkout"
     description "Update all attributes of a checkout"
     consumes "application/json"
     produces "application/json"
     parameters do
       id :path, :integer, "Checkout ID", required: true, example: 3
       user :body, Schema.ref(:CheckoutRequest), "The checkout details", example: %{
         checkout: %{account_id: "1", status: 1}
       }
     end
     response 200, "Updated Successfully", Schema.ref(:CheckoutResponse), example: %{
       data: %{account_id: "1", status: 1}
     }
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

  swagger_path(:delete) do
    delete "/api/v1/checkouts/{id}"
    summary "Delete checkout"
    description "Delete a checkout by ID"
    parameter :id, :path, :integer, "checkout ID", required: true, example: 4
    response 203, "No Content - Deleted Successfully"
  end

  def delete(conn, %{"id" => id}) do
    checkout = Repo.get!(Checkout, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(checkout)

    send_resp(conn, :no_content, "")
  end
end
