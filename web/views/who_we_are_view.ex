defmodule TRexRestPhoenix.WhoWeAreView do
  use TRexRestPhoenix.Web, :view

  def render("index.json", %{who_we_are: who_we_are}) do
    %{data: render_many(who_we_are, TRexRestPhoenix.WhoWeAreView, "who_we_are.json")}
  end

  def render("show.json", %{who_we_are: who_we_are}) do
    %{data: render_one(who_we_are, TRexRestPhoenix.WhoWeAreView, "who_we_are.json")}
  end

  def render("who_we_are.json", %{who_we_are: who_we_are}) do
    %{id: who_we_are.id,
      our_mission: who_we_are.our_mission,
      our_mission_photo: who_we_are.our_mission_photo,
      what_we_do: who_we_are.what_we_do,
      what_we_do_photo: who_we_are.what_we_do_photo,
      our_product: who_we_are.our_product,
      our_product_photo: who_we_are.our_product_photo}
  end
end
