defmodule TRexRestPhoenix.CheckoutView do
  use TRexRestPhoenix.Web, :view

  def render("index.json", %{checkouts: checkouts}) do
    %{data: render_many(checkouts, TRexRestPhoenix.CheckoutView, "checkout.json")}
  end

  def render("show.json", %{checkout: checkout}) do
    %{data: render_one(checkout, TRexRestPhoenix.CheckoutView, "checkout.json")}
  end

  def render("checkout.json", %{checkout: checkout}) do
    %{id: checkout.id,
      account_id: checkout.account_id,
      status: checkout.status}
  end

  def render("detail.json", assigns) do
    %{
      data: %{
        date: assigns.checkout.inserted_at,
        status: assigns.checkout.status,
        profile: %{
          firstname: assigns.profile.firstname,
          lastname: assigns.profile.lastname,
          address: assigns.profile.address,
          photo: assigns.profile.photo,
          id: assigns.profile.account_id,
          phone: assigns.profile.phone,
          email: assigns.account.email
        },
        books: assigns.books 
      }
    }
  end
end
