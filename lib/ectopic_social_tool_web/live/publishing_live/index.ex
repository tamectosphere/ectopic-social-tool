defmodule EctopicSocialToolWeb.PublishingLive.Index do
  use EctopicSocialToolWeb, :live_view

  # def render(assigns) do
  #   ~H"""
  #   <.header class="text-center">
  #     Log in
  #     <.ectopic_button phx-click="testToast" class="w-full animate-none">
  #       Create an account
  #     </.ectopic_button>
  #   </.header>
  #   """
  # end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_event("testToast", _params, socket) do
    {:noreply, socket |> put_flash(:success, "It worked!")}
  end

  def handle_event("testToast2", _params, socket) do
    {:noreply, socket |> put_flash(:success, "It worked!")}
  end
end
