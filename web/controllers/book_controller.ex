defmodule TRexRestPhoenix.BookController do
  use TRexRestPhoenix.Web, :controller

  alias TRexRestPhoenix.Book
  alias TRexRestPhoenix.Author

  def index(conn, _params) do
    books = Repo.all(from book in Book, where: book.status == 1)
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
                     "description" => description,
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

      author_param = Repo.get!(Author, author)

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
        description: description,
        author_name: Enum.join([author_param.firstname,author_param.lastname], " "),
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
                     "description" => description,
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

      author_param = Repo.get!(Author, author)

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
        description: description,
        author_name: Enum.join([author_param.firstname,author_param.lastname], " "),
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

  def tmpDelete(conn, %{"id" => id}) do
    book = Repo.get!(Book, id)

    newBook = %{
      title: book.title,
      isbn: book.isbn,
      price: book.price,
      unit: book.unit,
      publisher_name: book.publisher_name,
      published_year: book.published_year,
      page_count: book.page_count,
      language: book.language,
      shipping_weight: book.shipping_weight,
      book_dimensions: book.book_dimensions,
      status: 0,
      description: book.description,
      author_name: book.author_name,
      image: book.image,
      category_id: book.category_id,
      author_id: book.author_id
    }

    changeset = Book.changeset(book, newBook)

    Repo.update(changeset)

    json conn, %{data: %{message: "book has been delete",
                         status: 200
          }}
  end
end
