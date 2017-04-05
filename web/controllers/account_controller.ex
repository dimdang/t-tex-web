defmodule TRexRestPhoenix.AccountController do
  use TRexRestPhoenix.Web, :controller
  import Comeonin.Bcrypt
  import Ecto.Changeset

  alias TRexRestPhoenix.Account
  alias TRexRestPhoenix.UserProfile
  use PhoenixSwagger

  def swagger_definitions do
    %{
      Account: swagger_schema do
        title "Account"
        description "A account for register"
        properties do
          email :string, "Account email", required: true
          password :string, "Account password", required: true
          role :integer, "Account role", required: true
          status :boolean, "Account status", required: true
        end
        example %{
          email: "mail@mail.com",
          password: "1234578",
          role: 1,
          status: true
        }
      end,
      AccountRequest: swagger_schema do
        title "Account Request"
        description "Post boday for creating a account"
        property :account, Schema.ref(:Account), "The account details"
      end,
      AccountResponse: swagger_schema do
        title "Account Response"
        description "Response schema for single account"
        property :data, Schema.ref(:Account), "The account details"
      end,
      AccountsResponse: swagger_schema do
        title "Accounts Response"
        description "Response schema for multiple accounts"
        property :data, Schema.array(:Account), "The account details"
      end
    }
  end

  swagger_path(:index) do
    get "/api/v1/accounts"
    summary "List all account"
    description "List all account in the database"
    produces "application/json"
    response 200, "OK", Schema.ref(:AccountResponse), example: %{
      data: [
        %{email: "mail@mail.com", role: 1, status: true},
        %{email: "gmail@gmail.com", role: 1, status: true}
      ]
    }
  end

  def index(conn, _params) do

    accounts = Repo.all(from account in Account, where: account.status == true)

    render(conn, "index.json", accounts: accounts)
  end

  swagger_path(:login) do
    post "/api/v1/login"
    summary "User login"
    description "User login with email"
    consumes "application/json"
    produces "application/json"
    parameter :category, :body, Schema.ref(:AccountRequest), "The account details", example: %{
      account: %{email: "mail@mail.com", password: "12345678"}
    }
    response 200, "Login successfully!", Schema.ref(:AccountsResponse), example: %{
      data: %{token: "2we4YUIOcop09mguy=", role: 1, firstname: "xxx", lastname: "xxx", isprofile: 1, email: "xxx@mail.com"}
    }
  end

  # user login
  def login(conn, %{"account" => account_params})do
    changeset = Account.changeset(%Account{}, account_params)

    account = Repo.get_by(Account, email: changeset.params["email"], status: true)

    if account === nil do
      json conn, %{data: %{
          status: 400,
          message: "This account was disable. please register with other account"
        }}
    else

      profile = Repo.get_by(UserProfile, account_id: account.id)

      case authenticate(account, changeset.params["password"]) do
        true ->
          case profile do
            nil -> json conn, %{data: %{
                      status: 200,
                      message: "login success",
                      token: "dC1yZXg6dC1yZXhAMm50JUVsaXhpcjk=",
                      id: account.id,
                      email: account.email,
                      role: account.role,
                      isprofile: 0
              }}
              _ -> json conn,%{data: %{
                      status: 200,
                      message: "login success",
                      firstname: profile.firstname,
                      lastname: profile.lastname,
                      id: account.id,
                      email: account.email,
                      role: account.role,
                      token: "dC1yZXg6dC1yZXhAMm50JUVsaXhpcjk=",
                      isprofile: 1
              }}
          end

          _  -> json conn, %{data: %{
                      status: 404,
                      message: "Password or email didn't match",
                      token: ""
              }}
      end
    end
  end

  # verify password
  defp authenticate(account, password) do
    case account do
      nil -> false
      _   -> checkpw(password, account.password)
    end
  end

  swagger_path(:create) do
    post "/api/v1/accounts"
    summary "Create account"
    description "Creates a new account"
    consumes "application/json"
    produces "application/json"
    parameter :account, :body, Schema.ref(:AccountRequest), "The account details", example: %{
      category: %{email: "xxx@mail.com", password: "12345678", role: 1, status: true}
    }
    response 201, "Category created OK", Schema.ref(:AccountResponse), example: %{
      data: %{email: "xxx@gmail.com", role: 1, status: true}
    }
  end

  def create(conn, %{"account" => account_params}) do
    changeset = Account.changeset(%Account{}, account_params)

    account = Repo.get_by(Account, email: changeset.params["email"])

    case account do
      nil ->
        data = changeset
        |> put_change(:password, hashpwsalt(changeset.params["password"]))

        case Repo.insert(data) do
        {:ok, account} ->
          conn
          |> put_status(:created)
          |> put_resp_header("location", account_path(conn, :show, account))
          |> render("show.json", account: account)
        {:error, changeset} ->
          conn
          |> put_status(:unprocessable_entity)
          |> render(TRexRestPhoenix.ChangesetView, "error.json", changeset: changeset)
      end
      _ ->
        json conn , %{ data: %{
            message: "Your email already register with our system",
            status: 400
          }
        }
    end
  end

  swagger_path(:show) do
    get "/api/v1/accounts/{id}"
    summary "Show account"
    description "Show a account by ID"
    produces "application/json"
    parameter :id, :path, :integer, "account ID", required: true, example: 1
    response 200, "OK", Schema.ref(:AccountResponse), example: %{
      data:  %{email: "xxx@mail.com", role: 1, status: true}
    }
  end

  def show(conn, %{"id" => id}) do
    account = Repo.get!(Account, id)
    render(conn, "show.json", account: account)
  end

  swagger_path(:update) do
     put "/api/v1/accounts/{id}"
     summary "Update account"
     description "Update all attributes of a account"
     consumes "application/json"
     produces "application/json"
     parameters do
       id :path, :integer, "account ID", required: true, example: 3
       user :body, Schema.ref(:AccountRequest), "The account details", example: %{
         account: %{email: "xxx@gmail.com", password: "12345678", role: 1, status: true}
       }
     end
     response 200, "Updated Successfully", Schema.ref(:AccountResponse), example: %{
       data: %{email: "xxx@gmail.com", role: 1, status: true}
     }
  end

  def update(conn, %{"id" => id, "account" => account_params}) do
    account = Repo.get!(Account, id)
    changeset = Account.changeset(account, account_params)

    case Repo.update(changeset) do
      {:ok, account} ->
        render(conn, "show.json", account: account)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(TRexRestPhoenix.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    account = Repo.get!(Account, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(account)

    send_resp(conn, :no_content, "")
  end
end
