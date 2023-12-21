defmodule EctopicSocialToolWeb.PublishingLive.Index do
  use EctopicSocialToolWeb, :live_view
  alias EctopicSocialTool.Publishers

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

  def handle_event("publish", %{"provider" => provider}, socket) do
    Publishers.enqueue_job(provider)
    {:noreply, socket |> put_flash(:info, "Your post is publishing...")}
  end
end
