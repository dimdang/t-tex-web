defmodule TRexRestPhoenix.AccountView do
  use TRexRestPhoenix.Web, :view

  def render("index.json", %{accounts: accounts}) do
    %{data: render_many(accounts, TRexRestPhoenix.AccountView, "account.json")}
  end

  def render("show.json", %{account: account}) do
    %{data: render_one(account, TRexRestPhoenix.AccountView, "account.json")}
  end

  def render("account.json", %{account: account}) do
    %{id: account.id,
      email: account.email,
      role: account.role,
      status: account.status,
      inserted_at: account.inserted_at}
  end
end
