defmodule EctopicSocialToolWeb.PublishingLive.Components.UserPostsList do
  use EctopicSocialToolWeb, :live_component

  alias EctopicSocialTool.Posts

  def render(assigns) do
    ~H"""
    <div id={@id}>
      <div class="h-48 sm:h-64 md:h-96 lg:h-full flex flex-col justify-between">
        <div class="overflow-x-auto">
          <table class="table">
            <!-- head -->
            <thead>
              <tr>
                <th></th>
                <th>ID</th>
                <th>Type</th>
                <th>Scheduled At</th>
                <th>Status</th>
                <th>Create at</th>
                <th></th>
              </tr>
            </thead>
            <tbody phx-update="stream" id="user-posts-stream">
              <tr :for={{dom_id, user_post} <- @streams.user_posts} id={dom_id}>
                <td>
                  <button
                    phx-target={@myself}
                    phx-click="refresh"
                    phx-value-user_post_id={user_post.user_post_id}
                    phx-throttle="3000"
                  >
                    <.icon name="hero-arrow-path-mini" class="h-5 w-5" />
                  </button>
                </td>
                <th><%= user_post.id %></th>
                <td><%= user_post.type %></td>
                <td>
                  <div
                    id={"scheduled_at-#{dom_id}"}
                    phx-hook="ConvertDateTime"
                    data-utc-datetime={user_post.scheduled_at}
                  >
                  </div>
                </td>
                <td>
                  <%= if user_post.status === :pending do %>
                    pending
                  <% else %>
                    <%= user_post.status %> at
                    <div
                      id={"completed_at-#{dom_id}"}
                      phx-hook="ConvertDateTime"
                      data-utc-datetime={user_post.completed_at}
                    >
                    </div>
                  <% end %>
                </td>
                <td>
                  <div
                    id={"inserted_at-#{dom_id}"}
                    phx-hook="ConvertDateTime"
                    data-utc-datetime={user_post.inserted_at}
                  >
                  </div>
                </td>
                <td :if={user_post.status == :completed}>
                  <a href={user_post.post_link} target="_blank" class="btn btn-link">
                    <span>go to post <.icon name="hero-arrow-up-right-mini" class="h-5 w-5" /></span>
                  </a>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
        <button
          :if={!@end_of_timeline?}
          class="btn btn-link"
          phx-target={@myself}
          phx-click="load-more"
        >
          Load more
        </button>
      </div>
    </div>
    """
  end

  def update(assign, socket) do
    case assign.new_item do
      nil ->
        {:ok,
         socket
         |> assign(:id, assign.id)
         |> assign(:current_user, assign.current_user)
         |> assign(:social_account, assign.social_account)
         |> paginate_user_posts(:init)}

      new_item ->
        {:ok,
         stream_insert(
           socket,
           :user_posts,
           new_item,
           at: 0
         )}
    end
  end

  def handle_event("load-more", _, socket) do
    {:noreply, paginate_user_posts(socket, socket.assigns.cursor, :after)}
  end

  def handle_event("refresh", %{"user_post_id" => user_post_id}, socket) do
    user_post = String.to_integer(user_post_id) |> Posts.get_transform_user_post()

    {:noreply,
     stream_insert(
       socket,
       :user_posts,
       user_post
     )}
  end

  defp paginate_user_posts(socket, :init) do
    %{entries: entries, metadata: metadata} =
      Posts.get_user_posts_cursor(
        socket.assigns.current_user.id,
        socket.assigns.social_account["id"]
      )

    case metadata.after do
      nil ->
        socket
        |> assign(end_of_timeline?: true)
        |> assign(:cursor, nil)
        |> stream(:user_posts, entries)

      after_cursor ->
        socket
        |> assign(end_of_timeline?: false)
        |> assign(:before, nil)
        |> assign(:cursor, after_cursor)
        |> stream(:user_posts, entries)
    end
  end

  defp paginate_user_posts(socket, cursor, :after) do
    %{entries: entries, metadata: metadata} =
      Posts.get_user_posts_cursor(
        socket.assigns.current_user.id,
        socket.assigns.social_account["id"],
        cursor,
        :after
      )

    case metadata.after do
      nil ->
        socket
        |> assign(end_of_timeline?: true)
        |> assign(:before, nil)
        |> assign(:cursor, nil)
        |> stream(:user_posts, entries)

      after_cursor ->
        socket
        |> assign(end_of_timeline?: false)
        |> assign(:before, nil)
        |> assign(:cursor, after_cursor)
        |> stream(:user_posts, entries)
    end
  end
end
