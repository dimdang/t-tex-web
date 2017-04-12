defmodule TRexRestPhoenix.BookController do
  use TRexRestPhoenix.Web, :controller

  alias TRexRestPhoenix.Book
  alias TRexRestPhoenix.Author
  alias TRexRestPhoenix.Cart
  use PhoenixSwagger

  def swagger_definitions do
    %{
      Book: swagger_schema do
        title "Book"
        description "A book"
        properties do
          title :string, "Book name", required: true
          isbn :string, "Book ISBN", required: true
          price :float, "Book price", required: true
          unit :integer, "Book unit", required: true
          publisher_name :string, "Book publisher name", required: true
          published_year :string, "Book published year", required: true
          page_count :string, "Book page count", required: true
          language :string, "Book language", required: true
          shipping_weight :float, "Book shipping weight", required: true
          book_dimensions :string, "Book dimensions", required: true
          status :integer, "Book status", required: true
          image :string, "Book image", required: true
          description :string, "Book description", required: true
          author_name :string, "Book author name", required: true
          is_feature :boolean, "Book feature", required: true
          category_id :integer, "category id", required: true
          author_id :integer, "author id", required: true
        end
        example %{
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
      end,
      BookRequest: swagger_schema do
        title "Book Request"
        description "Post body for creating a book"
        property :book, Schema.ref(:Book), "The book details"
      end,
      BookResponse: swagger_schema do
        title "Book Response"
        description "Response schema for single book"
        property :data, Schema.ref(:Book), "The book details"
      end,
      BooksResponse: swagger_schema do
        title "Book Response"
        description "Response schema for multiple books"
        property :data, Schema.array(:Book), "The books details"
      end
    }
  end

  swagger_path(:index) do
    get "/api/v1/books"
    summary "List all books"
    description "List all books in the database"
    produces "application/json"
    response 200, "OK", Schema.ref(:BooksResponse), example: %{
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

  def index(conn, _params) do
    books = Repo.all(from book in Book, where: book.status == 1)
    render(conn, "index.json", books: books)
  end

  swagger_path(:bookFeatures) do
    get "/api/v1/book-feature"
    summary "List all books"
    description "List all books in the database"
    produces "application/json"
    response 200, "OK", Schema.ref(:BooksResponse), example: %{
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

  def bookFeatures(conn, _params) do
    books = Repo.all(from book in Book, where: book.is_feature == true)
    render(conn, "index.json", books: books)
  end

  swagger_path(:create) do
    post "/api/v1/books"
    summary "Create book"
    description "Creates a new book"
    consumes "application/json"
    produces "application/json"
    parameter :book, :body, Schema.ref(:BookRequest), "The book details", example: %{
      book:   %{
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
    }
    response 200, "Book created OK", Schema.ref(:BookResponse), example: %{
      data:   %{
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
    }
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
                     "is_feature" => is_feature,
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
        is_feature: is_feature,
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

  swagger_path(:show) do
    get "/api/v1/books/{id}"
    summary "Show book"
    description "Show a book by ID"
    produces "application/json"
    parameter :id, :path, :integer, "book ID", required: true, example: 1
    response 200, "OK", Schema.ref(:BookResponse), example: %{
      data:  %{
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
    }
  end

  def show(conn, %{"id" => id}) do
    book = Repo.get!(Book, id)
    render(conn, "show.json", book: book)
  end

  swagger_path(:update) do
     put "/api/v1/books/{id}"
     summary "Update book"
     description "Update all attributes of a book"
     consumes "application/json"
     produces "application/json"
     parameters do
       id :path, :integer, "Book ID", required: true, example: 3
       user :body, Schema.ref(:BookRequest), "The book details", example: %{
         book: %{
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
       }
     end
     response 200, "Updated Successfully", Schema.ref(:BookResponse), example: %{
       data: %{
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
     }
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
                     "is_feature" => is_feature,
                     "category_id" => category,
                     "author_id" => author
                     }) do

    book = Repo.get!(Book, id)

    author_param = Repo.get!(Author, author)

    if photo == "1" do

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
        is_feature:  is_feature,
        author_name: Enum.join([author_param.firstname,author_param.lastname], " "),
        image: book.image,
        category_id: category,
        author_id: author
      }

      changeset = Book.changeset(book, newBook)

      case Repo.update(changeset) do
        {:ok, book} ->
          render(conn, "show.json", book: book)
        {:error, changeset} ->
          conn
          |> put_status(:unprocessable_entity)
          |> render(TRexRestPhoenix.ChangesetView, "error.json", changeset: changeset)
      end

    else

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
          description: description,
          is_feature:  is_feature,
          author_name: Enum.join([author_param.firstname,author_param.lastname], " "),
          image: filename,
          category_id: category,
          author_id: author
        }

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
  end

  swagger_path(:delete) do
    delete "/api/v1/books/{id}"
    summary "Delete book"
    description "Delete a book by ID"
    parameter :id, :path, :integer, "book ID", required: true, example: 4
    response 200, "No Content - Deleted Successfully"
  end

  def delete(conn, %{"id" => id}) do
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
      is_feature:  book.is_feature,
      author_name: book.author_name,
      image: book.image,
      category_id: book.category_id,
      author_id: book.author_id
    }

    changeset = Book.changeset(book, newBook)

    case Repo.update(changeset) do
      {:ok, book} ->
        carts = Repo.all(from cart in Cart, where: cart.book_id == ^id)
        case carts do
          nil ->
            json conn, %{data: %{message: "book has been delete",
                               status: 200
                }}
          _ ->
            for c <- carts do
              cart = Repo.get!(Cart, c.id)
              Repo.delete!(cart)
            end
            json conn, %{data: %{message: "book has been delete",
                               status: 200
                }}
        end
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(TRexRestPhoenix.ChangesetView, "error.json", changeset: changeset)
    end
  end
end
