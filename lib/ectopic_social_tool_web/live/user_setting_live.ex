defmodule EctopicSocialToolWeb.UserSettingLive do
  use EctopicSocialToolWeb, :live_view

  def render(assigns) do
    ~H"""
    <.header class="text-center">
      User Setting
    </.header>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
