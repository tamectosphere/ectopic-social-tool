defmodule EctopicSocialToolWeb.Components.SocialAccountsModal do
  use EctopicSocialToolWeb, :live_component

  alias EctopicSocialTool.SocialAccounts

  def render(assigns) do
    ~H"""
    <div id={@id}>
      <div class="overflow-y-scroll h-46 sm:h-64 md:h-96 lg:h-full flex flex-col justify-between">
        <ul class="scroll-content space-y-4" id="social-accounts" phx-update="stream">
          <li
            :for={{dom_id, social_accounts} <- @streams.social_accounts}
            }
            id={dom_id}
            class="py-2 px-4 flex justify-between items-center"
          >
            <text><%= social_accounts.provider_name %> - <%= social_accounts.title %></text>
            <.ectopic_button
              phx-target={@myself}
              phx-click={
                JS.push("select", value: %{social_accounts: social_accounts})
                |> hide_modal("confirm-modal")
              }
            >
              select
            </.ectopic_button>
          </li>
        </ul>
      </div>
      <.ectopic_button
        :if={!@end_of_timeline?}
        class="w-50 justify-center"
        phx-click="after-social-accounts-page"
      >
        🎉 Load more 🎉
      </.ectopic_button>
    </div>
    """
  end

  def update(assign, socket) do
    {:ok,
     socket
     |> assign(:id, assign.id)
     |> assign(:current_user, assign.current_user)
     |> paginate_social_accounts(:init)}
  end

  def handle_event("select", %{"social_accounts" => social_account}, socket) do
    send(self(), {:selected_account, social_account})
    {:noreply, socket}
  end

  def handle_event("after-social-accounts-page", _, socket) do
    {:noreply, paginate_social_accounts(socket, socket.assigns.cursor, :after)}
  end

  defp paginate_social_accounts(socket, :init) do
    %{entries: entries, metadata: metadata} =
      SocialAccounts.get_social_accounts_cursor(socket.assigns.current_user.id)

    case metadata.after do
      nil ->
        socket
        |> assign(end_of_timeline?: true)
        |> assign(:cursor, nil)
        |> stream(:social_accounts, entries)

      after_cursor ->
        socket
        |> assign(end_of_timeline?: false)
        |> assign(:before, nil)
        |> assign(:cursor, after_cursor)
        |> stream(:social_accounts, entries)
    end
  end

  defp paginate_social_accounts(socket, cursor, :after) do
    %{entries: entries, metadata: metadata} =
      SocialAccounts.get_social_accounts_cursor(socket.assigns.current_user.id, cursor, :after)

    case metadata.after do
      nil ->
        socket
        |> assign(end_of_timeline?: true)
        |> assign(:before, nil)
        |> assign(:cursor, nil)
        |> stream(:social_accounts, entries)

      after_cursor ->
        socket
        |> assign(end_of_timeline?: false)
        |> assign(:before, nil)
        |> assign(:cursor, after_cursor)
        |> stream(:social_accounts, entries)
    end
  end
end
