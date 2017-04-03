defmodule TRexRestPhoenix.AccountController do
  use TRexRestPhoenix.Web, :controller
  import Comeonin.Bcrypt
  import Ecto.Changeset

  alias TRexRestPhoenix.Account
  alias TRexRestPhoenix.UserProfile

  def index(conn, _params) do

    accounts = Repo.all(from account in Account, where: account.status == true)

    render(conn, "index.json", accounts: accounts)
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

  def show(conn, %{"id" => id}) do
    account = Repo.get!(Account, id)
    render(conn, "show.json", account: account)
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
