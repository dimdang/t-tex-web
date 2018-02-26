defmodule TRexRestPhoenix.Email do
  use Bamboo.Phoenix, view: TRexRestPhoenix.EmailView
  import Bamboo.Email

  def welcome(email) do
    new_email
    |> to(email)
    |> from("2nt.book.store@gmail.com")
    |> subject("Welcome to Book store")
    |> html_body("
        <body>
          <p>Dear customer,</p>
          <br/>
          <p>Congradulation! you are now become our book store member</p>
          <br/>
          <p>Warm Regard,</p>
          <br/>
          <p>book store team</p>
        </body>
    ")
  end

  def checkout(email, book) do
    new_email
    |> to(email)
    |> from("2nt.book.store@gmail.com")
    |> subject("Add to cart success")
    |> html_body("
       <body>
       <p>Dear customer, </p>
       <br/>
       <p>Your book <strong>" <> book.title <>
       "</strong> has been add to your cart. please checkout to get it." <>
       "</p>
       <p>Warm Regard,</p>
       <br/>
       <p>book store team</p>
       </body>
    ")
  end
end
