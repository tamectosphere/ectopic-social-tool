defmodule EctopicSocialToolWeb.SocialChannelsLive.Index do
  use EctopicSocialToolWeb, :live_view
  alias EctopicSocialTool.OauthProviders
  alias EctopicSocialTool.SocialAccounts

  def mount(_, _, socket) do
    {:ok,
     socket
     |> paginate_oauth_providers(:init)
     |> paginate_social_accounts(:init)}
  end

  defp paginate_oauth_providers(socket, :init) do
    %{entries: entries, metadata: metadata} = OauthProviders.get_oauth_providers_cursor()

    case metadata.after do
      nil ->
        socket
        |> assign(end_of_oauth_providers_timeline?: true)
        |> assign(:cursor, nil)
        |> stream(:oauth_providers, entries)

      after_cursor ->
        socket
        |> assign(end_of_oauth_providers_timeline?: false)
        |> assign(:before, nil)
        |> assign(:cursor, after_cursor)
        |> stream(:oauth_providers, entries)
    end
  end

  def handle_event("after-social-accounts-page", _, socket) do
    {:noreply, paginate_social_accounts(socket, socket.assigns.cursor, :after)}
  end

  def handle_event("unlink", %{"social-account-id" => social_account_id}, socket) do
    case SocialAccounts.unlink(
           social_account_id,
           socket.assigns.current_user.id
         ) do
      {:ok, social_account} ->
        {:noreply, socket |> stream_delete(:social_accounts, social_account)}

      {:error, message} ->
        {:noreply, socket |> put_flash(:error, message)}
    end
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
