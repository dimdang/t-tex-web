defmodule TRexRestPhoenix.CartController do
  use TRexRestPhoenix.Web, :controller

  alias TRexRestPhoenix.Cart
  alias TRexRestPhoenix.Book

  def index(conn, _params) do
    carts = Repo.all(Cart)
    render(conn, "index.json", carts: carts)
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
    end
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
        image: book.image
      }
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

  def deleteBookFromCart(conn, %{"id" => id, "book_id" => book_id}) do
    cart = Repo.all(from cart in Cart, where: cart.account_id == ^id and cart.book_id == ^book_id)
    book = Repo.get_by(Book, id: book_id)

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

  def delete(conn, %{"id" => id}) do
    cart = Repo.get!(Cart, id)

    Repo.delete!(cart)

    send_resp(conn, :no_content, "")
  end
end
