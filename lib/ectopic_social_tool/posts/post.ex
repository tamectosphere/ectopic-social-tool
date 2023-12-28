defmodule EctopicSocialTool.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false

  schema "posts" do
    field :content, :map
    field :type, Ecto.Enum, values: [:now, :scheduled]
    field :status, Ecto.Enum, values: [:pending, :completed, :failed]
    field :result, :map
    field :return_post_id, :string
    field :scheduled_at, :utc_datetime
    field :completed_at, :utc_datetime

    belongs_to :social_account, EctopicSocialTool.SocialAccounts.SocialAccount

    many_to_many :users, EctopicSocialTool.Users.User,
      join_through: EctopicSocialTool.Users.UserPost

    timestamps()
  end

  def changeset(post, attrs, type) do
    post
    |> cast(attrs, [
      :content,
      :type,
      :status,
      :result,
      :return_post_id,
      :scheduled_at,
      :completed_at,
      :social_account_id
    ])
    |> validate_required([
      :content,
      :type,
      :status,
      :social_account_id
    ])
    |> validate_scheduled_at(type)
  end

  defp validate_scheduled_at(changeset, :now) do
    changeset
  end

  defp validate_scheduled_at(changeset, :scheduled) do
    changeset
    |> validate_required([
      :scheduled_at
    ])
  end

  # def get_post_cursor_query(query, user_id) do
  #   query
  #   |> join(:inner, [sa], op in assoc(sa, :oauth_provider))
  #   |> where([sa], sa.user_id == ^user_id)
  #   |> select([sa, op], %{id: sa.id, title: sa.title, provider_name: op.name})
  #   |> order_by([sa], asc: sa.id)
  # end

  def get_post_query(query, where, select \\ nil, preload \\ []) do
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
