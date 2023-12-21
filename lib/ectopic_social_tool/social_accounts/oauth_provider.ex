defmodule EctopicSocialTool.SocialAccounts.OauthProvider do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false

  schema "oauth_providers" do
    field :name, :string
    field :logo_url, :string
    field :is_active, :boolean, default: true

    has_many :social_accounts, EctopicSocialTool.SocialAccounts.SocialAccount

    timestamps(type: :utc_datetime)
  end

  def changeset(provider, attrs) do
    provider
    |> cast(attrs, [
      :name,
      :logo_url
    ])
    |> validate_required([:name])
  end

  def get_oauth_provider_cursor_query(query) do
    query
    |> where([op], op.is_active == true)
    |> select([op], %{id: op.id, name: op.name})
    |> order_by([op], asc: op.id)
  end

  def get_oauth_provider_query(query, where, select \\ nil, preload \\ []) do
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
