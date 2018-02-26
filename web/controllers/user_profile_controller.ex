defmodule TRexRestPhoenix.UserProfileController do
  use TRexRestPhoenix.Web, :controller

  alias TRexRestPhoenix.UserProfile
  use PhoenixSwagger

  def swagger_definitions do
    %{
      UserProfile: swagger_schema do
        title "User Profile"
        description "A user profile"
        properties do
           firstname :string, "user firstname", required: true
           lastname :string, "user lastname", required: true
           address :string, "user address", required: true
           photo :string, "user photo", required: true
           status :boolean, "user status", required: true
           phone :string, "user phone number", required: true
           account_id :integer, "user account id", required: true
        end
        example %{
          firstname: "DK",
          lastname: "Kelvin",
          address: "Phnom Penh",
          photo: "myphoto.jpg",
          status: true,
          phone: "097878789",
          account_id: 1
        }
      end,
      UserProfileRequest: swagger_schema do
        title "User profile Request"
        description "Post body for creating a user profile"
        property :userprofile, Schema.ref(:UserProfile), "The user profile details"
      end,
      UserProfileResponse: swagger_schema do
        title "User profile response"
        description "Response schema for single user profile"
        property :data, Schema.ref(:UserProfile), "The user profile details"
      end,
      UserProfilesResponse: swagger_schema do
        title "User profile response"
        description "Response schema for multiple user profile"
        property :data, Schema.array(:UserProfile), "The user profile details"
      end
    }
  end

  swagger_path(:index) do
    get "/api/v1/user_profile"
    summary "List all user profile"
    description "List all user profile in the database"
    produces "application/json"
    response 200, "OK", Schema.ref(:UserProfilesResponse), example: %{
      data: [
        %{firstname: "DK", lastname: "Kelvin", address: "Phnom Penh", photo: "myphoto.jpg", phone: "093433232", status: true, account_id: 1},
        %{firstname: "DK", lastname: "Kelvin", address: "Phnom Penh", photo: "myphoto.jpg", phone: "093433232", status: true, account_id: 1}
      ]
    }
  end

  def index(conn, _params) do
    user_profile = Repo.all(UserProfile)
    render(conn, "index.json", user_profile: user_profile)
  end

  swagger_path(:create) do
    post "/api/v1/user_profile"
    summary "Create user profile"
    description "Creates a new user profile"
    consumes "application/json"
    produces "application/json"
    parameter :userprofile, :body, Schema.ref(:UserProfileRequest), "The category details", example: %{firstname: "DK", lastname: "Kelvin", address: "Phnom Penh", photo: "myphoto.jpg", phone: "093433232", status: true, account_id: 1}
    response 201, "user profile created OK", Schema.ref(:UserProfileResponse), example: %{
      data: %{firstname: "DK", lastname: "Kelvin", address: "Phnom Penh", photo: "myphoto.jpg", phone: "093433232", status: true, account_id: 1}
    }
  end

  def create(conn, %{"firstname" => firstname,
                     "lastname" => lastname,
                     "address" => address,
                     "photo" => photo,
                     "phone" => phone,
                     "account_id" => account_id}) do
     if photo.filename === nil do
       json conn, %{data: %{
                      status: 404,
                      message: "please check your image"
         }}
     else
       extension = Path.extname(photo.filename)
       filename = "#{UUID.uuid1()}#{extension}"
       File.cp(photo.path,  Enum.join(["./uploads/", filename], ""))
       profile = %{
           firstname: firstname,
           lastname: lastname,
           address: address,
           photo: filename,
           status: true,
           phone: phone,
           account_id: account_id
       }

       changeset = UserProfile.changeset(%UserProfile{}, profile)

       case Repo.insert(changeset) do
         {:ok, profile} ->
           conn
           |> put_status(:created)
           |> put_resp_header("location", user_profile_path(conn, :show, profile))
           |> render("show.json", user_profile: profile)
         {:error, changeset} ->
           conn
           |> put_status(:unprocessable_entity)
           |> render(TRexRestPhoenix.ChangesetView, "error.json", changeset: changeset)
       end
     end
   end

   swagger_path(:show) do
     get "/api/v1/user_profile/{id}"
     summary "Show user profile"
     description "Show a user profile by ID"
     produces "application/json"
     parameter :id, :path, :integer, "user profile ID", required: true, example: 1
     response 200, "OK", Schema.ref(:UserProfileResponse), example: %{
       data:  %{
         firstname: "DK",
         lastname: "Kelvin",
         address: "Phnom Penh",
         photo: "myphoto.jpg",
         status: true,
         phone: "097878789",
         account_id: 1
       }
     }
   end

  def show(conn, %{"id" => id}) do
    user_profile = Repo.get!(UserProfile, id)
    render(conn, "show.json", user_profile: user_profile)
  end

  swagger_path(:update) do
     put "/api/v1/user_profile/{id}"
     summary "Update user profile"
     description "Update all attributes of a user profile"
     consumes "application/json"
     produces "application/json"
     parameters do
       id :path, :integer, "user profile ID", required: true, example: 3
       user :body, Schema.ref(:UserProfileRequest), "The user profile details", example: %{
         userprofile: %{
           firstname: "DK",
           lastname: "Kelvin",
           address: "Phnom Penh",
           photo: "myphoto.jpg",
           status: true,
           phone: "097878789",
           account_id: 1
         }
       }
     end
     response 200, "Updated Successfully", Schema.ref(:UserProfileResponse), example: %{
       data: %{
         firstname: "DK",
         lastname: "Kelvin",
         address: "Phnom Penh",
         photo: "myphoto.jpg",
         status: true,
         phone: "097878789",
         account_id: 1
       }
     }
  end

  def update(conn, %{"id" => id,
                     "firstname" => firstname,
                     "lastname" => lastname,
                     "address" => address,
                     "photo" => photo,
                     "phone" => phone,
                     "account_id" => account_id}) do

    if photo.filename === nil do
      json conn, %{data: %{
                     status: 404,
                     message: "please check your image"
        }}
    else
      extension = Path.extname(photo.filename)
      filename = "#{UUID.uuid1()}#{extension}"
      File.cp(photo.path,  Enum.join(["./uploads/", filename], ""))

      profile = %{
          firstname: firstname,
          lastname: lastname,
          address: address,
          photo: filename,
          status: true,
          phone: phone,
          account_id: account_id
      }

      user_profile = Repo.get!(UserProfile, id)
      changeset = UserProfile.changeset(user_profile, profile)

      case Repo.update(changeset) do
        {:ok, user_profile} ->
          render(conn, "show.json", user_profile: user_profile)
        {:error, changeset} ->
          conn
          |> put_status(:unprocessable_entity)
          |> render(TRexRestPhoenix.ChangesetView, "error.json", changeset: changeset)
      end
    end
  end

  swagger_path(:delete) do
    get "/api/v1/user_profile/{id}"
    summary "Delete user profile"
    description "Delete a user profile by ID"
    parameter :id, :path, :integer, "user profile ID", required: true, example: 4
    response 203, "No Content - Deleted Successfully"
  end

  def delete(conn, %{"id" => id}) do
    user_profile = Repo.get!(UserProfile, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(user_profile)

    send_resp(conn, :no_content, "")
  end
end
