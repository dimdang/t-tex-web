defmodule TRexRestPhoenix.WhoWeAreController do
  use TRexRestPhoenix.Web, :controller

  alias TRexRestPhoenix.WhoWeAre
  use PhoenixSwagger

  def swagger_definitions do
    %{
      WhoWeAre: swagger_schema do
        title "who we are content"
        description "who we are dynamic content"
        properties do
           our_mission :string, "our mission content", required: true
           our_mission_photo :string, "our mission photo", required: true
           what_we_do :string, "what we do content", required: true
           what_we_do_photo :string, "what we do photo", required: true
           our_product :string, "our product", required: true
           our_product_photo :string, "our product photo", required: true
        end
        example %{
          our_mission: "this is our mission",
          our_mission_photo: "our_mission.jpg",
          what_we_do: "this is what we do",
          what_we_do_photo: "what_we_do.jpg",
          our_product: "this is our product",
          our_product_photo: "our_product.jpg"
        }
      end,
      WhoWeAreRequest: swagger_schema do
        title "Who we are request"
        description "Post body for creating who we are"
        property :who_we_are, Schema.ref(:WhoWeAre), "The who we are details"
      end,
      WhoWeAreResponse: swagger_schema do
        title "Who we are Response"
        description "Response schema for single who we are"
        property :data, Schema.ref(:WhoWeAre), "The who we are details"
      end,
      WhoWeAresResponse: swagger_schema do
        title "Who we are Response"
        description "Response schema for multiple who we are"
      end
    }
  end

  swagger_path(:index) do
    get "/api/v1/who_we_are"
    summary "List all who we are"
    description "List all who we are in the database"
    produces "application/json"
    response 200, "OK", Schema.ref(:WhoWeAresResponse), example: %{
      data: [
        %{
          our_mission: "this is our mission",
          our_mission_photo: "our_mission.jpg",
          what_we_do: "this is what we do",
          what_we_do_photo: "what_we_do.jpg",
          our_product: "this is our product",
          our_product_photo: "our_product.jpg"
        }
      ]
    }
  end

  def index(conn, _params) do
    who_we_are = Repo.all(WhoWeAre)
    render(conn, "index.json", who_we_are: who_we_are)
  end

  swagger_path(:create) do
    post "/api/v1/who_we_are"
    summary "Create who we are"
    description "Creates a new who we are"
    consumes "application/json"
    produces "application/json"
    parameter :who_we_are, :body, Schema.ref(:WhoWeAreRequest), "The category details", example: %{
      our_mission: "this is our mission",
      our_mission_photo: "our_mission.jpg",
      what_we_do: "this is what we do",
      what_we_do_photo: "what_we_do.jpg",
      our_product: "this is our product",
      our_product_photo: "our_product.jpg"
    }
    response 201, "Who we are created OK", Schema.ref(:WhoWeAreResponse), example: %{
      data: %{
        our_mission: "this is our mission",
        our_mission_photo: "our_mission.jpg",
        what_we_do: "this is what we do",
        what_we_do_photo: "what_we_do.jpg",
        our_product: "this is our product",
        our_product_photo: "our_product.jpg"
      }
    }
  end

  def create(conn, %{"our_mission" => our_mission,
                     "our_mission_photo" => our_mission_photo,
                     "what_we_do" => what_we_do,
                     "what_we_do_photo" => what_we_do_photo,
                     "our_product" => our_product,
                     "our_product_photo" => our_product_photo
              }) do

    if our_mission_photo.filename === nil or what_we_do_photo.filename === nil or our_product_photo.filename === nil do
      json conn, %{data: %{
                     status: 404,
                     message: "please check your image"
        }}
    else
        missionExtension = Path.extname(our_mission_photo.filename)
        missionFilename = "#{UUID.uuid1()}#{missionExtension}"
        File.cp(our_mission_photo.path,  Enum.join(["./uploads/", missionFilename], ""))

        wedoExtension = Path.extname(what_we_do_photo.filename)
        wedoFilename = "#{UUID.uuid1()}#{wedoExtension}"
        File.cp(what_we_do_photo.path,  Enum.join(["./uploads/", wedoFilename], ""))

        productExtension = Path.extname(our_product_photo.filename)
        productFilename = "#{UUID.uuid1()}#{productExtension}"
        File.cp(our_product_photo.path,  Enum.join(["./uploads/", productFilename], ""))

        whoWeAre = %{
          our_mission: our_mission,
          our_mission_photo: missionFilename,
          what_we_do: what_we_do,
          what_we_do_photo: wedoFilename,
          our_product: our_product,
          our_product_photo: productFilename
        }

        changeset = WhoWeAre.changeset(%WhoWeAre{}, whoWeAre)

        case Repo.insert(changeset) do
          {:ok, who_we_are} ->
            conn
            |> put_status(:created)
            |> put_resp_header("location", who_we_are_path(conn, :show, who_we_are))
            |> render("show.json", who_we_are: who_we_are)
          {:error, changeset} ->
            conn
            |> put_status(:unprocessable_entity)
            |> render(TRexRestPhoenix.ChangesetView, "error.json", changeset: changeset)
        end

    end
  end

  def show(conn, %{"id" => id}) do
    who_we_are = Repo.get!(WhoWeAre, id)
    render(conn, "show.json", who_we_are: who_we_are)
  end

  swagger_path(:update) do
     put "/api/v1/categories/{id}"
     summary "Update category"
     description "Update all attributes of a category"
     consumes "application/json"
     produces "application/json"
     parameters do
       id :path, :integer, "Category ID", required: true, example: 3
       user :body, Schema.ref(:WhoWeAreRequest), "The category details", example: %{
         whoWeAre: %{
           our_mission: "this is our mission",
           our_mission_photo: "our_mission.jpg",
           what_we_do: "this is what we do",
           what_we_do_photo: "what_we_do.jpg",
           our_product: "this is our product",
           our_product_photo: "our_product.jpg"
         }
       }
     end
     response 200, "Updated Successfully", Schema.ref(:WhoWeAreResponse), example: %{
       data: %{
         our_mission: "this is our mission",
         our_mission_photo: "our_mission.jpg",
         what_we_do: "this is what we do",
         what_we_do_photo: "what_we_do.jpg",
         our_product: "this is our product",
         our_product_photo: "our_product.jpg"
       }
     }
  end

  def update(conn, %{"id" => id,
                     "our_mission" => our_mission,
                     "our_mission_photo" => our_mission_photo,
                     "what_we_do" => what_we_do,
                     "what_we_do_photo" => what_we_do_photo,
                     "our_product" => our_product,
                     "our_product_photo" => our_product_photo}) do

    if our_mission_photo.filename === nil or what_we_do_photo.filename === nil or our_product_photo.filename === nil do
      json conn, %{data: %{
                      status: 404,
                      message: "please check your image"
                  }}
    else
      missionExtension = Path.extname(our_mission_photo.filename)
      missionFilename = "#{UUID.uuid1()}#{missionExtension}"
      File.cp(our_mission_photo.path,  Enum.join(["./uploads/", missionFilename], ""))

      wedoExtension = Path.extname(what_we_do_photo.filename)
      wedoFilename = "#{UUID.uuid1()}#{wedoExtension}"
      File.cp(what_we_do_photo.path,  Enum.join(["./uploads/", wedoFilename], ""))

      productExtension = Path.extname(our_product_photo.filename)
      productFilename = "#{UUID.uuid1()}#{productExtension}"
      File.cp(our_product_photo.path,  Enum.join(["./uploads/", productFilename], ""))

      whoWeAre = %{
        our_mission: our_mission,
        our_mission_photo: missionFilename,
        what_we_do: what_we_do,
        what_we_do_photo: wedoFilename,
        our_product: our_product,
        our_product_photo: productFilename
      }

      who_we_are = Repo.get!(WhoWeAre, id)
      changeset = WhoWeAre.changeset(who_we_are, whoWeAre)

      case Repo.update(changeset) do
        {:ok, who_we_are} ->
          render(conn, "show.json", who_we_are: who_we_are)
        {:error, changeset} ->
          conn
          |> put_status(:unprocessable_entity)
          |> render(TRexRestPhoenix.ChangesetView, "error.json", changeset: changeset)
      end
    end
  end

  def delete(conn, %{"id" => id}) do
    who_we_are = Repo.get!(WhoWeAre, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(who_we_are)

    send_resp(conn, :no_content, "")
  end
end
