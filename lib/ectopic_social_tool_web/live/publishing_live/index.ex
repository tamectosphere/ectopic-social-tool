defmodule EctopicSocialToolWeb.PublishingLive.Index do
  use EctopicSocialToolWeb, :live_view
  alias EctopicSocialTool.Publishers
  alias EctopicSocialToolWeb.PublishingLive.Components.UserPostsList

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(social_account: nil)
      |> assign(form: nil)

    {:ok, socket}
  end

  def handle_event("publish", %{"published_content" => published_content}, socket) do
    case Publishers.enqueue_job(
           socket.assigns.social_account,
           socket.assigns.current_user,
           published_content
         ) do
      {:ok, new_post} ->
        socket =
          push_event(socket, "close-modal", %{
            id: "create-post-button"
          })
          |> push_event("scroll-to", %{
            id: "create-post-button"
          })
          |> assign(form: build_form(socket.assigns.social_account["provider_name"]))

        send_update(UserPostsList,
          id: "user-posts-list",
          social_account: socket.assigns.social_account,
          current_user: socket.assigns.current_user,
          new_item: new_post
        )

        {:noreply, socket |> put_flash(:info, "Your post is publishing...")}

      {:error, failed_operation} ->
        {:noreply,
         socket |> put_flash(:error, "Error while publishing your post: #{failed_operation}")}
    end
  end

  def handle_info({:selected_account, social_account}, socket) do
    socket =
      socket
      |> assign(social_account: social_account)
      |> assign(form: build_form(social_account["provider_name"]))

    {:noreply, socket}
  end

  defp build_form("linkedin") do
    to_form(
      %{"is_scheduled_post" => false, "scheduled_at" => nil, "text" => nil, "visibility" => nil},
      as: "published_content"
    )
  end
end
