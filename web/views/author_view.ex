defmodule TRexRestPhoenix.AuthorView do
  use TRexRestPhoenix.Web, :view

  def render("index.json", %{authors: authors}) do
    %{data: render_many(authors, TRexRestPhoenix.AuthorView, "author.json")}
  end

  def render("show.json", %{author: author}) do
    %{data: render_one(author, TRexRestPhoenix.AuthorView, "author.json")}
  end

  def render("author.json", %{author: author}) do
    %{id: author.id,
      firstname: author.firstname,
      lastname: author.lastname,
      description: author.description,
      photo: author.photo,
      status: author.status}
  end
end
