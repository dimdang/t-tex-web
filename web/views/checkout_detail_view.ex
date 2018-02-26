defmodule TRexRestPhoenix.CheckoutDetailView do
  use TRexRestPhoenix.Web, :view

  def render("index.json", %{checkout_detail: checkout_detail}) do
    %{data: render_many(checkout_detail, TRexRestPhoenix.CheckoutDetailView, "checkout_detail.json")}
  end

  def render("show.json", %{checkout_detail: checkout_detail}) do
    %{data: render_one(checkout_detail, TRexRestPhoenix.CheckoutDetailView, "checkout_detail.json")}
  end

  def render("checkout_detail.json", %{checkout_detail: checkout_detail}) do
    %{id: checkout_detail.id,
      unit: checkout_detail.unit,
      price: checkout_detail.price,
      checkout_id: checkout_detail.checkout_id,
      book_id: checkout_detail.book_id}
  end
end
