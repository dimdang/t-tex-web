defmodule TRexRestPhoenix.BookControllerTest do
  use TRexRestPhoenix.ConnCase

  alias TRexRestPhoenix.Book
  @valid_attrs %{author_id: 42, book_dimensions: "some content", category_id: 42, image: "some content", isbn: "some content", language: "some content", page_count: "some content", price: "120.5", published_year: "some content", publisher_name: "some content", shipping_weight: "120.5", status: 42, title: "some content", unit: 42}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, book_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    book = Repo.insert! %Book{}
    conn = get conn, book_path(conn, :show, book)
    assert json_response(conn, 200)["data"] == %{"id" => book.id,
      "title" => book.title,
      "isbn" => book.isbn,
      "price" => book.price,
      "unit" => book.unit,
      "publisher_name" => book.publisher_name,
      "published_year" => book.published_year,
      "page_count" => book.page_count,
      "language" => book.language,
      "shipping_weight" => book.shipping_weight,
      "book_dimensions" => book.book_dimensions,
      "status" => book.status,
      "image" => book.image,
      "category_id" => book.category_id,
      "author_id" => book.author_id}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, book_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, book_path(conn, :create), book: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Book, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, book_path(conn, :create), book: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    book = Repo.insert! %Book{}
    conn = put conn, book_path(conn, :update, book), book: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Book, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    book = Repo.insert! %Book{}
    conn = put conn, book_path(conn, :update, book), book: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    book = Repo.insert! %Book{}
    conn = delete conn, book_path(conn, :delete, book)
    assert response(conn, 204)
    refute Repo.get(Book, book.id)
  end
end
