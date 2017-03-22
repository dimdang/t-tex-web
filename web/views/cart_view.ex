defmodule TRexRestPhoenix.CartView do
  use TRexRestPhoenix.Web, :view

  def render("index.json", %{carts: carts}) do
    %{data: render_many(carts, TRexRestPhoenix.CartView, "cart.json")}
  end

  def render("show.json", %{cart: cart}) do
    %{data: render_one(cart, TRexRestPhoenix.CartView, "cart.json")}
  end

  def render("cart.json", %{cart: cart}) do
    %{id: cart.id,
      price: cart.price,
      unit: cart.unit,
      status: cart.status,
      account_id: cart.account_id,
      book_id: cart.book_id}
  end

  def render("book_in_cart.json", assigns) do
    %{data:
        %{
          books: assigns.books
        },
      status: 200,
      message: "data found!"
    }
  end
end
