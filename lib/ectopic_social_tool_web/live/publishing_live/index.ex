defmodule EctopicSocialToolWeb.PublishingLive.Index do
  use EctopicSocialToolWeb, :live_view
  alias EctopicSocialTool.Publishers

  def mount(_params, _session, socket) do
    form =
      to_form(%{"content" => nil}, as: "published_content")

    socket =
      socket
      |> assign(social_account: nil)
      |> assign(form: form)

    {:ok, socket, temporary_assigns: [form: form]}
  end

  def handle_event("publish", %{"published_content" => published_content}, socket) do
    Publishers.enqueue_job(
      socket.assigns.social_account,
      socket.assigns.current_user,
      published_content
    )

    {:noreply, socket |> put_flash(:info, "Your post is publishing...")}
  end

  def handle_info({:selected_account, social_account}, socket) do
    {:noreply, socket |> assign(social_account: social_account)}
  end
end
