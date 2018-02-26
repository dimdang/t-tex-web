defmodule TRexRestPhoenix.BookTest do
  use TRexRestPhoenix.ModelCase

  alias TRexRestPhoenix.Book

  @valid_attrs %{author_id: 42, author_name: "some content", book_dimensions: "some content", category_id: 42, description: "some content", image: "some content", is_feature: true, isbn: "some content", language: "some content", page_count: "some content", price: "120.5", published_year: "some content", publisher_name: "some content", shipping_weight: "120.5", status: 42, title: "some content", unit: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Book.changeset(%Book{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Book.changeset(%Book{}, @invalid_attrs)
    refute changeset.valid?
  end
end
