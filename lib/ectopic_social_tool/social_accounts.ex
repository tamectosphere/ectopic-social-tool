defmodule EctopicSocialTool.SocialAccounts do
  alias EctopicSocialTool.Repo
  alias EctopicSocialTool.SocialAccounts.SocialAccount
  alias EctopicSocialTool.SocialAccounts.OauthProvider

  @default_expires_in 5_183_999

  def connect_social_account_to_user(provider, user_id, %{user: _, token: _} = result) do
    with current_provider <- valid_provider?(provider),
         current_social_account <- get_social_account(current_provider, provider, result),
         {:ok, status} <- get_social_account_state(current_social_account, user_id),
         social_account_params <-
           build_social_account_params(user_id, current_provider, provider, result),
         changeset <- SocialAccount.changeset(%SocialAccount{}, social_account_params) do
      upsert_social_account(changeset, current_social_account, status)
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
  end

  defp get_token_expired_at(nil) do
    DateTime.utc_now()
    |> DateTime.add(@default_expires_in, :second)
  end

  defp upsert_social_account(changeset, _, :new) do
    case Repo.insert(changeset) do
      {:ok, social_account} ->
        {:ok, social_account}

      {:error, changeset} ->
        IO.inspect(changeset)
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
end
