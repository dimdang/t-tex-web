defmodule TRexRestPhoenix.CheckoutView do
  use TRexRestPhoenix.Web, :view

  def render("index.json", %{checkouts: checkouts}) do
    %{data: render_many(checkouts, TRexRestPhoenix.CheckoutView, "checkout.json")}
  end

  def render("show.json", %{checkout: checkout}) do
    %{data: render_one(checkout, TRexRestPhoenix.CheckoutView, "checkout.json")}
  end

  def render("checkout.json", %{checkout: checkout}) do
    %{
      id: checkout.id,
      account_id: checkout.account_id,
      inserted_at: checkout.inserted_at
    }
  end

  def render("detail.json", assigns) do
    %{data:
        %{
            date: assigns.checkout.inserted_at,
            profile:  %{
                          status: assigns.profile.status,
                          photo:  assigns.profile.status,
                          lastname: assigns.profile.lastname,
                          firstname: assigns.profile.firstname,
                          address: assigns.profile.address,
                          id: assigns.profile.account_id,
                          email: assigns.account.email
                        },
            books: assigns.books,
            status:   200,
            message:  "data found!"
          }
      }
  end

end
