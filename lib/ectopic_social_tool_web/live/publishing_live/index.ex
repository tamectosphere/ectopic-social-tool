defmodule EctopicSocialToolWeb.PublishingLive.Index do
  use EctopicSocialToolWeb, :live_view
  alias EctopicSocialTool.Publishers

  def mount(_params, _session, socket) do
    form =
      to_form(%{"content" => nil}, as: "publisher")

    socket =
      socket
      |> assign(social_account: nil)
      |> assign(form: form)

    {:ok, socket, temporary_assigns: [form: form]}
  end

  def handle_event("publish", %{"publisher" => %{"content" => content}}, socket) do
    IO.inspect(content, label: "content")
    IO.inspect(socket.assigns, label: "socket")
    {:noreply, socket}
    # Publishers.enqueue_job(provider)
    # {:noreply, socket |> put_flash(:info, "Your post is publishing...")}
  end

  def handle_info({:selected_account, social_account}, socket) do
    {:noreply, socket |> assign(social_account: social_account)}
  end
end
