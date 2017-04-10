defmodule TRexRestPhoenix.Email do
  use Bamboo.Phoenix, view: TRexRestPhoenix.EmailView
  import Bamboo.Email

  def welcome(email) do
    new_email
    |> to("kuylim.tith@gmail.com")
    |> from("2nt.book.store@gmail.com")
    |> subject("Welcome to Book store")
    |> text_body("You are become book store member")
  end
end
