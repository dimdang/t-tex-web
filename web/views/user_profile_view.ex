defmodule TRexRestPhoenix.UserProfileView do
  use TRexRestPhoenix.Web, :view

  def render("index.json", %{user_profile: user_profile}) do
    %{data: render_many(user_profile, TRexRestPhoenix.UserProfileView, "user_profile.json")}
  end

  def render("show.json", %{user_profile: user_profile}) do
    %{data: render_one(user_profile, TRexRestPhoenix.UserProfileView, "user_profile.json")}
  end

  def render("user_profile.json", %{user_profile: user_profile}) do
    %{id: user_profile.id,
      firstname: user_profile.firstname,
      lastname: user_profile.lastname,
      address: user_profile.address,
      photo: user_profile.photo,
      status: user_profile.status,
      phone: user_profile.phone,
      account_id: user_profile.account_id}
  end
end
