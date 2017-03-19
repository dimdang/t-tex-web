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
      account_id: checkout.account_id}
  end
end
