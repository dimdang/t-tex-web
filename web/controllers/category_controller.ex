defmodule TRexRestPhoenix.CategoryController do
  use TRexRestPhoenix.Web, :controller

  alias TRexRestPhoenix.Category
  use PhoenixSwagger

  def swagger_definitions do
    %{
      Category: swagger_schema do
        title "Category"
        description "A category for books"
        properties do
           name :string, "Category name", required: true
           description :string, "Category description"
           status :boolean, "Category status", required: true
        end
        example %{
          name: "History",
          description: "All books relate to history",
          status: true
        }
      end,
      CategoryRequest: swagger_schema do
        title "Category Request"
        description "Post body for creating a category"
        property :category, Schema.ref(:Category), "The category details"
      end,
      CategoryResponse: swagger_schema do
        title "Category Response"
        description "Response schema for single category"
        property :data, Schema.ref(:Category), "The category details"
      end,
      CategoriesResponse: swagger_schema do
        title "Category Response"
        description "Response schema for multiple categories"
        property :data, Schema.array(:Category), "The categories details"
      end
    }
  end

  swagger_path(:index) do
    get "/api/v1/categories"
    summary "List all categories"
    description "List all categories in the database"
    produces "application/json"
    response 200, "OK", Schema.ref(:CategoriesResponse), example: %{
      data: [
        %{name: "History", description: "Store history books", status: true},
        %{name: "Mind Book", description: "Store mind books", status: true}
      ]
    }
  end

  def index(conn, _params) do
    categories = Repo.all(from category in Category, where: category.status == true)
    render(conn, "index.json", categories: categories)
  end

  swagger_path(:create) do
    post "/api/v1/categories"
    summary "Create category"
    description "Creates a new category"
    consumes "application/json"
    produces "application/json"
    parameter :category, :body, Schema.ref(:CategoryRequest), "The category details", example: %{
      category: %{name: "History", description: "Store history books", status: true}
    }
    response 201, "Category created OK", Schema.ref(:CategoryResponse), example: %{
      data: %{name: "History", description: "Store history books", status: true}
    }
  end

  def create(conn, %{"category" => category_params}) do
    changeset = Category.changeset(%Category{}, category_params)

    case Repo.insert(changeset) do
      {:ok, category} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", category_path(conn, :show, category))
        |> render("show.json", category: category)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(TRexRestPhoenix.ChangesetView, "error.json", changeset: changeset)
    end
  end

  swagger_path(:show) do
    get "/api/v1/categories/{id}"
    summary "Show category"
    description "Show a category by ID"
    produces "application/json"
    parameter :id, :path, :integer, "category ID", required: true, example: 1
    response 200, "OK", Schema.ref(:CategoryResponse), example: %{
      data:  %{name: "History", description: "Store history books", status: true}
    }
  end

  def show(conn, %{"id" => id}) do
    category = Repo.get!(Category, id)
    render(conn, "show.json", category: category)
  end

  swagger_path(:update) do
     put "/api/v1/categories/{id}"
     summary "Update category"
     description "Update all attributes of a category"
     consumes "application/json"
     produces "application/json"
     parameters do
       id :path, :integer, "Category ID", required: true, example: 3
       user :body, Schema.ref(:CategoryRequest), "The category details", example: %{
         category: %{name: "Science", description: "Store science books", status: true}
       }
     end
     response 200, "Updated Successfully", Schema.ref(:CategoryResponse), example: %{
       data: %{name: "Science", description: "Store science books", status: true}
     }
  end

  def update(conn, %{"id" => id, "category" => category_params}) do
    category = Repo.get!(Category, id)
    changeset = Category.changeset(category, category_params)

    case Repo.update(changeset) do
      {:ok, category} ->
        render(conn, "show.json", category: category)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(TRexRestPhoenix.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    category = Repo.get!(Category, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(category)

    send_resp(conn, :no_content, "")
  end

  swagger_path(:tmpDelete) do
    get "/api/v1/category/{id}"
    summary "Delete category"
    description "Delete a category by ID"
    parameter :id, :path, :integer, "category ID", required: true, example: 4
    response 203, "No Content - Deleted Successfully"
  end

  def tmpDelete(conn, %{"id" => id}) do
    category = Repo.get!(Category, id)

    newCategory = %{
      name: category.name,
      description: category.description,
      status: false
    }
    changeset = Category.changeset(category, newCategory)

    Repo.update(changeset)

    json conn, %{data: %{
        message: "category delete success!",
        status: 200
      }}
  end
end
