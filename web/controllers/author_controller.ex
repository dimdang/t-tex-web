defmodule TRexRestPhoenix.AuthorController do
  use TRexRestPhoenix.Web, :controller

  alias TRexRestPhoenix.Author
  use PhoenixSwagger

  def swagger_definitions do
    %{
      Author: swagger_schema do
        title "Author"
        description "A author"
        properties do
          firstname :string, "Author firstname", required: true
          lastname :string, "Author lastname", required: true
          position :string, "Author position", required: true
          description :string, "Author description"
          photo :string, "Author photo", required: true
          status :boolean, "Author status", required: true
        end
        example %{
          firstname: "DK",
          lastname: "kelvin",
          position: "writer",
          description: "He is a writer and developer",
          photo: "photo.jpg",
          status: true
        }
      end,
      AuthorRequest: swagger_schema do
        title "Author Request"
        description "Post body for creating a author"
        property :author, Schema.ref(:Author), "The author details"
      end,
      AuthorResponse: swagger_schema do
        title "Author Response"
        description "Response schema for single author"
        property :data, Schema.ref(:Author), "The author details"
      end,
      AuthorsResponse: swagger_schema do
        title "Author Response"
        description "Response schema for multiple author"
        property :data, Schema.array(:Author), "The author details"
      end
    }
  end

  swagger_path(:index) do
    get "/api/v1/authors"
    summary "List all authors"
    description "List all authors in the database"
    produces "application/json"
    response 200, "OK", Schema.ref(:AuthorsResponse), example: %{
      data: [
        %{firstname: "DK", lastname: "Kelvin", position: "writer", description: "he is a writer and gammer", photo: "photo.jpg", status: true},
        %{firstname: "Anna", lastname: "Kelvin", position: "writer", description: "he is a writer and gammer", photo: "photo.jpg", status: true}
      ]
    }
  end

  def index(conn, _params) do
    authors = Repo.all(from author in Author, where: author.status == true)
    render(conn, "index.json", authors: authors)
  end

  swagger_path(:create) do
    post "/api/v1/authors"
    summary "Create authors"
    description "Creates a new authors"
    consumes "application/json"
    produces "application/json"
    parameter :author, :body, Schema.ref(:AuthorRequest), "The category details", example: %{
      author: %{firstname: "DK", lastname: "Kelvin", position: "writer", description: "he is a writer and gammer", photo: "photo.jpg", status: true}
    }
    response 200, "author created OK", Schema.ref(:AuthorResponse), example: %{
      data: %{firstname: "DK", lastname: "Kelvin", position: "writer", description: "he is a writer and gammer", photo: "photo.jpg", status: true}
    }
  end

  def create(conn, %{"firstname" => firstname,
                     "lastname" => lastname,
                     "position" => position,
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
        position: position,
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

  swagger_path(:show) do
    get "/api/v1/authors/{id}"
    summary "Show author"
    description "Show a author by ID"
    produces "application/json"
    parameter :id, :path, :integer, "author ID", required: true, example: 1
    response 200, "OK", Schema.ref(:AuthorResponse), example: %{
      data:  %{firstname: "DK", lastname: "Kelvin", position: "writer", description: "he is a writer and gammer", photo: "photo.jpg", status: true}
    }
  end

  def show(conn, %{"id" => id}) do
    author = Repo.get!(Author, id)
    render(conn, "show.json", author: author)
  end

  swagger_path(:update) do
     put "/api/v1/author/{id}"
     summary "Update author"
     description "Update all attributes of a author"
     consumes "application/json"
     produces "application/json"
     parameters do
       id :path, :integer, "author ID", required: true, example: 3
       user :body, Schema.ref(:AuthorRequest), "The category details", example: %{
         author: %{firstname: "DK", lastname: "Kelvin", position: "writer", description: "he is a writer and gammer", photo: "photo.jpg", status: true}
       }
     end
     response 200, "Updated Successfully", Schema.ref(:AuthorResponse), example: %{
       data: %{firstname: "DK", lastname: "Kelvin", position: "writer", description: "he is a writer and gammer", photo: "photo.jpg", status: true}
     }
  end

  def update(conn, %{"id" => id,
                     "firstname" => firstname,
                     "lastname" => lastname,
                     "position" => position,
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
        position: position,
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

  swagger_path(:tmpDelete) do
    get "/api/v1/author/{id}"
    summary "Delete author"
    description "Delete a author by ID"
    parameter :id, :path, :integer, "author ID", required: true, example: 4
    response 203, "No Content - Deleted Successfully"
  end

  def tmpDelete(conn, %{"id" => id}) do
    author = Repo.get!(Author, id)
    newAuthor = %{
      firstname: author.firstname,
      lastname: author.lastname,
      position: author.position,
      description: author.description,
      photo: author.photo,
      status: false
    }
    changeset = Author.changeset(author, newAuthor)

    Repo.update(changeset)
    json conn, %{data: %{
                message: "delete author success!",
                status: 200
      }}
  end
end
