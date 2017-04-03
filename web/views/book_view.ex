defmodule TRexRestPhoenix.BookView do
  use TRexRestPhoenix.Web, :view

  def render("index.json", %{books: books}) do
    %{data: render_many(books, TRexRestPhoenix.BookView, "book.json")}
  end

  def render("show.json", %{book: book}) do
    %{data: render_one(book, TRexRestPhoenix.BookView, "book.json")}
  end

  def render("book.json", %{book: book}) do
    %{id: book.id,
      title: book.title,
      isbn: book.isbn,
      price: book.price,
      unit: book.unit,
      publisher_name: book.publisher_name,
      published_year: book.published_year,
      page_count: book.page_count,
      language: book.language,
      shipping_weight: book.shipping_weight,
      book_dimensions: book.book_dimensions,
      status: book.status,
      image: book.image,
      description: book.description,
      author_name: book.author_name,
      category_id: book.category_id,
      author_id: book.author_id}
  end
end
