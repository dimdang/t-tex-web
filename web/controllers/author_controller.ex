defmodule TRexRestPhoenix.AuthorController do
  use TRexRestPhoenix.Web, :controller

  alias TRexRestPhoenix.Author

  def index(conn, _params) do
    authors = Repo.all(Author)
    render(conn, "index.json", authors: authors)
  end

  def create(conn, %{"firstname" => firstname,
                     "lastname" => lastname,
                     "description" => decription,
                     "photo" => photo}) do

    if photo.filename === nil do
      json conn, %{data: %{
                     status: 404,
                     message: "please check you image"
        }}
    else
      extension = Path.extname(photo.filename)
      filename = "#{UUID.uuid1()}#{extension}"
      File.cp(photo.path,  Enum.join(["./uploads/", filename], ""))

      author = %{
        firstname: firstname,
        lastname: lastname,
        description: decription,
        photo: filename,
        status: true
      }
      changeset = Author.changeset(%Author{}, author)

      case Repo.insert(changeset) do
        {:ok, author} ->
          conn
          |> put_status(:created)
          |> put_resp_header("location", author_path(conn, :show, author))
          |> render("show.json", author: author)
        {:error, changeset} ->
          conn
          |> put_status(:unprocessable_entity)
          |> render(TRexRestPhoenix.ChangesetView, "error.json", changeset: changeset)
      end
    end
  end

  def show(conn, %{"id" => id}) do
    author = Repo.get!(Author, id)
    render(conn, "show.json", author: author)
  end

  def update(conn, %{"id" => id,
                     "firstname" => firstname,
                     "lastname" => lastname,
                     "description" => decription,
                     "photo" => photo}) do

    if photo.filename === nil do
      json conn, %{data: %{
                     status: 404,
                     message: "please check your image"
        }}                        
    else
      extension = Path.extname(photo.filename)
      filename = "#{UUID.uuid1()}#{extension}"
      File.cp(photo.path,  Enum.join(["./uploads/", filename], ""))

      newAuthor = %{
        firstname: firstname,
        lastname: lastname,
        description: decription,
        photo: filename,
        status: true
      }

      author = Repo.get!(Author, id)
      changeset = Author.changeset(author, newAuthor)

      case Repo.update(changeset) do
        {:ok, author} ->
          render(conn, "show.json", author: author)
        {:error, changeset} ->
          conn
          |> put_status(:unprocessable_entity)
          |> render(TRexRestPhoenix.ChangesetView, "error.json", changeset: changeset)
      end
    end
  end

  def delete(conn, %{"id" => id}) do
    author = Repo.get!(Author, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(author)

    send_resp(conn, :no_content, "")
  end
end
