defmodule EctopicSocialTool.SocialAccounts.SocialAccount do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false

  schema "social_accounts" do
    field :social_account_id, :string
    field :title, :string
    field :type, :string
    field :access_token, :string
    field :refresh_token, :string
    field :token_expired_at, :utc_datetime
    field :metadata, :map

    belongs_to :user, EctopicSocialTool.Users.User
    belongs_to :oauth_provider, EctopicSocialTool.SocialAccounts.OauthProvider

    timestamps()
  end

  def changeset(social_account, attrs) do
    social_account
    |> cast(attrs, [
      :social_account_id,
      :title,
      :type,
      :access_token,
      :refresh_token,
      :token_expired_at,
      :metadata,
      :user_id,
      :oauth_provider_id
    ])
    |> validate_required([
      :social_account_id,
      :title,
      :type,
      :access_token,
      :token_expired_at,
      :metadata,
      :oauth_provider_id
    ])
  end

  def get_social_account_query(query, where, select \\ nil, preload \\ []) do
    query
    |> apply_where(where)
    |> apply_preload(preload)
    |> apply_select(select)
  end

  defp apply_where(query, where) when is_list(where) do
    where(query, ^where)
  end

  defp apply_where(query, _), do: query

  defp apply_preload(query, preload) when is_list(preload) do
    preload(query, ^preload)
  end

  defp apply_preload(query, _), do: query

  defp apply_select(query, select) when is_list(select) do
    select(query, ^select)
  end

  defp apply_select(query, _), do: query
end
