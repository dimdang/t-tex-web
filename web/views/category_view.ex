defmodule TRexRestPhoenix.CategoryView do
  use TRexRestPhoenix.Web, :view

  def render("index.json", %{categories: categories}) do
    %{data: render_many(categories, TRexRestPhoenix.CategoryView, "category.json")}
  end

  def render("show.json", %{category: category}) do
    %{data: render_one(category, TRexRestPhoenix.CategoryView, "category.json")}
  end

  def render("category.json", %{category: category}) do
    %{id: category.id,
      name: category.name,
      description: category.description,
      status: category.status}
  end
end
