defmodule TRexRestPhoenix.CartController do
  use TRexRestPhoenix.Web, :controller

  alias TRexRestPhoenix.Cart
  alias TRexRestPhoenix.Book
  use PhoenixSwagger

  def swagger_definitions do
    %{
      Cart: swagger_schema do
        title "Cart"
        description "A cart to store books"
        properties do
           price :float, "Book price", required: true
           unit :integer, "Book unit", required: true
           status :integer, "Cart status", required: true
           account_id :integer, "Account ID", required: true
           book_id :integer, "Book ID", required: true
        end
        example %{
          price: 12.0,
          unit: 6,
          status: 1,
          account_id: 1,
          book_id: 1
        }
      end,
      CartRequest: swagger_schema do
        title "Cart Request"
        description "Post body for creating a cart"
        property :cart, Schema.ref(:Cart), "The cart details"
      end,
      CartResponse: swagger_schema do
        title "Cart Response"
        description "Response schema for single cart"
        property :cart, Schema.ref(:Cart), "The cart details"
      end,
      CartsResponse: swagger_schema do
        title "Carts Response"
        description "Response schema for multiple carts"
        property :data, Schema.array(:Cart), "The carts detail"
      end
    }
  end

  swagger_path(:index) do
    get "/api/v1/carts"
    summary "List all cart"
    description "List all cart in the database"
    produces "application/json"
    response 200, "OK", Schema.ref(:CartsResponse), example: %{
      data: [
        %{
          price: 12.0,
          unit: 6,
          status: 1,
          account_id: 1,
          book_id: 1
        },
        %{
          price: 12.0,
          unit: 6,
          status: 1,
          account_id: 1,
          book_id: 1
        }
      ]
    }
  end

  def index(conn, _params) do
    carts = Repo.all(from cart in Cart, where: cart.status == 1)
    render(conn, "index.json", carts: carts)
  end

  swagger_path(:create) do
    post "/api/v1/carts"
    summary "Create cart"
    description "Creates a new cart"
    consumes "application/json"
    produces "application/json"
    parameter :cart, :body, Schema.ref(:CartRequest), "The cart details", example: %{
      cart: %{
        price: 12.0,
        unit: 6,
        status: 1,
        account_id: 1,
        book_id: 1
      }
    }
    response 201, "cart created OK", Schema.ref(:CartResponse), example: %{
      data: %{
        price: 12.0,
        unit: 6,
        status: 1,
        account_id: 1,
        book_id: 1
      }
    }
  end

  def create(conn, %{"cart" => cart_params}) do
    changeset = Cart.changeset(%Cart{}, cart_params)

    book = Repo.get_by(Book, id: changeset.params["book_id"])

    if book.unit < changeset.params["unit"] do
      json conn , %{
        data: %{
          message: "Not engough books in stock!",
          unit_left: book.unit,
          status: 404
        }
      }
    else
      cart = Repo.get_by(Cart, book_id: changeset.params["book_id"])

      #create new book struct to update
      newBooks = %{
          title: book.title,
          isbn: book.isbn,
          price: book.price,
          unit: book.unit - changeset.params["unit"],
          publisher_name: book.publisher_name,
          published_year: book.published_year,
          page_count: book.page_count,
          language: book.language,
          shipping_weight: book.shipping_weight,
          image: book.image,
          book_dimensions: book.book_dimensions,
          status: book.status,
          category_id: book.category_id,
          author_id: book.author_id
      }

      case cart do
        # new book at to cart
        nil ->
          #update unit in books
          Repo.update(Book.changeset(book, newBooks))

          #save book to cart
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
        # old book in cart
        _ ->
          #update unit in books
          Repo.update(Book.changeset(book, newBooks))

          cart_params = %{
            price: cart.price,
            unit: (cart.unit + changeset.params["unit"]),
            status: cart.status,
            account_id: cart.account_id,
            book_id: cart.book_id
          }

          newCart = Cart.changeset(cart, cart_params)

          case Repo.update(newCart) do
            {:ok, cart} ->
              render(conn, "show.json", cart: cart)
            {:error, changeset} ->
              conn
              |> put_status(:unprocessable_entity)
              |> render(TRexRestPhoenix.ChangesetView, "error.json", changeset: changeset)
          end
      end
    end
  end

  swagger_path(:showBookInCart) do
    get "/api/v1/carts/user/{id}"
    summary "List all books in cart"
    description "List all books in cart in the database"
    produces "application/json"
    response 200, "OK", Schema.ref(:CartsResponse), example: %{
      data: [
        %{
          title: "How to program in C",
          isbn: "QWE34F98UIYO",
          price: 12.0,
          unit: 99,
          publisher_name: "Deitel Inc",
          published_year: "2013",
          page_count: "800",
          language: "en",
          shipping_weight: 2,
          book_dimensions: "12*12*0.9",
          status: true,
          image: "photo.jpg",
          description: "c programming for beginner",
          author_name: "Paul Deteil",
          is_feature: true,
          category_id: 1,
          author_id: 2
        },
        %{
          title: "How to program in C",
          isbn: "QWE34F98UIYO",
          price: 12.0,
          unit: 99,
          publisher_name: "Deitel Inc",
          published_year: "2013",
          page_count: "800",
          language: "en",
          shipping_weight: 2,
          book_dimensions: "12*12*0.9",
          status: true,
          image: "photo.jpg",
          description: "c programming for beginner",
          author_name: "Paul Deteil",
          is_feature: true,
          category_id: 1,
          author_id: 2
        }
      ]
    }
  end

  def showBookInCart(conn, %{"id" => id}) do
    cart = Repo.all(from cart in Cart, where: cart.account_id == ^id)

    conn
    |> assign(:books, renderBooks(cart))
    |> render("book_in_cart.json")
  end

  #render books user add to cart
  defp renderBooks(cart) do
    for c <- cart do
      book = Repo.get_by(Book, id: c.book_id)
      %{
        sub_total: c.unit * c.price,
        book_id: book.id,
        title: book.title,
        unit: c.unit,
        price: c.price,
        shipping_weight: book.shipping_weight,
        publisher_name: book.publisher_name,
        page_count: book.page_count,
        language: book.language,
        isbn: book.isbn,
        description: book.description,
        image: book.image,
        cart_id: c.id
      }
    end
  end

  swagger_path(:show) do
    get "/api/v1/carts/{id}"
    summary "Show cart"
    description "Show a cart by ID"
    produces "application/json"
    parameter :id, :path, :integer, "category ID", required: true, example: 1
    response 200, "OK", Schema.ref(:CartResponse), example: %{
      data:  %{
        price: 12.0,
        unit: 6,
        status: 1,
        account_id: 1,
        book_id: 1
      }
    }
  end

  def show(conn, %{"id" => id}) do
    cart = Repo.get!(Cart, id)
    render(conn, "show.json", cart: cart)
  end

  swagger_path(:update) do
     put "/api/v1/carts/{id}"
     summary "Update cart"
     description "Update all attributes of a cart"
     consumes "application/json"
     produces "application/json"
     parameters do
       id :path, :integer, "Cart ID", required: true, example: 3
       user :body, Schema.ref(:CartsRequest), "The cart details", example: %{
         cart: %{
           price: 12.0,
           unit: 6,
           status: 1,
           account_id: 1,
           book_id: 1
         }
       }
     end
     response 200, "Updated Successfully", Schema.ref(:CartResponse), example: %{
       data: %{
         price: 12.0,
         unit: 6,
         status: 1,
         account_id: 1,
         book_id: 1
       }
     }
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

  swagger_path(:delete) do
    delete "/api/v1/carts/{id}"
    summary "Delete cart"
    description "Delete a category by ID"
    parameter :id, :path, :integer, "category ID", required: true, example: 4
    response 203, "No Content - Deleted Successfully"
  end

  def delete(conn, %{"id" => id}) do
    cart = Repo.get!(Cart, id)

    book = Repo.get_by(Book, id: cart.book_id)

    newBooks = %{
        title: book.title,
        isbn: book.isbn,
        price: book.price,
        unit: book.unit + cart.unit,
        publisher_name: book.publisher_name,
        published_year: book.published_year,
        page_count: book.page_count,
        language: book.language,
        shipping_weight: book.shipping_weight,
        image: book.image,
        book_dimensions: book.book_dimensions,
        status: book.status,
        category_id: book.category_id,
        author_id: book.author_id
    }
    #update unit in books
    Repo.update(Book.changeset(book, newBooks))

    Repo.delete!(cart)

    json conn, %{ data: %{
                  message: "Remove book from cart success",
                  status: 200,
                }
              }
  end
end
