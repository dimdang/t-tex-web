defmodule TRexRestPhoenix.BookController do
  use TRexRestPhoenix.Web, :controller

  alias TRexRestPhoenix.Book

  def index(conn, _params) do
    books = Repo.all(Book)
    render(conn, "index.json", books: books)
  end

  def create(conn, %{"title" => title,
                     "isbn" => isbn,
                     "price" => price,
                     "unit" => unit,
                     "publisher_name" => publisher,
                     "published_year" => published,
                     "page_count" => page,
                     "language" => language,
                     "shipping_weight" => shipping,
                     "book_dimensions" => bookDm,
                     "photo" => photo,
                     "category_id" => category,
                     "author_id" => author}) do

    if photo.filename === nil do
      json conn, %{data: %{
          status: 404,
          message: "please check you image"
      }}
    else
      extension = Path.extname(photo.filename)
      filename = "#{UUID.uuid1()}#{extension}"
      File.cp(photo.path,  Enum.join(["./uploads/", filename], ""))

      book = %{
        title: title,
        isbn: isbn,
        price: price,
        unit: unit,
        publisher_name: publisher,
        published_year: published,
        page_count: page,
        language: language,
        shipping_weight: shipping,
        book_dimensions: bookDm,
        status: 1,
        image: filename,
        category_id: category,
        author_id: author
      }

      changeset = Book.changeset(%Book{}, book)

      case Repo.insert(changeset) do
        {:ok, book} ->
          conn
          |> put_status(:created)
          |> put_resp_header("location", book_path(conn, :show, book))
          |> render("show.json", book: book)
        {:error, changeset} ->
          conn
          |> put_status(:unprocessable_entity)
          |> render(TRexRestPhoenix.ChangesetView, "error.json", changeset: changeset)
      end

    end
  end

  def show(conn, %{"id" => id}) do
    book = Repo.get!(Book, id)
    render(conn, "show.json", book: book)
  end

  def update(conn, %{"id" => id,
                     "title" => title,
                     "isbn" => isbn,
                     "price" => price,
                     "unit" => unit,
                     "publisher_name" => publisher,
                     "published_year" => published,
                     "page_count" => page,
                     "language" => language,
                     "shipping_weight" => shipping,
                     "book_dimensions" => bookDm,
                     "photo" => photo,
                     "category_id" => category,
                     "author_id" => author
                     }) do

    if photo.filename === nil do
      json conn, %{data: %{
                     status: 404,
                     message: "please check your image"
        }}
    else
      extension = Path.extname(photo.filename)
      filename = "#{UUID.uuid1()}#{extension}"
      File.cp(photo.path,  Enum.join(["./uploads/", filename], ""))

      newBook = %{
        title: title,
        isbn: isbn,
        price: price,
        unit: unit,
        publisher_name: publisher,
        published_year: published,
        page_count: page,
        language: language,
        shipping_weight: shipping,
        book_dimensions: bookDm,
        status: 1,
        image: filename,
        category_id: category,
        author_id: author
      }

      book = Repo.get!(Book, id)
      changeset = Book.changeset(book, newBook)

      case Repo.update(changeset) do
        {:ok, book} ->
          render(conn, "show.json", book: book)
        {:error, changeset} ->
          conn
          |> put_status(:unprocessable_entity)
          |> render(TRexRestPhoenix.ChangesetView, "error.json", changeset: changeset)
      end

    end
  end

  def delete(conn, %{"id" => id}) do
    book = Repo.get!(Book, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(book)

    send_resp(conn, :no_content, "")
  end
end
