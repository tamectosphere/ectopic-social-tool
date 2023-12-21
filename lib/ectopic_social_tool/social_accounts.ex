defmodule EctopicSocialTool.SocialAccounts do
  alias EctopicSocialTool.Repo
  alias EctopicSocialTool.SocialAccounts.SocialAccount
  alias EctopicSocialTool.SocialAccounts.OauthProvider

  @default_expires_in 5_183_999

  def get_social_accounts_cursor(user_id) do
    query = SocialAccount |> SocialAccount.get_social_account_cursor_query(user_id)

    Repo.paginate(
      query,
      include_total_count: true,
      cursor_fields: [:id],
      limit: 5
    )
  end

  def get_social_accounts_cursor(user_id, cursor, :after) do
    query = SocialAccount |> SocialAccount.get_social_account_cursor_query(user_id)

    Repo.paginate(
      query,
      after: cursor,
      include_total_count: true,
      cursor_fields: [:id],
      limit: 5
    )
  end

  def get_social_accounts_cursor(user_id, cursor, :before) do
    query = SocialAccount |> SocialAccount.get_social_account_cursor_query(user_id)

    Repo.paginate(
      query,
      before: cursor,
      include_total_count: true,
      cursor_fields: [:id],
      limit: 5
    )
  end

  def unlink(social_account_id, user_id) do
    social_account_id = String.to_integer(social_account_id)

    with current_social_account <- get_social_account_by_id(social_account_id),
         {:ok, true} <- social_account_exists?(current_social_account),
         {:ok, true} <- belong_to_user?(current_social_account.user_id, user_id) do
      case current_social_account
           |> Ecto.Changeset.change(%{user_id: nil})
           |> Repo.update() do
        {:ok, social_account} ->
          {:ok, social_account}

        {:error, _} ->
          {:error, "Unprocessable Entity"}
      end
    end
  end

  defp social_account_exists?(nil) do
    {:error, "Social account not found"}
  end

  defp social_account_exists?(_) do
    {:ok, true}
  end

  defp belong_to_user?(social_account_user_id, user_id) do
    case social_account_user_id == user_id do
      true ->
        {:ok, true}

      false ->
        {:error, "Social account is not belonged to user"}
    end
  end

  def connect_social_account_to_user(provider, user_id, %{user: _, token: _} = result) do
    with current_provider <- valid_provider?(provider),
         current_social_account <- get_social_account(current_provider, provider, result),
         {:ok, status} <- get_social_account_state(current_social_account, user_id),
         social_account_params <-
           build_social_account_params(user_id, current_provider, provider, result),
         changeset <- SocialAccount.changeset(%SocialAccount{}, social_account_params) do
      case status do
        :new ->
          upsert_social_account(changeset, current_social_account, status)

        :exist ->
          upsert_social_account(social_account_params, current_social_account, status)
      end
    end
  end

  defp valid_provider?(provider) when is_binary(provider) do
    case get_oauth_provider(provider) do
      nil ->
        {:error, "Provider not found"}

      provider ->
        provider
    end
  end

  defp get_oauth_provider(provider) when is_binary(provider) do
    OauthProvider.get_oauth_provider_query(OauthProvider,
      name: provider
    )
    |> Repo.one()
  end

  defp get_social_account(current_provider, provider, result) do
    SocialAccount.get_social_account_query(
      SocialAccount,
      [
        oauth_provider_id: current_provider.id,
        social_account_id: get_social_account_id(provider, result.user)
      ],
      nil,
      []
    )
    |> Repo.one()
  end

  defp get_social_account_state(social_account, user_id) do
    cond do
      is_nil(social_account) ->
        {:ok, :new}

      !is_nil(social_account) && is_nil(social_account.user_id) ->
        {:ok, :exist}

      !is_nil(social_account) &&
        !is_nil(social_account.user_id) && social_account.user_id == user_id ->
        {:error, "Already connected to your account"}

      true ->
        {:error, "Already connected to other account"}
    end
  end

  defp build_social_account_params(user_id, current_provider, provider, result) do
    %{
      social_account_id: get_social_account_id(provider, result.user),
      title: get_social_account_title(provider, result.user),
      type: "personal",
      access_token: result.token["access_token"],
      refresh_token: result.token["refresh_token"],
      token_expired_at: result.token["expires_in"] |> get_token_expired_at(),
      metadata: result,
      user_id: user_id,
      oauth_provider_id: current_provider.id
    }
  end

  defp get_social_account_id(provider, user) do
    case provider do
      "linkedin" ->
        user["sub"]
    end
  end

  defp get_social_account_title(provider, user) do
    case provider do
      "linkedin" ->
        user["name"]
    end
  end

  defp get_token_expired_at(expires_in) when is_integer(expires_in) do
    DateTime.utc_now()
    |> DateTime.add(expires_in, :second)
    |> DateTime.truncate(:second)
  end

  defp get_token_expired_at(nil) do
    DateTime.utc_now()
    |> DateTime.add(@default_expires_in, :second)
    |> DateTime.truncate(:second)
  end

  defp upsert_social_account(changeset, _, :new) do
    case Repo.insert(changeset) do
      {:ok, social_account} ->
        {:ok, social_account}

      {:error, changeset} ->
        {:error, "Unprocessable Entity"}
    end
  end

  defp upsert_social_account(changeset, current_social_account, :exist) do
    updated_social_account =
      Ecto.Changeset.change(
        current_social_account,
        changeset
      )

    case Repo.update(updated_social_account) do
      {:ok, social_account} ->
        {:ok, social_account}

      {:error, _} ->
        {:error, "Unprocessable Entity"}
    end
  end

  defp get_social_account_by_id(social_account_id) do
    SocialAccount.get_social_account_query(
      SocialAccount,
      [
        id: social_account_id
      ],
      [:id, :user_id],
      []
    )
    |> Repo.one()
  end
end
