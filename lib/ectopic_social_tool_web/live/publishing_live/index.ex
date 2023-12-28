defmodule EctopicSocialToolWeb.PublishingLive.Index do
  use EctopicSocialToolWeb, :live_view
  alias EctopicSocialTool.Publishers

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(social_account: nil)
      |> assign(form: nil)

    {:ok, socket}
  end

  def handle_event("publish", %{"published_content" => published_content}, socket) do
    IO.inspect(published_content, label: "published_content")
    {:noreply, socket |> put_flash(:info, "Your post is publishing...")}
    # case Publishers.enqueue_job(
    #        socket.assigns.social_account,
    #        socket.assigns.current_user,
    #        published_content,
    #        nil
    #      ) do
    #   {:ok, true} ->
    #     {:noreply, socket |> put_flash(:info, "Your post is publishing...")}

    #   {:error, failed_operation} ->
    #     {:noreply,
    #      socket |> put_flash(:error, "Error while publishing your post: #{failed_operation}")}
    # end
  end

  def handle_event("validate", %{"_target" => ["is_scheduled_post"]} = params, socket) do
    # form_params = deal_with_html_form_encoding_shortcomings(params)
    IO.inspect(params)
    published_content = params |> Map.get("published_content")

    case params["published_content"]["is_scheduled_post"] do
      nil ->
        form =
          to_form(published_content |> Map.put_new("is_scheduled_post", true),
            as: "published_content"
          )

        IO.inspect(form, label: "form1")
        {:noreply, socket |> assign(form: form)}

      _ ->
        form =
          to_form(
            %{published_content | is_scheduled_post: true},
            as: "published_content"
          )

        IO.inspect(form, label: "form2")
        {:noreply, socket |> assign(form: form)}
    end
  end

  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  # defp deal_with_html_form_encoding_shortcomings(params) do
  #   # Work around the fact that no selection submits no data
  #   params |> Map.get("form", %{}) |> Map.put_new("is_scheduled_post", true)
  # end

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
